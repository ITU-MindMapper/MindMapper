class Model(object):

    def __str__(self):
        pass

    @staticmethod
    def serialize_dict(dict):
        return " ".join([key + "='" + str(dict[key]) + "'"
                         for key in dict])

    @staticmethod
    def serialize_text(text):
        # TODO: Implement this method
        return text


class Project(Model):

    def __init__(self):
        self.leafs = []

    def append(self, leaf):
        self.leafs.append(leaf)

    def __str__(self):
        return "<project>\n" +\
            "".join([str(leaf) for leaf in self.leafs]) +\
            "</project>\n"
