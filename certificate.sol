pragma solidity ^0.8.0;

import "./owned.sol";

contract certificate {

    //컨트랙트 내에 생성되는 변수들은 블록체인에 영구적으로 저장되는 변수들임.

    byte32 certhash; //strct cert 내부의 변수와 다른 변수임. 
                     //여기에 해시값 받아서 구조체 certhash에 넣을 것.
    address addr;
    uint notBefore; //유효기간 시작 시간
    uint notAfter; //유효기간 끝나는 시간

    //사용자가 정보를 등록할 때마다 새로운 정보가 UserInfo 배열에 추가된 후 NewCert 이벤트를 실행하도록 한다.
    event NewCert(uint certId, address addr, string name, string birth, uint notBefore, uint notAfter, byte32 ID);

    struct userinfo { //내부정보 - 이름, 생일, ID등 정보를 가지는 구조체
        address addr;
        string name; //이름
        string birth; //생년월일
        uint notBefore; //유효기간 시작 시간
        uint notAfter; //유효기간 끝나는 시간
        byte32 ID;
    }

    userinfo[] public UserInfo; //사용자 정보 동적 배열

    struct cert { 
        //userinfo 구조체 변수를 이용해 만들어진 인증서 해시값과 
        //이용자의 공개키, 발급기관의 공개키를 가지는 구조체
        byte32 certhash;
        address CAPubKey; //발급기관의 공개키
        address UserPubKey; //이용자 공개키
    }

    cert[] public Cert; //인증서 동적 배열

    mapping(address ==> userinfo) public addressinfo;

    modifier onlyOwner() {
        
    }

    function setTime(uint _notBefore, uint _notAfter) public {

        newUserInfo(); //함수 호출 [함수에서 함수 호출이 가능한가..?]
    }
 
    //아래 함수는 정보 생성 함수이니 private 함수로 설정한다.
    function newUserInfo(address _addr, string _name, string _birth, uint _notBefore, uint _notAfter, byte32 ID)) private {
        //UserInfo 배열에 정보 저장하면서 새롭게 생성
        UserInfo.push(userinfo(_addr, _name, _birth, _notBefore, _notAfter, byte32 _ID)); 

        //UserInfo 배열에 정보 추가
        //배열이 첫 원소의 인덱스가 0이기 때문에 array.push()-1은 막 추가된 정보의 인덱스가 될 것이다.
        //id는 NewCert 이벤트를 위해 활용한다.
        uint id = UserInfo.push(userinfo(_addr, _name, _birth, _notBefore, _notAfter, byte32 _ID)) - 1;
        NewCert(id, _addr, _name, _birth, _notBefore, _notAfter, byte32 _ID);

        mapping(address ==> cert) public certificates;

        certificates[msg.sender].caPublicKey;
        certificates[msg.sender].userPubkey = msg.sender;
        certificates[msg.sender].certHash = certHash;

        getCertificate(); //함수 호출
    }

    //뭔가 이 함수는 return값으로 출력되는 게 있어야 할 것 같은데...
    function getCertificate() public {
        
    }


    function hasInfo(address _addr) private {
        if (addresstoInfo[addr] == 0) {
            return true;
        }

        //아래 if문은 미정 조건문
        if (hasinfo(addr) == 0) {
            setTime(_notBefore, _notAfter); //함수 호출
        }

        return false;
    }

    function newUserInfo(string _name, string _birth) private {
        addresstoinfo[addr].addr = msg.sender;
        addresstoinfo[addr].name = name;
        addresstoinfo[addr].birth = birth;
        addresstoinfo[addr].notBefore = notBefore;
        addresstoinfo[addr].notAfter = notAfter;
        addresstoinfo[addr].id = setId();

        return keccak256(addresstoinfo[addr]);
    }
}
