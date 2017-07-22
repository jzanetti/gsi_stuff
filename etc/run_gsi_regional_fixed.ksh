##################################################################################

echo " Copy fixed files and link CRTM coefficient files to working directory"

# Set fixed files
#   berror   = forecast model background error statistics
#   specoef  = CRTM spectral coefficients
#   trncoef  = CRTM transmittance coefficients
#   emiscoef = CRTM coefficients for IR sea surface emissivity model
#   aerocoef = CRTM coefficients for aerosol effects
#   cldcoef  = CRTM coefficients for cloud effects
#   satinfo  = text file with information about assimilation of brightness temperatures
#   satangl  = angle dependent bias correction file (fixed in time)
#   pcpinfo  = text file with information about assimilation of prepcipitation rates
#   ozinfo   = text file with information about assimilation of ozone data
#   errtable = text file with obs error for conventional data (regional only)
#   convinfo = text file with information about assimilation of conventional data
#   bufrtable= text file ONLY needed for single obs test (oneobstest=.true.)
#   bftab_sst= bufr table for sst ONLY needed for sst retrieval (retrieval=.true.)

if [ ${bkcv_option} = GLOBAL ] ; then
  echo ' Use global background error covariance'
  BERROR=${FIX_ROOT}/${BYTE_ORDER}/nam_glb_berror.f77.gcv
  OBERROR=${FIX_ROOT}/prepobs_errtable.global
  if [ ${bk_core} = NMM ] ; then
     ANAVINFO=${FIX_ROOT}/anavinfo_ndas_netcdf_glbe
  fi
  if [ ${bk_core} = ARW ] ; then
    ANAVINFO=${FIX_ROOT}/anavinfo_arw_netcdf_glbe
  fi
  if [ ${bk_core} = NMMB ] ; then
    ANAVINFO=${FIX_ROOT}/anavinfo_nems_nmmb_glb
  fi
else
  echo ' Use NAM background error covariance'
  BERROR=${FIX_ROOT}/${BYTE_ORDER}/nam_nmmstat_na.gcv
  OBERROR=${FIX_ROOT}/nam_errtable.r3dv
  if [ ${bk_core} = NMM ] ; then
     ANAVINFO=${FIX_ROOT}/anavinfo_ndas_netcdf
  fi
  if [ ${bk_core} = ARW ] ; then
     ANAVINFO=${FIX_ROOT}/anavinfo_arw_netcdf
  fi
  if [ ${bk_core} = NMMB ] ; then
     ANAVINFO=${FIX_ROOT}/anavinfo_nems_nmmb
  fi
fi

SATINFO=${FIX_ROOT}/global_satinfo.txt
CONVINFO=${FIX_ROOT}/global_convinfo_user_defined.txt
OZINFO=${FIX_ROOT}/global_ozinfo.txt
PCPINFO=${FIX_ROOT}/global_pcpinfo.txt

#  copy Fixed fields to working directory
 cp $ANAVINFO anavinfo
 cp $BERROR   berror_stats
 cp $SATINFO  satinfo
 cp $CONVINFO convinfo
 cp $OZINFO   ozinfo
 cp $PCPINFO  pcpinfo
 cp $OBERROR  errtable
