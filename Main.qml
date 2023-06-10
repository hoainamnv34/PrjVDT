
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml
import project.RestService
import project.MediaResource


Window {
    id: mainWin
    width: 800
    height: 500
    visible: true
    title: qsTr("MINI-PROJECT")

    property color headerBG: "#16a63c";
    property color btnCL: "#16a63c";
    property color mainBG: "#f2f7f6"
    property color borderCL: "#baafaf";
    property color textCL: "#fcfafa";
    property color horveredCL: "#13782e"

    RestService {
        id: restService
        MediaResource{
            id: media;
            path:  '/v2'

        }
    }

    Component.onCompleted: urlSelectionPopup.open();


    // A popup for selecting the server URL
    MyPopup {
        id: urlSelectionPopup
        closePolicy: Popup.NoAutoClose

        onOpened: function() {
            btnHeader.visible = false
            mainContent.visible = false
        }


        onClosed: function () {
            btnHeader.visible = true
            mainContent.visible = true
        }


        Connections {
            target: media
            // Closes the URL selection popup once we have received data successfully
            function onDataUpdated() {
                fetchTester.stop()
                urlSelectionPopup.close()
            }
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 5


            Label {
                text: qsTr("Select server URL")
                font.pixelSize: 20
                Layout.alignment: Qt.AlignHCenter


            }
            RowLayout {
                id: urlSelectionLayout
                enabled: !fetchTester.running



                TextArea {
                    height: 30;
                    id: url1TextArea
                    // The default URL of the QtHttpServer
                    text: "http://localhost:9997"
                    Layout.minimumWidth: 200
                    Layout.preferredWidth: 200
                    Layout.maximumWidth: 200

                    background: Rectangle {
                            color: "transparent"
                            border.color: mainWin.borderCL
                            border.width: 2
                            radius: 1
                        }

                }

                Item { Layout.fillWidth: true /* spacer */ }

                MyButton {
                    id: useBtn
                    height: 30;
                    width: 50;

                    text: qsTr("Use")
                    onClicked: {
                        fetchTester.test(url1TextArea.text)
                    }
                }
            }


            Label {
                visible: !fetchTester.running
            }

            RowLayout {
                id: fetchIndicator
                visible: fetchTester.running

                Label {
                    text: qsTr("Testing URL")
                }
                BusyIndicator {
                    running: visible
                    Layout.fillWidth: true
                }
            }

            Timer {
                id: fetchTester
                interval: 2000

                function test(url) {
                    restService.url = url
                    media.refreshCurrentPage()
                    start()
                }

            }


        }
    }

    MyPopup {
        id: editPopup
        width: 400;
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        property bool isAdd: true;

        onOpened: function () {
            mainContent.opacity = 0.2
        }

        onClosed: function () {
            mainContent.opacity = 1
        }

        function createNewVideo() {
            isAdd = true;
            videoNameField.text = "example"
            videoLinkField.text = "rtsp://example"
            open()
        }

        property string oldName: ""

        function updateVideo(data) {
            isAdd = false;
            videoNameField.text = data.name
            videoLinkField.text = data.conf.source
            oldName = data.name
            open()
        }

        ColumnLayout {
            anchors.fill: parent

            RowLayout {

                ColumnLayout {
                    width: 60
                    Label {
                        width: 60
                        text: qsTr("Name");
                    }
                    TextField {
                        id: videoNameField;
                        width: 60
                        padding: 10
                    }
                }

                ColumnLayout {
                    Label{
                        text: qsTr("Link")
                        Layout.fillWidth: true
                    }


                    TextField{
                        id: videoLinkField;
                        Layout.fillWidth: true
                        padding: 10;
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Item {width: 20}

                MyButton {
                    text: qsTr("Cancel")
                    onClicked: editPopup.close()
                }

                Item {Layout.fillWidth: true}

                MyButton {
                    text: editPopup.isAdd ? qsTr("Add") : qsTr("Update")

                    onClicked: {
                        if(editPopup.isAdd) {

                            media.add({"source" : videoLinkField.text,}, videoNameField.text);
                        }else {

                            media.update({"source" : videoLinkField.text,}, videoNameField.text, editPopup.oldName);
                        }
                        editPopup.close();
                    }

                }
                Item {width: 20}
            }
        }

    }

    ColumnLayout {
        anchors.fill: parent


        ToolBar {
            Layout.fillWidth: true;
            height: 60
            background: Rectangle {
                        implicitWidth: parent.width;
                        implicitHeight: parent.height
                        color: mainWin.headerBG
                    }

            RowLayout {
                id: btnHeader
                visible: false;
                anchors.fill: parent;

                MyToolButton {
                    icon.source: "qrc:/img/icons/refresh.png"
                    onClicked: media.refreshCurrentPage()

                }

                Item { Layout.fillWidth: true /* spacer */ }

                MyToolButton {
                    icon.source: "qrc:/img/icons/add.png"
                    onClicked: editPopup.createNewVideo()
                }

                MyToolButton {
                    icon.source: "qrc:/img/icons/logout.png"
                    onClicked: urlSelectionPopup.open()

                }
            }

        }

        Pane {
            Layout.fillHeight: true;
            Layout.fillWidth: true;

            background: Rectangle {
                implicitWidth: parent.width;
                implicitHeight: parent.height
                color: mainWin.mainBG
            }

            ColumnLayout {
                id: mainContent
                anchors.fill: parent

                ListView{
                    model: media.data;
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: 10;

                    delegate: RowLayout{
                        id: nameDelegate;
                        required property var modelData

                        spacing: 20
                        height: 45

                            RowLayout {
                                height: parent.height

                                MyLabel {
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 120
                                    text: nameDelegate.modelData.name


                                }
                                MyLabel {
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 450
                                    text: nameDelegate.modelData.conf.source
                                }
                            }

                        Pane{
                            height: 45;

                            background: Rectangle {
                                implicitWidth: parent.width
                                implicitHeight: parent.height;
                                color: "#ffffff"
                                border.color: "#21be2b"
                                radius: 2
                            }


                            RowLayout {
                                height: parent.height

                                //view
                                ToolButton {
                                   id: viewButton
                                   icon.source: "qrc:/img/icons/play.png"
                                   onClicked: restService.playMedia(nameDelegate.modelData.name);
                                }
                                //edit
                                ToolButton {
                                   icon.source: "qrc:/img/icons/edit.png"
                                   onClicked: editPopup.updateVideo(nameDelegate.modelData);
                                }

                                //delete
                                ToolButton {
                                   icon.source: "qrc:/img/icons/delete.png"
                                   onClicked: media.remove(nameDelegate.modelData.name);
                                }

//                                //show viewer
//                                ToolButton {
//                                   icon.source: "qrc:/img/icons/viewer.png"
////                                   onClicked:
//                                }
                            }


                        }
                    }
                }
            }
        }
    }


}
