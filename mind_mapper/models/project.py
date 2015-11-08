from mind_mapper.models.edge import Edge
from mind_mapper.models.node import Node
import re


class Project(object):

    def __init__(self):
        self.nodes = {}
        self.edges = {}

    def append(self, leaf):
        if type(leaf) == Edge:
            self.edges[leaf.id] = leaf
        elif type(leaf) == Node:
            self.nodes[leaf.id] = leaf

    def __str__(self):
        return "<project>\n" +\
            "".join([str(node) for _, node in self.nodes.items()]) +\
            "".join([str(edge) for _, edge in self.edges.items()]) +\
            "</project>\n"

    def deserialize(self, xml):
        if xml.text and re.search(r"\w", str(xml.text)):
            raise ValueError(
                "Project shouldn't have text value! But has:\n'" +
                xml.text + "'")
        if xml.attrib.keys():
            raise AttributeError(
                "Project shouldn't have attributes!" +
                "\nDiff: " + str(xml.attrib.keys()))
        for node in xml.iterfind("node"):
            n = Node()
            n.deserialize(node)
            self.nodes[n.id] = n
        for edge in xml.iterfind("edge"):
            e = Edge()
            e.deserialize(edge)
            self.edges[e.id] = e
