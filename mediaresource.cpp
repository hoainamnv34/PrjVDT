#include "mediaresource.h"
#include "util.h"
#include "restaccessmanager.h"
#include <QtNetwork/qnetworkreply.h>
#include <QtCore/qurlquery.h>
#include <QtCore/qjsonobject.h>
#include <QtCore/qjsonarray.h>
#include <QDebug>

#include <QMetaType>

static  QString currentPageField = "/paths/list";
static  QString addEndpoint = "/config/paths/add/";
static  QString resourceIdentification = "/get";


MediaResource::MediaResource(QObject *parent) : QObject(parent)
{

}

void MediaResource::setAccessManager(std::shared_ptr<RestAccessManager> manager)
{
    m_manager = manager;
}

QList<QJsonObject> MediaResource::data() const
{
    return m_data;
}



void MediaResource::update(const QVariantMap &data, QString newName, QString oldName)
{
    if(newName == oldName) {
        RestAccessManager::ResponseCallback callback = [this](QNetworkReply* reply, bool success){
            Q_UNUSED(reply);
            if(success){
                refreshCurrentPage();
                qDebug() << "update done";
            };
        };

        m_manager.get()->post(m_path + "/config/paths/edit/" + oldName, data, callback);
    }else {
        remove(oldName);
        add(data, newName);
    }

}

void MediaResource::add(QVariantMap data, QString name)
{
    data.insert("sourceOnDemandStartTimeout", "10s");
    data.insert("sourceOnDemandCloseAfter", "10s");
    RestAccessManager::ResponseCallback callback = [this](QNetworkReply* reply, bool success) {
        Q_UNUSED(reply);
        if(success) {
            refreshCurrentPage();
            qDebug() << "add done";
        }
    };

    m_manager.get()->post(m_path + "/config/paths/add/" + name, data, callback);
}

void MediaResource::remove(QString name)
{
    RestAccessManager::ResponseCallback callback = [this](QNetworkReply* reply, bool success) {
        Q_UNUSED(reply);
        if(success) {
            refreshCurrentPage();
            qDebug() << "remove done";
        }
    };
    m_manager.get()->post(m_path + "/config/paths/remove/" + name, {} , callback);
}


void MediaResource::refreshCurrentPage()
{
    RestAccessManager::ResponseCallback callback = [this](QNetworkReply* reply, bool success) {
        if(success) {
            refreshRequestFinished(reply);
            qDebug() << "refresh Done";
        }
    };

    QUrlQuery query;
        query.addQueryItem("page", QString::number(0));
    m_manager.get()->get(m_path + currentPageField, query, callback);

}

void MediaResource::refreshRequestFinished(QNetworkReply *reply)
{
    m_data.clear();
    std::optional<QJsonObject> json = byteArrayToJsonObject(reply->readAll());
    if(json) {
        QJsonArray data = json->value("items").toArray();

        for (const auto& entry : std::as_const(data))
            m_data.append(entry.toObject());

    }
//    qDebug() << m_data;
    emit dataUpdated();
}




