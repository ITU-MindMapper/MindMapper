from mind_mapper.models import Model


class Annotation(Model):

    def __init__(self, text):
        self.text = text

    def __str__(self):
        return self.text

    __repr__ = __str__

    def setText(self, text):
        self.text = text
