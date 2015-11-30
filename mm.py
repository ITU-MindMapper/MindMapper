#!/bin/python3
import sys
from mind_mapper import Base
from mind_mapper.views import View

if __name__ == '__main__':
    proj = Base()
    view = View()
    view.run()
    sys.exit(0)
