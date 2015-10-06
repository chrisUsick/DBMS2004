-- Chris Usick, 0274130
-- Section 1
-- Assignment 3
-- October 4, 2015
-- DOS application for generating a report.
CONN T118/T118@DBMSDBII;
SET ECHO OFF
SET PAGESIZE 30
SET LINESIZE 120
SET FEEDBACK OFF

-- column format
COLUMN AgreementID HEADING 'Agreement'
COLUMN MovieName FORMAT A55 HEADING  'Movie Name'
COLUMN AgreementDate FORMAT A12 HEADING  'Date'
COLUMN 'Paid' FORMAT $999.99 HEADING 'Paid'

BREAK ON AgreementID SKIP ON REPORT ON 'First Name' ON 'Last Name'
ACCEPT CustomerId Number FORMAT 999 PROMPT 'Customer ID:  '
-- total
COMPUTE SUM LABEL 'Total' OF 'Paid' ON REPORT
-- titles 
TTITLE CENTER 'Movie Rental Details for Client &CustomerId' - 
RIGHT 'Page: ' FORMAT 9 SQL.PNO SKIP 2
BTITLE LEFT 'Run By:'SQL.USER CENTER 'End of Report'

SPOOL C:\Users\Administrator\DBMSDBII\Reports\Usick_Chris.txt

-- query
SELECT 	AgreementID,
		SUBSTR(FName, 1,15) AS "First Name",
		SUBSTR(LName, 1,15) AS "Last Name",
		AgreementDate,
		SUBSTR(M.Name, 1, 55) MovieName,
		RentalAmount AS "Paid"
FROM Customer
NATURAL JOIN RentalAgreement
NATURAL JOIN MovieRented
INNER JOIN Movie M 
	ON (MovieRented.MovieID = M.MovieID)
WHERE CustID = &CustomerId
ORDER BY AgreementID
;
SPOOL OFF
EXIT