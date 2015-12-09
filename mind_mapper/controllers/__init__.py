from mind_mapper.models.node import Node
from mind_mapper.models.edge import Edge
from mind_mapper.models.annotation import Annotation
from mind_mapper.models.text import Text
import logging
import os
from mind_mapper.models.project import Project
from xml.etree.ElementTree import fromstring
from PyQt5.QtCore import QFile


class Controller(object):

    NODE_IDS = 0
    EDGE_IDS = 0

    def __init__(self, view_manager):
        self.view_manager = view_manager
        self.node_shape = 0
        self.node_width = 0
        self.node_height = 0
        self.node_background = "#9dd2e7"
        self.node_text_color = "black"
        self.node_text_font = "Sans Serif"
        self.node_text_size = 14
        self.active_node = None
        self.active_edge = None
        self.edge_color = "#9dd2e7"
        self.edge_thickness = 0
        self.edge_spiked = 0
        self.edge_arrow = 0
        self.edge_type = 0
        self.connectNode = None
        self.project = Project()
        self.nodeViews = {}
        self.edgeViews = {}

    def load(self, what):
        # open file and load project
        if what != "":
            xml = QFile(what.toLocalFile())
        else:
            xml = QFile("temp")
        if xml.open(QFile.ReadOnly):
            self.project.deserialize(fromstring(xml.readAll()))
        if(what == ""):
            os.remove("./temp")
        self.view_manager._main.rootObject().setProperty(
            "workspaceHeight", int(self.project.workspace_height))
        self.view_manager._main.rootObject().setProperty(
            "workspaceWidth", int(self.project.workspace_width))

        # create views
        for id in self.project.nodes:
            self.nodeViews[id] = self.view_manager.create_node(
                self.project.nodes[id])
            # node_ids should be biggest of loaded ids
            if self.NODE_IDS <= id:
                self.NODE_IDS = id + 1
        # create edges
        for id in self.project.edges:
            self.edgeViews[id] = self.view_manager.create_edge(
                self.project.edges[id],
                self.project.nodes[self.project.edges[id].node1],
                self.project.nodes[self.project.edges[id].node2])
            # egde_ids should be biggest of loaded ids
            if self.EDGE_IDS <= id:
                self.EDGE_IDS = id + 1

    def exporting(self):
        try:
            os.mkdir("export")
        except:
            pass

    def save(self, where):
        try:
            os.mkdir("save")
        except:
            pass
        where = "save/" + where
        if where != "":
            if where[-4:] != ".xml":
                where += ".xml"
        else:
            where = "temp"
        with open(where, "w") as out:
            out.write(str(self.project))

    def create_node(self, x, y):
        height = self.node_height
        if height == 0:
            height = 100
        width = self.node_width
        if width == 0:
            width = 100
        node = Node(x=int(x), y=int(y), background=self.node_background,
                    shape=self.node_shape, width=width,
                    height=height, id=self.NODE_IDS, text=Text(
                        font=self.node_text_font, size=self.node_text_size,
                        color=self.node_text_color, text=""),
                    annotation=Annotation())
        if self.node_shape == 2:
            node.background = ""
        self.project.append(node)
        self.nodeViews[self.NODE_IDS] = self.view_manager.create_node(node)
        self.NODE_IDS += 1
        self.active_node = None
        self.node_focus(node.id)

    def create_edge(self, node1, node2):
        thickness = self.edge_thickness
        if thickness == 0:
            thickness = 10
        edge = Edge(x=int((node1.x + node2.x) / 2),
                    y=int((node1.y + node2.y) / 2),
                    thickness=thickness, type=self.edge_type,
                    spiked=self.edge_spiked, arrow=self.edge_arrow,
                    node1=node1.id, node2=node2.id, id=self.EDGE_IDS,
                    color=self.edge_color)
        self.project.edges[self.EDGE_IDS] = edge
        self.edgeViews[self.EDGE_IDS] = self.view_manager.create_edge(
            edge, node1, node2)
        self.EDGE_IDS += 1
        self.edge_focus(edge.id)

    def node_text_changed(self, id, text):
        logging.debug('Text of node ' + str(id) + ' changed to: ' + text)
        self.project.nodes[int(id)].text.text = text

    def node_annot_changed(self, id, text):
        self.project.nodes[id].annotation = Annotation(text=text)
        self.view_manager.node_update(self.project.nodes[int(id)])

    def node_position_changed(self, id, x, y):
        logging.debug('Position of node ' + str(id) + ' changed to: [' +
                      str(int(x)) + ',' + str(int(y)) + ']')
        self.active_node.x = int(x)
        self.active_node.y = int(y)
        self.view_manager._main.rootObject().setProperty(
            "activeNodeX", int(x))
        self.view_manager._main.rootObject().setProperty(
            "activeNodeY", int(y))
        self.view_manager.node_update(self.project.nodes[int(id)])

        # Connection indicator modification
        if self.connectNode is not None:
            if self.connectNode.id == int(id):
                self.view_manager._main.rootObject().setProperty(
                    "connectingFromX", x)
                self.view_manager._main.rootObject().setProperty(
                    "connectingFromY", y)
                self.view_manager._main.rootObject().setProperty(
                    "connectingToX", x)
                self.view_manager._main.rootObject().setProperty(
                    "connectingToY", y)

        # Edge modification
        start_ids = []
        end_ids = []
        for key, edge in self.project.edges.items():
            if edge.node1 == int(id):
                start_ids.append(edge.id)
            elif edge.node2 == int(id):
                end_ids.append(edge.id)

        for key, view in self.edgeViews.items():
            if key in start_ids:
                view.rootObject().setProperty("startX", str(x))
                view.rootObject().setProperty("startY", str(y))
            elif key in end_ids:
                view.rootObject().setProperty("endX", str(x))
                view.rootObject().setProperty("endY", str(y))

    def clear_workspace(self):
        node_keys = list(self.project.nodes.keys())
        for id in node_keys:
            self.node_delete(int(id))
        self.NODE_IDS = 0
        self.EDGE_IDS = 0

    def node_delete(self, id):
        logging.debug('Delete of node ' + str(id) + ' issued')
        self.nodeViews[int(id)].deleteLater()
        del self.nodeViews[int(id)]
        del self.project.nodes[int(id)]
        invalid_edges = []
        for key, edge in self.project.edges.items():
            if ((edge.node1 == int(id)) or (edge.node2 == int(id))):
                invalid_edges.append(key)
        for edge_id in invalid_edges:
            self.edge_delete(edge_id)
        if self.connectNode and self.connectNode.id == int(id):
            self.connectNode = None
        self.active_node = None
        self.view_manager._main.rootObject().setProperty(
            "hasActiveNode", False)

    def edge_delete(self, id):
        logging.debug('Delete of edge ' + str(id) + ' issued')
        self.edgeViews[int(id)].deleteLater()
        del self.edgeViews[int(id)]
        del self.project.edges[int(id)]
        self.active_edge = None
        self.view_manager._main.rootObject().setProperty(
            "hasActiveEdge", False)

    def edge_position_changed(self, id, x, y):
        self.project.edges[int(id)].x = int(x)
        self.project.edges[int(id)].y = int(y)
        logging.debug('Position of edge ' + str(id) + ' ctrpoint changed' +
                      ' to: [' + str(int(x)) + ',' + str(int(y)) + ']\n' +
                      str(self.project.edges[int(id)]))

    def node_connect(self, id):
        if self.connectNode is None:
            self.connectNode = self.project.nodes[int(id)]
            self.view_manager._main.rootObject().setProperty(
                "connectingFromX", self.connectNode.x)
            self.view_manager._main.rootObject().setProperty(
                "connectingFromY", self.connectNode.y)
            self.view_manager._main.rootObject().setProperty(
                "connectingToX", self.connectNode.x)
            self.view_manager._main.rootObject().setProperty(
                "connectingToY", self.connectNode.y)
            self.view_manager._main.rootObject().setProperty(
                "connecting", True)
        elif self.connectNode.id != int(id):
            self.view_manager._main.rootObject().setProperty(
                "connecting", False)
            self.create_edge(self.connectNode, self.project.nodes[int(id)])
            self.connectNode = None

    def mouse_position(self, x, y):
        self.view_manager._main.rootObject().setProperty("connectingToX", x)
        self.view_manager._main.rootObject().setProperty("connectingToY", y)

    def lose_focus(self):
        self.connectNode = None
        self.view_manager._main.rootObject().setProperty(
            "connecting", False)
        self.view_manager._main.rootObject().setProperty(
            "hasActiveNode", False)
        if (self.active_node is not None):
            self.nodeViews[self.active_node.id].rootObject().setProperty(
                "inputting", False)
        self.active_node = None
        self.edge_transfer_active_to(None)

    def node_color_sel(self, color):
        self.node_background = color.name()
        if (self.active_node is not None)and(self.active_node.shape != 2):
            self.nodeViews[self.active_node.id].rootObject().setProperty(
                "background", str(color.name()))
            self.active_node.background = str(color.name())

    def node_text_color_sel(self, color):
        self.node_text_color = color.name()
        if self.active_node is not None:
            self.nodeViews[self.active_node.id].rootObject().setProperty(
                "textColor", str(color.name()))
            self.active_node.text.color = str(color.name())
            self.view_manager._main.rootObject().setProperty(
                "activeNodeTextColor", str(color.name()))

    def edge_color_sel(self, color):
        self.edge_color = color.name()
        if self.active_edge is not None:
            self.edgeViews[self.active_edge.id].rootObject().setProperty(
                "color", str(color.name()))
            self.active_edge.color = str(color.name())

    def edge_type_sel(self, type, spiked, arrow):
        self.edge_type = int(type)
        self.edge_spiked = int(spiked)
        self.edge_arrow = int(arrow)

    def node_shape_sel(self, shape):
        self.node_shape = int(shape)

    def workspace_height_changed(self, height):
        self.project.workspace_height = int(height)
        logging.debug('New window height: ' + str(height))
        for key, view in self.edgeViews.items():
            view.rootObject().setProperty("workspaceHeight", str(height))
        for key, view in self.nodeViews.items():
            view.rootObject().setProperty("workspaceHeight", str(height))

    def workspace_width_changed(self, width):
        self.project.workspace_width = int(width)
        logging.debug('New window width: ' + str(width))
        for key, view in self.edgeViews.items():
            view.rootObject().setProperty("workspaceWidth", str(width))
        for key, view in self.nodeViews.items():
            view.rootObject().setProperty("workspaceWidth", str(width))

    def node_focus(self, id):
        self.active_node = self.project.nodes[int(id)]
        self.view_manager._main.rootObject().setProperty(
            "hasActiveNode", False)
        if self.active_node.shape != 2:
            self.view_manager._main.rootObject().setProperty(
                "activeNodeColor", str(self.active_node.background))
        self.view_manager._main.rootObject().setProperty(
            "activeNodeShape", self.active_node.shape)
        self.view_manager._main.rootObject().setProperty(
            "activeNodeWidth", self.active_node.width)
        self.view_manager._main.rootObject().setProperty(
            "activeNodeHeight", self.active_node.height)
        self.view_manager._main.rootObject().setProperty(
            "activeNodeX", self.active_node.x)
        self.view_manager._main.rootObject().setProperty(
            "activeNodeY", self.active_node.y)
        self.view_manager._main.rootObject().setProperty(
            "activeNodeText", str(self.active_node.text.text))
        self.view_manager._main.rootObject().setProperty(
            "activeNodeTextSize", self.active_node.text.size)
        self.view_manager._main.rootObject().setProperty(
            "activeNodeTextColor", str(self.active_node.text.color))
        self.view_manager._main.rootObject().setProperty(
            "hasActiveNode", True)

    def edge_focus(self, id):
        self.edge_transfer_active_to(int(id))
        self.view_manager._main.rootObject().setProperty(
            "hasActiveEdge", False)
        self.view_manager._main.rootObject().setProperty(
            "activeEdgeColor", str(self.active_edge.color))
        self.view_manager._main.rootObject().setProperty(
            "activeEdgeThickness", self.active_edge.thickness)
        self.view_manager._main.rootObject().setProperty(
            "activeEdgeType", self.active_edge.type)
        self.view_manager._main.rootObject().setProperty(
            "activeEdgeSpiked", self.active_edge.spiked)
        self.view_manager._main.rootObject().setProperty(
            "activeEdgeArrow", self.active_edge.arrow)
        self.view_manager._main.rootObject().setProperty(
            "hasActiveEdge", True)

    def node_width_changed(self, width):
        self.node_width = int(width)
        if self.active_node is not None:
            real_x = int(self.active_node.x - int(width) / 2)
            self.active_node.width = int(width)
            self.nodeViews[self.active_node.id].rootObject().setProperty(
                "width", int(width))
            self.nodeViews[self.active_node.id].rootObject().setX(real_x)
            self.view_manager._main.rootObject().setProperty(
                "activeNodeWidth", int(width))
            self.view_manager._main.rootObject().setProperty(
                "activeNodeX", int(self.active_node.x))

    def node_height_changed(self, height):
        self.node_height = int(height)
        if self.active_node is not None:
            real_y = int(self.active_node.y - int(height) / 2)
            self.active_node.height = int(height)
            self.nodeViews[self.active_node.id].rootObject().setProperty(
                "height", int(height))
            self.nodeViews[self.active_node.id].rootObject().setY(real_y)
            self.view_manager._main.rootObject().setProperty(
                "activeNodeHeight", int(height))
            self.view_manager._main.rootObject().setProperty(
                "activeNodeY", int(self.active_node.y))

    def node_text_size_changed(self, size):
        self.node_text_size = int(size)
        if self.active_node is not None:
            self.active_node.text.size = int(size)
            self.nodeViews[self.active_node.id].rootObject().setProperty(
                "textSize", int(size))
            self.view_manager._main.rootObject().setProperty(
                "activeNodeTextSize", int(size))

    def node_image_loaded(self, source):
        if self.active_node is not None:
            self.active_node.background = source.toString()

    def edge_thickness_changed(self, thickness):
        self.edge_thickness = thickness
        if self.active_edge is not None:
            self.active_edge.thickness = int(thickness)
            self.edgeViews[self.active_edge.id].rootObject().setProperty(
                "thickness", int(thickness))
            self.view_manager._main.rootObject().setProperty(
                "activeEdgeThickness", int(thickness))

    def edge_transfer_active_to(self, id):
        if self.active_edge is not None:
            self.edgeViews[self.active_edge.id].rootObject().setProperty(
                "isActive", False)
        if id is not None:
            self.active_edge = self.project.edges[int(id)]
            self.edgeViews[self.active_edge.id].rootObject().setProperty(
                "isActive", True)
        else:
            self.active_edge = None

    def hide_edge_controls(self):
        for key, view in self.edgeViews.items():
            view.rootObject().setProperty("showCtrlPoint", False)

    def show_edge_controls(self):
        for key, view in self.edgeViews.items():
            view.rootObject().setProperty("showCtrlPoint", True)
