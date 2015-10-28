from PyQt5.QtCore import QUrl
from PyQt5.QtWidgets import QApplication, QWidget
from PyQt5.QtQuick import QQuickView
from mind_mapper.controllers import Controller
import logging
import sys
import os


class View(object):

    counter = 0

    shapes = ["rectangle"]

    def __init__(self):
        self._controller = Controller(self)
        self._gui = QApplication(sys.argv)
        self._qml_dir = os.path.dirname(os.path.realpath(__file__))
        main = QQuickView()
        main.setSource(QUrl(self._qml_dir + '/main.qml'))
        main.rootObject().click.connect(self._controller.create_node)
        self._main = QWidget.createWindowContainer(main)
        self._main.show()

    def run(self):
        return self._gui.exec_()

    def create_node(self, node):
        print(node.x, node.y)
        qml_node = QQuickView()
        qml_node.setSource(QUrl(self._qml_dir + '/shapes/' +
                                self.shapes[node.shape] + '.qml'))
        qml_node.rootObject().setProperty("value", str(node.id))
        qml_node.rootObject().setProperty("color", str(node.background))
        qml_node.rootObject().setProperty("width", str(node.size))
        qml_node.rootObject().setProperty("height", str(node.size))
        qml_node.rootObject().setProperty("padding", str(node.padding))
        qml_node.rootObject().click.connect(self.clicked)
        qml_node.rootObject().position_changed.connect(
            self._controller.position_changed)
        widget_node = QWidget.createWindowContainer(qml_node, self._main)
        widget_node.move(node.x, node.y)
        widget_node.show()
        logging.debug("Node has been created!\n{}".format(str(node)))
        self.counter += 1

    def clicked(self, x):
        print(x)
