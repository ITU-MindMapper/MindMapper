from PyQt5.QtCore import QUrl
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQuick import QQuickView
from mind_mapper.controllers import Controller
import sys
import os


class View(object):

    counter = 0

    shapes = ["rectangle", "ellipse"]

    def __init__(self):
        self._controller = Controller(self)
        self._gui = QGuiApplication(sys.argv)

        self._qml_dir = os.path.dirname(os.path.realpath(__file__))
        self._main = QQuickView()
        self._main.setResizeMode(QQuickView.SizeRootObjectToView)
        self._main.setSource(QUrl(self._qml_dir + '/main.qml'))

        self._main.rootObject().click.connect(self._controller.create_node)
        self._main.setProperty("width", 500)
        self._main.setProperty("height", 500)
        self._main.show()

    def run(self):
        return self._gui.exec_()

    def create_node(self, node):
        # Creates new node from source QML and puts it inside of main window
        qml_node = QQuickView(QUrl(self._qml_dir + '/shapes/' +
                                   self.shapes[node.shape] + '.qml'),
                              self._main)

        # Sets all properties
        qml_node.rootObject().setProperty("parent", self._main.rootObject())
        qml_node.rootObject().setProperty("objectId", str(node.id))
        qml_node.rootObject().setProperty("backgroundColor",
                                          str(node.background))
        qml_node.rootObject().setProperty("width", str(node.width))
        qml_node.rootObject().setProperty("height", str(node.height))
        qml_node.rootObject().setProperty("text", str(node.id))

        # Signal connection
        qml_node.rootObject().click.connect(self.clicked)
        qml_node.rootObject().position_changed.connect(
            self._controller.position_changed)

        # Position to mouse click
        qml_node.rootObject().setX(node.x - node.width / 2)
        qml_node.rootObject().setY(node.y - node.height / 2)
        self.counter += 1

    def node_update(self, node):
        pass

    def clicked(self, x):
        print(x)
