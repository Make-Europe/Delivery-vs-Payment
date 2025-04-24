// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeliveryVsPaymentEscrowSafeTimeout {
    using SafeERC20 for IERC20;

    address public seller;
    address public buyer;

    IERC20 public securitiesToken; // WBTC
    IERC20 public stablecoinToken; // USDC

    uint256 public securitiesAmount;
    uint256 public stablecoinAmount;

    bool public sellerDeposited;
    bool public buyerDeposited;

    uint256 public deadline;

// 1 TIME CONSTRUCTOR OF ESCROW DEAL 

    constructor(
        address _seller,
        address _buyer,
        address _securitiesToken,
        address _stablecoinToken,
        uint256 _securitiesAmount,
        uint256 _stablecoinAmount,
        uint256 _timeoutSeconds // e.g. 86400 per 24hrs 
    ) {
        seller = _seller;
        buyer = _buyer;
        securitiesToken = IERC20(_securitiesToken);
        stablecoinToken = IERC20(_stablecoinToken);
        securitiesAmount = _securitiesAmount;
        stablecoinAmount = _stablecoinAmount;
        deadline = block.timestamp + _timeoutSeconds;
    }

    function depositSecurities() external {
        require(msg.sender == seller, "Only seller can deposit securities");
        require(!sellerDeposited, "Securities already deposited");

        securitiesToken.safeTransferFrom(seller, address(this), securitiesAmount);
        sellerDeposited = true;
    }

    function depositStablecoins() external {
        require(msg.sender == buyer, "Only buyer can deposit stablecoins");
        require(!buyerDeposited, "Stablecoins already deposited");

        stablecoinToken.safeTransferFrom(buyer, address(this), stablecoinAmount);
        buyerDeposited = true;
    }

// SETTLEMENT

    function settleTrade() external {
        require(block.timestamp <= deadline, "Trade expired");
        require(sellerDeposited && buyerDeposited, "Both deposits required");

        stablecoinToken.safeTransfer(seller, stablecoinAmount);
        securitiesToken.safeTransfer(buyer, securitiesAmount);

        // Reset
        sellerDeposited = false;
        buyerDeposited = false;
    }

// TIMEOUT CANCELATION

    function cancelTrade() external {
        require(block.timestamp > deadline, "Deadline not yet passed");

        if (sellerDeposited) {
            securitiesToken.safeTransfer(seller, securitiesAmount);
            sellerDeposited = false;
        }

        if (buyerDeposited) {
            stablecoinToken.safeTransfer(buyer, stablecoinAmount);
            buyerDeposited = false;
        }
    }
}