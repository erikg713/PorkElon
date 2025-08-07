// porkelon-frontend/src/components/TokenChart.jsx
import React from 'react';

export default function TokenChart() {
  return (
    <div className="mt-10">
      <h2 className="text-xl font-semibold mb-2">📊 Live Chart</h2>
      <div className="w-full h-[500px]">
        <iframe
          title="Token Chart"
          src={`https://dexscreener.com/goerli/${import.meta.env.VITE_CONTRACT_ADDRESS}`}
          width="100%"
          height="100%"
          style={{ border: 0 }}
          allowFullScreen
        ></iframe>
      </div>
    </div>
  );
}