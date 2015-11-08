from mind_mapper.models import Model
import re


class Edge(Model):

    def __init__(self, **kwargs):
        super(Edge, self).__init__()
        if kwargs:
            self.attributes = {
                "id": kwargs["id"],
                "type": kwargs["type"],
                "thickness": kwargs["thickness"],
                "color": kwargs["color"],
                "node1": kwargs["node1"],
                "node2": kwargs["node2"],
                "x": kwargs["x"],
                "y": kwargs["y"],
            }
        else:
            self.attributes = {
                "id": None,
                "type": None,
                "thickness": None,
                "color": None,
                "node1": None,
                "node2": None,
                "x": None,
                "y": None,
            }

    def __getattr__(self, attr):
        return self.attributes[attr]

    def __setattr__(self, attr, value):
        return super(Edge, self).__setattr__(attr, value)

    def __str__(self):
        return "<edge " + self.serialize_dict(self.attributes) +\
            " />\n"

    def deserialize(self, xml):
        if xml.text and re.search(r"\w", str(xml.text)):
            raise ValueError(
                "Edge shouldn't have text value! But has:\n'" + xml.text + "'")
        if self.attributes.keys() != xml.attrib.keys():
            raise AttributeError(
                "Edge has not enough/too many attributes!" +
                "\nDiff: " + str(
                    self.attribute_diff(
                        self.attributes.keys(), xml.attrib.keys())))
        self.deserialize_attr(xml, self.attributes)

    __repr__ = __str__

    def get_position(self):
        ''' Return position of edge control point as a touple '''
        return (self.x, self.y)
