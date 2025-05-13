#!/bin/bash

# Load required Palmetto modules
module load anaconda3
module load cuda/11.8.0

# Define environment name
ENV_NAME=3d-gs

# Create conda environment
conda create -n $ENV_NAME python=3.10 -y

# Activate environment
source activate $ENV_NAME

# Set CUDA environment variables (must be after loading module)
export CUDA_HOME=/software/slurm/spackages/linux-rocky8-x86_64/gcc-12.3.0/cuda-11.8.0-in72fn46ydgmi5ak67tvzjll5dz4w43u
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

# Install Python dependencies
pip install --upgrade pip
pip install numpy cmake ninja plyfile tqdm

# Install PyTorch with CUDA 11.8 support
pip install torch==2.0.1+cu118 torchvision==0.15.2+cu118 \
  --extra-index-url https://download.pytorch.org/whl/cu118

# Clone the repo
echo "Cloning GitHub repo..."
git clone https://github.com/graphdeco-inria/diff-gaussian-rasterization.git
cd diff-gaussian-rasterization
git submodule update --init --recursive

# Install the package
pip install .

# to develop the package comment line 36 and uncomment line 39
python setup.py develop
