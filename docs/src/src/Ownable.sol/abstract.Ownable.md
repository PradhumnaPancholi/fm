# Ownable
[Git Source](https://github.com/PradhumnaPancholi/fm/blob/8d94bb6c061a4dbcf51c00c97d17456b302080d4/src/Ownable.sol)


## State Variables
### _owner

```solidity
address private _owner;
```


## Functions
### constructor


```solidity
constructor();
```

### onlyOwner


```solidity
modifier onlyOwner();
```

### owner


```solidity
function owner() public view returns (address);
```

### transferOwnership


```solidity
function transferOwnership(address newOwner) public onlyOwner;
```

## Events
### OwnershipTransferred

```solidity
event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
```

