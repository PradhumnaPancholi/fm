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
//    vm.deal(address(fmeth), 1 ether);
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

//function test_ExactStorage() public {
//  FMETH freshContract = new FMETH();
//
//  //check first 20 slots
//  for (uint256 i = 0; i < 20; i++) {
//    bytes32 value = vm.load(address(freshContract), bytes32(i));
//    console.log("Fresh Contract Slot", i , ":", vm.toString(value));
//  }
//
//  vm.deal(alice, 1 ether);
//  vm.prank(alice);
//  freshContract.deposit{value: 0.1 ether}();
//
//  for (uint256 i = 0; i < 20; i++) {
//    bytes32 value = vm.load(address(freshContract), bytes32(i));
//    console.log("After deposit Slot", i , ":", vm.toString(value));
//
//  }

//bytes32 balanceSlot = keccak256(abi.encode(alice, uint256(4))); // _balances at slot 4
//uint256 balanceValue = uint256(vm.load(address(freshContract), balanceSlot));
//console.log("Balance storage:", balanceValue);
//}
//function  test_BalanceStorage() public {
//  // 1. Contract Identity
//  console.log("fmeth address : ", address(fmeth));
//  console.log("test contract : ", address(this));
//
//  //2. Deploying fresh fmeth contract//
//  FMETH fresh = new FMETH();
//  console.log("fresh fmeth : ", address(fresh));
//
//  vm.deal(alice, 1 ether);
//  vm.prank(alice);
//  fresh.deposit{value: 0.1 ether}();
//
//  for (uint256 i = 0; i < 20; i++) {
//    bytes32 value = vm.load(address(fresh), bytes32(i));
//    console.log("slot" ,i, " : ", vm.toString(value));
//  }
//
//    // 5. Check balance via function call
//    console.log("balanceOf(alice):", fresh.balanceOf(alice));
//    bytes32 balanceSlot = keccak256(abi.encode(alice, uint256(4)));
//    uint256 balanceFromSlot = uint256(vm.load(address(fresh), balanceSlot));
//    console.log("Direct balance slot access:", balanceFromSlot);
//
//    console.log("totalSupply() : ", fresh.totalSupply());
//    bytes32 totalSupplySlot = bytes32(uint256(3));
//    uint256 totalSupplyFromSlot = uint256(vm.load(address(fresh), totalSupplySlot));
//    console.log("TotalSupply from slot:", totalSupplyFromSlot);
//
//    //-----------------------------//
//   // Try withdrawing exactly the balance
//    uint256 shares = fresh.balanceOf(alice);
//    console.log("Shares to withdraw:", shares);  console.log("Shares to withdraw:", shares);   
//    vm.prank(alice);
//    fresh.withdraw(shares, 0.1 ether);
//}
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
vm.prank(alice);
  fmeth.withdraw(1, 0);    
    
}


  /*--------------------------------------------
                    REWARDS
  ---------------------------------------------*/
  
  //1. Rewards accural over time
  //2. Math pricision - small rewards don't get rounded to zero
  //3. Fair rewards for depsittors 
  //4. Emits events
  //5. Edge Cases
  //  a. zero time elasped
  //  b. maximum time
  //  c. tiny deposits
  //6. Share price appreciation 
  function test_FMETHWithdrawAddsReward() public {
    //ToDo : Add documention and set clean logic for mock rewards , explaing eth v/s virtual eth
    vm.deal(address(fmeth), 1 ether); // to deal with virtual eth
    vm.deal(alice, 1 ether);
    vm.prank(alice);
    fmeth.deposit{value: 1 ether}();
    assertEq(fmeth.balanceOf(alice), 1e18);
    assertEq(fmeth.totalPooledETH(), 1 ether);

    vm.warp(block.timestamp + 100 days);
    vm.prank(alice);

    //uint256 rewards = ((block.timestamp + 100 days) * 1e18 * 400) / (10000 * 365 days) ;
    //uint256 balanceWithRewards = 1e18 + rewards;
    //console.log("with rewards : ", balanceWithRewards);
    
    fmeth.withdraw(1e18, 1 ether);
    //ToDo make a cleaner, more readable code to calculate balance with rewards to check againt instead of hardcoded//
    assertEq(address(alice).balance, 1010958904109589041);
  }

  function test_FMETHPreciseRewards() public {
    vm.deal(alice, 1 ether);
    vm.prank(alice);
    fmeth.deposit{value:0.1 ether}();
    assertEq(fmeth.balanceOf(alice), 1e17);

    vm.warp(block.timestamp + 2 days);
    vm.prank(alice);

    
    //Annual rewards: 0.1 ETH × 0.04 = 0.004 ETH
    //Daily rewards: 0.004 ETH ÷ 365 ≈ 0.0000109589 ETH
    //2 days rewards: 0.0000109589 × 2 ≈ 0.0000219178 ETH
    vm.deal(address(fmeth), 0.5 ether); // this is to deal with funds for contract to pay for transaction
    fmeth.withdraw(1e17,0.1 ether);
    assertGt(address(alice).balance, 0.9 ether + 0.1000219178 ether);

  }

  function test_FMETHFairRewardsForDepositors() public {
    vm.deal(alice, 10 ether);
    vm.deal(bob, 10 ether);

    vm.prank(alice);
    fmeth.deposit{value: 10 ether}();
    uint256 aShares = fmeth.balanceOf(alice);
    vm.warp(block.timestamp + 30 days);
    vm.prank(bob);
    fmeth.deposit{value: 10 ether}();
    uint256 bShares = fmeth.balanceOf(bob);
    vm.warp(block.timestamp + 30 days);

    vm.deal(address(fmeth), 50 ether); // to deal with virtual ETH for fees//
 
    //Annual rewards: 1 ETH × 0.04 = 0.04 ETH
    //Daily rewards: 0.04 ETH ÷ 365 ≈ 0.000109589 ETH
    // Rewards for 30 days: 30 X 0.000109589 = 0.00328767 
    // Rewards for 60 days: 60 X 0.000109589 = 0.00657534
    vm.prank(alice);
    fmeth.withdraw(aShares, 10e18);
    vm.assertGe(address(alice).balance, 10 ether + 0.00657537 ether);
    vm.prank(bob);
    fmeth.withdraw(bShares, 10e18);
    vm.assertGe(address(bob).balance, 10 ether + 0.00328767 ether);
    console.log('alice', address(alice).balance, address(bob).balance);
  }

  function testFMETHWithdrawEmitsEvent () public {
    vm.deal(alice, 1 ether);
    vm.prank(alice);
    fmeth.deposit{value: 1 ether}();
    assertEq(fmeth.balanceOf(alice), 1e18);

    vm.expectEmit();
    vm.prank(alice);
    emit Withdrawn(alice, 1e17, 1e17);
    fmeth.withdraw(1e17, 1e17);
  
  }

  /*--------------------------------------------/
        PAUSABLE => Incident Management
  /-------------------------------------------*/
 function test_FMETHMintReverts_WhenPaused() public {
    vm.prank(owner);
    fmeth.pause();
    
    vm.deal(alice, 0.1 ether);
    vm.prank(alice);

    vm.expectRevert("Pausable: Contract is currently paused");
    fmeth.deposit{value: 0.1 ether}();
 }

 function test_FMETHWithdrawReverts_WhenPaused() public {
   vm.deal(alice, 1 ether);
   vm.prank(alice);
   fmeth.deposit{value: 0.1 ether}();

   vm.prank(owner);
   fmeth.pause();

   vm.prank(alice);
   vm.expectRevert("Pausable: Contract is currently paused");
   fmeth.withdraw(1e17, 1e17);
 }
 /*/////////////////////////////////////////////
                      EVENTS
 /////////////////////////////////////////////*/
event Deposited(address indexed account, uint256 indexed amount, uint256 indexed shares);
event Withdrawn(address indexed account, uint256 indexed ethAmount, uint256 indexed shares);



}
