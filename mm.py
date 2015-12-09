#!/bin/python3
import sys
from mind_mapper import Base
from mind_mapper.views import View
import logging


if __name__ == '__main__':
    logging.disable(logging.DEBUG)
    logging.disable(logging.INFO)
    proj = Base()
    view = View()
    view.run()
    sys.exit(0)
