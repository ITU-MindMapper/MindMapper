import QtQuick 2.5

Item {
    id: container

    property var show: false
    property var duration: 2000
    property var text
    property alias color: rect.color

    anchors.top: parent.top
    anchors.topMargin: 20
    anchors.horizontalCenter: parent.horizontalCenter

    width: text.paintedWidth + 40
    height: text.paintedHeight + 20

    visible: false
    z: 5

    function restart() {timer.restart()}

    onShowChanged: {
        if(show == true)
            showAnimation.running = true
        else
            closeAnimation.running = true
    }

    // Zoom indicator
    Rectangle {
        id: rect
        anchors.fill: parent
        color: "#DDDDDD"
        opacity: 0

        onOpacityChanged: {
            if (opacity == 0)
                container.visible = false
            else
                container.visible = true
        }

        PropertyAnimation { 
            id: showAnimation;
            target: rect;
            property: "opacity";
            to: 0.5;
            duration: 500
        }

        PropertyAnimation { 
            id: closeAnimation;
            target: rect;
            property: "opacity";
            to: 0;
            duration: 500
        }

        Timer {
            id: timer
            interval: container.duration
            running: false
            onTriggered: container.show = false
        }

        Text {
            id: text
            anchors.centerIn: parent
            text: container.text
        }
    }
}