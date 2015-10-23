from mind_mapper.models import Model


class Text(Model):

    def __init__(self, **kwargs):
        self.attributes = {
            "size": kwargs["size"],
            "color": kwargs["color"],
            "font": kwargs["font"]
        }
        self.text = kwargs["text"]

    def __getattr__(self, attr):
        return self.attributes[attr]

    def __str__(self):
        return "<text " + self.serialize_dict(self.attributes) + " >\n" +\
            self.serialize_text(self.text) +\
            "\n</text>\n"

    __repr__ = __str__
