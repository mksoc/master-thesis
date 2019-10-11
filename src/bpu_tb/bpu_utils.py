from dataclasses import dataclass

XLEN = 64
HLEN = 16
BTB_BITS = 10
OFFSET = 2

# Function definitions


def hexpad(number, length):
    return hex(number)[2:].zfill(length // 4)


def res_parser(line):
    res = Resolution()
    fields = line.split()
    res.valid = bool(fields[0])
    res.pc = int(fields[1], 16)
    res.index = int(fields[2], 16)
    res.target = int(fields[3], 16)
    res.taken = bool(fields[4])
    res.mispredict = bool(fields[5])
    return res


# PHT definitions


@dataclass
class PhtEntry:
    valid: bool
    count: int

    def __str__(self):
        counter = ('NT', 'WEAK_NT', 'WEAK_T', 'T')
        return f"{self.valid}\t{counter[self.count]}"


class Pht:
    def __init__(self):
        self.table = [PhtEntry(0, 1) if (row % 2) else
                      PhtEntry(0, 2) for row in range(2**HLEN)]

    def query(self, index):
        if (self.table[index].valid) and (self.table[index].count < 2):
            return True
        else:
            return False

    def update(self, index, taken):
        self.table[index].valid = 1
        if taken:
            self.table[index].count = min(self.table[index].count + 1, 3)
        else:
            self.table[index].count = max(self.table[index].count - 1, 0)


# BHT definitions


class History:
    def __init__(self):
        self.bht = 0
        self.mask = (1 << HLEN) - 1

    def __str__(self):
        return hexpad(self.bht, HLEN)

    def shift(self, taken):
        self.bht = (self.bht >> 1) & self.mask
        if taken:
            self.bht |= 1 << (HLEN - 1)

    def get_index(self, address):
        addr_mask = ((1 << HLEN) - 1) << OFFSET
        return (address & addr_mask) >> OFFSET


# BTB definitions


@dataclass
class BtbEntry:
    valid: bool
    tag: int
    target: int


class Btb:
    def __init__(self):
        self.table = [BtbEntry(0, 0, 0) for row in range(2**BTB_BITS)]
        self.target_mask = (1 << XLEN) - 1

    def get_index(self, address):
        addr_mask = ((1 << BTB_BITS) - 1) << OFFSET
        return (address & addr_mask) >> OFFSET

    def get_tag(self, address):
        tag_mask = ((1 << (XLEN - BTB_BITS)) - 1) << (BTB_BITS + OFFSET)
        return (address & tag_mask) >> (BTB_BITS + OFFSET)

    def query(self, address):
        if (self.table[self.get_index(address)].valid) and \
                (self.table[self.get_index(address)].tag == self.get_tag(address)):
            return (True, self.table[self.get_index(address)].target & self.target_mask)
        else:
            return (False, 0)

    def update(self, address, target=0, delete=False):
        if delete:
            self.table[self.get_index(address)].valid = False
            self.table[self.get_index(address)].tag = 0
            self.table[self.get_index(address)].target = 0
        else:
            self.table[self.get_index(address)].valid = True
            self.table[self.get_index(address)].tag = self.get_tag(address)
            self.table[self.get_index(address)].target = target & self.target_mask


# Prediction/resolution structures

@dataclass
class Prediction:
    pc: int = 0
    index: int = 0
    target: int = 0
    taken: bool = False

    def __str__(self):
        return f"{hexpad(self.pc, XLEN)} {hexpad(self.index, HLEN)} {hexpad(self.target, XLEN)} {int(self.taken)}"


@dataclass
class Resolution:
    valid: bool = False
    pc: int = 0
    index: int = 0
    target: int = 0
    taken: bool = False
    mispredict: bool = False
