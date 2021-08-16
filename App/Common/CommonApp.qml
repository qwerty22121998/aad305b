import QtQuick 2.0

Item {
    width: 1920 * appConfig.w_ratio
    height: 1200 * appConfig.h_ratio

    property string appTitle: ""
    property string image: ""
    AppHeader {
        id: headerItem
        width: parent.width
        height: 70 * appConfig.h_ratio
        title: appTitle
    }
    Image {
        id: settingScr
        height: implicitHeight
        width: implicitWidth
        anchors.centerIn: parent
        anchors.top: headerItem.bottom
        source: image
    }
}
