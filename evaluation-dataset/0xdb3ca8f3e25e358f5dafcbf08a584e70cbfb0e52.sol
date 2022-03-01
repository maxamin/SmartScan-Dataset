pragma solidity ^0.4.19;

interface UNetworkToken {
    function transfer (address receiver, uint amount) public;
    function balanceOf(address _owner) returns (uint256 balance);
}


contract AirDrop {

	UNetworkToken UUU;
	address owner;
	uint256[] values = [64000, 5000, 20000, 21000, 8000, 188000, 32000, 4000, 624843, 4000, 30000, 100000, 80000, 100000, 1000, 1046, 1073, 1133, 1255, 6221, 6341, 8000, 10249, 12000, 14424, 17856, 20000, 20502, 21397, 21903, 24295, 26943, 29322, 30000, 34995, 37078, 38601, 39351, 40709, 41826, 43771, 46101, 48450, 62149, 62293, 70000, 70000, 58065, 75000, 79762, 96073, 112350, 112604, 119820, 128080, 128513, 187288, 193665, 213681, 225632, 244471, 254146, 260000, 288685, 296813, 314262, 317804, 400000, 432983, 450000, 512225, 510000, 477, 72922];
	address[] recipients = [0x410fbb3f4a72346feb59c677e6e3627c08b52d4a, 0xa811e83EBE697DF486a1f4465D4E055038024Fd1, 0x1CcCeCf4b5B65507ad7a8031090A33356027754C, 0x74909B52C77AAa5830d10f3CBfa18E2C4261CB98, 0x05ddc84f2bb00ae648aedb9eb071eaf49f9da5f7, 0x643994310DeaC920fA7Ee3932f00A97e0AC2aD8a, 0x14a1393fd4fac7f250f8c508dd9770f2366bb45e, 0x563dEe0D2F6D3fd5cB8D77B19F50b05cAfe6E3F7, 0x3C9F28F41BEf76B31c0E7Bb77b12ed7D23633939, 0x03AC626F35d61fA3F51676038223B06483CF846D, 0x079c74edbbd374f8cbb9c5f5e68f50876399a756, 0x0b2838bb8b05ca72c4967aa501519e221c41be9b, 0x7c68d4eb865c74c2158894430dd6d299cdcddccc, 0x685d9638f22b552E1f9fe4e1325970Fc07E52993, 0x563dEe0D2F6D3fd5cB8D77B19F50b05cAfe6E3F7, 0xF3C8fcFF6BD85Fb30e3e3043CdbC595aF3BAb20B, 0x0692718AC810bAc658CB26D590386d4F32660efD, 0xd001981c7D765c0e2A89f8424dDd08b2095881FC, 0xeaE12DbE038bdc9D759d2Acc480aeC0CbBa99a10, 0xC805700915eaFcDcdD90893B61e3bC04D3d91f94, 0xd101B3A62342B6334414fD01f21c49ccAeF08a79, 0x1352533eFa002CeD22A32551567bcE664352a7d4, 0x7ad40D2023dF95dE05decFDEFff1664D8B11d537, 0x185808B673B98799cF9B3c07Bbb302DECdeEbea7, 0xfA712645B206B5c98E51e73a3A47fde9D0a2790c, 0x7420E0939B3767A5A873ed4b57D217C1de339191, 0xc4325cd68761019ebd8ddfc4fb0b2d3ed8a307fb, 0x541cFedcB8A89dD5954FBd428a6152c23D2765A4, 0x1CcCeCf4b5B65507ad7a8031090A33356027754C, 0xDce94357980C6466FA8ba6439DDbeeAFFe39DE16, 0xDce94357980C6466FA8ba6439DDbeeAFFe39DE16, 0x05A1ac048f164c67B08af18d543205e16f77b0c7, 0x4E0d21509F98d6e7449CD169343A52ABA69d1B7D, 0xcF5A8D7E30F7D69511048a194aF05Ea6782266C6, 0xe78a8657B9b2E23AfB40f0BC3968AA59d9d9011C, 0xb9AC16Aa7Bb262E3bB0DDFA328c07b383AF72062, 0x1E14544F417a0328c74e210BA7D21Cdf4eA8dE15, 0xEf32EfE86C56443ec85Aa2884F5AB34378b27954, 0x2D49910f99Fdf8DB1C1ebb10B44A45b1c53d7D40, 0xcc7d6B751cFf416915BC1BE77b1D34c32aDeaaD6, 0x3acCd73140607A9638a20017BbedAa0b35E4935d, 0xDf6B3912a8D10DAfa13187C0D594002cB0f38a0e, 0x87bF90Cba0A3d88a90ef7120C9B31dc894644a13, 0xDFdE52999363EAa754Bd4Dfc8446312e27EE3460, 0x7F82D9085286f373867A130980C75c23AD24719a, 0xE1cA38541664a075CE63aE84D5D5cCA9F688eC04, 0x514409FE9Dae542bDFD32b746843c33A58e19862, 0xcCF7C0cEFddE76b3E230f309160CB6547AeA57B5, 0x514409FE9Dae542bDFD32b746843c33A58e19862, 0xC0B609E4edb33dAb32B3bDd9d910e7D02d061E6E, 0xB0836b25F9eb9fd4656451bEb8437CCBe47FCE59, 0x54B478834E0420A638e80a1227B5eE6Fc0eBD826, 0x8159436cb18AEB518525e0a8F149f8F33c961765, 0x3C9F28F41BEf76B31c0E7Bb77b12ed7D23633939, 0x646962E094cBc00d9A6A03e8e98Ff2443DbcAa41, 0xA1A3b7D27c81960F2d7C962ba130a55e5d457799, 0xF29e2B524Fd1F5BE1A41DcAb9333Ed27567904c1, 0xCf50fB42926b255747fb8b0EA8E26D4e66952CA4, 0x576c79444bce16E986d030B432E739a8fF2Ad810, 0x9b1d6F34cC0E1e81648A016c7C9766C718D0b78C, 0x9e402906942D99beF8E995C58EA55056f692cD1f, 0xd13955f8f6D08880A99a42c1963cE6f789720619, 0x5fA373F710d31486e2d40180F69E748b0D1BF48e, 0xC0B0c32F4eFe69B3B941C6BD23DC6d82Df26A5ca, 0xFb486f8041234Bd8Fd41f1d54a5de39Cef0c27C5, 0x5568D97cCA34b016E6CB6687f9C3766118F77543, 0x278Ca73880810Ece1BD326dA43513a779dc46A49, 0x685d9638f22b552E1f9fe4e1325970Fc07E52993, 0x643994310DeaC920fA7Ee3932f00A97e0AC2aD8a, 0x3826c98Ba453328B32837964A44589c88231690c, 0xB217f1D7093b021B7dE9dd603D498CE3A16e293C, 0x514409FE9Dae542bDFD32b746843c33A58e19862, 0xe8B46a9dD631D41618598E92E04Dc4ddF3CA0Fd5, 0x3D00301Ed8B7284dbA8f1364B16aC5eBF670da96];
	function AirDrop() public {
		UUU = UNetworkToken(0x3543638ed4a9006e4840b105944271bcea15605d);
		owner = msg.sender;
		require(values.length == recipients.length);
	}

	function drop() public {
	    for (uint256 i = 0; i < recipients.length; i++) {
	    	UUU.transfer(recipients[i], values[i] * 10 ** 18);
	    }
	}

	function refund() public {
		UUU.transfer(owner, UUU.balanceOf(this));
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
