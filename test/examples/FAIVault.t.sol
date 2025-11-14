//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import "../../examples/FAIVault.sol";
import "forge-std/Test.sol";
import "../../examples/FAI.sol";

contract FAIVaultTest is Test {
  FAI public fai;
  FAIVault public vault; 
  address public owner;
  address public alice;
  address public bob;
  address public charlie;

  /*///////////////////////
          SETUP
  ///////////////////////*/
  function setUp() public {
    owner = address(this);
    alice = makeAddr("alice");
    bob = makeAddr("bob");
    charlie = makeAddr("charlie");

    fai = new FAI();
    vault = new FAIVault(address(fai));

    fai.setMinter(address(vault));

    vm.deal(alice, 10 ether);
    vm.deal(bob, 10 ether);
  }

  /*////////////////////////////////////
                Deposit And Mint
  ////////////////////////////////////*/
    /*
1. deposit and mint happy path
2. deposit emits event
3. updates global state
4. insufficient eth


    */
  function test_DepositAndMint() public {
    vm.prank(alice);
    vault.depositCollateralAndMint{value: 1 ether}(5000e18);
    assertEq(fai.balanceOf(alice), 5000e18);
    (uint256 collateral, uint256 debt) = vault.getPosition(alice);
    assertEq(collateral, 1 ether);
    assertEq(debt, 5000e18);
  }

  /*
    1. widhtdraw and burn happy path
  2. emits event
  3. updates global state correctly
  4. too high eth
  5. partial widhtdraw
  6. full withdrawal

    */
  function test_WithdrawAndBurn() public {
    vm.prank(alice);
    vault.depositCollateralAndMint{value: 1 ether}(5000e18);
    assertEq(fai.balanceOf(alice), 5000e18);
    (uint256 collateral, uint256 debt) = vault.getPosition(alice);
    assertEq(collateral, 1 ether);
    assertEq(debt, 5000e18);

    vm.prank(alice);
    vault.burnAndWithdrawCollateral(5000e18, 1 ether);

  }
}
