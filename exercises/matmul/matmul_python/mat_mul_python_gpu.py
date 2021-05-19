import numpy as np
import time
from numpy.random import seed
from numpy.random import rand
from numba import jit,cuda

size_array=4096
size_vec=size_array*size_array
validate=True

def generate_array(num,size):
    seed(num)
    lst=10.*rand(size)+1.
    return lst


a=np.array(generate_array(1,size_vec))
b=np.array(generate_array(2,size_vec))
c=np.zeros(size_vec)

@cuda.jit
def mat_mul(a,b,c,size):
    row=cuda.blockIdx.y*cuda.blockDim.y+cuda.threadIdx.y
    col=cuda.blockIdx.x*cuda.blockDim.x+cuda.threadIdx.x
    for i in range(size):
        c[row*size+col]+=a[row*size+i]*b[i*size+col]


threadsperblock = (16,16)
blockspergrid_x = int(np.ceil(size_array / threadsperblock[0]))
blockspergrid_y = int(np.ceil(size_array / threadsperblock[1]))
blockspergrid = (blockspergrid_x, blockspergrid_y)
start=time.time()
mat_mul[blockspergrid, threadsperblock](a,b,c,size_array)
end=time.time()
print('Elapsed time: ',end-start)

c=np.zeros(size_vec)
start=time.time()
mat_mul[blockspergrid, threadsperblock](a,b,c,size_array)
end=time.time()
print('Elapsed time: ',end-start)
  
if(validate):
    a2d=np.reshape(a,(size_array,-1))
    b2d=np.reshape(b,(size_array,-1))
    c2d_numba=np.reshape(c,(size_array,-1))
    c2d=np.matmul(a2d,b2d)
    dif=np.abs(c2d_numba-c2d)
    summation=np.sum(dif)
    print(summation,summation/float(size_vec))
