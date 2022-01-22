pragma solidity ^0.4.17;

contract CampaignFactory {
    address[] public deployedCampaign;

    function CampaignFactory(uint minimum) public {
        address newCampaign = new Campaign(minimum,msg.sender);
        deployedCampaign.push(newCampaign);
    }

    function getDeployedCampaign() public view returns (address[]) {
        return deployedCampaign;
    }
}

contract Campaign {

    struct Request {
        string description;
        address recipient;
        uint value;
        bool complete;
        mapping(address => bool) approvals;
        uint approvalsCount;
    }

    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;
    Request[] public requests;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function Campaign(uint minimum,address creator) public {
        manager = creator;
        minimumContribution = minimum;
        approversCount=0;
    }

    function contribue() public payable {
        require(msg.value > minimumContribution);
        approvers[msg.sender] = true;
        approversCount++;
    }

    function createRequest(string description,address recipient,uint value) public restricted {
        Request memory newRequest = Request({
            description:description,
            recipient:recipient,
            value:value,
            complete:false,
            approvalsCount:0
        });
        requests.push(newRequest);
    }

    function approveRequest(uint index) public {
        Request storage temp = requests[index];
        require(approvers[msg.sender]);
        require(!temp.approvals[msg.sender]);

        temp.approvals[msg.sender]=true;
        temp.approvalsCount++;
    }

    function finalizeRequest(uint index) public restricted {
        Request storage temp = requests[index];
        require(!temp.complete);
        require(temp.approvalsCount > (approversCount/2));
        temp.complete=true;
        temp.recipient.transfer(temp.value);
    }

}
