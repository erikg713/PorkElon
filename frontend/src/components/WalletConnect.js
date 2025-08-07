import { useAccount, useConnect, useDisconnect } from 'wagmi'; // [2, 6, 7]
import { InjectedConnector } from 'wagmi/connectors/injected'; // [2, 8, 5]

export default function WalletConnect() {
  const { address, isConnected } = useAccount(); // [2, 6]
  const { connect } = useConnect({ connector: new InjectedConnector() }); // [2, 5]
  const { disconnect } = useDisconnect(); // [2, 7]

  if (isConnected) return (
    <div className="mb-6">
      <p className="mb-2">🔗 Connected: {address}</p>
      <button onClick={disconnect} className="bg-red-600 px-4 py-2 rounded">Disconnect</button>
    </div>
  );

  return <button onClick={() => connect()} className="bg-green-600 px-4 py-2 rounded">Connect Wallet</button>;
}


import { useAccount, useConnect, useDisconnect } from 'wagmi';
import { InjectedConnector } from 'wagmi/connectors/injected';

export default function WalletConnect() {
  const { address, isConnected } = useAccount();
  const { connect } = useConnect({ connector: new InjectedConnector() });
  const { disconnect } = useDisconnect();

  if (isConnected)
    return (
      <div className="mb-6">
        <p className="mb-2">🔗 Connected: {address}</p>
        <button onClick={disconnect} className="bg-red-600 px-4 py-2 rounded">Disconnect</button>
      </div>
    );

  return <button onClick={() => connect()} className="bg-green-600 px-4 py-2 rounded">Connect Wallet</button>;
}