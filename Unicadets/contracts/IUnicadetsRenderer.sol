// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.5;

interface IUnicadetsRenderer {
    function tokenURI(uint256 _seed) external pure returns (string memory);
}