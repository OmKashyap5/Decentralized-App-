import json
import matplotlib.pyplot as plt
from web3 import Web3
import random
import numpy as np

# Connect to the Ethereum node
web3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))  # Change to your node's address
if web3.is_connected():
    print("Connected to Ethereum Node")
else:
    raise ConnectionError("Unable to connect to Ethereum node")

# Unlock the first account
web3.eth.default_account = web3.eth.accounts[0]  # Use the first account from the node

# Load the contract ABI and bytecode from JointAccountDApp.json
with open('JointAccountDApp.json') as f:
    contract_data = json.load(f)

contract_abi = contract_data['abi']
contract_bytecode = contract_data['bytecode']

# Deploy or connect to the contract
contract = web3.eth.contract(abi=contract_abi, bytecode=contract_bytecode)
tx_hash = contract.constructor().transact()
tx_receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
contract_instance = web3.eth.contract(address=tx_receipt.contractAddress, abi=contract_abi)
print(f"Contract deployed at: {contract_instance.address}")

# Utility functions
def register_user(user_address):
    tx = contract_instance.functions.addUser(user_address).transact()
    web3.eth.wait_for_transaction_receipt(tx)

def add_edge(from_user, to_user, weight1, weight2):
    tx = contract_instance.functions.addEdge(from_user, to_user, weight1, weight2).transact()
    web3.eth.wait_for_transaction_receipt(tx)

def send_amount(from_user, to_user, amount):
    tx = contract_instance.functions.transaction(from_user, to_user, amount).transact()
    receipt = web3.eth.wait_for_transaction_receipt(tx)
    return receipt  # Use this to analyze success messages

# Step 1: Create 100 new accounts
user_addresses = []
for _ in range(1):  # Create 100 new accounts
    new_account = web3.eth.account.create()
    user_addresses.append(new_account.address)
    # print(f"Created new user: {new_account.address}")

# Step 2: Register users
for user in user_addresses:
    register_user(user)

print(f"{len(user_addresses)} users registered.")

# Step 3: Create a power-law degree distribution graph
mean_balance = 10  # Mean for the exponential distribution
edges = []

while len(edges) < 700:  # Ensure at least 200 edges
    from_user = random.choice(user_addresses)
    to_user = random.choice(user_addresses)
    if from_user != to_user and (from_user, to_user) not in edges:
        balance = np.random.exponential(mean_balance)
        weight1 = weight2 = int(balance / 2)  # Split the balance equally
        add_edge(from_user, to_user, weight1, weight2)
        edges.append((from_user, to_user))

print(f"{len(edges)} edges created.")

# Step 4: Stream 1000 transactions and plot the success ratio
successful_transactions = 0
total_transactions = 0
success_ratios = []  # Store the success ratios for plotting

# Real-time plotting setup
plt.ion()  # Interactive mode for real-time updates
fig, ax = plt.subplots()
ax.set_title("Transaction Success Ratio")
ax.set_xlabel("Transactions (x100)")
ax.set_ylabel("Success Ratio (%)")
x_data, y_data = [], []

for i in range(1000):
    from_user, to_user = random.sample(user_addresses, 2)
    try:
        # print("a\n")
        receipt = send_amount(from_user, to_user, 1)  # Send 1 unit
        logs = contract_instance.events.SimpleMessage().process_receipt(receipt)
        for log in logs:
            # print(log["args"]["message"])
            if log["args"]["message"] == "Transaction successful":
                successful_transactions += 1
    except Exception as e:
        print(f"Transaction failed: {e}")
    
    total_transactions += 1

    # Report and plot ratio after every 100 transactions
    if total_transactions % 100 == 0:
        ratio = successful_transactions / total_transactions
        success_ratios.append(ratio)
        print(f"After {total_transactions} transactions, success ratio: {ratio:.2%}")

        # Update the plot
        x_data.append(total_transactions // 100)
        y_data.append(ratio * 100)  # Convert to percentage
        ax.plot(x_data, y_data, marker='o', color='b')
        plt.draw()
        plt.pause(0.1)

print("Transaction simulation completed.")

# Finalize the plot
plt.ioff()
plt.show()
