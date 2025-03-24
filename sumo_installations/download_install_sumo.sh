#!/bin/bash
#SBATCH --job-name=install_sumo
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --output=install_sumo.log

# === Load Anaconda and Activate Environment ===
module load anaconda3
source activate carla-sim

# === Define Installation Paths ===
INSTALL_DIR="/scratch/$USER/Projects/sumo-install"
SRC_DIR="$INSTALL_DIR/src"
BUILD_DIR="$SRC_DIR/sumo/build"
BASHRC_FILE="$HOME/.bashrc"

echo "[INFO] Installing SUMO into: $INSTALL_DIR using Conda env: carla-sim"

# === Create Directories ===
mkdir -p "$SRC_DIR"
cd "$SRC_DIR" || exit 1

# === Clone SUMO Repository ===
if [ ! -d "sumo" ]; then
    echo "[INFO] Cloning SUMO source..."
    git clone https://github.com/eclipse/sumo.git
    cd sumo
    git checkout v1_18_0  # Use a stable release tag
else
    echo "[INFO] SUMO repo already exists, skipping clone."
    cd sumo
fi

# === Build and Install SUMO ===
mkdir -p build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
make install

# === Set Environment Variables ===
SUMO_HOME_LINE="export SUMO_HOME=$INSTALL_DIR/share/sumo"
PATH_LINE="export PATH=$INSTALL_DIR/bin:\$PATH"
PYTHONPATH_LINE="export PYTHONPATH=\$SUMO_HOME/tools:\$PYTHONPATH"

# Add to ~/.bashrc if not already there
if ! grep -Fxq "$SUMO_HOME_LINE" "$BASHRC_FILE"; then
    echo "$SUMO_HOME_LINE" >> "$BASHRC_FILE"
    echo "$PATH_LINE" >> "$BASHRC_FILE"
    echo "$PYTHONPATH_LINE" >> "$BASHRC_FILE"
    echo "[INFO] Added SUMO environment variables to ~/.bashrc"
else
    echo "[INFO] SUMO environment variables already exist in ~/.bashrc"
fi

# === Export for Current Session ===
export SUMO_HOME=$INSTALL_DIR/share/sumo
export PATH=$INSTALL_DIR/bin:$PATH
export PYTHONPATH=$SUMO_HOME/tools:$PYTHONPATH

# === Verify Installation ===
echo "[INFO] Verifying SUMO installation..."
sumo --version || echo "[WARNING] 'sumo' command failed. Check PATH."
python -c "import traci; print('[INFO] TraCI loaded from:', traci.__file__)" || echo "[WARNING] Could not import 'traci'"

echo "[INFO] SUMO installation completed."

