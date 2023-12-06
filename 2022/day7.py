

from enum import Enum
from typing import Tuple


class FsEntry():
    path: str
    size: int
    children: list

    def __init__(self, path: str, size = 0) -> None:
        self.path = path
        self.size = size
        self.children = []
    
    def add_child(self, entry):
        self.size += entry.size
        self.children.append(entry)

class Command(Enum):
    CD = 1
    LS = 2
    DIR = 3
    FILE = 4

    
def parse(line: str) -> Tuple[Command, list]:
    parts = line.strip().split(" ")
    if parts[0] == "$":
        if parts[1] == "cd":
            return (Command.CD, [parts[2]])
        if parts[1] == "ls":
            return (Command.LS, [])
        raise Exception(f"Unknown command {parts}")
    if parts[0] == "dir":
        return (Command.DIR, [parts[1]])
    return (Command.FILE, [parts[1], int(parts[0])])


def find_min(entry: FsEntry):
    if entry.size < 30000000:
        return 999999999999
    min = entry.size
    mins = list(map(find_min, entry.children))
    for m in mins:
        if m < min:
            min = m
    return min
    

def main():
    root = None
    dirPath = []
    total=0
    with open("inputs/day7.txt") as f:
        for line in f.readlines():
            (cmd, details) = parse(line)
            if cmd == Command.CD:
                if details[0] == "/":
                    root = FsEntry("/")
                    dirPath.append(root)
                elif details[0] == "..":
                    top = dirPath.pop()
                    dirPath[-1].add_child(top)
                    if top.size <= 100000:
                        total += top.size
                else:
                    entry = FsEntry(details[0])
                    dirPath.append(entry)
            elif cmd == Command.LS:
                continue
            elif cmd == Command.DIR:
                continue
            elif cmd == Command.FILE:
                entry = FsEntry(details[0], details[1])
                dirPath[-1].add_child(entry)
    while len(dirPath) > 1:
        entry = dirPath.pop()
        dirPath[-1].add_child(entry)

    print(total)

    print(find_min(root))




if __name__ == "__main__":
    main()