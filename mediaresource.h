#ifndef MEDIARESOURCE_H
#define MEDIARESOURCE_H

#include <QObject>
#include<restaccessmanager.h>
#include <QList>
#include <QString>
#include <QtQml/qqml.h>
#include <QtCore/qjsonobject.h>
#include <QtNetwork/qnetworkreply.h>
#include <memory>



class MediaResource : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QJsonObject> data READ data NOTIFY dataUpdated)
    Q_PROPERTY(QString path MEMBER m_path)


    QML_ELEMENT
public:
    explicit MediaResource(QObject* parent = nullptr);
    virtual ~ MediaResource() = default;

    void setAccessManager(std::shared_ptr<RestAccessManager> manager);

    QList<QJsonObject> data() const;

    Q_INVOKABLE void refreshCurrentPage();
    Q_INVOKABLE void update(const QVariantMap& data, QString newName, QString oldName);
    Q_INVOKABLE void add( QVariantMap data, QString name);
    Q_INVOKABLE void remove(QString name);
    Q_INVOKABLE void kickOutSession(QString id);


signals:
    void dataUpdated();


private:
    void refreshRequestFinished(QNetworkReply* reply);
    void getSessionFinished(QNetworkReply* reply);
    QString convertDateTime(QString timeStr);

    std::shared_ptr<RestAccessManager> m_manager;
    QList<QJsonObject> m_data;
    QList<QJsonObject> m_session;
    QString m_path;


};

#endif // MEDIARESOURCE_H
