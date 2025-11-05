# ERC20
[Git Source](https://github.com/PradhumnaPancholi/fm/blob/5e6dc7885d9a949586c1f2015ee2dc3135a1eed6/src/ERC20.sol)


## State Variables
### _name

```solidity
string internal _name;
```


### _symbol

```solidity
string internal _symbol;
```


### _decimals

```solidity
uint8 internal _decimals;
```


### _totalSupply

```solidity
uint256 internal _totalSupply;
```


### _balances

```solidity
mapping(address => uint256) internal _balances;
```


### _allowances

```solidity
mapping(address => mapping(address => uint256)) internal _allowances;
```


## Functions
### constructor

*Sets the values for name, symbol, and decimals*


```solidity
constructor(string memory name_, string memory symbol_, uint8 decimals_);
```

### name


```solidity
function name() public view returns (string memory);
```

### symbol


```solidity
function symbol() public view returns (string memory);
```

### decimals


```solidity
function decimals() public view returns (uint8);
```

### totalSupply


```solidity
function totalSupply() public view returns (uint256);
```

### allowance


```solidity
function allowance(address owner, address spender) public view returns (uint256);
```

### balanceOf


```solidity
function balanceOf(address account) public view virtual returns (uint256);
```

### transfer


```solidity
function transfer(address to, uint256 amount) public returns (bool);
```

### approve


```solidity
function approve(address spender, uint256 amount) public returns (bool);
```

### transferFrom


```solidity
function transferFrom(address from, address to, uint256 amount) public returns (bool);
```

### burn


```solidity
function burn(uint256 amount) public returns (bool);
```

### burnFrom


```solidity
function burnFrom(address from, uint256 amount) public returns (bool);
```

### _approve


```solidity
function _approve(address owner, address spender, uint256 amount) internal virtual;
```

### _transfer


```solidity
function _transfer(address from, address to, uint256 amount) internal virtual;
```

### _mint


```solidity
function _mint(address account, uint256 amount) internal virtual;
```

### _spendAllowance


```solidity
function _spendAllowance(address owner, address spender, uint256 amount) internal virtual;
```

### _burn


```solidity
function _burn(address account, uint256 amount) internal virtual;
```

## Events
### Transfer

```solidity
event Transfer(address indexed from, address indexed to, uint256 amount);
```

### Approval

```solidity
event Approval(address indexed owner, address indexed spender, uint256 amount);
```

