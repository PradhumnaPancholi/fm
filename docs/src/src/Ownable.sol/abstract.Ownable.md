# Ownable
[Git Source](https://github.com/PradhumnaPancholi/fm/blob/45f598020bcf465d88cc4d54367f89ee9613baad/src/Ownable.sol)


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

