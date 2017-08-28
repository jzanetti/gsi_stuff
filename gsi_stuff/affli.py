import subprocess
import os
import logging

def run_executables(cmd, working_dir):
    try:
        soutput = subprocess.check_output(cmd, shell=True, cwd=working_dir)
        return soutput
    except subprocess.CalledProcessError as e:
        print e.output
        
def test_if_data_available(data_filepath):
    if data_filepath != '':
        if os.path.exists(data_filepath) == False:
            raise Exception('data: \'{}\' is not available'.format(data_filepath))

def test_all(gsi_config):
    """check if background files are available"""
    test_if_data_available(gsi_config.path_config['background_data'])
    """check if all required obs are available and do the linking"""
    bufr_filename_keys = gsi_config.path_config['bufr_ob_filname_to_type'].keys()
    for ckey in gsi_config.path_config['bufr_ob_filname_to_type'].keys():
        test_if_data_available(gsi_config.path_config['bufr_ob_filname_to_type'][ckey])
        link_cmd = 'ln -sf {} {}/{}'.format(gsi_config.path_config['bufr_ob_filname_to_type'][ckey], gsi_config.gsi_working_dir, ckey)
        logging.info(' -- {}'.format(link_cmd))
        run_executables(link_cmd, gsi_config.gsi_working_dir)
        