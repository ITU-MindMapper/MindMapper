from mind_mapper.models.node import Node
from mind_mapper.models.edge import Edge
from mind_mapper.models.annotation import Annotation
from mind_mapper.models.text import Text
import logging


class Controller(object):

    NODE_IDS = 0
    EDGE_IDS = 0

    def __init__(self, view_manager):
        self.view_manager = view_manager
        self.node_shape = 0
        self.node_width = 100
        self.node_height = 50
        self.node_background = "#afd8a3"

        self.edge_thickness = 1
        self.edge_type = 0

        self.connectNode = None

        self.nodes = {}
        self.nodeViews = {}
        self.edges = {}
        self.edgeViews = {}

    def create_node(self, x, y):
        node = Node(x=x, y=y, background=self.node_background,
                    shape=self.node_shape, width=self.node_width,
                    height=self.node_height, id=self.NODE_IDS, text=Text(),
                    annotation=Annotation())
        self.nodes[self.NODE_IDS] = node
        self.nodeViews[self.NODE_IDS] = self.view_manager.create_node(node)
        self.NODE_IDS += 1
        self.node_shape = (self.node_shape + 1) % 2

    def create_edge(self, node1, node2):
        edge = Edge(x=int((node1.x + node2.x) / 2),
                    y=int((node1.y + node2.y) / 2),
                    thickness=self.edge_thickness, type=self.edge_type,
                    node1=node1, node2=node2, id=self.EDGE_IDS, color=None)
        self.edges[self.EDGE_IDS] = edge
        self.edgeViews[self.EDGE_IDS] = self.view_manager.create_edge(edge)
        self.EDGE_IDS += 1

    def node_text_changed(self, id, text):
        logging.debug('Text of node ' + str(id) + ' changed to: ' + text)
        self.nodes[int(id)].text.text = text

    def node_annot_changed(self, id, text):
        self.nodes[id].annotation = Annotation(text=text)
        self.view_manager.node_update(self.nodes[int(id)])

    def node_position_changed(self, id, x, y):
        logging.debug('Position of node ' + str(id) + ' changed to: [' +
                      str(int(x)) + ',' + str(int(y)) + ']')
        self.nodes[int(id)].x = int(x)
        self.nodes[int(id)].y = int(y)
        self.view_manager.node_update(self.nodes[int(id)])

        # Edge modification
        start_ids = []
        end_ids = []
        for key, edge in self.edges.items():
            if edge.node1.id == int(id):
                start_ids.append(edge.id)
            elif edge.node2.id == int(id):
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
        del self.nodes[int(id)]
        invalid_edges = []
        for key, edge in self.edges.items():
            if ((edge.node1.id == int(id)) or (edge.node2.id == int(id))):
                invalid_edges.append(key)
        for edge_id in invalid_edges:
            self.edge_delete(edge_id)
        if self.connectNode.id == int(id):
            self.connectNode = None

    def edge_delete(self, id):
        logging.debug('Delete of edge ' + str(id) + ' issued')
        self.edgeViews[int(id)].deleteLater()
        del self.edgeViews[int(id)]
        del self.edges[int(id)]

    def edge_position_changed(self, id, x, y):
        logging.debug('Position of edge ' + str(id) + ' ctrpoint changed to: ['
                      + str(int(x)) + ',' + str(int(y)) + ']')
        self.edges[int(id)].x = int(x)
        self.edges[int(id)].y = int(y)

    def node_connect(self, id):
        if self.connectNode is None:
            self.connectNode = self.nodes[int(id)]
        elif self.connectNode.id != int(id):
            endNode = self.nodes[int(id)]
            self.create_edge(self.connectNode, endNode)
            self.connectNode = None
