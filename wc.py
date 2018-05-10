
import os


def CountLines(name):
    res = []
    with open(name, 'r') as target:
        for line in target.readlines():
            res.append(line)
    return len(res)


if __name__ == '__main__':
    a = CountLines('test.txt')
    print(a)
    import re
    re.compile()
