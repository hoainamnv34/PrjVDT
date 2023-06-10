#ifndef RESTSERVICE_H
#define RESTSERVICE_H

#include<mediaresource.h>

#include <QtQml/qqml.h>
#include <QtQml/qqmlparserstatus.h>
#include <QtNetwork/qnetworkaccessmanager.h>
#include <QtNetwork/qnetworkreply.h>
#include <QtCore/qobject.h>
#include <QtCore/qstring.h>
#include <QtCore/qjsonobject.h>
#include <QQmlListProperty>
#include <QDesktopServices>


class RestAccessManager;

class RestService : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_PROPERTY(RestAccessManager* network READ network CONSTANT)
    Q_PROPERTY(QUrl url READ url WRITE setUrl NOTIFY urlChanged)
    Q_CLASSINFO("DefaultProperty", "resources")
    Q_INTERFACES(QQmlParserStatus)
    Q_PROPERTY(QQmlListProperty<MediaResource> resources READ resources CONSTANT)
    QML_ELEMENT
public:
    explicit RestService(QObject* parent = nullptr);
    ~RestService() override = default;

    RestAccessManager *network() const;

    QUrl url() const;
    void setUrl(const QUrl& url);

    void classBegin() override;
    void componentComplete() override;
    Q_INVOKABLE void playMedia(QString url);

    QQmlListProperty<MediaResource> resources();


signals:
    void urlChanged();

private:
    QUrl m_url;
    QList<MediaResource*> m_resources;
    std::shared_ptr<RestAccessManager> m_manager;
};

#endif // RESTSERVICE_H
