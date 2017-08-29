# gsi_stuff
reference:
https://www.da.ucar.edu/sites/default/files/Benjamin_BlueDA-GSD-8Mar2016.pdf

**Test GSI with external wps/wrf/gsi pkgs** <br />
1. Install the necessary packages from `/home/szhang/GitHub_branches/conda_pkg/intel-parallel/cloud/release` <br />
- hdf5-1.8.19-intel_test.tar.bz2 <br />
- netcdf-4.4.1.1-intel_test.tar.bz2 <br />
- netcdf-fortran-4.4.4-intel_test.tar.bz2 <br />
- jasper_test-2.0.12-intel_test.tar.bz2 <br />
- wrf_test-3.9.1-intel_test.tar.bz2 <br />
- wps_test-3.9.1-intel_test.tar.bz2 <br />
- gsi-3.5-intel_test.tar.bz2 <br />
- wrfda_test-3.9.1-intel_test.tar.bz2 <br />
- bufr_stuff-0.1.0-intel_test.tar.bz2 <br />
- gsi_stuff-0.1.0-python.tar.bz2 <br />
<br />
2. In the box: <br />
 -run `conda install -f` for all of the above required packages <br />
 - run `conda install krb5 -n wrf` <br />
 - run `conda install crtm -n wrf` <br />
 - run `export LD_LIBRARY_PATH=/opt/miniconda2/envs/wrf/lib:$LD_LIBRARY_PATH` <br />
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
3. Produce observations: <br />
&nbsp;&nbsp; => cd /opt/miniconda2/envs/wrf/bufr_stuff/scripts <br />
&nbsp;&nbsp; => python get_ddb.py research us-west-2 201708211100 201708211300 -50.0 -30.0 150.0 180.0 <br />
&nbsp;&nbsp;&nbsp;&nbsp; -- we would get a file called `Output.txt` under the working directory <br />
&nbsp;&nbsp; => cd /opt/miniconda2/envs/wrf/bufr_stuff/bin <br />
&nbsp;&nbsp; => ./ascii2bufr_conv.exe ../scripts/Output.txt test.bufr ../etc/conv_prep.bufrtable <br />
&nbsp;&nbsp;&nbsp;&nbsp; -- we would get a bufr file called `test.bufrt` under the working directory <br />
<br />
<br />
4. Run GSI <br />
&nbsp;&nbsp; => cd /opt/miniconda2/envs/wrf/lib/python2.7/site-packages/gsi_stuff <br />
&nbsp;&nbsp; => python Main_Script.py 2017082112 /mnt/WRF/gsi_test/practice_11 4 3 50 /mnt/WRF/wrf_1FMTHf/wrfinput_d01 /opt/miniconda2/envs/wrf/crtm-2.2.3/CRTM_2.2.3 /opt/miniconda2/envs/wrf/comGSIv3.5_EnKFv1.1 <br />


