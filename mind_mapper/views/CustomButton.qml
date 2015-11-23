import QtQuick 2.5

Item {
    id: container

    property color color: nohovercolor
    property color nohovercolor
    property color hovercolor
    property alias iconsource: icon.source
    property alias textvalue:  text.text
    property alias iconcolor:  iconrect.color
    property alias hoverEnabled: mouseArea.hoverEnabled
    signal clicked()

    onHoverEnabledChanged: {
        if(hoverEnabled == false)
            container.color = container.hovercolor
        else
            container.color = container.nohovercolor
    }

    onColorChanged: {
        if((iconrect.color == container.nohovercolor) ||
          (iconrect.color == container.hovercolor))
            iconrect.color = container.color
        iconrect.border.color = container.color
        textrect.color = container.color
    }

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
        id: mouseArea
        anchors.fill: parent

        hoverEnabled: true

        onEntered: {
            iconrect.border.color = container.hovercolor;
            textrect.color = container.hovercolor;
            if(iconrect.color == container.color)
                iconrect.color = container.hovercolor;
        }

        onExited: {
            iconrect.border.color = container.color;
            textrect.color = container.color;
            if(iconrect.color == container.hovercolor)
                iconrect.color = container.color;
        }

        onClicked: container.clicked();
    }
}