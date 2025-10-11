//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

abstract contract ERC20 {

  // @dev Token Metadata
  string private _name;
  string private _symbol;
  uint8 private _decimals;

  // Handling Balance
  uint256 private _totalSupply;
  mapping(address => uint256) private _balances;
  mapping(address => mapping(address => uint256)) private _allowances;
  //Events//
  event Transfer(address indexed from, address indexed to, uint256 amount);
  event Approval(address indexed owner, address indexed spender, uint256 amount);
  /**
    * @dev Sets the values for name, symbol, and decimals
  **/
  constructor(string memory name_, string memory symbol_, uint8 decimals_){
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

  function decimals() public view returns (uint8) {
    return _decimals;
  }

  function totalSupply() public view returns (uint256) {
    return _totalSupply;
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
  function _approve(address owner, address spender, uint256 amount) internal virtual {
    require(spender != address(0), "ERC-20: Approve To Zero Address");
    require(owner != address(0), "ERC-20: Approve From Zero Address");
    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  function _transfer(address from, address to, uint256 amount) internal virtual {
    require(from != address(0), "ERC-20: Transfer From Zero Address");
    require(to != address(0), "ERC-20: Transfer To Zero Address");
    uint256 accountBalance = _balances[from];
    require(accountBalance >= amount, "ERC-20: Amount Exceeds Balance");
    unchecked {
      _balances[from] = accountBalance - amount;
      _balances[to] += amount;
    }
    emit Transfer(from, to, amount);
  }

  function _mint(address account, uint256 amount) internal virtual {
    require(account != address(0), "ERC-20: Mint To Zero Address");
    _totalSupply += amount;
    unchecked {
      _balances[account] += amount;
    }
    emit Transfer(address(0), account, amount);
  }

  function _spendAllowance(address owner, address spender, uint256 amount) internal virtual{
    uint256 currentAllowance = _allowances[owner][spender];

    if (currentAllowance != type(uint256).max ) {
      require(currentAllowance >= amount, "ERC-20: Insufficient Allowance");
      unchecked {
        _allowances[owner][spender] -= amount;
      }
    }
  }
 
  function _burn(address account, uint256 amount) internal virtual {
    require(account != address(0), "ERC-20: Account Is An Zero Address");
    uint256 accountBalance = _balances[account];
    require(accountBalance >= amount, "ERC-20: Amount Exceeds Account Balance");
    unchecked {
      _balances[account] = accountBalance - amount;
      _totalSupply -= amount;
    }
    emit Transfer(account, address(0), amount);
  }
  
}
