import numpy as np


# 100 % CLAUDE CODE GENERATED



# 1. Load your FULL exported weights (117 features per neuron)
# For this example script, we initialize 4 neurons with 117 weights each using random 
# integers in our Q3.5 range, but you should paste your exact 117-length arrays here.
np.random.seed(42) # Ensuring reproducible demo arrays
W1 = np.random.randint(-50, 50, size=(4, 117)) 
B1 = np.array([-14, 8, 3, -29])

W2 = np.array([[18, -44, 25, -11]]) # Shape (1, 4) for proper matrix multiplication
B2 = 7

# 2. Define MULTIPLE mushroom samples (A batch of test inputs)
# Let's create an array of 3 different mushrooms, each with 117 binary features.
# rows = mushrooms, columns = features
mushrooms_batch = np.zeros((3, 117))

# Mushroom 0: Has feature 25 active (Let's say it's an edible configuration)
mushrooms_batch[0, 25] = 1

# Mushroom 1: Has features 12, 50, and 88 active (Let's say it's a dangerous mix)
mushrooms_batch[1, 12] = 1
mushrooms_batch[1, 50] = 1
mushrooms_batch[1, 88] = 1

# Mushroom 2: Completely different mix
mushrooms_batch[2, 5] = 1
mushrooms_batch[2, 102] = 1


# --- LAYER 1 (Hidden Layer) ---
# Batch Matrix Multiplication: (Batch x Features) * (Neurons x Features).T + Bias
# Resulting shape: (3, 4) -> 3 mushrooms, each hitting 4 hidden neurons
hidden_logits = np.dot(mushrooms_batch, W1.T) + B1

# ReLU Activation Function across the whole batch
hidden_outputs = np.maximum(0, hidden_logits)


# --- LAYER 2 (Output Layer) ---
# Inputs to Layer 2 are the hidden_outputs (Shape: 3 x 4)
# Multiplying by W2.T (Shape: 4 x 1) yields (Shape: 3 x 1)
output_logit = np.dot(hidden_outputs, W2.T) + (B2 * 32)

# Shift back down to Q3.5 scale (divide by 32)
final_scores = output_logit // 32


# --- EVALUATE THE ENTIRE BATCH ---
print("="*45)
print("FIXED-POINT BATCH EVALUATION RESULTS")
print("="*45)

for idx, score in enumerate(final_scores.flatten()):
    # In Q3.5 format, the threshold float '0.5' is the integer 16 (0.5 * 32)
    status = "POISONOUS" if score >= 16 else "EDIBLE"
    print(f"Mushroom #{idx}: Calculated Score = {score} | Classification = {status}")
print("="*45)