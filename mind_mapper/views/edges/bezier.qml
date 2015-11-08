import QtQuick 2.5

Item {
    
    // Id of the shape
    id: bezierEdge

    // Object ID
    property var objectId

    property alias startX: canvas.startX
    property alias startY: canvas.startY
    property alias endX: canvas.endX
    property alias endY: canvas.endY
    property alias ctrlX: ctrlPoint.x
    property alias ctrlY: ctrlPoint.y

    // Signals
    signal edge_delete(var id)
    signal edge_position_changed(var id, var x, var y)

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
            property var thickness: 5;

            onStartXChanged:requestPaint();
            onStartYChanged:requestPaint();
            onEndXChanged:requestPaint();
            onEndYChanged:requestPaint();
            onCtrlXChanged:requestPaint();
            onCtrlYChanged:requestPaint();
            onThicknessChanged:requestPaint();

            onPaint: {
                var realCtrlX = 2*ctrlX - 0.5*startX - 0.5*endX
                var realCtrlY = 2*ctrlY - 0.5*startY - 0.5*endY

                var ctx = getContext("2d");
                ctx.reset()
                ctx.strokeStyle = Qt.rgba(0, 0, 0, 1);
                ctx.lineWidth = thickness;
                ctx.beginPath();
                ctx.moveTo(startX, startY);
                ctx.quadraticCurveTo(realCtrlX, realCtrlY, endX, endY);
                ctx.stroke();
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

        property var dragged: false
        property var dragMaxX: 0
        property var dragMaxY: 0
            
        anchors.fill: ctrlPoint

        acceptedButtons: Qt.LeftButton

        drag.target: ctrlPoint
        drag.axis: Drag.XandYAxis
        drag.minimumX: 0
        drag.minimumY: 0
        drag.maximumX: dragMaxX
        drag.maximumY: dragMaxY

        onDoubleClicked: bezierEdge.edge_delete(bezierEdge.objectId)

        onPressed: dragged = false

        onPositionChanged: dragged = true

        onReleased: {
            if(dragged){
                bezierEdge.edge_position_changed(
                    bezierEdge.objectId,
                    ctrlPoint.x,
                    ctrlPoint.y)
                dragged = false
            }
        }
    }

}
