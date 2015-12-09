import QtQuick 2.5
import QtQuick.Dialogs 1.2

Item {
    
    // Id of the shape
    id: container

    // Object ID
    property var objectId
    property var workspaceWidth
    property var workspaceHeight

    // Background color
    property var background

    // Text
    property alias text:      text.nodetext
    property alias textFont:  text.textfont
    property alias textSize:  text.textsize
    property alias textColor: text.textcolor
    property alias inputting: text.inputting

    signal node_delete(var id)
    signal node_position_changed(var id, var x, var y)
    signal node_text_changed(var id, var new_text)
    signal node_connect(var id)
    signal node_focus(var id)
    signal node_image_loaded(var source)

    onBackgroundChanged: {
        if(container.background == "")
            fileDialog.open();
        else
            image.source = container.background;
    }

    FileDialog {
        id: fileDialog
        title: "Choose a file"
        folder: shortcuts.pictures
        selectMultiple: false
        nameFilters: [ "Image files (*.jpg *.png *.bmp *.jpeg)"]
        onAccepted: {
            image.source = fileDialog.fileUrl;
            container.node_image_loaded(image.source);
            fileDialog.close();
        }
        onRejected: {
            image.source = "../resources/noimage.png";
            container.node_image_loaded(image.source);
            fileDialog.close();
        }
    }

    Image {
        id: image
        sourceSize.width: container.width
        sourceSize.height: container.height
        property int errorCount: 0
        property string altSource: "../resources/noimage.png"
        onStatusChanged: {
            if (image.status == Image.Error) {
                errorCount += 1;
                if (errorCount == 1)
                    image.source = "";
                image.source = image.altSource;
            }
        }
    }

    // Text content
    Nodetext {
        id: text
        width: parent.width
        height: parent.height
        onTextChanged: container.node_text_changed(container.objectId, text.nodetext)
    }

    // MouseArea
    MouseArea {
        id: mouseArea
        objectName: "mouseArea"

        property var dragged: false
        property var ispress: false

        anchors.fill: parent
        
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        drag.target: container
        drag.axis: Drag.XandYAxis
        drag.minimumX: 0
        drag.minimumY: 0
        drag.maximumX: container.workspaceWidth - parent.width
        drag.maximumY: container.workspaceHeight - parent.height

        onClicked: {
            if(mouse.button == Qt.LeftButton){
                text.inputting = true;
                container.node_focus(container.objectId);
            }
            else if (mouse.button == Qt.RightButton)
                container.node_connect(container.objectId);
        }

        onDoubleClicked: {
            if(mouse.button == Qt.LeftButton)
                container.node_delete(container.objectId)
        }

        onPressed: {
            dragged = false
            ispress = true
            container.node_focus(container.objectId);
        }

        onPositionChanged: {
            dragged = true
            if(ispress == true)
                container.node_position_changed(
                    container.objectId,
                    container.x + container.width / 2,
                    container.y + container.height / 2);
        }

        onReleased: {
            dragged = false;
            ispress = false;
        }
    }
}
