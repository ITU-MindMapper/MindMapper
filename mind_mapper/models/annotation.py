from mind_mapper.models import Model


class Annotation(Model):

    def __init__(self, **kwargs):
        if kwargs:
            self.text = kwargs["text"]
        else:
            self.text = None

    def __str__(self):
        return "<annotation>\n" +\
            self.serialize_text(self.text) +\
            "\n</annotation>\n"

    def deserialize(self, xml):
        self.text = xml.get("text")
        if xml.attrs():
            raise AttributeError("Bad XML format!")

    __repr__ = __str__
