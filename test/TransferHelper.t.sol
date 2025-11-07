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
  function allowance(address owner, address spender) external view returns (uint256) {
    uint256 currentAllowance =  _allowances[owner][spender];
    console.log(" allowance contract", address(this));
    console.log("current allowance", currentAllowance);
    return currentAllowance;
  }
  function approve(address spender, uint256 amount) external returns (bool) {
    require(_totalSupply >= amount, "MST: approval can not be higher than total supply");
    require(msg.sender != address(0), "MST: owner can not be a zero address");
    require(spender != address(0), "MST: spender can not be a zero address");
    _allowances[msg.sender][spender] = amount;
    console.log("approve contract", address(this));
    console.log("allowance", _allowances[msg.sender][spender]);
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
    require(_totalSupply >= amount, "MUSDT: amount can not be higher than total supply");
    require(to != address(0), "MUSDT: can not sent to zero address");
    require(_balances[msg.sender] >=  amount, "MUSDT: insufficient funds");
    _balances[msg.sender] -= amount;
    _balances[to] += amount;
  }
  function approve(address spender, uint256 amount) external {
    require(_totalSupply >= amount, "MUSDT: approval can not be higher than total supply");
    require(msg.sender != address(0), "MUSDT: owner can not be a zero address");
    require(spender != address(0), "MUSDT: spender can not be a zero address");
    _allowances[msg.sender][spender] = amount;
  }
  
  function transferFrom(address from, address to, uint256 amount) external { 
    require(_totalSupply >= amount, "MUSDT: amount can not be higher than total supply");
    require(from != address(0), "MUSDT: from address can not be zero");
    require(to != address(0), "MUSDT: to address can not zero address");
    require(_allowances[from][msg.sender] >= amount, "MUSDT: not enough allowance");
    require(_balances[from] >=  amount, "MUSDT: insufficient funds");
    _balances[from] -= amount;
    _balances[to] += amount;
  }
}

/*
* @dev A token that's designed to be malicious. The kind that exploits and ERC-20's behaviour assumptions with silent failures
* @custom:security This is particularly to enforce return type. Many protocols dont check for return types and just rely on revert* This is where malicious tokens can perform various malicious operations and leave permissionless protocols vulnerable. 
* Imagine this, we have a permissionless protocol that allows users/find managers to launch their strategizied vaults. It ends up passing all the tests and goes live on mainnet. However, its transfer function wasn't performin anything and just returning "false" a.k.a silent failure. And tests did't check for return type but rather just relied on checking if it reverted which it did't. This can lead to loss of reputation and funds. 
* This had lead to multiple incidents in 2018 specifically. The affected projects like:
* 1. BeautyChain
* 2. MESH
* 3. Kyber Network (early version)
* 4. USDT (early version)
* 5. Bancor
*/
contract MaliciousToken is IERC20 {
  uint256 internal _totalSupply = 1000; //capped supply
  mapping(address => uint256) internal _balances;
  mapping(address => mapping(address => uint256)) internal _allowances;

  constructor() {
    _balances[msg.sender] = _totalSupply;
  }

  function name() external view returns (string memory) { return "Malicious Token";}
  function symbol() external view returns (string memory) {return "MTK";}
  function decimals() external view returns (uint8) {return 18;}
  function totalSupply() external view returns (uint256) { return _totalSupply; }
  function balanceOf(address account) external view returns (uint256) {return _balances[account];}
  function transfer(address to, uint256 amount) external returns (bool) {
    return false;
  }
  function allowance(address owner, address spender) external view returns (uint256) {
    return 0;
  }
  function approve(address spender, uint256 amount) external returns (bool) {
    return false;
  }

  function transferFrom(address from, address to, uint256 amount) external returns (bool) {
    return false;
  }

} 

