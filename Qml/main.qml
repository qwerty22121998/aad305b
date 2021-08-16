import QtQuick 2.11
import QtQuick.Window 2.0
import QtQuick.Controls 2.4

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
        initialItem: HomeWidget {}
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
    }
}
