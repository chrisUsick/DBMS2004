LOAD DATA
INFILE RentalAgreement.dat
APPEND INTO TABLE RentalAgreement
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY "'"
(AgreementID, CustID, AgreementDate, MovieCount, DurationID)
