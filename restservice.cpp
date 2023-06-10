#include "restservice.h"



RestService::RestService(QObject *parent) : QObject(parent)
{
    m_manager = std::make_shared<RestAccessManager>();

//    MediaResource* a = new MediaResource();
//    a->setName("name");
//    MediaResource* b = new MediaResource();
//    b->setName("nu");
//    m_resources.append(a);
//    m_resources.append(b);

}

RestAccessManager *RestService::network() const
{
    return m_manager.get();
}

QUrl RestService::url() const
{
    return m_url;
}

void RestService::setUrl(const QUrl &url)
{
    if(m_url == url) {
        return;
    }
    m_url = url;
    m_manager.get()->setUrl(url);
    emit urlChanged();
}

void RestService::classBegin()
{

}

void RestService::componentComplete()
{
    for(const auto resource : std::as_const(m_resources)){
        resource->setAccessManager(m_manager);
    }
}

void RestService::playMedia(QString url)
{
    QDesktopServices::openUrl(QUrl((m_url.toString()).replace("9997","8889") + "/"  + url));
}

QQmlListProperty<MediaResource> RestService::resources()
{
    return {this, &m_resources};
}


