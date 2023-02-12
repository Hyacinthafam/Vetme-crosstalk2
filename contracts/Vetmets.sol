// contracts/Vetmets.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";
import "@routerprotocol/router-crosstalk/contracts/RouterSequencerCrossTalk.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./IStake.sol";

//import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//import "@openzeppelin-contracts/blob/v4.7.3/contracts/token/ERC20/ERC20.sol";




 /*contract Vetmets is ERC20{
     //address payable public owner;
     constructor(uint256 initialSuppy) ERC20("Vetmets", "VMT"){
        //owner = msg.sender;
         _mint(msg.sender, initialSuppy);
     }*/


contract Vetmets is ERC20Capped, ERC20Burnable {
    address payable public owner;
    uint256 public blockReward;



     constructor(uint256 cap, uint256 reward) ERC20("Vetmets", "VMT") ERC20Capped(cap * (10 ** decimals())) {
        owner = payable(msg.sender);
        _mint(owner, 70000000 * (10 ** decimals()));
        blockReward = reward * (10 ** decimals());
    }
   // using SafeERC20 for IERC20;
    // IStake public stakingContract;
    // IERC20 public immutable token;
    //uint256 public nonce;
    //mapping(uint256 => bytes32) public nonceToHash;
    

 
   //Start of vault
    /*constructor(uint256 cap, uint256 reward, address _token,
        address _sequencerHandler,
        address _erc20handler,
        address _reservehandler
        ) 
        RouterSequencerCrossTalk(
            _sequencerHandler,
            _erc20handler,
            _reservehandler
        )
        
        
        
        
    {
        token = IERC20(_token);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function setLinker(address _linker) external onlyRole(DEFAULT_ADMIN_ROLE) {
        setLink(_linker);
    }

    function setFeesToken(address _feeToken)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        setFeeToken(_feeToken);
    }

    function _approveFees(address _feeToken, uint256 _amount)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        approveFees(_feeToken, _amount);
    }

    function _approveTokens(
        address _toBeApproved,
        address _token,
        uint256 _value
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        approveTokens(_toBeApproved, _token, _value);
    }

    function setStakingContract(address _stakingContract)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        stakingContract = IStake(_stakingContract);
    }

    function stake(uint256 _amount) external {
        token.safeTransferFrom(msg.sender, address(this), _amount);
        stakingContract.stake(msg.sender, _amount);
    }

    function unstake(uint256 _amount) external {
        stakingContract.unstake(msg.sender, _amount);
    }

    function stakeCrossChain(
        uint8 _chainID,
        uint256 _crossChainGasLimit,
        uint256 _crossChainGasPrice,
        bytes memory _ercData,
        bytes calldata _swapData
    ) external returns (bytes32) {
        nonce = nonce + 1;
        bytes4 _selector = bytes4(
            keccak256("receiveStakeCrossChain(address,uint256)")
        );
        uint256 amount = abi.decode(_swapData, (uint256));
        bytes memory _data = abi.encode(msg.sender, amount);
        bytes memory _genericData = abi.encode(_selector, _data);
        Params memory params = Params(
            _chainID,
            _ercData,
            _swapData,
            _genericData,
            _crossChainGasLimit,
            _crossChainGasPrice,
            this.fetchFeeToken(),
            true,
            false
        );
        (bool success, bytes32 hash) = routerSend(params);
        nonceToHash[nonce] = hash;
        require(success, "Unsuccessful");
        return hash;
    }

    function receiveStakeCrossChain(address _user, uint256 _amount)
        external
        isSelf
    {
        stakingContract.stake(_user, _amount);
    }

    function _routerSyncHandler(bytes4 _selector, bytes memory _data)
        internal
        override
        returns (bool, bytes memory)
    {
        if (
            _selector ==
            bytes4(keccak256("receiveStakeCrossChain(address,uint256)"))
        ) {
            (address user, uint256 amount) = abi.decode(
                _data,
                (address, uint256)
            );
            (bool success, bytes memory data) = address(this).call(
                abi.encodeWithSelector(_selector, user, amount)
            );
            return (success, data);
        }

        return (true, "");
    }

    function replayTx(
        uint64 _nonce,
        uint256 crossChainGasLimit,
        uint256 crossChainGasPrice
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        routerReplay(
            nonceToHash[_nonce],
            crossChainGasLimit,
            crossChainGasPrice
        );
    }

    function recoverFeeTokens(address owner)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        address feeToken = this.fetchFeeToken();
        uint256 amount = IERC20(feeToken).balanceOf(address(this));
        IERC20(feeToken).transfer(owner, amount);
    } */
  //End of vault crosstalk


    
    function _mint(address account, uint256 amount) internal virtual override(ERC20Capped, ERC20) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }

    function _mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }

    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override {
        if(from != address(0) && to != block.coinbase && block.coinbase != address(0)) {
            _mintMinerReward();
        }
        super._beforeTokenTransfer(from, to, value);
    }

    function setBlockReward(uint256 reward) public onlyOwner {
        blockReward = reward * (10 ** decimals());
    }

    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
    
    
    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
    
}