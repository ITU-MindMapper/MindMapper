import QtQuick 2.2
import QtQuick.Controls 1.1


Rectangle {

    signal click(var val)
    signal position_changed(var val, var x, var y)

    property var value: "Tlacitko"
    id: button
    width: 300
    height: 40
    color: "#aa0000"


    Text {
        text: button.value
        anchors.centerIn: parent
        color: "black"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: button.click(button.value)
        onReleased: button.position_changed(button.value, mouse.x, mouse.y)
    }
}
