pragma solidity ^0.4.17;

contract Campaign {
    struct Request {
        string description;
        address recipient;
        uint value;
        bool complete;
    }

    address public manager;
    uint public minimumContribution;
    address[] public approvers;
    Request[] public requests;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function Campaign(uint minimum) public {
        manager = msg.sender;
        minimumContribution = minimum;
    }

    function contribue() public payable {
        require(msg.value > minimumContribution);
        approvers.push(msg.sender);
    }

    function createRequest(string description,address recipient,uint value) public restricted {
        Request memory newRequest = Request({
            description:description,
            recipient:recipient,
            value:value,
            complete:false
        });
        requests.push(newRequest);
    }

}
