import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: container

    property alias color: rect.color
    property var text
    property alias checked: checkbox.checked

    signal clicked()

    anchors.horizontalCenter : parent.horizontalCenter

    Rectangle {
        id: rect
        anchors.fill: parent

        Grid{
            rows: 1
            columns: 3
         
            Rectangle {
                id: filler
                width: container.height/4
                height: container.height
                color: rect.color
            }

            CheckBox {
                id: checkbox
                height: container.height
                width: container.height - filler.width
                onClicked: {
                    container.clicked()
                }
            }


            Text {
                id: text
                height: container.height
                width: container.width - container.height
                text: container.text
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
