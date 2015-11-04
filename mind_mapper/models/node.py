from mind_mapper.models import Model
from mind_mapper.models.annotation import Annotation
from mind_mapper.models.text import Text
import re


class Node(Model):

    def __init__(self, **kwargs):
        super(Node, self).__init__()
        if kwargs:
            self.attributes = {
                "id": kwargs["id"],
                "x": kwargs["x"],
                "y": kwargs["y"],
                "background": kwargs["background"],
                "shape": kwargs["shape"],
                "height": kwargs["height"],
                "width": kwargs["width"],
            }
            self.text = kwargs["text"]
            self.annotation = kwargs["annotation"]
        else:
            self.attributes = {
                "id": None,
                "x": None,
                "y": None,
                "background": None,
                "shape": None,
                "height": None,
                "width": None,
            }
            self.text = Text()
            self.annotation = Annotation()

    def __getattr__(self, attr):
        return self.attributes[attr]

    def __setattr__(self, attr, value):
        super(Node, self).__setattr__(attr, value)

    def __str__(self):
        return "<node " + self.serialize_dict(self.attributes) +\
            ">\n" + str(self.text) + str(self.annotation) +\
            "</node>"

    __repr__ = __str__

    def deserialize(self, xml):
        if xml.text and re.search(r"\w", str(xml.text)):
            raise ValueError(
                "Node shouldn't have text value! But has:\n'" + xml.text + "'")
        if self.attributes.keys() != xml.attrib.keys():
            raise AttributeError(
                "Node has not enough/too many attributes!" +
                "\nDiff: " + str(
                    self.attribute_diff(
                        self.attributes.keys(), xml.attrib.keys())))
        self.deserialize_attr(xml, self.attributes)
        for ch in xml.iter():
            if ch.tag == "text":
                self.text.deserialize(ch)
            elif ch.tag == "annotation":
                self.annotation.deserialize(ch)

    def get_position(self):
        ''' Return position of node as a touple '''
        return (self.x, self.y)
