import gsi_config
import affli

def plot_single_obs():
    plotting_ncl = '{}/util/Analysis_Utilities/plots_ncl/GSI_singleobs_arw.ncl'.format(gsi_config.analysis_config['GSI_ROOT'])
    affli.run_executables('cp -rf {} {}/GSI_singleobs_arw_default.ncl'.format(plotting_ncl, gsi_config.gsi_working_dir), gsi_config.gsi_working_dir)
    