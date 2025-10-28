// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

/*
* @title Burnable
* @author Pradhumna Pancholi
* @notice A set of functionalities to implement custom burning mechanism into your tokens
* @dev This mixin exists to do more than allowing users to burn their own tokens. This module is intended to help
* Centralized and compliant institutional stablecoins like USDC
* Governance control to punish and penalize malicious actors in their respective ecosystem
* Implementing deflationary token flow
* and more custom features by extending on it.
*/
import "@fm/Ownable.sol";

abstract contract Burnable is Ownable{

  address private _burner;

  /*
  * @notice Emmitted when tokens are burned 
  * @param burner The account that performed the action 
  * @param account The account from which the tokens were burned
  * @param amount The amount of tokens burned
  */
  event TokensBurned(address indexed burner, address indexed account, uint256 amount);

  /*
  * @notice Emitted when a new address is given the burning privileges
  * @param oldBurner The address of previous burner 
  * @param newBurner The new address with burner privileges
  */
  event BurnerUpdated(address indexed oldBurner, address indexed newBurner);

  /*
  * @notice Upon deployment, sets the "owner" as "burner"
  * This should ideally be two different accounts/address which be performed using "setBurner".
  * @dev Extends upon "Ownable" and enables developers to implement flexible burning mechanisms
  */
  constructor() {
    _burner = msg.sender;
  }

  /*
  * @notice Throws error when the given function is peformed by an account without burning privileges
  * @dev Ensures that only authorized accounts can perform "burn" function
  */
  modifier onlyBurner() {
    require(msg.sender == _burner, "Burnable: Only burner can perform this action");
    _;
  }

  /*
  * @notice Returns the address of "burner"
  * @return The address of "burner"
  */
  function burner() public view returns(address) {
    return _burner;
  }

  /*
  * @notice Allows "owner" to set a new "burner" for better distribution of power and concern.
  * @dev Extends upon "Ownable" to allow only the "owner" to set a new "burner". 
  * No address/account with "burner" priivileges can perform this action
  * Emits "BurnerUpdated" event for tracking
  */
  function setBurner(address newBurner) public onlyOwner{
    require(newBurner != address(0), "Burnable: Zero address can not be a burner");
    address oldBurner = _burner;
    _burner = newBurner;
    emit BurnerUpdated (oldBurner, newBurner);
  }

  /*
  * @dev This needs to be overriden by the imported contract to manage state change according to the token design
  */
  function _burn(address from, uint256 amount) internal virtual;

  /*
  * @notice Burn tokens from the given account if the correct authorization is held by the caller
  * @param from The address from which the tokens are to be burned
  * @param amount The amount of tokens to be burned
  * @dev This provides a public interace for burn function
  * Developers are expected to override the internal "_burn" function to manage state change
  * This provides generic guards for action safety
  * Emits TokensBurned for tracking/monitoring
  */
  function burn(address from, uint256 amount) public onlyBurner{
    require(from != address(0), "Burnable: Can not burn from zero address");
    require(amount > 0, "Burnable: Amount must be non-zero");
    _burn(from, amount);
     emit TokensBurned(msg.sender, from, amount);
  }


}
