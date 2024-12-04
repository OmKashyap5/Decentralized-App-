# Decentralized-App-
Creating a DApp by setting a private ethereum node and using that node to execute a smart contract for other users in the DApp.
1. Initial step includes setting up private ethereum node on your system. The same can be done by:
   a. Install geth on your pc.
   b. Once geth set up is complete run command "geth --dev --http --http.api eth,web3,net". This will start the ethereum functionalities and server.
2. Compile the solidity code(ensure that solc compiler is installed by 'npm install -g solc'). This will create 2 files with .abi and .bin extension.
3. Now open .json file and insert the data of abi file and bin file in the specific places given.
4. Now compile the python file which will register user, create accounts between randon users and fire transactions.
5. We will get the graph of number of successful transactions.
