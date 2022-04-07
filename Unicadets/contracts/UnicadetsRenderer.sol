// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract UnicadetsRenderer {

    uint16 private constant ARM_COUNT = 9;
    uint16 private constant WEAPON_COUNT = 12;
    uint16 private constant TORSO_COUNT = 11;
    uint16 private constant LEG_COUNT = 22;
    uint16 private constant HEAD_COUNT = 25;

    function tokenURI(uint256 _seed) external pure returns (string memory) {
        string memory svg = _renderSVG(_seed);
        svg = _svgToImageURI(svg);
        return _imageURItoTokenURI(svg, _seed);
    }

    function _randomRarity(uint256 _seed, uint256 _maxIndex) internal pure returns (uint16 _index, string memory _rarityType) {
        uint256 rand_in_range = _seed % 10000;
        _maxIndex -= 1;
        if (rand_in_range >= 0 && rand_in_range <= 8500)
            return (uint16(_seed % (_maxIndex - 6)), "Common");
        else if (rand_in_range > 8500 && rand_in_range <= 9500)
            return (uint16(((_seed % 2) + (_maxIndex - 6) + 1)), "Uncommon");
        else if (rand_in_range > 9500 && rand_in_range <= 9900)
            return (uint16(((_seed % 2) + (_maxIndex - 4) + 1)),"Rare");
        else if (rand_in_range > 9900)
            return (uint16(((_seed % 2) + (_maxIndex - 2) + 1)) , "Mythic");
    }


    function _legs(uint256 rand, bool inUnicode) internal pure returns (string memory) {

        // ⦣⦣ ιι ›› ⅬⅬ ⲧⲧ ❬❬ ⸝⸝ ❠❠ ⱹⱹ ⱼⱼ ⸥⸥ ⌋⌋ ⧼⧼ ❭❭ ↯↯ ₍₍ ii ,, vv ❱❱ ɺɺ ʁʁ 
        uint16 _index;
        (_index, ) = _randomRarity(rand, LEG_COUNT);
        if (inUnicode == false) {
                uint16[LEG_COUNT] memory legs = [10659, 953, 8250, 8556, 
                            11431, 10092, 11805, 
                        10080, 11385, 11388, 
                    11813, 8971, 10748, 
                10093, 8623, 8333, 
            105, 44, 118, 10097, 634, 641]; 
            return toString(legs[_index]);
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
            return legs_str[_index];
        }
  
    }


    function _weapon(uint rand, bool inUnicode) internal pure returns (string memory) {
        // Ⳕ ﴽ ⟆ ℥ ⨛ ⌈ ⼬ ⚸ Ⲋ ⨙ ⨔ ⍤
        uint16 _index;
        (_index, ) = _randomRarity(rand, WEAPON_COUNT);
        if (inUnicode == false) {
            uint16[WEAPON_COUNT] memory weapons = [
                11476, 64829, 10182, 8485, 10779,
                8968, 12076, 9912, 11402, 10777,
                10772, 9060
            ];
            return toString(weapons[_index]);
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
            return weapons_str[_index];
        }
    }
    

    function _body(uint256 rand, bool inUnicode) internal pure returns (string memory) {
 
        uint16 _index;
        (_index, ) = _randomRarity(rand, TORSO_COUNT);
        // ◳ ⛻ ⬯ ≋ ⼞ ⛫ ℿ ▤ ▧ ⾻ ⻩
        if (inUnicode == false) {
            uint16[TORSO_COUNT] memory torsos = [9715, 9979, 11055,
                                            8779, 12062, 9963,
                                        8511, 9636, 9639, 12219, 12009];
            return toString(torsos[_index]);
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
            return torsos_str[_index];
        }       
    }

    function _arms(uint256 rand, bool inUnicode) internal pure returns (string memory, string memory) {
        uint16 _index;
        (_index, ) = _randomRarity(rand, ARM_COUNT);
        // ~ - ⌐ ↼ ⹀ ∼ = ⤚ ↜
        // ~ - ¬ ⇀ ⹀ ∼ = ⤙ ↝
        if (inUnicode == false) {
            uint16[ARM_COUNT] memory left_arms = [126, 45, 8976, 
                                            8636,  11840,
                                    8764, 61, 10522, 8604];
                                    
        
            uint16[ARM_COUNT] memory right_arms = [126, 45, 172, 
                                    8640, 11840,
                                8764, 61, 10521, 8605];

            
            return (toString(left_arms[_index]), toString(right_arms[_index]));
        } else {
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
            string memory arms_str = string(abi.encodePacked(left_arms_str[_index], right_arms_str[_index]));
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

    function _reseed(uint256 _rand, uint256 _index) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(_rand, _index)));
    }

    function getAttributes(uint256 _rand) internal pure returns (string memory) {
        uint256[5] memory reseededRand; 
        for (uint256 i = 0; i < 5; ++i) 
            reseededRand[i] = _reseed(_rand, i);
        string memory top = _top(reseededRand[0], true);
        string memory arms;
        (arms, ) = _arms(reseededRand[1], true);
        string memory torso = _body(reseededRand[2], true);
        string memory weapon = _weapon(reseededRand[3], true);
        string memory legs = _legs(reseededRand[4], true);

        // Rarity strings
        string memory top_rarity;
        ( ,top_rarity) = _randomRarity(reseededRand[0], HEAD_COUNT);
        string memory arms_rarity;
        ( ,arms_rarity) = _randomRarity(reseededRand[1], ARM_COUNT);
        string memory torso_rarity;
        ( ,torso_rarity) = _randomRarity(reseededRand[2], TORSO_COUNT);
        string memory weapon_rarity;
        ( ,weapon_rarity) = _randomRarity(reseededRand[3], WEAPON_COUNT);
        string memory legs_rarity;
        ( ,legs_rarity) = _randomRarity(reseededRand[4], LEG_COUNT);

        return string(abi.encodePacked('"attributes":[{"trait_type":"Helmet","value":"', top_rarity, ' ', top,'"},{"trait_type":"Chestplate", "value":"', torso_rarity, ' ', torso, '"},{"trait_type":"Gauntlets","value":"', arms_rarity, ' ', arms,'"},{"trait_type":"Weapon","value":"', weapon_rarity, ' ', weapon,'"},{"trait_type":"Leggings","value":"', legs_rarity, ' ', legs,'"}]'));
    }

    function _top(uint256 rand, bool inUnicode) internal pure returns (string memory) {

        // 〇 ⍝ ಠ ఠ ◔ ☯ ツ ☲ ◉ ⳬ ∰ ♕ ◓ ❃ ⭖ Ⳝ ✹ ☳ ⍨ ⱒ ⚍ ⸿ ✪ ⪣ ∬
        uint16 _index;
        (_index,) = _randomRarity(rand, HEAD_COUNT);
        if (inUnicode == false) {
            uint16[HEAD_COUNT] memory heads = [12295, 9053, 3232, 3104, 9684, 9775,
                                    12484, 9778, 9673, 11500, 8752, 9813,
                                9683, 10051, 11094, 11484, 10041, 9779,
                            9064, 11346, 9869, 11839, 10026, 10915,
                        8748];
            return toString(heads[_index]);
        } else {
            // Put hex escape characters in js metadata object "\uNNNN" and use the same hex characters to encode in svg &#xNNNN;
            //string memory heads_str = "\u3007\u235D\u0CA0\u0C20\u25D4\u262F\u30C4\u2632\u25C9\u2CEC\u2230\u2655\u25D3\u2743\u2B56\u2CDC\u2739\u2633\u2368\u2C52\u268D\u2E3F\u272A\u2AA3\u222C";
            
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
            
            return heads_str[_index];
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


    function substring(
        string memory str,
        uint256 startIndex,
        uint256 endIndex
    ) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        for (uint256 i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        return string(result);
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


