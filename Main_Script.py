import create_script
import gsi_config
import affli
import logging

logging.basicConfig(filename=gsi_config.gsi_dir + '/running_log',level=logging.INFO,filemode='w',format='%(message)s')

if __name__ == '__main__':
    logging.info('\n<><><><><><><><><><><><><><><><><><><><><><>')
    logging.info('1. Preparing')
    logging.info('<><><><><><><><><><><><><><><><><><><><><><>')
    create_script.create_folder()
    create_script.create_script_for_run_gsi_region()
    create_script.create_anavinfo_arw_netcdf(gsi_config.model_config['model_vertical_level'])
    create_script.create_comgsi_namelist()
    
    
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
    
