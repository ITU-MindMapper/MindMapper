import QtQuick 2.5

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
            property var thickness: 5
            property var edgeColor

            onStartXChanged:requestPaint();
            onStartYChanged:requestPaint();
            onEndXChanged:requestPaint();
            onEndYChanged:requestPaint();
            onThicknessChanged:requestPaint();

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset()
                ctx.strokeStyle = edgeColor
                ctx.lineWidth = thickness;
                ctx.beginPath();
                ctx.moveTo(startX, startY);
                ctx.lineTo(endX, endY);
                ctx.stroke()
                straightEdge.moveCtrlPoint();
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
