import QtQuick 2.12
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQml.Models 2.1
import QtQml 2.3

Item {
    id: root
    width: parent.width
    height: parent.height
    function openApplication(url, prop) {
        parent.push(url, prop)
    }

    property var focusingItem 
    property bool focusWidget: true
    property int focusIdx: 0

    signal triggerHardKey(bool open)

    function focus(item) {
        if (focusingItem != undefined) {
            focusingItem.focus = false
        }
        focusingItem = item
        focusingItem.focus = true
    }

    function checkFocus(item, isWidget, open) {
        if (isWidget != focusWidget) return false
        if (item.parent.visualIndex != focusIdx) return false
        focus(item)
        if (open) item.click()
        return true
    }

    function keyboardPress(event) {
        console.log("key pressed", event.key)
        let open = false
        switch (event.key) {
            case Qt.Key_Up:
            case Qt.Key_Down:
                focusWidget = !focusWidget
                focusIdx = 0
                break
            case Qt.Key_Left:
                focusIdx--
                break
            case Qt.Key_Right:
                focusIdx++
                break
            case Qt.Key_Return:
                open = true
                break
            default:
                return
        }
        if (focusWidget) {
            focusIdx += 3
            focusIdx %= 3
        } else {
            if (appsModel.rowCount() > 0) {
                focusIdx += appsModel.rowCount()
                focusIdx %= appsModel.rowCount()
            }
        }
        console.log("focus widget", focusWidget, "focus id", focusIdx)
        triggerHardKey(open)
    }

    ListView {
        id: lvWidget
        spacing: 10 * appConfig.w_ratio
        orientation: ListView.Horizontal
        width: 1920 * appConfig.w_ratio
        height: 570 * appConfig.h_ratio
        interactive: false

        displaced: Transition {
            NumberAnimation {
                properties: "x,y"
                easing.type: Easing.OutQuad
            }
        }

        model: DelegateModel {
            id: visualModelWidget
            model: ListModel {
                id: widgetModel
                ListElement {
                    type: "map"
                }
                ListElement {
                    type: "climate"
                }
                ListElement {
                    type: "media"
                }
            }

            delegate: DropArea {
                id: delegateRootWidget
                width: 635 * appConfig.w_ratio
                height: 570 * appConfig.h_ratio
                keys: ["widget"]

                onEntered: {
                    visualModelWidget.items.move(drag.source.visualIndex,
                        iconWidget.visualIndex)
                    iconWidget.item.enabled = false
                }
                property int visualIndex: DelegateModel.itemsIndex
                Binding {
                    target: iconWidget
                    property: "visualIndex"
                    value: visualIndex
                }
                onExited: iconWidget.item.enabled = true
                onDropped: {
                    console.log(drop.source.visualIndex)
                }

                Loader {
                    id: iconWidget
                    property int visualIndex: 0
                    width: 635 * appConfig.w_ratio
                    height: 570 * appConfig.h_ratio
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }

                    sourceComponent: {
                        switch (model.type) {
                            case "map":
                                return mapWidget
                            case "climate":
                                return climateWidget
                            case "media":
                                return mediaWidget
                        }
                    }

                    Drag.active: iconWidget.item.drag.active
                    Drag.keys: "widget"
                    Drag.hotSpot.x: delegateRootWidget.width / 2
                    Drag.hotSpot.y: delegateRootWidget.height / 2

                    states: [
                        State {
                            when: iconWidget.Drag.active
                            ParentChange {
                                target: iconWidget
                                parent: root
                            }

                            AnchorChanges {
                                target: iconWidget
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }
            }
        }

        Component {
            id: mapWidget
            MapWidget {
                id: mapItem
                onClicked: openApplication("qrc:/App/Map/Map.qml")
                function onTriggerHardKey(open) {
                    checkFocus(mapItem, true, open)
                }
                Component.onCompleted: {
                    root.triggerHardKey.connect(onTriggerHardKey)
                }
            }
        }
        Component {
            id: climateWidget
            ClimateWidget {
                id: climateItem
                function onTriggerHardKey(open) {
                    checkFocus(climateItem, true, open)
                }
                Component.onCompleted: {
                    root.triggerHardKey.connect(onTriggerHardKey)
                }
            }
        }
        Component {
            id: mediaWidget
            MediaWidget {
                id: mediaItem
                onClicked: openApplication("qrc:/App/Media/Media.qml")
                function onTriggerHardKey(open) {
                    checkFocus(mediaItem, true, open)
                }
                Component.onCompleted: {
                    root.triggerHardKey.connect(onTriggerHardKey)
                }
            }
        }
    }

    ScrollView {
        id: scrollApps
        x: 0
        y: 570 * appConfig.h_ratio
        width: 1920 * appConfig.w_ratio
        height: 604 * appConfig.h_ratio

        ScrollBar.horizontal: ScrollBar {
            id: sbApps
            anchors.top: lvApps.top
            policy: (lvApps.count > 6) ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
            size: scrollApps.width / lvApps.width
            contentItem: Rectangle {
                implicitWidth: 1920 * appConfig.w_ratio
                implicitHeight: 10 * appConfig.h_ratio
                radius: height / 2
            }
        }

        ListView {
            id: lvApps

            width: 1920 * appConfig.w_ratio
            height: 604 * appConfig.h_ratio
            orientation: ListView.Horizontal
            interactive: sbApps.visible
            spacing: 5 * appConfig.w_ratio

            ScrollBar.horizontal: sbApps

            displaced: Transition {
                NumberAnimation {
                    properties: "x,y"
                    easing.type: Easing.OutQuad
                }
            }

            model: DelegateModel {
                id: visualModel
                model: appsModel
                delegate: DropArea {
                    id: delegateRoot
                    width: 316 * appConfig.w_ratio
                    height: 604 * appConfig.h_ratio
                    keys: "AppButton"

                    onEntered: {
                        visualModel.items.move(drag.source.visualIndex,
                            icon.visualIndex)
                        appsModel.move(drag.source.visualIndex,
                            icon.visualIndex)
                        xmlWriter.saveXml()
                    }

                    property int visualIndex: DelegateModel.itemsIndex
                    Binding {
                        target: icon
                        property: "visualIndex"
                        value: visualIndex
                    }

                    Item {
                        id: icon
                        property int visualIndex: 0
                        width: 316 * appConfig.w_ratio
                        height: 604 * appConfig.h_ratio
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter: parent.verticalCenter
                        }

                        AppButton {
                            id: app
                            anchors.fill: parent
                            title: model.title
                            icon: model.iconPath
                            onClicked: openApplication(model.url, {
                                "appTitle": model.title,
                                "image": model.iconPath + "_n.png"
                            })
                            drag.axis: Drag.XAndYAxis
                            drag.target: icon



                            onPressAndHold: {

                            }

                            onReleased: {
                                app.focus = true
                                app.state = "Focus"
                                for (var index = 0; index < visualModel.items.count; index++) {
                                    if (index !== icon.visualIndex)
                                        visualModel.items.get(
                                            index).focus = false
                                    else
                                        visualModel.items.get(
                                            index).focus = true
                                }
                            }

                            function onTriggerHardKey(open) {
                                if (root.checkFocus(app, false, open)) {
                                    lvApps.positionViewAtIndex(icon.visualIndex, ListView.Visible)
                                }
                            }

                            Component.onCompleted: {
                                root.triggerHardKey.connect(onTriggerHardKey)
                            }

                            Component.onDestruction: {
                                root.triggerHardKey.disconnect(onTriggerHardKey)
                            }
                        }

                        onFocusChanged: app.focus = icon.focus

                        Drag.active: app.drag.active
                        Drag.hotSpot.x: delegateRoot.width / 2
                        Drag.hotSpot.y: delegateRoot.height / 2
                        Drag.keys: "AppButton"

                        states: [
                            State {
                                when: icon.Drag.active
                                ParentChange {
                                    target: icon
                                    parent: scrollApps
                                }

                                AnchorChanges {
                                    target: icon
                                    anchors.horizontalCenter: undefined
                                    anchors.verticalCenter: undefined
                                }
                            }
                        ]
                    }
                }
            }
        }
    }
}
