pragma solidity ^0.4.0;

contract Vionex {

    uint public constant _totalSupply = 10000000000000000;

    string public constant symbol = "VIOX";
    string public constant name = "Vionex";
    uint8 public constant decimals = 8;

    mapping(address => uint)balances;
    mapping(address => mapping(address => uint)) approved;


    uint supply;


    //ERC20

    function Vionex() {
        balances[msg.sender] = _totalSupply;
    }

    function totalSupply() constant returns (uint totalSupply){
        return supply;
    }

    function balanceOf(address _owner) constant returns (uint balance){
        return balances[_owner];
    }

    function transfer(address _to, uint _value) returns (bool success){

        if(balances[msg.sender]>=_value && _value > 0){

            balances[msg.sender]-= _value;
            balances[_to] += _value;

            // successful transaction
            return true;
        }
        else{
            // failed transaction
            return false;
        }
    }


    function approve(address _spender, uint _value) returns (bool success){

        if(balances[msg.sender]>=_value){
            approved[msg.sender][_spender] = _value;
            return true;
        }

        return false;

    }

    function allowance(address _owner, address _spender) constant returns (uint remaining){

        return approved[_owner][_spender];

    }


    function transferFrom(address _from, address _to, uint _value) returns (bool success){

        if(balances[_from]>=_value &&
            approved[_from][msg.sender]>=_value &&
            _value > 0){


                balances[_from] -= _value;
                approved[_from][msg.sender] -= _value;
                balances[_to] += _value;

                return true;

        }
        else{
            return false;
        }


    }

    // our own
    function mint (uint numberOfCoins){
        balances[msg.sender] += numberOfCoins;
        supply += numberOfCoins;
    }

    function getMyBalance() returns (uint){
        return balances[msg.sender];
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

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
 }
