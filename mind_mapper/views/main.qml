import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQml 2.2

Item {
    id: mainWindow

    /**
     * Signals
     */

    // Node signals
    signal create_node(var x, var y)
    signal node_color_sel(var color)
    signal node_shape_sel(var shape)
    signal node_width_changed(var width)
    signal node_height_changed(var height)

    // Edge signals
    signal edge_color_sel(var color)
    signal edge_type_sel(var type, var spiked, var arrow)
    signal edge_thickness_changed(var thickness)

    // General signals
    signal lose_focus()
    signal save()
    signal load()
    signal window_resize(var width, var height)
    signal mouse_position(var x, var y)

    /**
     * Properties
     */

    // Menu attributes
    property color menuIdleButtonColor: "#E5E5E5"
    property color menuHoveredButtonColor: "#D0D0D0"

    // Connection Pointer attributes
    property var connecting
    property alias connectingFromX: connectionPointer.cx
    property alias connectingFromY: connectionPointer.cy
    property alias connectingToX: connectionPointer.endX
    property alias connectingToY: connectionPointer.endY

    // Active node properties (set by controller)
    property color activeNodeColor
    property var activeNodeShape
    property var activeNodeWidth
    property var activeNodeHeight
    property var activeNodeX
    property var activeNodeY
    property var activeNodeText
    property var activeNodeTextSize
    property var activeNodeTextColor
    property var hasActiveNode: false

    // Active edge properties (set by controller)
    property color activeEdgeColor
    property var activeEdgeThickness
    property var activeEdgeType
    property var activeEdgeSpiked
    property var activeEdgeArrow
    property var hasActiveEdge: false

    /**
     * Functions
     */

    // Function to clear opened toolbar
    function toggleToolbar(objectName){
        if(objectName != "nodeColorSelButton"){
            nodeColorSelButton.hoverEnabled = true;
            nodeColorToolbar.show = false;
        }
        if(objectName != "edgeColorSelButton"){
            edgeColorSelButton.hoverEnabled = true;
            edgeColorToolbar.show = false;
        }
        if(objectName != "edgeTypeSelButton"){
            edgeTypeSelButton.hoverEnabled = true;
            edgeTypeToolbar.show = false;
        }
        if(objectName != "nodeShapeSelButton"){
            nodeShapeSelButton.hoverEnabled = true;
            nodeShapeToolbar.show = false;
        }
    }

    // Function to get edge icon based on type, spiked and arrow property
    function getEdgeIcon(type, spiked, arrow){
        if((mainWindow.activeEdgeType == 0) &&
           (mainWindow.activeEdgeSpiked == 0))
            return "resources/line.png";
        else if((mainWindow.activeEdgeType == 0) &&
                (mainWindow.activeEdgeSpiked == 1))
            return "resources/linespike.png";
        else if((mainWindow.activeEdgeType == 1) &&
                (mainWindow.activeEdgeSpiked == 0))
            return "resources/curve.png";
        else
            return "resources/curvespike.png";
    }

    onConnectingChanged: connectionPointer.requestPaint()

    // If active node is changed, node toolbars are changed
    onHasActiveNodeChanged: {
        if(hasActiveNode == true){
            nodeColorSelButton.iconcolor = mainWindow.activeNodeColor;
            mainWindow.node_color_sel(mainWindow.activeNodeColor);
            if(mainWindow.activeNodeShape == 0)
                nodeShapeSelButton.iconsource = "resources/rectangle.png";
            else
                nodeShapeSelButton.iconsource = "resources/circle.png";
            mainWindow.node_shape_sel(mainWindow.activeNodeShape);
            nodeWidthControl.text = mainWindow.activeNodeWidth;
            nodeHeightControl.text = mainWindow.activeNodeHeight;
        }
    }

    // If active edge is changed, edge toolbars are changed
    onHasActiveEdgeChanged: {
        if(hasActiveEdge == true){
            edgeColorSelButton.iconcolor = mainWindow.activeEdgeColor;
            mainWindow.edge_color_sel(mainWindow.activeEdgeColor);
            edgeTypeSelButton.iconsource = getEdgeIcon(
                                                mainWindow.activeEdgeType,
                                                mainWindow.activeEdgeSpiked,
                                                mainWindow.activeEdgeArrow)
            mainWindow.edge_type_sel(mainWindow.activeEdgeType,
                                     mainWindow.activeEdgeSpiked,
                                     mainWindow.activeEdgeArrow)
            edgeThicknessControl.text = mainWindow.activeEdgeThickness;
        }
    }

    // Beckground
    Rectangle {
        anchors.fill: parent
        color: "#E5E5E5"
    }

    ZoomIndicator {
        id: zoomIndicator
        width: 100
        height: 50
        color: "#DDDDDD"
        text: parseInt(zoomScale.xScale * 100).toString() + "%"
        show: false
    }

    /**
     * Toolbars
     */

    // Node color toolbar
    ColorToolbar {
        id: nodeColorToolbar
        anchors.right: parent.right
        anchors.rightMargin: menu.width
        animationDuration: 200
        opacity: 0
        z: 4

        onClicked: {
            mainWindow.node_color_sel(color);
            nodeColorSelButton.iconcolor = color;
        }
    } // end of node color toolbar

    // Edge color toolbar
    ColorToolbar {
        id: edgeColorToolbar
        anchors.right: parent.right
        anchors.rightMargin: menu.width
        animationDuration: 200
        opacity: 0
        z: 4

        onClicked: {
            mainWindow.edge_color_sel(color);
            edgeColorSelButton.iconcolor = color;
        }
    } // end of edge color toolbar

    // Edge type toolbar
    EdgeTypeToolbar {
        id: edgeTypeToolbar
        anchors.right: parent.right
        anchors.rightMargin: menu.width
        animationDuration: 200
        opacity: 0
        z: 4
        y: edgeTypeSelButton.y

        onClicked: {
            /*
             * type 1 = curve, type 0 = line
             * spiked 1 = true, spiked 0 = false
             * arrow 1 = true, arrow 0 = false
             */
            if(number == 0){
                mainWindow.edge_type_sel(0,0,0);
                edgeTypeSelButton.iconsource = "resources/line.png";
            }
            else if(number == 1){
                mainWindow.edge_type_sel(0,1,0);
                edgeTypeSelButton.iconsource = "resources/linespike.png";
            }
            else if(number == 2){
                mainWindow.edge_type_sel(1,0,0);
                edgeTypeSelButton.iconsource = "resources/curve.png";
            }
            else{
                mainWindow.edge_type_sel(1,1,0);
                edgeTypeSelButton.iconsource = "resources/curvespike.png";
            }
        }
    } // end of edge type toolbar

    // Node shape toolbar
    NodeShapeToolbar {
        id: nodeShapeToolbar
        anchors.right: parent.right
        anchors.rightMargin: menu.width
        animationDuration: 200
        opacity: 0
        z: 4
        y: nodeShapeSelButton.y

        onClicked: {
            /*
             * type 1 = curve, type 0 = line
             * spiked 1 = true, spiked 0 = false
             * arrow 1 = true, arrow 0 = false
             */
            mainWindow.node_shape_sel(number);
            if(number == 0)
                nodeShapeSelButton.iconsource = "resources/rectangle.png";
            else
                nodeShapeSelButton.iconsource = "resources/circle.png";
        }
    } // end of node shape toolbar

    /**
     * Layout
     */

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
            //scale: zoom
            transform: Scale {id: zoomScale}


            onWidthChanged: {
                gridcanvas.requestPaint();
                mainWindow.window_resize(width, height);
            }

            onHeightChanged: {
                gridcanvas.requestPaint();
                mainWindow.window_resize(width, height);
            }

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


            // Active node highlighter
            NodeHighlighter {
                id: nodeHighlighter
                shape: mainWindow.activeNodeShape
                width: mainWindow.activeNodeWidth + 30
                height: mainWindow.activeNodeHeight + 30
                color: "#d8d8d8"
                visible: mainWindow.hasActiveNode
                x: mainWindow.activeNodeX - width/2
                y: mainWindow.activeNodeY - height/2
            } // end of active node highlighter

            // Workspace mouse area
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                acceptedButtons: Qt.Wheel | Qt.LeftButton | Qt.RightButton

                onWheel: {
                    if((wheel.angleDelta.y < 0)&&(zoomScale.xScale <= 2.95)){
                        zoomIndicator.show = true
                        zoomIndicator.restart()
                        zoomScale.xScale += 0.1
                        zoomScale.yScale += 0.1
                        zoomScale.origin.x = wheel.x
                        zoomScale.origin.y = wheel.y
                    }
                    else if((wheel.angleDelta.y > 0)&&(zoomScale.yScale >= 0.35)){
                        zoomIndicator.show = true
                        zoomIndicator.restart()
                        zoomScale.xScale -= 0.1
                        zoomScale.yScale -= 0.1
                        zoomScale.origin.x = wheel.x
                        zoomScale.origin.y = wheel.y
                    }
                }

                onDoubleClicked: {
                    if(mouse.button == Qt.LeftButton)
                        mainWindow.create_node(mouse.x, mouse.y)
                }

                onClicked: {
                    if(mouse.button == Qt.LeftButton){
                        mainWindow.lose_focus()
                        mainWindow.toggleToolbar()
                    }
                }

                onPositionChanged: {
                    if(mainWindow.connecting == true)
                        mainWindow.mouse_position(mouse.x, mouse.y)
                }
            } // end of workspace mouse area
        } // end of workspace

        /**
         * Following column contains right hand side
         * toolbars, buttons, controls etc
         */

        // Toolbar menu
        Column {
            id: menu
            width: 100
            z: 4

            // Save button
            CustomButton {
                height: 40
                width: parent.width
                color: mainWindow.menuIdleButtonColor
                hovercolor: mainWindow.menuHoveredButtonColor
                iconsource: "resources/save.png"
                textvalue: "Save"
                onClicked: mainWindow.save()
            } // end of save button

            // Load button
            CustomButton {
                height: 40
                width: parent.width
                nohovercolor: mainWindow.menuIdleButtonColor
                hovercolor: mainWindow.menuHoveredButtonColor
                iconsource: "resources/load.png"
                textvalue: "Load"
                onClicked: mainWindow.load()
            } // end of load button

            // Simple text label
            MenuLabel {
                text: "Node"
                height: 40
                width: parent.width
            }

            // Node shape selection button - opens up node shape toolbar
            CustomButton {
                id: nodeShapeSelButton
                objectName: "nodeShapeSelButton"
                height: 40
                width: parent.width
                nohovercolor: mainWindow.menuIdleButtonColor
                hovercolor: mainWindow.menuHoveredButtonColor
                textvalue: "Shape"
                iconsource: "resources/rectangle.png"
                onClicked: {
                    hoverEnabled = !hoverEnabled;
                    mainWindow.toggleToolbar(objectName);
                    nodeShapeToolbar.show = !nodeShapeToolbar.show;
                }
            } // end of node shape selection button

            // Node color selection button - opens up node color toolbar
            CustomButton {
                id: nodeColorSelButton
                objectName: "nodeColorSelButton"
                height: 40
                width: parent.width
                nohovercolor: mainWindow.menuIdleButtonColor
                hovercolor: mainWindow.menuHoveredButtonColor
                textvalue: "Color"
                iconcolor: "#9dd2e7"
                onClicked: {
                    hoverEnabled = !hoverEnabled;
                    mainWindow.toggleToolbar(objectName);
                    nodeColorToolbar.show = !nodeColorToolbar.show;
                }
            } // end of node color selection button

            // Node width control text input field
            MenuInputField {
                id: nodeWidthControl
                width: parent.width
                height: 40
                maximumLength: 8
                padding: 10
                placeholder: qsTr("Width")
                onChanged: mainWindow.node_width_changed(value)
            } // end of node width control

            // Node height control text input field
            MenuInputField {
                id: nodeHeightControl
                width: parent.width
                height: 40
                maximumLength: 8
                padding: 10
                placeholder: qsTr("Height")
                onChanged: mainWindow.node_height_changed(value)
            } // end of node height control

            // Simple label
            MenuLabel {
                text: "Edge"
                height: 40
                width: parent.width
            }

            // Edge type selection button - opens up edge type toolbar
            CustomButton {
                id: edgeTypeSelButton
                objectName: "edgeTypeSelButton"
                height: 40
                width: parent.width
                nohovercolor: mainWindow.menuIdleButtonColor
                hovercolor: mainWindow.menuHoveredButtonColor
                textvalue: "Type"
                iconsource: "resources/line.png"
                onClicked: {
                    hoverEnabled = !hoverEnabled;
                    mainWindow.toggleToolbar(objectName);
                    edgeTypeToolbar.show = !edgeTypeToolbar.show;
                }
            } // end of edge type selection button

            // Edge color selection button - opens up edge color toolbar
            CustomButton {
                id: edgeColorSelButton
                objectName: "edgeColorSelButton"
                height: 40
                width: parent.width
                nohovercolor: mainWindow.menuIdleButtonColor
                hovercolor: mainWindow.menuHoveredButtonColor
                textvalue: "Color"
                iconcolor: "#9dd2e7"
                onClicked: {
                    hoverEnabled = !hoverEnabled;
                    mainWindow.toggleToolbar(objectName);
                    edgeColorToolbar.show = !edgeColorToolbar.show;
                }
            } // end of edge color selection button

            // Edge thickness control text field
            MenuInputField {
                id: edgeThicknessControl
                width: parent.width
                height: 40
                maximumLength: 8
                padding: 10
                placeholder: qsTr("Thickness")
                onChanged: mainWindow.edge_thickness_changed(value)
            } // end of edge thickness control
        } // end of toolbar menu
    } // end of layout
} // end of main window
