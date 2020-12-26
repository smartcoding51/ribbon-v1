// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import {OptionType} from "../adapters/IProtocolAdapter.sol";

interface IAggregatedOptionsInstrument {
    function getBestTrade(uint256 purchaseAmount)
        external
        view
        returns (
            string[] memory venues,
            uint8[] memory optionTypes,
            uint256[] memory amounts,
            uint256[] memory premiums
        );

    function buyInstrument(
        string[] calldata venues,
        OptionType[] calldata optionTypes,
        uint256[] calldata amounts
    ) external payable returns (uint256 positionID);

    function exercise(uint256 positionID) external returns (uint256 profit);
}

interface IVaultedInstrument {
    // Deposit and minting processes
    function deposit(uint256 collateralAmount) external payable;

    function mint(uint256 tokenAmount) external;

    function depositAndMint(uint256 collateralAmount, uint256 tokenAmount)
        external
        payable;

    function depositMintAndSell(
        uint256 collateral,
        uint256 dToken,
        uint256 maxSlippage
    ) external payable;

    // Withdrawals
    function withdrawAfterExpiry() external;

    // Debt repayment
    function repayDebt(address vault, uint256 debtAmount) external;

    // Redemption and settlement
    function settle() external;

    function redeem(uint256 tokenAmount) external;
}

interface IInstrumentStorage {
    function name() external view returns (string memory);

    function dToken() external view returns (address);

    function symbol() external view returns (string memory);
}
