@echo off
del file.csv
sqlplus /nolog @exportRentalAgreement.sql
sqlplus /nolog @exportMovieRented.sql
sqlplus /nolog @exportMovie.sql