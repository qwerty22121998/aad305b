import QtQuick 2.0
import "../../Qml"
import "../Common"

Item {
    CommonApp {
        appTitle: "Climate"
        ClimateWidget {
            enabled: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
