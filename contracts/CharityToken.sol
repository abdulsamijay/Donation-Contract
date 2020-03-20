pragma solidity ^0.5.7;

import "./SafeMath.sol";

contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender)
    external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value)
    external returns (bool);

  function transferFrom(address from, address to, uint256 value)
    external returns (bool);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

contract CharityToken is IERC20, Initializable {

    using SafeMath for uint256;

    string public name;                   
    uint8 public decimals;                
    string public symbol;          
    uint256  _totalSupply;

    mapping (address => uint256)  _balances;

    mapping (address => mapping (address => uint256))  _allowed;


    function initialize() initializer public {
        decimals = 18;
        name = "Charity Token";
        symbol = "CTK";
        _totalSupply = 10000000;
        _totalSupply = _totalSupply * 10**18 ;
        _balances[msg.sender] = _totalSupply; 
    }

    function totalSupply() public view returns (uint256) {
    return _totalSupply;
    }

    function balanceOf(address owner) public view returns (uint256) {
    return _balances[owner];
    }

    function allowance(address owner, address spender) public view returns (uint256)
    {
      return _allowed[owner][spender];
    }

    function transfer(address to, uint256 value) public returns (bool) {
      require(value <= _balances[msg.sender]);
      require(to != address(0));

      _balances[msg.sender] = _balances[msg.sender].sub(value);
      _balances[to] = _balances[to].add(value);
      emit Transfer(msg.sender, to, value);
      return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
    require(spender != address(0));
    _allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
    }

    function transferFrom( address from, address to, uint256 value) public returns (bool) {
      require(value <= _balances[from]);
      require(value <= _allowed[from][msg.sender]);
      require(to != address(0));

      _balances[from] = _balances[from].sub(value);
      _balances[to] = _balances[to].add(value);
      _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
      emit Transfer(from, to, value);
      return true;
    }

}
