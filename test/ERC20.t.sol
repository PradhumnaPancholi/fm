//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/token/ERC20.sol";

//Implemention of base ERC20 contract for testing//
contract MockERC20 is ERC20 {

  constructor(string memory name, string memory symbol, uint8 decimals)
  ERC20(name, symbol, decimals){}

  //Exposes internal function "_mint" for testing
  function mint(address to, uint256 amount) public {
    _mint(to, amount);
  }

  //Exposes internal function "_burn" for testing
  function burn(address from, uint256 amount) public {
    _burn(from, amount);
  }
}

//---Tests---//
contract ERC20Test is Test {

  MockERC20 public token;

  //Setting up accounts for testing
  address public owner;
  address public alice;
  address public bob;

  function setUp() public {
    owner = address(this); // This makes this contract owner of the mockERC20
    alice = makeAddr("alice");
    bob = makeAddr("bob");

    //Deploys an instance of MockERC20
    token = new MockERC20("Test Token", "TST", 18);
  }

  // Metadata //
  function test_MetaData() public view{
    assertEq(token.name(), "Test Token");
    assertEq(token.symbol(), "TST");
    assertEq(token.decimals(), 18);
  }

  // Minting
  function test_Mint() public {
    token.mint(alice, 100);
    
    //1. Token supply increased
    assertEq(token.totalSupply(), 100);
    //2. Alice gets 100 tokens
    assertEq(token.balanceOf(alice), 100);
     
  }

  function test_MintToZeroAddr() public {
    vm.expectRevert("ERC-20: Mint To Zero Address");
    token.mint(address(0), 10);
  }

  function test_MintEmitsTransfer() public {
    vm.expectEmit();
    emit Transfer(address(0),alice, 100);

    token.mint(alice, 100);
  }

  // Burn
  //1. burn affects total supply and blance
 // 2. Burn emits events
  //3. can not burn more tokens
  //4. can not burn from zero
  function test_Burn() public {
    token.mint(alice, 100);
    assertEq(token.totalSupply(), 100);
    assertEq(token.balanceOf(alice), 100);

    token.burn(alice, 10);
    assertEq(token.totalSupply(), 90);
    assertEq(token.balanceOf(alice), 90);
  }

  function test_BurnEmitsTransfer() public {
    token.mint(alice, 20);
    assertEq(token.balanceOf(alice), 20);
    vm.expectEmit(true, true, false, true);
    emit Transfer(alice, address(0), 10);

    token.burn(alice, 10);
  }

  function test_BurnRevertsInsufficientBalance() public {
    token.mint(alice, 10);
    assertEq(token.balanceOf(alice), 10);

    vm.expectRevert("ERC-20: Amount Exceeds Account Balance");
    token.burn(alice, 11);
  }

  function test_BurnFromZeroAddress() public {
    vm.expectRevert("ERC-20: Account Is An Zero Address");
    token.burn(address(0), 1);
  }

  // Transfer
  //1. Transfer from 0 address
  // 2. Transfer emits Transfer
  // 3. Transfer modifies balance//
  //4 . transfer to zero address
  //5. transfer full balance//
  //6. Transfer insuf balance
  function test_Transfer() public {
    token.mint(alice, 10);
    assertEq(token.balanceOf(alice), 10); // alice's balance is 10
    assertEq(token.balanceOf(bob), 0); // bob's blance is 0

    vm.prank(alice); // set current account to alice
    token.transfer(bob, 5);
    
    assertEq(token.balanceOf(alice), 5); // alice's balance should be 5
    assertEq(token.balanceOf(bob), 5); // bob's blance should be 5
  }
  // Events
  event Transfer(address indexed from, address indexed to, uint256 amount);
}
