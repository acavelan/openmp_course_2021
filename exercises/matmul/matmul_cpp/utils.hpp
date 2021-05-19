#include <ctime>
#include <cstdlib>
#include <chrono>

typedef std::chrono::high_resolution_clock Clock;
typedef std::chrono::time_point<Clock> TimePoint;
typedef std::chrono::duration<double> Time;

void zeros(float *m, int n)
{
	for(int i=0; i<n*n; ++i)
		m[i] = 0;
}

void random(float *m, int n)
{
	for(int i=0; i<n*n; ++i)
		m[i] = (rand() % 1000 - 500) / 1000.0;
}

float checksum(const float *m3, int n)
{
	float sum = 0.0f;
	for(int i=0; i<n*n; i++)
		sum += m3[i];
	return sum;
}

double elapsedTime(TimePoint start, TimePoint stop)
{
	return std::chrono::duration_cast<Time>(stop-start).count();
}
