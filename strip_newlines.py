#!/usr/bin/env python3

import sys
import re

print(re.sub('\\n*$', '', sys.stdin.read()), end='')
