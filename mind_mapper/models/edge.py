from mind_mapper.models import Model
import re


class Edge(Model):

    def __init__(self, **kwargs):
        super(Edge, self).__init__({
            "id": None,
            "type": None,
            "thickness": None,
            "spiked": None,
            "arrow": None,
            "color": None,
            "node1": None,
            "node2": None,
            "x": None,
            "y": None,
        }, kwargs)

    def __str__(self):
        return "<edge " + self.serialize_dict() +\
            " />\n"

    def deserialize(self, xml):
        if xml.text and re.search(r"\w", str(xml.text)):
            raise ValueError(
                "Edge shouldn't have text value! But has:\n'" + xml.text + "'")
        if self.keys() != xml.attrib.keys():
            raise AttributeError(
                "Edge has not enough/too many attributes!" +
                "\nDiff: " + str(
                    self.attribute_diff(
                        self.keys(), xml.attrib.keys())))
        self.deserialize_attr(xml)
        self.id = int(self.id)
        self.type = int(self.type)
        self.thickness = int(self.thickness)
        self.spiked = int(self.spiked)
        self.arrow = int(self.arrow)
        self.node1 = int(self.node1)
        self.node2 = int(self.node2)
        self.x = int(self.x)
        self.y = int(self.y)

    __repr__ = __str__

    def get_position(self):
        ''' Return position of edge control point as a touple '''
        return (self.x, self.y)
