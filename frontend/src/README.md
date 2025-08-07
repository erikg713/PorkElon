-------------------------------------
### 🐷 PorkElon Token Dashboard ###
-------------------------------------
---
Overview
---
The PorkElon Token Dashboard is a modern, React-based decentralized application (dApp) frontend designed to interact with and monitor a blockchain-based token ecosystem. It provides users with real-time token statistics, facilitates secure wallet connections, and enables basic transaction sending.
This dashboard leverages a robust stack including React for dynamic user interfaces, the Wagmi library for seamless blockchain integration, and Tailwind CSS for efficient and consistent styling.
Features
 * Wallet Connectivity: Connect and disconnect popular injected wallets (e.g., MetaMask) to the dashboard.
 * Real-time Token Statistics: Displays key tokenomics data directly from the smart contract, including:
   * Total Supply
   * Burned Supply
   * Token Unlock Time
 * Native Token Sending: Allows users to send the native currency of the connected blockchain (e.g., ETH on Ethereum Mainnet) to any address.
 * Responsive UI: Styled with Tailwind CSS for a clean, consistent, and responsive user experience.
Technologies Used
 * React: A JavaScript library for building user interfaces.
 * Wagmi: A collection of React Hooks for Ethereum and EVM-compatible blockchains, simplifying wallet connections, contract interactions, and transaction management.
 * Tailwind CSS: A utility-first CSS framework for rapidly building custom designs.
 * Viem: A low-level library for Ethereum applications, used by Wagmi for efficient blockchain interactions (e.g., converting ether values).
Project Structure
The project follows a standard React application structure, organized for modularity and maintainability:
```
porkelon-frontend/
├── public/
├── src/
│   ├── App.jsx
│   ├── config.js
│   ├── constants/
│   │   └── contracts.js
│   ├── components/
│   │   ├── WalletConnect.jsx
│   │   ├── TokenStats.jsx
│   │   └── SendPorkElon.jsx
│   └── hooks/
│       └── usePorkElon.js
├── package.json
├── tailwind.config.js
├── postcss.config.js
└── README.md
```
### File Breakdown:

*   **`src/App.jsx`**: The main entry point and root component of the React application. It sets up the global `WagmiConfig` context, making blockchain functionalities available throughout the component tree, and orchestrates the rendering of core dashboard components.
*   **`src/config.js`**: Configures the Wagmi client, defining the blockchain networks (`chains`), wallet connectors (`connectors`), and transport mechanisms (`transports`) for blockchain communication.
*   **`src/constants/contracts.js`**: Stores immutable data related to your smart contract, specifically the `PORKELON_CONTRACT_ADDRESS` and `PORKELON_CONTRACT_ABI`. **(Requires your actual contract details)**
*   **`src/components/`**: Contains reusable UI components:
    *   **`WalletConnect.jsx`**: Manages wallet connection status, displaying the connected address and providing connect/disconnect actions using Wagmi's `useAccount`, `useConnect`, and `useDisconnect` hooks.
    *   **`TokenStats.jsx`**: Displays the PorkElon token's total supply, burned supply, and unlock time by utilizing the `useTokenStats` custom hook.
    *   **`SendPorkElon.jsx`**: Provides a form to send native tokens (e.g., ETH) to a specified address, leveraging Wagmi's `useSendTransaction` and `useWaitForTransactionReceipt` hooks.
*   **`src/hooks/usePorkElon.js`**: A custom React Hook that encapsulates the logic for fetching specific token statistics (`totalSupply`, `burnedSupply`, `unlockTime`) directly from your PorkElon smart contract using Wagmi's `useContractRead` hook, with real-time data refreshing.

## Setup and Installation

Follow these steps to get the PorkElon Token Dashboard running on your local machine.

### Prerequisites

*   Node.js (v18 or higher recommended)
*   npm or yarn

### Steps

1.  **Clone the repository:**
    ```bash
    git clone
    cd porkelon-frontend
    ```

2.  **Install dependencies:**
    ```bash
    npm install
    # or
    yarn install
    ```
    This will install React, Wagmi, Viem, Tailwind CSS, PostCSS, and Autoprefixer.

