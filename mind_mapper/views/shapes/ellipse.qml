import QtQuick 2.5

Item {
    
    // Id of the shape
    id: elipseShape

    // Object ID
    property var objectId

    // Background color
    property alias backgroundColor: canvas.backgroundColor
    
    // Text
    property alias text:      text.text
    property alias textFont:  text.font.family
    property alias textSize:  text.font.pointSize
    property alias textColor: text.color

    signal click(var val)
    signal position_changed(var val, var x, var y)

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
        
        onEditingFinished: {
            text.text = inputField.text
            inputField.visible = false
            inputField.focus = false
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
        anchors.fill: parent

        onClicked: enableEditing()

        Component.onCompleted: enableEditing()

        onDoubleClicked: elipseShape.destroy()
        
        drag.target: elipseShape
        drag.axis: Drag.XandYAxis
    }
}
