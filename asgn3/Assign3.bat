REM Chris Usick, 0274130
REM Section 1
REM Assignment 3
REM October 4, 2015
REM DOS application for generating a report.

@echo off
:showMenu
CLS
ECHO JR Movie Rentals 
echo
ECHO 1. Generate Report
ECHO 2. Exit
echo

SET /P menuChoice=Enter your choice: 
IF '%menuChoice%'=='1' (
	ECHO Report
) ELSE IF '%menuChoice%'=='2' (
	exit
) ELSE IF '%menuChoice%'=='' (
	echo Error - No choice entered. Please choose an option displayed.
	pause
	GOTO showMenu
) ELSE (
	echo Error - Invalid choice entered. Please choose a valid option.
	pause
	GOTO showMenu
)
GOTO showMenu