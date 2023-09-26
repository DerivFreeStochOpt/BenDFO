import os
import sys

import numpy as np
import scipy as sp

from dfoxs import dfoxs
from calfun import calfun

# np.seterr("raise")


def doit():
    dfo = np.loadtxt("../data/dfo.dat")

    for probtype in ["absnormal", "absuniform", "abswild", "noisy3", "nondiff", "relnormal", "reluniform", "relwild", "smooth", "wild3"]:
        for row, (nprob, n, m, factor_power) in enumerate(dfo):
            n = int(n)
            m = int(m)

            X0 = dfoxs(n, nprob, int(10**factor_power)).T
            out = calfun(X0, m, int(nprob), probtype, 0, vecout=True)


if __name__ == "__main__":
    doit()
