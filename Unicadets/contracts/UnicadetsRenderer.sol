// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract UnicadetsRenderer {

    uint256 private constant ARM_COUNT = 9;
    uint256 private constant WEAPON_COUNT = 12;
    uint256 private constant TORSO_COUNT = 11;
    uint256 private constant LEG_COUNT = 22;
    uint256 private constant HEAD_COUNT = 25;

    function tokenURI(uint256 _seed) external pure returns (string memory) {
        string memory svg = _renderSVG(_seed);
        svg = _svgToImageURI(svg);
        return _imageURItoTokenURI(svg, _seed);
    }

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function _legs(uint256 rand, bool inUnicode) internal pure returns (string memory) {

        // ⦣⦣ ιι ›› ⅬⅬ ⲧⲧ ❬❬ ⸝⸝ ❠❠ ⱹⱹ ⱼⱼ ⸥⸥ ⌋⌋ ⧼⧼ ❭❭ ↯↯ ₍₍ ii ,, vv ❱❱ ɺɺ ʁʁ 
        if (inUnicode == false) {
                uint16[LEG_COUNT] memory legs = [10659, 953, 8250, 8556, 
                            11431, 10092, 11805, 
                        10080, 11385, 11388, 
                    11813, 8971, 10748, 
                10093, 8623, 8333, 
            105, 44, 118, 10097, 634, 641]; 
            return toString(legs[rand % LEG_COUNT]);
        } else {
            string[LEG_COUNT] memory legs_str = [
                unicode"⦣⦣",
                unicode"ιι",
                unicode"››",
                unicode"ⅬⅬ",
                unicode"ⲧⲧ",
                unicode"❬❬",
                unicode"⸝⸝",
                unicode"❠❠",
                unicode"ⱹⱹ",
                unicode"ⱼⱼ",
                unicode"⸥⸥",
                unicode"⌋⌋",
                unicode"⧼⧼",
                unicode"❭❭",
                unicode"↯↯",
                unicode"₍₍",
                unicode"ii",
                unicode",,",
                unicode"vv",
                unicode"❱❱",
                unicode"ɺɺ",
                unicode"ʁʁ"
            ];
            return legs_str[rand % LEG_COUNT];
        }
  
    }


    function _weapon(uint rand, bool inUnicode) internal pure returns (string memory) {
        // Ⳕ ﴽ ⟆ ℥ ⨛ ⌈ ⼬ ⚸ Ⲋ ⨙ ⨔ ⍤
        if (inUnicode == false) {
            uint16[WEAPON_COUNT] memory weapons = [
                11476, 64829, 10182, 8485, 10779,
                8968, 12076, 9912, 11402, 10777,
                10772, 9060
            ];
            return toString(weapons[rand % WEAPON_COUNT]);
        } else {
            string[WEAPON_COUNT] memory weapons_str = [
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
            return weapons_str[rand % WEAPON_COUNT];
        }
    }
    

    function _body(uint256 rand, bool inUnicode) internal pure returns (string memory) {
 
        // ◳ ⛻ ⬯ ≋ ⼞ ⛫ ℿ ▤ ▧ ⾻ ⻩
        if (inUnicode == false) {
            uint16[TORSO_COUNT] memory torsos = [9715, 9979, 11055,
                                            8779, 12062, 9963,
                                        8511, 9636, 9639, 12219, 12009];
            return toString(torsos[rand % TORSO_COUNT]);
        } else {
            string[TORSO_COUNT] memory torsos_str = [
                unicode"◳", 
                unicode"⛻",
                unicode"⬯",
                unicode"≋",
                unicode"⼞",
                unicode"⛫",
                unicode"ℿ",
                unicode"▤",
                unicode"▧",
                unicode"⾻",
                unicode"⻩"
            ];
            return torsos_str[rand % TORSO_COUNT];
        }       
    }

    function _arms(uint256 rand, bool inUnicode) internal pure returns (string memory, string memory) {

        // ~ - ⌐ ↼ ⹀ ∼ ⤚ = ↜
        // ~ - ¬ ⇀ ⹀ ∼ ⤙ = ↝
        if (inUnicode == false) {
            uint16[ARM_COUNT] memory left_arms = [126, 45, 8976, 
                                            8636,  11840,
                                    8764, 10522, 61, 8604];
                                    
        
            uint16[ARM_COUNT] memory right_arms = [126, 45, 172, 
                                    8640, 11840,
                                8764, 10521, 61, 8605];

            uint8 arm_pair = uint8(rand % ARM_COUNT);
            return (toString(left_arms[arm_pair]), toString(right_arms[arm_pair]));
        } else {
            uint8 arm_pair = uint8(rand % ARM_COUNT);
            string[ARM_COUNT] memory left_arms_str = [
                unicode"~",
                unicode"-",
                unicode"⌐",
                unicode"↼",
                unicode"⹀",
                unicode"∼",
                unicode"⤚",
                unicode"=",
                unicode"↜"
            ];
            string[ARM_COUNT] memory right_arms_str = [
                unicode"~",
                unicode"-",
                unicode"¬",
                unicode"⇀",
                unicode"⹀",
                unicode"∼",
                unicode"⤙",
                unicode"=",
                unicode"↝"
            ];
            string memory arms_str = string(abi.encodePacked(left_arms_str[arm_pair], right_arms_str[arm_pair]));
            return (arms_str, "");
        }



    }

    function _imageURItoTokenURI (string memory imageURI, uint256 _seed) internal pure returns (string memory) {
        string memory baseURL = "data:application/json;base64,";
        string memory attributes = getAttributes(_seed);
        return string(abi.encodePacked(
                baseURL,
                _encode(bytes(abi.encodePacked(
                    '{"name": "Unicadets", "description":"Unicode Cadets living entirely on the blockchain!", "attributes":"", "image":"',
                    imageURI, 
                    '",',
                    attributes, 
                    '}')
                    ))
                  )); 
    }

    function _svgToImageURI (string memory svg) internal pure returns (string memory) {
        string memory encoded = _encode(bytes(svg));
        return string(
                    abi.encodePacked(
                        "data:image/svg+xml;base64,", 
                        encoded
                        )
                    );        
    }

    function getAttributes(uint256 rand) internal pure returns (string memory) {
        string memory top = _top(rand, true);
        string memory arms;
        (arms, ) = _arms(rand, true);
        string memory torso = _body(rand, true);
        string memory weapon = _weapon(rand, true);
        string memory legs = _legs(rand, true);

        return string(abi.encodePacked('"attributes":[{"trait_type":"Helmet","value":"', top,'"},{"trait_type":"Chestplate", "value":"', torso,'"},{"trait_type":"Gauntlets","value":"', arms,'"},{"trait_type":"Weapon","value":"', weapon,'"},{"trait_type":"Leggings","value":"', legs,'"}]'));
    }

    function _top(uint256 rand, bool inUnicode) internal pure returns (string memory) {

        // 〇 ⍝ ಠ ఠ ◔ ☯ ツ ☲ ◉ ⳬ ∰ ♕ ◓ ❃ ⭖ Ⳝ ✹ ☳ ⍨ ⱒ ⚍ ⸿ ✪ ⪣ ∬
        if (inUnicode == false) {
            uint16[HEAD_COUNT] memory heads = [12295, 9053, 3232, 3104, 9684, 9775,
                                    12484, 9778, 9673, 11500, 8752, 9813,
                                9683, 10051, 11094, 11484, 10041, 9779,
                            9064, 11346, 9869, 11839, 10026, 10915,
                        8748];
            return toString(heads[rand % HEAD_COUNT]);
        } else {
            string[HEAD_COUNT] memory heads_str = [
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
            return heads_str[rand % HEAD_COUNT];
        }
    }

    function _encode(bytes memory data) internal pure returns (string memory) {
        string memory TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
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

    function _renderSVG(uint256 seed) public pure returns(string memory) {

        string memory top = _top(seed, false);
        string memory torso = _body(seed, false);

        string memory left_arm;
        string memory right_arm;
        (left_arm, right_arm) = _arms(seed, false);
        string memory leg = _legs(seed, false);
        string memory weapon = _weapon(seed, false);
        uint weapon_on_right = seed % 2;
        string memory weapon_x;
        
        if (weapon_on_right == 1)
        {
            weapon_x = '75%';
            left_arm = string(abi.encodePacked('<text x="85" y="128" font-size="60px" text-anchor="middle" dominant-baseline="central" transform="rotate(-45, 100, 145)">&#', left_arm, ';</text>'));
            right_arm = string(abi.encodePacked('<text x="60%" y="60%" font-size="60px" text-anchor="middle" dominant-baseline="central" transform="rotate(15, 240, 200)">&#', right_arm, ';</text>'));
        } else if (weapon_on_right == 0)
        {
            weapon_x = '15%';
            left_arm = string(abi.encodePacked('<text x="148" y="128" font-size="60px" text-anchor="middle" dominant-baseline="central" transform="rotate(-15, 140, 400)">&#', left_arm, ';</text>'));
            right_arm = string(abi.encodePacked('<text x="172" y="128" font-size="60px" text-anchor="middle" dominant-baseline="central" transform="rotate(45, 158, 128)">&#', right_arm, ';</text>'));
        }

        string memory svg_string = '<svg width="256px" height="256px"  xmlns="http://www.w3.org/2000/svg">';
        top = string(abi.encodePacked('<text x="38%" y="33%" font-size="50px">&#', top, ';</text>'));
        torso = string(abi.encodePacked('<text x="38%" y="60%" font-size="60px">&#', torso, ';</text>'));
        weapon = string(abi.encodePacked('<text x="', weapon_x,'" y="60%" font-size="60px">&#', weapon, ';</text>'));        
        string memory legs = string(abi.encodePacked('<text x="40%" y="80%" font-size="50px">&#', leg, ';</text>','<text x="52%" y="80%" font-size="50px">&#', leg, ';</text></svg>'));
    
        return string(abi.encodePacked(
                    svg_string,
                    top,
                    left_arm,
                    torso,
                    right_arm,
                    weapon,
                    legs
            ));
    }
    
}