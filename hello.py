# Author sjie

import os


def CountLines(name):
    return len([line.rstrip() for line in open(name, 'r').readline()])


def CountChars(name):
    return len([char for char in open(name, 'r').read()])


def test(filename):
    len_line = CountLines(filename)
    len_chars = CountChars(filename)
    result_repr = "字符数为%d，行数为%d" % (len_chars, len_line)
    return result_repr


if __name__ == '__main__':
    result = test('test.txt')
    print(result)
