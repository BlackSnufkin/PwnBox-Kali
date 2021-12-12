#!/usr/bin/python


# 8th November, 2009
# update manager failed, giving me the error:
# 'files list file for package 'xxx' is missing final newline' for every package.
# some Googling revealed that this problem was due to corrupt files(s) in /var/lib/dpkg/info/
# looping though those files revealed that some did not have a final new line
# this script will resolve that problem by appending a newline to all files that are missing it
# NOTE: you will need to run this script as root, e.g. sudo python newline_fixer.py

import os

dpkg_path = '/var/lib/dpkg/info/'
paths = os.listdir(dpkg_path)
for path in paths:
    path = dpkg_path + path
    f = open(path, 'a+')
    data = f.read()
    if len(data) > 1 and data[-1:] != '\n':
        f.write('\n')
        print 'added newline character to:', path
    f.close() 
