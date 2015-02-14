#!/usr/bin/env python3

import subprocess
import multiprocessing

s = subprocess.Popen(['bspc', 'control', '--subscribe'], stdout=subprocess.PIPE)

while True:
    line = s.stdout.readline()
    if not line:
        break
    print(line.strip().decode('utf-8'))
