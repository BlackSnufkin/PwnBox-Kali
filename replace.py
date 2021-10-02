#!/bin/python3
# Python script to replace line in given file 
# replace.py <string> <line number> <path/to/file>

import sys
def main():

    file2edit = sys.argv[3]
    newstring = str(sys.argv[1])
    line_number = int(sys.argv[2])
    print('File Name: {}'.format(file2edit))
    print('New String to add: {}'.format(newstring))
    print('Line To Edit: {}'.format(line_number))

    with open(file2edit, 'r') as f:
        lines = f.read().split('\n')

        lines[line_number-1] = newstring
    with open(file2edit,'w') as f:
        f.write('\n'.join(lines))

if __name__ == '__main__':
    try:
        main()
    except Exception as error:
        print("""
Usage: Python3 replace.py <the new string> <line to add the new string> <file to edit>
Notice it will erase the old string and replace it with new string  
*** Example: python3 replace.py 'also string with stuff' 12 file.txt
                """);print(error)
