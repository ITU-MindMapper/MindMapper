from mind_mapper.models import Model


class Annotation(Model):

    def __init__(self, **kwargs):
        if kwargs:
            self.text = kwargs["text"]
        else:
            self.text = ""

    def __str__(self):
        return "<annotation>\n" +\
            self.serialize_text(self.text) +\
            "\n</annotation>\n"

    def deserialize(self, xml):
        if xml.attrib.keys():
            raise AttributeError("Bad XML format!")
        self.text = xml.text

    __repr__ = __str__
