from support import MMTestCase
from mind_mapper.models.project import Project
from mind_mapper.models.node import Node
from mind_mapper.models.edge import Edge
from xml.etree.ElementTree import fromstring


class TestSerialization(MMTestCase):

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

    def _check_xml_node(self, node):
        self.assertIn('<node ', str(node))
        self.assertIn("x='0'", str(node))
        self.assertIn("y='0'", str(node))
        self.assertIn("background='#000000'", str(node))
        self.assertIn("shape='classic'", str(node))
        self.assertIn("size='50'", str(node))
        self.assertIn("padding='0'", str(node))
        self.assertIn("/>", str(node))

    def test_node(self):
        node = Node(id="0", x=0, y=0, background="#000000", shape="classic",
                    size=50, padding=0, text='', annotation='')
        self._check_node(node)

    def test_edge(self):
        edge = Edge(type='auto', thickness=50, color='#ffffff',
                    node1=540, node2=0, x=0, y=0)
        self._check_edge(edge)

    def test_project(self):
        proj = Project()
        proj.append(
            Node(id="0", x=0, y=0, background="#000000",
                 shape="classic", size=50, padding=0, text='', annotation=''))
        proj.append(
            Edge(type='auto', thickness=50, color='#ffffff',
                 node1=540, node2=0, x=0, y=0))
        self.assertIn("<project>", str(proj))
        self.assertIn("</project>", str(proj))
        self._check_node(proj)
        self._check_edge(proj)

    def test_xml_parse(self):
        proj = Project()
        proj.append(
            Node(id="0", x=0, y=0, background="#000000",
                 shape="classic", size=50, padding=0, text='', annotation=''))
        proj.append(
            Edge(type='auto', thickness=50, color='#ffffff',
                 node1=540, node2=0, x=0, y=0))
        xml = fromstring(str(proj))
        for node in xml.iterfind("node"):
            self._check_xml_node(self._xml_to_str(node))
        for edge in xml.iterfind("edge"):
            self._check_edge(self._xml_to_str(edge))

    def _xml_to_str(self, node):
        return "<" + node.tag + " " +\
            " ".join([key + "='" + value + "'"
                      for key, value in node.items()]) +\
            " />"
