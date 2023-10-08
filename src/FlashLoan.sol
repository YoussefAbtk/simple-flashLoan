//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import {IPoolAddressesProvider} from "../lib/aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol";
import {IPool} from "../lib/aave-v3-core/contracts/interfaces/IPool.sol";
import {FlashLoanSimpleReceiverBase} from "../lib/aave-v3-core/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashLoanSimpleReceiver is FlashLoanSimpleReceiverBase {
    error NotEnoughtBalance();

    event assetBorrowed(address indexed asset, uint256 indexed amount);
    event fees(uint256 indexed fee);

    constructor(IPoolAddressesProvider provider) FlashLoanSimpleReceiverBase(provider) {}

    function flashLoan(address asset, uint256 amount) external {
        uint256 bal = IERC20(asset).balanceOf(address(this));
        if (bal <= amount) {
            revert NotEnoughtBalance();
        }
        POOL.flashLoanSimple(address(this), asset, amount, "", 0);
    }

    function executeOperation(address asset, uint256 amount, uint256 premium, address initiator, bytes calldata params)
        external
        override
        returns (bool)
    {
        emit assetBorrowed(asset, amount);
        emit fees(premium);

        uint256 amountToPay = amount + premium;

        IERC20(asset).approve(address(POOL), amountToPay);
        return true;
    }
}
