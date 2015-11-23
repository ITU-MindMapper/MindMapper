import QtQuick 2.5

Item {
    id: container

    signal clicked(color color)
    property alias backgroundColor: rect.color
    property var buttonSize: 30
    width: 40
    height: 680

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "#D0D0D0"
    }

    Column {
        id: col
        anchors.centerIn: parent
        spacing: 2

        ColorButton {
            color: "#9dd2e7"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#73b0b2"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#009993"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#015873"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#002849"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#192327"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#380952"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#785e94"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#d86fb4"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#bd3758"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#58011c"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#e93f1e"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "red"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#8b4513"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#61635c"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#008547"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#047619"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#458b00"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#63e91e"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#f7c460"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#e3d05d"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }
    }
}