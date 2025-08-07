import React from 'react';
import { useSendTransaction, useWaitForTransactionReceipt } from 'wagmi'; // [2, 3, 4]
import { parseEther } from 'viem'; // [7]

export default function SendPorkElon() {
  const { data: hash, isPending, sendTransaction } = useSendTransaction(); // [2, 3, 4]

  const { isLoading: isConfirming, isSuccess: isConfirmed } = useWaitForTransactionReceipt({
    hash,
  }); // [5]

  async function submit(e) {
    e.preventDefault();
    const formData = new FormData(e.target);
    const to = formData.get('address');
    const value = formData.get('value');

    if (to && value) {
      try {
        sendTransaction({
          to: to,
          value: parseEther(value), // [2, 7] Converts string ether to BigInt wei
        });
      } catch (error) {
        console.error("Failed to send transaction:", error);
        // You might want to display a user-friendly error message here
      }
    }
  }

  return (
    <div className="mt-8 p-6 bg-gray-800 rounded-lg shadow-lg">
      <h2 className="text-2xl font-bold mb-4">💸 Send Native Token</h2>
      <form onSubmit={submit} className="space-y-4">
        <div>
          <label htmlFor="address" className="block text-sm font-medium text-gray-300 mb-1">Recipient Address</label>
          <input
            id="address"
            name="address"
            type="text"
            placeholder="0x..."
            required
            className="w-full p-3 rounded bg-gray-700 border border-gray-600 text-white focus:outline-none focus:ring-2 focus:ring-green-500"
          />
        </div>
        <div>
          <label htmlFor="value" className="block text-sm font-medium text-gray-300 mb-1">Amount (ETH/Native Token)</label>
          <input
            id="value"
            name="value"
            type="number"
            step="any"
            placeholder="0.05"
            required
            className="w-full p-3 rounded bg-gray-700 border border-gray-600 text-white focus:outline-none focus:ring-2 focus:ring-green-500"
          />
        </div>
        <button
          type="submit"
          disabled={isPending |

| isConfirming}
          className="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-4 rounded transition duration-200 ease-in-out disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {isPending? 'Confirming in Wallet...' : isConfirming? 'Sending...' : 'Send Transaction'}
        </button>

        {hash && (
          <div className="text-sm text-gray-400 break-all mt-2">
            Transaction Hash: <a href={`https://etherscan.io/tx/${hash}`} target="_blank" rel="noopener noreferrer" className="text-blue-400 hover:underline">{hash}</a>
          </div>
        )}
        {isConfirming && <div className="text-yellow-400 mt-2">Waiting for confirmation...</div>}
        {isConfirmed && <div className="text-green-400 mt-2">Transaction confirmed!</div>}
      </form>
    </div>
  );
}
