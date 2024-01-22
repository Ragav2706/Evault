pragma solidity ^0.4.0;

contract IdentityManagement {

    address public ContractOwner;
    uint public userCount;

    function IdentityManagement() public {
        ContractOwner = msg.sender;
        userCount = 0;
    }

    struct UserInfo {
        string FullName;
        string EmailID;
        uint MobileNo;
        bytes32 AadharHash;  
        bytes32 PANHash;     
        bytes32 LicenseHash; 
    }

    function hash(string memory data) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(data));
    }

    mapping(address => UserInfo) public UserMap;
    mapping(uint => address) public UserAddresses;

    modifier onlyContractOwner() {
        require(msg.sender == ContractOwner, "Only the contract owner can perform this operation");
        _;
    }

    function AddUser(
        string FullName,
        string EmailID,
        uint MobileNo,
        string Aadhar,
        string PAN,
        string License
    ) public onlyContractOwner {
        address newUserAddress = address(uint160(uint(keccak256(abi.encodePacked(msg.sender, now, userCount++))))); 
        UserMap[newUserAddress] = UserInfo(
            FullName,
            EmailID,
            MobileNo,
            hash(Aadhar),
            hash(PAN),
            hash(License)
        );

        UserAddresses[userCount - 1] = newUserAddress; 
    }

    function checkUser(string memory idName, uint number) public view returns (address) {
        bytes32 hashedNumber;

        if (keccak256(abi.encodePacked(idName)) == keccak256(abi.encodePacked("Aadhar"))) {
            hashedNumber = hash(uint2str(number));
        } else if (keccak256(abi.encodePacked(idName)) == keccak256(abi.encodePacked("PAN"))) {
            hashedNumber = hash(uint2str(number));
        } else if (keccak256(abi.encodePacked(idName)) == keccak256(abi.encodePacked("License"))) {
            hashedNumber = hash(uint2str(number));
        } else {
            return address(0);
        }

        for (uint i = 0; i < userCount; i++) {
            UserInfo memory userInfo = UserMap[UserAddresses[i]];
            if (userInfo.AadharHash == hashedNumber || userInfo.PANHash == hashedNumber || userInfo.LicenseHash == hashedNumber) {
                return UserAddresses[i]; 
            }
            else {return 0;}
        }

        return address(0); 
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}