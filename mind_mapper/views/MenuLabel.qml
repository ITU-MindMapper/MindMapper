import QtQuick 2.5

Item {
    id: container

    property alias color: rect.color
    property alias textcolor: text.color
    property alias text: text.text

    anchors.horizontalCenter : parent.horizontalCenter

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "#C0C0C0"

        Text {
            id: text
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
        }
    }
}
