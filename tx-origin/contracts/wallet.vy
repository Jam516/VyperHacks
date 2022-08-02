# @version >=0.3.3

"""
@notice Wallet is a simple contract where the owner can make deposits and transfer
the ETH in the wallet to other addresses. This contract is vulnerable because
its transfer function uses tx.origin to check if the contract caller is the owner.
1. Deploy Wallet with 10ETH.
2. Deploy the Attack contract.
3. Trick the owner of the wallet into signing the attack transaction. Maybe use
a fake NFT free mint to do it.

What happened?
The owner of the wallet called Attack.attack() which called Wallet.transfer()
Since the origin of the transaction is the owner of the wallet the transaction
is successful and the wallet is drained.
"""
owner: address

# @notice Set owner address when the contract is created
# @notice Make constructor payable so owner can fill it as part of the deployment transaction
@external
@payable
def __init__():
    self.owner = msg.sender

# @notice Function to transfer ETH to another wallet
@external
def transfer(_to:address, _amount:uint256):
    assert tx.origin == self.owner, "Not the owner"
    assert self.balance > as_wei_value(_amount, "ether"), "Insufficient balance"
    send(_to, as_wei_value(_amount, "ether"))

# @notice Function to top up the wallet
@external
@payable
def __default__():
    pass
