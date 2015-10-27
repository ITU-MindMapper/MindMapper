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
        self.assertIn("id='0'", str(node))
        self.assertIn("</node>", str(node))

    def _check_text(self, text):
        self.assertIn("<text ", str(text))
        self.assertIn("color='#000000'", str(text))
        self.assertIn("size='0'", str(text))
        self.assertIn("font='lol'", str(text))
        self.assertIn("ExampleText", str(text))
        self.assertIn("</text>", str(text))

    def _check_annotation(self, anno):
        self.assertIn("<annotation>", str(anno))
        self.assertIn("ExampleAnnotation", str(anno))
        self.assertIn("</annotation>", str(anno))

    def test_node(self):
        _xml = fromstring("<node x='0' y='0' id='0' shape='classic' " +
                          "background='#000000' padding='0' size='50'>" +
                          "</node>")
        node = Node()
        node.deserialize(_xml)
        self._check_node(node)

    def test_edge(self):
        _xml = fromstring("<edge type='auto' x='0' y='0' thickness='50' " +
                          "color='#ffffff' node1='540' node2='0' />")
        edge = Edge()
        edge.deserialize(_xml)
        self._check_edge(edge)

    def test_text(self):
        _xml = fromstring("<node x='0' y='0' id='0' shape='classic' " +
                          "background='#000000' padding='0' size='50'>" +
                          "<text size='0' color='#000000' font='lol'>" +
                          "ExampleText</text></node>")
        node = Node()
        node.deserialize(_xml)
        self._check_text(node)

    def test_annotation(self):
        _xml = fromstring("<node x='0' y='0' id='0' shape='classic' " +
                          "background='#000000' padding='0' size='50'>" +
                          "<annotation>ExampleAnnotation</annotation></node>")
        node = Node()
        node.deserialize(_xml)
        self._check_annotation(node)

    def test_project(self):
        _xml = fromstring(
            "<project><edge type='auto' x='0' y='0' thickness='50' " +
            "color='#ffffff' node1='540' node2='0' />" +
            "<node x='0' y='0' id='0' shape='classic' " +
            "background='#000000' padding='0' size='50'>" +
            "<text size='0' color='#000000' font='lol'>ExampleText</text>" +
            "<annotation>ExampleAnnotation</annotation>" +
            "</node></project>")
        proj = Project()
        proj.deserialize(_xml)
        self._check_edge(proj)
        self._check_node(proj)
        self._check_text(proj)
        self._check_annotation(proj)

    def test_node_fail(self):
        node = Node()
        _xml = fromstring("<node x='0' y='0' id='0' shape='classic' " +
                          "background='#000000' padding='0' size='50' " +
                          "non_existing_attribute='value'>" +
                          "</node>")
        self.assertRaises(AttributeError, node.deserialize, _xml)
        _xml = fromstring("<node x='0' y='0' id='0' shape='classic' " +
                          "background='#000000' padding='0' size='50'>" +
                          "FalseValue</node>")
        self.assertRaises(ValueError, node.deserialize, _xml)
        _xml = fromstring("<node x='0' y='0' id='0' shape='classic' " +
                          "background='#000000' padding='0'>" +
                          "</node>")
        self.assertRaises(AttributeError, node.deserialize, _xml)

    def test_edge_fail(self):
        edge = Edge()
        _xml = fromstring("<edge type='auto' x='0' y='0' thickness='50' " +
                          "color='#ffffff' node1='540' node2='0' a='0' />")
        self.assertRaises(AttributeError, edge.deserialize, _xml)
        _xml = fromstring("<edge type='auto' x='0' y='0' thickness='50' " +
                          "color='#ffffff' node1='540' node2='0'>" +
                          "Value</edge>")
        self.assertRaises(ValueError, edge.deserialize, _xml)
        _xml = fromstring("<edge type='auto' x='0' y='0' thickness='50' " +
                          "color='#ffffff' node1='540' />")
        self.assertRaises(AttributeError, edge.deserialize, _xml)

    def test_text_fail(self):
        node = Node()
        _xml = fromstring("<node x='0' y='0' id='0' shape='classic' " +
                          "background='#000000' padding='0' size='50'>" +
                          "<text size='0' color='#000000' font='lol' " +
                          "add='0'>ExampleText</text></node>")
        self.assertRaises(AttributeError, node.deserialize, _xml)
        _xml = fromstring("<node x='0' y='0' id='0' shape='classic' " +
                          "background='#000000' padding='0' size='50'>" +
                          "<text size='0' color='#000000'>" +
                          "ExampleText</text></node>")
        self.assertRaises(AttributeError, node.deserialize, _xml)
