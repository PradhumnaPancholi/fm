# Burnable
[Git Source](https://github.com/PradhumnaPancholi/fm/blob/599e5f65db21026d1a2cf81c2b31c737c15f6bc3/src/Burnable.sol)

**Inherits:**
[Ownable](/src/Ownable.sol/abstract.Ownable.md)


## State Variables
### _burner

```solidity
address private _burner;
```


## Functions
### constructor


```solidity
constructor();
```

### onlyBurner


```solidity
modifier onlyBurner();
```

### burner


```solidity
function burner() public view returns (address);
```

### setBurner


```solidity
function setBurner(address newBurner) public onlyOwner;
```

### _burn


```solidity
function _burn(address from, uint256 amount) internal virtual;
```

### burn


```solidity
function burn(address from, uint256 amount) public onlyBurner;
```

## Events
### TokensBurned

```solidity
event TokensBurned(address indexed burner, address indexed account, uint256 amount);
```

### BurnerUpdated

```solidity
event BurnerUpdated(address indexed oldBurner, address indexed newBurner);
```

