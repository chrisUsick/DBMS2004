-- Chris Usick, 0274130
-- Section 1
-- Assignment 7
-- Milestone 1
-- December 1, 2015
-- Modify the JR Movie Rentals schema to accomodate renting eBooks

-- DROP TABLE statements 
DROP TABLE BookRented;
DROP TABLE BookAuthor;
DROP TABLE eBook;

-- Create tables 
CREATE TABLE eBook (
	BookID 			NUMBER(5,0) NOT NULL,
	ISBN				CHAR(13),
	Title				VARCHAR2(100) NOT NULL,
	Publisher 	VARCHAR2(100) NOT NULL,
	Published 	DATE, 		
	NoOfPages		NUMBER(4,0),
	RentalCost  NUMBER(5,2) 	NOT NULL,
	CONSTRAINT eBookPK
		PRIMARY KEY (BookID),
	CONSTRAINT ISBNUnique
		UNIQUE (ISBN),
	CONSTRAINT RentalCostPositive
		CHECK (RentalCost > 0)
);

CREATE TABLE BookAuthor (
	BookID 					NUMBER(5, 0) NOT NULL,
	ContributorID		NUMBER(5, 0) NOT NULL,
	CONSTRAINT BookAuthorPK
		PRIMARY KEY (BookID, ContributorID)
);

CREATE TABLE BookRented (
	BookID 				NUMBER(5, 0) NOT NULL,
	AgreementID 	NUMBER(5, 0) NOT NULL,
	RentalAmount	NUMBER(5, 2) NOT NULL,
	RentalExpiry	DATE				 NOT NULL,
	CONSTRAINT BookRentedPK
		PRIMARY KEY (BookID, AgreementID)
);

-- Add foreign keys
ALTER TABLE BookAuthor 
	ADD CONSTRAINT CreatesFK
		FOREIGN KEY (BookID)
		REFERENCES eBook;
		
ALTER TABLE BookAuthor
	ADD CONSTRAINT ContributesFK 
		FOREIGN KEY (ContributorID)
		REFERENCES Contributor;
		
ALTER TABLE BookRented
	ADD CONSTRAINT RentedFK 
		FOREIGN KEY (BookID)
		REFERENCES eBook;
		
ALTER TABLE BookRented
	ADD CONSTRAINT RentsOutFK
		FOREIGN KEY (AgreementID)
		REFERENCES RentalAgreement;
		
-- Modify RentalAgreement
ALTER TABLE RentalAgreement
	RENAME COLUMN MovieCount TO ItemCount;
	
ALTER TABLE RentalAgreement
	ADD RentalType 	CHAR(1) DEFAULT ' ' NOT NULL;

-- must make data valid before adding constraint
UPDATE RentalAgreement
	SET RentalType = 'M';

ALTER TABLE RentalAgreement
	ADD CONSTRAINT RentalTypeCheck 
	CHECK (RentalType IN ('M', 'B'));
	
