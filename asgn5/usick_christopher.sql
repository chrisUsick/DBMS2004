-- Q 1
CREATE USER t118_jgarnet
IDENTIFIED BY dbpass;

CREATE USER t118_pBlat
IDENTIFIED BY dbpass;

CREATE USER t118_rseymore
IDENTIFIED BY dbpass;

-- Q 2
CREATE ROLE t118_Receptionist_Role;

GRANT SELECT 
ON Customer
TO t118_Receptionist_Role;

GRANT SELECT 
ON RentalAgreement
TO t118_Receptionist_Role;

GRANT SELECT 
ON MovieRented
TO t118_Receptionist_Role;

GRANT SELECT 
ON Movie
TO t118_Receptionist_Role;

-- Q 3
GRANT CREATE SESSION
TO t118_Receptionist_Role;

-- Q 4
GRANT t118_Receptionist_Role
TO t118_jgarnet;

-- Q 5
CREATE ROLE t118_Salesperson_Role;

GRANT CREATE SESSION
TO t118_Salesperson_Role;

GRANT SELECT 
ON Customer
TO t118_Salesperson_Role;

GRANT SELECT, INSERT
ON RentalAgreement
TO t118_Salesperson_Role;

GRANT SELECT, INSERT
ON MovieRented
TO t118_Salesperson_Role;

GRANT SELECT 
ON Movie
TO t118_Salesperson_Role;

-- Q 6
GRANT t118_Salesperson_Role
TO t118_pBlat;

-- Q 7
CREATE ROLE t118_SaleManager_Role
IDENTIFIED BY rpass;

GRANT SELECT, INSERT, UPDATE, DELETE
ON Customer
TO t118_SaleManager_Role;

GRANT SELECT, INSERT, UPDATE, DELETE
ON RentalAgreement
TO t118_SaleManager_Role;

GRANT SELECT, INSERT, UPDATE, DELETE
ON MovieRented
TO t118_SaleManager_Role;

GRANT SELECT, INSERT, UPDATE, DELETE
ON Movie
TO t118_SaleManager_Role;

-- Q 8
GRANT t118_SaleManager_Role, t118_Salesperson_Role
TO t118_rseymore;

ALTER USER t118_Salesperson_Role
DEFAULT ROLE t118_Salesperson_Role;

-- Q 9
SET ROLE t118_SaleManager_Role 
IDENTIFIED BY rpass;

-- Q 10
SET ROLE t118_Salesperson_Role;