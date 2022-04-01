// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Unicadets {
        
    address payable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function draw(uint256 seed) public pure returns(string memory) {
        uint256 rand = uint256(keccak256(abi.encodePacked(seed)));
        string memory top = _top(rand);
        string memory legs = _legs(rand);
        return string(abi.encodePacked(top, legs));
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

    
    
    
    
    

    uint private constant HEAD_COUNT = 21;
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
            unicode"⚍"
        ];

        return heads[rand % HEAD_COUNT];
    }

    uint private constant ARM_COUNT = 7;
    function _arms(uint256 rand) internal pure returns (string memory, string memory) {

        string[ARM_COUNT] memory left_arms = [
            "~",
            "-",
            unicode"⌐",
            unicode"↼",
            unicode"↜",
            unicode"⹀",
            "="
            
        ];
        string[ARM_COUNT] memory right_arms = [
            "~",
            "-",
            unicode"¬",
            unicode"⇀",
            unicode"↝",
            unicode"⹀",
            "="
        ];

        uint arm_pair = rand % ARM_COUNT;
        return (left_arms[arm_pair],  right_arms[arm_pair]);
    }

    uint private constant TORSO_COUNT = 6;
    function _body(uint256 rand) internal pure returns (string memory, string memory) {

        string[TORSO_COUNT] memory left_torsos = [
            "[",
            unicode"❴",
            unicode"⾻",
            unicode"◳",
            unicode"⛻",
            unicode"Ⱉ"

        ];

        string[TORSO_COUNT] memory right_torsos = [
            "]",
            unicode"❵",
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
    
    uint private constant LEG_COUNT = 15;
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
            "i"
            ",",
            "v"
            
        ];
        return legs[rand % LEG_COUNT];
    }

}