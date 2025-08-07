export const PORKELON_CONTRACT_ADDRESS = '0x';

// Replace with your actual PorkElon Token Contract ABI
// This ABI should include functions for:
// - totalSupply()
// - burnedSupply() (or similar function name for burned tokens)
// - unlockTime() (or similar function name for token unlock timestamp)
export const PORKELON_CONTRACT_ABI =,
    "name": "totalSupply",
    "outputs":,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs":,
    "name": "burnedSupply", // Assuming your contract has a function to get burned supply
    "outputs":,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs":,
    "name": "unlockTime", // Assuming your contract has a function for unlock time (Unix timestamp)
    "outputs":,
    "stateMutability": "view",
    "type": "function"
  },
  //... other ABI entries for your contract
];
