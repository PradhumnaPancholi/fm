//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

abstract contract ERC20 {

  // @dev Token Metadata
  string private _name;
  string private _symbol;
  uint256 private _decimals;

  // Handling Balance
  uint256 private _tokenSupply;
  mapping(address => uint256) private _balances;
  mapping(address => mapping(address => uint256)) private _allowances;
  //Events//
  event Transfer(address indexed from, address indexed to, uint256 amount);
  event Approval(address indexed owner, address indexed spender, uint256 amount);
  /**
    * @dev Sets the values for name, symbol, and decimals
  **/
  constructor(string memory name_, string memory symbol_, uint256 decimals_){
    _name = name_;
    _symbol = symbol_;
    _decimals = decimals_;
  }

  //View Functions - name, symbol, decimals

  function name() public view returns (string memory) {
    return _name;
  }

  function symbol() public view returns (string memory) {
    return _symbol;
  }

  function decimals() public view returns (uint256) {
    return _decimals;
  }

  function tokenSupply() public view returns (uint256) {
    return _tokenSupply();
  }

  function allowance(address owner, address spender) public view returns (uint256) {
    return _allowances[owner][spender];
  }

  function balanceOf(address account) public view returns (uint256) {
    return _balances[account];
  }

  // Public Functions

  function transfer(address to, uint256 amount) public returns (bool){
    _transfer(msg.sender, to, amount);
    return true;
  }

  function approve(address spender, uint256 amount) public returns (bool){
    _approve(msg.sender, spender, amount);
    return true;
  }

  function transferFrom(address from, address to, uint256 amount) public returns (bool){
    _spendAllowance(from, msg.sender, amount);
    _transfer(from, to, amount);
    return true;
  }

  // Internal Functions//
  function _transfer(address from, address to, uint256 amount) internal virtual {
    require(from != address(0), "ERC-20: Transfer From The Zero Address");
    require(to != address(0), "ERC-20: Transfer To The Zero Address");
    require(_balances[from] >= amount, "ERC-20: Amount Exceeds Balance");
    _balances[from] -= amount;
    _balances[to] += amount;
    emit Transfer(from, to, amount);
  }

}
