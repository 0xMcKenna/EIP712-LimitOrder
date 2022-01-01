// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract LimitOrder {
    using ECDSA for bytes32;

    // STORAGE VARIABLES
    struct LimitOrder {
        uint256 price;
        uint256 units;
        uint256 orderExpire;
        bool bid;
    }

    mapping(address => LimitOrder) public limitOrders;

    IERC20 public USDC;

    // EIP-712
    bytes32 public DOMAIN_SEPERATOR;
    bytes32 public constant LIMIT_ORDER_TYPEHASH = keccak256("LimitOrder(uint256 price,uint256 units,uint256 orderExpire,bool bid)");

    // Events
    event OrderSet(uint256 indexed price, uint256 indexed units, bool bid);

    // Constructor
    constructor(address usdc) {
        // Set USDC Address
        USDC = IERC20(usdc);

        // Domain Seperator
        DOMAIN_SEPERATOR = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                // This should match the domain you set in your client side signing.
                keccak256(bytes("LimitOrderToken")),
                keccak256(bytes("1")),
                block.chainid,
                address(this)
        ));
    }

    // Limit Order Hash
    function hashLimitOrder(LimitOrder memory limitOrder) private pure returns (bytes32) {
        return keccak256(
            abi.encode(
                LIMIT_ORDER_TYPEHASH,
                limitOrder.price,
                limitOrder.units,
                limitOrder.orderExpire,
                limitOrder.bid
        ));
    }

    // Verify Limit Order Hash
    function verifyLimitOrder() external {

    }

}
