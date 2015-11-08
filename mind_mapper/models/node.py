from mind_mapper.models import Model
from mind_mapper.models.annotation import Annotation
from mind_mapper.models.text import Text
import re


class Node(Model):

    def __init__(self, **kwargs):
        if kwargs:
            self.text = kwargs["text"]
            self.annotation = kwargs["annotation"]
        else:
            self.text = Text()
            self.annotation = Annotation()
        super(Node, self).__init__({
            "id": None,
            "x": None,
            "y": None,
            "background": None,
            "shape": None,
            "height": None,
            "width": None,
        }, kwargs, ["text", "annotation"])

    def __str__(self):
        return "<node " + self.serialize_dict() +\
            ">\n" + str(self.text) + str(self.annotation) +\
            "</node>\n"

    __repr__ = __str__

    def deserialize(self, xml):
        if xml.text and re.search(r"\w", str(xml.text)):
            raise ValueError(
                "Node shouldn't have text value! But has:\n'" + xml.text + "'")
        if self.keys() != xml.attrib.keys():
            raise AttributeError(
                "Node has not enough/too many attributes!" +
                "\nDiff: " + str(
                    self.attribute_diff(
                        self.keys(), xml.attrib.keys())))
        self.deserialize_attr(xml)
        for ch in xml.iter():
            if ch.tag == "text":
                self.text.deserialize(ch)
            elif ch.tag == "annotation":
                self.annotation.deserialize(ch)
        self.x = int(self.x)
        self.y = int(self.y)
        self.width = int(self.width)
        self.height = int(self.height)
        self.id = int(self.id)
        self.shape = int(self.shape)

    def get_position(self):
        ''' Return position of node as a touple '''
        return (self.x, self.y)
