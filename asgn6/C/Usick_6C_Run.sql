-- Chris Usick, 0274130
-- Section 1
-- Assignment 6
-- Novemeber 16, 2015
-- Extract tables from database

CONN T118/T118@DBMSDBII;
SET ECHO OFF
SET FEEDBACK OFF
SET SERVEROUTPUT ON SIZE 10000 FORMAT TRUNCATED
-- spool settings etc.
SPOOL 'Create_Tables_Usick.sql'
EXEC Extract_Tables;

SPOOL OFF;
EXIT;