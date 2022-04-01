// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Unicadets is ERC721A, Ownable {

    event UnicadetMinted(uint256 indexed tokenId, string traits);

    mapping(uint256 => uint256) internal tokenIdToHash;
    mapping(uint256 => bool) internal hashToMinted;
    mapping(uint256 => uint256) internal tokenIdToSeed;

    uint256 MAX_SUPPLY = 3000;
    
        
    address payable owner;
    string internal constant TABLE =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    constructor() ERC721A("Unicadets", "UNCDT") {}

    function mint (address _address, uint256 quantity) public {
        uint256 supply = totalSupply();
        require(msg.sender == tx.origin, "NO CHEATING");
        require(supply <= MAX_SUPPLY, "Max supply reached!");
        require(supply + quantity <= MAX_SUPPLY, "Not enough left to mint");
        
        _safeMint(msg.sender, quantity);
        _internalMint(supply, quantity);
    }

    function _internalMint(uint256 current_token, uint256 remaining) internal returns (uint) {
        if (remaining == 0)
            return 0;
        uint256 seed = _seedGen(
                            block.timestamp,
                            block.difficulty,
                            current_token,
                            msg.gas
                    );
        uint256 token_hash = uint256(keccak256(
                                bytes(
                                    _draw(
                                        seed
                                    )
                                )
                            )
                        );
        if (!hashToMinted[token_hash]) {
            hashToMinted[token_hash] = true;
            tokenIdToHash[current_token] = token_hash;
            tokenIdToSeed[current_token] = seed;
            return _internalMint(current_token + 1, remaining - 1);
        } else 
            return _internalMint(current_token, remaining);       
    }

    function _seedGen(uint256 timestamp, uint256 difficulty, uint256 index, uint256 gas) internal pure returns (uint256) {
        return uint256(
                keccak256(
                    abi.encodePacked(
                            timestamp,
                            difficulty,
                            index,
                            gas
                        )
                    )
                );
    }
 

    function _draw(uint256 seed) internal pure returns (string memory) {
        string memory top = _top(seed);
        string memory legs = _legs(seed);

        string memory torso;
        string memory torso_right;
        (torso, torso_right) = _body(seed);

        string memory left_arm;
        string memory right_arm;
        (left_arm, right_arm) = _arms(seed);

        string memory weapon = _weapon(seed);
        return string(abi.encodePacked(top, torso, torso_right, left_arm, right_arm, weapon, legs));
    }

    function _encode(bytes memory data) internal pure returns (string memory) {
        if (data.length == 0) return "";

        // load the table into memory
        string memory table = TABLE;

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((data.length + 2) / 3);

        // add some extra buffer at the end required for the writing
        string memory result = new string(encodedLen + 32);

        assembly {
            // set the actual output length
            mstore(result, encodedLen)

            // prepare the lookup table
            let tablePtr := add(table, 1)

            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

            // result ptr, jump over length
            let resultPtr := add(result, 32)

            // run over the input, 3 bytes at a time
            for {

            } lt(dataPtr, endPtr) {

            } {
                dataPtr := add(dataPtr, 3)

                // read 3 bytes
                let input := mload(dataPtr)

                // write 4 characters
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(6, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(input, 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
            }

            // padding with '='
            switch mod(mload(data), 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }
        }

        return result;
    }

    function _svgToImageURI (string memory svg) internal pure returns (string memory) {
        string memory encoded = _encode(bytes(svg));
        return string(abi.encodePacked("data:image/svg+xml;base64,", encoded));        
    }

    function _imageURItoTokenURI (string memory imageURI) internal pure returns (string memory) {
        string memory baseURL = "data:application/json;base64";
        return string(abi.encodePacked(
                baseURL,
                _encode(bytes(abi.encodePacked(
                    '{"name": "Unicadets", "description":"Unicode Cadets living entirely on the blockchain!", "attributes":"", "image":"',
                    imageURI, 
                    '"}')
                    ))
                  )); 
    }
    function renderSVG(uint256 seed) public pure returns(string memory) {

        string memory top = _top(seed);
        string memory left_body;
        string memory right_body;
        (left_body, right_body) = _body(seed);

        string memory left_arm;
        string memory right_arm;
        (left_arm, right_arm) = _arms(seed);
        string memory leg = _legs(seed);
        string memory weapon = _weapon(seed);
        uint weapon_on_right = seed % 2;
        string memory weapon_x;
        
        if (weapon_on_right == 1)
        {
            weapon_x = '75%';
            left_arm = string(abi.encodePacked('<text x="85" y="128" font-size="60px" text-anchor="middle" dominant-baseline="central" transform="rotate(-45, 100, 145)">', left_arm, '</text>'));
            right_arm = string(abi.encodePacked('<text x="60%" y="60%" font-size="60px">', right_arm, '</text>'));
        } else if (weapon_on_right == 0)
        {
            weapon_x = '15%';
            left_arm = string(abi.encodePacked('<text x="24%" y="60%" font-size="60px">', left_arm, '</text>'));
            right_arm = string(abi.encodePacked('<text x="172" y="128" font-size="60px" text-anchor="middle" dominant-baseline="central" transform="rotate(45, 158, 128)">', right_arm, '</text>'));
        }

        string memory svg_string = '<svg width="256px" height="256px"  xmlns="http://www.w3.org/2000/svg">';
        top = string(abi.encodePacked('<text x="38%" y="33%" font-size="50px">', top, '</text>'));
        left_body = string(abi.encodePacked('<text x="38%" y="60%" font-size="60px">', left_body, '</text>'));
        right_body = string(abi.encodePacked('<text x="50%" y="60%" font-size="60px">', right_body,'</text>'));
        weapon = string(abi.encodePacked('<text x="', 
                                                weapon_x, 
                                                '" y="60%" font-size="60px">', 
                                                weapon, 
                                                '</text>'));
                                                
        string memory legs = string(abi.encodePacked(
                                                '<text x="40%" y="80%" font-size="50px">',
                                                leg,
                                                '</text>',
                                                '<text x="52%" y="80%" font-size="50px">',
                                                leg,
                                                '</text></svg>'));
        
        return string(abi.encodePacked(
                    svg_string,
                    top,
                    left_arm,
                    left_body,
                    right_body,
                    right_arm,
                    weapon,
                    legs
            ));
    }

    function tokenURI (uint _tokenId) public override view returns (string memory) {
        require(ownerOf(_tokenId) != address(0), "Token does not exist!");
        string memory svg = renderSVG(tokenIdToSeed[_tokenId]);
        svg = _svgToImageURI(svg);
        return _imageURItoTokenURI(svg);        
    }

    
    
    
    
    

    uint private constant HEAD_COUNT = 25;
    function _top(uint256 rand) internal pure returns (string memory) {

        string[HEAD_COUNT] memory heads = [
            unicode"〇",
            unicode"⍝",
            unicode"ಠ",
            unicode"ఠ",
            unicode"◔",
            unicode"☯",
            unicode"ツ",
            unicode"☲",
            unicode"◉",
            unicode"ⳬ",
            unicode"∰",
            unicode"♕",
            unicode"◓",
            unicode"❃",
            unicode"⭖",
            unicode"Ⳝ",
            unicode"✹",
            unicode"☳",
            unicode"⍨",
            unicode"ⱒ",
            unicode"⚍",
            unicode"⸿",
            unicode"✪",
            unicode"⪣",
            unicode"∬"
        ];

        return heads[rand % HEAD_COUNT];
    }

    uint private constant ARM_COUNT = 9;
    function _arms(uint256 rand) internal pure returns (string memory, string memory) {

        string[ARM_COUNT] memory left_arms = [
            "~",
            "-",
            unicode"⌐",
            unicode"↼",
            unicode"↜",
            unicode"⹀",
            unicode"∼",
            unicode"⤚",
            "="
            
        ];
        string[ARM_COUNT] memory right_arms = [
            "~",
            "-",
            unicode"¬",
            unicode"⇀",
            unicode"↝",
            unicode"⹀",
            unicode"∼",
            unicode"⤙",
            "="
        ];

        uint arm_pair = rand % ARM_COUNT;
        return (left_arms[arm_pair],  right_arms[arm_pair]);
    }

    uint private constant TORSO_COUNT = 14;
    function _body(uint256 rand) internal pure returns (string memory, string memory) {

        string[TORSO_COUNT] memory left_torsos = [
            "[",
            unicode"❴",
            unicode"⾻",
            unicode"◳",
            unicode"⛻",
            unicode"Ⱉ",
            unicode"⬯",
            unicode"⻩",
            unicode"≋",
            unicode"⼞",
            unicode"ℿ",
            unicode"▤",
            unicode"ↈ",
            unicode"▧"

        ];

        string[TORSO_COUNT] memory right_torsos = [
            "]",
            unicode"❵",
            unicode"",
            unicode"",
            unicode"",
            unicode"",
            unicode"",
            unicode"",
            unicode"",
            unicode"",
            unicode"",
            unicode"",
            unicode"",
            unicode""
        ];

        uint torso_int = rand % TORSO_COUNT;
        return (left_torsos[torso_int], right_torsos[torso_int]);
    }

    uint private constant WEAPON_COUNT = 12;
    function _weapon(uint rand) internal pure returns(string memory) {

        string[WEAPON_COUNT] memory weapons = [
            unicode"Ⳕ",
            unicode"ﴽ",
            unicode"⟆",
            unicode"℥",
            unicode"⨛",
            unicode"⌈",
            unicode"⼬",
            unicode"⚸",
            unicode"Ⲋ",
            unicode"⨙",
            unicode"⨔",
            unicode"⍤"
        ];

        return weapons[rand % WEAPON_COUNT];
    }
    
    uint private constant LEG_COUNT = 21;
    function _legs(uint256 rand) internal pure returns (string memory) {
        string[LEG_COUNT] memory legs = [
            unicode"ɺ",
            unicode"ʁ",
            unicode"⦣",
            unicode"ι",
            unicode"›",
            unicode"Ⅼ",
            unicode"ⲧ",
            unicode"❬",
            unicode"⸝",
            unicode"❠",
            unicode"ⱹ",
            unicode"ⱼ",
            unicode"⸥",
            unicode"⌋",
            unicode"⧼",
            unicode"❭",
            unicode"↯",
            unicode"₍",
            unicode"⌟",
            "i"
            ",",
            "v"
            
        ];
        return legs[rand % LEG_COUNT];
    }

}