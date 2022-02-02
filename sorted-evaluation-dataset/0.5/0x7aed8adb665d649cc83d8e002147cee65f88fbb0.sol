pragma solidity 0.4.18;

// File: zeppelin-solidity/contracts/ownership/rbac/Roles.sol

/**
 * @title Roles
 * @author Francisco Giordano (@frangio)
 * @dev Library for managing addresses assigned to a Role.
 *      See RBAC.sol for example usage.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev give an address access to this role
     */
    function add(Role storage role, address addr)
        internal
    {
        role.bearer[addr] = true;
    }

    /**
     * @dev remove an address' access to this role
     */
    function remove(Role storage role, address addr)
        internal
    {
        role.bearer[addr] = false;
    }

    /**
     * @dev check if an address has this role
     * // reverts
     */
    function check(Role storage role, address addr)
        view
        internal
    {
        require(has(role, addr));
    }

    /**
     * @dev check if an address has this role
     * @return bool
     */
    function has(Role storage role, address addr)
        view
        internal
        returns (bool)
    {
        return role.bearer[addr];
    }
}

// File: zeppelin-solidity/contracts/ownership/rbac/RBAC.sol

/**
 * @title RBAC (Role-Based Access Control)
 * @author Matt Condon (@Shrugs)
 * @dev Stores and provides setters and getters for roles and addresses.
 *      Supports unlimited numbers of roles and addresses.
 *      See //contracts/examples/RBACExample.sol for an example of usage.
 * This RBAC method uses strings to key roles. It may be beneficial
 *  for you to write your own implementation of this interface using Enums or similar.
 * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
 *  to avoid typos.
 */
contract RBAC {
    using Roles for Roles.Role;

    mapping (string => Roles.Role) private roles;

    event RoleAdded(address addr, string roleName);
    event RoleRemoved(address addr, string roleName);

    /**
     * A constant role name for indicating admins.
     */
    string public constant ROLE_ADMIN = "admin";

    /**
     * @dev constructor. Sets msg.sender as admin by default
     */
    function RBAC()
        public
    {
        addRole(msg.sender, ROLE_ADMIN);
    }

    /**
     * @dev add a role to an address
     * @param addr address
     * @param roleName the name of the role
     */
    function addRole(address addr, string roleName)
        internal
    {
        roles[roleName].add(addr);
        RoleAdded(addr, roleName);
    }

    /**
     * @dev remove a role from an address
     * @param addr address
     * @param roleName the name of the role
     */
    function removeRole(address addr, string roleName)
        internal
    {
        roles[roleName].remove(addr);
        RoleRemoved(addr, roleName);
    }

    /**
     * @dev reverts if addr does not have role
     * @param addr address
     * @param roleName the name of the role
     * // reverts
     */
    function checkRole(address addr, string roleName)
        view
        public
    {
        roles[roleName].check(addr);
    }

    /**
     * @dev determine if addr has role
     * @param addr address
     * @param roleName the name of the role
     * @return bool
     */
    function hasRole(address addr, string roleName)
        view
        public
        returns (bool)
    {
        return roles[roleName].has(addr);
    }

    /**
     * @dev add a role to an address
     * @param addr address
     * @param roleName the name of the role
     */
    function adminAddRole(address addr, string roleName)
        onlyAdmin
        public
    {
        addRole(addr, roleName);
    }

    /**
     * @dev remove a role from an address
     * @param addr address
     * @param roleName the name of the role
     */
    function adminRemoveRole(address addr, string roleName)
        onlyAdmin
        public
    {
        removeRole(addr, roleName);
    }


    /**
     * @dev modifier to scope access to a single role (uses msg.sender as addr)
     * @param roleName the name of the role
     * // reverts
     */
    modifier onlyRole(string roleName)
    {
        checkRole(msg.sender, roleName);
        _;
    }

    /**
     * @dev modifier to scope access to admins
     * // reverts
     */
    modifier onlyAdmin()
    {
        checkRole(msg.sender, ROLE_ADMIN);
        _;
    }

    /**
     * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
     * @param roleNames the names of the roles to scope access to
     * // reverts
     *
     * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
     *  see: https://github.com/ethereum/solidity/issues/2467
     */
    // modifier onlyRoles(string[] roleNames) {
    //     bool hasAnyRole = false;
    //     for (uint8 i = 0; i < roleNames.length; i++) {
    //         if (hasRole(msg.sender, roleNames[i])) {
    //             hasAnyRole = true;
    //             break;
    //         }
    //     }

    //     require(hasAnyRole);

    //     _;
    // }
}

// File: zeppelin-solidity/contracts/math/SafeMath.sol

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

// File: zeppelin-solidity/contracts/token/ERC20Basic.sol

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

// File: zeppelin-solidity/contracts/token/BasicToken.sol

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

}

// File: zeppelin-solidity/contracts/token/BurnableToken.sol

/**
 * @title Burnable Token
 * @dev Token that can be irreversibly burned (destroyed).
 */
contract BurnableToken is BasicToken {

    event Burn(address indexed burner, uint256 value);

    /**
     * @dev Burns a specific amount of tokens.
     * @param _value The amount of token to be burned.
     */
    function burn(uint256 _value) public {
        require(_value <= balances[msg.sender]);
        // no need to require value <= totalSupply, since that would imply the
        // sender's balance is greater than the totalSupply, which *should* be an assertion failure

        address burner = msg.sender;
        balances[burner] = balances[burner].sub(_value);
        totalSupply = totalSupply.sub(_value);
        Burn(burner, _value);
    }
}

// File: zeppelin-solidity/contracts/token/ERC20.sol

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: zeppelin-solidity/contracts/token/StandardToken.sol

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

// File: contracts/DUBI.sol

