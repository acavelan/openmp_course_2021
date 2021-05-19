#include <cstdio>
#include "utils.hpp"

void mul(const float *m1, const float *m2, float *m3, int n)
{
	#pragma omp parallel for
   	for(int i=0; i<n; ++i)
    	for(int k=0; k<n; ++k)
        	for(int j=0; j<n; ++j)
        		m3[ i * n + j] += m1[i * n + k] * m2[k * n + j];
}

int main(int argc, char **argv)
{
	int n = 64;
	if(argc > 1)
		n = atoi(argv[1]);

	srand(12);

	float *m1 = new float[n*n];
	float *m2 = new float[n*n];
	float *m3 = new float[n*n];

	random(m1, n);
	random(m2, n);
	random(m3, n);

	zeros(m3, n);

	TimePoint tstart, tstop;

	tstart = Clock::now();
	mul(m1, m2, m3, n);
	tstop = Clock::now();

	//printf("Checksum: %f -- Time: %fms\n", checksum(m3, n), elapsedTime(tstart, tstop));
	printf("%f %f\n", checksum(m3, n), elapsedTime(tstart, tstop));

	delete[] m1;
	delete[] m2;
	delete[] m3;
}
