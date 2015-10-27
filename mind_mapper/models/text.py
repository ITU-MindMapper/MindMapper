from mind_mapper.models import Model


class Text(Model):

    def __init__(self, **kwargs):
        super(Text, self).__init__()
        if kwargs:
            self.attributes = {
                "size": kwargs["size"],
                "color": kwargs["color"],
                "font": kwargs["font"]
            }
            self.text = kwargs["text"]
        else:
            self.attributes = {
                "size": None,
                "color": None,
                "font": None,
            }
            self.text = ""

    def __getattr__(self, attr):
        return self.attributes[attr]

    def __setattr__(self, attr, value):
        super(Text, self).__setattr__(attr, value)

    def __str__(self):
        return "<text " + self.serialize_dict(self.attributes) + ">\n" +\
            self.serialize_text(self.text) +\
            "\n</text>\n"

    def deserialize(self, xml):
        if self.attributes.keys() != xml.attrib.keys():
            raise AttributeError(
                "size, color, font are required only but have:\n" +
                str(self.attributes.keys()))
        self.deserialize_attr(xml, self.attributes)
        self.text = xml.text

    __repr__ = __str__
