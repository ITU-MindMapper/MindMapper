from support import MMTestCase
from mind_mapper import Base


class FakeBase(Base):

    def __init__(self, output, input_):
        super(FakeBase, self).__init__()
        self.output_xml = output
        self.input_xml = input_


class Functional(MMTestCase):

    def _check_load(self, base):
        # TODO: implement
        pass

    def _check_save(self, file):
        # TODO: implement
        pass

    def test_load(self):
        base = FakeBase("", self.project_dir + "/load.xml")
        base.load()
        self._check_load(base)

    def test_save(self):
        base = FakeBase(self.project_dir + "/save.xml", "")
        base.save()
        self._check_save(self.project_dir + "/save.xml")
