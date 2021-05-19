program mandelbrot_area

  implicit none

  integer,parameter::npoints=2000,mxitr=1000
  double precision,parameter:: eps=1.d-5

  integer i,j,numoutside
  double precision area,error,rp,ri

  numoutside=0

  print *,eps,numoutside
  do i=1,npoints
     do j=1,npoints
        rp=-2.d0+2.5d0*dble(i)/dble(npoints)+eps
        ri=1.125d0*dble(j)/dble(npoints)+eps
        call testpoint(rp,ri,numoutside,mxitr)
     enddo
  enddo
  area=2.d0*2.5d0*1.125d0*dble(npoints*npoints-numoutside)/dble(npoints*npoints)
  error=area/dble(npoints)

  print *,'area: ',area,numoutside
  print *,'error: ',error

end program mandelbrot_area


!***************************************************
subroutine testpoint(rp,ri,numoutside,mxitr)
  implicit none
  integer i
  integer,intent(in)::mxitr
  integer,intent(inout)::numoutside
  double precision,intent(in)::rp,ri
  double precision temp,crp,cri

  crp=rp
  cri=ri
  do i=1,mxitr
     temp=crp*crp-cri*cri+rp
     cri=crp*cri*2.d0+ri
     crp=temp
     if(crp*crp+cri*cri.gt.4.d0) then
        numoutside=numoutside+1
        exit
     endif
  enddo

  return
end subroutine testpoint
