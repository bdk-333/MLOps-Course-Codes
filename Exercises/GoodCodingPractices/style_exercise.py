"""Starter for the 'Code Styling with Ruff' sub-exercise.

Deliberately messy. Run `ruff check .` and then `ruff check . --fix` and
`ruff format .` and watch most of this clean up automatically. A few issues
Ruff can't auto-fix on its own — you'll need to edit those by hand.
"""
import os, sys           # E401: multiple imports on one line
import json              # F401: unused import
from   typing   import  List,Dict    # messy spacing, plus these should be
                                     # replaced with `list` / `dict` (UP006/UP007)


def compute_stats( values:List[int] )->Dict[str,float]:
    mean=sum(values)/len(values); var=sum((v-mean)**2 for v in values)/len(values)   # E702: multiple statements on one line
    return {"mean":mean,"variance":var,"stddev":var**0.5}


def very_long_line_that_is_definitely_over_one_hundred_characters_and_so_ruff_should_yell_at_us_about_it_for_sure(x):
    return x + 1   # trailing whitespace on the previous line is also a problem


def mutable_default(items = []):        # B006: mutable default argument
    items.append(1)
    return items


UNUSED_VARIABLE = "you never use me"    # F841 if it were inside a function


class   Point :          # weird spacing
    def __init__(self,x,y):
        self.x=x
        self.y=y
    def distance_from_origin(self) :
        return (self.x**2+self.y**2)**0.5
