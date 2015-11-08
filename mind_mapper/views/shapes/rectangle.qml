import QtQuick 2.5

Item {
    
    // Id of the shape
    id: rectangleShape

    // Object ID
    property var objectId

    // Background color
    property alias backgroundColor: content.color
    
    // Text
    property alias text:      text.text
    property alias textFont:  text.font.family
    property alias textSize:  text.font.pointSize
    property alias textColor: text.color

    signal node_delete(var id)
    signal node_position_changed(var id, var x, var y)
    signal node_text_changed(var id, var new_text)
    signal node_connect(var id)

    // Content
    Rectangle {
        id: content
        anchors.fill: parent
        border.color: "transparent"
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
            rectangleShape.node_text_changed(rectangleShape.objectId, text.text)
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
        property var ispress: false
        property var dragMaxX: 0
        property var dragMaxY: 0

        anchors.fill: parent
        
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        drag.target: rectangleShape
        drag.axis: Drag.XandYAxis
        drag.minimumX: 0
        drag.minimumY: 0
        drag.maximumX: dragMaxX
        drag.maximumY: dragMaxY

        onClicked: {
            if(mouse.button == Qt.LeftButton)
                enableEditing();
            else if (mouse.button == Qt.RightButton)
                rectangleShape.node_connect(rectangleShape.objectId);
        }

        onDoubleClicked: {
            if(mouse.button == Qt.LeftButton)
                rectangleShape.node_delete(rectangleShape.objectId)
        }

        onPressed: {
            if(mouse.button == Qt.LeftButton){
                dragged = false
                ispress = true
            }
        }

        onPositionChanged: {
            dragged = true
            if(ispress == true)
                rectangleShape.node_position_changed(
                    rectangleShape.objectId,
                    rectangleShape.x + rectangleShape.width / 2,
                    rectangleShape.y + rectangleShape.height / 2);
        }

        onReleased: {
            dragged = false;
            ispress = false;
        }
    }
}
