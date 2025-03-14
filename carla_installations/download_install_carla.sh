#!/bin/bash
#SBATCH --job-name=download_install_carla
#SBATCH --mem=24G
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=1
#SBATCH --output=download_install_carla.log

# Palmetto modules
module load anaconda3
module load cuda


# Define the target directory
CARLA_DIR="/scratch/$USER/Projects/carla"

# Download the CARLA package
CARLA_URL="https://tiny.carla.org/carla-0-9-15-linux"
CARLA_TAR="carla-0.9.15-linux.tar.gz"


CURRENT_DIR=$(pwd)
# Load Anaconda module
module load anaconda3

# Set the Anaconda environment name
ENV_NAME="carla-sim"

# Function to check if the conda environment exists
env_exists() {
    conda info --envs | awk '{print $1}' | grep -wq "$ENV_NAME"
}

# Initialize Conda (ensuring conda commands work properly)
eval "$(conda shell.bash hook)"

if env_exists; then
    echo "Activating Anaconda environment: $ENV_NAME"
    source activate "$ENV_NAME"
else
    echo "Conda environment '$ENV_NAME' does not exist. Creating it now."

    # Get the current working directory
    cd "$CURRENT_DIR"

    # Create the environment from the YML file
    conda env create -f environment_carla.yml -y

    # Set up runtime directory
    export XDG_RUNTIME_DIR=/tmp/$USER-runtime-dir

    # Activate the newly created environment
    source activate "$ENV_NAME"

    # Install necessary packages
    pip install carla
    pip install opencv-python
    pip install opencv-python-headless

    echo "Environment '$ENV_NAME' created and configured successfully."
fi

# Create the directory if it doesn't exist
if [ ! -d "$CARLA_DIR" ]; then
    echo "Creating directory: $CARLA_DIR"
    mkdir -p "$CARLA_DIR"
else
    echo "Directory already exists: $CARLA_DIR"
fi

# Change to the CARLA directory
cd "$CARLA_DIR"

# Download CARLA if it doesn't exist
if [ ! -f "$CARLA_TAR" ]; then
    echo "Downloading CARLA (progress hidden)..."
    wget -q -O "$CARLA_TAR" "$CARLA_URL"
else
    echo "TAR file alread exists using: $CARLA_TAR"
fi

# Extract the CARLA package
echo "Extracting $CARLA_TAR..."
tar -xvzf "$CARLA_TAR"


# Ensure XDG_RUNTIME_DIR is added to ~/.bashrc if not already present
BASHRC_FILE="$HOME/.bashrc"
XDG_EXPORT="export XDG_RUNTIME_DIR=/tmp/\$USER-runtime-dir"

if ! grep -qxF "$XDG_EXPORT" "$BASHRC_FILE"; then
    echo "Adding XDG_RUNTIME_DIR to ~/.bashrc"
    echo "$XDG_EXPORT" >> "$BASHRC_FILE"
else
    echo "XDG_RUNTIME_DIR is already set in ~/.bashrc"
fi

cp "$CURRENT_DIR/save_sim.py" "$CARLA_DIR/"
cp "$CURRENT_DIR/run_carla.sh" "$CARLA_DIR/"

# Cleaning
rm -rf "$CARLA_TAR"

