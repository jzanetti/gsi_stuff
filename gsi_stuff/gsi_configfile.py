import os
import shutil
#from matplotlib.offsetbox import kwargs

class gsi_configfile:
    #model_core = 'ARW'
    #cv_option = 'NAM'
    #analysis_datetime = '2017010106'
    #computing_platform = 'LINUX_PBS'
    #gsi_dir = '/home/szhang/gsi_directory/practice_10'
    #gsi_processor = 1
    #new_run = True
    def __init__(self, analysis_datetime, gsi_dir, gsi_processor, 
               cycle_interval, model_vertical_level,
               background_data, crtm_root, gsi_root,
               f_prepbufr='', f_1bamua='', f_1bhrs4='', f_1bmhs='', f_gpsro='', f_radwnd='', f_refInGSI='',
               model_core='ARW', cv_option='NAM',computing_platform='LINUX_PBS',new_run='True',
               outer_loop=2, inner_loop=50, if_clean='no'):
        
        self.model_core = model_core
        self.cv_option = cv_option
        self.analysis_datetime = analysis_datetime
        self.computing_platform = computing_platform
        self.gsi_dir = gsi_dir
        self.gsi_processor = gsi_processor
        self.new_run = new_run
        

        self.path_config = {
            'background_data': background_data,
            'crtm_root': crtm_root,
            'gsi_root': gsi_root,
            'bufr_ob_filname_to_type': {
                'prepbufr': f_prepbufr,
                '1bamua': f_1bamua,
                '1bhrs4': f_1bhrs4,
                '1bmhs': f_1bmhs,
                'gpsro': f_gpsro,
                'radwnd': f_radwnd,
                'refInGSI': f_refInGSI
                }
        }

        self.analysis_config = {
            'outer_loop': outer_loop,
            'inner_loop': inner_loop,
            'cycle_interval': cycle_interval,
                }

        self.model_config = {
            'model_vertical_level': model_vertical_level,
            'if_clean': if_clean,
            }


        self.gsi_working_dir = '{}/run'.format(gsi_dir)
        self.script_dir = '{}/script'.format(gsi_dir)
        self.fix_dir = '{}/fix'.format(gsi_dir)
        self.obs_dir = '{}/obs/obs'.format(gsi_dir)

        if new_run == 'True':
            if os.path.exists(gsi_dir):
                shutil.rmtree(gsi_dir)
        
        if os.path.exists(gsi_dir) == False:
            os.makedirs(gsi_dir)