#
#    # CRTM Spectral and Transmittance coefficients
CRTM_ROOT_ORDER=${CRTM_ROOT}/${BYTE_ORDER}
emiscoef_IRwater=${CRTM_ROOT_ORDER}/Nalli.IRwater.EmisCoeff.bin
emiscoef_IRice=${CRTM_ROOT_ORDER}/NPOESS.IRice.EmisCoeff.bin
emiscoef_IRland=${CRTM_ROOT_ORDER}/NPOESS.IRland.EmisCoeff.bin
emiscoef_IRsnow=${CRTM_ROOT_ORDER}/NPOESS.IRsnow.EmisCoeff.bin
emiscoef_VISice=${CRTM_ROOT_ORDER}/NPOESS.VISice.EmisCoeff.bin
emiscoef_VISland=${CRTM_ROOT_ORDER}/NPOESS.VISland.EmisCoeff.bin
emiscoef_VISsnow=${CRTM_ROOT_ORDER}/NPOESS.VISsnow.EmisCoeff.bin
emiscoef_VISwater=${CRTM_ROOT_ORDER}/NPOESS.VISwater.EmisCoeff.bin
emiscoef_MWwater=${CRTM_ROOT_ORDER}/FASTEM6.MWwater.EmisCoeff.bin
aercoef=${CRTM_ROOT_ORDER}/AerosolCoeff.bin
cldcoef=${CRTM_ROOT_ORDER}/CloudCoeff.bin

ln -s $emiscoef_IRwater ./Nalli.IRwater.EmisCoeff.bin
ln -s $emiscoef_IRice ./NPOESS.IRice.EmisCoeff.bin
ln -s $emiscoef_IRsnow ./NPOESS.IRsnow.EmisCoeff.bin
ln -s $emiscoef_IRland ./NPOESS.IRland.EmisCoeff.bin
ln -s $emiscoef_VISice ./NPOESS.VISice.EmisCoeff.bin
ln -s $emiscoef_VISland ./NPOESS.VISland.EmisCoeff.bin
ln -s $emiscoef_VISsnow ./NPOESS.VISsnow.EmisCoeff.bin
ln -s $emiscoef_VISwater ./NPOESS.VISwater.EmisCoeff.bin
ln -s $emiscoef_MWwater ./FASTEM6.MWwater.EmisCoeff.bin
ln -s $aercoef  ./AerosolCoeff.bin
ln -s $cldcoef  ./CloudCoeff.bin
# Copy CRTM coefficient files based on entries in satinfo file
for file in `awk '{if($1!~"!"){print $1}}' ./satinfo | sort | uniq` ;do
   ln -s ${CRTM_ROOT_ORDER}/${file}.SpcCoeff.bin ./
   ln -s ${CRTM_ROOT_ORDER}/${file}.TauCoeff.bin ./
done

# Only need this file for single obs test
 bufrtable=${FIX_ROOT}/prepobs_prep.bufrtable
 cp $bufrtable ./prepobs_prep.bufrtable

# for satellite bias correction
cp ${FIX_ROOT}/gdas1.t00z.abias.20150617 ./satbias_in
cp ${FIX_ROOT}/gdas1.t00z.abias_pc.20150617  ./satbias_pc

#
##################################################################################
# Set some parameters for use by the GSI executable and to build the namelist
echo " Build the namelist "

# default is NAM
#   as_op='1.0,1.0,0.5 ,0.7,0.7,0.5,1.0,1.0,'
vs_op='1.0,'
hzscl_op='0.373,0.746,1.50,'
if [ ${bkcv_option} = GLOBAL ] ; then
#   as_op='0.6,0.6,0.75,0.75,0.75,0.75,1.0,1.0'
   vs_op='0.7,'
   hzscl_op='1.7,0.8,0.5,'
fi
if [ ${bk_core} = NMMB ] ; then
   vs_op='0.6,'
fi

# default is NMM
   bk_core_arw='.false.'
   bk_core_nmm='.true.'
   bk_core_nmmb='.false.'
   bk_if_netcdf='.true.'
if [ ${bk_core} = ARW ] ; then
   bk_core_arw='.true.'
   bk_core_nmm='.false.'
   bk_core_nmmb='.false.'
   bk_if_netcdf='.true.'
fi
if [ ${bk_core} = NMMB ] ; then
   bk_core_arw='.false.'
   bk_core_nmm='.false.'
   bk_core_nmmb='.true.'
   bk_if_netcdf='.false.'
fi

if [ ${if_observer} = Yes ] ; then
  nummiter=0
  if_read_obs_save='.true.'
  if_read_obs_skip='.false.'
