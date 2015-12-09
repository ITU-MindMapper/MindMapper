import QtQuick 2.5

Item {
    
    // Id of the shape
    id: container

    // Object ID
    property var objectId
    property var workspaceWidth
    property var workspaceHeight

    // Background color
    property alias background: content.color
    
    // Text
    property alias text:      text.nodetext
    property alias textFont:  text.textfont
    property alias textSize:  text.textsize
    property alias textColor: text.textcolor
    property alias inputting: text.inputting

    signal node_delete(var id)
    signal node_position_changed(var id, var x, var y)
    signal node_text_changed(var id, var new_text)
    signal node_connect(var id)
    signal node_focus(var id)

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
        onTextChanged: container.node_text_changed(container.objectId, text.nodetext)
    }

    // MouseArea
    MouseArea {
        id: mouseArea
        objectName: "mouseArea"

        property var dragged: false
        property var ispress: false

        anchors.fill: parent
        
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        drag.target: container
        drag.axis: Drag.XandYAxis
        drag.minimumX: 0
        drag.minimumY: 0
        drag.maximumX: container.workspaceWidth - parent.width
        drag.maximumY: container.workspaceHeight - parent.height

        onClicked: {
            if(mouse.button == Qt.LeftButton){
                text.inputting = true;
                container.node_focus(container.objectId);
            }
            else if (mouse.button == Qt.RightButton)
                container.node_connect(container.objectId);
        }

        onDoubleClicked: {
            if(mouse.button == Qt.LeftButton)
                container.node_delete(container.objectId)
        }

        onPressed: {
            dragged = false
            ispress = true
            container.node_focus(container.objectId);
        }

        onPositionChanged: {
            dragged = true
            if(ispress == true)
                container.node_position_changed(
                    container.objectId,
                    container.x + container.width / 2,
                    container.y + container.height / 2);
        }

        onReleased: {
            dragged = false;
            ispress = false;
        }
    }
}
