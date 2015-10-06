REM Chris Usick, 0274130
REM Section 1
REM Assignment 3
REM October 4, 2015
REM DOS application for generating a report.

@ECHO off

:showMenu
CLS
ECHO JR Movie Rentals 
ECHO
ECHO   1. Generate Report
ECHO   2. Exit
ECHO

SET /P menuChoice=Enter your choice: 
IF '%menuChoice%'=='1' (
	REM create spool file location if doesn't exist
	IF NOT EXIST C:\Users\Administrator\DBMSDBII\Reports\ (
		MKDIR C:\Users\Administrator\DBMSDBII\Reports\
	)
	REM run sql
	sqlplus /nolog @report.sql
	PAUSE
) ELSE IF '%menuChoice%'=='2' (
	EXIT
) ELSE IF '%menuChoice%'=='' (
	ECHO Error - No choice entered. Please choose an option displayed.
	PAUSE
	GOTO showMenu
) ELSE (
	ECHO Error - Invalid choice entered. Please choose a valid option.
	PAUSE
	GOTO showMenu
)
GOTO showMenu