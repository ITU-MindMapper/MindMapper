import QtQuick 2.5

Item {
    id: container

    signal clicked(var number)
    property alias backgroundColor: rect.color
    property var animationDuration: 120
    property var buttonSize: 50
    property var show: false
    width: 58
    height: (50 + 2)*4 + 7 

    PropertyAnimation { 
        id: showAnimation;
        target: container;
        property: "opacity";
        to: 1;
        duration: container.animationDuration
    }

    PropertyAnimation { 
        id: closeAnimation;
        target: container;
        property: "opacity";
        to: 0;
        duration: container.animationDuration
    }

    onShowChanged: {
        if(show == true)
            showAnimation.running = true
        else
            closeAnimation.running = true
    }

    onOpacityChanged: {
        if(opacity == 0)
            visible = false
        else
            visible = true
    }

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
