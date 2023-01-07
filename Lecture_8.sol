pragma solidity ^0.8.0;

import "https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary/blob/master/contracts/BokkyPooBahsDateTimeLibrary.sol";

contract ContactBook {
    Contact[] private _contacts;

    function addContact(string memory name) public{
        Contact newContact = new Contact(name);
        newContact.setAddress(address(newContact));

        _contacts.push(newContact);
    }

    function callContact(uint index) view public returns (string memory)
    {
        return _contacts[index].reply();
    }

    function getContactAddress(uint number) view public returns(address){
        return _contacts[number].getAddress();
    }
}

contract Contact {

    string private _name;
    address private _address;

    constructor(string memory name) public {
        _name = name;
    }

    function getName() public returns (string memory)
    {
        return _name;
    }

    function setAddress(address newAddress) public
    {
        _address = newAddress;
    }

    function getAddress() view public returns (address)
    {
        return _address;
    }

    function reply() view public returns (string memory) {
        return string.concat(_name, " on call!");
    }
}