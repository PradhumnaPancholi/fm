// ToDo -Add functionality to pause if it feels needed after brainstorming //

// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.30;

import "@fm/Ownable.sol";

/**
* @title Mintable
* @author Pradhumna Pancholi
* @notice Provides secure and explicit role based minting privileges for tokens
* @dev An abstract contract to provide secure and explicit minting privileges
* Unlike implicit privileges, this provides a solid separation of concern to reduce surface attack 
* For instance, the deployer is given "minter" privileges. But once the "owner" sets a new minter, the owner can not mint the token any more
* This keep the "owner" with strict admin control and "minter" with strict minting control.
*/
abstract contract Mintable is Ownable {
    address private _minter;

    /**
    * @notice Emitted when the minter role is updated
    * @param oldMinter The previous minter address
    * @param newMinter The new minter address
    **/
    event MinterUpdated(address indexed oldMinter, address indexed newMinter);

    /**
    * @notice Initializes the contract, setting up the "owner" as the initial minter.
    * @dev Extends up "Ownable" for admin privileges, and allows flexible and explicit role management for the minting privileges
    **/
    constructor() {
      _minter = msg.sender;
    }

    /**
    * @notice Throws error, if called by an address who doesn't have "minter" privileges
    * @dev Ensures that minting operations are explicitly authorized
    **/
    modifier onlyMinter() {
        require(msg.sender == _minter, "Mintable: Only minter can perform this action");
        _;
    }

    /**
    * @notice Returns the address of current minter
    * @return The current minter who can perform minting operations
    **/
    function minter() public view returns (address) {
      return _minter;
    }

    /**
    * @notice Allows the "owner" set a "minter" to new account.
    * @param newMinter the address to grant the new "minter" role.
    * @dev Can be only performed by "owner". Emits "MinterUpdated" upon success
    * The "owner" doesn't get minting privileges implicitly. 
    * The "minter" can not set a new minter, unless the same address is "minter" and "owner"
    
    * ## Important Security Notes
    * Prevents assignment to zero address to avoid privilege lock
    * Emits event for transparent privilege tracking
    * Immediate effect - new minter can mint immediately after transaction
    * No cooling period or confirmation required (consider for high-value systems)
    * 
    * @custom:security This function changes critical privileges. Monitor MinterUpdated
    * events and consider multi-sig protection for production deployments.
    **/
    function setMinter(address newMinter) public onlyOwner {
        require(newMinter != address(0), "Mintable: Zero Address Can Not Be Minter");
        address oldMinter = _minter;
        _minter = newMinter;
        emit MinterUpdated(oldMinter, newMinter);
    }
}
