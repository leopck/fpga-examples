import torch

# Load trained model weights (adjust filename if needed)
model_state = torch.load("rps_weights.pt", map_location=torch.device("cpu"))

# Prepare SV-style assignment strings
sv_weights = []

# Input → Hidden weights (fc1)
fc1_weight = model_state['fc1.weight'].numpy()
fc1_bias = model_state['fc1.bias'].numpy()

for i in range(3):  # hidden neurons
    for j in range(4):  # only take first 4 inputs: your[3] + ai_prev[1]
        sv_weights.append(f"W1_{i}_{j} = {fc1_weight[i][j]:.6f};")
    sv_weights.append(f"B1_{i} = {fc1_bias[i]:.6f};")

# Hidden → Output weights (fc2)
fc2_weight = model_state['fc2.weight'].numpy()
fc2_bias = model_state['fc2.bias'].numpy()

for i in range(3):  # output neurons
    for j in range(3):  # from 3 hidden neurons
        sv_weights.append(f"W2_{i}_{j} = {fc2_weight[i][j]:.6f};")
    sv_weights.append(f"B2_{i} = {fc2_bias[i]:.6f};")

# Write to text file
with open("rps_nn_weights.sv.txt", "w") as f:
    f.write("initial begin\n")
    f.write("    // Input → Hidden weights\n")
    for line in sv_weights[:15]:
        f.write(f"    {line}\n")
    f.write("\n    // Hidden → Output weights\n")
    for line in sv_weights[15:]:
        f.write(f"    {line}\n")
    f.write("end\n")

