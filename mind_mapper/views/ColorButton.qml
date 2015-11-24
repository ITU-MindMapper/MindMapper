import QtQuick 2.5

Item {
    id: container

    property alias color: rect.color

    signal clicked(color color)

    Rectangle {
        id: rect
        anchors.fill: parent
        border.width: 0
        border.color: "black"
        radius: 5
    }

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true

        onEntered: rect.border.width = 2

        onExited: rect.border.width = 0

        onClicked: container.clicked(rect.color)
    }
}