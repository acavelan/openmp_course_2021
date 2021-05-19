program integration
    implicit none
    include 'mpif.h'
   
    integer ierr, comm, rank, size
    integer i, totalsteps, steps, ini, fin
    double precision dx, x, localSum, globalSum
     
    call MPI_INIT(ierr); comm = MPI_COMM_WORLD
    
    call MPI_COMM_RANK(comm, rank, ierr)
    call MPI_COMM_SIZE(comm, size, ierr)

    totalsteps = 1000000
    steps = totalsteps/size

    ini = rank * steps
    fin = (rank+1) * steps

    if(fin.ge.totalsteps) then
        fin = totalsteps
    endif

    write(*,*) rank, ini, fin

    dx = 1.d0 / totalsteps
    x = -0.5d0 * dx

    localSum = 0.d0
    do i = ini, fin
        x = (i-0.5d0)*dx
        localSum = localSum + 4.d0 / (1.d0 + x*x)
    enddo
    localSum = localSum * dx

    call MPI_ALLREDUCE(localSum,globalSum,1,MPI_DOUBLE_PRECISION,MPI_SUM,comm,ierr)

    write(*,*) localSum, globalSum

    call MPI_BARRIER(comm,ierr)
    call MPI_FINALIZE(ierr)
end program integration
           