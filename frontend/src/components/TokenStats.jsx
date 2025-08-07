import { useTokenStats } from '../hooks/usePorkElon';

export default function TokenStats() {
  const { totalSupply, burned, unlockTime } = useTokenStats();

  return (
    <div className="space-y-4">
      <div>📈 <strong>Total Supply:</strong> {totalSupply} PORK</div>
      <div>🔥 <strong>Burned Supply:</strong> {burned} PORK</div>
      <div>🔒 <strong>Unlock Time:</strong> {unlockTime}</div>
    </div>
  );
}
