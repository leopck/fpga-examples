import torch
import torch.nn as nn
import torch.optim as optim
import random
import struct

# Helper: one-hot encode Rock(0), Paper(1), Scissors(2)
def one_hot_rps(val):
    return [1 if i == val else 0 for i in range(3)]

# Dataset generator
def generate_dataset(n=1000):
    data = []
    for _ in range(n):
        your = random.randint(0, 2)
        ai_prev = random.randint(0, 2)
        x = one_hot_rps(your) + one_hot_rps(ai_prev)
        y = torch.tensor((your + 1) % 3)  # AI should counter your move
        data.append((torch.tensor(x, dtype=torch.float32), y))
    return data

# Model
class RPSModel(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc1 = nn.Linear(6, 3)
        self.relu = nn.ReLU()
        self.fc2 = nn.Linear(3, 3)

    def forward(self, x):
        x = self.relu(self.fc1(x))
        return self.fc2(x)

# Training
def train_model():
    model = RPSModel()
    dataset = generate_dataset()
    optimizer = optim.Adam(model.parameters(), lr=0.01)
    loss_fn = nn.CrossEntropyLoss()

    for epoch in range(7):
        total_loss = 0
        for x, y in dataset:
            optimizer.zero_grad()
            pred = model(x)
            loss = loss_fn(pred.unsqueeze(0), y.unsqueeze(0))
            loss.backward()
            optimizer.step()
            total_loss += loss.item()
        print(f"Epoch {epoch+1} Loss: {total_loss/len(dataset):.4f}")
    return model

# Save weights to .bin
def save_weights_to_bin(model, path):
    with open(path, "wb") as f:
        for param in model.parameters():
            flattened = param.detach().cpu().numpy().flatten()
            f.write(struct.pack(f'{len(flattened)}f', *flattened))

model = train_model()
bin_path = "./rps_weights.bin"
torch.save(model.state_dict(), "rps_weights.pt")

#save_weights_to_bin(model, bin_path)

#bin_path

