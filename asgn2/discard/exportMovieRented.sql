CONN T118/T118@DBMSDBII;
ALTER SESSION SET NLS_NUMERIC_CHARACTERS=".,";
SET ECHO OFF;
SET PAGESIZE 0;
SET LINESIZE 135;
SET FEEDBACK OFF;
SPOOL 'file.csv' APP;
SELECT RentalAmount || ',' || NVL(PercentReductionApplied, 0)
FROM MovieRented;
SPOOL OFF;
EXIT;