-- Chris Usick, 0274130
-- Section 1
-- Assignment 3
-- October 4, 2015
-- DOS application for generating a report.
CONN T118/T118@DBMSDBII;
ALTER SESSION SET NLS_NUMERIC_CHARACTERS=".,";
SET ECHO OFF;
SET PAGESIZE 30;
SET LINESIZE 120;
SET FEEDBACK OFF;
SPOOL 'C:\Users\Administrator\DBMSDBII\Reports\Usick_Chris.txt';

ACCEPT CustomerId CHAR FORMAT '999' PROMPT 'Customer ID:  ';
-- titles 
TTITLE CENTER 'Movie Rental Details for Client     ' &CustomerId - 
RIGHT 'Page: ' FORMAT 9 SQL.PNO SKIP 2;
BTITLE LEFT 'Run By:'SQL.USER CENTER 'End of Report';

-- total
COMPUTE SUM LABEL 'Total' OF RentalAmount on REPORT
BREAK ON REPORT

-- column format
COLUMN AgreementID HEADING 'Agreement'
BREAK ON AgreementID
COLUMN FName FORMAT 'A15' HEADING 'First Name'
COLUMN LName FORMAT 'A15' HEADING  'Last Name'
COLUMN MovieName FORMAT 'A55' HEADING  'Movie Name'
COLUMN AgreementDate FORMAT 'A12' HEADING  'Date'
COLUMN RentalAmount FORMAT '$99.99' HEADING 'Paid'

-- query
SELECT 	AgreementID,
		FName,
		LName,
		AgreementDate,
		SUBSTR(M.Name, 1, 55) MovieName,
		RentalAmount
FROM Customer
NATURAL JOIN RentalAgreement
NATURAL JOIN MovieRented
INNER JOIN Movie M 
	ON (MovieRented.MovieID = M.MovieID)
WHERE CustID = &CustomerId
ORDER BY AgreementID
;
SPOOL OFF;
EXIT;