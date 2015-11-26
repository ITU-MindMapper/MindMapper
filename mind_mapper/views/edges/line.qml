import QtQuick 2.5
import "edgefunctions.js" as Func

Item {
    
    // Id of the shape
    id: straightEdge

    // Object ID
    property var objectId

    property alias workspaceWidth: straightEdge.width
    property alias workspaceHeight: straightEdge.height
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

    function moveCtrlPoint(){
        straightEdge.ctrlX = (parseInt(startX) + parseInt(endX))/2 - 5;
        straightEdge.ctrlY = (parseInt(startY) + parseInt(endY))/2 - 5;
    }

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
            property var thickness
            property var edgeColor
            property var arrow
            property var spiked

            onStartXChanged:requestPaint();
            onStartYChanged:requestPaint();
            onEndXChanged:requestPaint();
            onEndYChanged:requestPaint();
            onThicknessChanged:requestPaint();

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.strokeStyle = edgeColor;
                
                if(spiked == 0){
                    ctx.lineWidth = thickness;
                    ctx.moveTo(startX, startY);
                    ctx.lineTo(endX, endY);
                    ctx.stroke();
                    straightEdge.moveCtrlPoint();
                }
                else {
                    var sp = Func.getPoints(startX, startY, 
                                            ctrlX, ctrlY,
                                            thickness);
                    ctx.fillStyle = edgeColor;
                    ctx.lineWidth = 1;
                    ctx.beginPath();
                    ctx.moveTo(sp[0], sp[1]);
                    ctx.lineTo(endX, endY);
                    ctx.lineTo(sp[2], sp[3]);
                    ctx.closePath();
                    ctx.fill();
                    ctx.stroke();
                    straightEdge.moveCtrlPoint();                  
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

    // MouseArea
    MouseArea {
        id: mouseArea
        objectName: "mouseArea"

        anchors.fill: ctrlPoint

        acceptedButtons: Qt.LeftButton

        onDoubleClicked: straightEdge.edge_delete(straightEdge.objectId)
    }
}
