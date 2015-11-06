from mind_mapper.models.node import Node
from mind_mapper.models.annotation import Annotation
from mind_mapper.models.text import Text


class Controller(object):

    NODE_IDS = 0

    def __init__(self, view_manager):
        self.view_manager = view_manager
        self.node_shape = 0
        self.node_width = 100
        self.node_height = 50
        self.node_background = "#afd8a3"
        self.nodes = {}
        self.nodeViews = {}

    def create_node(self, x, y):
        node = Node(x=x, y=y, background=self.node_background,
                    shape=self.node_shape, width=self.node_width,
                    height=self.node_height, id=self.NODE_IDS, text=Text(),
                    annotation=Annotation())
        self.nodes[self.NODE_IDS] = node
        self.nodeViews[self.NODE_IDS] = self.view_manager.create_node(node)
        print("Nodes: " + str(self.nodes))
        print("NodeViews: " + str(self.nodeViews))
        self.NODE_IDS += 1
        self.node_shape = (self.node_shape + 1) % 2

    def node_text_changed(self, id, text):
        #self.nodes[id].text = Text(text=text, size=self.text_size,
        #                           color=self.text_color, font=self.text_font)
        #self.view_manager.node_update(self.nodes[int(id)])
        print("Text of node " + str(id) + " changed to: " + text)

    def node_annot_changed(self, id, text):
        self.nodes[id].annotation = Annotation(text=text)
        self.view_manager.node_update(self.nodes[int(id)])

    def node_position_changed(self, id, x, y):
        self.nodes[int(id)].x = int(x)
        self.nodes[int(id)].y = int(y)
        self.view_manager.node_update(self.nodes[int(id)])
        print("Position of node " + str(id) + " changed to: [" +
              str(x) + "," + str(y) + "]")

    def node_delete(self, id):
        self.nodeViews[int(id)].deleteLater()
        del self.nodeViews[int(id)]
        del self.nodes[int(id)]
        print("Delete of node " + str(id) + " issued")
