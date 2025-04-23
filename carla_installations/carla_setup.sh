#!/bin/bash

module load anaconda3
cd /project/xiaoyon/trustai/carla
conda env create -f environment_carla.yml -y

export XDG_RUNTIME_DIR=/tmp/$USER-runtime-dir
source activate carla-sim
pip install carla
pip install opencv-python
pip install opencv-python-headless

