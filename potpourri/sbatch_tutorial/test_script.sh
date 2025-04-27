#!/bin/bash

# Submit this script with: sbatch FILENAME

#SBATCH --job-name=test_job               # Name of the job
#SBATCH --output=test_job_%j.out           # Standard output (%j = Job ID)
#SBATCH --error=test_job_%j.err            # Standard error (%j = Job ID)
#SBATCH --time=01:00:00                    # Max runtime (HH:MM:SS)
#SBATCH --nodes=1                          # Number of nodes
#SBATCH --ntasks=1                         # Number of tasks
#SBATCH --cpus-per-task=4                  # Number of CPU cores per task
#SBATCH --mem 12gb           # amount of memory per CPU core (Memory per Task / Cores per Task)
#SBATCH --gpus-per-task v100s:1 # gpu model and amount requested
# Created with the RCD Docs Job Builder
#
# Visit the following link to edit this job:
# https://docs.rcd.clemson.edu/palmetto/job_management/job_builder/?num_mem=12gb&use_gpus=yes&gpu_model=v100s&walltime=2%3A00%3A00&account_name=gbagwe&job_name=test_job

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE
# Load necessary modules
module load anaconda3
source activate py311 # this is the env name you use

# cd your/project/dir #just to make sure that it can find the code # use the abs directory path 

# Run your code
python test.py
