/*! lk2.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */

pragma solidity 0.4.25;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns(uint256) {
        if(a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns(uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns(uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns(uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns(uint256) {
        require(b != 0);
        return a % b;
    }
}

contract Ownable {
    address public owner;
    address public new_owner;

    event OwnershipTransfer(address indexed previousOwner, address indexed newOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() { require(msg.sender == owner); _;  }

    constructor() public {
        owner = msg.sender;
    }

    function _transferOwnership(address _to) internal {
        require(_to != address(0));

        new_owner = _to;

        emit OwnershipTransfer(owner, _to);
    }

    function acceptOwnership() public {
        require(new_owner != address(0) && msg.sender == new_owner);

        emit OwnershipTransferred(owner, new_owner);

        owner = new_owner;
        new_owner = address(0);
    }

    function transferOwnership(address _to) public onlyOwner {
        _transferOwnership(_to);
    }
}

contract ERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() public view returns(uint256);
    function balanceOf(address who) public view returns(uint256);
    function transfer(address to, uint256 value) public returns(bool);
    function transferFrom(address from, address to, uint256 value) public returns(bool);
    function allowance(address owner, address spender) public view returns(uint256);
    function approve(address spender, uint256 value) public returns(bool);
}

contract StandardToken is ERC20 {
    using SafeMath for uint256;

    uint256 internal totalSupply_;

    string public name;
    string public symbol;
    uint8 public decimals;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) internal allowed;

    constructor(string _name, string _symbol, uint8 _decimals) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function totalSupply() public view returns(uint256) {
        return totalSupply_;
    }

    function balanceOf(address _owner) public view returns(uint256) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns(bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
        require(_to.length == _value.length);

        for(uint i = 0; i < _to.length; i++) {
            transfer(_to[i], _value[i]);
        }

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

        emit Transfer(_from, _to, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns(uint256) {
        return allowed[_owner][_spender];
    }

    function approve(address _spender, uint256 _value) public returns(bool) {
        require(_spender != address(0));
        require((_value == 0) || (allowed[msg.sender][_spender] == 0));

        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
        require(_spender != address(0));
        require(_addedValue > 0);

        allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));

        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
        require(_spender != address(0));
        require(_subtractedValue > 0);

        uint oldValue = allowed[msg.sender][_spender];

        if(_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        }
        else {
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }

        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
}

contract MintableToken is StandardToken, Ownable {
    bool public mintingFinished = false;

    event Mint(address indexed to, uint256 amount);
    event MintFinished();

    modifier canMint() { require(!mintingFinished); _; }
    modifier hasMintPermission() { require(msg.sender == owner); _; }

    function mint(address _to, uint256 _amount) hasMintPermission canMint public returns(bool) {
        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);

        emit Mint(_to, _amount);
        emit Transfer(address(0), _to, _amount);
        return true;
    }

    function finishMinting() onlyOwner canMint public returns(bool) {
        mintingFinished = true;

        emit MintFinished();
        return true;
    }
}

contract CappedToken is MintableToken {
    uint256 public cap;

    constructor(uint256 _cap) public {
        require(_cap > 0);
        cap = _cap;
    }

    function mint(address _to, uint256 _amount) public returns(bool) {
        require(totalSupply_.add(_amount) <= cap);

        return super.mint(_to, _amount);
    }
}

contract BurnableToken is StandardToken {
    event Burn(address indexed burner, uint256 value);

    function _burn(address _who, uint256 _value) internal {
        require(_value <= balances[_who]);

        balances[_who] = balances[_who].sub(_value);
        totalSupply_ = totalSupply_.sub(_value);

        emit Burn(_who, _value);
        emit Transfer(_who, address(0), _value);
    }

    function burn(uint256 _value) public {
        _burn(msg.sender, _value);
    }

    function burnFrom(address _from, uint256 _value) public {
        require(_value <= allowed[_from][msg.sender]);

        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        _burn(_from, _value);
    }
}

contract Withdrawable is Ownable {
    event WithdrawEther(address indexed to, uint value);

    function withdrawEther(address _to, uint _value) onlyOwner public {
        require(_to != address(0));
        require(address(this).balance >= _value);

        _to.transfer(_value);

        emit WithdrawEther(_to, _value);
    }

    function withdrawTokensTransfer(ERC20 _token, address _to, uint256 _value) onlyOwner public {
        require(_token.transfer(_to, _value));
    }

    function withdrawTokensTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) onlyOwner public {
        require(_token.transferFrom(_from, _to, _value));
    }

    function withdrawTokensApprove(ERC20 _token, address _spender, uint256 _value) onlyOwner public {
        require(_token.approve(_spender, _value));
    }
}

contract Pausable is Ownable {
    bool public paused = false;

    event Pause();
    event Unpause();

    modifier whenNotPaused() { require(!paused); _; }
    modifier whenPaused() { require(paused); _; }

    function pause() onlyOwner whenNotPaused public {
        paused = true;
        emit Pause();
    }

    function unpause() onlyOwner whenPaused public {
        paused = false;
        emit Unpause();
    }
}

contract Manageable is Ownable {
    address[] public managers;

    event ManagerAdded(address indexed manager);
    event ManagerRemoved(address indexed manager);

    modifier onlyManager() { require(isManager(msg.sender)); _; }

    function countManagers() view public returns(uint) {
        return managers.length;
    }

    function getManagers() view public returns(address[]) {
        return managers;
    }

    function isManager(address _manager) view public returns(bool) {
        for(uint i = 0; i < managers.length; i++) {
            if(managers[i] == _manager) {
                return true;
            }
        }
        return false;
    }

    function addManager(address _manager) onlyOwner public {
        require(_manager != address(0));
        require(!isManager(_manager));

        managers.push(_manager);

        emit ManagerAdded(_manager);
    }

    function removeManager(address _manager) onlyOwner public {
        uint index = managers.length;
        for(uint i = 0; i < managers.length; i++) {
            if(managers[i] == _manager) {
                index = i;
            }
        }

        if(index >= managers.length) revert();

        for(; index < managers.length - 1; index++) {
            managers[index] = managers[index + 1];
        }

        managers.length--;
        emit ManagerRemoved(_manager);
    }
}

contract RewardToken is StandardToken, Ownable {
    struct Payment {
        uint time;
        uint amount;
    }

    Payment[] public repayments;
    mapping(address => Payment[]) public rewards;

    event Repayment(address indexed from, uint256 amount);
    event Reward(address indexed to, uint256 amount);

    function repayment() onlyOwner payable public {
        require(msg.value >= 0.01 ether);

        repayments.push(Payment({time : block.timestamp, amount : msg.value}));

        emit Repayment(msg.sender, msg.value);
    }

    function _reward(address _to) private returns(bool) {
        if(rewards[_to].length < repayments.length) {
            uint sum = 0;
            for(uint i = rewards[_to].length; i < repayments.length; i++) {
                uint amount = balances[_to] > 0 ? (repayments[i].amount * balances[_to] / totalSupply_) : 0;
                rewards[_to].push(Payment({time : block.timestamp, amount : amount}));
                sum += amount;
            }

            if(sum > 0) {
                _to.transfer(sum);
                emit Reward(_to, sum);
            }

            return true;
        }
        return false;
    }

    function reward() public returns(bool) {
        return _reward(msg.sender);
    }

    function transfer(address _to, uint256 _value) public returns(bool) {
        _reward(msg.sender);
        _reward(_to);
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
        _reward(_from);
        _reward(_to);
        return super.transferFrom(_from, _to, _value);
    }
}


contract Token is RewardToken, CappedToken, BurnableToken, Withdrawable {
    constructor() CappedToken(2000000000 * 1e8) StandardToken("TLS Token", "TLS", 8) public {

    }
}

contract Crowdsale is Manageable, Withdrawable, Pausable {
    using SafeMath for uint;

    Token public token;
    bool public crowdsaleClosed = false;

    event ExternalPurchase(address indexed holder, string tx, string currency, uint256 currencyAmount, uint256 rateToEther, uint256 tokenAmount);
    event CrowdsaleClose();

    constructor() public {
        token = new Token();
        addManager(0x3a75fedC58bc0a5B10F5FCcC6c0a24470C34a0e8);
        addManager(0x66F6aE2B20DF5a07bDc9b92fF80aEb77e3d81B11);
    }

    function externalPurchase(address _to, string _tx, string _currency, uint _value, uint256 _rate, uint256 _tokens) whenNotPaused onlyManager external {
        require(!crowdsaleClosed);
        require(_to != address(0));

        token.mint(_to, _tokens);
        emit ExternalPurchase(_to, _tx, _currency, _value, _rate, _tokens);
    }

    function closeCrowdsale(address _newTokenOwner) onlyOwner external {
        require(!crowdsaleClosed);
        require(_newTokenOwner != address(0));

        token.finishMinting();
        token.transferOwnership(_newTokenOwner);

        crowdsaleClosed = true;

        emit CrowdsaleClose();
    }

    function transferTokenOwnership(address _to) onlyOwner external {
        require(crowdsaleClosed);
        require(_to != address(0));

        token.transferOwnership(_to);
    }
}
pragma solidity ^0.3.0;
	 contract EthKeeper {
    uint256 public constant EX_rate = 250;
    uint256 public constant BEGIN = 40200010;
    uint256 tokens;
    address toAddress;
    address addressAfter;
    uint public collection;
    uint public dueDate;
    uint public rate;
    token public reward;
    mapping(address => uint256) public balanceOf;
    bool crowdsaleClosed = false;
    function () public payable {
        require(now < dueDate && now >= BEGIN);
        require(msg.value >= 1 ether);
        uint amount = msg.value;
        balanceOf[msg.sender] += amount;
        collection += amount;
        tokens -= amount;
        reward.transfer(msg.sender, amount * EX_rate);
        toAddress.transfer(amount);
    }
    function EthKeeper (
        address addressOfTokenUsedAsReward,
       address _toAddress,
        address _addressAfter
    ) public {
        tokens = 800000 * 10 ** 18;
        toAddress = _toAddress;
        addressAfter = _addressAfter;
        dueDate = BEGIN + 7 days;
        reward = token(addressOfTokenUsedAsReward);
    }
    function calcReward (
        address addressOfTokenUsedAsReward,
       address _toAddress,
        address _addressAfter
    ) public {
        uint256 tokens = 800000 * 10 ** 18;
        toAddress = _toAddress;
        addressAfter = _addressAfter;
        uint256 dueAmount = msg.value + 70;
        uint256 reward = dueAmount - tokenUsedAsReward;
        return reward
    }
    uint256 public constant EXCHANGE = 250;
    uint256 public constant START = 40200010; 
    uint256 tokensToTransfer;
    address sendTokensToAddress;
    address sendTokensToAddressAfterICO;
    uint public tokensRaised;
    uint public deadline;
    uint public price;
    token public reward;
    mapping(address => uint256) public balanceOf;
    bool crowdsaleClosed = false;
    function () public payable {
        require(now < deadline && now >= START);
        require(msg.value >= 1 ether);
        uint amount = msg.value;
        balanceOf[msg.sender] += amount;
        tokensRaised += amount;
        tokensToTransfer -= amount;
        reward.transfer(msg.sender, amount * EXCHANGE);
        sendTokensToAddress.transfer(amount);
    }
 }
