pragma solidity ^0.4.18;

contract IcoPool {
    
    address icoContract;
    address poolCreator;
    uint maxPoolAllocation;
    uint maxPerContributor;
    uint minPerContributor;
    address[] admins;
    address[] whitelist;
    address[] contributors;
    uint fee;
    bool automaticDistribution;
   
    mapping (address => uint) contributions;
    
    event withdrawal(address contributor, uint amount);
    
    function IcoPool( uint maxPoolAllocation1, uint maxPerContributor1, uint minPerContributor1) public {
        poolCreator = msg.sender;
        minPerContributor = minPerContributor1;
        maxPerContributor = maxPerContributor1;
        maxPoolAllocation = maxPoolAllocation1;
    }
    
    
    function getMaxPoolAllocation() constant public returns(uint) {
        return maxPoolAllocation;
    }
    function getMaxPerContributor() constant public returns(uint) {
        return maxPerContributor;
    }
    
     function getMinPerContributorn() constant public returns(uint) {
        return minPerContributor;
    }
    
     
     function getPoolBalance() constant public returns(uint) {
        return this.balance;
    }
     function getPoolCreator() constant public returns(address) {
        return poolCreator;
    }
      function setMinPerContributorn(uint contribution) public {
          require(contribution < maxPerContributor);
         minPerContributor = contribution;
    }
    
    function contribute() public payable {
        contributions[msg.sender] = msg.value;
        
        // is there a way to retrieve keys from mapping?
        contributors.push(msg.sender);
    }
    
    function getContributors() public constant returns(address[]) {
        return contributors;
    }
    function getContribution() public constant returns (uint) {
        return contributions[msg.sender];
    }
    
    function withdrawContribution(uint amount) public  returns (bool) {
        require(contributions[msg.sender] > 0);
        require(contributions[msg.sender] >= amount);
        require(this.balance >= amount);
        
        contributions[msg.sender] -= amount;
        msg.sender.transfer(amount);
        withdrawal(msg.sender,amount);
        return true;
    }
}
