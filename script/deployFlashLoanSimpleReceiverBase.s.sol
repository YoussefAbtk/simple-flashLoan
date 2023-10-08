//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import {Script} from "forge-std/Script.sol";
import {FlashLoanSimpleReceiver} from "../src/FlashLoan.sol";
import {IPoolAddressesProvider} from "../lib/aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol";

contract DeployFlashloan is Script {
    FlashLoanSimpleReceiver flashLoan;

    function run() public returns (FlashLoanSimpleReceiver) {
        vm.startBroadcast();
        flashLoan = new FlashLoanSimpleReceiver(IPoolAddressesProvider(0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e));
        vm.stopBroadcast();
        return flashLoan;
    }
}
