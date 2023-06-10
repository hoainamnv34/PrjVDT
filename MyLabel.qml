import QtQuick
import QtQuick.Controls


Label {
    height: 45
    font.pixelSize: 20
    color: "black"

    wrapMode: Text.WordWrap
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    background: Rectangle {
        implicitWidth: parent.width;
        implicitHeight: 45
        color: "#ffffff"
        border.color: "#21be2b"
        radius: 2
    }
}
