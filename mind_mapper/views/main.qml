import QtQuick 2.5
import QtQuick.Controls 1.4

Item {
    id: mainWindow

    signal toolbar_sel(var id)
    signal create_node(var x, var y)
    signal mouse_position(var x, var y)
    signal lose_focus()
    signal save()
    signal load()

    // Connection Pointer attributes
    property var connecting
    property alias connectingFromX: connectionPointer.cx
    property alias connectingFromY: connectionPointer.cy
    property alias connectingToX: connectionPointer.endX
    property alias connectingToY: connectionPointer.endY

    onConnectingChanged: connectionPointer.requestPaint()

    // Beckground
    Rectangle {
        anchors.fill: parent
        color: "#E5E5E5"
    }

    // Layout of elements
    Grid {
        rows: 1
        columns: 2
        anchors.fill: parent

        // Workspace
        Rectangle {
            id: workspace
            objectName: "workspace"

            width: parent.width - menu.width
            height: parent.height
            color: "white"

            onWidthChanged: gridcanvas.requestPaint();
            onHeightChanged: gridcanvas.requestPaint();

            // Background grid for better work
            Canvas {
                id: gridcanvas
                anchors.fill: parent
                property var size: 50
                property var vertical_count: parent.width/size - 1
                property var horizontal_count: parent.height/size - 1
                property var posX: 0
                property var posY: 0
                onPaint: {
                    posX = 0
                    posY = 0
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.strokeStyle = Qt.rgba(0.8, 0.8, 0.8, 1);
                    ctx.lineWidth = 1;
                    ctx.beginPath();
                    var i;
                    for (i = 0; i < vertical_count; i++) {
                        posX = posX + size;
                        ctx.moveTo(posX, 0);
                        ctx.lineTo(posX, parent.height);
                    }
                    for (i = 0; i < horizontal_count; i++) { 
                        posY = posY + size
                        ctx.moveTo(0, posY);
                        ctx.lineTo(parent.width, posY);
                    }
                    ctx.stroke();
                }
            } // end of background grid

            // Connection pointer indicator
            Canvas {
                id: connectionPointer
                anchors.fill: parent
                antialiasing: true;

                property var cx
                property var cy
                property var endX
                property var endY

                onCxChanged:requestPaint();
                onCyChanged:requestPaint();
                onEndXChanged:requestPaint();
                onEndYChanged:requestPaint();

                onPaint: {
                   var ctx = getContext("2d");
                   if(mainWindow.connecting == true){
                        ctx.reset();
                        ctx.strokeStyle = Qt.rgba(0.7, 0.7, 0.7, 1);
                        ctx.lineWidth = 3
                        ctx.clearRect(0,0,parent.width, parent.height)
                        ctx.beginPath();1
                        ctx.moveTo(cx, cy);
                        ctx.lineTo(endX, endY);
                        ctx.stroke();
                    }
                    else{
                        ctx.clearRect(0,0,parent.width,parent.height);
                    }
                }
            } // end of connection pointer

            // Workspace mouse area
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onDoubleClicked: mainWindow.create_node(mouse.x, mouse.y)

                onClicked: mainWindow.lose_focus()

                onPositionChanged: {
                    if(mainWindow.connecting == true)
                        mainWindow.mouse_position(mouse.x, mouse.y)
                }
            } // end of workspace mouse area
        } // end of workspace

        // Toolbar menu
        Column {
            id: menu
            width: 100
            z: 4

            // Save button
            CustomButton {
                height: 40
                width: parent.width
                color: "#E5E5E5"
                hovercolor: "#D0D0D0"
                iconsource: "resources/save.png"
                textvalue: "Save"
                onClicked: mainWindow.save()
            }

            // Load button
            CustomButton {
                height: 40
                width: parent.width
                color: "#E5E5E5"
                hovercolor: "#D0D0D0"
                iconsource: "resources/load.png"
                textvalue: "Load"
                onClicked: mainWindow.load()
            }

            Rectangle {
                width: parent.width
                height: parent.width
                color: "#f8ffcc"
            }
        } // end of toolbar menu
    } // end of layout
} // end of main window
