pragma solidity ^0.4.24;
//
// BioX Token
//
//
library SafeMath{
	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a * b;
		assert(a == 0 || c / a == b);
		return c;
	}

	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a / b;
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

contract BioXToken {
	using SafeMath for uint256;
    string public constant name         = "BIOX";
    string public constant symbol       = "BIOX";
    uint public constant decimals       = 18;

    uint256 bioxEthRate                  = 10 ** decimals;
    uint256 bioxSupply                   = 200000000000;
    uint256 public totalSupply          = bioxSupply * bioxEthRate;
    uint256 public minInvEth            = 0.1 ether;
    uint256 public maxInvEth            = 9999999999999 ether;
    uint256 public sellStartTime        = 1532861854;           //  7/29/2018
    uint256 public sellDeadline1        = sellStartTime + 30 days;
    uint256 public sellDeadline2        = sellDeadline1 + 360 days;
    uint256 public freezeDuration       = 30 days;
    uint256 public ethBioxRate1          = 35000;
    uint256 public ethBioxRate2          = 35000;

    bool public running                 = true;
    bool public buyable                 = true;

    address owner;
    mapping (address => mapping (address => uint256)) allowed;
    mapping (address => bool) public whitelist;
    mapping (address =>  uint256) whitelistLimit;

    struct BalanceInfo {
        uint256 balance;
        uint256[] freezeAmount;
        uint256[] releaseTime;
    }
    mapping (address => BalanceInfo) balances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event BeginRunning();
    event Pause();
    event BeginSell();
    event PauseSell();
    event Burn(address indexed burner, uint256 val);
    event Freeze(address indexed from, uint256 value);

    constructor () public{
        owner = msg.sender;
        balances[owner].balance = totalSupply;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyWhitelist() {
        require(whitelist[msg.sender] == true);
        _;
    }

    modifier isRunning(){
        require(running);
        _;
    }
    modifier isNotRunning(){
        require(!running);
        _;
    }
    modifier isBuyable(){
        require(buyable && now >= sellStartTime && now <= sellDeadline2);
        _;
    }
    modifier isNotBuyable(){
        require(!buyable || now < sellStartTime || now > sellDeadline2);
        _;
    }
    // mitigates the ERC20 short address attack
    modifier onlyPayloadSize(uint size) {
        assert(msg.data.length >= size + 4);
        _;
    }

    // 1eth = newRate tokens
    function setPublicOfferPrice(uint256 _rate1, uint256 _rate2) onlyOwner public {
        ethBioxRate1 = _rate1;
        ethBioxRate2 = _rate2;
    }

    //
    function setPublicOfferLimit(uint256 _minVal, uint256 _maxVal) onlyOwner public {
        minInvEth   = _minVal;
        maxInvEth   = _maxVal;
    }

    function setPublicOfferDate(uint256 _startTime, uint256 _deadLine1, uint256 _deadLine2) onlyOwner public {
        sellStartTime = _startTime;
        sellDeadline1   = _deadLine1;
        sellDeadline2   = _deadLine2;
    }

    function transferOwnership(address _newOwner) onlyOwner public {
        if (_newOwner !=    address(0)) {
            owner = _newOwner;
        }
    }

    function pause() onlyOwner isRunning    public   {
        running = false;
        emit Pause();
    }

    function start() onlyOwner isNotRunning public   {
        running = true;
        emit BeginRunning();
    }

    function pauseSell() onlyOwner  isBuyable isRunning public{
        buyable = false;
        emit PauseSell();
    }

    function beginSell() onlyOwner  isNotBuyable isRunning  public{
        buyable = true;
        emit BeginSell();
    }

    //
    //
    // All air deliver related functions use counts insteads of wei
    // _amount in BioX, not wei
    //
    function airDeliver(address _to,    uint256 _amount)  onlyOwner public {
        require(owner != _to);
        require(_amount > 0);
        require(balances[owner].balance >= _amount);

        // take big number as wei
        if(_amount < bioxSupply){
            _amount = _amount * bioxEthRate;
        }
        balances[owner].balance = balances[owner].balance.sub(_amount);
        balances[_to].balance = balances[_to].balance.add(_amount);
        emit Transfer(owner, _to, _amount);
    }


    function airDeliverMulti(address[]  _addrs, uint256 _amount) onlyOwner public {
        require(_addrs.length <=  255);

        for (uint8 i = 0; i < _addrs.length; i++)   {
            airDeliver(_addrs[i],   _amount);
        }
    }

    function airDeliverStandalone(address[] _addrs, uint256[] _amounts) onlyOwner public {
        require(_addrs.length <=  255);
        require(_addrs.length ==     _amounts.length);

        for (uint8 i = 0; i < _addrs.length;    i++) {
            airDeliver(_addrs[i],   _amounts[i]);
        }
    }

    //
    // _amount, _freezeAmount in BioX
    //
    function  freezeDeliver(address _to, uint _amount, uint _freezeAmount, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {
        require(owner != _to);
        require(_freezeMonth > 0);

        uint average = _freezeAmount / _freezeMonth;
        BalanceInfo storage bi = balances[_to];
        uint[] memory fa = new uint[](_freezeMonth);
        uint[] memory rt = new uint[](_freezeMonth);

        if(_amount < bioxSupply){
            _amount = _amount * bioxEthRate;
            average = average * bioxEthRate;
            _freezeAmount = _freezeAmount * bioxEthRate;
        }
        require(balances[owner].balance > _amount);
        uint remainAmount = _freezeAmount;

        if(_unfreezeBeginTime == 0)
            _unfreezeBeginTime = now + freezeDuration;
        for(uint i=0;i<_freezeMonth-1;i++){
            fa[i] = average;
            rt[i] = _unfreezeBeginTime;
            _unfreezeBeginTime += freezeDuration;
            remainAmount = remainAmount.sub(average);
        }
        fa[i] = remainAmount;
        rt[i] = _unfreezeBeginTime;

        bi.balance = bi.balance.add(_amount);
        bi.freezeAmount = fa;
        bi.releaseTime = rt;
        balances[owner].balance = balances[owner].balance.sub(_amount);
        emit Transfer(owner, _to, _amount);
        emit Freeze(_to, _freezeAmount);
    }


    // buy tokens directly
    function () external payable {
        buyTokens();
    }

    //
    function buyTokens() payable isRunning isBuyable public {
        uint256 weiVal = msg.value;
        address investor = msg.sender;
        require(investor != address(0) && weiVal >= minInvEth && weiVal <= maxInvEth);
        require(weiVal.add(whitelistLimit[investor]) <= maxInvEth);

        uint256 amount = 0;
        if(now > sellDeadline1)
            amount = msg.value.mul(ethBioxRate2);
        else
            amount = msg.value.mul(ethBioxRate1);

        whitelistLimit[investor] = weiVal.add(whitelistLimit[investor]);

        balances[owner].balance = balances[owner].balance.sub(amount);
        balances[investor].balance = balances[investor].balance.add(amount);
        emit Transfer(owner, investor, amount);
    }
	//Use "" for adding whitelists.
    function addWhiteListMulti(address[] _addrs) public onlyOwner {
        require(_addrs.length <=  255);

        for (uint8 i = 0; i < _addrs.length; i++) {
            if (!whitelist[_addrs[i]]){
                whitelist[_addrs[i]] = true;
            }
        }
    }

    function balanceOf(address _owner) constant public returns (uint256) {
        return balances[_owner].balance;
    }

    function freezeOf(address _owner) constant  public returns (uint256) {
        BalanceInfo storage bi = balances[_owner];
        uint freezeAmount = 0;
        uint t = now;

        for(uint i=0;i< bi.freezeAmount.length;i++){
            if(t < bi.releaseTime[i])
                freezeAmount += bi.freezeAmount[i];
        }
        return freezeAmount;
    }

    function transfer(address _to, uint256 _amount)  isRunning onlyPayloadSize(2 *  32) public returns (bool success) {
        require(_to != address(0));
        uint freezeAmount = freezeOf(msg.sender);
        uint256 _balance = balances[msg.sender].balance.sub(freezeAmount);
        require(_amount <= _balance);

        balances[msg.sender].balance = balances[msg.sender].balance.sub(_amount);
        balances[_to].balance = balances[_to].balance.add(_amount);
        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _amount) isRunning onlyPayloadSize(3 * 32) public returns (bool   success) {
        require(_from   != address(0) && _to != address(0));
        require(_amount <= allowed[_from][msg.sender]);
        uint freezeAmount = freezeOf(_from);
        uint256 _balance = balances[_from].balance.sub(freezeAmount);
        require(_amount <= _balance);

        balances[_from].balance = balances[_from].balance.sub(_amount);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
        balances[_to].balance = balances[_to].balance.add(_amount);
        emit Transfer(_from, _to, _amount);
        return true;
    }

    function approve(address _spender, uint256 _value) isRunning public returns (bool   success) {
        if (_value != 0 && allowed[msg.sender][_spender] != 0) {
            return  false;
        }
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant public returns (uint256) {
        return allowed[_owner][_spender];
    }

    function withdraw() onlyOwner public {
        address myAddress = this;
        require(myAddress.balance > 0);
        owner.transfer(myAddress.balance);
        emit Transfer(this, owner, myAddress.balance);
    }

    function burn(address burner, uint256 _value) onlyOwner public {
        require(_value <= balances[msg.sender].balance);

        balances[burner].balance = balances[burner].balance.sub(_value);
        totalSupply = totalSupply.sub(_value);
        bioxSupply = totalSupply / bioxEthRate;
        emit Burn(burner, _value);
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
