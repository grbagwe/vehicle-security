import carla
import random
import cv2
import numpy as np
import time

# Configuration for video recording
OUTPUT_FILE = 'test_ego_vehicle_camera.mp4'
FPS = 30  # Frames per second
FRAME_WIDTH = 800
FRAME_HEIGHT = 600

# Connect to the CARLA server
client = carla.Client('localhost', 2000)
client.set_timeout(10.0)

# Get the world
world = client.get_world()

# Get the blueprint library
blueprint_library = world.get_blueprint_library()

# Choose a vehicle blueprint (e.g., Tesla Model 3)
vehicle_bp = blueprint_library.find('vehicle.tesla.model3')
vehicle_bp.set_attribute('role_name', 'ego')

# Get a random spawn point
spawn_points = world.get_map().get_spawn_points()
spawn_point = random.choice(spawn_points)

# Spawn the ego vehicle
ego_vehicle = world.spawn_actor(vehicle_bp, spawn_point)
print("Ego vehicle spawned!")

# Enable autopilot (optional)
ego_vehicle.set_autopilot(True)

# Choose the RGB camera blueprint
camera_bp = blueprint_library.find('sensor.camera.rgb')
camera_bp.set_attribute('image_size_x', str(FRAME_WIDTH))
camera_bp.set_attribute('image_size_y', str(FRAME_HEIGHT))
camera_bp.set_attribute('fov', '90')

# Set the camera location relative to the vehicle
camera_transform = carla.Transform(carla.Location(x=1.5, z=2.4))
camera = world.spawn_actor(camera_bp, camera_transform, attach_to=ego_vehicle)

# Initialize video writer
fourcc = cv2.VideoWriter_fourcc(*'mp4v')
video_writer = cv2.VideoWriter(OUTPUT_FILE, fourcc, FPS, (FRAME_WIDTH, FRAME_HEIGHT))

# Function to convert the image to OpenCV format and save it
def process_image(image):
    # Convert raw image data to numpy array
    array = np.frombuffer(image.raw_data, dtype=np.uint8)
    array = array.reshape((FRAME_HEIGHT, FRAME_WIDTH, 4))
    frame = array[:, :, :3]  # Drop alpha channel

    # Write the frame to the video file
    video_writer.write(frame)

    # Display the frame (optional, for debugging)
    #cv2.imshow('Ego Vehicle Camera', frame)
    #cv2.waitKey(1)

# Attach the function to the camera sensor
camera.listen(lambda image: process_image(image))

# Record for a fixed amount of time
try:
    time.sleep(30)  # Record for 30 seconds
finally:
    # Clean up
    camera.stop()
    video_writer.release()
    ego_vehicle.destroy()
    camera.destroy()
    #cv2.destroyAllWindows()
    print("Recording saved to", OUTPUT_FILE)

