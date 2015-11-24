import QtQuick 2.5

Item {
    id: container
    
    property alias nodetext:  text.text
    property alias textcolor: text.color
    property alias textfont:  text.font.family
    property alias textsize:  text.font.pointSize

    property var inputting: false
    
    signal textChanged(var newtext)

    onInputtingChanged: {
        if(inputting == true){
            inputField.focus = true
            inputField.visible = true
            inputField.text = text.text
            text.text = ""
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
            container.textChanged(text.text)
        }
    }
}
