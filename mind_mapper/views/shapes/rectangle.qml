import QtQuick 2.5

Item {
    
    // Id of the shape
    id: rectangleShape

    // Object ID
    property var objectId
    property var workspaceWidth
    property var workspaceHeight

    // Background color
    property alias backgroundColor: content.color
    
    // Text
    property alias text:      text.nodetext
    property alias textFont:  text.textfont
    property alias textSize:  text.textsize
    property alias textColor: text.textcolor

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
    Nodetext {
        id: text
        width: parent.width
        height: parent.height
        onTextChanged: rectangleShape.node_text_changed(rectangleShape.objectId, text.nodetext)
    }

    // MouseArea
    MouseArea {
        id: mouseArea
        objectName: "mouseArea"

        property var dragged: false
        property var ispress: false

        anchors.fill: parent
        
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        drag.target: rectangleShape
        drag.axis: Drag.XandYAxis
        drag.minimumX: 0
        drag.minimumY: 0
        drag.maximumX: rectangleShape.workspaceWidth - parent.width
        drag.maximumY: rectangleShape.workspaceHeight - parent.height

        onClicked: {
            if(mouse.button == Qt.LeftButton)
                text.inputting = true;
            else if (mouse.button == Qt.RightButton)
                rectangleShape.node_connect(rectangleShape.objectId);
        }

        onDoubleClicked: {
            if(mouse.button == Qt.LeftButton)
                rectangleShape.node_delete(rectangleShape.objectId)
        }

        onPressed: {
            dragged = false
            ispress = true
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
