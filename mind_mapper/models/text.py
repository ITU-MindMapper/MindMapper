from mind_mapper.models import Model


class Text(Model):

    def __init__(self, text, **kwargs):
        self.attributes = {
            "size": kwargs["size"],
            "color": kwargs["color"],
            "font": kwargs["font"],
        }
        self.text = text

    def __getattr__(self, attr):
        return self.attributes[attr]

    def __str__(self):
        return "Text: " + self.text + '|' +\
               "Size: " + str(self.size) + '|' +\
               "Color: " + self.color + '|' +\
               "Font: " + self.font

    __repr__ = __str__

    def setText(self, text):
        self.text = text
