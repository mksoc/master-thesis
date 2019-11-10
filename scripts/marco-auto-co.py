#! /usr/bin/python3

import mmm

# Set variables
user = 'marco.andorno'
repo_root = '/home/marco/Documents/repos/master-thesis'
remote_home = f'/home/thesis/{user}/'
src_folder = f'{remote_home}/src'
syn_folder = f'{remote_home}/syn'

# Connect to remote server
session = mmm.ssh_session(user, 'vlsiwall.polito.it', 10000)

# Copy files
# session.copy_to(f'{repo_root}/include/mmm_pkg.sv', dest_folder)
# session.copy_to(f'{repo_root}/src/frontend/*', dest_folder)
session.copy_to(f'{repo_root}/src/*.sv', src_folder)