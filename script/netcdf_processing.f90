module nc_processing

contains

subroutine write_netcdf(file_name, var_name, &
                       nrecs, nlats, nlons, nlvls, &
                       lat_in, lon_in, lvls_in, data_in)
! *****************************************************************
! subprogram:  write_netcdf: write 4d matrix (time, lon, lat, lev) into netcdf for viewing purpose
!
!   PRGMMR: Sijin Zhang
!
! In: file_name: netcdf filename
!     var_name: variable name
!     nrecs: time dimension (fixed to 1 for now)
!     nlats: lat dimension
!     nlons: lon dimension
!     nlvls: level dimension
!     lat_in/lon_in/lvls_in: latitude/longitude/level data (1d)
!     data_in: data matrix (3d: lon:lat:level)
! 
! Compilation independently:
!    gfortran write_netcdf.f90 -I/home/jzanetti/programs/netcdf-fortran-4.4.4/include -L/home/jzanetti/programs/netcdf-fortran-4.4.4/lib -lnetcdf -lnetcdff
!
! Compilation in GSI:
!    1. in src/libs/gsdcloud/make.filelist, add netcdf_processsing.f90 under SRC_FILES
!	e.g., 	SRC_FILES = netcdf_processing.f90 \
!            			ARPS_cldLib.f90 \
!				....
!    2. in src/libs/gsdcloud/make.dependencies, add netcdf_processing.f90
!	e.g., 	constants.o : constants.f90 kinds.o
!		nc_processing.o : netcdf_processing.f90
!		....
!
! Use netcdf_processing.f90 in the cloud analysis:
!	e.g., in src/libs/gsdcloud/cloudCover_Surface.f90, add:
!		use nc_processing, only: write_netcdf
!		...
!	   	call write_netcdf('cld_cover_3d_step3.nc', 'cld_cover_3d', &
!                       1, nlat, nlon, nsig, &
!                       lat_in, lon_in, lvls_in, cld_cover_3d)
!		...
! *****************************************************************

  use netcdf
  implicit none

  ! This is the name of the data file we will create.
  character (len = *), intent(in) :: file_name
  integer, intent(in) :: nrecs, nlvls, nlats, nlons
  character (len = *), intent(in) :: var_name
  real, intent(in) :: data_in(nlons, nlats, nlvls)
  real, intent(in) :: lat_in(nlats), lon_in(nlons), lvls_in(nlvls)

  integer :: ncid

  ! We are writing 4D data, a 2 x 6 x 12 lvl-lat-lon grid, with 2
  ! timesteps of data.
  integer, parameter :: NDIMS = 4

  character (len = *), parameter :: LVL_NAME = "level"
  character (len = *), parameter :: LAT_NAME = "latitude"
  character (len = *), parameter :: LON_NAME = "longitude"
  character (len = *), parameter :: REC_NAME = "time"
  integer :: lvl_dimid, lon_dimid, lat_dimid, rec_dimid

  ! The start and count arrays will tell the netCDF library where to
  ! write our data.
  integer :: start(NDIMS), count(NDIMS)

  ! These program variables hold the latitudes and longitudes.
  real :: lats(nlats), lons(nlons)
  integer :: lon_varid, lat_varid

  ! We will create two netCDF variables, one each for temperature and
  ! pressure fields.
  integer :: data_varid
  integer :: dimids(NDIMS)

  ! We recommend that each variable carry a "units" attribute.
  character (len = *), parameter :: UNITS = "units"
  character (len = *), parameter :: DATA_UNITS = "not defined"
  character (len = *), parameter :: LAT_UNITS = "degrees_north"
  character (len = *), parameter :: LON_UNITS = "degrees_east"

  real :: data_out(nlons, nlats, nlvls)
  real, parameter :: SAMPLE_PRESSURE = 900.0
  real, parameter :: SAMPLE_TEMP = 9.0

  ! Use these to construct some latitude and longitude data for this
  ! example.
  real, parameter :: START_LAT = 25.0, START_LON = -125.0

  ! Loop indices
  integer :: lvl, lat, lon, rec, i

  ! Create pretend data. If this wasn't an example program, we would
  ! have some real data to write, for example, model output.
  ! nrecs = 1

  write(*,*) 'nctest1'
  lats = lat_in
  lons = lon_in
  data_out = data_in
  write(*,*) 'nctest2'

  ! Create the file. 
  call check( nf90_create(file_name, nf90_clobber, ncid) )
  
  call check( nf90_def_dim(ncid, LVL_NAME, nlvls, lvl_dimid) )
  call check( nf90_def_dim(ncid, LAT_NAME, nlats, lat_dimid) )
  call check( nf90_def_dim(ncid, LON_NAME, nlons, lon_dimid) )
  call check( nf90_def_dim(ncid, REC_NAME, NF90_UNLIMITED, rec_dimid) )

  call check( nf90_def_var(ncid, LAT_NAME, NF90_REAL, lat_dimid, lat_varid) )
  call check( nf90_def_var(ncid, LON_NAME, NF90_REAL, lon_dimid, lon_varid) )
  call check( nf90_put_att(ncid, lat_varid, UNITS, LAT_UNITS) )
  call check( nf90_put_att(ncid, lon_varid, UNITS, LON_UNITS) )

  dimids = (/ lon_dimid, lat_dimid, lvl_dimid, rec_dimid /)

  call check( nf90_def_var(ncid, var_name, NF90_REAL, dimids, data_varid) )

  ! Assign units attributes to the netCDF variables.
  call check( nf90_put_att(ncid, data_varid, UNITS, DATA_UNITS) )

  ! End define mode.
  call check( nf90_enddef(ncid) )
  
  ! Write the coordinate variable data. This will put the latitudes
  ! and longitudes of our data grid into the netCDF file.
  call check( nf90_put_var(ncid, lat_varid, lats) )
  call check( nf90_put_var(ncid, lon_varid, lons) )
  
  ! These settings tell netcdf to write one timestep of data. (The
  ! setting of start(4) inside the loop below tells netCDF which
  ! timestep to write.)
  count = (/ NLONS, NLATS, NLVLS, 1 /)
  start = (/ 1, 1, 1, 1 /)

  ! Write the pretend data. The arrays only hold one timestep worth
  ! of data. We will just rewrite the same data for each timestep. In
  ! a real :: application, the data would change between timesteps.
  do rec = 1, nrecs
     start(4) = rec
     call check( nf90_put_var(ncid, data_varid, data_out, start = start, &
                              count = count) )
  end do
  
  ! Close the file. This causes netCDF to flush all buffers and make
  ! sure your data are really written to disk.
  call check( nf90_close(ncid) )
  
  print *,"*** SUCCESS writing the required file ", file_name, "!"

contains
  subroutine check(status)
    integer, intent ( in) :: status
    
    if(status /= nf90_noerr) then 
      print *, trim(nf90_strerror(status))
      stop "Stopped"
    end if
  end subroutine check  
end subroutine write_netcdf

end module nc_processing

