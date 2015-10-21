from mind_mapper.models import Model
from mind_mapper.models.text import Text
from mind_mapper.models.annotation import Annotation
from mind_mapper.models.edge import Edge


class Node(Model):

    def __init__(self):
        self.text = Text()
        self.annotation = Annotation()
        self.edges = []
