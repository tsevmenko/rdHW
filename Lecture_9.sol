pragma solidity 0.8.17;

interface Living{
    function eat(string memory food) external returns(string memory);
}

contract HasName{
    string internal _name;
    constructor(string memory name){
        _name=name;
    }

    function getName() view public returns(string memory){
        return _name;
    }
}

abstract contract Animal is Living{

    function eat(string memory food) view virtual public returns(string memory){
        return string.concat(string.concat("Animal eats ",food));
    }

    function sleep() pure public returns(string memory){
        return "Z-z-z...";
    }

    function speak() view virtual public returns(string memory){
        return "...";
    }
}

library StringComparer{
    function compare(string memory str1, string memory str2) public pure returns (bool) {
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }
}

abstract contract Herbivore is Animal, HasName{
    string constant PLANT = "plant";

    modifier eatOnlyPlant(string memory food){
        require(StringComparer.compare(food,PLANT),"Can only eat plant food");
        _;
    }

    function eat(string memory food) view virtual override public eatOnlyPlant(food) returns(string memory){
        return super.eat(food);
    }
}

contract Cow is Herbivore{

    constructor(string memory name) HasName(name){
    }

    function speak() pure override public returns(string memory){
        return "Mooo";
    }
}

contract Horse is Herbivore{

    constructor(string memory name) HasName(name){
    }

    function speak() view override public returns(string memory){
        return "Igogo";
    }

}

contract Wolf is Animal{
    string constant MEAT = "meat";

    modifier strictFood(string memory food) virtual {
        require(StringComparer.compare(food, MEAT), "Can only eat meat food");
        _;
    }

    function eat(string memory food) view virtual override public strictFood(food) returns(string memory){
        return string.concat("Wolf eats ", food);
    }

    function speak() view virtual override public returns(string memory){
        return "Awoo";
    }
}

contract Dog is Wolf{
    string constant PLANT = "plant";
    string constant CHOCKOLADE = "chokolade";

    modifier strictFood(string memory food) override {
        require(!StringComparer.compare(food, CHOCKOLADE), "Can\'t eat chokolade");
        require(StringComparer.compare(food, MEAT) || StringComparer.compare(food, PLANT), "Can only eat meat or plant");

        _;
    }

    function eat(string memory food) view virtual override public strictFood(food) returns(string memory){
        return string.concat("Dog eats ", food);
    }

    function speak() view override public returns(string memory){
        return "Woof";
    }
}

contract Farmer{

    function feed(address animal, string memory food) view public returns(string memory){
        return Animal(animal).eat(food);
    }

    function call(address animal) view public returns(string memory){
        return Animal(animal).speak();
    }
}