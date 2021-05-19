      program matmul_prog

        use omp_lib
        
        implicit none
        
        integer icrow,iccol
        integer ic,i,j,num_devices
        integer,parameter :: a_row=840, a_col=3230, a_elem=a_row*a_col
        integer,parameter :: b_row=3230, b_col=802, b_elem=b_row*b_col
        integer,parameter :: c_row=a_row, c_col=b_col, c_elem=c_row*c_col        

        integer, dimension(12) :: seed=(/3,6,1,2,8,4,2,9,0,4,5,6/)
              
        double precision, dimension(a_row,a_col) ::  a
        double precision, dimension(b_row,b_col) ::  b
        double precision, dimension(c_row,c_col) ::  c,c_ref
        double precision, dimension(a_elem) :: a_temp
        double precision, dimension(b_elem) :: b_temp

        double precision num,sum,t1,t2

        logical, parameter :: validation=.true.
        logical, parameter :: print_result=.false.

        if(a_col.ne.b_row) stop 'Wrong matrices dimensions'

        num_devices = omp_get_num_devices()
        
        !generate initial arrays
        call random_seed(put=seed)
        
        do i=1,a_elem
           call random_number(num)
           a_temp(i)=10.d0*num+1.d0
        enddo
        do i=1,b_elem
           call random_number(num)
           b_temp(i)=10.d0*num+1.d0
        enddo
        a = transpose(reshape(a_temp,(/ size(a, 2), size(a, 1) /)))
        b = transpose(reshape(b_temp,(/ size(b, 2), size(b, 1) /)))


        t1=OMP_GET_WTIME()
        !matrix multiplication
        c=0.d0
        !$omp target map(tofrom:c) map(to:a,b)
        !$omp teams distribute parallel do private(ic,icrow,iccol,i)
        do ic=1,c_elem
           icrow=mod(ic-1,c_row)+1
           iccol=(ic-1)/c_row+1
           do i=1,a_col
              c(icrow,iccol)=c(icrow,iccol)+a(icrow,i)*b(i,iccol)
           enddo
        enddo
        !$omp end target
        t2=OMP_GET_WTIME()
        
        print *,'Elapsed time:',t2-t1

        !Print result
        if(print_result) then
           do icrow=1,c_row
              print '(20(1x,f12.5))', (c(icrow,iccol),iccol=1,c_col)
           enddo
        endif

        
        !Validation

        if(validation) then
           c_ref=matmul(a,b)

           do i=1,c_row
              do j=1,c_col
                 sum=sum+c(i,j)-c_ref(i,j)
              enddo
           enddo
           print *,sum,sum/dble(c_elem)
        endif

      end program matmul_prog
           
              

  
