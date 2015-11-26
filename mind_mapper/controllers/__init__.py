from mind_mapper.models.node import Node
from mind_mapper.models.edge import Edge
from mind_mapper.models.annotation import Annotation
from mind_mapper.models.text import Text
import logging
from mind_mapper.models.project import Project
from xml.etree.ElementTree import fromstring


class Controller(object):

    NODE_IDS = 0
    EDGE_IDS = 0

    def __init__(self, view_manager):
        self.view_manager = view_manager
        self.node_shape = 0
        self.node_width = 100
        self.node_height = 50
        self.node_background = "#9dd2e7"
        self.active_node = None
        self.edge_color = "#9dd2e7"
        self.edge_thickness = 10
        self.edge_spiked = 0
        self.edge_arrow = 0
        self.edge_type = 0
        self.connectNode = None
        self.project = Project()
        self.nodeViews = {}
        self.edgeViews = {}

    def load(self, what="temp.xml"):
        # Firstly we have to delete what is in memory
        node_keys = list(self.project.nodes.keys())
        for id in node_keys:
            self.node_delete(id)
        edge_keys = list(self.project.edges.keys())
        for id in edge_keys:
            self.edge_delete(id)
        self.NODE_IDS = 0
        self.EDGE_IDS = 0
        # open file and load project
        with open(what, "r") as xml:
            self.project.deserialize(fromstring(xml.read()))
        # create views
        for id in self.project.nodes:
            self.nodeViews[id] = self.view_manager.create_node(
                self.project.nodes[id])
            print("Loaded nodes: " + str(self.project.nodes))
            print("Loaded NodeViews: " + str(self.nodeViews))
            # node_ids should be biggest of loaded ids
            if self.NODE_IDS <= id:
                self.NODE_IDS = id + 1
        # create edges
        for id in self.project.edges:
            self.edgeViews[id] = self.view_manager.create_edge(
                self.project.edges[id],
                self.project.nodes[self.project.edges[id].node1],
                self.project.nodes[self.project.edges[id].node2])
            print("Loaded edges: " + str(self.project.edges))
            print("Loaded EdgeViews: " + str(self.edgeViews))
            # egde_ids should be biggest of loaded ids
            if self.EDGE_IDS <= id:
                self.EDGE_IDS = id + 1

    def save(self, where="temp.xml"):
        with open(where, "w") as out:
            out.write(str(self.project))

    def create_node(self, x, y):
        node = Node(x=int(x), y=int(y), background=self.node_background,
                    shape=self.node_shape, width=self.node_width,
                    height=self.node_height, id=self.NODE_IDS, text=Text(),
                    annotation=Annotation())
        self.project.append(node)
        self.nodeViews[self.NODE_IDS] = self.view_manager.create_node(node)
        self.NODE_IDS += 1
        self.active_node = None
        self.node_focus(node.id)

    def create_edge(self, node1, node2):
        print(node1.id, node2.id)
        edge = Edge(x=int((node1.x + node2.x) / 2),
                    y=int((node1.y + node2.y) / 2),
                    thickness=self.edge_thickness, type=self.edge_type,
                    spiked=self.edge_spiked, arrow=self.edge_arrow,
                    node1=node1.id, node2=node2.id, id=self.EDGE_IDS,
                    color=self.edge_color)
        self.project.edges[self.EDGE_IDS] = edge
        self.edgeViews[self.EDGE_IDS] = self.view_manager.create_edge(
            edge, node1, node2)
        self.EDGE_IDS += 1

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
        self.active_node = None

    def node_color_sel(self, color):
        self.node_background = color.name()
        if self.active_node is not None:
            self.nodeViews[self.active_node.id].rootObject().setProperty(
                "backgroundColor", str(color.name()))
            self.active_node.background = str(color.name())

    def edge_color_sel(self, color):
        self.edge_color = color.name()

    def edge_type_sel(self, type, spiked, arrow):
        self.edge_type = int(type)
        self.edge_spiked = int(spiked)
        self.edge_arrow = int(arrow)

    def node_shape_sel(self, shape):
        self.node_shape = int(shape)

    def window_resize(self, width, height):
        for key, view in self.edgeViews.items():
            view.rootObject().setProperty("workspaceWidth", str(width))
            view.rootObject().setProperty("workspaceHeight", str(height))
        for key, view in self.nodeViews.items():
            view.rootObject().setProperty("workspaceWidth", str(width))
            view.rootObject().setProperty("workspaceHeight", str(height))

    def node_focus(self, id):
        self.active_node = self.project.nodes[int(id)]

        self.view_manager._main.rootObject().setProperty(
            "hasActiveNode", False)
        self.view_manager._main.rootObject().setProperty(
            "activeNodeColor", str(self.active_node.background))
        self.view_manager._main.rootObject().setProperty(
            "activeNodeShape", self.active_node.shape)
        self.view_manager._main.rootObject().setProperty(
            "activeNodeWidth", self.active_node.width)
        self.view_manager._main.rootObject().setProperty(
            "activeNodeHeigth", self.active_node.height)
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
