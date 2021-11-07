pragma solidity ^0.8.0;

import "./certificate.sol";

contract scrapCert is certificate {
    function compareInfo(string memory _name, string memory _birth) public {
        require(msg.sender == addressToInfo[_name]);
        userinfo storage trashInfo = UserInfo[_name];
    }

    function resetInfo() public{
        if (addressToInfo[addr].addr = msg.sender) {
            delete addressToInfo[addr].addr;
        }
        else if (addressToInfo[addr].name = name) {
            delete addressToInfo[addr].name;
        }
        else if (addressToInfo[addr].birth = birth) {
            delete addressToInfo[addr].birth;
        }
        else if (addressToInfo[addr].notBefore = notBefore) {
            delete addressToInfo[addr].notBefore;
        }
        else if (addressToInfo[addr].notAfter = notAfter) {
            delete addressToInfo[addr].notAfter;
        }
        else if (addressToInfo[addr].id = setId()) {
            delete addressToInfo[addr].id;
        }
    }

    function issue(string memory name, string memory birth) public {
        if(hasinfo(addr) == false){
            newUserInfo(name, birth);
            compareInfo(name, birth);
            resetInfo();
        }
    }
}
