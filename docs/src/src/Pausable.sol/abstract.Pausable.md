# Pausable
[Git Source](https://github.com/PradhumnaPancholi/fm/blob/5e6dc7885d9a949586c1f2015ee2dc3135a1eed6/src/Pausable.sol)

**Inherits:**
[Ownable](/src/Ownable.sol/abstract.Ownable.md)


## State Variables
### _paused

```solidity
bool internal _paused = false;
```


### _pauser

```solidity
address internal _pauser;
```


## Functions
### constructor


```solidity
constructor();
```

### pauser


```solidity
function pauser() public view returns (address);
```

### onlyPauser


```solidity
modifier onlyPauser();
```

### whenPaused


```solidity
modifier whenPaused();
```

### whenNotPaused


```solidity
modifier whenNotPaused();
```

### pause


```solidity
function pause() public onlyPauser;
```

### unpause


```solidity
function unpause() public onlyPauser;
```

### setPauser


```solidity
function setPauser(address newPauser) public onlyOwner;
```

## Events
### Paused

```solidity
event Paused(address indexed pauser);
```

### UnPaused

```solidity
event UnPaused(address indexed pauser);
```

### PauserUpdated

```solidity
event PauserUpdated(address indexed oldPauser, address indexed newPauser);
```

