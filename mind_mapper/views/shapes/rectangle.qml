import QtQuick 2.2
import QtQuick.Controls 1.1
import "../qml"


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
