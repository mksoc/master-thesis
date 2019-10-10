from enum import Enum
from dataclasses import dataclass

# Definitions
class Counter(Enum):
  NT = 0
  WEAK_NT = 1
  WEAK_T = 2
  T = 3

HLEN = 16
BTB_BITS = 10
OFFSET = 2

@dataclass
class PhtEntry:
  valid: bool = False
  count: Counter = Counter.WEAK_NT

pht = [PhtEntry(0, Counter.WEAK_NT) if (row % 2) else \
    PhtEntry(0, Counter.WEAK_T) for row in range(2**HLEN)]

@dataclass
class BtbEntry:
  valid: int = 0
  tag: int
  target: int

btb = [BtbEntry(0, 0, 0) for row in range(2**BTB_BITS)]

