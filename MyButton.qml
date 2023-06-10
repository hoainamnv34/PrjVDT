import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Button {
    height: 30;
    width: 50;

    contentItem: Text {
        text: parent.text
        font: parent.font
        opacity: enabled ? 1.0 : 0.3
        color: mainWin.textCL;
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: parent.width;
        implicitHeight: parent.height
        color: parent.hovered ?  mainWin.horveredCL : mainWin.btnCL
        radius: 1

    }
    MouseArea{
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed:  parent.clicked();
    }
}
