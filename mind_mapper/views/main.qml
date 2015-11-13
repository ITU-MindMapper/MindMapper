import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: mainWindow

    signal toolbar_sel(var id)
    signal create_node(var x, var y)
    signal mouse_position(var x, var y)
    signal lose_focus()
    signal save()
    signal load()

    property var connecting
    property alias connectingFromX: connectionPointer.cx
    property alias connectingFromY: connectionPointer.cy
    property alias connectingToX: connectionPointer.endX
    property alias connectingToY: connectionPointer.endY

    onConnectingChanged: connectionPointer.requestPaint()

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
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onDoubleClicked: mainWindow.create_node(mouse.x, mouse.y)

                onClicked: mainWindow.lose_focus()

                onPositionChanged: {
                    if(mainWindow.connecting == true)
                        mainWindow.mouse_position(mouse.x, mouse.y)
                }
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
