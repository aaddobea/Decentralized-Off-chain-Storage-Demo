Generate a healthcare and key exchange smart contract between patient and doctor, where the patient shares the health data with the doctor but both the doctor and patient exchange session keys.

pragma solidity ^0.5.1;

// Healthcare and Key Exchange Smart Contract 
// between Patient and Doctor

contract HealthcareKeyExchange {

    // Events
    event KeyExchanged(address indexed from, address indexed to, bytes32 sessionKey);
    event HealthDataShared(address indexed from, address indexed to, bytes32 data);

    // Storage
    struct Patient {
        bytes32 publicKey;
        bytes32 healthData;
    }

    struct Doctor {
        bytes32 publicKey;
        bytes32 sessionKey;
    }

    mapping (address => Patient) public patients;
    mapping (address => Doctor) public doctors;

    // Constructor
    constructor() public {
        // set up the initial patient and doctor accounts 
        patients[msg.sender].publicKey = "patient_public_key";
        doctors[msg.sender].publicKey = "doctor_public_key";
    }

    // Share health data
    function shareHealthData(address _patient, bytes32 _data) public {
        // only the patient can share the data
        require(msg.sender == _patient);

        // store the health data of the patient
        patients[_patient].healthData = _data;

        // fire an event to indicate that the health data has been shared
        emit HealthDataShared(_patient, msg.sender, _data);
    }

    // Exchange keys
    function exchangeKeys(address _patient, bytes32 _sessionKey) public {
        // only the doctor can exchange the keys
        require(msg.sender == _patient);

        // store the session key of the doctor
        doctors[msg.sender].sessionKey = _sessionKey;

        // fire an event to indicate that the keys have been exchanged
        emit KeyExchanged(_patient, msg.sender, _sessionKey);
    }
}