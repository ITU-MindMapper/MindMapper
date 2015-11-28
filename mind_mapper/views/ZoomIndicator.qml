import QtQuick 2.5

Item {
    id: container

    property var show: false
    property var duration: 2000
    property var text
    property alias color: rect.color

    width: 100
    height: 50

    anchors.top: parent.top
    anchors.topMargin: 20
    anchors.horizontalCenter: parent.horizontalCenter

    visible: false
    z: 5

    function restart() {zoomTimer.restart()}

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
            id: zoomTimer
            interval: container.duration
            running: false
            onTriggered: container.show = false
        }

        Text {
            anchors.centerIn: parent
            text: container.text
        }
    }
}