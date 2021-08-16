import QtQuick 2.11
import QtQuick.Window 2.0
import QtQuick.Controls 2.4
import QtMultimedia 5.9


ApplicationWindow {
    id: window
    visible: true
    width: 1920 * appConfig.w_ratio
    height: 1200 * appConfig.h_ratio
    flags: Qt.Window | Qt.FramelessWindowHint

    Image {
        id: background
        anchors.fill: parent
        source: "qrc:/Img/bg_full.png"
    }

    StatusBar {
        id: statusBar
        onBntBackClicked: stackView.pop()
        isShowBackBtn: stackView.depth != 1
    }

    StackView {
        id: stackView
        width: parent.width
        anchors.top: statusBar.bottom
        initialItem: HomeWidget {
            id: home
        }
        onCurrentItemChanged: {
            currentItem.forceActiveFocus()
        }
        pushExit: Transition {
            XAnimator {
                from: 0
                to: -1920 * appConfig.w_ratio
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
        Keys.onPressed: {
            switch (event.key) {
                case Qt.Key_Backspace:
                    if (statusBar.isShowBackBtn === true)
                        statusBar.bntBackClicked()
                    break
                case Qt.Key_Home:
                    while (stackView.depth > 1)
                        stackView.pop()
                    break
                case Qt.Key_PageUp:
                    player.volume += 10
                    break
                case Qt.Key_PageDown:
                    player.volume -= 10
                    break
                case Qt.Key_End:
                    player.mute = !player.mute
                    break
                case Qt.Key_Space:
                    player.state == MediaPlayer.PlayingState ? player.pause() : player.play()
                    break
                default:
                    home.keyboardPress(event)
            }
        }
    }


}
