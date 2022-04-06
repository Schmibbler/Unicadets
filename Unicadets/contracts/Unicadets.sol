// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IUnicadetsRenderer.sol";

/*  @author: nonce-enz
*
*   Unicadets is a project fully
*   encoded on the blockchain,
*   requiring zero 3rd parties to function
*/
contract Unicadets is ERC721A, Ownable {

    address public UnicadetsRenderer;

    /*
    * @dev declares mappings for seed generation
    */
    mapping(uint256 => uint256) public tokenIdToSeed;
    mapping(uint256 => bool) internal seedToMinted;

    /*
    * @dev declares public minting variables
    */
    uint32 public constant MAX_MINT_PER = 5;
    uint64 public MAX_SUPPLY = 5555;
    uint256 MINT_PRICE = .1 ether;
    bool public DEVS_HAVE_MINTED = false;

    constructor() ERC721A("Unicadets", "UNCDT") {}

    /*
    *   @dev sets the contract that handles rendering logic
    */
    function setRendererContract(address RenderContractAddress) public onlyOwner {
        UnicadetsRenderer = RenderContractAddress;
    }

    function getBatchPrice(uint256 quantity) public view returns (uint256) {
        if (totalSupply() <= 555)
            return 0 ether;
        else
            return quantity * MINT_PRICE;
    }

    /*
    * @dev mints >= 1 cadets to msg.sender, after updating state
    */
    function mintCadet (uint256 quantity) payable public {
        /*
        * @dev avoids excessive gas-expensive SLOAD opcode 
        *      by doing 1 state read each vs > 1
        */
        uint256 supply = totalSupply();
        uint256 max = MAX_SUPPLY;
        uint256 mint_price = MINT_PRICE;

        uint256 batch_price;
        if (supply <= 555)
            batch_price = 0 ether;
        else
            batch_price = mint_price * quantity;

        require(msg.sender == tx.origin, "No minting from contracts!");
        require(quantity <= MAX_MINT_PER, "Exceeding max mints per transaction!");
        require(supply + quantity <= max, "Not enough left to mint");
        require(msg.value >= batch_price, "Not enough money provided!");
        _internalMint(supply, quantity);
        _safeMint(msg.sender, quantity);
    }

    /*
    * @dev mints to Unicadets developer team
    */
    function devTeamMint (uint256 quantity) public onlyOwner {
        require(quantity <= 55, "Don't be greedy!");
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

    /*
    * @dev recursively calls itself until a unique seed is generated per mint.
    *      Theoretically this should only call once, but is implemented
    *      regardless
    */
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