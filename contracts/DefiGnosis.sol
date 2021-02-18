pragma solidity ^0.5.1;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./github/IERC1155.sol";
import "./github/IConditionalTokens.sol";

contract DefiGnosis{
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

    function createbet(bytes32 questionId, uint amount) eexternal{
        conditionalTokens.prepareCondition(
            oracle,
            questionId,
            3
        );
        
        bytes32 conditionId = conditionalTokens.getConditionId(
            oracle,
            questionId,
            3
        );

        uint[] memory partition = new uint[](2);
        partition[0] = 1;
        partition[1] = 3;

        dai.approve(address(conditionTokens), amount);
        conditionalTokens.splitPosition(
            dai,
            bytes32(0),
            conditionId,
            partition,
            amount
        );

        tokenBalance[questionId][0] = amount;
        tokenBalance[questionId][1] = amount;

    
       
    }

    function transferTokens(
        bytes32 questionId,
        uint indexSet,
        address to,
        uint amount
    ) external {
        require(msg.sender == admin, "only admin");
        require(tokenBalance[questionId][indexSet] >= amount, "not enough tokens");

        bytes32 conditionId = conditionalTokens.getConditionId(
            oracle,
            questionId,
            3
        );
        bytes32 collectionId = conditionalTokens.getCollectionId(
            bytes32(0),
            conditionId,
            indexSet
        );
        uint positionId = conditionalTokens.getPositionId(
            dai,
            collectionId
        );

        conditionalTokens.safeTransaction(
            address(this),
            to,
            positionId,
            amount,
            ""
        );
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
