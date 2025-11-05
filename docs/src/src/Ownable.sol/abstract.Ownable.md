# Ownable
[Git Source](https://github.com/PradhumnaPancholi/fm/blob/599e5f65db21026d1a2cf81c2b31c737c15f6bc3/src/Ownable.sol)


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

