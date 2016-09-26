package 'reprepro'

# Dedicated directory for the repository
directory node['reprepro']['main_path']
directory node['reprepro']['main_path_conf']

cookbook_file node['reprepro']['main_path_conf_opt']
template node['reprepro']['main_path_conf_dist']

