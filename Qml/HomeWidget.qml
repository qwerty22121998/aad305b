import QtQuick 2.12
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQml.Models 2.1
import QtQml 2.3

Item {
    id: root
    width: parent.width
    height: parent.height
    function openApplication(url) {
        parent.push(url)
    }

    property var focusingItem
    property var focustModel: [visualModelWidget, visualModel]
    property var focustIndex: [0, 0]
    property int focusSection: 0

    signal triggerHardKey(bool open)

    function setFocus(item, isWidget) {
        if (focusingItem != undefined && focusingItem != item) {
            focusingItem.focus = false
            focusingItem.state = "Normal"
        }
        let section = isWidget ? 0 : 1
        focusingItem = item
        focusSection = section
        focustIndex[section] = item.parent.visualIndex
    }

    function forceFocus(item, isWidget) {
        setFocus(item, isWidget)
        item.focus = true
        item.state = "Focus"
    }

    function triggerFocus(item, isWidget, open) {
        let section = isWidget ? 0 : 1
        if (section != focusSection)
            return false
        if (item.parent.visualIndex != focustIndex[section])
            return false
        forceFocus(item, isWidget)
        if (open)
            item.clicked(null)
        return true
    }

    function keyboardPress(event) {
        let open = false
        let len = focustModel[focusSection].model.rowCount()
        switch (event.key) {
        case Qt.Key_Up:
        case Qt.Key_Down:
            focusSection++
            focusSection %= 2
            break
        case Qt.Key_Left:
            focustIndex[focusSection] += len - 1
            focustIndex[focusSection] %= len
            break
        case Qt.Key_Right:
            focustIndex[focusSection]++
            focustIndex[focusSection] %= len
            break
        case Qt.Key_Return:
            open = true
            break
        default:
            return
        }

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

            delegate: Item {
                id: delegateRootWidget
                width: 635 * appConfig.w_ratio
                height: 570 * appConfig.h_ratio

                property int visualIndex: DelegateModel.itemsIndex
                Binding {
                    target: iconWidget
                    property: "visualIndex"
                    value: visualIndex
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
                }
            }
        }

        Component {
            id: mapWidget
            MapWidget {
                id: mapItem

                onPressed: {
                    root.forceFocus(mapItem, true)
                }

                onReleased: {
                    root.forceFocus(mapItem, true)
                }

                onClicked: {
                    root.forceFocus(mapItem, true)
                    openApplication("qrc:/App/Map/Map.qml")
                }

                function onTriggerHardKey(open) {
                    root.triggerFocus(mapItem, true, open)
                }
                Component.onCompleted: {
                    root.forceFocus(mapItem, true)
                    root.triggerHardKey.connect(onTriggerHardKey)
                }
            }
        }
        Component {
            id: climateWidget
            ClimateWidget {
                id: climateItem

                onPressed: {
                    root.forceFocus(climateItem, true)
                }

                onReleased: {
                    root.forceFocus(climateItem, true)
                }

                function onTriggerHardKey(open) {
                    root.triggerFocus(climateItem, true, open)
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

                onPressed: {
                    root.forceFocus(mediaItem, true)
                }

                onClicked: {
                    root.forceFocus(mediaItem, true)
                    openApplication("qrc:/App/Media/Media.qml")
                }

                onReleased: {
                    root.forceFocus(mediaItem, true)
                }

                function onTriggerHardKey(open) {
                    root.triggerFocus(mediaItem, true, open)
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
                        let from = drag.source.visualIndex
                        let to = icon.visualIndex
                        appsModel.move(from, to)
                        visualModel.items.move(from, to)

                        xmlWriter.saveXml()
                    }

                    onDropped: {

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
                            onClicked: {
                                root.forceFocus(app, false)
                                openApplication(model.url)
                            }
                            drag.axis: Drag.XAndYAxis
                            drag.target: icon

                            onPressed: {
                                root.setFocus(app, false)
                            }

                            onReleased: {
                                root.setFocus(app, false)
                            }

                            function onTriggerHardKey(open) {
                                if (root.triggerFocus(app, false, open)) {
                                    lvApps.positionViewAtIndex(
                                                icon.visualIndex,
                                                ListView.Visible)
                                }
                            }

                            Component.onCompleted: {
                                root.triggerHardKey.connect(onTriggerHardKey)
                            }
                        }

                        onFocusChanged: icon.focus = app.focus
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
