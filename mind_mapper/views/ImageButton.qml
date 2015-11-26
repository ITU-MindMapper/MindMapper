import QtQuick 2.5

Item {
    id: container

    property alias image: image.source
    property var number: 0

    signal clicked(var number)

    anchors.horizontalCenter : parent.horizontalCenter

    Rectangle {
        id: rect
        anchors.fill: parent

        Image {
            id: image
            width: parent.width
            height: parent.height
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
        }
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

        onClicked: container.clicked(container.number)
    }
}
