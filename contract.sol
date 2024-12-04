
// pragma solidity ^0.8.0;

// contract Graph {
//     // Define the adjacency list
//     event SimpleMessage(string message);

//     mapping(address => Edge[]) public adjacencyList;

//     // Maintain a list of all user addresses
//     address[] public users;

//     // Track if a user is already registered
//     mapping(address => bool) public isRegistered;

//     // Define a struct for edges
//     struct Edge {
//         address to;
//         uint weight1;
//         uint weight2;
//     }
    
//     mapping(address => address) public prev;
//     mapping(address => bool) public visited;

//     // Function to add a new user
//     function addUser(address user) public {
//         require(!isRegistered[user], "User already registered.");
//         users.push(user); // Add user to the list
//         isRegistered[user] = true; // Mark user as registered
//     }

//     // Function to add an edge
//     function addEdge(
//         address fromUser,
//         address toUser,
//         uint weight1,
//         uint weight2
//     ) public {
//         require(isRegistered[fromUser], "From user not registered.");
//         require(isRegistered[toUser], "To user not registered.");
//         // Add the edge to the adjacency list
//         adjacencyList[fromUser].push(Edge(toUser, weight1, weight2));
//     }

//     // Function to terminate an account (remove an edge)
//     function terminateAccount(address fromUser, address toUser) public {
//         require(isRegistered[fromUser], "From user not registered.");
//         require(isRegistered[toUser], "To user not registered.");
//         // Remove the edge from 'fromUser' to 'toUser'
//         Edge[] storage edges = adjacencyList[fromUser];
//         for (uint i = 0; i < edges.length; i++) {
//             if (edges[i].to == toUser) {
//                 // Remove the edge by replacing it with the last element
//                 edges[i] = edges[edges.length - 1];
//                 edges.pop();
//                 break;
//             }
//         }
//     }

//     // Function to get all users
//     function getUsers() public view returns (address[] memory) {
//         return users;
//     }

//     // Function to get edges for a specific user
//     function getEdges(address user) public view returns (Edge[] memory) {
//         return adjacencyList[user];
//     }

//     // Function to find the shortest path between two users
//     function shortestPath(address start, address end) public returns (address[] memory) {
//         require(isRegistered[start], "Start user not registered.");
//         require(isRegistered[end], "End user not registered.");

//         // Reset visited and prev mappings
//         for (uint i = 0; i < users.length; i++) {
//             visited[users[i]] = false;
//             prev[users[i]] = address(0);
//         }

//         // BFS variables
//         address[] memory queue = new address[](users.length); // BFS queue
//         uint front = 0;
//         uint back = 0;

//         // Enqueue the start node
//         queue[back++] = start;
//         visited[start] = true;

//         // Perform BFS
//         while (front < back) {
//             address current = queue[front++];

//             if (current == end) {
//                 // Path found, reconstruct it
//                 uint pathLength = 0;
//                 address temp = end;

//                 // Calculate path length
//                 while (temp != address(0)) {
//                     pathLength++;
//                     temp = prev[temp];
//                 }

//                 // Store path
//                 address[] memory path = new address[](pathLength);
//                 temp = end;
//                 for (uint i = pathLength; i > 0; i--) {
//                     path[i - 1] = temp;
//                     temp = prev[temp];
//                 }
//                 return path;
//             }

//             // Enqueue neighbors
//             Edge[] memory edges = adjacencyList[current];
//             for (uint i = 0; i < edges.length; i++) {
//                 address neighbor = edges[i].to;
//                 if (!visited[neighbor]) {
//                     visited[neighbor] = true;
//                     prev[neighbor] = current;
//                     queue[back++] = neighbor;
//                 }
//             }
//         }

//         // Return an empty array if no path exists
//         return new address[](0) ;
//     }

