CONN T118/T118@DBMSDBII;
ALTER SESSION SET NLS_NUMERIC_CHARACTERS=".,";
SET ECHO OFF;
SET PAGESIZE 0;
SET LINESIZE 135;
SET FEEDBACK OFF;
SPOOL 'file.csv' APP;
SELECT CustID || ',' || AgreementDate
FROM RentalAgreement
WHERE EXTRACT(MONTH FROM AgreementDate) = EXTRACT(MONTH FROM ADD_MONTHS(CURRENT_DATE, -1));
SPOOL OFF;
EXIT;