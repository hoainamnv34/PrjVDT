
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


    //edit or add a path to the server
    MyPopup {
        id: editPopup
        width: 400;
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        property bool isAdd: true;

        function createNewVideo() {
            isAdd = true;
            videoNameField.text = "example"
            videoLinkField.text = "rtsp://example"
            privateCheckBox.checked = false;
            videoUserField.text = "";
            videoPassField.text = "";
            open()
        }

        property string oldName: ""

        function updateVideo(data) {
            isAdd = false;
            videoNameField.text = data.name
            videoLinkField.text = data.conf.source
            oldName = data.name
            if(data.conf.readUser !== "") {
                privateCheckBox.checked = true;
                videoUserField.text = data.conf.readUser;
                videoPassField.text = data.conf.readPass;
            }else {
                privateCheckBox.checked = false;
                videoUserField.text = "";
                videoPassField.text = "";

            }
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



            CheckBox {
                id: privateCheckBox
                text: qsTr("Private")
                checked: false
                onCheckStateChanged: function() {
                    if (checkState == Qt.Checked) {
                        privateLayout.visible = true;
                        editPopup.height = 250;
                    }else {
                        privateLayout.visible = false;
                        editPopup.height = 150;
                    }
                }
            }

            RowLayout {
                id: privateLayout
                visible: false
                ColumnLayout {
                    Label {
                        text: qsTr("User");
                        Layout.fillWidth: true
                    }
                    TextField {
                        id: videoUserField;
                        Layout.fillWidth: true
                        padding: 10
                    }
                }

                ColumnLayout {
                    Label{
                        text: qsTr("Password")
                        Layout.fillWidth: true

                    }

                    TextField{
                        id: videoPassField;
                        Layout.fillWidth: true
                        padding: 10;
                        echoMode: TextInput.Password
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
                    id: okBtn
                    text: editPopup.isAdd ? qsTr("Add") : qsTr("Update")
                    property var data;

                    onClicked: {
                        if (privateCheckBox.checkState == Qt.Checked) {
                            okBtn.data =  { "source" : videoLinkField.text,
                                            "readUser" : videoUserField.text,
                                            "readPass" : videoPassField.text,
                                            }
                        }else {
                            okBtn.data = {"source" : videoLinkField.text,}
                        }

                        if(editPopup.isAdd) {

                            media.add(okBtn.data, videoNameField.text);
                        }else {

                            media.update(okBtn.data, videoNameField.text, editPopup.oldName);
                        }
                        editPopup.close();
                    }

                }
                Item {width: 20}
            }
        }

    }


    //View and kick the WebRTC session
    MyPopup {
        id: viewerPopup
        width: 540
        height: 300
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        property var viewerModel;

        function openViewerModel(model) {
            viewerModel = model;
            viewerPopup.open();
        }

        ColumnLayout {
            anchors.fill: parent

            ListView{
                model:viewerPopup.viewerModel
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: 10;

                delegate: RowLayout{
                    id: viewerDelegate;
                    required property var modelData

                    spacing: 15
                    height: 40
                    MyLabel {
                        font.pixelSize: 15
                        Layout.preferredWidth: 300
                        Layout.fillHeight: true
                        text: viewerDelegate.modelData.id
                        color: "black"
                    }

                    MyLabel {
                        font.pixelSize: 15
                        Layout.preferredWidth: 150
                        Layout.fillHeight: true
                        text: viewerDelegate.modelData.created
                        color: "black"
                    }
                    ToolButton {
                        icon.source: "qrc:/img/icons/kick.png"
                        onClicked: function () {
                            media.kickOutSession(viewerDelegate.modelData.id);
                            viewerDelegate.visible = false;
                            media.refreshCurrentPage();
                        }
                    }

                }
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

                //add
                MyToolButton {
                    icon.source: "qrc:/img/icons/add.png"
                    onClicked: editPopup.createNewVideo()
                }

                //logout
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
                                   onClicked: {
                                       restService.playMedia(nameDelegate.modelData.name);
                                       media.refreshCurrentPage();
                                   }
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

                                //show viewer
                                ToolButton {
                                   icon.source: "qrc:/img/icons/viewer.png"
                                   onClicked: function() {
                                       viewerPopup.openViewerModel(nameDelegate.modelData.readers);
                                       media.refreshCurrentPage();
                                   }
                                }

                            }


                        }
                    }
                }
            }
        }
    }


}
