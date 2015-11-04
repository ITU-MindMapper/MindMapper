import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {
    id: mainWindow

    anchors.fill: parent

    signal click(var x, var y)

    Text {
        id: helloText
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Trol"
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        onDoubleClicked: mainWindow.click(mouse.x, mouse.y)
        anchors.fill: parent
    }
}
