REM import data from each dat file using their corresponding ctl file
@echo off
SQLLDR T118/T118@DBMSDBII CONTROL=Customer.ctl
SQLLDR T118/T118@DBMSDBII CONTROL=RentalAgreement.ctl
SQLLDR T118/T118@DBMSDBII CONTROL=MovieRented.ctl

pause