import argparse
import create_script
import gsi_configfile
import affli
import logging

'''  
analysis_datetime = '2017082100'
gsi_dir = '/home/szhang/GitHub_branches/gsi_stuff/test/gsi'
gsi_processor = 3
cycle_interval = 1
model_vertical_level = 50
background_data = '/home/szhang/GitHub_branches/gsi_stuff/test/wrf/wrfinput_d01'
crtm_root = 'crtm'
gsi_root = '/home/szhang/GitHub_branches/gsi_stuff/comGSI'
f_prepbufr = 'f_prepbufr'
gsi_config = gsi_configfile.gsi_configfile(analysis_datetime, gsi_dir, gsi_processor, cycle_interval, model_vertical_level, background_data, crtm_root, gsi_root, f_prepbufr)
'''


def setup_parser():
    """read the command line arguments"""
    PARSER = argparse.ArgumentParser(description='Running GSI')

    PARSER.add_argument('analysis_datetime', type=str, help="analysis_datetime")
    PARSER.add_argument('gsi_dir', type=str, help="gsi_dir")
    PARSER.add_argument('gsi_processor', type=int, help="gsi_processor")
    PARSER.add_argument('cycle_interval', type=int, help="cycle_interval")
    PARSER.add_argument('model_vertical_level', type=int, help="model_vertical_level")
    PARSER.add_argument('background_data', type=str, help="background_data")
    PARSER.add_argument('crtm_root', type=str, help="crtm_root")
    PARSER.add_argument('gsi_root', type=str, help="gsi_root")
    
    PARSER.add_argument('--f_prepbufr', type=str, dest="f_prepbufr", default='')
    PARSER.add_argument('--f_1bamua', type=str, dest="f_1bamua", default='')
    PARSER.add_argument('--f_1bhrs4', type=str, dest="f_1bhrs4", default='')
    PARSER.add_argument('--f_1bmhs', type=str, dest="f_1bmhs", default='')
    PARSER.add_argument('--f_gpsro', type=str, dest="f_gpsro", default='')
    PARSER.add_argument('--f_radwnd', type=str, dest="f_radwnd", default='')
    PARSER.add_argument('--f_refInGSI', type=str, dest="f_refInGSI", default='')
    PARSER.add_argument('--model_core', type=str, dest="model_core", default='ARW')
    PARSER.add_argument('--cv_option', type=str, dest="cv_option", default='NAM')
    PARSER.add_argument('--computing_platform', type=str, dest="computing_platform", default='LINUX_PBS')
    PARSER.add_argument('--new_run', type=str, dest="new_run", default='True')
    PARSER.add_argument('--outer_loop', type=int, dest="outer_loop", default=2)
    PARSER.add_argument('--inner_loop', type=int, dest="inner_loop", default=50)
    PARSER.add_argument('--if_clean', type=str, dest="if_clean", default='no')

    '''
    python Main_Script.py 2017082112 /mnt/WRF/gsi_test/practice_11 4 1 50 /mnt/WRF/wrf_1FMTHf/wrfinput_d01 /opt/miniconda2/envs/wrf/crtm-2.2.3/CRTM_2.2.3 /opt/miniconda2/envs/wrf/comGSIv3.5_EnKFv1.1 --f_prepbufr /opt/miniconda2/envs/wrf/bufr_stuff/bin/test.bufr
    return PARSER.parse_args(['2017082112', '/home/szhang/gsi_directory/practice_10', 
                              4, 1, 50,
                              '/home/szhang/gsi_directory/practice_10/background_data', 
                              '/home/szhang/gsi_directory/practice_10/crtm_root', 
                              '/home/szhang/gsi_directory/practice_10/gsi_root', 
                              '--f_prepbufr', '/home/szhang/gsi_directory/practice_10/f_prepbufr'])
    '''
    return PARSER.parse_args()


def main():
    args = setup_parser()

    gsi_config = gsi_configfile.gsi_configfile(args.analysis_datetime, 
                                               args.gsi_dir, args.gsi_processor, args.cycle_interval, args.model_vertical_level, 
                                               args.background_data, args.crtm_root, args.gsi_root, 
                                               args.f_prepbufr, args.f_1bamua, args.f_1bhrs4, args.f_1bmhs, args.f_gpsro, args.f_radwnd, args. f_refInGSI,
                                               args.model_core, args.cv_option, args.computing_platform, args.new_run, 
                                               args.outer_loop, args.inner_loop, args. if_clean)
    
    logging.basicConfig(filename=gsi_config.gsi_dir + '/running_log',level=logging.INFO,filemode='w',format='%(message)s')
    if __name__ == '__main__':
        logging.info('\n<><><><><><><><><><><><><><><><><><><><><><>')
        logging.info('1. Preparing')
        logging.info('<><><><><><><><><><><><><><><><><><><><><><>')
        create_script.create_folder(gsi_config)
        create_script.create_script_for_run_gsi_region(gsi_config)
        create_script.create_anavinfo_arw_netcdf(gsi_config, gsi_config.model_config['model_vertical_level'])
        create_script.create_comgsi_namelist(gsi_config)
        
        
        logging.info('\n<><><><><><><><><><><><><><><><><><><><><><>')
        logging.info('2. Test if all necessary files are available')
        logging.info('<><><><><><><><><><><><><><><><><><><><><><>') 
        """check if background files are available"""
        affli.test_all(gsi_config)
    
    
        logging.info('\n<><><><><><><><><><><><><><><><><><><><><><>')
        logging.info('3. Run GSI')
        logging.info('<><><><><><><><><><><><><><><><><><><><><><>')
        cmd_premi = 'chmod 755 {}/run_gsi_regional.ksh'.format(gsi_config.script_dir)
        cmd_run = '{}/run_gsi_regional.ksh'.format(gsi_config.script_dir)
        logging.info(' -- {}'.format(cmd_premi))
        logging.info(' -- {}'.format(cmd_run))
        affli.run_executables(cmd_premi, gsi_config.gsi_working_dir)
        affli.run_executables(cmd_run, gsi_config.gsi_working_dir)
        
        logging.info('\n')
        logging.info('job completed')
        print 'job completed'
    
if __name__ == '__main__':
    main()

