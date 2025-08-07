import { useState, useEffect } from 'react';
import { usePublicClient } from 'wagmi';

export const useTokenStats = () => {
  const [stats, setStats] = useState({
    totalSupply: 'Loading...',
    burned: 'Loading...',
    unlockTime: 'Loading...',
  });

  const publicClient = usePublicClient();

  useEffect(() => {
    // This is where you would call the smart contract to get the token data.
    // This is just a placeholder example.

    const fetchTokenData = async () => {
      try {
        // You would replace this with actual contract calls using 'publicClient'
        const totalSupply = '1,000,000,000,000';
        const burned = '500,000,000,000';
        const unlockTimestamp = 1735689600; // Example Unix timestamp for unlock

        const unlockDate = new Date(unlockTimestamp * 1000).toLocaleString();

        setStats({
          totalSupply,
          burned,
          unlockTime: unlockDate,
        });
      } catch (error) {
        console.error('Failed to fetch token stats:', error);
        setStats({
          totalSupply: 'Error',
          burned: 'Error',
          unlockTime: 'Error',
        });
      }
    };

    fetchTokenData();
  }, [publicClient]);

  return stats;
};

// porkelon-frontend/src/hooks/usePorkElon.js
import { useEffect, useState } from 'react';
import { ethers } from 'ethers';
import abi from '../abi/PorkElon.json';

const CONTRACT_ADDRESS = import.meta.env.VITE_CONTRACT_ADDRESS;
const RPC_URL = import.meta.env.VITE_RPC_URL;

export function useTokenStats() {
  const [totalSupply, setTotalSupply] = useState("Loading...");
  const [burned, setBurned] = useState("Loading...");
  const [unlockTime, setUnlockTime] = useState("Loading...");

  useEffect(() => {
    async function fetchStats() {
      try {
        const provider = new ethers.providers.JsonRpcProvider(RPC_URL);
        const contract = new ethers.Contract(CONTRACT_ADDRESS, abi, provider);

        const total = await contract.totalSupply();
        const burnedAmount = await contract.balanceOf("0x0000000000000000000000000000000000000000");
        const unlock = await contract.vestingUnlockTime();

        setTotalSupply(ethers.utils.formatUnits(total, 18));
        setBurned(ethers.utils.formatUnits(burnedAmount, 18));
        setUnlockTime(new Date(unlock.toNumber() * 1000).toLocaleString());
      } catch (error) {
        console.error("Failed to fetch token stats:", error);
      }
    }

    fetchStats();
  }, []);

  return { totalSupply, burned, unlockTime };
}
