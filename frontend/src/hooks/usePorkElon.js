import { useContractRead } from 'wagmi';
import { PORKELON_CONTRACT_ADDRESS, PORKELON_CONTRACT_ABI } from '../constants/contracts';

export const useTokenStats = () => {
  // Fetch Total Supply
  const { data: totalSupplyData, isLoading: isTotalSupplyLoading, isError: isTotalSupplyError } = useContractRead({
    address: PORKELON_CONTRACT_ADDRESS,
    abi: PORKELON_CONTRACT_ABI,
    functionName: 'totalSupply',
    watch: true, // Automatically refetch on new blocks
  });

  // Fetch Burned Supply (assuming a function named 'burnedSupply' in your contract)
  const { data: burnedData, isLoading: isBurnedLoading, isError: isBurnedError } = useContractRead({
    address: PORKELON_CONTRACT_ADDRESS,
    abi: PORKELON_CONTRACT_ABI,
    functionName: 'burnedSupply', // Make sure this matches your contract's function name
    watch: true,
  });

  // Fetch Unlock Time (assuming a function named 'unlockTime' in your contract that returns a Unix timestamp)
  const { data: unlockTimeData, isLoading: isUnlockTimeLoading, isError: isUnlockTimeError } = useContractRead({
    address: PORKELON_CONTRACT_ADDRESS,
    abi: PORKELON_CONTRACT_ABI,
    functionName: 'unlockTime', // Make sure this matches your contract's function name
    watch: true,
  });

  // Format the data for display
  const totalSupply = isTotalSupplyLoading
   ? 'Loading...'
    : isTotalSupplyError
     ? 'Error'
      : totalSupplyData? totalSupplyData.toString() : 'N/A'; // Convert BigInt to string

  const burned = isBurnedLoading
   ? 'Loading...'
    : isBurnedError
     ? 'Error'
      : burnedData? burnedData.toString() : 'N/A'; // Convert BigInt to string

  // Format unlock time from a Unix timestamp to a human-readable date
  const formattedUnlockTime = isUnlockTimeLoading
   ? 'Loading...'
    : isUnlockTimeError
     ? 'Error'
      : unlockTimeData
       ? new Date(Number(unlockTimeData) * 1000).toLocaleString() // Convert BigInt timestamp to number, then to date
        : 'N/A';

  return {
    totalSupply,
    burned,
    unlockTime: formattedUnlockTime,
  };
};
