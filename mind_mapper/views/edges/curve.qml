import QtQuick 2.5
import "edgefunctions.js" as Func

Item {
    
    // Id of the type
    id: container

    // Object ID
    property var objectId

    property alias showCtrlPoint: ctrlPoint.visible
    property var isActive: false

    property alias workspaceWidth: container.width
    property alias workspaceHeight: container.height
    property alias startX: canvas.startX
    property alias startY: canvas.startY
    property alias endX: canvas.endX
    property alias endY: canvas.endY
    property alias ctrlX: ctrlPoint.x
    property alias ctrlY: ctrlPoint.y
    property alias color: canvas.edgeColor
    property alias thickness: canvas.thickness
    property alias arrow: canvas.arrow
    property alias spiked: canvas.spiked

    // Signals
    signal edge_delete(var id)
    signal edge_position_changed(var id, var x, var y)
    signal edge_focus(var id)

    onColorChanged: canvas.requestPaint()

    // Content
    Rectangle {
        id: content
        border.color: "transparent"
        color: "transparent"
        anchors.fill: parent

        Canvas {
            id: canvas
            anchors.fill: parent
            objectName: "canvas"

            property var startX: 0
            property var startY: 0
            property var endX: 0
            property var endY: 0
            property var ctrlX: ctrlPoint.x + 5
            property var ctrlY: ctrlPoint.y + 5
            property var thickness
            property var edgeColor
            property var spiked
            property var arrow

            onStartXChanged:requestPaint();
            onStartYChanged:requestPaint();
            onEndXChanged:requestPaint();
            onEndYChanged:requestPaint();
            onCtrlXChanged:requestPaint();
            onCtrlYChanged:requestPaint();
            onThicknessChanged:requestPaint();

            onPaint: {
                var realCtrlX = 2*ctrlX - 0.5*startX - 0.5*endX;
                var realCtrlY = 2*ctrlY - 0.5*startY - 0.5*endY;
                var ctx = getContext("2d");
                ctx.reset();
                ctx.strokeStyle = edgeColor;

                if(spiked == 0){
                    ctx.lineWidth = thickness;
                    ctx.moveTo(startX, startY);
                    ctx.quadraticCurveTo(realCtrlX, realCtrlY, endX, endY);
                    ctx.stroke();
                }
                else {
                    var sp = Func.getPoints(startX, startY, 
                                            ctrlX, ctrlY,
                                            thickness);
                    ctx.fillStyle = edgeColor;
                    ctx.lineWidth = 1;
                    ctx.beginPath();
                    ctx.moveTo(sp[0], sp[1]);
                    ctx.quadraticCurveTo(realCtrlX, realCtrlY, endX, endY);
                    ctx.quadraticCurveTo(realCtrlX, realCtrlY, sp[2], sp[3]);
                    ctx.closePath();
                    ctx.fill()
                    ctx.stroke();
                }
            }
        }
    }

    Rectangle {
        id: ctrlPoint
        width: 10
        height: 10
        color: "#ff4000"
        radius: 5
    }

    Rectangle {
        id: activityIndicator
        width: 50
        height: 50
        color: "#d8d8d8"
        opacity: 0.5
        radius: 25
        x: ctrlPoint.x - (width - ctrlPoint.width) / 2
        y: ctrlPoint.y - (height - ctrlPoint.height) / 2
        visible: container.isActive && ctrlPoint.visible
    }

    // MouseArea
    MouseArea {
        id: mouseArea
        objectName: "mouseArea"

        property var dragged: false
            
        anchors.fill: ctrlPoint

        acceptedButtons: Qt.LeftButton

        drag.target: ctrlPoint
        drag.axis: Drag.XandYAxis
        drag.minimumX: 0
        drag.minimumY: 0
        drag.maximumX: container.workspaceWidth - ctrlPoint.width
        drag.maximumY: container.workspaceHeight - ctrlPoint.height

        onClicked: container.edge_focus(container.objectId);

        onDoubleClicked: container.edge_delete(container.objectId)

        onPressed: {
            dragged = false
            container.edge_focus(container.objectId);
        } 

        onPositionChanged: dragged = true

        onReleased: {
            if(dragged) {
                container.edge_position_changed(
                    container.objectId,
                    ctrlPoint.x,
                    ctrlPoint.y)
                dragged = false
            }
        }
    }
}
