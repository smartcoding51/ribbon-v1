// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import "./lib/DSMath.sol";
import "./lib/upgrades/Initializable.sol";
import "./interfaces/BalancerInterface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

contract Balancer is DSMath, Initializable {
    using SafeERC20 for IERC20;

    address private _dToken;
    address private _paymentToken;
    BalancerPool private _balancerPool;

    /**
     * @notice Emitted when a user sells their tokens to the balancer pool via this contract
     */
    event SoldToBalancerPool(
        address seller,
        address balancerPool,
        address tokenIn,
        address tokenOut,
        uint256 sellAmount,
        uint256 maxSlippage
    );

    /**
     * @notice Initializes the contract with params and creates a new pool, with address(this) as the pool's controller.
     * @param bFactory is the address of the Balancer Core Factory
     * @param dToken is the address of the instrument dToken
     * @param paymentToken is the address of the paymentToken (the token sellers get when selling dToken)
     */
    function initialize(
        address bFactory,
        address dToken,
        address paymentToken
    ) public initializer {
        _dToken = dToken;
        _paymentToken = paymentToken;
        _balancerPool = newPool(bFactory, dToken, paymentToken);
    }

    /**
     * @notice Creates a new pool with 50/50 weights between dToken and the paymentToken. The pool also gets finalized right after creation, which means the settings are set in stone.
     * @param bFactory is the address of the Balancer Core Factory
     * @param dToken is the address of the instrument dToken
     * @param paymentToken is the address of the paymentToken (the token sellers get when selling dToken)
     */
    function newPool(
        address bFactory,
        address dToken,
        address paymentToken
    ) private returns (BalancerPool) {
        BalancerFactory balancerFactory = BalancerFactory(bFactory);
        BalancerPool pool = balancerFactory.newBPool();

        // We need to set the weights for dToken and paymentToken to be equal i.e. 50/50
        // https://docs.balancer.finance/protocol/concepts#terminology
        // pool.bind(dToken, 0, 1);
        // pool.bind(paymentToken, 0, 1);
        // pool.finalize();

        return pool;
    }

    /**
     * @notice Sell _sellAmount worth of dTokens to the Balancer pool and get tokenAmountOut worth of paymentTokens in return
     * @param _sellAmount is the amount of dTokens to sell. All of the tokens will be sold.
     */
    function sellToPool(uint256 _sellAmount, uint256 _maxSlippage)
        public
        returns (uint256 tokenAmountOut, uint256 spotPriceAfter)
    {
        address dToken = _dToken;
        address paymentToken = _paymentToken;
        BalancerPool balancerPool = _balancerPool;
        uint256 spot = balancerPool.getSpotPrice(dToken, _paymentToken);
        uint256 maxPrice = wmul(spot, add(1 ether, _maxSlippage));
        uint256 minAmountOut = wdiv(_sellAmount, maxPrice);

        // we need to approve the transfer beforehand
        IERC20(dToken).approve(address(balancerPool), _sellAmount);

        (tokenAmountOut, spotPriceAfter) = _balancerPool.swapExactAmountIn(
            _dToken,
            _sellAmount,
            paymentToken,
            minAmountOut,
            maxPrice
        );

        // After swapping, we need to rescind the allowance for the balancer pool
        // Allowances depend on the implementation of the ERC20 contract so
        // it's possible that an ERC20 token doesn't reduce the allowance after a transferFrom
        // BONUS: It gives a gas refund for setting the allowance to zero.
        IERC20(dToken).approve(address(balancerPool), 0);

        // After the swap is complete, we need to transfer the swapped tokens back to the msg.sender
        require(
            IERC20(paymentToken).transfer(msg.sender, tokenAmountOut),
            "Token out transfer fail"
        );

        emit SoldToBalancerPool(
            msg.sender,
            address(balancerPool),
            dToken,
            paymentToken,
            _sellAmount,
            _maxSlippage
        );
    }

    // GETTERS

    /**
     * @notice Returns the stored dToken
     */
    function balancerDToken() public view returns (address) {
        return _dToken;
    }

    /**
     * @notice Returns the payment token
     */
    function balancerPaymentToken() public view returns (address) {
        return _paymentToken;
    }

    /**
     * @notice Returns the created balancer pool
     */
    function balancerPool() public view returns (address) {
        return address(_balancerPool);
    }
}