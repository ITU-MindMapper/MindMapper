import QtQuick 2.5

Item {
    
    // Id of the shape
    id: ellipseShape

    // Object ID
    property var objectId
    property var workspaceWidth: 0
    property var workspaceHeight: 0

    // Background color
    property alias backgroundColor: canvas.backgroundColor
    
    // Text
    property alias text:      text.nodetext
    property alias textFont:  text.textfont
    property alias textSize:  text.textsize
    property alias textColor: text.textcolor

    
    // Signals
    signal node_delete(var id)
    signal node_position_changed(var id, var x, var y)
    signal node_text_changed(var id, var new_text)
    signal node_connect(var id)
    signal node_focus(var id)

    onBackgroundColorChanged: canvas.requestPaint()

    // Content
    Rectangle {
        id: content
        border.color: "transparent"
        color: "transparent"
        anchors.fill: parent
        
        Canvas {
            id: canvas
            property color backgroundColor
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.beginPath();
                ctx.fillStyle = backgroundColor;
                ctx.ellipse(parent.x, parent.y, parent.width, parent.height);
                ctx.fill();
            }
        }
    }

    // Text content
    Nodetext {
        id: text
        width: parent.width
        height: parent.height
        onTextChanged: ellipseShape.node_text_changed(ellipseShape.objectId, text.nodetext)
    }

    // MouseArea
    MouseArea {
        id: mouseArea
        objectName: "mouseArea"

        property var dragged: false
        property var ispress: false

        anchors.fill: parent
        
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        drag.target: ellipseShape
        drag.axis: Drag.XandYAxis
        drag.minimumX: 0
        drag.minimumY: 0
        drag.maximumX: ellipseShape.workspaceWidth - parent.width
        drag.maximumY: ellipseShape.workspaceHeight - parent.height

        onClicked: {
            if(mouse.button == Qt.LeftButton){
                text.inputting = true;
                ellipseShape.node_focus(ellipseShape.objectId);
            }
            else if (mouse.button == Qt.RightButton)
                ellipseShape.node_connect(ellipseShape.objectId);
        }

        onDoubleClicked: {
            if(mouse.button == Qt.LeftButton)
                ellipseShape.node_delete(ellipseShape.objectId)
        }

        onPressed: {
            dragged = false
            ispress = true
            ellipseShape.node_focus(ellipseShape.objectId);
        }

        onPositionChanged: {
            dragged = true
            if(ispress == true)
                ellipseShape.node_position_changed(
                    ellipseShape.objectId,
                    ellipseShape.x + ellipseShape.width / 2,
                    ellipseShape.y + ellipseShape.height / 2);
        }

        onReleased: {
            dragged = false;
            ispress = false;
        }
    }
}