else
  nummiter=0
  if_read_obs_save='.false.'
  if_read_obs_skip='.false.'
fi

# Build the GSI namelist on-the-fly
. $GSI_NAMELIST
cat << EOF > gsiparm.anl

 $comgsi_namelist

EOF

###################################################
# modify the anavinfo vertical levels based on wrf_inout, for WRF ARW and NMM
if [ ${bk_core} = ARW ] || [ ${bk_core} = NMM ] ; then
bklevels=`ncdump -h wrf_inout | grep "bottom_top =" | awk '{print $3}' `
bklevels_stag=`ncdump -h wrf_inout | grep "bottom_top_stag =" | awk '{print $3}' `
anavlevels=`cat anavinfo | grep ' sf ' | tail -1 | awk '{print $2}' `  # levels of sf, vp, u, v, t, etc
anavlevels_stag=`cat anavinfo | grep ' prse ' | tail -1 | awk '{print $2}' `  # levels of prse
sed -i 's/ '$anavlevels'/ '$bklevels'/g' anavinfo
sed -i 's/ '$anavlevels_stag'/ '$bklevels_stag'/g' anavinfo
fi
#
###################################################
#  run  GSI
###################################################
echo ' Run GSI with' ${bk_core} 'background'

case $ARCH in
   'IBM_LSF')
      ${RUN_COMMAND} ./gsi.exe < gsiparm.anl > stdout 2>&1  ;;

   * )
      ${RUN_COMMAND} ./gsi.exe > stdout 2>&1  ;;
esac

##################################################################
#  run time error check
##################################################################
error=$?

if [ ${error} -ne 0 ]; then
  echo "ERROR: ${GSI} crashed  Exit status=${error}"
  exit ${error}
fi

#
##################################################################
#
#   GSI updating satbias_in
#
# GSI updating satbias_in (only for cycling assimilation)

# Copy the output to more understandable names
ln -s stdout      stdout.anl.${ANAL_TIME}
ln -s wrf_inout   wrfanl.${ANAL_TIME}
ln -s fort.201    fit_p1.${ANAL_TIME}
ln -s fort.202    fit_w1.${ANAL_TIME}
ln -s fort.203    fit_t1.${ANAL_TIME}
ln -s fort.204    fit_q1.${ANAL_TIME}
ln -s fort.207    fit_rad1.${ANAL_TIME}

# Loop over first and last outer loops to generate innovation
# diagnostic files for indicated observation types (groups)
#
# NOTE:  Since we set miter=2 in GSI namelist SETUP, outer
#        loop 03 will contain innovations with respect to
#        the analysis.  Creation of o-a innovation files
#        is triggered by write_diag(3)=.true.  The setting
#        write_diag(1)=.true. turns on creation of o-g
#        innovation files.
#

loops="01 03"
for loop in $loops; do

case $loop in
  01) string=ges;;
  03) string=anl;;
   *) string=$loop;;
esac

#  Collect diagnostic files for obs types (groups) below
#   listall="conv amsua_metop-a mhs_metop-a hirs4_metop-a hirs2_n14 msu_n14 \
#          sndr_g08 sndr_g10 sndr_g12 sndr_g08_prep sndr_g10_prep sndr_g12_prep \
#          sndrd1_g08 sndrd2_g08 sndrd3_g08 sndrd4_g08 sndrd1_g10 sndrd2_g10 \
#          sndrd3_g10 sndrd4_g10 sndrd1_g12 sndrd2_g12 sndrd3_g12 sndrd4_g12 \
#          hirs3_n15 hirs3_n16 hirs3_n17 amsua_n15 amsua_n16 amsua_n17 \
#          amsub_n15 amsub_n16 amsub_n17 hsb_aqua airs_aqua amsua_aqua \
#          goes_img_g08 goes_img_g10 goes_img_g11 goes_img_g12 \
#          pcp_ssmi_dmsp pcp_tmi_trmm sbuv2_n16 sbuv2_n17 sbuv2_n18 \
#          omi_aura ssmi_f13 ssmi_f14 ssmi_f15 hirs4_n18 amsua_n18 mhs_n18 \
#          amsre_low_aqua amsre_mid_aqua amsre_hig_aqua ssmis_las_f16 \
#          ssmis_uas_f16 ssmis_img_f16 ssmis_env_f16 mhs_metop_b \
#          hirs4_metop_b hirs4_n19 amusa_n19 mhs_n19"
# listall=`ls pe* | cut -f2 -d"." | awk '{print substr($0, 0, length($0)-3)}' | sort | uniq `

