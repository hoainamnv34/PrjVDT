#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <restaccessmanager.h>
#include <QDebug>
#include "util.h"
#include <QJsonArray>
#include "restservice.h"
#include "mediaresource.h"


#include <QUrl>
#include <QToolButton>
#include <QQuickItem>
#include <QObject>

#include "myclass.h"



int main(int argc, char *argv[])
{
//    QGuiApplication app(argc, argv);
//    QtWebEngineQuick::initialize();



/*
    RestAccessManager* m_manager = new RestAccessManager();
    m_manager->setUrl(QUrl("http://localhost:9997"));


    RestAccessManager::ResponseCallback callback = [](QNetworkReply* reply, bool success) {
        if (success){
//            qDebug() << reply->readAll().toStdString() ;
            std::optional<QJsonObject> json = byteArrayToJsonObject(reply->readAll());
            if(json) {
                QJsonArray data = json->value("items").toArray();
                QList<QJsonObject> m_data;
                for (const auto& entry : std::as_const(data))
                    m_data.append(entry.toObject());

                for(auto x : m_data) {
                    qDebug() << x.value("confName").toString();
                }
//                QJsonArray data = json->value("items");
                qDebug() << "oke nhe: "
//                         << m_data
                         << " ";
            }
        }

    };
*/

    /*
    RestAccessManager::ResponseCallback callback = [](QNetworkReply* reply, bool success) {
        Q_UNUSED(reply);
        if(success) {
            qDebug() << "remove done";
        }
    };

//    QUrlQuery query;
//    query.addQueryItem("page", QString::number(0));
    QVariantMap map;
    m_manager->post(QString("/v2/paths/remove/videodemo"), map, callback);
//    m_manager->get(QString("/v2/paths/list"), query, callback);


*/
//    QQmlApplicationEngine engine;
//    const QUrl url(u"qrc:/Project/Main.qml"_qs);
//    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
//        &app, []() { QCoreApplication::exit(-1); },
//        Qt::QueuedConnection);
//    engine.load(url);

//    return app.exec();


    QCoreApplication::setOrganizationName("QtExamples");
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);


    QGuiApplication app(argc, argv);

    qmlRegisterType<RestService>("project.RestService", 1, 0, "RestService");
    qmlRegisterType<MediaResource>("project.MediaResource", 1, 0, "MediaResource");



    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));

//    QToolButton *mybutton = engine.findChild<QToolButton*>("viewBtn");
//    MyClass myClass;
//    QObject::connect(mybutton, SIGNAL(mySignal(link)),
//                   &myClass, SLOT(cppSlot(link)));



    return app.exec();



}
