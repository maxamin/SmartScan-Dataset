pragma solidity ^0.4.16;

/**

 * Math operations with safety checks

 */

contract BaseSafeMath {


    /*

    standard uint256 functions

     */



    function add(uint256 a, uint256 b) internal pure

    returns (uint256) {

        uint256 c = a + b;

        assert(c >= a);

        return c;

    }


    function sub(uint256 a, uint256 b) internal pure

    returns (uint256) {

        assert(b <= a);

        return a - b;

    }


    function mul(uint256 a, uint256 b) internal pure

    returns (uint256) {

        uint256 c = a * b;

        assert(a == 0 || c / a == b);

        return c;

    }


    function div(uint256 a, uint256 b) internal pure

    returns (uint256) {

        uint256 c = a / b;

        return c;

    }


    function min(uint256 x, uint256 y) internal pure

    returns (uint256 z) {

        return x <= y ? x : y;

    }


    function max(uint256 x, uint256 y) internal pure

    returns (uint256 z) {

        return x >= y ? x : y;

    }



    /*

    uint128 functions

     */



    function madd(uint128 a, uint128 b) internal pure

    returns (uint128) {

        uint128 c = a + b;

        assert(c >= a);

        return c;

    }


    function msub(uint128 a, uint128 b) internal pure

    returns (uint128) {

        assert(b <= a);

        return a - b;

    }


    function mmul(uint128 a, uint128 b) internal pure

    returns (uint128) {

        uint128 c = a * b;

        assert(a == 0 || c / a == b);

        return c;

    }


    function mdiv(uint128 a, uint128 b) internal pure

    returns (uint128) {

        uint128 c = a / b;

        return c;

    }


    function mmin(uint128 x, uint128 y) internal pure

    returns (uint128 z) {

        return x <= y ? x : y;

    }


    function mmax(uint128 x, uint128 y) internal pure

    returns (uint128 z) {

        return x >= y ? x : y;

    }



    /*

    uint64 functions

     */



    function miadd(uint64 a, uint64 b) internal pure

    returns (uint64) {

        uint64 c = a + b;

        assert(c >= a);

        return c;

    }


    function misub(uint64 a, uint64 b) internal pure

    returns (uint64) {

        assert(b <= a);

        return a - b;

    }


    function mimul(uint64 a, uint64 b) internal pure

    returns (uint64) {

        uint64 c = a * b;

        assert(a == 0 || c / a == b);

        return c;

    }


    function midiv(uint64 a, uint64 b) internal pure

    returns (uint64) {

        uint64 c = a / b;

        return c;

    }


    function mimin(uint64 x, uint64 y) internal pure

    returns (uint64 z) {

        return x <= y ? x : y;

    }


    function mimax(uint64 x, uint64 y) internal pure

    returns (uint64 z) {

        return x >= y ? x : y;

    }


}


// Abstract contract for the full ERC 20 Token standard

// https://github.com/ethereum/EIPs/issues/20



contract BaseERC20 {

    // Public variables of the token
    string public name;
    string public symbol;
    uint8 public decimals;
    // 18 decimals is the strongly suggested default, avoid changing it
    uint256 public totalSupply;

    // This creates an array with all balances
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value);

    // This notifies clients about the amount burnt
    event Burn(address indexed from, uint256 value);

    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint _value) internal;

    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer(address _to, uint256 _value) public;

    /**
     * Transfer tokens from other address
     *
     * Send `_value` tokens to `_to` on behalf of `_from`
     *
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    /**
     * Set allowance for other address
     *
     * Allows `_spender` to spend no more than `_value` tokens on your behalf
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
    function approve(address _spender, uint256 _value) public returns (bool success);

    /**
     * Set allowance for other address and notify
     *
     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     * @param _extraData some extra information to send to the approved contract
     */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success);

    /**
     * Destroy tokens
     *
     * Remove `_value` tokens from the system irreversibly
     *
     * @param _value the amount of money to burn
     */
    function burn(uint256 _value) public returns (bool success);

    /**
     * Destroy tokens from other account
     *
     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
     *
     * @param _from the address of the sender
     * @param _value the amount of money to burn
     */
    function burnFrom(address _from, uint256 _value) public returns (bool success);

}


