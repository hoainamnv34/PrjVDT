#include "util.h"
#include <QtCore/qjsondocument.h>

std::optional<QJsonObject> byteArrayToJsonObject(const QByteArray& data)
{
    QJsonParseError parseError;
    const auto json = QJsonDocument::fromJson(data, &parseError);

    if (parseError.error) {
        qDebug() << "Response data not JSON:" << parseError.errorString()
                 << "at" << parseError.offset << data;
    }
    return json.isObject() ? json.object() : std::optional<QJsonObject>(std::nullopt);
}

QByteArray JsonObjectToByteArray(const QJsonObject& jsonObject)
{
    // Create a QJsonDocument from the QJsonObject
    QJsonDocument jsonDoc(jsonObject);

    // Convert the QJsonDocument to a QByteArray
    QByteArray byteArray = jsonDoc.toJson();

    return byteArray;
}
