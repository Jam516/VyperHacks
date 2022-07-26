# @version >=0.3.2

"""
@notice EtherStore is a contract where you can deposit ETH and withdraw that same amount of ETH later.
This contract is vulnerable to re-entrancy attack. Here is the attack flow:
1. Deposit 1 ETH each from Account 1 (Alice) and Account 2 (Bob) into EtherStore.
2. Deploy the Attack contract.
3. Call the Attack contract's attack function sending 1 ether (using Account 3 (Eve)).
   You will get 3 Ethers back (2 Ether stolen from Alice and Bob,
   plus 1 Ether sent from this contract).

What happened?
Attack was able to call EtherStore.withdraw multiple times before
EtherStore.withdraw finished executing.
"""

# @notice Mapping from address to ETH balance held in the contract
balances: public(HashMap[address, uint256])

# @notice Function to deposit ETH into the contract
@external
@payable
def deposit():
    self.balances[msg.sender] += msg.value

# @notice Function to withdraw the ETH deposited into the contract
@external
def withdraw():
    bal: uint256 = self.balances[msg.sender]
    assert bal > 0, "This account does not have a balance"

    send(msg.sender, bal)

    self.balances[msg.sender] = 0

# @notice Helper function to get the balance of the contract
@external
@view
def getBalance() -> uint256:
    return self.balance
