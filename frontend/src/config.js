import { createConfig, http } from 'wagmi';
import { mainnet } from 'wagmi/chains'; // You might want to add other chains like arbitrum if PORK is on Arbitrum [1, 2]
import { injected } from 'wagmi/connectors';

export const config = createConfig({
  chains: [mainnet], // [3, 4] Consider adding other chains relevant to PorkElon, like Arbitrum [1, 2]
  connectors: [
    injected(), // [5, 3, 4],
  transports: {
    [mainnet.id]: http(), // [3, 4]
  },
});
