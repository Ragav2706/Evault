
pragma solidity ^0.8.0;

contract LegalRecordManagement {

    struct LegalRecord {
        string caseNumber;
        string clientName;
        string description;
        int256 lawyerFee; 
    }

    mapping(string => LegalRecord) legalRecords;

    event LegalRecordCreated(string indexed caseNumber, string clientName, string description, int256 lawyerFee);

    event LegalRecordRemoved(string indexed caseNumber);

    function addLegalRecord(string memory _caseNumber, string memory _clientName, string memory _description, int256 _lawyerFee) public payable {
        require(bytes(legalRecords[_caseNumber].caseNumber).length == 0, "Legal record already exists");

        LegalRecord memory newLegalRecord = LegalRecord({
            caseNumber: _caseNumber,
            clientName: _clientName,
            description: _description,
            lawyerFee: _lawyerFee
        });

        legalRecords[_caseNumber] = newLegalRecord;

        emit LegalRecordCreated(_caseNumber, _clientName, _description, _lawyerFee);

        payable(msg.sender).transfer(uint256(_lawyerFee));
    }

    function getLegalRecord(string memory _caseNumber) public view returns (string memory, string memory, string memory, int256) {
        require(bytes(legalRecords[_caseNumber].caseNumber).length > 0, "Legal record not found");

        return (
            legalRecords[_caseNumber].caseNumber,
            legalRecords[_caseNumber].clientName,
            legalRecords[_caseNumber].description,
            legalRecords[_caseNumber].lawyerFee
        );
    }

    function removeLegalRecord(string memory _caseNumber) public {
        require(bytes(legalRecords[_caseNumber].caseNumber).length > 0, "Legal record not found");

        delete legalRecords[_caseNumber];
        emit LegalRecordRemoved(_caseNumber);
    }
}