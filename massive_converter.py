#!/usr/bin/python3

import sys
import os

from asm2bin import Converter

def main():
    cwd = os.getcwd()

    for file in os.listdir(cwd):
        if file.endswith(".asm"):
                with open(file, 'r') as asm_file:
                    bin_lines = Converter.assembly(asm_file.readlines())
                    out_file = file.replace('asm', 'mem')
                with open(out_file, 'w') as out_file:
                    bin_lines = map(lambda x: x + '\n', bin_lines)
                    out_file.writelines(bin_lines)
                    print (file, 'converted to mem')
    print ("** Conversion finished **")
if __name__ == "__main__":
    main()
