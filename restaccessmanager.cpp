#include "restaccessmanager.h"




using namespace Qt::StringLiterals;

static constexpr auto contentTypeJson = "application/json";
static const auto authorizationToken = "TOKEN"_ba;

static bool httpResponseSuccess(QNetworkReply* reply) {
    const int httpStatusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    const bool isReplyError = (reply->error() != QNetworkReply::NoError);

    qDebug() << "request to path" << reply->request().url().path() << "finished";
    if(isReplyError) {
        qDebug() << "Error" << reply->error();
    }else {
        qDebug() << "Http:" << httpStatusCode;
    }
    return (!isReplyError && (httpStatusCode >= 200 && httpStatusCode < 300));
}



RestAccessManager:: RestAccessManager(QObject *parent)
    : QNetworkAccessManager{parent}{

}

void RestAccessManager:: setUrl(const QUrl& url) {
    m_url = url;
}

void RestAccessManager:: setAuthorizationToken(const QByteArray& token) {
    m_authorizationToken = token;
}

bool RestAccessManager::sslSupported() const
{
#if QT_CONFIG(ssl)
    return QSslSocket::supportsSsl();
#else
    return false;
#endif
}

void RestAccessManager::post(const QString& api, const QVariantMap& value,
                             ResponseCallback callback)
{
//    qDebug() << QJsonDocument::fromVariant(value).toJson(QJsonDocument::Compact);
    m_url.setPath(api);
    auto request = QNetworkRequest(m_url);
    request.setHeader(QNetworkRequest::KnownHeaders::ContentTypeHeader, contentTypeJson);
    QNetworkReply* reply = QNetworkAccessManager::post(request,
                                            QJsonDocument::fromVariant(value).toJson(QJsonDocument::Compact));


    QObject::connect(reply, &QNetworkReply::finished, reply, [reply, callback](){
        callback(reply, httpResponseSuccess(reply));
    });
}

void RestAccessManager::postt(const QString& api, const QByteArray& value,
                             ResponseCallback callback)
{
    //    qDebug() << QJsonDocument::fromVariant(value).toJson(QJsonDocument::Compact);
    m_url.setPath(api);
    auto request = QNetworkRequest(m_url);
    request.setHeader(QNetworkRequest::KnownHeaders::ContentTypeHeader, contentTypeJson);
    QNetworkReply* reply = QNetworkAccessManager::post(request,value);


    QObject::connect(reply, &QNetworkReply::finished, reply, [reply, callback](){
        callback(reply, httpResponseSuccess(reply));
    });
}

void RestAccessManager:: get(const QString& api, const QUrlQuery& parameters,
                            ResponseCallback callback) {
    m_url.setPath(api);
    m_url.setQuery(parameters);
    QNetworkRequest request = QNetworkRequest(m_url);

    QNetworkReply* reply = QNetworkAccessManager::get(request);
    QObject::connect(reply, &QNetworkReply::finished, [reply, callback]() {
        callback(reply, httpResponseSuccess(reply));
    });
}
void RestAccessManager:: put(const QString& api, const QVariantMap& value,
                            ResponseCallback callback) {
    m_url.setPath(api);
    QNetworkRequest request = QNetworkRequest(m_url);
    request.setHeader(QNetworkRequest::KnownHeaders::ContentTypeHeader, contentTypeJson);
//    request.setRawHeader(authorizationToken, m_authorizationToken);
    QNetworkReply* reply = QNetworkAccessManager::put(request,
                                                      QJsonDocument::fromVariant(value).toJson(QJsonDocument::Compact));
    QObject::connect(reply, &QNetworkReply::finished, reply, [reply, callback](){
        callback(reply, httpResponseSuccess((reply)));
    });
}
void RestAccessManager::deleteResource(const QString& api, ResponseCallback callback)
{
    m_url.setPath(api);
    auto request = QNetworkRequest(m_url);
//    request.setRawHeader(authorizationToken, m_authorizationToken);
    QNetworkReply* reply = QNetworkAccessManager::deleteResource(request);
    QObject::connect(reply, &QNetworkReply::finished, reply, [reply, callback](){
        callback(reply, httpResponseSuccess(reply));
    });
}
