//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import {Test, console} from "forge-std/Test.sol";
import {DeployFlashloan} from "../script/deployFlashLoanSimpleReceiverBase.s.sol";
import {FlashLoanSimpleReceiver} from "../src/FlashLoan.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IPoolAddressesProvider} from "../lib/aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol";
import {IWeth} from "../test/interfaces/IWEH.sol";

contract FlashLoanTest is Test {
     event assetBorrowed(address indexed asset, uint256 indexed amount);
    event fees(uint256 indexed fee);
    uint256 mainnetFork;
    FlashLoanSimpleReceiver flashLoan;
    IWeth weth; 
   address wethAddress =0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function setUp() public {
        flashLoan = new FlashLoanSimpleReceiver(IPoolAddressesProvider(0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e));
        weth =  IWeth(wethAddress);
        vm.deal(address(flashLoan), 2000 ether);
        
    }

    function testFlashLoan() external {
        vm.prank(address(flashLoan));
        weth.deposit{value: 1000 ether}();
        console.log(address(flashLoan).balance, weth.balanceOf(address(flashLoan)));
         vm.expectRevert(FlashLoanSimpleReceiver.NotEnoughtBalance.selector);
        flashLoan.flashLoan(wethAddress, 10000e18);
    }

    

    
}
