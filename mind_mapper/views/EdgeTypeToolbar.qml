import QtQuick 2.5

Item {
    id: container

    signal clicked(var number)
    property alias backgroundColor: rect.color
    property var buttonSize: 50
    width: 58
    height: (50 + 2)*4 + 7 

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
            image: "resources/line.png"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(number)
        }

        ImageButton {
            number: 1
            image: "resources/linespike.png"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(number)
        }

        ImageButton {
            number: 2
            image: "resources/curve.png"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(number)
        }

        ImageButton {
            number: 3
            image: "resources/curvespike.png"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(number)
        }
    }
}
