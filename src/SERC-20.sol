//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8;

contract SERC20 {

  string public name = "SCRATCH";
  string public symbol = "SCH";
  uint8 public immutable decimals = 18;
  uint256 public tokenSupply;
  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address=>uint256))public allowance;
  
  event Transfer(address from, address to, uint256 amount);
  event Approval(address from, address spender, uint256 amount);
 
  constructor(uint256 tokenSupply_){
    tokenSupply = tokenSupply_;
  }

  function approve(address spender, uint256 amount) public returns(bool) {
    require(spender != address(0), "Invalid Address!");
    allowance[msg.sender][spender] = amount;
    emit Approval(msg.sender, spender, amount);
    return true;
  }


  function _transfer(address from, address to, uint256 amount) internal{
    require(to != address(0), "Can Not Transfer To Zero Address!");
    // Interesting edge case: Transferring FROM zero address would mean minting. In practice:
    // This will fail anyway because balanceOf[address(0)] is always 0
    // But explicit check is clearer and saves gas on revert message
    // OpenZeppelin does check this, s
    require(balanceOf[from] >= amount, "Insufficient Funds!");
    balanceOf[from] -= amount;
    balanceOf[to] += amount;
    emit Transfer(from, to, amount);
  }

  function transfer(address to, uint256 amount) public returns(bool){
    _transfer(msg.sender,to, amount);
    return true;
  }

  function transferFrom(address from, address to, uint256 amount) public returns (bool) {
    require(allowance[from][msg.sender] >= amount, "Amount Exceeds Allowance!");
    allowance[from][msg.sender] -= amount;
    _transfer(from,to,amount); 
    return true;
  }



  
  // required functions//
//totalSupply() - returns total token supply - done
//balanceOf(address) - returns balance of an account - done
//transfer(address, uint256) - transfers tokens - done
//approve(address, uint256) - approves spender - done
//allowance(address, address) - returns approved amount = done
//transferFrom(address, address, uint256) - transfers on behalf of


// needed events
//1. transfer - done
//2. approval- done
}
