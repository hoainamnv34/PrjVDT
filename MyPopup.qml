import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml

Popup {
    width: 280;
    height: 150;
    anchors.centerIn: parent
    padding: 10
    modal: true
    focus: true

    onOpened: function () {
        mainContent.opacity = 0.2
    }

    onClosed: function () {
        mainContent.opacity = 1
    }
}
