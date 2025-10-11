//SPDX-License-Identifier: GPL-3.0 
pragma solidity ^0.8;


abstract contract Mintable {

  // ownaer address
  //constructor
  // only ownder modifier//
  // transfer
  //renounce //
  // mint internal//
  // mint public

  address public owner;

  event OwnershipTransferred( address indexed oldOwner,address indexed newOwner);

  constructor(){
    owner = msg.sender;
  }

  modifier onlyOwner {
    require(msg.sender == owner, "Authorization Error: Owner Previliges Required!");
    _;
  }

  function transferOwnership(address newOwner) public virtual onlyOwner {
    require(newOwner!= address(0), "Invalid Address!");
    emit OwnershipTransferred(msg.sender, newOwner);
    owner = newOwner;
  }

  function renounceOwnership() public virtual onlyOwner {
    emit OwnershipTransferred(owner, address(0));
    owner = address(0);
  }

  function mint(address to, uint256 amount) public virtual onlyOwner {
    _mint(to, amount);
  }

  function _mint(address to, uint256 amount) internal virtual;

}
