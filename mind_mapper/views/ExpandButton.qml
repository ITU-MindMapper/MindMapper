import QtQuick 2.5

Item {
    id: container

    property var rotation: 0
    property alias color: rect.color

    signal clicked()

    width: 100
    height: 100
    z: 5

    // Zoom indicator
    Rectangle {
        id: rect
        anchors.fill: parent
        width: parent.width
        height: parent.height
        color: "#DDDDDD"
        opacity: 0

        Image {
            source: "resources/arrow.png"
            transform: Rotation {origin.x: width/2; origin.y: height/2; angle: container.rotation}
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
        }

        PropertyAnimation { 
            id: showAnimation;
            target: rect;
            property: "opacity";
            to: 0.5;
            duration: 250
        }

        PropertyAnimation { 
            id: closeAnimation;
            target: rect;
            property: "opacity";
            to: 0;
            duration: 250
        }
    }

    MouseArea {
        anchors.fill: rect
        hoverEnabled: true

        onEntered: showAnimation.running = true
        onExited: closeAnimation.running = true
        onPressed: container.clicked()
    }
}