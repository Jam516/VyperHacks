# @version >=0.3.3

"""
@notice GuessRandom is a game where you win 1ETH if you guess the right random number.
This contract is vulnerable because the source of randomness is weak. Here is the attack flow:
1. Deploy GuessTheRandomNumber and deposit 1ETH.
2. Deploy the Attack contract.
3. Call the Attack contract's attack function and win 1ETH.

What happened?
Attack computed the correct answer by simply copying the code that computes the random number.
"""

event TopUp:
    sender: indexed(address)
    amount: uint256
    bal: uint256

# @notice Function to check the user's guess and pay out the reward
@external
def guess(_guess:uint256):
    # @dev Get the hash of the previous block
    blockValue: uint256 = convert(block.prevhash, uint256)
    answer:uint256 = blockValue/100000000000000000000000000000000000000000000000000000000000000000000000000

    if _guess == answer:
        assert self.balance >= as_wei_value(1, "ether"), "Prize pot empty"
        send(msg.sender, as_wei_value(1, "ether"))

# @notice Function to top up the prize pool
@external
@payable
def __default__():
    log TopUp(msg.sender, msg.value, self.balance)