# the following line is modified to let the program find pe*conv_*, otherwise if finds pe*con_*
  listall=`ls pe* | cut -f2 -d"." | awk '{print substr($0, 0, length($0)-2)}' | sort | uniq `
   for type in $listall; do
      count=`ls pe*${type}_${loop}* | wc -l`
      if [[ $count -gt 0 ]]; then
         cat pe*${type}_${loop}* > diag_${type}_${string}.${ANAL_TIME}
      fi
   done
done

#  Clean working directory to save only important files 
ls -l * > list_run_directory
if [[ ${if_clean} = clean  &&  ${if_observer} != Yes ]]; then
  echo ' Clean working directory after GSI run'
  rm -f *Coeff.bin     # all CRTM coefficient files
  rm -f pe0*           # diag files on each processor
  rm -f obs_input.*    # observation middle files
  rm -f siganl sigf03  # background middle files
  rm -f fsize_*        # delete temperal file for bufr size
fi
#
#
#################################################
# start to calculate diag files for each member
#################################################
#
if [ ${if_observer} = Yes ] ; then
  string=ges
  for type in $listall; do
    count=0
    if [[ -f diag_${type}_${string}.${ANAL_TIME} ]]; then
       mv diag_${type}_${string}.${ANAL_TIME} diag_${type}_${string}.ensmean
    fi
  done
  mv wrf_inout wrf_inout_ensmean

# Build the GSI namelist on-the-fly for each member
  nummiter=0
  if_read_obs_save='.false.'
  if_read_obs_skip='.true.'
. $GSI_NAMELIST
cat << EOF > gsiparm.anl

 $comgsi_namelist

EOF

# Loop through each member
  loop="01"
  ensmem=1
  while [[ $ensmem -le $no_member ]];do

     rm pe0*

     print "\$ensmem is $ensmem"
     ensmemid=`printf %3.3i $ensmem`

# get new background for each member
     if [[ -f wrf_inout ]]; then
       rm wrf_inout
     fi

     BK_FILE=${BK_FILE_mem}${ensmemid}
     echo $BK_FILE
     ln -s $BK_FILE wrf_inout

#  run  GSI
     echo ' Run GSI with' ${bk_core} 'for member ', ${ensmemid}

     case $ARCH in
        'IBM_LSF')
           ${RUN_COMMAND} ./gsi.exe < gsiparm.anl > stdout_mem${ensmemid} 2>&1  ;;

        * )
           ${RUN_COMMAND} ./gsi.exe > stdout_mem${ensmemid} 2>&1 ;;
     esac

#  run time error check and save run time file status
     error=$?

     if [ ${error} -ne 0 ]; then
       echo "ERROR: ${GSI} crashed for member ${ensmemid} Exit status=${error}"
       exit ${error}
     fi

     ls -l * > list_run_directory_mem${ensmemid}

# generate diag files

     for type in $listall; do
           count=`ls pe*${type}_${loop}* | wc -l`
        if [[ $count -gt 0 ]]; then
           cat pe*${type}_${loop}* > diag_${type}_${string}.mem${ensmemid}
        fi
     done

# next member
     (( ensmem += 1 ))
      
  done

fi

exit 0
