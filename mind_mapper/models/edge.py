from mind_mapper.models import Model


class Edge(Model):

    def __init__(self, **kwargs):
        self.attributes = {
            "type": kwargs["type"],
            "thickness": kwargs["thickness"],
            "color": kwargs["color"],
            "node1": kwargs["node1"],
            "node2": kwargs["node2"],
            "x": kwargs["x"],
            "y": kwargs["y"],
        }

    def __getattr__(self, attr):
        return self.attributes[attr]

    def __str__(self):
        return "<edge " + self.serialize_dict(self.attributes) + " />\n"

    __repr__ = __str__

    def get_position(self):
        ''' Return position of edge control point as a touple '''
        return (self.x, self.y)
