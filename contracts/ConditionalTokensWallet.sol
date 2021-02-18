pragma solidity ^0.5.1;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./github/IERC1155.sol";
import "./github/IConditionalTokens.sol";

contract ConditionalTokensWallet is IERC1155TokenReceiver{
    IERC20 dai;
    IConditionalTokens conditionalTokens;
    address public oracle;
    mapping(bytes32 => mapping(uint=>uint)) public tokenBalance;
    address admin;

    constructor(
        address _dai,
        address _conditionalTokens,
        address _oracle
    ) public {
        dai = IERC20(_dai);
        conditionalTokens = IConditionalTokens(_conditionalTokens);
        oracle = _oracle;
        admin = msg.sender;
    }

    function redeemTokens(bytes32 conditionId, uint[] calldata indexSets)  external{
        conditionalTokens.redeemPositions(
            dai,
            bytes32(0),
            conditionId,
            indexSets
        );
    }

    function transferDai(address to, uint amount) external {
        require(msg.sender == admin, "only admin");
        dai.transfer(to, amount);
    }

    function onERC1155Received(
            address operator,
            address from,
            uint256 id,
            uint256 value,
            bytes calldata data
    )
    external
    returns(bytes4){
        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    }
    
    function onERC1155BatchReceived(
            address operator,
            address from,
            uint256[] calldata ids,
            uint256[] calldata values,
            bytes calldata data
    )
    external
    returns(bytes4){
        return bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"));
    }

}