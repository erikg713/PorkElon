// porkelon-frontend/src/components/TokenStats.jsx
import { useTokenStats } from '../hooks/usePorkElon';

export default function TokenStats() {
  const { totalSupply, burned, unlockTime } = useTokenStats();

  return (
    <div className="space-y-4">
      <div>📈 <strong>Total Supply:</strong> {totalSupply} PORK</div>
      <div>🔥 <strong>Burned Supply:</strong> {burned} PORK</div>
      <div>🔒 <strong>Unlock Time:</strong> {unlockTime}</div>

      <a
        href={`https://app.uniswap.org/#/swap?outputCurrency=${import.meta.env.VITE_CONTRACT_ADDRESS}&chain=goerli`}
        target="_blank"
        rel="noopener noreferrer"
        className="block bg-purple-600 px-6 py-2 rounded text-center mt-4"
      >
        🛒 Buy PORKELON on Uniswap
      </a>
    </div>
  );
}