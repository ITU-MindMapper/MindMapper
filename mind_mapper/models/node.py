from mind_mapper.models import Model
from mind_mapper.models.text import Text
from mind_mapper.models.annotation import Annotation


class Node(Model):

    def __init__(self, **kwargs):
        self.attributes = {
            "id": kwargs["id"],
            "x": kwargs["x"],
            "y": kwargs["y"],
            "background": kwargs["background"],
            "shape": kwargs["shape"],
            "size": kwargs["size"],
            "padding": kwargs["padding"],
            "text": Text(),
            "annotation": Annotation(),
        }

    def __getattr__(self, attr):
        return self.attributes[attr]

    def __str__(self):
        return "ID: " + str(self.id) + '|' +\
               "Positon: " + str((self.x, self.y)) + '|' +\
               "BG:" + self.background + '|' +\
               "Shape: " + self.shape + '|' +\
               "Size: " + str(self.size) + '|' +\
               "Padding: " + str(self.padding)

    __repr__ = __str__

    def getPosition(self):
        ''' Return position of node as a touple '''
        return (self.x, self.y)
