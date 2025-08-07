import React from 'react';
import { WagmiConfig } from 'wagmi';
import { config } from './config';

import WalletConnect from './components/WalletConnect';
import TokenStats from './components/TokenStats';

export default function App() {
  return (
    <WagmiConfig config={config}>
      <div className="min-h-screen bg-gray-900 text-white p-4">
        <div className="max-w-2xl mx-auto">
          <h1 className="text-4xl font-bold mb-6">🐷 PorkElon Token Dashboard</h1>
          <WalletConnect />
          <TokenStats />
        </div>
      </div>
    </WagmiConfig>
  );
}
