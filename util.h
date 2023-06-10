#ifndef UTIL_H
#define UTIL_H



#include <QtCore/qjsonobject.h>
#include <QByteArray>

std::optional<QJsonObject> byteArrayToJsonObject(const QByteArray& data);

QByteArray JsonObjectToByteArray(const QJsonObject& jsonObject);

#endif // UTIL_H
