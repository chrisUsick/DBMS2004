CONN T118/T118@DBMSDBII;
ALTER SESSION SET NLS_NUMERIC_CHARACTERS=".,";
SET ECHO OFF;
SET PAGESIZE 0;
SET LINESIZE 135;
SET FEEDBACK OFF;
-- output the data to file.csv
SPOOL 'file.csv' APP;
SELECT 	CustID || ',' || 
		AgreementDate || ',' ||
		RentalAmount || ',' || 
		NVL(PercentReductionApplied, 0) || ',' || 
		MovieID || ',' || 
		Name || ',' || 
		DECODE(Released, NULL, 'Unknown', TO_CHAR(Released))
FROM Movie NATURAL JOIN MovieRented NATURAL JOIN RentalAgreement
WHERE EXTRACT(MONTH FROM AgreementDate) = EXTRACT(MONTH FROM ADD_MONTHS(CURRENT_DATE, -1));
SPOOL OFF;
EXIT;