import QtQuick 2.5

Item {
    id: container

    property color color
    property color hovercolor
    property alias iconsource: icon.source
    property alias textvalue:  text.text

    signal clicked()

    Grid {

        rows: 1
        columns: 2
        anchors.fill: parent

        Rectangle {
            id: iconrect
            width: parent.height
            height: parent.height
            color: container.color
            border.width: 5
            border.color: container.color

            Image {
                id: icon
                width: parent.height - 2 * parent.border.width
                height: parent.height - 2 * parent.border.width
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
            }
        }

        Rectangle {
            id: textrect
            width: parent.width - parent.height
            height: parent.height
            color: container.color

            Text {
                id: text
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true

        onEntered: {
            iconrect.border.color = container.hovercolor;
            textrect.color = container.hovercolor;
            iconrect.color = container.hovercolor;
        }

        onExited: {
            iconrect.border.color = container.color;
            textrect.color = container.color;
            iconrect.color = container.color;
        }

        onClicked: container.clicked()
    }
}