pragma solidity ^0.4.24;

// Define a supply chain contract for Lemonade Stand
contract LemonadeStand {

    // Variable Owner
    address owner;

    // Variable skuCount
    uint skuCount;

    // State For sale
    enum State { ForSale, Sold }

    // Struct "Item with the following fields: name, sku, price, state, seller, buyer"
    struct Item {
        string name;
        uint sku;
        uint price;
        State state;
        address seller;
        address buyer;
    }

    // Mapping Assign item to a  particular sku
    mapping (uint => Item) items;

    // Event For sale
    event ForSale(uint skuCount);

    // Event sold
    event Sold(uint sku);

    // modifier: Only Owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _; // This returns the execution of the code to the caller of the modifier
    }

    // Modifier: Verify caller
    modifier verifyCaller(address _address) {
        require(msg.sender == _address);
        _;
    }

    // Modifier: Paid enough
    modifier paidEnough(uint _price) {
        require(msg.value >= _price);
        _;
    }

    // Modifier: For sale
    modifier forSale(uint _sku) {
        require(items[_sku].state == State.ForSale);
        _;
    }

    // Modifier: sold
    modifier sold(uint _sku) {
        require(items[_sku].state == State.Sold);
        _;
    }

    // Function: Constructor to set some initial values
    constructor() public {
        owner = msg.sender;
        skuCount = 0;
    }

    // Function add item
    function addItem(string _name, uint _price) onlyOwner public {
        skuCount = skuCount + 1;

        emit ForSale(skuCount);

        items[skuCount] = Item({name: _name, sku: skuCount, price: _price, state: State.ForSale, seller: msg.sender, buyer: 0});
    }

    // Function buy item
    function buyItem(uint _sku) forSale(_sku) paidEnough(items[_sku].price) public payable {
        address buyer = msg.sender;

        uint price = items[_sku].price;

        items[_sku].buyer = buyer;

        items[_sku].state = State.Sold;

        items[_sku].seller.transfer(price);

        emit Sold(_sku);
    }

    // Function fetch item
    function fetchItem(uint _sku) public view returns (string name, uint sku, uint price, string stateIs, address seller, address buyer) {
        uint state;

        name = items[_sku].name;
        price = items[_sku].price;
        state = uint(items[_sku].state);
        sku = _sku;

        if (state == 0) {
            stateIs = "For Sale";
        } else {
            stateIs = "Sold";
        }

        seller = items[_sku].seller;
        buyer = items[_sku].buyer;
    }
}
