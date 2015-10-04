REM delete the output file and execute the export script
@echo off
del file.csv
sqlplus /nolog @export.sql 