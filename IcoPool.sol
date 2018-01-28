pragma solidity ^0.4.18;

import "./ERC20Interface.sol";
contract IcoPool {
    
    address icoContract;
    address poolCreator;
    uint maxPoolAllocation;
    uint maxPerContributor;
    uint minPerContributor;
    address[] admins;
    address[] whitelist;
    mapping (address => bool) contributors;
    address[] contributorsList;
    uint fee;
    bool automaticDistribution;
    
    struct erc20token {
        address tokenAddress;
        string name;
    }
    mapping (address => uint) tokenBalanceForAddress;
    
    ERC20Interface token;
   
    mapping (address => uint) contributions;
    
    modifier onlyPoolCreator() {
        if (msg.sender == poolCreator) {
            _;
        }
    }
    
    event withdrawal(address contributor, uint amount);
    event DepositForTokenReceived(address, uint, uint);
    
    function IcoPool( uint maxPoolAllocation1, uint maxPerContributor1, uint minPerContributor1) public {
        poolCreator = msg.sender;
        minPerContributor = minPerContributor1;
        maxPerContributor = maxPerContributor1;
        maxPoolAllocation = maxPoolAllocation1;
    }
    
    //// Getters /////
    
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
    
     function getContributors() public constant returns(address[]) {
        return contributorsList;
    }
    function getMyContribution() public constant returns (uint) {
        return contributions[msg.sender];
    }
    function getContribution(address addr) public constant returns (uint) {
        return contributions[addr];
    }
      
    function getRegisteredTokenSupply() public constant returns (uint) {
        return token.totalSupply();
    }
    
      
    function getTokenBalance(address addr) public constant returns (uint) {
        return tokenBalanceForAddress[addr];
    }
    ////// Setters ////////
    
      function setMinPerContributorn(uint contribution) public {
          require(contribution < maxPerContributor);
         minPerContributor = contribution;
    }
    
    function contribute() public payable {
        contributions[msg.sender] += msg.value;
        
           if(!alreadyContributed(msg.sender)) contributorsList.push(msg.sender); 
           contributors[msg.sender] = true;
    }
    
    
    function alreadyContributed(address addr) public constant returns (bool) {
        if(contributors[addr]) return true;
        return false;
    }
    
   
    
    function withdrawContribution(uint amount) public  returns (bool) {
        require(contributions[msg.sender] > 0);
        require(contributions[msg.sender] >= amount);
        require(this.balance >= amount);
        
        contributions[msg.sender] -= amount;
        msg.sender.transfer(amount);
        
        if(contributions[msg.sender] == 0) contributors[msg.sender] = false;
        withdrawal(msg.sender,amount);
        return true;
    }
    
    function registerToken(address tokenAddress) public onlyPoolCreator returns (bool){
        require(tokenAddress != address(0));
        token = ERC20Interface(tokenAddress);
        return true;
    }
  
    
    // Token owner most likely invokes this method. msg.sender is the token owner that calls this function
     function depositToken(uint amount) public returns (bool) {
        require(token.transferFrom(msg.sender, address(this), amount) == true);
        require(tokenBalanceForAddress[poolCreator] + amount >= tokenBalanceForAddress[poolCreator]);
        tokenBalanceForAddress[poolCreator] += amount;
        DepositForTokenReceived(poolCreator, amount, now);
        return true;
    }
  
  // 0xf828377c9048dac1e072734cf1ffc01db5887758
}