//import QtQuick
//import QtWebEngine


//Window {
////    property alias link: webView.url;
//    width: 1024
//    height: 750
//    visible: true
//    WebEngineView {
//        id: webView
//        anchors.fill: parent
//        url: "http://127.0.0.1:8889/myvideo/"
//    }




//}

import QtQuick 2.15
import QtMultimedia 5.15

//import QtQuick.Controls 2.15
////import QtMultimedia 5.15

Window {
    width: 800
    height: 600
    color: "black"

    MediaPlayer {
        id: player
        source: "file://video.webm"
        autoPlay: true
    }

    VideoOutput {
        id: videoOutput
        source: player
        anchors.fill: parent
    }
}
