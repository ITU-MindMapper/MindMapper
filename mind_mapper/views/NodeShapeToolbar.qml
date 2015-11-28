import QtQuick 2.5

Item {
    id: container

    signal clicked(var number)
    property alias backgroundColor: rect.color
    property var buttonSize: 50
    width: 58
    height: (50 + 2)*2 + 7 

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "#D0D0D0"
    }

    Column {
        id: col
        anchors.centerIn: parent
        spacing: 2

        ImageButton {
            number: 0
            image: "resources/rectangle.png"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(number)
        }

        ImageButton {
            number: 1
            image: "resources/circle.png"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(number)
        }
    }
}