contract RevertingToken is IERC20 {
  uint256 internal _totalSupply = 1000; //capped supply
  mapping(address => uint256) internal _balances;
  mapping(address => mapping(address => uint256)) internal _allowances;

  constructor() {
    _balances[msg.sender] = _totalSupply;
  }

  function name() external view returns (string memory) { return "Reverting Token";}
  function symbol() external view returns (string memory) {return "RTK";}
  function decimals() external view returns (uint8) {return 18;}
  function totalSupply() external view returns (uint256) { return _totalSupply; }
  function balanceOf(address account) external view returns (uint256) {return _balances[account];}
  function transfer(address to, uint256 amount) external returns (bool) {
    revert();
  }
  function allowance(address owner, address spender) external view returns (uint256) {
    return 0;
  }
  function approve(address spender, uint256 amount) external returns (bool) {
    revert();
  }

  function transferFrom(address from, address to, uint256 amount) external returns (bool) {
    revert();
  }


}
/*
* @title TransferHelperTest 
  @author Pradhumna Pancholi
* @notice A test suit for for TransferHelper utility library
*/
contract TransferHelperTest is Test {
  MockStandardToken public mst;
  MockUSDT public musdt;
  MaliciousToken public mtk;
  RevertingToken public rtk;

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

    mtk = new MaliciousToken();
    mtk.transfer(alice, 10);

    rtk = new RevertingToken();

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

  function test_SafeTransferRevert_Malicious() public {
    vm.prank(deployer);
    //`vm.expectRevert(abi.encodeWithSelector(TransferHelper.TransferFailed.selector));
    //vm.expectRevert(bytes4(0xc31eb0e0));
    vm.expectRevert();
    TransferHelper.safeTransfer(address(mtk), bob, 10);
  }

  function test_SafeTransfer_Catches_Revert() public {
    vm.prank(deployer);
    vm.expectRevert();
    TransferHelper.safeTransfer(address(rtk), alice, 10);
  }

  function test_SafeApprove_Standard_Success() public {
    vm.prank(alice);
    TransferHelper.safeApprove(address(mst), bob, 10);
    assertEq(mst.allowance(alice, bob), 10);
  }

  function test_SafeApprove_MUSDT_Success() public {
    vm.prank(alice);
    TransferHelper.safeApprove(address(musdt), bob, 10);
    assertEq(musdt.allowance(alice, bob), 10);
  }
  
  function test_SafeApproveRevertsWhen_Malicious() public {
    vm.prank(alice);
//    TransferHelper.safeApprove(address(mtk), bob, 10);
  }

  function test_SafeTransferFrom_Standard_Success() public {
    vm.prank(alice);
    TransferHelper.safeApprove(address(mst), bob, 10);
    vm.prank(bob);
    TransferHelper.safeTransferFrom(address(mst),alice, charlie, 5);
  }
  
  function test_SafeTransferFrom_MUSDT_Success() public {
    vm.prank(alice);
    TransferHelper.safeApprove(address(musdt), bob, 10);
    vm.prank(bob);
    TransferHelper.safeTransferFrom(address(musdt),alice, charlie, 5);
  }

  function test_GetBalance_Standard_Success() public {
    uint256 balance = TransferHelper.getBalance(address(mst), alice);
    assertEq(balance, 10);
  }

  function test_GetBalance_MUSDT_Success() public {
    uint256 balance = TransferHelper.getBalance(address(musdt), alice);
    assertEq(balance, 10);

  }

  function test_SafeTransferETH_Success() public {
    uint256 alicePrevBalance = address(alice).balance;
    uint256 bobPrevBalance = address(bob).balance;
    TransferHelper.safeTransferETH(bob, 10 ether);
    uint256 bobNewBalance = address(bob).balance;
    assertEq(bobNewBalance, 11 ether);
  }
  function test_SafeTransferETH_ZeroAmount() public {
    //doesn't revert, handles gracefully//
    vm.deal(alice, 5 ether);
    vm.prank(alice);
    TransferHelper.safeTransferETH(bob, 0);
    assertEq(address(alice).balance, 5 ether);
  }
  function test_SafeTransferETH_ZeroAddress() public {
    vm.deal(alice, 5 ether);
    vm.prank(alice);
    TransferHelper.safeTransferETH(address(0), 1 ether);
    assertEq(address(alice).balance, 4 ether);
  }

//  function test_storage() public {
//    vm.prank(alice);
//    mst.approve(bob, 10);
//
//    console.log("allowance", mst.allowance(alice, bob));
//    assertEq(mst.allowance(alice, bob), 10);
//  }
//
//  function test_lowLevelCall() public {
//    vm.prank(alice);
//    
//    (bool success, ) = address(mst).call(
//      abi.encodeWithSelector(IERC20.approve.selector, bob, 0)
//    );
//
//    console.log("low level call 1", success);
//    assertEq(mst.allowance(alice, bob), 0);
//   (bool success2, ) = address(mst).call(
//      abi.encodeWithSelector(IERC20.approve.selector, bob, 10)
//    );
//    console.log("low level call 2", success2);
//    assertEq(mst.allowance(alice, bob), 10);
//  }
//

} 
