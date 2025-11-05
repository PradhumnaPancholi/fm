# Ownable
[Git Source](https://github.com/PradhumnaPancholi/fm/blob/5e6dc7885d9a949586c1f2015ee2dc3135a1eed6/src/Ownable.sol)


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

