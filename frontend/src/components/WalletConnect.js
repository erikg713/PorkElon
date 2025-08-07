// porkelon-frontend/src/components/WalletConnect.jsx
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