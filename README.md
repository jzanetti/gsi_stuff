# gsi_stuff
reference:
https://www.da.ucar.edu/sites/default/files/Benjamin_BlueDA-GSD-8Mar2016.pdf

Test GSI with external wps/wrf/gsi pkgs
1. Install the necessary packages from `/home/szhang/GitHub_branches/conda_pkg/intel-parallel/cloud/release` <br />
(1) hdf5-1.8.19-intel_test.tar.bz2 <br />
(2) netcdf-4.4.1.1-intel_test.tar.bz2 <br />
(3) netcdf-fortran-4.4.4-intel_test.tar.bz2 <br />
(4) jasper_test-2.0.12-intel_test.tar.bz2 <br />
(5) wrf_test-3.9.1-intel_test.tar.bz2 <br />
(6) wps_test-3.9.1-intel_test.tar.bz2 <br />
(7) gsi-3.5-intel_test.tar.bz2 <br />
(8) wrfda_test-3.9.1-intel_test.tar.bz2 <br />
(9) bufr_stuff-0.1.0-intel_test.tar.bz2 <br />
(10) gsi_stuff-0.1.0-python.tar.bz2 <br />
<br />
In the box: <br />
&nbsp;&nbsp;&nbsp;run `conda install -f` for all of the above required packages <br />
&nbsp;&nbsp;&nbsp;run `conda install krb5 -n wrf` <br />
&nbsp;&nbsp;&nbsp;run `conda install crtm -n wrf` <br />
&nbsp;&nbsp;&nbsp;run `export LD_LIBRARY_PATH=/opt/miniconda2/envs/wrf/lib:$LD_LIBRARY_PATH` <br />
<br />
<br />
2. Test if the builds are working: <br />
&nbsp;&nbsp;(1) => cd /opt/miniconda2/envs/wrf/wps-3.9 <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ldd geogrid.exe / ungrib.exe / metgrid.exe <br />
&nbsp;&nbsp;(2) => cd /opt/miniconda2/envs/wrf/wrf-3.9.1/test/em_real <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ldd real.exe / wrf.exe <br />
&nbsp;&nbsp;(3) => cd /opt/miniconda2/envs/wrf/comGSIv3.5_EnKFv1.1/run <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ldd gsi.exe <br />
&nbsp;&nbsp;(4) => cd /opt/miniconda2/envs/wrf/wrfda-3.9.1/var/build <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ldd da_wrfvar.exe <br />
<br />
<br />
3. Produce observations:
&nbsp;&nbsp; =>`cd /opt/miniconda2/envs/wrf/bufr_stuff/scripts`
&nbsp;&nbsp; =>`python get_ddb.py research us-west-2 201708211100 201708211300 -50.0 -30.0 150.0 180.0`
&nbsp;&nbsp;&nbsp;&nbsp; -- we would get a file called `Output.txt` under the working directory
&nbsp;&nbsp; =>`/opt/miniconda2/envs/wrf/bufr_stuff/bin`
&nbsp;&nbsp; =>`./ascii2bufr_conv.exe ../scripts/Output.txt test.bufr ../etc/conv_prep.bufrtable`
&nbsp;&nbsp;&nbsp;&nbsp; -- we would get a bufr file called `test.bufrt` under the working directory
<br />
<br />
4. Run GSI
&nbsp;&nbsp; =>`cd /opt/miniconda2/envs/wrf/lib/python2.7/site-packages/gsi_stuff`
&nbsp;&nbsp; =>`python Main_Script.py 2017082112 /mnt/WRF/gsi_test/practice_11 4 1 50 /mnt/WRF/wrf_1FMTHf/wrfinput_d01 /opt/miniconda2/envs/wrf/crtm-2.2.3/CRTM_2.2.3 /opt/miniconda2/envs/wrf/comGSIv3.5_EnKFv1.1`


