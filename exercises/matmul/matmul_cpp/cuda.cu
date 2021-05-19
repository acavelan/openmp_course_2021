#include <cstdio>
#include "utils.hpp"

__global__ void cuda_mul(float* m1, float* m2, float* m3, int n) {

    int row = blockIdx.y*blockDim.y+threadIdx.y;
    int col = blockIdx.x*blockDim.x+threadIdx.x;

    for (int i = 0; i < n; i++)
        m3[row * n + col] += m1[row * n + i] * m2[i * n + col];
}

void mul(const float *m1, const float *m2, float *m3, int n)
{
	float *dm1 = nullptr, *dm2 = nullptr, *dm3 = nullptr;

	cudaMalloc((void**)&dm1, sizeof(float) * n * n);
	cudaMalloc((void**)&dm2, sizeof(float) * n * n);
	cudaMalloc((void**)&dm3, sizeof(float) * n * n);

	cudaMemcpy(dm1, m1, sizeof(float) * n * n, cudaMemcpyHostToDevice);
	cudaMemcpy(dm2, m2, sizeof(float) * n * n, cudaMemcpyHostToDevice);
	cudaMemcpy(dm3, m3, sizeof(float) * n * n, cudaMemcpyHostToDevice);

	dim3 blockSize = dim3(16, 16);
	dim3 gridSize = dim3(n / blockSize.x, n/ blockSize.y);
	
	cuda_mul<<<gridSize, blockSize>>>(dm1, dm2, dm3, n);

	cudaMemcpy(m3, dm3, sizeof(float) * n * n, cudaMemcpyDeviceToHost);

	cudaFree(dm1);
	cudaFree(dm2);
	cudaFree(dm3);
}

int main(int argc, char **argv)
{
	int n = 64;
	if(argc > 1)
		n = atoi(argv[1]);

	srand(12);

	float *m1 = nullptr, *m2 = nullptr, *m3 = nullptr;

	cudaError_t err = cudaMallocHost((void**)&m1, sizeof(float) * n * n);
	if(err) printf("Error status is %s\n", cudaGetErrorString(err));
	err = cudaMallocHost((void**)&m2, sizeof(float) * n * n);
	if(err) printf("Error status is %s\n", cudaGetErrorString(err));
	err = cudaMallocHost((void**)&m3, sizeof(float) * n * n);
	if(err) printf("Error status is %s\n", cudaGetErrorString(err));

	random(m1, n);
	random(m2, n);
	random(m3, n);

	zeros(m3, n);

	TimePoint tstart, tstop;

	tstart = Clock::now();
	mul(m1, m2, m3, n);
	tstop = Clock::now();

	//printf("checksum: %f -- Time: %fms\n", checksum(m3, n), elapsedTime(tstart, tstop));
	printf("%f %f\n", checksum(m3, n), elapsedTime(tstart, tstop));

	cudaFreeHost(m1);
	cudaFreeHost(m2);
	cudaFreeHost(m3);
}
