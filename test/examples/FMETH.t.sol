// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

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

 /*///////////////////////////////////////
                Deposit
 ///////////////////////////////////////*/

 function test_FMETHFirstDeposit() public {
  vm.prank(alice);
  vm.deal(alice, 10 ether);
  
  fmeth.deposit{value: 10 ether}();

  assertEq(fmeth.balanceOf(alice), 10e18);
  assertEq(fmeth.totalPooledETH(), 10 ether);
  assertEq(fmeth.totalSupply(), 10e18);

 }

 function test_FMETHMintRevertsWhen_AmountIsLessThanMinDeposit() public {
  vm.deal(alice, 1 ether);

  vm.expectRevert("fmETH: Need minimum deposit of 0.1 ether");
  vm.prank(alice);
  fmeth.deposit{value: 0.01 ether}();
 }

 function test_FMETHDepositEmitsEvent() public {
  vm.deal(alice, 1 ether);
  vm.prank(alice);

  vm.expectEmit();
  emit Deposited(alice, 1 ether, 1e18);
  fmeth.deposit{value: 1 ether}();

 }
 // add func for  second deposit//

 /*/////////////////////////////////////////////
                    Withdraw
 /////////////////////////////////////////////*/
//function test_StorageSlot() public {
//  vm.deal(alice, 1 ether);
//  vm.prank(alice);
//  fmeth.deposit{value: 0.1 ether}();
//
//  bytes32 slot0 = vm.load(address(fmeth), bytes32(uint256(0)));
//  console.logBytes32(slot0);
//
//  bytes32 balanceSlot = keccak256(abi.encode(alice, uint256(0)));
//  uint256 balanceValue = uint256(vm.load(address(fmeth), balanceSlot));
//
//  console.log('balance storage', balanceValue);
//  console.log('balanceof result', fmeth.balanceOf(alice));
//}

//function test_StorageLayout() public {
//  for (uint256 i = 0; i < 10; i++) {
//    bytes32 value = vm.load(address(fmeth), bytes32(i));
//    console.log('slot', i, ":", vm.toString(value));
//  }
//
//  bytes32 balanceSlot = keccak256(abi.encode(alice, uint256(4)));
//  uint256 balanceValue = uint256(vm.load(address(fmeth), balanceSlot));
//  console.log('balance storage', balanceValue);
//}
//
//function test_StorageAfterMint() public {
//  vm.deal(alice, 1 ether);
//  vm.prank(alice);
//  fmeth.deposit{value: 0.1 ether}();
//
//  bytes32 totalSupplySlot = bytes32(uint256(3));
//  uint256 storedTotalSupplyValue =  uint256(vm.load(address(fmeth), totalSupplySlot));
//  console.log("store total supply value", storedTotalSupplyValue);
//
//}

function test_ExactStorage() public {
  FMETH freshContract = new FMETH();

  //check first 20 slots
  for (uint256 i = 0; i < 20; i++) {
    bytes32 value = vm.load(address(freshContract), bytes32(i));
    console.log("Fresh Contract Slot", i , ":", vm.toString(value));
  }

  vm.deal(alice, 1 ether);
  vm.prank(alice);
  freshContract.deposit{value: 0.1 ether}();

  for (uint256 i = 0; i < 20; i++) {
    bytes32 value = vm.load(address(freshContract), bytes32(i));
    console.log("After deposit Slot", i , ":", vm.toString(value));

  }

bytes32 balanceSlot = keccak256(abi.encode(alice, uint256(4))); // _balances at slot 4
uint256 balanceValue = uint256(vm.load(address(freshContract), balanceSlot));
console.log("Balance storage:", balanceValue);
}
// @dev: This test is for justchecking the "global" state
function test_FMETHWithdraw() public {
  vm.deal(alice, 1 ether);
  vm.prank(alice);

  fmeth.deposit{value: 0.1 ether}();
  assertEq(fmeth.totalPooledETH(), 0.1 ether);
  assertEq(fmeth.totalSupply(), 1e17);
  assertEq(fmeth.balanceOf(alice), 1e17);
  assertEq(address(fmeth).balance, 1e17);

  vm.warp(block.timestamp + 10 days);
//for (uint256 i = 0; i < 10; i++) {
//    bytes32 value = vm.load(address(fmeth), bytes32(i));
//    console.log('slot', i, ":", vm.toString(value));
//  }
//
//  bytes32 balanceSlot = keccak256(abi.encode(alice, uint256(4)));
//  uint256 balanceValue = uint256(vm.load(address(fmeth), balanceSlot));
//  console.log('balance storage', balanceValue);
//
  fmeth.withdraw(1, 0);    
    
}


// rewards//
// incident management - pausable//
 /*/////////////////////////////////////////////
                      EVENTS
 /////////////////////////////////////////////*/
event Deposited(address indexed account, uint256 indexed amount, uint256 indexed shares);
event Withdrawn(address indexed account, uint256 indexed ethAmount, uint256 indexed shares);



}
