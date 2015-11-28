import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: container

    property alias placeholder: text.placeholderText
    property alias text: text.text
    property alias maximumLength: text.maximumLength
    property var padding: 0

    signal changed(var value)

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "#E5E5E5"
    }

    TextField {
        id: text
        anchors.centerIn: rect
        width: rect.width - container.padding
        height: rect.height - container.padding
        maximumLength: 8
        validator: IntValidator {}
        style: TextFieldStyle {
            textColor: "black"
            background: Rectangle {
            }
        }

        onTextChanged: {
            if((text.text == '')||(text.text == '0'))
                container.changed('1')
            else
                container.changed(text.text)
        }
    }
}
