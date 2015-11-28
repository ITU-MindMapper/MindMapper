import QtQuick 2.5

Item {
    id: container

    signal clicked(color color)
    property alias backgroundColor: rect.color
    property var animationDuration: 120
    property var buttonSize: 30
    property var rows: 22
    property var columns: 1
    property var show: false

    height: parent.height
    width: columns * (buttonSize + 1) + 10

    property var toolbarHeight: rows * (buttonSize + 1) + 10

    onHeightChanged: {
        if(height < toolbarHeight){
            var temp
            columns += 1
            temp = parseInt(22 / columns)
            if((columns * temp) < 22)
                rows = temp + 1
            else
                rows = temp
        }
        else if(columns > 1){
            var newColums = columns - 1
            var newRows = parseInt(22 / newColums)
            if((newRows * newColums)<22)
                newRows += 1
            var newHeight = newRows * (buttonSize + 1) + 10
            if(newHeight < height){
                columns = newColums
                rows = newRows
            }
        } 
    }

    PropertyAnimation { 
        id: showAnimation;
        target: container;
        property: "opacity";
        to: 1;
        duration: container.animationDuration
    }

    PropertyAnimation { 
        id: closeAnimation;
        target: container;
        property: "opacity";
        to: 0;
        duration: container.animationDuration
    }

    onShowChanged: {
        if(show == true)
            showAnimation.running = true
        else
            closeAnimation.running = true
    }

    onOpacityChanged: {
        if(opacity == 0)
            visible = false
        else
            visible = true
    }

    Rectangle {
        id: rect
        height: parent.toolbarHeight
        width: parent.width
        anchors.centerIn: parent
        color: "#D0D0D0"
    }

    Grid {
        id: grid
        rows: container.rows
        columns: container.columns
        anchors.centerIn: rect
        spacing: 1
        horizontalItemAlignment: Grid.AlignHCenter
        verticalItemAlignment: Grid.AlignVCenter

        ColorButton {
            color: "#9dd2e7"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#73b0b2"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#009993"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#015873"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#002849"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#380952"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#785e94"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#d86fb4"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#bd3758"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#58011c"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#e93f1e"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "red"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#8b4513"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#61635c"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#008547"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#047619"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#458b00"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#63e91e"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#f7c460"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "#e3d05d"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "black"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }

        ColorButton {
            color: "white"
            width: container.buttonSize
            height: container.buttonSize
            onClicked: container.clicked(color)
        }
    }
}