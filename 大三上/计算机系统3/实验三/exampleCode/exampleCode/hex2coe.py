import sys

def splitHexLine(hexLine):
    ret = []
    for i in range(0,len(hexLine),16):
        ret.append(hexLine[i:16 + i])
    return ret[::-1]


def hex2coe(srcFile,destFile):
    with open(srcFile,'r') as hexFile:
        lines = hexFile.readlines()
        with open(destFile,'w') as coeFile:
            coeFile.write('memory_initialization_radix=16;\n')
            coeFile.write('memory_initialization_vector=\n')
            for i in range(0,len(lines)):
                coeLines = splitHexLine(lines[i].strip())
                for j in range(0,len(coeLines)):
                    if i == len(lines) - 1 and j == len(coeLines) - 1:
                        coeFile.write(coeLines[j]+';\n')
                    else:
                        coeFile.write(coeLines[j]+',\n')


def main():
    if(len(sys.argv) != 3):
        print("usage : hex2coe <srcFile> <destFile>")
    else:
        hex2coe(sys.argv[1],sys.argv[2])

if __name__ == '__main__':
    main()