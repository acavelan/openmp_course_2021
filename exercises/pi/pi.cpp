#include <cstdio>
#include <math.h>

int main()
{
	const int steps = 1000000000;
	const double dx = 1./steps;
    const double pi = std::acos(-1.0);

    double sum = 0.0;

    for(int i=0; i<steps; i++)
    {
        double x = (i-0.5) * dx;
        sum += 4.0 / (1.0 + x*x);
    }

    sum *= dx;

	printf("%.15f %.15e\n", sum, abs(pi-sum));

	return 0;
}