import math
from numba import njit, prange

steps = 100000

pi = math.acos(-1.0)
dx = 1./steps

lsum = 0.0
for i in prange(0, steps):
	x = (i-0.5)*dx
	lsum = lsum + 4./(1.0 + x*x)

lsum = lsum * dx

print(lsum, abs(pi-lsum)/pi)