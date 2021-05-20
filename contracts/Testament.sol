// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";

contract Testament {
    // Library usage
    using Address for address payable;

    // Library usage
    address private _owner;
    address private _doctor;
    bool private _contractEnd;
    mapping(address => uint256) private _legacy;

    // Events
    event Bequeath(address indexed owner, address account, uint256 amount);
    event TestamentUpdate(
        address indexed owner,
        address account,
        bool contractEnd
    );
    event LegacyWithdrew(
        address indexed owner,
        address account,
        uint256 amount
    );

    // Constructor
    constructor(address owner_, address doctor_) {
        require(
            owner_ != doctor_,
            "Testament: You can't define the owner and the doctor as the same person."
        );
        _owner = owner_;
        _doctor = doctor_;
    }

    // Modifiers
    modifier onlyOwner() {
        require(
            msg.sender == _owner,
            "Testament: You are not allowed to use this function."
        );
        _;
    }
    modifier onlyDoctor() {
        require(
            msg.sender == _doctor,
            "Testament: You are not allowed to use this function."
        );
        _;
    }
    modifier contractOver() {
        require(
            _contractEnd == true,
            "Testament: The contract has not yet over."
        );
        _;
    }

    // Functions
    function bequeath(address account) external payable onlyOwner {
        _legacy[account] += msg.value;
        emit Bequeath(msg.sender, account, msg.value);
    }

    function setDoctor(address account) public onlyOwner {
        require(
            msg.sender != account,
            "Testament: You can't be set as doctor."
        );
        _doctor = account;
        emit TestamentUpdate(msg.sender, account, _contractEnd);
    }

    function contractEnd() public onlyDoctor {
        require(
            _contractEnd == false,
            "Testament: The contract is already over."
        );
        _contractEnd = true;
        emit TestamentUpdate(_owner, msg.sender, _contractEnd);
    }

    function withdraw() public contractOver {
        require(
            _legacy[msg.sender] != 0,
            "Testament: You do not have any legacy on this contract."
        );
        uint256 amount = _legacy[msg.sender];
        _legacy[msg.sender] = 0;
        payable(msg.sender).sendValue(amount);
        emit LegacyWithdrew(_owner, msg.sender, amount);
    }

    function legacy(address account) public view returns (uint256) {
        return _legacy[account];
    }

    function doctor() public view returns (address) {
        return _doctor;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function isContractOver() public view returns (bool) {
        return _contractEnd;
    }
}