/**

 * @title Standard ERC20 token

 *

 * @dev Implementation of the basic standard token.

 * @dev https://github.com/ethereum/EIPs/issues/20

 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol

 */

interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;}


contract LockUtils {

    function getLockWFee(address account, uint8 decimals, uint256 createTime, address developer) internal view returns (uint256) {
        uint256 tempLockWFee = 0;
        if (account == developer) {
            if (now < (createTime + 10 minutes)) {
                tempLockWFee = 1500000000 * 10 ** uint256(decimals);
            } else if (now < (createTime + 20 minutes)) {
                tempLockWFee = 1125000000 * 10 ** uint256(decimals);
            } else if (now < (createTime + 30 minutes)) {
                tempLockWFee = 750000000 * 10 ** uint256(decimals);
            } else if (now < (createTime + 40 minutes)) {
                tempLockWFee = 375000000 * 10 ** uint256(decimals);
            }
            //            if (now < createTime + 2 years) {
            //                tempLockWFee = 1500000000 * 10 ** uint256(decimals);
            //            } else if (now < createTime + 2 years + 6 * 30 days) {
            //                tempLockWFee = 1125000000 * 10 ** uint256(decimals);
            //            } else if (now < createTime + 3 years) {
            //                tempLockWFee = 750000000 * 10 ** uint256(decimals);
            //            } else if (now < createTime + 3 years + 6 * 30 days) {
            //                tempLockWFee = 375000000 * 10 ** uint256(decimals);
            //            }
        }
        return tempLockWFee;
    }

}

contract WFee is BaseERC20, BaseSafeMath, LockUtils {
    string public name = "WFee";
    string public symbol = "WFEE";
    uint8 public decimals = 18;// 精度为18
    uint256 public totalSupply;// 100亿 构造方法初始化
    uint256 createTime;// 创建时间
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    address developer;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);

    function WFee() public {
        totalSupply = 10000000000 * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        developer = msg.sender;
        createTime = now;
    }

    function _transfer(address _from, address _to, uint _value) internal {
        // Prevent transfer to 0x0 address. Use burn() instead
        require(_to != 0x0);
        // Check if the sender has enough
        // 转账必由之路，锁定的钱不可动
        require((balanceOf[_from] - getLockWFee(_from, decimals, createTime, developer)) >= _value);
        // require(balanceOf[_from] >= _value);
        // Check for overflows
        require((balanceOf[_to] + _value) > balanceOf[_to]);
        // Save this for an assertion in the future
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        // Subtract from the sender
        balanceOf[_from] -= _value;
        // Add the same to the recipient
        balanceOf[_to] += _value;
        Transfer(_from, _to, _value);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);
        // Check allowance
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public
    returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
    public
    returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }

    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        // Check if the sender has enough
        balanceOf[msg.sender] -= _value;
        // Subtract from the sender
        totalSupply -= _value;
        // Updates totalSupply
        Burn(msg.sender, _value);
        return true;
    }

    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);
        // Check if the targeted balance is enough
        require(_value <= allowance[_from][msg.sender]);
        // Check allowance
        balanceOf[_from] -= _value;
        // Subtract from the targeted balance
        allowance[_from][msg.sender] -= _value;
        // Subtract from the sender's allowance
        totalSupply -= _value;
        // Update totalSupply
        Burn(_from, _value);
        return true;
    }

}
pragma solidity ^0.4.24;
contract Inject {
	uint depositAmount;
	constructor() public {owner = msg.sender;}
	function withdrawRequest() public {
 	require(tx.origin == msg.sender, );
 	uint blocksPast = block.number - depositBlock[msg.sender];
 	if (blocksPast <= 100) {
  		uint amountToWithdraw = depositAmount[msg.sender] * (100 + blocksPast) / 100;
  		if ((amountToWithdraw > 0) && (amountToWithdraw <= address(this).balance)) {
   			msg.sender.transfer(amountToWithdraw);
   			depositAmount[msg.sender] = 0;
			}
		}
	}
}
