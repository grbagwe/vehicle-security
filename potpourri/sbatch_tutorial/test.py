import torch
import torch.nn as nn

# Check for GPU
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print(f"Using device: {device}")

# Define a simple network
class SimpleNet(nn.Module):
    def __init__(self):
        super(SimpleNet, self).__init__()
        self.fc1 = nn.Linear(10, 50)
        self.fc2 = nn.Linear(50, 20)
        self.fc3 = nn.Linear(20, 1)

    def forward(self, x):
        x = torch.relu(self.fc1(x))
        x = torch.relu(self.fc2(x))
        return self.fc3(x)

# Create network and move it to device
model = SimpleNet().to(device)

# Generate random input
input_tensor = torch.randn(1, 10).to(device)

# Forward pass
output = model(input_tensor)
print(f"Network output: {output.item()}")

# Approximate pi using Monte Carlo method
def approximate_pi(num_samples: int = 1_000_000):
    x = torch.rand(num_samples, device=device)
    y = torch.rand(num_samples, device=device)
    inside_circle = (x**2 + y**2) <= 1
    pi_estimate = (inside_circle.sum().item() / num_samples) * 4
    return pi_estimate

pi_estimate = approximate_pi()
print(f"Approximate value of pi: {pi_estimate:.10f}")

