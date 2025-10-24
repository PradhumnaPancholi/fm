// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.30;

import "forge-std/Test.sol";
import "../../examples/FMETH.sol";

contract FMETHTEST is Test {
  FMETH public fmeth;
  address public owner;
  address public alice;
  address public bob;
  address public charlie;
  
  /*----------------------
          SETUP
  ----------------------*/
  function setUp() public {
    owner = address(this);
    alice = makeAddr("alice");
    bob = makeAddr("bob");
    charlie = makeAddr("charlie");

    fmeth = new FMETH();
  }

  /*---------------------------------------------
                    METADATA
  ----------------------------------------------*/
 function test_FMETH() public {
   assertEq(fmeth.name(), "Freakishly Mesmerising Ether");
   assertEq(fmeth.symbol(), "fmETH");
   assertEq(fmeth.decimals(), 18);
 }

 function test_FMETHFirstDeposit() public {
  vm.prank(alice);
  vm.deal(alice, 10 ether);
  
  fmeth.deposit{value: 10 ether}();

  assertEq(fmeth.balanceOf(alice), 10e18);
  assertEq(fmeth.totalPooledETH(), 10 ether);
  assertEq(fmeth.totalShares(), 10e18);

 }

 function test_FMETHEMITS() {}

}
