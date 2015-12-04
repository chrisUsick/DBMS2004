LOAD DATA
INFILE RentalAgreement.csv
APPEND INTO TABLE RentalAgreement
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY "'"
(AgreementID, CustID, AgreementDate, ItemCount,DurationID,RentalType)