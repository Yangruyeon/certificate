pragma solidity ^0.8.0;

//import "./owned.sol";

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

    constructor() public { //생성자. 계약서가 배포될 때 호출됨.
        addr = msg.sender;
    }
    
    mapping(address => userinfo) public addressToInfo;
    mapping(address => cert) public certificates;

    function hasInfo(address _addr) internal {
        if(addressToInfo[addr].id == 0 ){
            return false;
        }
        return true;
    }

    function setTime() public{ //유효기간 설정
        notBefore = block.timestamp;
        notAfter = notBefore + 365 days;
    }
 
    //아래 함수는 정보 생성 함수이니 private 함수로 설정한다.
    //상속하는 컨트랙트에서도 접근이 가능해야 하므로 internal로 변경
    function newUserInfo(string _name, string _birth) internal {
        addressToInfo[addr].addr = msg.sender;
        addressToInfo[addr].name = name;
        addressToInfo[addr].birth = birth;
        addressToInfo[addr].notBefore = notBefore;
        addressToInfo[addr].notAfter = notAfter;
        addressToInfo[addr].id = setId();
        
        certhash = keccak256(userinfoToBytes(addressToInfo[addr]));
    }

    function userinfoToBytes(userinfo memory u) internal returns (bytes memory data){    //userinfo 구조체 내부 값들을 바이트열로 변환하여 연접
        uint _size = 116 + bytes(u.name).length + bytes(u.birth).length;
        bytes memory _data = new bytes(_size);
        
        uint counter = 0;
        bytes memory baddr = abi.encodePacked(u.addr);
        bytes memory bBefore = abi.encodePacked(u.notBefore);
        bytes memory bAfter = abi.encodePacked(u.notAfter);
        bytes memory bId = abi.encodePacked(u.id);
        for (uint i = 0; i < 20; i++){
            _data[counter] = bytes(baddr)[i];
            counter++;
        }
        for (uint i = 0; i < bytes(u.name).length; i++){
            _data[counter] = bytes(u.name)[i];
            counter++;
        }
        for (uint i = 0; i < bytes(u.birth).length; i++){
            _data[counter] = bytes(u.birth)[i];
            counter++;
        }
        for (uint i = 0; i < 32; i++){
            _data[counter] = bytes(bBefore)[i];
            counter++;
        }
        for (uint i = 0; i < 32; i++){
            _data[counter] = bytes(bAfter)[i];
            counter++;
        }
        for (uint i = 0; i < 32; i++){
            _data[counter] = bytes(bId)[i];
            counter++;
        }
        
        return _data;   //연접한 바이트열 반환
    }
    
    function setId() public returns(bytes32){   //현재시각+컨트랙트 호출자 정보를 이용한 랜덤 난수 생성
        return keccak256(abi.encodePacked(block.timestamp, msg.sender));
    }

    function newCert() public{
        certificates[addr].caPubkey = 0x19dec5DE28cD9433d73A5FEA9C9D99E137064B57;
        certificates[addr].userPubkey = addr;
        certificates[addr].certhash = certhash;
    }

    function getCertificate() public view returns(address, string memory, string memory, uint, uint){   //인증서 내부 정보 반환
        return(addressToInfo[addr].addr, addressToInfo[addr].name, addressToInfo[addr].birth, addressToInfo[addr].notBefore, addressToInfo[addr].notAfter);
    }

    function getCertInfo() public view returns(bytes32, address, address){  //인증서 해시, 이용자 공개키, 발급기관 공개키 반환
        return(certificates[addr].certhash, certificates[addr].caPubkey, certificates[addr].userPubkey);
    }
    
    function issue(string memory name, string memory birth) public {
        if(hasinfo(addr) == false){
            setTime();
            newUserInfo(name, birth);
            newCert();
        }
    }

    function newUserInfo(string _name, string _birth) internal {
        addresstoinfo[addr].addr = msg.sender;
        addresstoinfo[addr].name = name;
        addresstoinfo[addr].birth = birth;
        addresstoinfo[addr].notBefore = notBefore;
        addresstoinfo[addr].notAfter = notAfter;
        addresstoinfo[addr].id = setId();

        return keccak256(addresstoinfo[addr]);
    }
}
