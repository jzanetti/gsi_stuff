import os
import shutil

model_core = 'ARW'
cv_option = 'NAM'
analysis_datetime = '2017010106'
computing_platform = 'LINUX_PBS'
gsi_dir = '/home/jzanetti/gsi_directory/practice_10'
gsi_processor = 1
new_run = True

path_config = {
    'background_data': '/home/jzanetti/wrf_directory/wrf_exp_20170710/wrf/wrfinput_d01',
    'crtm_root': '/home/jzanetti/programs/CRTM_2.2.3',
    'gsi_root': '/home/jzanetti/programs/comGSIv3.5_EnKFv1.1_cloud_analysis',
    'bufr_ob_filname_to_type': {
        #'prepbufr': '/home/jzanetti/workspace/bufr_stuff_v3/obs.prepbufr',
        'prepbufr': '/home/jzanetti/github/bufr_stuff/metar_test.prepbufr',
        '1bamua': '',
        '1bhrs4': '',
        '1bmhs': '',
        'gpsro': '',
        'radwnd': '',
        #'refInGSI': '/home/jzanetti/github/bufr_stuff/NSSLRefInGSI.bufr',
        }
    }

analysis_config = {
    'outer_loop': 2,
    'inner_loop': 50,
    'cycle_interval':3,
        }

model_config = {
    'model_vertical_level': 50,
    'if_clean': 'no',
    }

gsi_working_dir = '{}/run'.format(gsi_dir)
script_dir = '{}/script'.format(gsi_dir)
fix_dir = '{}/fix'.format(gsi_dir)
obs_dir = '{}/obs/obs'.format(gsi_dir)

if new_run:
    if os.path.exists(gsi_dir):
        shutil.rmtree(gsi_dir)

if os.path.exists(gsi_dir) == False:
    os.makedirs(gsi_dir)


