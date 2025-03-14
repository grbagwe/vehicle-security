# CARLA installtion on palmetto

If you absolutly need to install carla on palmetto you can use this script. It installs carla 0.9.15
** In future we will have a common installation for everyone in the project folder **

1. Clone this repo

''' 
git clone <repo_name> #TODO add the repo name
''' 
# run 
'''
bash download_install.sh
'''

you can specify the folder you want to install that in

it also installs the env, but if it breaks you can install it manually using the env.file

# Test

test the env by running the run_carla.sh file, then generate traffic, finally run save_sim.py

it sould create a file *.mp4



# to access the common folder setup, run 
'''
bash carla_setup.sh
''' 
