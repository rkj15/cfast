
! --------------------------- cfast -------------------------------------------

    program cfast

    !     Routine: cfast (main program)
    !     Purpose: main program for the model

    !     Permission is hereby granted, free of charge, to any person
    !     obtaining a copy of this software and associated documentation
    !     files (the "Software"), to deal in the Software without
    !     restriction, including without limitation the rights to use,
    !     copy, modify, merge, publish, distribute, sublicense, and/or sell
    !     copies of the Software, and to permit persons to whom the
    !     Software is furnished to do so, subject to the following
    !     conditions:

    !     The above copyright notice and this permission notice shall be
    !     included in all copies or substantial portions of the Software.

    !     The software is provided "as is", without warranty of any kind,
    !     express or implied, including but not limited to the warranties
    !     of merchantability, fitness for a particular purpose and
    !     noninfringement. In no event shall the authors or copyright
    !     holders be liable for any claim, damages or other liability,
    !     whether in an action of contract, tort or otherwise, arising
    !     from, out of or in connection with the software or the use or
    !     other dealings in the software.

    use precision_parameters
    use initialization_routines, only : initialize_memory, initialize_fire_objects, initialize_species, initialize_walls
    use input_routines, only : open_files, read_input_file
    use output_routines, only: output_version, output_initial_conditions
    use solve_routines, only : solve_simulation
    use utility_routines, only : cptime, read_command_options
    use radiation_routines, only : radiation

    use setup_data
    use thermal_data
    use option_data, only: total_steps
    use namelist_data

    implicit none

    real(eb) :: xdelt, tstop, tbeg, tend
    type(thermal_type), pointer :: thrmpptr

    cfast_version = 7301        ! Current CFAST version number

    if (command_argument_count().eq.0) then
        call output_version(0)
        stop
    end if

    ! initialize the basic memory configuration

    stime = 0.0_eb
    call initialize_memory
    call read_command_options
    call open_files

    call output_version (iofill)

    call read_input_file

    call initialize_species

    i_time_step = 1
    xdelt = time_end/deltat
    i_time_end = xdelt + 1
    tstop = i_time_end - 1

    ! add the default thermal property
    n_thrmp = n_thrmp + 1
    thrmpptr => thermalinfo(n_thrmp)
    thrmpptr%name = 'DEFAULT'
    thrmpptr%eps = 0.90_eb
    thrmpptr%nslab = 1
    thrmpptr%k(1) = 0.120_eb
    thrmpptr%c(1) = 900.0_eb
    thrmpptr%rho(1) = 800.0_eb
    thrmpptr%thickness(1) = 0.0120_eb

    call initialize_walls (tstop)

    call output_initial_conditions

    call cptime(tbeg)
    call solve_simulation (tstop)
    call cptime(tend)

    if (.not.validation_flag) write (*,5000) tend - tbeg
    if (.not.validation_flag) write (*,5010) total_steps
    write (iofill,5000) tend - tbeg
    write (iofill,5010) total_steps
    call cfastexit ('CFAST', 0)

5000 format ('Total execution time = ',1pg10.3,' seconds')
5010 format ('Total time steps = ',i10)

    end program cfast

! --------------------------- cfastexit -------------------------------------------

    subroutine cfastexit (name, errorcode)

    ! called when CFAST exits, printing an error code if necessary
    ! inputs:   name        routine name calling for exit ... at this point, it's always "CFAST"
    !           errorcode   numeric code indicating reason for an error exit.  0 for a normal exit

    use output_routines, only : deleteoutputfiles
    use setup_data

    character, intent(in) :: name*(*)
    integer, intent(in) :: errorcode

    if (errorcode==0) then
        if (.not.validation_flag) write (*, '(''Normal exit from '',a)') trim(name)
        write (iofill, '(''Normal exit from '',a)') trim(name)
    else
        write (*,'(''***Error exit from '',a,'' code = '',i0)') trim(name), errorcode
        write (iofill,'(''***Error exit from '',a,'' code = '',i0)') trim(name), errorcode
    end if

    close (unit=iofilkernel, status='delete')
    call deleteoutputfiles (stopfile)

    stop

    end subroutine cfastexit