3.  **Initialize Tailwind CSS (if not already done):**
    ```bash
    npx tailwindcss init -p
    ```
    This command generates `tailwind.config.js` and `postcss.config.js`.

4.  **Configure Tailwind CSS:**
    Ensure your `tailwind.config.js` file is configured to scan your source files for Tailwind classes. A typical `content` array looks like this:
    ```javascript
    // tailwind.config.js
    module.exports = {
      content: [
        "./index.html",
        "./src/**/*.{js,ts,jsx,tsx}",
      ],
      theme: {
        extend: {},
      },
      plugins:,
    }
    ```

5.  **Add Tailwind Directives to your CSS:**
    Create a main CSS file (e.g., `src/index.css` or `src/styles/tailwind.css`) and include the Tailwind directives. Then, ensure this CSS file is imported into your `src/main.jsx` (or `src/index.js`) file.
    ```css
    /* src/index.css or src/styles/tailwind.css */
    @tailwind base;
    @tailwind components;
    @tailwind utilities;
    ```
    And in your main entry file (e.g., `src/main.jsx`):
    ```jsx
    // src/main.jsx
    import React from 'react';
    import ReactDOM from 'react-dom/client';
    import App from './App.jsx';
    import './index.css'; // Or './styles/tailwind.css'

    ReactDOM.createRoot(document.getElementById('root')).render(
      <React.StrictMode>
        <App />
      </React.StrictMode>,
    );
    ```

6.  **Update Contract Constants:**
    Open `src/constants/contracts.js` and replace the placeholder values with your actual PorkElon token contract address and its ABI.
    ```javascript
    // src/constants/contracts.js
    export const PORKELON_CONTRACT_ADDRESS = '0xYourActualPorkElonContractAddressHere';

    export const PORKELON_CONTRACT_ABI =,
        "name": "totalSupply",
        "outputs":,
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs":,
        "name": "burnedSupply",
        "outputs":,
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs":,
        "name": "unlockTime",
        "outputs":,
        "stateMutability": "view",
        "type": "function"
      },
      //... other ABI entries for your contract
    ];
    ```

7.  **Start the development server:**
    ```bash
    npm run dev
    # or
    yarn dev
    ```
    This will typically start the application on `http://localhost:5173` (or another available port).

## Usage

Once the application is running:

1.  **Connect Wallet:** Click the "Connect Wallet" button to link your browser-injected wallet (e.g., MetaMask).
2.  **View Token Stats:** The dashboard will automatically display the total supply, burned supply, and unlock time for the PorkElon token by reading directly from the smart contract.
3.  **Send Native Token:** Use the "Send Native Token" section to input a recipient address and an amount, then send a transaction. Follow the prompts in your wallet to confirm.

## Important Notes

*   **"PorkElon" Ambiguity:** The term "PorkElon" in the dashboard title is ambiguous. This dashboard is designed to interact with a single "PorkElon" token contract as defined by `PORKELON_CONTRACT_ADDRESS`. If you intend to track both "PigsCanFly (PORK)" and "Dogelon Mars (ELON)", further UI and contract integration would be required to differentiate between them.
*   **Contract Address and ABI:** Ensure the `PORKELON_CONTRACT_ADDRESS` and `PORKELON_CONTRACT_ABI` in `src/constants/contracts.js` are accurate for your specific token. Incorrect values will prevent the dashboard from fetching data or sending transactions.
*   **Chain Configuration:** The `config.js` file currently uses `mainnet`. If your PorkElon token operates on a different EVM chain (e.g., Arbitrum), remember to add that chain to the `chains` array in `src/config.js` for full compatibility.

## Future Enhancements

Based on the research and common dApp functionalities, here are some potential areas for future development:

*   **ERC20 Token Transfer:** Implement functionality to send the specific PorkElon token (ERC20) using Wagmi's `useWriteContract` to call the token's `transfer` function.
*   **Multi-Chain Support:** Expand the `config.js` to support multiple EVM chains, allowing users to switch between networks and interact with the token on different deployments.
*   **NFT Holdings Display:** If the PorkElon ecosystem includes NFTs, add a component to display the user's NFT collection.
*   **Transaction History:** Integrate a feature to show a list of past transactions for the connected wallet.
*   **Error Handling & User Feedback:** Enhance error messages and loading states for a more robust user experience.

