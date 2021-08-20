import QtQuick 2.0

Item {
    width: 1920 * appConfig.w_ratio
    height: (1200 - 104) * appConfig.h_ratio

    property string appTitle: ""
    property string image: ""
    AppHeader {
        id: headerItem
        width: parent.width
        anchors.top: parent.top
        height: 70 * appConfig.h_ratio
        title: appTitle
    }
    Image {
        id: settingScr
        anchors.top: headerItem.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height - headerItem.height
        source: image
        fillMode: Image.PreserveAspectFit
    }
}
