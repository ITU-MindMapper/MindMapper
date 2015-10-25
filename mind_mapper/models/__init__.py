class Model(dict):

    def __init__(self):
        super(Model, self).__init__()

    def __str__(self):
        pass

    def deserialize(self, xml):
        pass

    @staticmethod
    def serialize_dict(dict):
        return " ".join([key + "='" + str(dict[key]) + "'"
                         for key in dict])

    @staticmethod
    def serialize_text(text):
        # TODO: Implement this method
        return text

    @staticmethod
    def deserialize_attr(xml, attrs):
        for key in attrs.keys():
            attrs[key] = xml.attrib[key]

    @staticmethod
    def attribute_diff(a, b):
        return (a - b).union(b - a)
