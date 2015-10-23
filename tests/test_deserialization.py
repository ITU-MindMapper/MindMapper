from support import MMTestCase
from mind_mapper.models.project import Project
from mind_mapper.models.node import Node
from mind_mapper.models.edge import Edge
from xml.etree.ElementTree import fromstring


class TestDeserialization(MMTestCase):

    def _check_edge(self, edge):
        self.assertIn('<edge ', str(edge))
        self.assertIn("type='auto'", str(edge))
        self.assertIn("x='0'", str(edge))
        self.assertIn("y='0'", str(edge))
        self.assertIn("thickness='50'", str(edge))
        self.assertIn("color='#ffffff'", str(edge))
        self.assertIn("node1='540'", str(edge))
        self.assertIn("node2='0'", str(edge))
        self.assertIn("/>", str(edge))

    def _check_node(self, node):
        self.assertIn('<node ', str(node))
        self.assertIn("x='0'", str(node))
        self.assertIn("y='0'", str(node))
        self.assertIn("background='#000000'", str(node))
        self.assertIn("shape='classic'", str(node))
        self.assertIn("size='50'", str(node))
        self.assertIn("padding='0'", str(node))
        self.assertIn("</node>", str(node))

    def test_node(self):
        _xml = fromstring("<node x='0' y='0' thickness='50' shape='classic' " +
                          "background='#000000' padding='0' size='50' />")
        node = Node()
        node.deserialize(_xml)
        self._check_node(node)

    def test_edge(self):
        _xml = fromstring("<edge type='auto' x='0' y='0' thickness='50' " +
                          "color='#ffffff' node1='540' node2='0' />")
        edge = Edge()
        edge.deserialize(_xml)
        self._check_edge(edge)

    def test_project(self):
        _xml = fromstring(
            "<project><edge type='auto' x='0' y='0' thickness='50' " +
            "color='#ffffff' node1='540' node2='0' />" +
            "<node x='0' y='0' thickness='50' shape='classic' " +
            "background='#000000' padding='0' size='50' />" +
            "</project>")
        proj = Project()
        proj.deserialize(_xml)
        self._check_edge(proj)
        self._check_node(proj)
