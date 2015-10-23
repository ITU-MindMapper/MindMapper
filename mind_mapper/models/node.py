from mind_mapper.models import Model


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
        }

    def __getattr__(self, attr):
        return self.attributes[attr]

    def __str__(self):
        return "<node " + self.serialize_dict(self.attributes) + " />\n"

    __repr__ = __str__

    def get_position(self):
        ''' Return position of node as a touple '''
        return (self.x, self.y)
