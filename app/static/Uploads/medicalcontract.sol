pragma solidity ^0.5.1;
/*pragma experimental ABIEncoderV2;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract medicaldatacontract  is Ownable{
ID unint256;
age uint256;
phone number uint256;


    
    
    
    

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract HealthPort is Ownable {
     struct AlergyRecords {
        string substance;
        string category;
        string saverity;
        string reaction;
        uint256 createdAt;
    }
    struct MedicationRecords {
        string name;
        string dose;
        string frequency;
        string physician;
        uint256 createdAt;
    }
    struct ProcedureRecords {
        string procedure;
        uint256 procedureDate;
        uint256 createdAt;
    }
    mapping (address => AlergyRecords[])   alergyRecords;
    mapping (address => MedicationRecords[])  medicationRecords;
    mapping (address => ProcedureRecords[])   procedureRecords;

    event AlergyRecord(address indexed _user,uint256 timestamp);
    event MedicationRecord(address indexed _user,uint256 timestamp);
    event ProcedureRecord(address indexed _user,uint256 timestamp);

    mapping (address=> bool) admin;
    event Admin(address indexed user, bool status);
    
    constructor() public {
        admin[msg.sender] = true;
        emit Admin(msg.sender,true);

    }
    
     /**
     * @dev Throws if called by any account other than the admin.
     */
    modifier onlyAdmin() {
        require(admin[msg.sender]);
        _;
    }
    
    function updateAdmin(address user, bool status) onlyOwner external {
        admin[user] = status;
        emit Admin(user,status);
    }
    //insert alergy records in smart contract
    function insertAlergyRecord (address user,  string memory _substance, string memory _category,string memory _saverity,string memory  _reaction) public onlyAdmin{
            AlergyRecords memory alergyRecord;
            alergyRecord.substance = _substance;
            alergyRecord.category = _category;
            alergyRecord.saverity = _saverity;
            alergyRecord.reaction = _reaction;
            alergyRecord.createdAt = block.timestamp;
            alergyRecords[user].push(alergyRecord);
            emit AlergyRecord(user,block.timestamp);
    }
    
    function getAlergyRecords() external view  returns (AlergyRecords  [] memory)
    {
       return alergyRecords[msg.sender];
    }
    
    function getAlergyRecords(address user) onlyAdmin external view  returns (AlergyRecords  [] memory)
    {
       return alergyRecords[user];
    }
        //insert Medication records in smart contract
    function insertMedicationRecord (address user,string memory name,string memory dose, string memory frequency, string memory physician) public onlyAdmin {
        MedicationRecords memory medicationRecord;
        medicationRecord.name = name;
        medicationRecord.dose = dose;
        medicationRecord.frequency = frequency;
        medicationRecord.physician = physician;
        medicationRecord.createdAt = block.timestamp;
        medicationRecords[user].push(medicationRecord);
        emit MedicationRecord(user,block.timestamp);
    }
    
    function getMedicationRecords() external view  returns (MedicationRecords  [] memory)
    {
       return medicationRecords[msg.sender];
    }
    
    function getMedicationRecords(address user) onlyAdmin external view  returns (MedicationRecords  [] memory)
    {
       return medicationRecords[user];
    }   
    //insert Procedure records in smart contract
    function insertProcedureRecord (address user, string memory procedure, uint256 procedureDate) public onlyAdmin {
        ProcedureRecords memory procedureRecord;
        procedureRecord.procedure = procedure;
        procedureRecord.procedureDate = procedureDate;
        procedureRecord.createdAt = block.timestamp;
        procedureRecords[user].push(procedureRecord);
        emit ProcedureRecord(user,block.timestamp);
    }
    
    function getProcedureRecords() external view  returns (ProcedureRecords  [] memory)
    {
       return procedureRecords[msg.sender];
    }
    
    function getProcedureRecords(address user) onlyAdmin external view  returns (ProcedureRecords  [] memory)
    {
       return procedureRecords[user];
    }
}