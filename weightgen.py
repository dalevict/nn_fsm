import pandas as pd
import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim
from sklearn.model_selection import train_test_split

url = "https://archive.ics.uci.edu/ml/machine-learning-databases/mushroom/agaricus-lepiota.data"
columns = [
    "class", "cap-shape", "cap-surface", "cap-color", "bruises", "odor",
    "gill-attachment", "gill-spacing", "gill-size", "gill-color", "stalk-shape",
    "stalk-root", "stalk-surface-above-ring", "stalk-surface-below-ring",
    "stalk-color-above-ring", "stalk-color-below-ring", "veil-type", "veil-color",
    "ring-number", "ring-type", "spore-print-color", "population", "habitat"
]
df = pd.read_csv(url, names=columns)


# PREPROCESSING

y = (df["class"] == "p").astype(int).values
X_categorical = df.drop(columns=["class"])
X_encoded = pd.get_dummies(X_categorical, dtype=int)
X = X_encoded.values
feature_names = X_encoded.columns.tolist()
input_dim = X.shape[1]

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

X_train_t = torch.tensor(X_train, dtype=torch.float32)
y_train_t = torch.tensor(y_train, dtype=torch.float32).unsqueeze(1)
X_test_t = torch.tensor(X_test, dtype=torch.float32)
y_test_t = torch.tensor(y_test, dtype=torch.float32).unsqueeze(1)


# TRAINING

class TinyMushroomNN(nn.Module):
    def __init__(self, input_dim):
        super(TinyMushroomNN, self).__init__()
        self.hidden = nn.Linear(input_dim, 4)
        self.output = nn.Linear(4, 1)
        self.relu = nn.ReLU()
        self.sigmoid = nn.Sigmoid()

    def forward(self, x):
        x = self.relu(self.hidden(x))
        x = self.sigmoid(self.output(x))
        return x

model = TinyMushroomNN(input_dim)

criterion = nn.BCELoss()
optimizer = optim.Adam(model.parameters(), lr=0.05)

epochs_log = []
for epoch in range(1, 101):
    model.train()
    optimizer.zero_grad()
    predictions = model(X_train_t)
    loss = criterion(predictions, y_train_t)
    loss.backward()
    optimizer.step()
    if epoch % 10 == 0 or epoch == 1:
        epochs_log.append(f"Epoch {epoch:3d}/100 - Loss: {loss.item():.4f}")


# EVALUATION

model.eval()
with torch.no_grad():
    test_preds = model(X_test_t)
    test_preds_binary = (test_preds >= 0.5).float()
    accuracy = (test_preds_binary == y_test_t).float().mean().item() * 100

scale = 32
hidden_weights = model.hidden.weight.detach().numpy()
hidden_bias = model.hidden.bias.detach().numpy()
output_weights = model.output.weight.detach().numpy()
output_bias = model.output.bias.detach().numpy()

quant_h_w = np.round(hidden_weights * scale).astype(int)
quant_h_b = np.round(hidden_bias * scale).astype(int)
quant_o_w = np.round(output_weights * scale).astype(int)
quant_o_b = np.round(output_bias * scale).astype(int)


# WRITE TO TXT

output_text = []
output_text.append("="*60)
output_text.append("MUSHROOM NN TRAINING & VERILOG EXPORT REPORT")
output_text.append("="*60)
output_text.append(f"Total one-hot encoded input dimensions: {input_dim}")
output_text.append(f"Final Test Accuracy: {accuracy:.2f}%\n")

output_text.append("--- TRAINING PROGRESS LOG ---")
output_text.extend(epochs_log)
output_text.append("")

output_text.append("--- INPUT FEATURE MAPPING INDEXES ---")
for idx, name in enumerate(feature_names):
    output_text.append(f"Index {idx:3d}: {name}")
output_text.append("")

output_text.append("--- QUANTIZED WEIGHTS & BIASES (Q3.5 Format: Signed Float * 32) ---")
output_text.append("\n[Layer 1: Hidden Weights (4 Neurons x 117 Inputs)]")
for i, neuron_weights in enumerate(quant_h_w):
    weights_str = ", ".join(map(str, neuron_weights))
    output_text.append(f"Neuron_{i}_Weights = [{weights_str}]")

output_text.append("\n[Layer 1: Hidden Biases (4 Neurons)]")
output_text.append(f"Hidden_Biases = {list(quant_h_b)}")

output_text.append("\n[Layer 2: Output Weights (1 Neuron x 4 Inputs)]")
output_text.append(f"Output_Weights = {list(quant_o_w[0])}")

output_text.append("\n[Layer 2: Output Bias (1 Neuron)]")
output_text.append(f"Output_Bias = [{quant_o_b[0]}]")

filename = "weights.txt"
with open(filename, "w") as f:
    f.write("\n".join(output_text))

print(f"File saved successfully as {filename}")