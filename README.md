# gsi_stuff
reference:
https://www.da.ucar.edu/sites/default/files/Benjamin_BlueDA-GSD-8Mar2016.pdf

Test GSI with external wps/wrf/gsi pkgs \n
1. Install the necessary packages from `/home/szhang/GitHub_branches/conda_pkg/intel-parallel/cloud/release`
(1) hdf5-1.8.19-intel_test.tar.bz2
(2) netcdf-4.4.1.1-intel_test.tar.bz2
(3) netcdf-fortran-4.4.4-intel_test.tar.bz2
(4) jasper_test-2.0.12-intel_test.tar.bz2
(5) wrf-3.9.1-intel_test.tar.bz2
(6) wps-3.9.1-intel_test.tar.bz2
(7) gsi-3.5-intel_test.tar.bz2
(8) CRTM_2.2.3.tar.gz

In the box: run `conda install -f` for all of the above required packages
            run `export LD_LIBRARY_PATH=/opt/miniconda2/envs/wrf/lib:$LD_LIBRARY_PATH`
            run `conda install krb5 -n wrf`

2. Test if the builds are working:
(1) => cd /opt/miniconda2/envs/wrf/wps-3.9
    ldd geogrid.exe / ungrib.exe / metgrid.exe
(2) => cd /opt/miniconda2/envs/wrf/wrf-3.9.1/test/em_real
    ldd real.exe / wrf.exe
(3) => cd /opt/miniconda2/envs/wrf/comGSIv3.5_EnKFv1.1/run
    ldd gsi.exe





