from mind_mapper.models.project import Project
from xml.etree.ElementTree import fromstring
import logging


class Base(object):

    def __init__(self):
        self.proj = Project()
        self.output_xml = "save.xml"
        self.input_xml = "load.xml"
        self._set_up_logger()
        logging.info("Base loaded!")

    def _set_up_logger(self):
        logging.basicConfig(
            level=logging.DEBUG,
            format='[%(asctime)s] {%(pathname)s:%(lineno)d} '
                   '%(levelname)s - %(message)s',
            handlers=[logging.StreamHandler()], datefmt='%H:%M:%S')

    def save(self):
        with open(self.output_xml, 'w') as out:
            out.write(str(self.proj))

    def load(self):
        with open(self.input_xml, 'r') as inp:
            self.proj.deserialize(fromstring(inp.read()))

    def run(self):
        return 0
