from mind_mapper.models import Model


class Annotation(Model):

    def __init__(self, text):
        self.text = text

    def __str__(self):
        return "<annotation>\n" +\
            self.serialize_text(self.text) +\
            "\n</annotation>\n"

    __repr__ = __str__