//     function transaction(address fromUser, address toUser, uint amnt) public {
//         address[] memory path = shortestPath(fromUser, toUser);
//         if (path.length == 0) {
//             emit SimpleMessage("The two users are not connected. Transaction failed.");
//         } else {
//             uint flag = 0;
//             for (uint i = 0; i < path.length - 1; i++) {
//                 for (uint j = 0; j < adjacencyList[path[i]].length; j++) {
//                     if (adjacencyList[path[i]][j].to == path[i + 1]) {
//                         if (adjacencyList[path[i]][j].weight1 < amnt) {
//                             emit SimpleMessage("There are not enough funds for transaction. Transaction failed.");
//                             flag = 1;
//                         } else {
//                             adjacencyList[path[i]][j].weight1 = adjacencyList[path[i]][j].weight1 - amnt;
//                             adjacencyList[path[i]][j].weight2 = adjacencyList[path[i]][j].weight2 + amnt;
//                         }
//                         break;
//                     }
//                 }
//             }
//             if (flag == 0) {
//                 emit SimpleMessage("Transaction successful");
//             }
//         }
//     }
// }

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Graph {
    // Define the adjacency list
    event SimpleMessage(string message);

    mapping(address => Edge[]) public adjacencyList;

    // Maintain a list of all user addresses
    address[] public users;

    // Track if a user is already registered
    mapping(address => bool) public isRegistered;

    // Define a struct for edges
    struct Edge {
        address to;
        uint weight1;
        uint weight2;
    }
    
    mapping(address => address) public prev;
    mapping(address => bool) public visited;

    // Function to add a new user
    function addUser(address user) public {
        require(!isRegistered[user], "User already registered.");
        users.push(user); // Add user to the list
        isRegistered[user] = true; // Mark user as registered
    }

    // Function to add an edge
    function addEdge(
        address fromUser,
        address toUser,
        uint weight1,
        uint weight2
    ) public {
        require(isRegistered[fromUser], "From user not registered.");
        require(isRegistered[toUser], "To user not registered.");
        // Add the edge to the adjacency list
        adjacencyList[fromUser].push(Edge(toUser, weight1, weight2));
        adjacencyList[toUser].push(Edge(fromUser, weight2, weight1));
    }

    // Function to terminate an account (remove an edge)
    function terminateAccount(address fromUser, address toUser) public {
        require(isRegistered[fromUser], "From user not registered.");
        require(isRegistered[toUser], "To user not registered.");
        // Remove the edge from 'fromUser' to 'toUser'
        Edge[] storage edges = adjacencyList[fromUser];
        for (uint i = 0; i < edges.length; i++) {
            if (edges[i].to == toUser) {
                // Remove the edge by replacing it with the last element
                edges[i] = edges[edges.length - 1];
                edges.pop();
                break;
            }
        }
    }

    // Function to get all users
    function getUsers() public view returns (address[] memory) {
        return users;
    }

    // Function to get edges for a specific user
    function getEdges(address user) public view returns (Edge[] memory) {
        return adjacencyList[user];
    }

    // Function to find the shortest path between two users
    function shortestPath(address start, address end) public returns (address[] memory) {
        require(isRegistered[start], "Start user not registered.");
        require(isRegistered[end], "End user not registered.");

        // Reset visited and prev mappings
        for (uint i = 0; i < users.length; i++) {
            visited[users[i]] = false;
            prev[users[i]] = address(0);
        }

        // BFS variables
        address[] memory queue = new address[](users.length); // BFS queue
        uint front = 0;
        uint back = 0;

        // Enqueue the start node
        queue[back++] = start;
        visited[start] = true;

        // Perform BFS
        while (front < back) {
            address current = queue[front++];

            if (current == end) {
                // Path found, reconstruct it
                uint pathLength = 0;
                address temp = end;

                // Calculate path length
                while (temp != address(0)) {
                    pathLength++;
                    temp = prev[temp];
                }

                // Store path
                address[] memory path = new address[](pathLength);
                temp = end;
                for (uint i = pathLength; i > 0; i--) {
                    path[i - 1] = temp;
                    temp = prev[temp];
                }
                return path;
            }

            // Enqueue neighbors
            Edge[] memory edges = adjacencyList[current];
            for (uint i = 0; i < edges.length; i++) {
                address neighbor = edges[i].to;
                if (!visited[neighbor]) {
                    visited[neighbor] = true;
                    prev[neighbor] = current;
                    queue[back++] = neighbor;
                }
            }
        }

        // Return an empty array if no path exists
        return new address[](0) ;
    }

    function transaction(address fromUser, address toUser, uint amnt) public {
        address[] memory path = shortestPath(fromUser, toUser);
        if (path.length == 0) {
            emit SimpleMessage("The two users are not connected. Transaction failed.");
        } else {
            uint flag = 0;
            for (uint i = 0; i < path.length - 1; i++) {
                for (uint j = 0; j < adjacencyList[path[i]].length; j++) {
                    if (adjacencyList[path[i]][j].to == path[i + 1]) {
                        if (adjacencyList[path[i]][j].weight1 < amnt) {
                            emit SimpleMessage("There are not enough funds for transaction. Transaction failed.");
                            flag = 1;
                        } else {
                            adjacencyList[path[i]][j].weight1 = adjacencyList[path[i]][j].weight1 - amnt;
                            adjacencyList[path[i]][j].weight2 = adjacencyList[path[i]][j].weight2 + amnt;
                        }
                        break;
                    }
                }
            }
            if (flag == 0) {
                emit SimpleMessage("Transaction successful");
            }
        }
    }
}