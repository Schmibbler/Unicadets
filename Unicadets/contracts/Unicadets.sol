// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IUnicadetsRenderer.sol";

contract Unicadets is ERC721A, Ownable {

    address public UnicadetsRenderer;

    mapping(uint256 => uint256) public tokenIdToSeed;
    mapping(uint256 => bool) internal seedToMinted;
    uint32 public constant MAX_MINT_PER = 5;
    uint64 public MAX_SUPPLY = 5000;
    bool public DEVS_HAVE_MINTED = false;

    constructor() ERC721A("Unicadets", "UNCDT") {}

    function setRendererContract(address RenderContractAddress) public onlyOwner {
        UnicadetsRenderer = RenderContractAddress;
    }
    function setMaxSupply(uint32 _supply) public onlyOwner {
        MAX_SUPPLY = _supply;
    }

    function _currentPrice(uint256 current_supply, uint64 max) internal pure returns (uint256) {
        if (current_supply <= 500)
            return 0 ether;
        else if (current_supply > 500 && current_supply <= max)
            return .1 ether;
        else
            return .1 ether;
    }

    function _batchPrice(uint256 quantity, uint256 current_supply, uint64 max) internal pure returns (uint256) {
        uint batch_price = 0 ether;
        for (uint i = 0; i < quantity; i++)
            batch_price += _currentPrice(current_supply + i, max);
        return batch_price;
    }

    function getBatchPrice(uint256 quantityOfTokensToMint) public view returns (uint256) {
            return _batchPrice(quantityOfTokensToMint, totalSupply(), MAX_SUPPLY);
    }

    function mint (uint256 quantity) payable public {
        uint256 supply = totalSupply();
        uint64 max = MAX_SUPPLY;
        require(msg.sender == tx.origin, "No minting from contracts!");
        require(quantity <= MAX_MINT_PER, "Exceeding max mints per transaction!");
        require(supply <= max, "Max supply reached!");
        require(supply + quantity <= max, "Not enough left to mint");
        require(msg.value >= _batchPrice(quantity, supply, max), "Not enough money provided!");
        _internalMint(supply, quantity);
        _safeMint(msg.sender, quantity);
    }

    function devTeamMint (uint256 quantity) public onlyOwner {
        require(quantity <= 30, "Don't be greedy!");
        require(DEVS_HAVE_MINTED == false, "Developer team has already minted!");
        _internalMint(totalSupply(), quantity);
        _safeMint(msg.sender, quantity);
        DEVS_HAVE_MINTED = true;
    }

    function _internalMint(uint256 current_token, uint256 remaining) internal {
        if (remaining == 0) return;
        uint256 seed = _seedGen(
                            block.timestamp,
                            block.difficulty,
                            current_token,
                            gasleft()
                    );
        seedToMinted[seed] = true;
        tokenIdToSeed[current_token] = seed;
        _internalMint(current_token + 1, remaining - 1);      
    }

    function _seedGen(uint256 timestamp, uint256 difficulty, uint256 index, uint256 gas) internal view returns (uint) {
        uint256 seed = uint256(
                        keccak256(
                            abi.encodePacked(
                                    timestamp,
                                    difficulty,
                                    index,
                                    gas
                                )
                            )
                        );
        if (seedToMinted[seed])
            return _seedGen(timestamp + 1, difficulty + 1, index + 1, gas + 1);
        else
            return seed;
    }


    function tokenURI (uint _tokenId) public override view returns (string memory) {
        require(ownerOf(_tokenId) != address(0), "Token does not exist!");
        return IUnicadetsRenderer(UnicadetsRenderer).tokenURI(tokenIdToSeed[_tokenId]);
    }

    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance); 
    }
}