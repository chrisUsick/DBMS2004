CONN T118/T118@DBMSDBII;
ALTER SESSION SET NLS_NUMERIC_CHARACTERS=".,";
--SET ECHO OFF;
SET PAGESIZE 0;
SET LINESIZE 135;
--SET FEEDBACK OFF;
SPOOL 'file.sql';
column movies HEADING 'movies';
SELECT COUNT(*) movies from movie;
SELECT COUNT(*) from movieRented;
SELECT COUNT(*) from rentalAgreement;

SPOOL OFF;
EXIT;