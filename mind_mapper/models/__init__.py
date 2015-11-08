class Model(dict):

    def __init__(self, default, kwargs, ignore=[]):
        if kwargs:
            attributes = {
                k: v for k, v in kwargs.items() if k not in ignore
            }
        else:
            attributes = default
        dict.__init__(self, attributes)
        self.__initialized = True

    def __setattr__(self, key, value):
        if "_Model__initialized" not in self.__dict__:
            return dict.__setattr__(self, key, value)
        elif key in self.__dict__:
            dict.__setattr__(self, key, value)
        else:
            self.__setitem__(key, value)

    def __getattr__(self, key):
        try:
            if key in self.__dict__:
                return dict.__getattr__(key)
            else:
                return self.__getitem__(key)
        except KeyError:
            raise AttributeError(key)

    def __str__(self):
        pass

    def deserialize(self, xml):
        pass

    def serialize_dict(self):
        return " ".join([key + "='" + str(item) + "'"
                         for key, item in self.items()])

    def deserialize_attr(self, xml):
        for key in self.keys():
            self[key] = xml.attrib[key]

    @staticmethod
    def serialize_text(text):
        # TODO: Implement this method
        return text

    @staticmethod
    def attribute_diff(a, b):
        return (a - b).union(b - a)
