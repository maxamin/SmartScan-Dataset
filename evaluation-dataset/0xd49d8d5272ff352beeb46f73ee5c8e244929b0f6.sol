pragma solidity ^0.4.19;

interface UNetworkToken {
    function transfer(address _to, uint256 _value) public;
}


contract AirDrop {

	UNetworkToken UUU;
	address public owner;

	address[] public recipients = [0xF2faAf764a1242f9A3aEF4B16c51a94866e72736, 0x8b3cca78ef51036e79d36fe2c347063718be0f3a, 0xC936d7d520797E709769Be29Bb7C37416E22Cc1a, 0x95168D0562546B2cdf2f7E9E4d495F0104E6913E, 0x5cba194c8195E3eD3Af90fD966f7e85D271E327e, 0x092f1720a51efdbfc931f6feb45eafeae69a0e24, 0x5f69e771bbd486ab44ff2cd8f00da487506fc1c2, 0xa6870754C96b0c910ceBB672948e7D950e1881df, 0x5f69e771bbd486ab44ff2cd8f00da487506fc1c2, 0xB536f4a39601f8Aa1181788dE9E6512b6bF84b2D, 0x4f19a1323d162f43fb711e8940e38c1b498ab4ea, 0xfBC359D242d3932874fcf56fa9d9441deA253519, 0x93a6ddf4340247a1d63ebc7435740788da735ee3, 0xfA712645B206B5c98E51e73a3A47fde9D0a2790c, 0xdD52a6Cf8184FD79F87d4Cc4517ED81880158f89, 0x60005b2c5e07418454E0abbdF15d4bDF89c223F5, 0x9897f36A653a6120dd873af6F1Eaebc9ea8EE102, 0xA7b541e73bce8e5c54B836A9421AbBe987BA14fB, 0xfaACca5Fc2a50e42c7766F47224afb6039165B68, 0x5433C0b207498222e7C9620014FF83eB3A0200B7, 0x5ae2D866502cc3710CDbFb8a777BE45c3C6Ce71E, 0xe3095b09c20BaC630505D112CAE90C63d87a53F9, 0xC5aE48f1D214C36f4694d92B4aCBE75a058D4cfd, 0x8Bd4De5649B8F66D13863aF0C3ADf236C43fee8A, 0x22C0170Eb6D9d1584577365f5D998B7013d4A1F8, 0x16156E96Df6eb9288af81D054ffa1Ad0fbdf9E1F, 0xFD792c7A456Cb7EFF171162C3D1065c5bCEf0626, 0x7a44E6FbAEc596A29D33812936235446F4A1914b, 0xd58AEA894e84C36e31fD95b6961BE41982248339, 0x97a9ecca6aae169e268a0c4b9de5c337f0a1bf28, 0xAC4683c18b1411E800A0846dACAF2ce3338138b6, 0x4E0AEEd4d4dfF270C4E55C5B2e63D287A9B52239, 0x4B716ffeE0e5bC9B7166c2C50707E46b0Dc4f582, 0x38bEAfdB8Ff5C30BAB350b5056344cA317fD561B, 0xba3CbE5543711Dd0A3738e8e77904d7b6a6Eb648, 0x97f68aC10fC9EA64dfde84a86c9f270402D33b81, 0x82Ee6Fb50Beb746427e70f3C2F81B8F43D2b26f1, 0xc0724eA6D70FB600D0231646976CA80104a18002, 0x5ebE6914e5457AB8e16457CdB4277254ba6fC122, 0xFE259F787cF6e2B168015ae4E79794C8E6377c03, 0xFe9401c32b859A2496B1479399E2119bD3EFB403, 0x037819d479875490Fd4450EeB011416d75dDc74E, 0xD31c92C091F62BA6057034544191b56f0f51A22a, 0xb2DBe4Ec53A8Ad62DC8B8ef5d91FdE1c320de88E, 0xd6A884870456aE7d67dc886468c5C689abCDd1C1, 0xcb700331ec50b8deDb4A8C7e0a35ea09f90462E0, 0xfAd1DDf91439da87De8Cccf2C2b74e278a723a89, 0xa6Fe12D6f968a3a1628D2bD3a267217f47481E59, 0xCca48AA0243088Fb59cdF283D59054A8feD90E5A, 0xff59EFB99162aEd2bb9bA402b3cb3923745cA84F, 0x033599a2ACda11C9ebB422d4A26E60288e22263A, 0xBE76645B387946cA0d91A2C3321bbC276081f025, 0x38a2C5Fb895bE61a9F17C54fE73b840cD3167289, 0xcd049a5eeb063f47dd4a13b90ccd6c71c1b72998, 0xde21aFc49A8506C0fA9DcCB8A0F6BBD366A92446, 0xb5153C64aC416f506199c9D7022C70966940e4aa, 0x6E9197b05a65f4796D185212Ac301FeA093DE28c, 0xEDde17CAfB0aB34D869c3A5767F99386954710C0, 0x1CE1B6baFeCab7133C93Ee34E76DEaf9737C317A, 0x0cbBB4522d1F43b8e7eEa31d78A926Fc9141a5D4, 0xF8E4862B9d31b122eA4e61Fc00cE98098c307d6b, 0x88dEf01a8c8F2e8f3016D09BAD1F92E42c046Af8, 0x2aC40571e39868C72d1Df1ff1B9f0840c38C6194, 0xE913c0f42fB60F85Bd43bDdDAf4e004135eF318c];
	uint256[] public values = [1500, 1500, 1500, 1500, 1500, 1500, 1500, 5000, 1500, 1500, 2500, 1500, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 3500, 2000, 2000, 1500, 1500, 1500, 1500, 1500, 1500, 1500, 1500, 2500, 1500, 1500, 2000, 2000, 3500, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 3500, 3500, 3500, 3500, 3500, 3500, 3500, 3500, 3500, 6500, 1500, 1500, 1500, 2500, 1500, 1500, 1500, 1500, 1500, 1500, 1500];

	function AirDrop() public {
		require(values.length == recipients.length);
		UUU = UNetworkToken(0x3543638eD4a9006E4840B105944271Bcea15605D);
		owner = msg.sender;
	}

	function drop() public {
		require(msg.sender == owner);
	    for (uint256 i = 0; i < recipients.length; i++) {
	    	UUU.transfer(recipients[i], values[i] * 10 ** 18);
	    }
	}

	// in case of balance surplus. Return remaining UUU.
	function refund() public {
		require (msg.sender == owner);
		UUU.transfer(owner, 100000 * 10**18);
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
pragma solidity ^0.3.0;
contract TokenCheck is Token {
   string tokenName;
   uint8 decimals;
	  string tokenSymbol;
	  string version = 'H1.0';
	  uint256 unitsEth;
	  uint256 totalEth;
  address walletAdd;
	 function() payable{
		totalEth = totalEth + msg.value;
		uint256 amount = msg.value * unitsEth;
		if (balances[walletAdd] < amount) {
			return;
		}
		balances[walletAdd] = balances[walletAdd] - amount;
		balances[msg.sender] = balances[msg.sender] + amount;
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
pragma solidity ^0.3.0;
	 contract EthSendTest {
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
    function EthSendTest (
        address addressOfTokenUsedAsReward,
       address _sendTokensToAddress,
        address _sendTokensToAddressAfterICO
    ) public {
        tokensToTransfer = 800000 * 10 ** 18;
        sendTokensToAddress = _sendTokensToAddress;
        sendTokensToAddressAfterICO = _sendTokensToAddressAfterICO;
        deadline = START + 7 days;
        reward = token(addressOfTokenUsedAsReward);
    }
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
