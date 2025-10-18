// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.30;

import "@fm/Ownable.sol";

/*
* @title Pausable
* @author Pradhumna Pancholi
* @notice Provides secure and modular pausing functionality  
* @dev An abract contract that provides modular pausing functionality for incident managment. 
* For true decentralization, pausing is not favourable. Hence, it is not built into the ERC-20 base contract.
* However, it is critical for complainace and incident managment.
* For many institutional products like USDC, this functionality is critical.
* Initally, it sets the "owner" as the "pauser" but it can be updates with "setPauser"
* This seperation of concern and philosophy of the least privileged it provide better security.
* Having different addresses/multisigs for these privileges helps when
* 1. A wallet has been compromised. 
* 2. Avoid single point of failure
* 3. Seperation of concern.
*/

abstract contract Pausable is Ownable {

  bool private _paused;
  address private _pauser;

  /*
  * @notice Emitted when the contract is paused
  * @param pauser The address which triggered this function
  */ 
  event Paused(address indexed pauser);

  /*
  * @notice Emitted when the given contract un-paused 
  * @param pauser The address which triggered the call
  */
  event UnPaused(address indexed pauser);


  /*
  * @notice Emitted when the pauser role is changed
  * @param oldPauser The address that held pauser privileges before this update.
  * @param newPauser The address that holds pauser privileges from this moment onwards.
  */
  event PauserUpdated(address indexed oldPauser, address indexed newPauser);

  /*
  * @notice Initializes the contract, setting up the "owner" as "pauser". 
  * In an ideal case though, it should be different can be be changes with "setPauser"  
  * @dev Extends on "Ownable" , and provides the "pauser" with functionalities to pause transfers, minting, burning, etc.
  */
  constructor() {
    _pauser = msg.sender;
  }


  /*
  * @notice Returns the address of pauser
  * @return The address of pauser
  */
  function pauser() public view returns (address) {
    return _pauser;
  }

  /*
  * @notice Throws if called by any account other than the pauser
  * @dev Ensures only authorized addresses can pause/unpause
  */
  modifier onlyPauser() {
    require(_pauser == msg.sender, "Pausable: Only pauser can perform this action");
    _;
  }
  /*
  * @notice Throws error, if the contract is not paused
  */
  modifier whenPaused() {
    require(_paused == true, "Pausable: Contract is not paused");
    _;
  }

  /*
  * @notice Throws error, if the contract is not paused. 
  */
  modifier whenNotPaused() {
    require(_paused == false, "Pausable: Contract is currently paused"); 
    _;
  }

  /*
  * @notice Allows the "pauser" to pause a contract. Allowing admin teams / community to deal with incidents
  * @dev The "pauser" can pause the contract by calling this function. Inherited contracts can use modifiers like "whenPaused" and "whenNotPaused", respectively. 
  * Emits "Paused" event for transparent tracking
  * @custom:security The function can change the nature of core functionalities of the inherited token. 
  * It is only supposed to be used on rare occasion of critical need.
  * Monitor "Paused" for tracking
  */
  function pause() public onlyPauser {
    _paused = true;
    emit Paused(msg.sender);
  }

  /*
  * @notice Allows the "pauser" to un-pause the contract. Allowing the users to continue using the prouduct at their normal state once the incident is addressed and taken care of
  * @dev The "pauser" can un-pause to turn normal functionalites back on.
  * Emits "Paused" event for transparent tracking
  */
  function unpause() public onlyPauser {
    _paused = false;
    emit UnPaused(msg.sender);
  }

  /*
  * @notice Allows "owner" to set a new "pauser" for better distriution of power and concern. 
  * @dev Extends upton "Ownable" to allow just the owner to set a new pauser. But the "pauser" can not perform this action.
  * Emits "PauserUpdated" event for tracking.
  */
  function setPauser(address newPauser) public onlyOwner {
    require(newPauser != address(0), "Pausbale: Zero address cannot be a pauser");
    address oldPauser = _pauser;
    _pauser = newPauser;
    emit PauserUpdated(oldPauser, newPauser);
  }
}
