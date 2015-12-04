REM import data from each csv file using their corresponding ctl file
@echo off
SQLLDR T118/T118@DBMSDBII CONTROL=RentalAgreement.ctl
SQLLDR T118/T118@DBMSDBII CONTROL=eBook.ctl
SQLLDR T118/T118@DBMSDBII CONTROL=BookRented.ctl
SQLLDR T118/T118@DBMSDBII CONTROL=Author.ctl
SQLLDR T118/T118@DBMSDBII CONTROL=BookAuthor.ctl