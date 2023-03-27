// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract EventContract{
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }
    mapping(uint=>Event) public events;//uint symbolises event id while Event reqresents the structure of whole event
    mapping(address=>mapping(uint=>uint)) public tickets;//address symbolises buyer account address while inside nested mapping is from event id to number of tickets
    uint public nextId;

    function createEvent(string memory name, uint date, uint price, uint ticketCount)external {
        require(date>block.timestamp, "You can organize event for the future date");
        require(ticketCount>0, "You can organize event if you create more than 0 tickets");
        uint ticketRemain=ticketCount;
        events[nextId]= Event(msg.sender, name, date, price, ticketCount, ticketRemain);
        nextId++;
    }

    function buyTicket(uint id, uint quantity) external payable{
        Event storage _event = events[id];
        require(msg.value==(_event.price*quantity), "Ether is not enough");
        require(_event.ticketRemain>=quantity, "Not enough tickets");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+=quantity;
    }
}