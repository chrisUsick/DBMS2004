CONN T118/T118@DBMSDBII;
ALTER SESSION SET NLS_NUMERIC_CHARACTERS=".,";
SET ECHO OFF;
SET PAGESIZE 0;
SET LINESIZE 135;
SET FEEDBACK OFF;
SPOOL 'Usick_Chris.txt';
-- skip agreement 7
SELECT 	AgreementID AS "Agreement",
		FName AS "First Name", Name AS "Movie Name"
FROM Customer
NATURAL JOIN RentalAgreement
NATURAL JOIN MovieRented
-- joins on columns `MovieID` and `RentalAmount`
NATURAL JOIN Movie
WHERE CustID = 933;

-- isolated example of problem
-- SELECT 	AgreementID, Name
-- FROM MovieRented
-- -- inner join movie using (movieId)
-- NATURAL JOIN Movie
-- WHERE agreementID = 7;

-- shows agreement 7
-- SELECT 	AgreementID AS "Agreement",
		-- FName AS "First Name",
		-- M.Name AS "Movie Name"
-- FROM Movie M, Customer
-- NATURAL JOIN RentalAgreement
-- NATURAL JOIN MovieRented
-- WHERE CustID = 933
-- AND M.MovieID = MovieRented.MovieID
-- ;

SPOOL OFF;
EXIT;