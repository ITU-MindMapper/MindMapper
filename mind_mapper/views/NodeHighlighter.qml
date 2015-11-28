import QtQuick 2.5

Item {
    id: container

    property var shape
    property var color

    z: 2
    opacity: 0.5

    onVisibleChanged: {
        if(visible == true){
            if(shape == 0){
                rectangleShape.visible = true
                ellipseShape.visible = false
            }
            else{
                ellipseShape.visible = true
                rectangleShape.visible = false
                canvas.requestPaint()
            }
        }
    }

    Rectangle {
        id: rectangleShape
        anchors.fill: parent
        color: container.color
    }

    // Content
    Rectangle {
        id: ellipseShape
        border.color: "transparent"
        color: "transparent"
        anchors.fill: parent

        Canvas {
            id: canvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.beginPath();
                ctx.fillStyle = container.color;
                ctx.ellipse(parent.x, parent.y, parent.width, parent.height);
                ctx.fill();
            }
        }
    }
}
