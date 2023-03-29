# @version ^0.3.0

from vyper.interfaces import ERC20
from vyper.interfaces import ERC20Detailed

implements: ERC20
implements: ERC20Detailed

event Transfer:
    sender: indexed(address)
    receiver: indexed(address)
    value: uint256

event Approval:
    sender: indexed(address)
    receiver: indexed(address)
    value: uint256

name: public(String[32])
symbol: public(String[32])
decimals: public(uint8)

# NOTE: By declaring `balanceOf` as public, vyper automatically generates a 'balanceOf()' getter
#       method to allow access to account balances.
#       The _KeyType will become a required parameter for the getter and it will return _ValueType.
#       See: https://vyper.readthedocs.io/en/v0.1.0-beta.8/types.html?highlight=getter#mappings
balanceOf: public(HashMap[address, uint256])
# By declaring `allowance` as public, vyper automatically generates the `allowance()` getter
allowance: public(HashMap[address, HashMap[address, uint256]])
# By declaring `totalSupply` as public, we automatically create the `totalSupply()` getter
totalSupply: public(uint256)
minter: address

### ---- All above are required to implement ERC20 otherwise a INTERFACE VIOLATION will occur

MAX_SUPPLY: constant(uint256) = 1000000
INIT_SUPPLY: constant(uint256) = 100000

@external
def __init__(_name: String[32], _symbol: String[32], _decimals: uint8, _supply: uint256):
    self.name = _name
    self.symbol = _symbol
    self.decimals = _decimals
    self.balanceOf[msg.sender] = INIT_SUPPLY
    self.totalSupply = INIT_SUPPLY
    self.minter = msg.sender
    log Transfer(empty(address), msg.sender, INIT_SUPPLY)

@external
def transfer(_account : address, _value : uint256) -> bool:
    """
    @dev Transfer token for a specified address
    @param _account The address to transfer to.
    @param _value The amount to be transferred.
    """
    # NOTE: vyper does not allow underflows
    #       so the following subtraction would revert on insufficient balance
    self.balanceOf[msg.sender] -= _value
    self.balanceOf[_account] += _value
    log Transfer(msg.sender, _account, _value)
    return True


@external
def transferFrom(_from : address, _account : address, _value : uint256) -> bool:
    """
     @dev Transfer tokens from one address to another.
     @param _from address The address which you want to send tokens from
     @param _account address The address which you want to transfer to
     @param _value uint256 the amount of tokens to be transferred
    """
    # NOTE: vyper does not allow underflows
    #       so the following subtraction would revert on insufficient balance
    self.balanceOf[_from] -= _value
    self.balanceOf[_account] += _value
    # NOTE: vyper does not allow underflows
    #      so the following subtraction would revert on insufficient allowance
    self.allowance[_from][msg.sender] -= _value
    log Transfer(_from, _account, _value)
    return True

@external
def mint(_account: address, _value: uint256) -> bool:
    assert msg.sender == self.minter
    assert _account != empty(address)
    self.totalSupply += _value
    self.balanceOf[_account] += _value
    log Transfer(empty(address), _account, _value)
    return True

@external
def approve(_spender : address, _value : uint256) -> bool:
    self.allowance[msg.sender][_spender] = _value
    log Approval(msg.sender, _spender, _value)
    return True

@internal
def _burn(_address : address, _value : uint256):
    """
    @Dev Internal Function that burns the set amount of tokens passed at _value from the Address
    @Param _address The account which will have the tokens burned from
    @Param _value the ammount of tokens to burn
    """
    assert _address != empty(address)
    self.totalSupply -= _value
    self.balanceOf[_address] -= _value
    log Transfer(_address, empty(address), _value)

@external
def burn(_value : uint256):
    """
    @Dev Burn ammount for Internal call _burn from msg.sender
    @Param _value The ammount to burn
    """
    self._burn(msg.sender, _value)

@external
def burnFrom(_address : address, _value : uint256):
    """
    @Dev Burn amount of token for a given address/account
    @param _address the account/address to burn from
    @param _value The amount that will be burned.
    """
    self.allowance[_address][msg.sender] -= _value
    self._burn(_address, _value)