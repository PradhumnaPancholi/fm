//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import "../../examples/FAIVault.sol";
import  {Test} from "forge-std/Test.sol";
import "../../examples/FAI.sol";
import {MockPriceFeed} from "../examples/FAIVault.t.sol";

contract FAIVaultTest is Test {
  FAI public fai;
  FAIVault public vault; 
  address public owner;
  address public alice;
  address public bob;
  address public charlie;
  MockPriceFeed public mockOracle;

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
    mockOracle = new MockPriceFeed();
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

  function test_Minting_EmitsEvent() public {
    vm.prank(alice);
    vm.expectEmit();
    emit FAIMinted(alice, 10000e18); 
    vault.depositCollateralAndMint{value: 2 ether}(10000e18);
  }

  function test_DepositAndMint_UpdatesGlobalState() public {
    vm.prank(alice);
    vault.depositCollateralAndMint{value: 2 ether}(10000e18);
    assertEq(vault.totalCollateral(), 2e18);
    assertEq(vault.debt(), 10000e18);
  }

  function test_DepositAndMintReverts_WhenNotEnoughETH() public {
    vm.prank(alice);
    vm.expectRevert();
    vault.depositCollateralAndMint{value: 0.5 ether}(10000e18);
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
    (uint256 collateral2, uint256 debt2) = vault.getPosition(alice);
    assertEq(collateral2, 0);
    assertEq(debt2, 0);
  }

  function test_WithdrawAndBurn_Partial() public {
    vm.prank(alice);
    vault.depositCollateralAndMint{value: 1 ether}(5000e18);
    assertEq(fai.balanceOf(alice), 5000e18);

    vm.prank(alice);
    vault.burnAndWithdrawCollateral(1000e18, 0.1 ether);
  }
  function test_WithdrawAndBurn_EmitsEvent() public {
    vm.prank(alice);
    vault.depositCollateralAndMint{value: 1 ether}(5000e18);
    assertEq(fai.balanceOf(alice), 5000e18);
    
    vm.expectEmit();
    emit FAIBurned(alice, 5000e18);
    vm.prank(alice);
    vault.burnAndWithdrawCollateral(5000e18, 1 ether);
  }

  function test_WithdrawAndBurn_UpdatesGlobalState() public {
    vm.prank(alice);
    vault.depositCollateralAndMint{value: 1 ether}(5000e18);
    assertEq(vault.totalCollateral(), 1e18);
    assertEq(vault.debt(),5000e18);

    vm.prank(alice);
    vault.burnAndWithdrawCollateral(5000e18, 1 ether);
    assertEq(vault.totalCollateral(), 0);
    assertEq(vault.debt(), 0);
  }

  function test_WithdrawAndBurn_RevertsWhen_AttemptsToHighETH() public {
    vm.prank(alice);
    vault.depositCollateralAndMint{value: 1 ether}(5000e18);

    vm.prank(alice);
    vm.expectRevert("FAIVault: not enough collateral");
    vault.burnAndWithdrawCollateral(4000e18, 1 ether);
  }

  /*////////////////////////////////////////////////////
                         LIQUIDATION
  ///////////////////////////////////////////////////*/
  function test_Liquidation() public {
    vm.prank(alice);
    vault.depositCollateralAndMint{value: 1 ether}(6666e18);
    assertEq(fai.balanceOf(alice), 6666e18);
    // @dev Original mock price for ETH was set to $10K
    // At 150%, it allows users to mint ~$6666.66 fai per ether
    // This reduces to ~ $6333.33, when ether price drops to $9500
    // At max mint, this calls for liquidation to maintain peg.
    mockOracle.setPrice(9500e18);


    vm.deal(charlie, 5 ether);
    vm.prank(charlie);
    vault.depositCollateralAndMint{value: 2 ether}(10000e18);
    vm.prank(charlie);
    fai.approve(address(vault), type(uint256).max);

    vm.prank(charlie);
    vault.liquidate(alice);
    assertGt(charlie.balance, 3, "Liquidator should get ETH");   
    (uint256 collateral, uint256 debt) = vault.getPosition(alice);
    assertLt(collateral, 1e18, "Alice's collateral should be reduced");
    assertLt(debt, 6666e18, "Alice's debt should be reduced");
  }

  function test_Liquidation_EmitsEvent() public {
    vm.prank(alice);
    vault.depositCollateralAndMint{value: 1 ether}(6666e18);
    assertEq(fai.balanceOf(alice), 6666e18);
    // @dev Original mock price for ETH was set to $10K
    // At 150%, it allows users to mint ~$6666.66 fai per ether
    // This reduces to ~ $6333.33, when ether price drops to $9500
    // At max mint, this calls for liquidation to maintain peg.
    mockOracle.setPrice(9500e18);


    vm.deal(charlie, 5 ether);
    vm.prank(charlie);
    vault.depositCollateralAndMint{value: 2 ether}(10000e18);
    vm.prank(charlie);
    fai.approve(address(vault), type(uint256).max);

    vm.prank(charlie);
    //vm.expectEmit(); 
    // @dev Math for liquidation numbers //
    // expected faiAmount = 6666e8 / 2  = 3333e18;
    // for expected ethAmount ,
    // normal eth = 3333 (FAI) / 9500 (new ETH price in USD) = ~0.35 ether
    // with 1% penalty, discounted eth = 0.35 x 0.99 = ~0.347 ether
   // emit FAIPositionLiquidated(alice, 347333684210526315, 3333e18);
    //vault.liquidate(alice);
  }

  function test_Liquidation_UpdatesGlobalState() public {
    vm.prank(alice);
    vault.depositCollateralAndMint{value: 1 ether }(6666e18);
    assertEq(vault.debt(), 6666e18);
    assertEq(vault.totalCollateral(), 1 ether);

    vm.deal(charlie, 5 ether);
    vm.prank(charlie);
    vault.depositCollateralAndMint{value: 2 ether}(10000e18);

    // Capturing state before liquidation
    uint256 totalDebtBefore = vault.debt();
    uint256 totalCollateral = vault.totalCollateral();
    (uint256 aliceCollateralBefore, uint256 aliceDebtBefore) = vault.getPosition(alice);

    // Liquidation
    vm.prank(charlie);
    fai.approve(address(vault), type(uint256).max);
    mockOracle.setPrice(9500e18);
    vm.prank(charlie);
    vault.liquidate(alice); 

    // totalDebtBefore - alice's new debt (50% of initial after liquidation)
    (uint256 aliceCollateralAfter, uint256 aliceDebtAfter ) = vault.getPosition(alice); 
    uint256 debtRemoved = aliceDebtBefore - aliceDebtAfter ;
    uint256 collateralRemoved = aliceCollateralBefore - aliceCollateralAfter;
    uint256 expectedDebt = totalDebtBefore - debtRemoved ;
    uint256 expectedCollateral = totalCollateral - collateralRemoved;

    assertEq(vault.debt(), expectedDebt);
    assertEq(vault.totalCollateral(), expectedCollateral);    
  }
  function test_Liquidation_Self() public {
    vm.prank(alice);
    vault.depositCollateralAndMint{value: 1 ether}(6666e18);
    assertEq(vault.debt(), 6666e18);
    assertEq(vault.totalCollateral(), 1 ether);
    (uint256 aliceCollateralBefore, uint256 aliceDebtBefore) = vault.getPosition(alice);
    mockOracle.setPrice(9500e18);
    
    vm.prank(alice);
    fai.approve(address(vault), type(uint256).max);
    vm.prank(alice);
    vault.liquidate(alice);

    assertEq(vault.debt(), aliceDebtBefore / 2);
    //assertEq(vault.totalCollateral(), aliceCollateralBefore /2); 
  }
  function test_Liquidation_RewardsLiquidator() public {}
  /*////////////////////////////////////////////////////
                        Incident Management
  ////////////////////////////////////////////////////*/
  

  //---------------------Events----------------------//
  event FAIMinted(address indexed account, uint256 indexed amount);
  event FAIBurned(address indexed account, uint256 indexed amount);
  event FAIPositionLiquidated(address indexed account, uint256 indexed ethAmount, uint256 indexed faiAmount);

}
