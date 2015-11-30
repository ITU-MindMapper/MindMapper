import QtQuick 2.5

Item {
    id: container

    property alias color: rect.color

    signal clicked(color color)

    Rectangle {
        id: rect
        anchors.fill: parent
    }

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true

        onEntered: {
            container.width += 5;
            container.height += 5;
        }

        onExited: {
            container.width -= 5;
            container.height -= 5;
        }

        onClicked: container.clicked(rect.color)
    }
}