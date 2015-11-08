import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: mainWindow

    signal toolbar_sel(var id)
    signal create_node(var x, var y)
    signal save()
    signal load()

    Rectangle {
        anchors.fill: parent
        color: "#E5E5E5"
    }

    Grid {
        rows: 1
        columns: 2
        anchors.fill: parent

        Rectangle {
            id: workspace
            objectName: "workspace"

            width: parent.width - menu.width
            height: parent.height
            color: "white"

            MouseArea {
                anchors.fill: parent
                onDoubleClicked: mainWindow.create_node(mouse.x, mouse.y)
            }

        }

        Column {
            id: menu
            width: 100

            // Here shall be thy toolbars. Praise the sun.
            Rectangle {
                width: parent.width
                height: parent.width
                color: "#ff4000"

                Text {
                    text: "SAVE"
                    anchors.centerIn: parent
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: mainWindow.save()
                }
            }

            Rectangle {
                width: parent.width
                height: parent.width
                color: "#2bdce1"

                Text {
                    text: "LOAD"
                    anchors.centerIn: parent
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: mainWindow.load()
                }
            }

            Rectangle {
                width: parent.width
                height: parent.width
                color: "#f8ffcc"
            }
        }
    }
}
