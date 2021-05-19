CXX=g++
CXXFLAGS=-O2 -Wall -fopenmp
NVCC=nvcc
NVCCFLAGS=-O2
RUN=

RANGE=64,128,256,512,1024#,2048,4096,8192
NTHREADS=4

N=64

all: naive order threads target cuda

naive:
	$(CXX) $(CXXFLAGS) -o naive naive.cpp

order:
	$(CXX) $(CXXFLAGS) -o order order.cpp

threads:
	$(CXX) $(CXXFLAGS) -o threads threads.cpp

target:
	$(CXX) $(CXXFLAGS) -o target target.cpp

cuda:
	$(NVCC) $(NVCCFLAGS) -o cuda cuda.cu

.PHONY: clean run test

clean:
	rm -f naive order factorized threads target cuda
	rm -f time.*.txt

run: clean all
	@echo -n "naive:        " && $(RUN) ./naive $N
	@echo -n "order:        " && $(RUN) ./order $N
	@echo -n "threads:      " && $(RUN) ./threads $N
	@echo -n "target:       " && $(RUN) ./target $N
	@echo -n "cuda:         " && $(RUN) ./cuda $N

test: clean all
	rm -f time.*.txt
	export OMP_NUM_THREADS=$(NTHREADS); for i in {$(RANGE)}; do echo $$i && ./naive $$i >> time.naive.txt; done
	export OMP_NUM_THREADS=$(NTHREADS); for i in {$(RANGE)}; do echo $$i && ./order $$i >> time.order.txt; done
	export OMP_NUM_THREADS=$(NTHREADS); for i in {$(RANGE)}; do echo $$i && ./threads $$i >> time.threads.txt; done
	export OMP_NUM_THREADS=$(NTHREADS); for i in {$(RANGE)}; do echo $$i && ./target $$i >> time.target.txt; done
	export OMP_NUM_THREADS=$(NTHREADS); for i in {$(RANGE)}; do echo $$i && ./cuda $$i >> time.cuda.txt; done

plot:
	python plot.py