// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IUnicadetsRenderer.sol";

contract Unicadets is ERC721A, Ownable {

    address public UnicadetsRenderer;

    mapping(uint256 => uint256) public tokenIdToSeed;
    mapping(uint256 => bool) internal seedToMinted;

    uint32 MAX_SUPPLY = 3000;

    constructor() ERC721A("Unicadets", "UNCDT") {}

    function setRendererContract(address RenderContractAddress) public onlyOwner {
        UnicadetsRenderer = RenderContractAddress;
    }


    function _currentPrice(uint256 current_supply) internal pure returns (uint256) {
        if (current_supply <= 300)
            return 0 ether;
        else if (current_supply <= 2000)
            return .1 ether;
        else if (current_supply <= 3000)
            return .15 ether;
        else
            return .1 ether;
    }

    function _batchPrice(uint256 quantity, uint256 current_supply) internal pure returns (uint256) {
        uint batch_price = 0 ether;
        for (uint i = 0; i < quantity; i++)
            batch_price += _currentPrice(current_supply + i);
        return batch_price;
    }
    

    function mint (uint256 quantity) payable public {
        uint256 supply = totalSupply();
        require(msg.sender == tx.origin, "NO CHEATING");
        require(quantity <= 10, "Maximum of 10 cadets per wallet!");
        require(supply <= MAX_SUPPLY, "Max supply reached!");
        require(supply + quantity <= MAX_SUPPLY, "Not enough left to mint");
        require(msg.value >= _batchPrice(quantity, supply), "Not enough money provided!");
        _internalMint(supply, quantity);
        _safeMint(msg.sender, quantity);
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
 

    /*
    function _draw(uint256 seed) internal pure returns (string memory) {
        string memory top = _top(seed);
        string memory legs = _legs(seed);

        string memory torso = _body(seed);

        string memory left_arm;
        string memory right_arm;
        (left_arm, right_arm) = _arms(seed);

        string memory weapon = _weapon(seed);
        return string(
                abi.encodePacked(
                    top, 
                    torso, 
                    left_arm, 
                    right_arm, 
                    weapon, 
                    legs
                    )
                );
    }*/

    function tokenURI (uint _tokenId) public override view returns (string memory) {
        /*require(ownerOf(_tokenId) != address(0), "Token does not exist!");
        string memory svg = _renderSVG(tokenIdToSeed[_tokenId]);
        svg = _svgToImageURI(svg);
        return _imageURItoTokenURI(svg);*/
        require(ownerOf(_tokenId) != address(0), "Token does not exist!");
        return IUnicadetsRenderer(UnicadetsRenderer).tokenURI(tokenIdToSeed[_tokenId]);
    }
}