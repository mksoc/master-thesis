#! /usr/bin/python3

import mmm

# Set variables
user = 'marco.andorno'
repo_root = '/home/marco/Documents/repos/MMM-thesis'
remote_home = f'/home/thesis/{user}/'
dest_folder = f'{remote_home}/frontend'

# Connect to remote server
session = mmm.ssh_session(user, 'vlsiwall.polito.it', 10000)

# Copy files
session.copy_to(f'{repo_root}/include/mmm_pkg.sv', dest_folder)
session.copy_to(f'{repo_root}/src/frontend/*', dest_folder)
session.copy_to(f'{repo_root}/src/branch_unit*.sv', dest_folder)