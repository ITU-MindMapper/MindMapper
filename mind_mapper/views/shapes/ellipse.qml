import QtQuick 2.5

Item {
    
    // Id of the shape
    id: ellipseShape

    // Object ID
    property var objectId

    // Background color
    property alias backgroundColor: canvas.backgroundColor
    
    // Text
    property alias text:      text.text
    property alias textFont:  text.font.family
    property alias textSize:  text.font.pointSize
    property alias textColor: text.color

    // Signals
    signal node_delete(var id)
    signal node_position_changed(var id, var x, var y)
    signal node_text_changed(var id, var new_text)

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
    Text {
        id: text
        anchors.centerIn: parent
    }

    // Text input field
    TextInput {
        id: inputField
        anchors.centerIn: parent
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: text.color
        font.family: text.font.family
        font.pointSize: text.font.pointSize
        focus: true
        visible: false
        
        onAccepted: {
            text.text = inputField.text
            inputField.visible = false
            inputField.focus = false
            ellipseShape.node_text_changed(ellipseShape.objectId, text.text)
        }
    }

    function enableEditing() {
        inputField.focus = true
        inputField.visible = true
        inputField.text = text.text
        text.text = ""
    }

    // MouseArea
    MouseArea {
        id: mouseArea
        objectName: "mouseArea"

        property var dragged: false
        property var dragMaxX: 0
        property var dragMaxY: 0
        
        anchors.fill: parent

        drag.target: ellipseShape
        drag.axis: Drag.XandYAxis
        drag.minimumX: 0
        drag.minimumY: 0
        drag.maximumX: dragMaxX
        drag.maximumY: dragMaxY

        onClicked: enableEditing()

        onDoubleClicked: ellipseShape.node_delete(ellipseShape.objectId)

        onPressed: dragged = false

        onPositionChanged: dragged = true

        onReleased: {
            if(dragged){
                ellipseShape.node_position_changed(
                    ellipseShape.objectId,
                    ellipseShape.x + ellipseShape.width / 2,
                    ellipseShape.y + ellipseShape.height / 2)
                dragged = false
            }
        }
    }
}
