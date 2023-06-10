import QtQuick
import QtQuick.Controls

ToolButton {
    icon.color: mainWin.textCL;
    width: 30;
    height: 30;
    icon.height: 30;
    icon.width: 30;

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
