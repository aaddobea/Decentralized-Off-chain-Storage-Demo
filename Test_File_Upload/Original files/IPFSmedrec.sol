// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the IPFS library for handling IPFS interactions
import "./IPFSInterface.sol";

contract MedicalRecords {
    // IPFS contract interface
    IPFSInterface private ipfsContract;

    // Mapping to store the hash of signcrypted data for each patient
    mapping(address => bytes32) private patientHashes;

    // Mapping to store doctor access permissions
    mapping(address => bool) private doctors;

    // Events to log actions
    event MedicalRecordUploaded(address indexed patient, bytes32 indexed hash);
    event DoctorAdded(address indexed doctor);
    event AccessGranted(address indexed patient, address indexed doctor);
    event AccessRevoked(address indexed patient, address indexed doctor);

    constructor(address _ipfsContractAddress) {
        ipfsContract = IPFSInterface(_ipfsContractAddress);
    }

    // Modifier to restrict access to only authorized doctors
    modifier onlyDoctor() {
        require(doctors[msg.sender], "Only authorized doctors can access.");
        _;
    }

    // Patients can upload their medical data hash
    function uploadMedicalRecord(bytes32 _hash) external {
        patientHashes[msg.sender] = _hash;
        emit MedicalRecordUploaded(msg.sender, _hash);
    }

    // Doctors can be added by the contract owner (administrator)
    function addDoctor(address _doctor) external onlyOwner {
        doctors[_doctor] = true;
        emit DoctorAdded(_doctor);
    }

    // Grant access to a specific doctor for a specific patient's record
    function grantAccess(address _doctor) external {
        require(patientHashes[msg.sender] != 0, "Patient has no medical record.");
        doctors[_doctor] = true;
        emit AccessGranted(msg.sender, _doctor);
    }

    // Revoke access from a specific doctor for a specific patient's record
    function revokeAccess(address _doctor) external {
        doctors[_doctor] = false;
        emit AccessRevoked(msg.sender, _doctor);
    }

    // Doctor retrieves signcrypted data hash from IPFS using patient's hash
    function retrieveMedicalData() external view onlyDoctor returns (bytes memory) {
        require(patientHashes[msg.sender] != 0, "No access to patient's medical data.");
        bytes32 patientHash = patientHashes[msg.sender];
        bytes memory medicalDataHash = ipfsContract.retrieveData(patientHash);
        return medicalDataHash;
    }
}
