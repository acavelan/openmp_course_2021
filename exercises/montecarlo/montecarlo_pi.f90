program montecarlo_pi

  implicit none

  integer i,countin
  integer,parameter::npoints=100000000
  double precision num,pi,pi_true,x,y,random_last

  pi_true=acos(-1.d0)
  countin=0
  random_last=0
  do i=1,npoints
     call random_number(x)
     call random_number(y)
     if(x*x+y*y.le.1.d0)countin=countin+1
  enddo

  pi=dble(countin)/dble(npoints)*4.d0

  print *,'Calculated: ',pi,'Real: ',pi_true

end program montecarlo_pi
