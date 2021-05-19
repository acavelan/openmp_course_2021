#include <cstdio>
#include <mpi.h>

int main()
{
	MPI_Comm comm;
	int size, rank;

	MPI_Init(NULL, NULL); comm = MPI_COMM_WORLD;
    MPI_Comm_rank(comm, &rank); 
    MPI_Comm_size(comm, &size);

	const int totalsteps = 10000;
	const int steps = totalsteps/size;

	const double dx = 1./totalsteps;

	int ini = rank * steps;
    int fin = (rank+1) * steps;

    if(fin >= totalsteps)
        fin = totalsteps;

    double localSum = 0.0;
    for(int i=ini; i<fin; i++)
    {
        double x = (i-0.5) * dx;
        localSum += 4.0 / (1.0 + x*x);
    }

    localSum = localSum * dx;

    double globalSum = 0.0;
    MPI_Allreduce(&localSum,&globalSum,1,MPI_DOUBLE_PRECISION,MPI_SUM,comm);

	printf("%f %f\n", localSum, globalSum);

    MPI_Barrier(comm);
    MPI_Finalize();

	return 0;
}