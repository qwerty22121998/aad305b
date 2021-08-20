import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.1

Drawer {
    id: drawer
    property alias mediaPlaylist: mediaPlaylist
    interactive: false
    modal: false
    background: Rectangle {
        id: playList_bg
        anchors.fill: parent
        color: "transparent"
    }
    ListView {
        id: mediaPlaylist
        anchors.fill: parent
        model: myModel
        clip: true
        spacing: 2
        currentIndex: player.playlist.currentIndex
        delegate: MouseArea {
            property variant myData: model
            implicitWidth: playlistItem.width
            implicitHeight: playlistItem.height
            Image {
                id: playlistItem
                width: 650 * appConfig.w_ratio
                height: 100 * appConfig.h_ratio
                source: "qrc:/App/Media/Image/playlist.png"
                opacity: 0.5
            }
            Text {
                text: title
                anchors.fill: parent
                anchors.leftMargin: 70 * appConfig.w_ratio
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.pixelSize: 32 * appConfig.h_ratio
            }
            onClicked: {
                player.playlist.currentIndex = index
            }

            onPressed: {
                playlistItem.source = "qrc:/App/Media/Image/hold.png"
            }
            onReleased: {
                playlistItem.source = "qrc:/App/Media/Image/playlist.png"
            }
        }
        highlight: Image {
            source: "qrc:/App/Media/Image/playlist_item.png"
            Image {
                anchors.left: parent.left
                anchors.leftMargin: 15 * appConfig.w_ratio
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/App/Media/Image/playing.png"
            }
        }
        ScrollBar.vertical: ScrollBar {
            parent: mediaPlaylist.parent
            anchors.top: mediaPlaylist.top
            anchors.left: mediaPlaylist.right
            anchors.bottom: mediaPlaylist.bottom
        }
    }

    Connections {
        target: player.playlist
        function onCurrentIndexChanged() {
            mediaPlaylist.currentIndex = index
        }
    }
}
