# Delivery vs Payment (DvP) Escrow Smart Contract

This project demonstrates a **secure asset trading mechanism** where payment and delivery happen simultaneously on the blockchain — known as **Delivery vs Payment (DvP)**.

✅ **Includes a ready-to-run test** using **Hardhat** and **Ethers.js v6**, even for non-Ethereum specialists!


## Requirements

- **Node.js v18.x** (recommended)  
  Check your version: `node -v`  
  [Download Node.js 18](https://nodejs.org/en)

- **npm** (comes with Node.js)

---

## Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/dvp-escrow.git
   cd dvp-escrow
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Compile the smart contracts**:
   ```bash
   npx hardhat compile
   ```

4. **Run tests**:
   ```bash
   npx hardhat test
   ```

## Project Structure

```plaintext
contracts/
│   ├── ERC20Mock.sol                      # Simulated Token (for testing)
│   ├── DeliveryVsPaymentEscrowSafeTimeout.sol  # Main DvP Smart Contract
test/
│   ├── dvpTest.js                         # Automated test file
hardhat.config.js                          # Hardhat configuration file
package.json                               # Project dependencies
```

## What This Project Does

1. **Seller deposits securities**: The seller deposits the assets (such as tokens or securities) into the escrow smart contract.
2. **Buyer deposits payment**: The buyer deposits the payment (e.g., stablecoins) into the escrow smart contract.
3. **Simultaneous exchange**: When both deposits are complete, the smart contract securely swaps the assets and the payment.
4. **Timeout handling**: If either party fails to complete their deposit within the specified time, the contract returns the funds to the respective parties.


## Technologies Used

- **Solidity** v0.8.20
- **Hardhat**
- **Ethers.js** v6
- **OpenZeppelin Contracts**

## License

This project is licensed under the **MIT License**.

## Contact

Your MAKE Europe  
GitHub: [https://github.com/make-europe](https://github.com/make-europe)
