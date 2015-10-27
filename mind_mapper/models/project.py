from mind_mapper.models import Model
from mind_mapper.models.edge import Edge
from mind_mapper.models.node import Node
import re


class Project(Model):

    def __init__(self):
        self.leafs = []

    def append(self, leaf):
        self.leafs.append(leaf)

    def __str__(self):
        return "<project>\n" +\
            "".join([str(leaf) for leaf in self.leafs]) +\
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
            self.leafs.append(n)
        for edge in xml.iterfind("edge"):
            e = Edge()
            e.deserialize(edge)
            self.leafs.append(e)
