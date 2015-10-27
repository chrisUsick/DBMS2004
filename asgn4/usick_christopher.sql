-- Section 1
-- Chris Usick
-- Assignment 4

-- Question 1
ALTER TABLE Customer
ADD CreditCardNumber NUMBER(12) DEFAULT NULL
-- constraint ensure that creditCardNumber is 12 digits
ADD CONSTRAINT CreditCardNumber_Unique CHECK (CreditCardNumber >= 100000000000)
;

-- Question 2
ALTER TABLE RentalAgreement
MODIFY (AgreementDate DEFAULT CURRENT_DATE);

-- Question 3
ALTER TABLE Customer
RENAME TO Client;

-- Question 4
ALTER TABLE Client
RENAME COLUMN PCode TO PostalCode;

-- Question 5
PURGE RecycleBin;

-- Question 6
CREATE SEQUENCE RA_Sequence 
START WITH 1000
INCREMENT BY 3
MAXVALUE 10000
MINVALUE 1
CYCLE
CACHE 5;

-- Question 7
INSERT INTO RentalAgreement (AgreementID, CustID, AgreementDate, MovieCount, DurationID)
VALUES (RA_Sequence.NEXTVAL,23,CURRENT_DATE,1,1);

-- Question 8 
INSERT INTO MovieRented (MovieID, AgreementID, RentalAmount, PercentReductionApplied)
VALUES (6, RA_Sequence.CURRVAL, 3.76, 0);

-- Question 9
CREATE PUBLIC SYNONYM Movies_T118 
FOR Movie;
GRANT ALL PRIVILEGES ON Movie
TO DJONES, TBROWN
;

-- Question 10
CREATE INDEX Names_Index 
ON Client 
( FName, 
  LName)
ONLINE;

-- Question 11
EXEC DBMS_STATS.GATHER_TABLE_STATS(ownname=>'T118', tabname=>'CLIENT', cascade=>TRUE);

-- Question 12
CREATE UNIQUE INDEX CreditCard_Index
ON Client (CreditCardNumber)
COMPUTE STATISTICS;

-- Question 13
EXEC DJones.BuildTables;

-- Question 14
ANALYZE INDEX SamplePK
VALIDATE STRUCTURE;

-- Question 15
SELECT Height, Blocks, BR_Blks,  LF_Blks, BR_Rows, LF_Rows
FROM Index_Stats;
-- a. 3 Levels in tree.
-- b. 16 blocks in the Index.
-- c. 1 block is a branch block
-- d. 5 blocks are leaf blocks
-- e. there are 4 branch rows
-- f. there are 2100 leaf rows 

-- Question 16
SELECT ROUND(Del_LF_Rows_len/LF_Rows_Len * 100) Balance_Ratio
FROM Index_Stats
WHERE NAME = 'SAMPLEPK'
;
-- balance ratio: 0
-- the index does not need to be rebuilt