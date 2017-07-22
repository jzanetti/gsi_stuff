import gsi_config
import os
import affli
import shutil
from string import Template
import logging

class MyTemplate(Template):
    delimiter = '@'

def create_folder():
    logging.info('-------------------------------------------')
    logging.info('1.1 Create Directories')
    logging.info('-------------------------------------------')

    if os.path.exists(gsi_config.gsi_working_dir) == False:
        logging.info(' -- Create gsi working directory: {} '.format(gsi_config.gsi_working_dir))
        os.makedirs(gsi_config.gsi_working_dir)

    if os.path.exists(gsi_config.script_dir) == False:
        logging.info(' -- Create gsi script directory: {} '.format(gsi_config.script_dir))
        os.makedirs(gsi_config.script_dir)
    
    if os.path.exists(gsi_config.obs_dir) == False:
        logging.info(' -- Create gsi observation directory: {} '.format(gsi_config.obs_dir))
        os.makedirs(gsi_config.obs_dir)   

    if os.path.exists(gsi_config.fix_dir) == False:
        logging.info(' -- Create gsi fix directory: {} '.format(gsi_config.fix_dir))
        os.makedirs(gsi_config.fix_dir)

    # dummy crtm if no satellite radiance assimilated
    if os.path.exists(gsi_config.path_config['crtm_root']) == False:
        logging.info(' -- Create gsi crtm directory: {} '.format(gsi_config.path_config['crtm_root']))
        os.makedirs(gsi_config.path_config['crtm_root'])
    
    logging.info('   * Linking fixed files from {}/fix to {} '.format(gsi_config.path_config['gsi_root'], gsi_config.fix_dir))
    affli.run_executables('ln -sf {} {}'.format(gsi_config.path_config['gsi_root'] + '/fix/*', gsi_config.fix_dir), 
                          gsi_config.gsi_working_dir)

def create_script_for_run_gsi_region():
    logging.info('------------------------------------------- ')
    logging.info('1.2 Create GSI scripts ')
    logging.info('------------------------------------------- ')
    
    logging.info(' -- Getting run_gsi_regional template from: {}\n'.format('etc/run_gsi_regional_template.ksh'))
    filein = open('etc/run_gsi_regional_template.ksh')
    src = MyTemplate(filein.read())
    
    """parmater preprocessing"""
    logging.info(' -- Observation Types:')
    if 'prepbufr' in gsi_config.path_config['bufr_ob_filname_to_type'].keys():
        conv_datapath =  gsi_config.path_config['bufr_ob_filname_to_type']['prepbufr']
        logging.info('   * prepbufr: conventional observations from :{} '.format(conv_datapath))
    else:
        conv_datapath = ''
    
    logging.info(' -- Background data:')
    bk_path = gsi_config.path_config['background_data']
    logging.info('   * background data from :{} '.format(bk_path))
    bk_root = os.path.dirname(bk_path)
        
    """parse arguments"""
    d = {'gsiproc': gsi_config.gsi_processor,
         'platform': gsi_config.computing_platform,
         'analysis_datetime': gsi_config.analysis_datetime,
         'gsi_workdir': gsi_config.gsi_working_dir,
         'obs_dir': gsi_config.obs_dir,
         'gsi_script': gsi_config.script_dir,
         'prepbufr': conv_datapath,
         'bk_root': bk_root,
         'bk_path': bk_path,
         'crtm_root': gsi_config.path_config['crtm_root'],
         'gsi_root': gsi_config.path_config['gsi_root'],
         'bk_core': gsi_config.model_core,
         'cv_option': gsi_config.cv_option
        }
    
    result = src.substitute(d)
    text_file = open('{}/run_gsi_regional.ksh'.format(gsi_config.script_dir), "w")
    text_file.write(result)
    text_file.close()

def create_anavinfo_arw_netcdf(bk_vertical_level):
    logging.info('------------------------------------------- ')
    logging.info('1.3 Create NETCDF info ')
    logging.info('------------------------------------------- ')
    
    logging.info(' -- Getting navinfo_arw_netcdf template from: {} '.format('etc/anavinfo_arw_netcdf_template'))
    filein = open('etc/anavinfo_arw_netcdf_template')
    src = MyTemplate(filein.read())

    """parse arguments"""
    d = {'lev': gsi_config.model_config['model_vertical_level'],
         'lev0': gsi_config.model_config['model_vertical_level']+1
        }

    logging.info('   * NETCDF vertical levels :{} '.format(gsi_config.model_config['model_vertical_level']))    
    result = src.substitute(d)
    text_file = open('{}/anavinfo_arw_netcdf'.format(gsi_config.fix_dir), "w")
    text_file.write(result)
    text_file.close()

def create_comgsi_namelist(single_obs=False):
    logging.info('------------------------------------------- ')
    logging.info('1.4 Create GSI namelist')
    logging.info('------------------------------------------- ')
    
    logging.info(' -- Getting GSI namelist template from: {} '.format('etc/comgsi_namelist_template.sh'))
    filein = open('etc/comgsi_namelist_template.sh')
    src = MyTemplate(filein.read())

    """parse arguments"""
    d = {'outloop': gsi_config.analysis_config['outer_loop'],
         'innerloop': gsi_config.analysis_config['inner_loop'],
         'single_obs': str(single_obs).lower(),
         'cycle_interval': gsi_config.analysis_config['cycle_interval'],
        }
    
    logging.info('    * outloop: {} '.format(gsi_config.analysis_config['outer_loop']))
    logging.info('    * innerloop: {} '.format(gsi_config.analysis_config['inner_loop']))
    logging.info('    * cycle_interval: {} '.format(gsi_config.analysis_config['cycle_interval']))
    
    result = src.substitute(d)
    text_file = open('{}/comgsi_namelist.sh'.format(gsi_config.script_dir), "w")
    text_file.write(result)
    text_file.close()

