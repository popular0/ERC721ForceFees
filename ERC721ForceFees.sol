pragma solidity 0.8.0;

import "./FutureERC721/FutureERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

/// @dev ERC721 Token with fee-enforced transfers
/// Useful for enforcing minimum creator fees across all marketplaces

/// This contract imagines the following Solidity issue has been closed:
/// https://github.com/ethereum/solidity/issues/11253
/// and the OpenZeppelin ERC721 has been subsequently updated to
/// mark public transfer functions as payable

contract ERC721ForceFees is Ownable, FutureERC721 {
    using Address for address;
    using Address for address payable;

    // Flat fee in wei
    uint256 public _flatFee;

    // Recipient address - **TRUSTED ADDRESS**
    address payable public _beneficiary;

    // Known marketplaces that already adhere to desired fee structure.
    // These are approved to bypass the flatfee requirements
    mapping(address => bool) public _approvedMarkets;

    /// @param flatFee_ The initial fee in wei
    /// @param beneficiary_ The fee recipient address
    /// @param name_ Standard ERC721 name parameter
    /// @param symbol_ Standard ERC721 symbol parameter
    constructor(
        uint256 flatFee_,
        address payable beneficiary_,
        string memory name_,
        string memory symbol_
    ) FutureERC721(name_, symbol_) {
        _flatFee = flatFee_;
        _beneficiary = beneficiary_;
    }

    /// @notice Overriden ERC721 _transfer function to enforce a flat eth fee
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        require(
            _approvedMarkets[msg.sender] || msg.value == _flatFee,
            "Gotta pay the troll toll"
        );
        if (msg.value > 0) _beneficiary.sendValue(_flatFee); // trusted external call
        super._transfer(from, to, tokenId);
    }

    // ----- ADMIN FUNCTIONS -----
    function setBeneficiary(address payable beneficiary) external onlyOwner {
        _beneficiary = beneficiary;
    }

    function approveMarket(address marketAddress) external onlyOwner {
        _approvedMarkets[marketAddress] = true;
    }

    function removeMarket(address marketAddress) external onlyOwner {
        delete _approvedMarkets[marketAddress];
    }

    /// @notice Mublic mint function for testing
    function mint(address to, uint256 id) external virtual {
        _mint(to, id);
    }
}
