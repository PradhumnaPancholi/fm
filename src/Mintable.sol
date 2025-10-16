//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.30;

import "@fm/Ownable.sol";

// @title Mintable 
// @author Pradhumna Pancholi
// @notice An access control implementation that provides modular and secure control over minting previleges. Its more than about just minting tokens. Its about making a sustainable, secure, and trustless system which allows a flexible path to true decentralization
abstract contract Mintable is Ownable{

    address private _minter;

    //events
    event MinterUpdated(address indexed oldMinter, address indexed );
    
    constructor() {
    }

    modifier onlyMinter() {
        require(msg.sender == _minter);
        _;
    }

    function setMinter(address newMinter) public onlyOwner{
      require(newMinter != address(0), "Mintable: Zero Address Can Not Be Minter");
      emit MinterUpdated(_minter, newMinter);
      _minter = newMinter; 
    }
    


}

