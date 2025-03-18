#!/bin/bash
#SBATCH --job-name=download_install_ollma
#SBATCH --mem=24G
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=1
#SBATCH --output=download_install_ollma.log

# Palmetto modules



# pull ollama docker image
apptainer pull docker://ollama/ollama


