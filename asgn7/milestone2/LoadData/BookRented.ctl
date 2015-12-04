LOAD DATA
INFILE BookRented.csv
APPEND INTO TABLE BookRented
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY "'"
(bookid, agreementID, rentalamount, rentalExpiry)