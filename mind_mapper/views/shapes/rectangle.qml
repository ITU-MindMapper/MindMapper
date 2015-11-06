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

    signal click(var val)
    signal position_changed(var val, var x, var y)

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

        onDoubleClicked: rectangleShape.destroy()

        drag.target: rectangleShape
        drag.axis: Drag.XandYAxis
    }
}


/*
Rectangle {

    signal click(var val)
    signal position_changed(var val, var x, var y)

    property var value: "Tlacitko"
    property var toolTipRoot
    id: button


    Text {
        text: button.value
        anchors.centerIn: parent
        color: "black"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            button.click(button.value);
            parent.focus = true;
        }
        onReleased: button.position_changed(button.value, mouse.x, mouse.y)
    }
}
*/