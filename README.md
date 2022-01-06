# ERC721ForceFees

## Example custom ERC721 to enforce a flat fee on token transfer


This example contract is designed to enforce the caller of transfer functions to either be an approved address or to pay a specified ``_flatFee``. 

It utilizes a custom OpenZeppelin ERC721 - ``"FutureERC721"`` -  that has been modified (by me) to assume that the following Solidity issue has been resolved:

>https://github.com/ethereum/solidity/issues/11253

The [EIP721 spec](https://eips.ethereum.org/EIPS/eip-721) dictates that ``safeTransferFrom()`` and ``transferFrom()`` should be payable functions. However, for safety OpenZeppelin has removed the payable functionality to avoid forcing anyone that wants to use their implementations to decide what to do with received Ether (afaik). Solidity inheritance does not allow non-payable functions to be overriden as payable, hence the custom ERC721 with payable transfers.

I lightly tested functionality but highly discourage actually using this on mainnet.
