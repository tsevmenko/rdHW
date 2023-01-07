pragma solidity ^0.8.0;

import "https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary/blob/master/contracts/BokkyPooBahsDateTimeLibrary.sol";

contract BirthdayPayout {

    address _owner;

    Teammate[] public _teammates;
    TeammatePayment[] public _teammatesPayment;

    struct TeammatePayment {
        address account;
        uint year;
    }

    struct Teammate {
        string name;
        address account;
        uint256 salary;
        uint256 birthday;
    }

    constructor() public {
        _owner = msg.sender;
    }

    function addTeammate(address account, string memory name, uint256 salary, uint256 birthday) public onlyOwner {
        require(msg.sender != account, "Cannot add oneself");
        Teammate memory newTeammate = Teammate(name, account, salary, birthday);
        _teammates.push(newTeammate);
        emit NewTeammate(account, name);
    }

    function findBirthday() public onlyOwner {
        require(getTeammatesNumber() > 0, "No teammates in the database");

        (uint256 currentYear,,) = getDate(block.timestamp);

        for (uint256 i = 0; i < getTeammatesNumber(); i++) {
            if (checkBirthday(i) && isPaymentAuthorised(i, currentYear)) {
                // if the birthday is today - we make payment
                TeammatePayment memory newTP = TeammatePayment(_teammates[i].account, currentYear);
                _teammatesPayment.push(newTP);
                birthdayPayout(i);
            }
        }
        revert("Noone found");
    }

    function isPaymentAuthorised(uint256 index, uint256 currentYear) public onlyOwner returns (bool) {
        for (uint i = 0; i < _teammatesPayment.length; i++) {
            TeammatePayment memory tp = _teammatesPayment[i];
            if (tp.year == currentYear && tp.account == _teammates[index].account) {
                return false;
            }
        }

        return true;
    }

    // this function is instead of sendToTeammate
    function birthdayPayout(uint256 index) public onlyOwner {
        // send some money to the teammate
        payable(_teammates[index].account).transfer(_teammates[index].salary);
        // and emit a HappyBirthday event(just in case)
        emit HappyBirthday(_teammates[index].name, _teammates[index].account);
    }

    function getDate(uint256 timestamp) view public returns (uint256 year, uint256 month, uint256 day){
        (year, month, day) = BokkyPooBahsDateTimeLibrary.timestampToDate(timestamp);
    }

    function checkBirthday(uint256 index) view public returns (bool){
        uint256 birthday = getTeammate(index).birthday;
        (, uint256 birthday_month,uint256 birthday_day) = getDate(birthday);
        uint256 today = block.timestamp;
        (, uint256 today_month,uint256 today_day) = getDate(today);

        if (birthday_day == today_day && birthday_month == today_month) {
            return true;
        }
        return false;
    }

    function getTeammate(uint256 index) view public returns (Teammate memory){
        return _teammates[index];
    }

    function getTeam() view public returns (Teammate[] memory){
        return _teammates;
    }

    function getTeammatesNumber() view public returns (uint256){
        return _teammates.length;
    }

    function deposit() public payable {

    }

    modifier onlyOwner{
        require(msg.sender == _owner, "Sender should be the owner of contract");
        _;
    }

    event NewTeammate(address account, string name);
    event HappyBirthday(string name, address account);
}