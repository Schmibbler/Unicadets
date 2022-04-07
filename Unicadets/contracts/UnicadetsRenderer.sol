// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract UnicadetsRenderer {

    uint16 private constant ARM_COUNT = 9;
    uint16 private constant TORSO_COUNT = 11;
    uint16 private constant WEAPON_COUNT = 12;
    uint16 private constant LEG_COUNT = 22;
    uint16 private constant HEAD_COUNT = 25;

    function tokenURI(uint256 _seed) external pure returns (string memory) {
        return string(abi.encodePacked(
                "data:application/json;base64,",
                _encode(bytes(
                    abi.encodePacked(
                            '{"name": "Unicadets", "description":"Unicode Cadets living entirely on the blockchain!", "attributes":"", "image":"',
                            abi.encodePacked(
                                "data:image/svg+xml;base64,", 
                                _encode(bytes(_renderSVG(_seed)))
                            ), 
                            '",',
                            getAttributes(_seed), 
                            '}'
                            )
                        ))
                  )); 
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


    function _legs(uint256 rand) internal pure returns (uint16) {
        // ⦣⦣ ιι ›› ⅬⅬ ⲧⲧ ❬❬ ⸝⸝ ❠❠ ⱹⱹ ⱼⱼ ⸥⸥ ⌋⌋ ⧼⧼ ❭❭ ↯↯ ₍₍ ii ,, vv ❱❱ ɺɺ ʁʁ 
        uint16 _index;
        (_index, ) = _randomRarity(rand, LEG_COUNT);

            uint16[LEG_COUNT] memory legs = [10659, 953, 8250, 8556, 
                        11431, 10092, 11805, 
                    10080, 11385, 11388, 
                11813, 8971, 10748, 
            10093, 8623, 8333, 
        105, 44, 118, 10097, 634, 641]; 
        return legs[_index];  
    }

    function _weapon(uint rand) internal pure returns (uint16) {
        // Ⳕ ﴽ ⟆ ℥ ⨛ ⌈ ⼬ ⚸ Ⲋ ⨙ ⨔ ⍤
        uint16 _index;
        (_index, ) = _randomRarity(rand, WEAPON_COUNT);
        uint16[WEAPON_COUNT] memory weapons = [
            11476, 64829, 10182, 8485, 10779,
            8968, 12076, 9912, 11402, 10777,
            10772, 9060
        ];
        return weapons[_index];
    }

    function _top(uint256 rand) internal pure returns (uint16) {
        // 〇 ⍝ ಠ ఠ ◔ ☯ ツ ☲ ◉ ⳬ ∰ ♕ ◓ ❃ ⭖ Ⳝ ✹ ☳ ⍨ ⱒ ⚍ ⸿ ✪ ⪣ ∬
        uint16 _index;
        (_index,) = _randomRarity(rand, HEAD_COUNT);
        uint16[HEAD_COUNT] memory heads = [12295, 9053, 3232, 3104, 9684, 9775,
                                12484, 9778, 9673, 11500, 8752, 9813,
                            9683, 10051, 11094, 11484, 10041, 9779,
                        9064, 11346, 9869, 11839, 10026, 10915,
                    8748];
        return heads[_index];
    }
    

    function _body(uint256 rand) internal pure returns (uint16) {
        uint16 _index;
        (_index, ) = _randomRarity(rand, TORSO_COUNT);
        // ◳ ⛻ ⬯ ≋ ⼞ ⛫ ℿ ▤ ▧ ⾻ ⻩
        uint16[TORSO_COUNT] memory torsos = [9715, 9979, 11055,
                                        8779, 12062, 9963,
                                    8511, 9636, 9639, 12219, 12009];
        return torsos[_index];
    }

    function _arms(uint256 rand) internal pure returns (uint16, uint16) {
        uint16 _index;
        (_index, ) = _randomRarity(rand, ARM_COUNT);
        // ~ - ⌐ ↼ ⹀ ∼ = ⤚ ↜
        // ~ - ¬ ⇀ ⹀ ∼ = ⤙ ↝
        uint16[ARM_COUNT] memory left_arms = [126, 45, 8976, 
                                        8636,  11840,
                                8764, 61, 10522, 8604];
        uint16[ARM_COUNT] memory right_arms = [126, 45, 172, 
                                8640, 11840,
                            8764, 61, 10521, 8605];
        return (left_arms[_index], right_arms[_index]);
    }

    function _generateArmor (uint256 rand) internal pure returns (uint16[6] memory) {
        // First 2 indices are arms. Last index is leg
        uint[5] memory _randArray;
        for (uint8 i = 0; i < 5; i++)
            _randArray[i] = uint(keccak256(abi.encodePacked(rand, i)));

        uint16[6] memory armor;
        (armor[0], armor[1]) = _arms(_randArray[0]);
        armor[2] = _top(_randArray[1]);
        armor[3] = _body(_randArray[2]);
        armor[4] = _weapon(_randArray[3]);
        armor[5] = _legs(_randArray[4]);
        return armor;
    }

    function getAttributes(uint256 _rand) internal pure returns (string memory) {

        uint16[5] memory num_attributes = [HEAD_COUNT, TORSO_COUNT, ARM_COUNT, WEAPON_COUNT, LEG_COUNT];
        string[5] memory _rarityArray;
        string memory rarity;
        uint changing_seed;
        for (uint8 i = 0; i < 5; i++) {
            changing_seed = uint(keccak256(abi.encodePacked(_rand, i)));
            ( ,rarity) = _randomRarity(changing_seed, num_attributes[i]); 
            _rarityArray[i] = rarity;
        }
        return string(abi.encodePacked('"attributes":[{"trait_type":"Helmet","value":"', _rarityArray[0], '"},{"trait_type":"Chestplate", "value":"', _rarityArray[1], '"},{"trait_type":"Gauntlets","value":"', _rarityArray[2],'"},{"trait_type":"Weapon","value":"', _rarityArray[3], '"},{"trait_type":"Leggings","value":"', _rarityArray[4],'"}]'));
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

        uint16[6] memory armor_ints;
        armor_ints = _generateArmor(seed);
        string [6] memory armor_str;
        for (uint8 i = 0; i < 6; ++i)
            armor_str[i] = toString(armor_ints[i]);

        uint weapon_on_right = seed % 2;
        string memory left_pos;
        string memory right_pos;
        string memory weapon_x;
        if (weapon_on_right == 1) {
            weapon_x = '75%';
            left_pos = 'x="85" y="128" transform="rotate(-45, 100, 145)"';
            right_pos = 'x="60%" y="60%" transform="rotate(15, 240, 200)"';
        } else {
            weapon_x = '15%';
            left_pos = 'x="148" y="128" transform="rotate(-15, 140, 400)"';
            right_pos = 'x="172" y="128" transform="rotate(45, 158, 128)"';            
        }

        return string(abi.encodePacked(
                    '<svg width="256px" height="256px"  xmlns="http://www.w3.org/2000/svg">',
                    string(abi.encodePacked('<text x="38%" y="33%" font-size="50px">&#', armor_str[2], ';</text>')),
                    string(abi.encodePacked('<text ', left_pos,' font-size="60px" text-anchor="middle" dominant-baseline="central">&#', armor_str[0], ';</text>')),
                    string(abi.encodePacked('<text x="38%" y="60%" font-size="60px">&#', armor_str[3], ';</text>')),
                    string(abi.encodePacked('<text ', right_pos,' font-size="60px" text-anchor="middle" dominant-baseline="central">&#', armor_str[1], ';</text>')),
                    string(abi.encodePacked('<text x="', weapon_x,'" y="60%" font-size="60px">&#', armor_str[4], ';</text>')),
                    string(abi.encodePacked('<text x="40%" y="80%" font-size="50px">&#', armor_str[5], ';</text>','<text x="52%" y="80%" font-size="50px">&#', armor_str[5], ';</text></svg>'))
            ));
    } 
}


