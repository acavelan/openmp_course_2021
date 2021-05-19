program montecarlo_pi_v2

  implicit none

  integer i,countin,id
  integer,parameter::npoints=100000000
  double precision num,pi,pi_true,x,y
  integer random_last

  pi_true=acos(-1.d0)
  countin=0
  random_last=0
  do i=1,npoints
     call LCG_random(x,random_last)
     call LCG_random(y,random_last)
     if(x*x+y*y.le.1.d0)countin=countin+1
  enddo

  pi=dble(countin)/dble(npoints)*4.d0

  print *,pi,pi_true

end program montecarlo_pi_v2


!***************************************************
subroutine LCG_random(num,random_last)

  implicit none
  integer,parameter::multiplier=1366,addend=150889,pmod=714025
  integer,intent(inout)::random_last
  double precision num

  num=dble(mod(multiplier*random_last+addend,pmod))
  random_last=num
  num=num/dble(pmod)

  return
end subroutine LCG_random
