import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.1
import QtMultimedia 5.9

Item {
    Text {
        id: audioTitle
        anchors.top: parent.top
        anchors.topMargin: 20 * appConfig.h_ratio
        anchors.left: parent.left
        anchors.leftMargin: 20 * appConfig.w_ratio
        text: album_art_view.currentItem.myData.title
        color: "white"
        font.pixelSize: 36 * appConfig.h_ratio
        onTextChanged: {
            textChangeAni.targets = [audioTitle, audioSinger]
            textChangeAni.restart()
        }
    }
    Text {
        id: audioSinger
        anchors.top: audioTitle.bottom
        anchors.left: audioTitle.left
        text: album_art_view.currentItem.myData.singer
        color: "white"
        font.pixelSize: 32 * appConfig.h_ratio
    }

    NumberAnimation {
        id: textChangeAni
        property: "opacity"
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.InOutQuad
    }
    Text {
        id: audioCount
        anchors.top: parent.top
        anchors.topMargin: 20 * appConfig.h_ratio
        anchors.right: parent.right
        anchors.rightMargin: 20 * appConfig.w_ratio
        text: album_art_view.count
        color: "white"
        font.pixelSize: 36 * appConfig.h_ratio
    }
    Image {
        anchors.top: parent.top
        anchors.topMargin: 23 * appConfig.h_ratio
        anchors.right: audioCount.left
        anchors.rightMargin: 10 * appConfig.w_ratio
        source: "qrc:/App/Media/Image/music.png"
    }

    Component {
        id: appDelegate
        Item {
            property variant myData: model
            width: 400 * appConfig.w_ratio
            height: 400 * appConfig.h_ratio
            scale: PathView.iconScale
            Image {
                id: myIcon
                width: parent.width
                height: parent.height
                y: 20 * appConfig.h_ratio
                anchors.horizontalCenter: parent.horizontalCenter
                source: album_art
            }

            MouseArea {
                anchors.fill: parent
                onClicked: album_art_view.currentIndex = index
            }
        }
    }

    PathView {
        id: album_art_view
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - 1100 * appConfig.w_ratio) / 2
        anchors.top: parent.top
        anchors.topMargin: 300 * appConfig.h_ratio
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        focus: true
        model: myModel
        delegate: appDelegate
        pathItemCount: 3
        path: Path {
            startX: 10 * appConfig.w_ratio
            startY: 50 * appConfig.w_ratio
            PathAttribute {
                name: "iconScale"
                value: 0.5
            }
            PathLine {
                x: 550 * appConfig.w_ratio
                y: 50 * appConfig.h_ratio
            }
            PathAttribute {
                name: "iconScale"
                value: 1.0
            }
            PathLine {
                x: 1100 * appConfig.w_ratio
                y: 50 * appConfig.h_ratio
            }
            PathAttribute {
                name: "iconScale"
                value: 0.5
            }
        }
        currentIndex: player.playlist.currentIndex
        onCurrentIndexChanged: {
            if (currentIndex != player.playlist.currentIndex) {
                player.playlist.currentIndex = currentIndex
            }
        }
    }
    //Progress
    Text {
        id: currentTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 250 * appConfig.h_ratio
        anchors.right: progressBar.left
        anchors.rightMargin: 20 * appConfig.w_ratio
        text: utility.getTimeInfo(player.position)
        color: "white"
        font.pixelSize: 24 * appConfig.h_ratio
    }
    Slider {
        id: progressBar
        width: (1400 - 675 * playlist.position) * appConfig.w_ratio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 245 * appConfig.h_ratio
        anchors.horizontalCenter: parent.horizontalCenter
        from: 0
        to: player.duration
        value: player.position
        background: Rectangle {
            x: progressBar.leftPadding
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            implicitWidth: 200 * appConfig.w_ratio
            implicitHeight: 4 * appConfig.h_ratio
            width: progressBar.availableWidth
            height: implicitHeight
            radius: 2
            color: "gray"

            Rectangle {
                width: progressBar.visualPosition * parent.width
                height: parent.height
                color: "white"
                radius: 2
            }
        }
        handle: Image {
            anchors.verticalCenter: parent.verticalCenter
            x: progressBar.leftPadding + progressBar.visualPosition
               * (progressBar.availableWidth - width)
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            source: "qrc:/App/Media/Image/point.png"
            Image {
                anchors.centerIn: parent
                source: "qrc:/App/Media/Image/center_point.png"
            }
        }
        onMoved: {
            if (player.seekable) {
                player.setPosition(Math.floor(position * player.duration))
            }
        }
    }
    Text {
        id: totalTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 250 * appConfig.h_ratio
        anchors.left: progressBar.right
        anchors.leftMargin: 20 * appConfig.w_ratio
        text: utility.getTimeInfo(player.duration)
        color: "white"
        font.pixelSize: 24 * appConfig.h_ratio
    }
    //Media control
    SwitchButton {
        id: shuffer
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120 * appConfig.h_ratio
        anchors.left: currentTime.left
        icon_off: "qrc:/App/Media/Image/shuffle.png"
        icon_on: "qrc:/App/Media/Image/shuffle-1.png"
        status: player.playlist.playbackMode === Playlist.Random ? 1 : 0
        onClicked: {
            console.log(player.playlist.playbackMode)
            if (player.playlist.playbackMode === Playlist.Random) {
                player.playlist.playbackMode = Playlist.Sequential
            } else {
                player.playlist.playbackMode = Playlist.Random
            }
        }
    }
    ButtonControl {
        id: prev
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120 * appConfig.h_ratio
        anchors.right: play.left
        icon_default: "qrc:/App/Media/Image/prev.png"
        icon_pressed: "qrc:/App/Media/Image/hold-prev.png"
        icon_released: "qrc:/App/Media/Image/prev.png"
        onClicked: {
            player.playlist.previous()
        }
    }
    ButtonControl {
        id: play
        anchors.verticalCenter: prev.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        icon_default: player.state == MediaPlayer.PlayingState ? "qrc:/App/Media/Image/pause.png" : "qrc:/App/Media/Image/play.png"
        icon_pressed: player.state == MediaPlayer.PlayingState ? "qrc:/App/Media/Image/hold-pause.png" : "qrc:/App/Media/Image/hold-play.png"
        icon_released: player.state == MediaPlayer.PlayingState ? "qrc:/App/Media/Image/pause.png" : "qrc:/App/Media/Image/play.png"
        onClicked: {
            if (player.state != MediaPlayer.PlayingState) {
                player.play()
            } else {
                player.pause()
            }
        }
        Connections {
            target: player
            function onStateChanged() {
                play.source = player.state == MediaPlayer.PlayingState ? "qrc:/App/Media/Image/pause.png" : "qrc:/App/Media/Image/play.png"
            }
        }
    }
    ButtonControl {
        id: next
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120 * appConfig.h_ratio
        anchors.left: play.right
        icon_default: "qrc:/App/Media/Image/next.png"
        icon_pressed: "qrc:/App/Media/Image/hold-next.png"
        icon_released: "qrc:/App/Media/Image/next.png"
        onClicked: {
            player.playlist.next()
        }
    }
    SwitchButton {
        id: repeater
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120 * appConfig.h_ratio
        anchors.right: totalTime.right
        icon_on: "qrc:/App/Media/Image/repeat1_hold.png"
        icon_off: "qrc:/App/Media/Image/repeat.png"
        status: player.playlist.playbackMode === Playlist.Loop ? 1 : 0
        onClicked: {
            console.log(player.playlist.playbackMode)
            if (player.playlist.playbackMode === Playlist.Loop) {
                player.playlist.playbackMode = Playlist.Sequential
            } else {
                player.playlist.playbackMode = Playlist.Loop
            }
        }
    }

    Connections {
        target: player.playlist
        function onCurrentIndexChanged() {
            album_art_view.currentIndex = index
        }
    }
}
