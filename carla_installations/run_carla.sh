
# Load required modules
module load virtualgl/2.5.2
module load openmpi/5.0.1

# Set up XDG_RUNTIME_DIR
export XDG_RUNTIME_DIR=/tmp/$USER-runtime-dir
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# Disable audio to avoid ALSA errors
export SDL_AUDIODRIVER=dummy

# Run CARLA with VirtualGL for off-screen rendering
vglrun ./CarlaUE4.sh -RenderOffScreen -opengl --no-sandbox
