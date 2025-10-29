# Mintable
[Git Source](https://github.com/PradhumnaPancholi/fm/blob/8d94bb6c061a4dbcf51c00c97d17456b302080d4/src/Mintable.sol)

**Inherits:**
[Ownable](/src/Ownable.sol/abstract.Ownable.md)

**Author:**
Pradhumna Pancholi

Provides secure and explicit role based minting privileges for tokens

*An abstract contract to provide secure and explicit minting privileges
Unlike implicit privileges, this provides a solid separation of concern to reduce surface attack
For instance, the deployer is given "minter" privileges. But once the "owner" sets a new minter, the owner can not mint the token any more
This keep the "owner" with strict admin control and "minter" with strict minting control.*


## State Variables
### _minter

```solidity
address private _minter;
```


## Functions
### constructor

Initializes the contract, setting up the "owner" as the initial minter.

*Extends up "Ownable" for admin privileges, and allows flexible and explicit role management for the minting privileges*


```solidity
constructor();
```

### onlyMinter

Throws error, if called by an address who doesn't have "minter" privileges

*Ensures that minting operations are explicitly authorized*


```solidity
modifier onlyMinter();
```

### minter

Returns the address of current minter


```solidity
function minter() public view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The current minter who can perform minting operations|


### setMinter

Allows the "owner" set a "minter" to new account.

*Can be only performed by "owner". Emits "MinterUpdated" upon success
The "owner" doesn't get minting privileges implicitly.
The "minter" can not set a new minter, unless the same address is "minter" and "owner"
## Important Security Notes
Prevents assignment to zero address to avoid privilege lock
Emits event for transparent privilege tracking
Immediate effect - new minter can mint immediately after transaction
No cooling period or confirmation required (consider for high-value systems)*

**Note:**
security: This function changes critical privileges. Monitor MinterUpdated
events and consider multi-sig protection for production deployments.


```solidity
function setMinter(address newMinter) public onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newMinter`|`address`|the address to grant the new "minter" role.|


## Events
### MinterUpdated
Emitted when the minter role is updated


```solidity
event MinterUpdated(address indexed oldMinter, address indexed newMinter);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`oldMinter`|`address`|The previous minter address|
|`newMinter`|`address`|The new minter address|

