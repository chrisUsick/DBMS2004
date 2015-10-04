CONN T118/T118@DBMSDBII;
ALTER SESSION SET NLS_NUMERIC_CHARACTERS=".,";
SET ECHO OFF;
SET PAGESIZE 0;
SET LINESIZE 135;
SET FEEDBACK OFF;
SPOOL 'file.sql';

ACCEPT columnName CHAR FORMAT 'A7' PROMPT 'Enter employee lastname:  '
SELECT Name, &columnName
FROM movie natural join movierented
where rownum <= 10;
SPOOL OFF;
EXIT;