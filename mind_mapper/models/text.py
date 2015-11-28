from mind_mapper.models import Model
import re


class Text(Model):

    def __init__(self, **kwargs):
        if kwargs:
            self.text = kwargs["text"]
        else:
            self.text = ""
        super(Text, self).__init__({
            "size": None,
            "color": None,
            "font": None,
        }, kwargs, ["text"])

    def __str__(self):
        return "<text " + self.serialize_dict() + ">\n" +\
            self.serialize_text(self.text) +\
            "\n</text>\n"

    def deserialize(self, xml):
        if self.keys() != xml.attrib.keys():
            raise AttributeError(
                "size, color, font are required only but have:\n" +
                str(self.keys()))
        self.deserialize_attr(xml)
        self.text = re.sub('\n', '', xml.text)

    __repr__ = __str__
