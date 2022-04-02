// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

interface IUnicadetsRenderer {
    function tokenURI(uint256 _seed) external pure returns (string memory);
}