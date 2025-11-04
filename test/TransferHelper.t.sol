//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "@fm/TransferHelper.sol";
import "@fm/IERC20.sol";

/*
* @dev A mock implementation of an standard, compliant ERC-20 token that behaves ideally
*/
contract MockStandardToken is IERC20 {
  uint256 internal _totalSupply = 1000; //capped supply
  mapping(address => uint256) internal _balances;
  mapping(address => mapping(address => uint256)) internal _allowances;

  constructor() {
    _balances[msg.sender] = _totalSupply;
  }

  function name() external view returns (string memory) { return "Mock Standard Token";}
  function symbol() external view returns (string memory) {return "MST";}
  function decimals() external view returns (uint8) {return 18;}
  function totalSupply() external view returns (uint256) { return _totalSupply; }
  function balanceOf(address account) external view returns (uint256) {return _balances[account];}
  function transfer(address to, uint256 amount) external returns (bool) {
    require(_totalSupply >= amount, "MST: amount can not be higher than total supply");
    require(to != address(0), "MST: can not sent to zero address");
    require(_balances[msg.sender] >=  amount, "MST: insufficient funds");
    _balances[msg.sender] -= amount;
    _balances[to] += amount;
    return true;
  }
  function allowance(address owner, address spender) external view returns (uint256) {return _allowances[owner][spender];}
  function approve(address spender, uint256 amount) external returns (bool) {
    require(_totalSupply >= amount, "MST: approval can not be higher than total supply");
    require(msg.sender != address(0), "MST: owner can not be a zero address");
    require(spender != address(0), "MST: spender can not be a zero address");
    _allowances[msg.sender][spender] = amount;
    return true;
  }
  function transferFrom(address from, address to, uint256 amount) external returns (bool) {
    require(_totalSupply >= amount, "MST: amount can not be higher than total supply");
    require(from != address(0), "MST: from address can not be zero");
    require(to != address(0), "MST: to address can not zero address");
    require(_allowances[from][msg.sender] >= amount, "MST: not enough allowance");
    require(_balances[from] >=  amount, "MST: insufficient funds");
    _balances[from] -= amount;
    _balances[to] += amount;
    return true;
  }
 
}

/*
* @dev A mock implementation for USDT token. This does not have
* 1. minting operation like USDT
* 2. burning mechanism like USDT
* 3. incident management like USDT
* This is purely for mocking how their transfer function works because:
* 1. USDT is such bug part of ecosystem now and holds much liquidity that most DeFi protocols would use it in some way
* 2. Their can be many other non-standard erc-20 token modeled like USDT. And its not secure to no handle them explicitly
*/
contract MockUSDT {
  uint256 internal _totalSupply = 1000;

  mapping(address => uint256) internal _balances;
  mapping(address => mapping(address => uint256)) internal _allowances;

  constructor() {
    _balances[msg.sender] = _totalSupply;
  }

  function name() external view returns (string memory) {return "Mock USDT";} 
  function symbol() external view returns (string memory){ return "MUSDT";}
  function decimals() external view returns (uint8){return 18;}
  function totalSupply() external view returns (uint256){return _totalSupply;} 
  function allowance(address owner, address spender) external view returns (uint256){return _allowances[owner][spender];} 
  function balanceOf(address account) external  view returns (uint256){return _balances[account];}
  function transfer(address to, uint256 amount) external {
    require(_totalSupply >= amount, "MST: amount can not be higher than total supply");
    require(to != address(0), "MST: can not sent to zero address");
    require(_balances[msg.sender] >=  amount, "MST: insufficient funds");
    _balances[msg.sender] -= amount;
    _balances[to] += amount;
  }
  function approve(address spender, uint256 amount) external {
    require(_totalSupply >= amount, "MST: approval can not be higher than total supply");
    require(msg.sender != address(0), "MST: owner can not be a zero address");
    require(spender != address(0), "MST: spender can not be a zero address");
    _allowances[msg.sender][spender] = amount;
  }
  
  function transferFrom(address from, address to, uint256 amount) external { 
    require(_totalSupply >= amount, "MST: amount can not be higher than total supply");
    require(from != address(0), "MST: from address can not be zero");
    require(to != address(0), "MST: to address can not zero address");
    require(_allowances[from][msg.sender] >= amount, "MST: not enough allowance");
    require(_balances[from] >=  amount, "MST: insufficient funds");
    _balances[from] -= amount;
    _balances[to] += amount;
  }
}

/*
* @title TransferHelperTest
* @author Pradhumna Pancholi
* @notice A test suit for for TransferHelper utility library
*/
contract TransferHelperTest is Test {
  MockStandardToken public mst;
  MockUSDT public musdt;

  address public deployer;
  address public alice;
  address public bob;
  address public charlie;


  /*///////////////////////
          SETUP
  ///////////////////////*/
  function setUp() public {
    deployer = address(this);
    alice = makeAddr("alice");
    bob = makeAddr("bob");
    charlie = makeAddr("charlie");

    mst = new MockStandardToken();
    mst.transfer(alice, 10);

    musdt = new MockUSDT();
    musdt.transfer(alice, 10);

    vm.deal(alice, 1 ether);
    vm.deal(bob, 1 ether);
  }

  function test_SafeTransfer_Standard_Success() public {
    vm.prank(alice);
    TransferHelper.safeTransfer(address(mst), bob, 10);
  }

  function test_SafeTransfer_MUSDT_Success() public {
    vm.prank(alice);
    TransferHelper.safeTransfer(address(musdt), bob, 10);
  }


} 
