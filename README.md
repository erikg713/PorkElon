### 📄 README.md ###

# 🐷 PorkElon Token (PORKELON)

A meme token with anti-bot protections, transaction cooldown, and fee distribution.

## 🔐 Features

- ✅ ERC20 using OpenZeppelin
- ✅ 2% fee to marketing wallet
- ✅ 30-second cooldown per address
- ✅ Max tx: 1% | Max wallet: 2%
- ✅ Fee & cooldown exclusions

## 🛠 Setup

```bash
git clone <your_repo_url>
cd porkelon-token
npm install

Create a .env file:

PRIVATE_KEY=...
RPC_URL=...
ETHERSCAN_API_KEY=...

🚀 Deploy

npx hardhat run scripts/deploy.js --network goerli

🧪 Test

npx hardhat test

🔍 Verify on Etherscan

npx hardhat verify --network goerli DEPLOYED_ADDRESS "0xMarketingWallet"


---

License

MIT

---

## 🧭 Step 2: Initialize & Push to GitHub

```bash
cd porkelon-token
git init
git add .
git commit -m "Initial commit: PorkElon token project"
gh repo create porkelon-token --public --source=. --remote=origin
git push -u origin main

(You need GitHub CLI gh installed for this, or create the repo manually and push via git remote add origin.)