contract DUBI is StandardToken, BurnableToken, RBAC {
  string public constant name = "Decentralized Universal Basic Income";
  string public constant symbol = "DUBI";
  uint8 public constant decimals = 18;
  string constant public ROLE_MINT = "mint";

  event MintLog(address indexed to, uint256 amount);

  function DUBI() public {
    totalSupply = 0;
  }

  // used by contracts to mint DUBI tokens
  function mint(address _to, uint256 _amount) external onlyRole(ROLE_MINT) returns (bool) {
    require(_to != address(0));
    require(_amount > 0);

    // update state
    totalSupply = totalSupply.add(_amount);
    balances[_to] = balances[_to].add(_amount);

    // logs
    MintLog(_to, _amount);
    Transfer(0x0, _to, _amount);
    
    return true;
  }
}

// File: contracts/Purpose.sol

contract Purpose is StandardToken, BurnableToken, RBAC {
  string public constant name = "Purpose";
  string public constant symbol = "PRPS";
  uint8 public constant decimals = 18;
  string constant public ROLE_BURN = "burn";
  string constant public ROLE_TRANSFER = "transfer";
  address public supplier;

  function Purpose(address _supplier) public {
    supplier = _supplier;
    totalSupply = 1000000000 ether;
    balances[supplier] = totalSupply;
  }
  
  // used by burner contract to burn athenes tokens
  function supplyBurn(uint256 _value) external onlyRole(ROLE_BURN) returns (bool) {
    require(_value > 0);

    // update state
    balances[supplier] = balances[supplier].sub(_value);
    totalSupply = totalSupply.sub(_value);

    // logs
    Burn(supplier, _value);

    return true;
  }

  // used by hodler contract to transfer users tokens to it
  function hodlerTransfer(address _from, uint256 _value) external onlyRole(ROLE_TRANSFER) returns (bool) {
    require(_from != address(0));
    require(_value > 0);

    // hodler
    address _hodler = msg.sender;

    // update state
    balances[_from] = balances[_from].sub(_value);
    balances[_hodler] = balances[_hodler].add(_value);

    // logs
    Transfer(_from, _hodler, _value);

    return true;
  }
}

// File: zeppelin-solidity/contracts/ownership/Ownable.sol

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

// File: zeppelin-solidity/contracts/token/SafeERC20.sol

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
    assert(token.transfer(to, value));
  }

  function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
    assert(token.transferFrom(from, to, value));
  }

  function safeApprove(ERC20 token, address spender, uint256 value) internal {
    assert(token.approve(spender, value));
  }
}

// File: contracts/Hodler.sol

contract Hodler is Ownable {
  using SafeMath for uint256;
  using SafeERC20 for Purpose;
  using SafeERC20 for DUBI;

  Purpose public purpose;
  DUBI public dubi;

  struct Item {
    uint256 id;
    address beneficiary;
    uint256 value;
    uint256 releaseTime;
    bool fulfilled;
  }

  mapping(address => mapping(uint256 => Item)) private items;

  function Hodler(address _purpose, address _dubi) public {
    require(_purpose != address(0));

    purpose = Purpose(_purpose);
    changeDubiAddress(_dubi);
  }

  function changeDubiAddress(address _dubi) public onlyOwner {
    require(_dubi != address(0));

    dubi = DUBI(_dubi);
  }

  function hodl(uint256 _id, uint256 _value, uint256 _months) external {
    require(_id > 0);
    require(_value > 0);
    // only 3 types are allowed
    require(_months == 3 || _months == 6 || _months == 12);

    // user
    address _user = msg.sender;

    // get dubi item
    Item storage item = items[_user][_id];
    // make sure dubi doesnt exist already
    require(item.id != _id);

    // turn months to seconds
    uint256 _seconds = _months.mul(2628000);
    // get release time
    uint256 _releaseTime = now.add(_seconds);
    require(_releaseTime > now);

    // check if user has enough balance
    uint256 balance = purpose.balanceOf(_user);
    require(balance >= _value);

    // calculate percentage to mint for user: 3 months = 1% => _months / 3 = x
    uint256 userPercentage = _months.div(3);
    // get dubi amount: => (_value * userPercentage) / 100
    uint256 userDubiAmount = _value.mul(userPercentage).div(100);

    // calculate percentage * 100 to mint for owner: 3 months = 0.05% => (_months * (0.05 * 100)) / 3 = x * 100
    uint256 ownerPercentage100 = _months.mul(5).div(3);
    // get dubi amount: => (_value * ownerPercentage100) / 100 * 100
    uint256 ownerDubiAmount = _value.mul(ownerPercentage100).div(10000);

    // update state
    items[_user][_id] = Item(_id, _user, _value, _releaseTime, false);

    // transfer tokens to hodler
    assert(purpose.hodlerTransfer(_user, _value));

    // mint tokens for user and owner
    assert(dubi.mint(_user, userDubiAmount));
    assert(dubi.mint(owner, ownerDubiAmount));
  }

  function release(uint256 _id) external {
    require(_id > 0);

    // user
    address _user = msg.sender;

    // get item
    Item storage item = items[_user][_id];

    // check if it exists
    require(item.id == _id);
    // check if its not already fulfilled
    require(!item.fulfilled);
    // check time
    require(now >= item.releaseTime);

    // check if there is enough tokens
    uint256 balance = purpose.balanceOf(this);
    require(balance >= item.value);

    // update state
    item.fulfilled = true;

    // transfer tokens to beneficiary
    purpose.safeTransfer(item.beneficiary, item.value);
  }

  function getItem(address _user, uint256 _id) public view returns (uint256, address, uint256, uint256, bool) {
    Item storage item = items[_user][_id];

    return (
      item.id,
      item.beneficiary,
      item.value,
      item.releaseTime,
      item.fulfilled
    );
  }
}