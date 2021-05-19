import numpy as np
import time
from numpy.random import seed
from numpy.random import rand
from numba import jit,prange

size_array=4096
size_vec=size_array*size_array

def generate_array(num,size):
    seed(num)
    lst=10.*rand(size)+1.
    return lst


a=np.array(generate_array(1,size_vec))
b=np.array(generate_array(2,size_vec))
c=np.zeros(size_vec)

@jit
def mat_mul(a,b,c,size):
    for i in range(size):
        for k in range(size):
            for j in range(size):
                c[i*size+j]+=a[i*size+k]+b[k*size+j]

start=time.time()
c=mat_mul(a,b,c,size_array)
end=time.time()
print('Elapsed time: ',end-start)

c=np.zeros(size_vec)

start=time.time()
c=mat_mul(a,b,c,size_array)
end=time.time()



print('Elapsed time: ',end-start)
  
