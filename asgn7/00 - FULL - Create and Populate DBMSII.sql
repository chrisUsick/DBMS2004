--****************************************************************************************************
-- This procedure is the set-up script required for the DBMS-2004 final project.
-- The script executes the 'cleanup' procedure to delete all schema objects.
-- It then re-creates the JR Movie Rental database.
--
-- Author: David A Jones
-- Date: Sept 1, 2015
--
-- Revision Log  Date Revised  Reason for revision
-- ============  ============  ========================================================================
-- 
--****************************************************************************************************
--
-- Delete everything in the current schema
--
EXEC cleanup;

--
-- Recreate the required tables
--
CREATE TABLE ValidDuration (
 DurationID NUMERIC(2) NOT NULL,
 Name CHAR(15) NOT NULL,
 Duration NUMERIC(2) NOT NULL,
 CONSTRAINT PK_ValidDurations 
 PRIMARY KEY (DurationID)
);

CREATE TABLE VolumePromotion (
 MinMovies NUMERIC(2) NOT NULL,
 MaxMovies NUMERIC(2,0),
 Duration NUMERIC(2) NOT NULL,
 PercentReduction NUMERIC(4,2) NOT NULL
);

CREATE TABLE Rating (
 RatingID CHAR(3) NOT NULL,
 RatingType CHAR(30),
 Description VARCHAR(100),
 CONSTRAINT PK_Rating 
 PRIMARY KEY (RatingID)
);

CREATE TABLE Genre (
 GenreID CHAR(2) NOT NULL,
 GenreType VARCHAR(50) NOT NULL,
 CONSTRAINT PK_Genre 
 PRIMARY KEY (GenreID)
);

CREATE TABLE Customer (
 CustID NUMERIC(5) NOT NULL,
 FName CHAR(25) NOT NULL,
 LName VARCHAR(50) NOT NULL,
 StreetNo NUMERIC(5),
 Street VARCHAR(100),
 City VARCHAR(25),
 Province CHAR(2),
 PCode CHAR(7),
 PrimaryCustID NUMERIC(5),
 CONSTRAINT PK_Customers 
 PRIMARY KEY (CustID)
);

CREATE TABLE Contributor (
 ContributorID NUMERIC(5) NOT NULL,
 FName VARCHAR(50),
 MName VARCHAR(50),
 LName VARCHAR(50),
 MusicalGroup VARCHAR(100),
 CONSTRAINT PK_Contributor 
 PRIMARY KEY (ContributorID)
);

CREATE TABLE Distributor (
 DistributorID NUMERIC(10) NOT NULL,
 DistributorName VARCHAR(100) NOT NULL,
 CONSTRAINT PK_Distributor 
 PRIMARY KEY (DistributorID)
);

CREATE TABLE Movie (
 MovieID NUMERIC(7) NOT NULL,
 Name VARCHAR(100) NOT NULL,
 Released DATE,
 DistributionCost NUMERIC(5,2) NOT NULL,
 RentalAmount NUMERIC(5,2) NOT NULL,
 Stars NUMERIC(2),
 RatingID CHAR(3),
 CONSTRAINT PK_Movies 
 PRIMARY KEY (MovieID)
);

CREATE TABLE RentalAgreement (
 AgreementID NUMERIC(5) NOT NULL,
 CustID NUMERIC(5) NOT NULL,
 AgreementDate DATE NOT NULL,
 MovieCount NUMERIC(3),
 DurationID NUMERIC(2) NOT NULL,
 CONSTRAINT PK_RentalAgreement 
 PRIMARY KEY (AgreementID)
);

CREATE TABLE Song (
 SongID NUMERIC(5) NOT NULL,
 Name VARCHAR(150) NOT NULL,
 CONSTRAINT PK_Songs 
 PRIMARY KEY (SongID)
);

CREATE TABLE MovieActor (
 MovieID NUMERIC(7) NOT NULL,
 ContributorID NUMERIC(5) NOT NULL,
 Billing CHAR(10),
 CONSTRAINT PK_MovieActors 
 PRIMARY KEY (MovieID,ContributorID)
);

CREATE TABLE MovieDistributor (
 MovieID NUMERIC(7) NOT NULL,
 DistributorID NUMERIC(10) NOT NULL,
 CONSTRAINT PK_MovieDistributor 
 PRIMARY KEY (MovieID,DistributorID)
);

CREATE TABLE MovieGenre (
 MovieID NUMERIC(7) NOT NULL,
 GenreID CHAR(2) NOT NULL,
 CONSTRAINT PK_MovieGenre 
 PRIMARY KEY (MovieID,GenreID)
);

CREATE TABLE MovieSong (
 MovieID NUMERIC(7) NOT NULL,
 SongID NUMERIC(5) NOT NULL,
 CONSTRAINT PK_MovieSongs 
 PRIMARY KEY (MovieID,SongID)
);

CREATE TABLE MovieRented (
 MovieID NUMERIC(7) NOT NULL,
 AgreementID NUMERIC(5) NOT NULL,
 RentalAmount NUMERIC(5,2) NOT NULL,
 PercentReductionApplied NUMERIC(4,2),
 CONSTRAINT PK_MoviesRented 
 PRIMARY KEY (MovieID, AgreementID)
);

CREATE TABLE SongAuthor (
 SongID NUMERIC(5) NOT NULL,
 ContributorID NUMERIC(5) NOT NULL,
 CONSTRAINT PK_SongAuthors 
 PRIMARY KEY (SongID,ContributorID)
);

CREATE TABLE SongPerformer (
 SongID NUMERIC(5) NOT NULL,
 ContributorID NUMERIC(5) NOT NULL,
 Featured CHAR(1),
 CONSTRAINT PK_SongPerformer 
 PRIMARY KEY (SongID,ContributorID)
);

--
-- Alter on the Foreign Keys
--
ALTER TABLE Customer
ADD CONSTRAINT FK_Customers_0 
FOREIGN KEY (PrimaryCustID) 
REFERENCES Customer (CustID);

ALTER TABLE Movie
ADD CONSTRAINT FK_Movies_0 
FOREIGN KEY (RatingID) 
REFERENCES Rating (RatingID);

ALTER TABLE RentalAgreement 
ADD CONSTRAINT FK_RentalAgreement_0 
FOREIGN KEY (CustID) 
REFERENCES Customer (CustID);

ALTER TABLE RentalAgreement 
ADD CONSTRAINT FK_RentalAgreement_1 
FOREIGN KEY (DurationID) 
REFERENCES ValidDuration (DurationID);


ALTER TABLE MovieActor
ADD CONSTRAINT FK_MovieActors_0 
FOREIGN KEY (ContributorID) 
REFERENCES Contributor (ContributorID);

ALTER TABLE MovieActor
ADD CONSTRAINT FK_MovieActors_1 
FOREIGN KEY (MovieID) 
REFERENCES Movie (MovieID);


ALTER TABLE MovieDistributor 
ADD CONSTRAINT FK_MovieDistributor_0 
FOREIGN KEY (DistributorID) 
REFERENCES Distributor (DistributorID);

ALTER TABLE MovieDistributor 
ADD CONSTRAINT FK_MovieDistributor_1 
FOREIGN KEY (MovieID) 
REFERENCES Movie (MovieID);


ALTER TABLE MovieGenre 
ADD CONSTRAINT FK_MovieGenre_0 
FOREIGN KEY (MovieID) 
REFERENCES Movie (MovieID);

ALTER TABLE MovieGenre 
ADD CONSTRAINT FK_MovieGenre_1 
FOREIGN KEY (GenreID) 
REFERENCES Genre (GenreID);


ALTER TABLE MovieSong
ADD CONSTRAINT FK_MovieSongs_0 
FOREIGN KEY (MovieID) 
REFERENCES Movie (MovieID);

ALTER TABLE MovieSong 
ADD CONSTRAINT FK_MovieSongs_1 
FOREIGN KEY (SongID) 
REFERENCES Song (SongID);


ALTER TABLE MovieRented 
ADD CONSTRAINT FK_MoviesRented_0 
FOREIGN KEY (AgreementID) 
REFERENCES RentalAgreement (AgreementID);

ALTER TABLE MovieRented 
ADD CONSTRAINT FK_MoviesRented_1 
FOREIGN KEY (MovieID) 
REFERENCES Movie (MovieID);


ALTER TABLE SongAuthor
ADD CONSTRAINT FK_SongAuthors_0 
FOREIGN KEY (SongID) 
REFERENCES Song (SongID);

ALTER TABLE SongAuthor
ADD CONSTRAINT FK_SongAuthors_1 
FOREIGN KEY (ContributorID) 
REFERENCES Contributor (ContributorID);

ALTER TABLE SongPerformer 
ADD CONSTRAINT FK_SongPerformer_0 
FOREIGN KEY (SongID) 
REFERENCES Song (SongID);

ALTER TABLE SongPerformer 
ADD CONSTRAINT FK_SongPerformer_1 
FOREIGN KEY (ContributorID) 
REFERENCES Contributor (ContributorID);

ALTER TABLE Contributor
ADD CONSTRAINT ContributorName
CHECK (FName IS NOT NULL OR MusicalGroup IS NOT NULL);

--
--This statement allows data to contain an ampersand
--LEAVE IT IN!!
--
SET DEFINE OFF

--
--Insert data into all the tables
--
INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(23, 'Al', 'Dente', 17, 'Rosedale Ave', 'Halifax', 'NS', 'B3N 2J2', null );

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(44, 'Tom', 'Dente', 17, 'Rosedale Ave', 'Halifax', 'NS', 'B3N 2J2', 23);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(48, 'Wendy', 'Dente', 17, 'Rosedale Ave', 'Halifax', 'NS', 'B3N 2J2', 23);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(135, 'April', 'May', 5275, 'Vestry St', 'Halifax', 'NS', 'B3K 2N9', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(136, 'Billy', 'Rubin', 3440, 'Bright St', 'Halifax', 'NS', 'B3K 4Z3',  null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(163, 'Bud', 'Light', 6301, 'Coburg Rd', 'Halifax', 'NS', 'B3H 1Y8', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(164, 'Cara', 'Van', 2630, 'Gottingen Rd', 'Halifax', 'NS', 'B3K 3C6',  null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(181, 'Doug', 'Hole', 210, 'Hammonds Plains Road', 'Halifax', 'NS', 'B4A 3P6', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(252, 'Forrest', 'Green', 90, 'Armstrong Rd', 'Halifax', 'NS', 'B3M 4N5', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(256, 'Gail', 'Force', 30, 'Idlewylde Rd', 'Halifax', 'NS', 'B3N 1B9', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(261, 'Hazle', 'Nutt', 5142, 'Lady Hammond Rd', 'Halifax', 'NS', 'B3K 2R5', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(269, 'I', 'Pullem', 3671, 'Basinview Dr', 'Halifax', 'NS', 'B3H 1Y8', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(272, 'Jack', 'Pott', 534, 'Tower Rd', 'Halifax', 'NS', 'B3H 2X3', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(287, 'Kandi', 'Apple', 3793, 'Novalea Dr', 'Halifax', 'NS', 'B3K 3E6', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(333, 'Kenya', 'Dewitt', 15, 'Sylvania', 'Halifax', 'NS', 'B3Z 1J2', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(334, 'Willie', 'Dewitt', 15, 'Sylvania', 'Halifax', 'NS', 'B3Z 1J2', 333);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(343, 'Lilly', 'Pond', 3310, 'Agricola St', 'Halifax', 'NS', 'B3K 4H6', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(344, 'Ivy', 'Pond', 3310, 'Agricola St', 'Halifax', 'NS', 'B3K 4H6', 343);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(434, 'Marshall', 'Law', 6761, 'Chebucto Rd', 'Halifax', 'NS', 'B3L 1K5', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(435, 'May', 'Day', 170, 'Regency Park Dr.', 'Halifax', 'NS', 'B3S 1P2', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(599, 'Olive', 'Branch', 1361, 'Hollis St', 'Halifax', 'NS', 'B3H 2P6', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(633, 'Paige', 'Turner', 5613, 'Leeds St', 'Halifax', 'NS', 'B3K 2T3', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(682, 'Real', 'Turner', 70, 'Fairfax St', 'Halifax', 'NS', 'B3H 1Y8', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(781, 'Raynor', 'Schein', 87, 'Chipstone Close', 'Halifax', 'NS', 'B3M 4H3', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(795, 'Russell', 'Sprout', 3500, 'Dutch Village Rd', 'Halifax', 'NS', 'B3N 2S7', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(822, 'Sonny', 'Day', 25, 'Hubley', 'Halifax', 'NS', 'B3Z 1A1', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(828, 'Tad', 'Moore', 11, 'Cedarbrae Ln', 'Halifax', 'NS', 'B3M 3M4', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(832, 'Tad', 'Pohl', 1324, 'Lower Water St', 'Halifax', 'NS', 'B3J 3R3', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(872, 'Urich', 'Huncle', 4, 'Ramsgate Lane', 'Halifax', 'NS', 'B3P 2R7', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(891, 'Will', 'Power', 418, 'Herring Cove Rd', 'Halifax', 'NS', 'B3N 1N9', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(892, 'Virginia', 'Beach', 5520, 'Stoneham Crt', 'Halifax', 'NS', 'B3K 4A5', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(931, 'Rocky', 'Beach', 5520, 'Stoneham Crt ', 'Halifax', 'NS', 'B3K 4A5', 892);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(932, 'Sandy', 'Beach', 5520, 'Stoneham Crt ', 'Halifax', 'NS', 'B3K 4A5', 892);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(933, 'Willie', 'Leake', 5531, 'Duffus St', 'Halifax', 'NS', 'B3K 2L7', null);

INSERT INTO ValidDuration (DurationID, Name, Duration)
 VALUES(1, 'Day', 1);

INSERT INTO ValidDuration (DurationID, Name, Duration)
 VALUES(2, 'Weekend', 2);

INSERT INTO ValidDuration (DurationID, Name, Duration)
 VALUES(3, 'Long Weekend', 3);

INSERT INTO ValidDuration (DurationID, Name, Duration)
 VALUES(4, 'Week', 7);

INSERT INTO VolumePromotion (MinMovies, MaxMovies, Duration, PercentReduction)
 VALUES(3, 4, 2, 5.25);

INSERT INTO VolumePromotion (MinMovies, MaxMovies, Duration, PercentReduction)
 VALUES(5, 6, 2, 8.75);

INSERT INTO VolumePromotion (MinMovies, MaxMovies, Duration, PercentReduction)
 VALUES(4, 7, 3, 6.25);

INSERT INTO VolumePromotion (MinMovies, MaxMovies, Duration, PercentReduction)
 VALUES(8, 12, 3, 11.1);

INSERT INTO VolumePromotion (MinMovies, MaxMovies, Duration, PercentReduction)
 VALUES(10, 15, 7, 11.1);

INSERT INTO VolumePromotion (MinMovies, MaxMovies, Duration, PercentReduction)
 VALUES(16, 25, 7, 15.5);

INSERT INTO Rating(RatingID, RatingType, Description)
 VALUES('G', 'General Audience', 'Suitable for all' );

INSERT INTO Rating(RatingID, RatingType, Description)
 VALUES('PG', 'Parental Guidance', 'Parental guidance advised (no age restriction)' );

INSERT INTO Rating(RatingID, RatingType, Description)
 VALUES('14A', '14 Accompaniment', 'Persons under 14 must be accompanied by an adult' );

INSERT INTO Rating(RatingID, RatingType, Description)
 VALUES('18A', '18 Accompaniment', 'Persons under 18 must be accompanied by an adult' );

INSERT INTO Rating(RatingID, RatingType, Description)
 VALUES('R', 'Restricted', 'Only persons 18 or older may attend' );

INSERT INTO Rating(RatingID, RatingType, Description)
 VALUES('A', 'Adult', 'Explicitly violent or sexual activity' );

INSERT INTO Rating(RatingID, RatingType, Description)
 VALUES('U', 'Unrated', 'This film has not yet been rated' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('AC', 'Action' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('AD', 'Adventure' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('CO', 'Comedy' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('CG', 'Crime and Gangster' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('DR', 'Drama' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('EH', 'Epics and Historical' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('FA', 'Fantasy' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('HO', 'Horror' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('MD', 'Musicals and Dance' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('SF', 'Science Fiction' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('WA', 'War' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('WE', 'Westerns' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('MY', 'Mystery' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('TH', 'Thriller' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('BI', 'Biography' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('FM', 'Family' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('AN', 'Animation' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('DO', 'Documentary' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('SP', 'Sport' );

INSERT INTO Genre(GenreID, GenreType)
 VALUES('RO', 'Romance' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(479, 'Ed', null, 'Lauter', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(88, null, null, null, 'ZZ Top' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(770, 'Pete', null, 'Townshend', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(255, 'Johnny', null, 'Depp', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(198, 'Stockard', null, 'Channing', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(340, 'Billy', null, 'Gibbons', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(434, 'Enotris', null, 'Johnson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(432, 'Scarlett', null, 'Johansson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(818, 'Curly', null, 'Williams', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(725, 'Steve', null, 'Stevens', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(337, 'Barry', null, 'Gibb', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(78, null, null, null, 'Toothpick' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(598, 'Jason', null, 'Orange', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(774, 'Jeanne', null, 'Tripplehorn', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(633, 'Ryan', null, 'Potter', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(76, null, null, null, 'Tokyo Gakuso' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(673, 'Geoffrey', null, 'Rush', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(599, 'Heather', null, 'O''Rourke', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(470, 'Mila', null, 'Kunis', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(590, 'Alexander', null, 'Norris', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(571, 'Donna', null, 'Murphy', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(531, 'Yoji', null, 'Matsuda', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(273, 'Lamont', null, 'Dozier', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(415, 'Tom', null, 'Hull', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(572, 'Eddie', null, 'Murphy', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(614, 'Bill', null, 'Paxton', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(140, 'Michael', null, 'Biehn', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(723, 'Sylvester', null, 'Stallone', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(706, 'Glenn', null, 'Slater', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(80, null, null, null, 'Valentine' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(618, 'Joe', null, 'Perry', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(134, 'Astrid', null, 'Berges-Frisbey', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(208, 'John', null, 'Coinman', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(859, 'Sting', null, null, null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(805, 'Sigourney', null, 'Weaver', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(303, 'Siobhan', null, 'Fahey', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(694, 'Jane', null, 'Seymour', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(245, 'Sunny', null, 'David', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(801, 'Diane', null, 'Warren', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(14, null, null, null, 'Deep Purple' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(186, 'Mike', null, 'Carabello', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(47, null, null, null, 'Smokey Robinson�and�The Miracles' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(472, 'Shia', null, 'LaBeouf', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(864, 'Tara', null, 'Brown', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(297, 'Robert', null, 'Englund', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(546, 'Joel', null, 'McNeely', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(697, 'Talia', null, 'Shire', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(268, 'Micky', null, 'Dolenz', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(262, 'Celine', null, 'Dion', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(282, 'Craig', null, 'Eastman', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(797, 'Tom', null, 'Waits', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(51, null, null, null, 'Survivor' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(464, 'Morgana', null, 'King', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(311, 'Ralph', null, 'Fiennes', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(384, 'Noah', null, 'Hathaway', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(768, 'Anthony', null, 'Tombling Jnr.', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(91, 'Bryan', null, 'Adams', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(256, 'Bruce', null, 'Dern', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(380, 'Lorenz', null, 'Hart', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(765, 'Charles', null, 'Tobias', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(744, 'Tony', null, 'Swain', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(353, 'Justin', null, 'Gray', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(637, 'Lindsey', null, 'Ray', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(24, null, null, null, 'Jefferson Airplane' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(116, 'Gene', null, 'Autry', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(643, 'Graeme', null, 'Revell', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(583, 'Olivia', null, 'Newton-John', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(275, 'David', null, 'Dundara', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(29, null, null, null, 'Lynyrd Skynyrd' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(661, 'Chris', null, 'Rock', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(216, 'Roger', null, 'Cook', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(39, null, null, null, 'REO Speedwagon' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(764, 'Matthew', null, 'Tishler', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(710, 'Jaden', null, 'Smith', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(164, 'Danny', 'Joe', 'Brown', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(163, 'Anita', null, 'Brown', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(578, 'Dave', null, 'Navarro', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(579, 'Liam', null, 'Neeson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(524, 'Bernie', null, 'Marsden', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(705, 'Ed', null, 'Simons', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(449, 'Anna', null, 'Kendrick', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(498, 'Cleavon', null, 'Little', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(194, 'Elpidia', null, 'Carrillo', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(346, 'Domhnall', null, 'Gleeson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(403, 'Doc', null, 'Holiday', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(500, 'Fritz', null, 'L�hner-Beda', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(530, 'Mary', 'Elizabeth', 'Mastrantonio', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(131, 'Robby', null, 'Benson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(429, 'Jim', null, 'Jacobs', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(696, 'Tye', null, 'Sheridan', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(321, 'Susanna', null, 'Foster', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(476, 'Arnold', null, 'Lanni', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(191, 'Wendy', null, 'Carlos', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(769, 'Marisa', null, 'Tomei', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(804, 'Carl', null, 'Weathers', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(130, 'Henri', null, 'Belolo', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(82, null, null, null, 'Whitesnake' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(246, 'Benny', null, 'Davis', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(171, 'George', null, 'Bruns', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(224, 'Jai', null, 'Courtney', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(771, 'Joseph', null, 'Trapanese', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(714, 'John', null, 'Sparkes', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(597, 'Barret', null, 'Oliver', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(320, 'Stephen', null, 'Foster', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(431, 'Will', null, 'Jennings', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(223, 'Kevin', null, 'Costner', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(568, 'Ennio', null, 'Morricone', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(145, 'Orlando', null, 'Bloom', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(709, 'Chad', null, 'Smith', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(594, 'Paige', null, 'O''Hara', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(237, 'Willem', null, 'Dafoe', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(655, 'Johanna', null, 'Riding', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(558, 'Maika', null, 'Monroe', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(519, 'Raine', null, 'Maida', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(300, 'Chris', null, 'Evans', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(648, 'Tim', null, 'Rice', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(430, 'Mick', null, 'Jagger', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(664, 'Richard', null, 'Rogers', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(38, null, null, null, 'Red Hot Chili Peppers' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(574, 'John', null, 'Myers', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(260, 'Leonardo', null, 'DiCaprio', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(53, null, null, null, 'The Allman Brothers Band' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(495, 'Kenji', null, 'Lin', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(581, 'Willie', null, 'Nelson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(184, 'Mugs', null, 'Cain', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(426, 'Yuriko', null, 'Ishida', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(596, 'Gary', null, 'Oldman', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(652, 'Lionel', null, 'Richie', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(641, 'Les', null, 'Reed', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(827, 'Bruce', null, 'Willis', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(144, 'Robert', null, 'Blackwell', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(154, 'Tommy', null, 'Boyce', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(20, null, null, null, 'George Thorogood & The Destroyers' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(779, 'Carmen', null, 'Twillie', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(151, 'Sammy', null, 'Bower', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(436, 'Steve', null, 'Jolley', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(401, 'Billie', null, 'Holiday', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(549, 'Johnny', null, 'Mercer', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(123, 'Jason', null, 'Bateman', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(177, 'Solomon', null, 'Burke', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(612, 'Mandy', null, 'Patinkin', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(108, 'Asia', null, 'Argento', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(408, 'Dennis', null, 'Hopper', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(156, 'Marlon', null, 'Brando', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(214, 'Billy', null, 'Connolly', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(242, 'Jack', null, 'Dangers', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(416, 'Helen', null, 'Hunt', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(550, 'Sienna', null, 'Miller', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(790, 'Dan', null, 'Vickrey', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(577, 'Johnny', null, 'Nash', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(657, 'Julia', null, 'Roberts', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(326, 'Morgan', null, 'Freeman', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(118, 'Kevin', null, 'Bacon', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(32, null, null, null, 'Odetta' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(741, 'Keifer', null, 'Sutherland', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(412, 'Nicolas', null, 'Hoult', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(659, 'Daniel', null, 'Robles', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(59, null, null, null, 'The Doobie Brothers' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(179, 'Gerard', null, 'Butler', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(786, 'Alex', null, 'Van Halen', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(620, 'Mary', null, 'Philbin', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(810, 'Pete', null, 'Wentz', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(336, 'Jeff', null, 'Garlin', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(248, 'Sammy', null, 'Davis Jr.', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(290, 'Bernard', null, 'Edwards', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(460, 'Jimmy', null, 'Kimmel', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(345, 'Ian', null, 'Gillan', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(625, 'Chris', null, 'Pine', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(862, 'Tara', null, 'Brown', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(349, 'John', null, 'Gomez', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(339, 'Robin', null, 'Gibb', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(94, 'Sade', null, 'Adu', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(207, 'Leonard', null, 'Cohen', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(681, 'Carlos', null, 'Santana', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(254, 'Dana', null, 'Delaney', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(454, 'Daniella', null, 'Kertesz', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(861, 'Van Morrison', null, null, null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(309, 'William', null, 'Fichtner', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(215, 'Bill', null, 'Conti', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(206, 'Jeff', null, 'Cohen', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(361, 'Bob', null, 'Gunton', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(554, 'Kim', null, 'Miyori', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(220, 'Jesse', null, 'Corti', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(308, 'Tina', null, 'Fey', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(477, 'Cindy', null, 'Lauper', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(230, 'Kevin', null, 'Cronin', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(660, 'Guy', null, 'Roche', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(169, 'Ramond', null, 'Brown', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(791, 'Alicia', null, 'Vikander', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(44, null, null, null, 'Second Coming' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(99, 'Gregg', null, 'Allman', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(605, 'Jimmy', null, 'Page', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(491, 'Jerry', 'Lee', 'Lewis', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(732, 'Sharon', null, 'Stone', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(188, 'Mariah', null, 'Carey', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(573, 'Chad', 'Michael', 'Murray', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(751, 'Channing', null, 'Tatum', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(158, 'Matthew', null, 'Broderick', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(600, 'Haley', 'Joel', 'Osment', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(55, null, null, null, 'The Bee Gees' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(834, 'Bill', null, 'Withers', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(239, 'Sara', null, 'Dallin', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(411, 'Michael', null, 'Horse', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(333, 'Wally', null, 'Gagel', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(69, null, null, null, 'The Patterson Tribe' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(469, 'Herman', null, 'Koto', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(200, 'Jessica', null, 'Chastain', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(367, 'Kevin', 'Peter', 'Hall', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(319, 'Farrah', null, 'Forke', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(407, 'Ian', null, 'Holm', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(830, 'Nancy', null, 'Wilson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(358, 'Graham', null, 'Greene', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(8, null, null, null, 'Charli XCX' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(382, 'Josh', null, 'Hartnett', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(126, 'Peter', null, 'Beckett', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(462, 'Edward', null, 'King', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(858, 'Sade', null, null, null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(155, 'Travis', null, 'Bracht', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(511, 'Jeff', null, 'Lynne', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(852, 'Hans', null, 'Zimmer', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(814, 'Margaret', null, 'Whitton', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(101, 'Louis', null, 'Alter', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(428, 'Samuel', 'L.', 'Jackson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(677, 'Halston', null, 'Sage', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(110, 'Louis', null, 'Armstrong', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(621, 'Emo', null, 'Phillips', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(17, null, null, null, 'Fall Out Boy' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(150, 'Pat', null, 'Boone', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(840, 'Keren', null, 'Woodward', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(842, 'Andrew', null, 'Wyatt', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(803, 'Ken', null, 'Watanabe', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(503, 'Herbert', null, 'Lom', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(654, 'Alan', null, 'Rickman', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(148, 'John', null, 'Bonham', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(229, 'David', null, 'Crawford', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(159, 'Josh', null, 'Brolin', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(228, 'Bryan', null, 'Cranston', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(409, 'John', 'L.', 'Horn', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(394, 'Ludwig', null, 'Herzer', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(607, 'Victor', null, 'Parascos', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(217, 'Bruno', null, 'Coon', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(775, 'Joseph', null, 'Trohman', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(371, 'Oscar', null, 'Hammerstein II', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(77, null, null, null, 'Tommy Dorsey & His Orchestra' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(505, 'Khris', null, 'Lorenz', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(638, 'Otis', null, 'Redding', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(64, null, null, null, 'The Ink Spots' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(781, 'Steven', null, 'Tyler', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(185, 'Anna', null, 'Calvi', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(201, 'Frederic', null, 'Chopin', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(322, 'Bruce', 'L.', 'Fowler', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(5, null, null, null, 'Boom Boom Satellites' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(298, 'Mireille', null, 'Enos', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(863, 'Tara', null, 'Brown', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(244, 'Dean', null, 'Daughtry', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(562, 'Warren', null, 'Moore', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(440, 'Mick', null, 'Jones', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(484, 'Jacquie', null, 'Lee', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(442, 'Jeremy', null, 'Jordan', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(789, 'Ronnie', null, 'Van Zant', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(453, 'Norman', null, 'Kerry', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(485, 'James', null, 'Leg', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(548, 'Alan', null, 'Menken', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(141, '�Bj�rnstjerne', null, 'Bj�rnson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(83, null, null, null, 'Wings' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(847, 'Angus', null, 'Young', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(627, 'Brad', null, 'Pitt', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(93, 'Scott', null, 'Adsit', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(525, 'Logan', null, 'Marshall-Green', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(559, 'Clayton', null, 'Moore', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(565, 'Pat', null, 'Morita', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(569, 'John', null, 'Morris', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(619, 'Jim', null, 'Peterik', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(213, 'Jennifer', null, 'Connelly', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(687, 'Michael', null, 'Schrieve', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(788, 'Jimmy', null, 'Van Heusen', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(528, 'Dick', null, 'Marx', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(117, 'Johann', null, 'Bach', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(359, 'Colin', null, 'Greenwood', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(868, null, null, null, 'The DBA Performers' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(261, 'Stephen', null, 'Dillane', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(455, 'Judy', null, 'Kester', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(1, null, null, null, '30 Seconds to Mars' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(236, 'Jamie', 'Lee', 'Curtis', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(542, 'Patrick', null, 'McGoohan', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(532, 'Mackenzie', null, 'Mauzy', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(700, 'Jay', null, 'Silverheels', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(142, 'Jack', null, 'Black', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(766, 'Harry', null, 'Tobias', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(629, 'Christopher', null, 'Plummer', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(342, 'Keir', null, 'Gilchrist', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(106, 'Nathaniel', null, 'Arcand', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(649, 'Keith', null, 'Richards', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(203, 'Charlotte', null, 'Church', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(67, null, null, null, 'The Mills Brothers' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(187, 'Paul', null, 'Carafotes', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(592, 'Rick', null, 'Nowels', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(138, 'Dickey', null, 'Betts', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(552, 'Irving', null, 'Mills', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(249, 'Tom', null, 'Dawes', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(585, 'Scott', null, 'Nickoley', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(482, 'Denis', null, 'Leary', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(537, 'Andrew', null, 'McCluskey', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(623, 'Joaquin', null, 'Phoenix', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(752, 'Christopher', null, 'Taylor', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(819, 'Hank', null, 'Williams', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(493, 'Tony', null, 'Liberto', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(305, 'Colin', null, 'Farrell', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(684, 'Maximillian', null, 'Schell', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(688, 'Arnold', null, 'Schwarzenegger', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(835, 'Reese', null, 'Witherspoon', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(712, 'Wesley', null, 'Snipes', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(520, 'Henri', null, 'Mancini', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(672, 'Mark', null, 'Ruffalo', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(822, 'Paul', null, 'Williams', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(735, 'Meryl', null, 'Streep', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(11, null, null, null, 'Counting Crows' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(580, 'Craig', 'T.', 'Nelson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(121, 'John', null, 'Barry', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(354, 'Eva', null, 'Green', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(865, 'David', 'A', 'Jones', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(755, 'Charlize', null, 'Theron', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(395, 'David', null, 'Hilker', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(647, 'Christina', null, 'Ricci', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(378, 'Bobby', null, 'Hart', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(238, 'Arlene', null, 'Dahl', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(556, 'Fredrich-Wilhelm', null, 'Moller', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(404, 'Brian', null, 'Holland', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(274, 'Minnie', null, 'Driver', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(243, 'Jeff', null, 'Daniels', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(227, 'Ronny', null, 'Cox', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(66, null, null, null, 'The Lovin'' Spoonful' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(302, 'Mark', null, 'Everett', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(36, null, null, null, 'Queen' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(666, 'Sigmund', null, 'Romberg', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(383, 'Anne', null, 'Hathaway', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(675, 'Kurt', null, 'Russell', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(263, 'Bob', null, 'DiPiero', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(347, 'Roger', null, 'Glover', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(296, 'Cary', null, 'Elwes', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(828, 'Victor', null, 'Willis', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(762, 'George', null, 'Thorogood', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(124, 'Michael', null, 'Bates', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(181, 'Amick', null, 'Byram', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(689, 'Heather', null, 'Sears', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(486, 'Franz', null, 'Leh�r', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(849, 'Jesse', 'Colin', 'Young', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(853, 'Professor Green', null, null, null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(463, 'Jon', null, 'King', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(31, null, null, null, 'Muse' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(563, 'Jacques', null, 'Morali', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(146, 'Jon', null, 'Bon Jovi', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(400, 'Magnus', null, 'Hoilberg', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(328, 'John', null, 'Frusciante', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(65, null, null, null, 'The Jimi Hendrix Experience' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(651, 'Joely', null, 'Richardson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(204, 'Paolo', null, 'Citarella', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(564, 'Rushton', null, 'Moreve', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(504, 'Jon', null, 'Lord', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(782, 'Ritchie', null, 'Valens', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(642, 'Keanu', null, 'Reeves', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(785, 'Ludwig', null, 'van Beethoven', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(25, null, null, null, 'Kool & The Gang' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(344, 'Andy', null, 'Gill', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(377, 'Naomi', null, 'Harris', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(178, 'Ben', null, 'Burtt', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(284, 'Clint', null, 'Eastwood', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(102, 'Dave', null, 'Amato', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(18, null, null, null, 'Flea' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(445, 'Michael', null, 'Kamen', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(360, 'Jonny', null, 'Greenwood', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(729, 'Richard', null, 'Stilgoe', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(780, 'Liv', null, 'Tyler', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(671, 'Tom', null, 'Rowlands', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(372, 'Tom', null, 'Hanks', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(439, 'John', 'Paul', 'Jones', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(711, 'Will', null, 'Smith', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(386, 'Goldie', null, 'Hawn', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(499, 'Christopher', null, 'Lloyd', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(327, 'Cliff', null, 'Friend', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(742, 'Milan', null, 'Svoboda', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(534, 'Linda', null, 'McCartney', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(417, 'Andy', null, 'Hurley', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(253, 'Edward', null, 'de Souza', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(113, 'Sean', null, 'Astin', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(480, 'Jack', null, 'Lawrence', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(829, 'Alan', null, 'Wilson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(285, 'Aaron', null, 'Eckhart', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(135, 'Jackie', null, 'Bernstein', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(628, 'Jacob', null, 'Plant', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(669, 'Emmy', null, 'Rossum', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(867, 'David', 'A', 'Jones', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(133, 'Tom', null, 'Berenger', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(510, 'Martin', null, 'Luther', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(739, 'Patrick', null, 'Stump', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(658, 'Smokey', null, 'Robinson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(636, 'Doug', null, 'Ray', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(231, 'Russell', null, 'Crowe', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(162, 'Pam', null, 'Brooks', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(748, 'Wei', null, 'Tang', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(471, 'Olga', null, 'Kurylenko', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(738, 'Joe', null, 'Strummer', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(143, 'Ritchie', null, 'Blackmore', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(250, 'Doris', null, 'Day', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(103, 'Tori', null, 'Amos', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(278, 'Bob', null, 'Dylan', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(821, 'Michelle', null, 'Williams', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(582, 'Thomas', null, 'Newman', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(593, 'Ed', null, 'Obrien', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(604, 'Jinkee', null, 'Pacquiai', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(734, 'Izzy', null, 'Stradlin', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(506, 'Bruno', null, 'Louchouarn', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(692, 'Rezs�', null, 'Seress', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(107, 'Jose', null, 'Areas', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(225, 'David', null, 'Coverdale', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(570, 'Viggo', null, 'Mortenson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(90, 'Amy', null, 'Adams', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(547, 'Ian', null, 'McShane', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(48, null, null, null, 'SOHN' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(759, 'Gordon', 'V.', 'Thompson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(492, 'Lykke', null, 'Li', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(758, 'Theo', null, 'Thomas', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(501, 'Kristanna', null, 'Loken', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(698, 'Elisabeth', null, 'Shue', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(465, 'Ben', null, 'Kingsley', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(656, 'Tim', null, 'Robbins', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(630, 'Simone', null, 'Porter', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(793, 'Rich', null, 'Vreeland', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(277, 'Adam', null, 'Duritz', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(461, 'Christopher', 'Royal', 'King', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(271, 'Tom', null, 'Douglas', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(105, 'Michael', null, 'Anthony', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(125, 'Frank', null, 'Beard', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(776, 'Chris', null, 'Tucker', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(848, 'Burt', null, 'Young', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(332, 'Sarah', null, 'Gadon', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(35, null, null, null, 'Pokey LaFarge and the South City Three' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(295, 'Sam', null, 'Elliott', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(517, 'Amy', null, 'Madigan', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(690, 'John', null, 'Sebastian', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(288, 'Nelson', null, 'Eddy', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(553, 'Tamara', null, 'Minta', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(398, 'David', 'Lawrence', 'Hlubek', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(716, 'Bruce', null, 'Springsteen', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(2, null, null, null, 'AC/DC' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(12, null, null, null, 'Creedence Clearwater Revival' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(109, 'Syamsul', null, 'Arifin', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(149, 'Hugh', null, 'Bonneville', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(855, 'Rihanna', null, null, null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(529, 'James', null, 'Mason', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(708, 'Grace', null, 'Slick', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(74, null, null, null, 'The Who' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(724, 'Arthur', null, 'Stead', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(720, 'Louis', null, 'St. Louis', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(68, null, null, null, 'The Neville Broithers' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(98, 'Woody', null, 'Allen', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(474, 'Dennis', null, 'Lambert', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(678, 'Camille', null, 'Saint-Saens', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(84, null, null, null, 'Woodkid' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(168, 'Jason', 'Robert', 'Brown', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(737, 'Tami', null, 'Stronach', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(241, 'Beverly', null, 'D''Angelo', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(272, 'Robert', null, 'Downey JR', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(23, null, null, null, 'Jabu' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(396, 'Dusty', null, 'Hill', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(75, null, null, null, '''This Will Destroy You''' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(137, 'Lyle', null, 'Bettger', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(802, 'Estella', null, 'Warren', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(42, null, null, null, 'Santana' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(533, 'Brian', null, 'May', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(667, 'Axl', null, 'Rose', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(425, 'Daryl', null, 'Isaacs', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(7, null, null, null, 'Canned Heat' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(497, 'David', null, 'Lindsay-Abaire', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(343, 'Rhett', null, 'Giles', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(746, 'Dudley', null, 'Taft', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(334, 'Jeremy', null, 'Gallindo', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(89, 'Quinton', null, 'Aaron', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(258, 'Andrea', null, 'Di Stefano', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(740, 'Frankie', null, 'Sullivan', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(422, 'Jeremy', null, 'Irons', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(701, 'Alan', null, 'Silvestri', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(176, 'Glenn', null, 'Burke', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(370, 'Armie', null, 'Hammer', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(663, 'Nile', null, 'Rogers', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(483, 'Heath', null, 'Ledger', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(424, 'Oscar', null, 'Isaac', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(60, null, null, null, 'The Eels' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(235, 'Benedict', null, 'Cumberbatch', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(631, 'Grace', null, 'Potter', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(174, 'Peter', null, 'Buffett', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(509, 'Steve', null, 'Lunt', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(63, null, null, null, 'The Hollies' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(96, 'Christina', null, 'Aguilera', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(388, 'Skip', null, 'Henderson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(866, 'David', 'A', 'Jones', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(310, 'Brad', null, 'Fiedel', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(452, 'James', null, 'Kerrigen', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(806, 'Andrew', 'Lloyd', 'Webber', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(490, 'Zachary', null, 'Levi', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(670, 'Tim', null, 'Roth', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(73, null, null, null, 'The Village People' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(70, null, null, null, 'The Pipes and Drums of the Chicago Police Department' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(286, 'Duane', null, 'Eddy', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(197, 'Lon', null, 'Chaney', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(81, null, null, null, 'Van Halen' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(634, 'Noomi', null, 'Raace', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(306, 'Johnny', null, 'Farrow', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(726, 'Robert', 'Louis', 'Stevenson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(613, 'Will', null, 'Patton', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(527, 'Al', null, 'Martino', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(437, 'Bessie', null, 'Jones', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(591, 'Aldo', null, 'Nova', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(812, 'Jack', null, 'White', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(825, 'Eagle Eye', null, 'Williamson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(787, 'Edward', null, 'Van Halen', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(374, 'Kit', null, 'Harington', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(566, 'Giorgio', null, 'Moroder', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(459, 'Val', null, 'Kilmer', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(406, 'Sam', null, 'Hollander', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(466, 'Joel', null, 'Kinnaman', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(745, 'Marty', null, 'Symes', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(795, 'Loudon', null, 'Wainwright III', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(37, null, null, null, 'Radiohead' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(54, null, null, null, 'The Atlanta Rhythm Section' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(72, null, null, null, 'The Supremes' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(808, 'Rachel', null, 'Weisz', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(475, 'Robert', 'John', 'Lange', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(114, 'Xavier', null, 'Atencio', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(316, 'Kris', null, 'Fogelmark', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(836, 'Stevie', null, 'Wonder', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(753, 'John', null, 'Taylor', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(575, 'Mike', null, 'Myers', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(838, 'Bokeem', null, 'Woodbine', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(26, null, null, null, 'Led Zepplin' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(587, 'Robert', null, 'Nix', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(375, 'Jessica', null, 'Harper', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(447, 'John', null, 'Kay', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(128, 'Bonnie', null, 'Bedelia', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(22, null, null, null, 'Hi-Fi Killers' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(157, 'Anita', null, 'Briem', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(4, null, null, null, 'Bananarama' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(369, 'Linda', null, 'Hamilton', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(21, null, null, null, 'Guns N'' Roses' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(586, 'Bill', null, 'Nighy', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(841, 'Robin', null, 'Wright', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(691, 'Phil', null, 'Selway', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(560, 'Mandy', null, 'Moore', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(232, 'Tom', null, 'Cruise', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(541, 'Malcom', null, 'McDowell', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(703, 'Paul', null, 'Simon', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(387, 'Chris', null, 'Hemsworth', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(136, 'Xandy', null, 'Berry', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(325, 'Brendan', null, 'Fraser', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(518, 'Patrick', null, 'Magee', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(626, 'Dean', null, 'Pitchford', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(435, 'Tom', null, 'Johnson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(175, 'Sandra', null, 'Bullock', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(721, 'Nick', null, 'Stahl', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(608, 'Jim', null, 'Parsons', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(233, 'Penelope', null, 'Cruz', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(419, 'Billy', null, 'Idol', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(699, 'Abner', null, 'Silver', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(423, 'Michael', null, 'Ironside', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(757, 'Banner', 'Harvey', 'Thomas', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(356, 'Norman', null, 'Greenbaum', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(777, 'Brett', null, 'Tuggle', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(190, 'Belinda', null, 'Carlisle', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(845, 'Michael', null, 'York', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(473, 'Frankie', null, 'Laine', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(304, 'John', null, 'Farrar', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(97, 'Eddie', null, 'Albert', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(226, 'Charlie', null, 'Cox', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(365, 'Merle', null, 'Haggard', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(811, 'Dominic', null, 'West', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(718, 'Morgan', null, 'Spurlock', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(448, 'Harvey', null, 'Keitel', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(640, 'Eddie', null, 'Redmayne', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(27, null, null, null, 'Little Richard' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(391, 'Taraji', 'P.', 'Henson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(247, 'Viola', null, 'Davis', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(329, 'Edward', null, 'Furlong', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(833, 'Kate', null, 'Winslet', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(352, 'Gerrit', null, 'Graham', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(545, 'Kevin', null, 'McNally', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(52, null, null, null, 'Take That' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(816, 'Gene', null, 'Wilder', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(413, 'Josh', null, 'Hucherson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(317, 'John', null, 'Fogerty', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(588, 'Bob', null, 'Nolan', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(433, 'Elton', null, 'John', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(451, 'Mike', null, 'Kerr', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(414, 'Daniel', null, 'Huddlestone', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(763, 'Dimitri', null, 'Tiomkin', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(355, 'Roger', null, 'Greenaway', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(3, null, null, null, 'Aerosmith' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(122, 'Felicia', null, 'Barton', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(368, 'Mark', null, 'Hamill', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(494, 'Ken', null, 'Liebenson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(212, 'Anwar', null, 'Congo', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(16, null, null, null, 'Duran Duran' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(166, 'James', null, 'Brown', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(846, 'Thom', null, 'Yorke', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(682, 'Brian', null, 'Satterwhite', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(234, 'Rory', null, 'Culkin', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(318, 'Harrison', null, 'Ford', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(351, 'Benny', null, 'Goodman', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(513, 'Yo-Yo', null, 'Ma', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(704, 'Scott', 'J.', 'Simon', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(86, null, null, null, 'Xzibit' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(715, 'Klinton', null, 'Spilsbury', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(695, 'Charlie', null, 'Sheen', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(132, 'Aaron', null, 'Benward', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(139, 'Jeff', null, 'Bhasker', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(79, null, null, null, 'Tryanglz' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(15, null, null, null, 'Deutsche Grammophon Gesellschaft' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(662, 'Gloriree', null, 'Rodriguez', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(112, 'Leroy', null, 'Asborne', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(160, 'Eric', null, 'Brooks', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(127, 'Kate', null, 'Beckinsale', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(266, 'Klaus', null, 'Doldinger', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(218, 'Bradley', null, 'Cooper', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(635, 'Claude', null, 'Rains', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(219, 'Dominic', null, 'Cooper', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(756, 'Bob', null, 'Thiele', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(399, 'Gaby', null, 'Hoffmann', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(13, null, null, null, 'CUTS' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(421, 'David', null, 'Immergluck', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(43, null, null, null, 'Screaming Trees' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(702, 'Joseph', null, 'Simmons', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(57, null, null, null, 'The Clash' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(686, 'David', null, 'Schommer', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(487, 'Carolyn', null, 'Leigh', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(807, 'George', 'David', 'Weiss', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(502, 'Gennady', null, 'Lokionov', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(348, 'Jerry', null, 'Goldsmith', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(722, 'Frank', null, 'Stallone', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(611, 'Molly', null, 'Pasutti', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(733, 'Madeleine', null, 'Stowe', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(728, 'Virgil', 'F.', 'Stewart', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(427, 'Alan', null, 'Jackson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(441, 'Tom', null, 'Jones', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(119, 'Christian', null, 'Bale', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(221, 'John', null, 'Costello', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(674, 'Odeya', null, 'Rush', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(839, 'Shailene', null, 'Woodley', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(676, 'Winona', null, 'Ryder', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(456, 'Cheb', null, 'Khaled', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(264, 'Omid', null, 'Djalili', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(405, 'Eddie', null, 'Holland', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(41, null, null, null, 'Run-D.M.C.' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(193, 'David', null, 'Carradine', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(373, 'Tom', null, 'Hardy', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(161, 'Mel', null, 'Brooks', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(205, 'Allan', null, 'Clarke', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(289, 'Joel', null, 'Edgerton', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(323, 'Dia', null, 'Frampton', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(750, 'Larenz', null, 'Tate', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(603, 'Al', null, 'Pacino', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(536, 'Tane', null, 'McClure', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(291, 'Carmen', null, 'Ejogo', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(489, 'Jared', null, 'Leto', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(301, 'Luke', null, 'Evans', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(392, 'Arthur', null, 'Herezog Jr.', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(555, 'Jason', null, 'Mizell', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(707, 'Darby', null, 'Slick', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(772, 'John', null, 'Travolta', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(526, 'Steve', null, 'Martin', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(376, 'Ed', null, 'Harris', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(46, null, null, null, 'Simon and Garfunkel' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(731, 'Ethan', null, 'Stoller', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(341, 'Mel', null, 'Gibson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(730, 'Stephen', null, 'Stills', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(535, 'Paul', null, 'McCartney', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(784, 'Frankie', null, 'Valli', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(292, 'Danny', null, 'Elfman', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(508, 'Olivia', null, 'Luccardi', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(33, null, null, null, 'Orchestral Manoeuvres in the Dark' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(815, 'Dianne', null, 'Wiest', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(40, null, null, null, 'Royal Blood' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(543, 'Tim', null, 'McGraw', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(665, 'Gregg', null, 'Rolie', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(521, 'Jono', null, 'Manson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(792, 'Jon', null, 'Voight', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(680, 'Julian', null, 'Sands', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(393, 'T.E.', null, 'Hermanson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(196, 'Jackie', null, 'Chan', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(183, 'Sammy', null, 'Cahn', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(210, 'Cy', null, 'Coleman', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(379, 'Charles', null, 'Hart', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(767, 'Henry', 'H.', 'Tobias', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(364, 'Sammy', null, 'Hagar', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(152, 'David', null, 'Bowie', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(467, 'Elissa', null, 'Knight', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(514, 'Ralph', null, 'Macchio', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(515, 'Seth', null, 'MacFarlane', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(761, 'Billy Bob', null, 'Thornton', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(299, 'Mikkel', null, 'Eriksen', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(800, 'Julie', null, 'Walters', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(540, 'Mary', null, 'McDonnell', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(324, 'James', null, 'Franco', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(809, 'Anthony', null, 'Wen', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(679, 'Adam', null, 'Sandler', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(195, 'Warren', null, 'Casey', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(601, 'Mark', null, 'Owen', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(397, 'Faith', null, 'Hill', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(820, 'JoBeth', null, 'Williams', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(713, 'Stephen', null, 'Sondheim', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(832, 'Bob', null, 'Wilvers', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(617, 'Shelly', null, 'Peiken', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(315, 'Justin', null, 'Fletcher', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(794, 'Mark', null, 'Wahlberg', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(668, 'Gioachino', null, 'Rossini', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(523, 'Sophie', null, 'Marceau', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(172, 'Jimmy', null, 'Buffett', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(576, 'Masayuki', null, 'Nakano', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(182, 'James', null, 'Caan', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(747, 'Yuko', null, 'Tanaka', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(335, 'Kyle', null, 'Gallner', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(56, null, null, null, 'The Chemical Brothers' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(727, 'Patrick', null, 'Stewart', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(624, 'Slim', null, 'Pickens', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(49, null, null, null, 'Steppenwolf' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(30, null, null, null, 'Molly Hatchet' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(749, 'Marvin', null, 'Tarplin', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(294, 'Ansel', null, 'Elgort', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(363, 'Gene', null, 'Hackman', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(270, 'Michael', null, 'Douglas', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(615, 'Tom', null, 'Paxton', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(458, 'Anthony', null, 'Kiedis', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(685, 'Jill', null, 'Schoelen', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(338, 'Maurice', null, 'Gibb', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(481, 'Scott', null, 'Learn', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(269, 'Howard', null, 'Donald', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(313, 'Neil', null, 'Finn', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(71, null, null, null, 'The Rolling Stones' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(438, 'James', 'Earl', 'Jones', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(831, 'Patrick', null, 'Wilson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(120, 'Gary', null, 'Barlow', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(595, 'Kevin', null, 'Okurland', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(646, 'Nick', null, 'Rhodes', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(645, 'Burt', null, 'Reynolds', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(350, 'Matthew', null, 'Goode', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(444, 'Milla', null, 'Jovovich', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(539, 'Darryl', null, 'McDaniels', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(10, null, null, null, 'Chic' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(129, 'Matthew', null, 'Bellamy', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(330, 'Peter', null, 'Gabriel', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(276, 'Jamie', null, 'Dunlap', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(616, 'Robert', null, 'Payne', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(62, null, null, null, 'The Hilliard Ensemble' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(817, 'Andy', null, 'Williams', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(240, 'Claire', null, 'Danes', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(281, 'Chris', null, 'Eacrett', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(606, 'Ian', null, 'Paice', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(410, 'James', null, 'Horner', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(61, null, null, null, 'The Gin Blossoms' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(115, 'Rowan', null, 'Atkinson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(843, 'Dwight', null, 'Yoakam', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(589, 'Monty', null, 'Norman', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(418, 'Alex', null, 'Hyde-White', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(95, 'Ben', null, 'Affleck', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(314, 'Carrie', null, 'Fischer', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(851, 'Billy', null, 'Zane', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(19, null, null, null, 'Gang of Four' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(312, 'William', null, 'Finley', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(6, null, null, null, 'Buddie Buie' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(389, 'Jimi', null, 'Hendrix', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(259, 'Cameron', null, 'Diaz', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(211, 'Toni', null, 'Collette', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(468, 'Keira', null, 'Knightley', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(778, 'Mike', null, 'Turner', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(813, 'Peter', null, 'Whitehead', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(551, 'Gordon', null, 'Mills', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(45, null, null, null, 'Sha-Na-Na' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(202, 'Jamie', null, 'Chung', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(760, 'Wayne', 'Carson', 'Thompson', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(385, 'Sally', null, 'Hawkins', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(34, null, null, null, 'Our Lady Peace' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(265, 'Nicholas', null, 'Dodd', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(165, 'David', null, 'Brown', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(602, 'David', null, 'Oyelowo', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(58, null, null, null, 'The Doo Wah Riders' );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(799, 'Chemeeks', null, 'Walker', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(850, 'Malcom', null, 'Young', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(111, 'Tom', null, 'Arnold', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(280, 'George', null, 'Dzundza', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(251, 'Zella', null, 'Day', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(170, 'Emily', null, 'Browning', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(307, 'Michael', null, 'Fassbender', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(754, 'Ben', null, 'Thatcher', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(257, 'Laura', null, 'Dern', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(622, 'Ricky', null, 'Phillips', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(488, 'Nikki', null, 'Leonti', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(381, 'Stuart', null, 'Hart', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(446, 'Michiyuki', null, 'Kawashima', null );

INSERT INTO Contributor (ContributorID, FName, MName, LName, MusicalGroup)
 VALUES(538, 'Matthew', null, 'McConaughey', null );

INSERT INTO Song (SongID, Name)
 VALUES(216, 'Midnight Rider');

INSERT INTO Song (SongID, Name)
 VALUES(100, 'Villa Del Refugio');

INSERT INTO Song (SongID, Name)
 VALUES(83, 'Wherever You''re Goin'' (It''s Alright)');

INSERT INTO Song (SongID, Name)
 VALUES(120, 'Summer Madness');

INSERT INTO Song (SongID, Name)
 VALUES(107, 'Whole Lotta Shakin'' Goin'' On');

INSERT INTO Song (SongID, Name)
 VALUES(132, 'If You''ve Only Got a Moustache');

INSERT INTO Song (SongID, Name)
 VALUES(7, 'Oh, Sinner Man');

INSERT INTO Song (SongID, Name)
 VALUES(11, 'Follin in the Rearview');

INSERT INTO Song (SongID, Name)
 VALUES(206, 'What a Wonderful World');

INSERT INTO Song (SongID, Name)
 VALUES(156, 'You Could Be Mine');

INSERT INTO Song (SongID, Name)
 VALUES(82, 'The Goonies ''R'' Good Enough');

INSERT INTO Song (SongID, Name)
 VALUES(39, 'Mein Vater war ein Wandersmann');

INSERT INTO Song (SongID, Name)
 VALUES(5, 'Snake Charmer');

INSERT INTO Song (SongID, Name)
 VALUES(149, 'You Can''t Do That');

INSERT INTO Song (SongID, Name)
 VALUES(1, 'Little Secrets');

INSERT INTO Song (SongID, Name)
 VALUES(177, 'Bird on a Wire');

INSERT INTO Song (SongID, Name)
 VALUES(137, 'Mean-Ass Cattle');

INSERT INTO Song (SongID, Name)
 VALUES(173, 'Every Little Thing She Does Is Magic');

INSERT INTO Song (SongID, Name)
 VALUES(178, 'Blowin'' In The Wind');

INSERT INTO Song (SongID, Name)
 VALUES(246, 'Prof of Geology');

INSERT INTO Song (SongID, Name)
 VALUES(210, 'La Grange');

INSERT INTO Song (SongID, Name)
 VALUES(37, 'Masters of War');

INSERT INTO Song (SongID, Name)
 VALUES(230, 'Bunk Bed Blues');

INSERT INTO Song (SongID, Name)
 VALUES(131, 'Going up the Country');

INSERT INTO Song (SongID, Name)
 VALUES(250, 'Registration Blues');

INSERT INTO Song (SongID, Name)
 VALUES(134, 'Back to the Future Theme');

INSERT INTO Song (SongID, Name)
 VALUES(225, 'Ain''t Got Time To Die');

INSERT INTO Song (SongID, Name)
 VALUES(200, 'Wild Times');

INSERT INTO Song (SongID, Name)
 VALUES(64, 'The Thieving Magpie (Overture)');

INSERT INTO Song (SongID, Name)
 VALUES(93, 'I Can See For Miles');

INSERT INTO Song (SongID, Name)
 VALUES(45, 'Eyes Down');

INSERT INTO Song (SongID, Name)
 VALUES(102, 'Grease');

INSERT INTO Song (SongID, Name)
 VALUES(176, 'The Challenge');

INSERT INTO Song (SongID, Name)
 VALUES(124, 'So Into You');

INSERT INTO Song (SongID, Name)
 VALUES(248, 'Whats Up Dude?');

INSERT INTO Song (SongID, Name)
 VALUES(77, 'Coffee Meditation');

INSERT INTO Song (SongID, Name)
 VALUES(142, 'The Ballad of Rock Ridge');

INSERT INTO Song (SongID, Name)
 VALUES(6, 'The Chink');

INSERT INTO Song (SongID, Name)
 VALUES(60, 'I Have But One Heart');

INSERT INTO Song (SongID, Name)
 VALUES(244, 'William Tell Overture');

INSERT INTO Song (SongID, Name)
 VALUES(14, 'The Heart of You');

INSERT INTO Song (SongID, Name)
 VALUES(111, 'The Music of the Night');

INSERT INTO Song (SongID, Name)
 VALUES(233, 'Prelude for Piano No. 15 in D Flat Major, Op. 28 No. 15');

INSERT INTO Song (SongID, Name)
 VALUES(147, 'Red River Valley');

INSERT INTO Song (SongID, Name)
 VALUES(227, 'Lean On Me');

INSERT INTO Song (SongID, Name)
 VALUES(84, 'The Name''s Bond... James Bond');

INSERT INTO Song (SongID, Name)
 VALUES(169, 'Child in Time');

INSERT INTO Song (SongID, Name)
 VALUES(8, 'U Kogo-to Budut Neptiyamosty');

INSERT INTO Song (SongID, Name)
 VALUES(175, 'Moon River');

INSERT INTO Song (SongID, Name)
 VALUES(208, 'I Don''t Want to Miss a Thing');

INSERT INTO Song (SongID, Name)
 VALUES(168, 'Melancholy Mechanics');

INSERT INTO Song (SongID, Name)
 VALUES(204, 'Christmas in Hollis');

INSERT INTO Song (SongID, Name)
 VALUES(67, 'What a Man');

INSERT INTO Song (SongID, Name)
 VALUES(213, 'Come See About Me');

INSERT INTO Song (SongID, Name)
 VALUES(133, 'A Million Ways To Die');

INSERT INTO Song (SongID, Name)
 VALUES(223, 'Soul Deep');

INSERT INTO Song (SongID, Name)
 VALUES(98, 'Detrius');

INSERT INTO Song (SongID, Name)
 VALUES(109, 'The Schmuel Song');

INSERT INTO Song (SongID, Name)
 VALUES(235, 'Crazy Girl');

INSERT INTO Song (SongID, Name)
 VALUES(211, 'Starseed');

INSERT INTO Song (SongID, Name)
 VALUES(130, 'Southern Voice');

INSERT INTO Song (SongID, Name)
 VALUES(232, 'Theme from Alien');

INSERT INTO Song (SongID, Name)
 VALUES(94, 'Purple Haze');

INSERT INTO Song (SongID, Name)
 VALUES(237, 'All She Wants Is');

INSERT INTO Song (SongID, Name)
 VALUES(166, 'Humans Being');

INSERT INTO Song (SongID, Name)
 VALUES(21, 'Rapunzels Song');

INSERT INTO Song (SongID, Name)
 VALUES(105, 'Look At Me I''m Sandra Dee');

INSERT INTO Song (SongID, Name)
 VALUES(152, 'Mutant Dancing');

INSERT INTO Song (SongID, Name)
 VALUES(33, 'Let Em In');

INSERT INTO Song (SongID, Name)
 VALUES(103, 'Hopelessy Devoted to You');

INSERT INTO Song (SongID, Name)
 VALUES(50, 'Die S�mpfe Der Traurigkeit');

INSERT INTO Song (SongID, Name)
 VALUES(217, 'No Guts');

INSERT INTO Song (SongID, Name)
 VALUES(49, 'Swamps Of Sadness');

INSERT INTO Song (SongID, Name)
 VALUES(122, 'Desire');

INSERT INTO Song (SongID, Name)
 VALUES(245, 'The Man in the Mask');

INSERT INTO Song (SongID, Name)
 VALUES(219, 'Plop, Plop, Fizz, Fizz');

INSERT INTO Song (SongID, Name)
 VALUES(96, 'Spirit in the Sky');

INSERT INTO Song (SongID, Name)
 VALUES(207, 'The Earth Died Screaming');

INSERT INTO Song (SongID, Name)
 VALUES(79, 'I Got You (I Feel Good)');

INSERT INTO Song (SongID, Name)
 VALUES(145, 'Fire Dance');

INSERT INTO Song (SongID, Name)
 VALUES(22, 'Giants in the Sky');

INSERT INTO Song (SongID, Name)
 VALUES(90, 'City of Angels');

INSERT INTO Song (SongID, Name)
 VALUES(35, 'House of the Rising Sun');

INSERT INTO Song (SongID, Name)
 VALUES(58, 'Lovesick Blues');

INSERT INTO Song (SongID, Name)
 VALUES(18, 'Boov Death Song');

INSERT INTO Song (SongID, Name)
 VALUES(141, 'Bugle Charge');

INSERT INTO Song (SongID, Name)
 VALUES(186, 'With These Hands');

INSERT INTO Song (SongID, Name)
 VALUES(160, 'The Terminator');

INSERT INTO Song (SongID, Name)
 VALUES(13, 'Never Let you Down');

INSERT INTO Song (SongID, Name)
 VALUES(95, 'Magic Carpet Ride');

INSERT INTO Song (SongID, Name)
 VALUES(46, 'Sometimes');

INSERT INTO Song (SongID, Name)
 VALUES(140, 'The Girl In The Flying Trapeze');

INSERT INTO Song (SongID, Name)
 VALUES(242, 'High Hopes');

INSERT INTO Song (SongID, Name)
 VALUES(236, 'Where Do I Begin');

INSERT INTO Song (SongID, Name)
 VALUES(23, 'Stay with me');

INSERT INTO Song (SongID, Name)
 VALUES(193, 'Only Found Out Yesterday');

INSERT INTO Song (SongID, Name)
 VALUES(43, 'Eye of the Tiger');

INSERT INTO Song (SongID, Name)
 VALUES(65, 'Orange Minuet');

INSERT INTO Song (SongID, Name)
 VALUES(162, 'Lover, Come Back to Me');

INSERT INTO Song (SongID, Name)
 VALUES(191, 'Davy Jones');

INSERT INTO Song (SongID, Name)
 VALUES(203, 'Almost Home');

INSERT INTO Song (SongID, Name)
 VALUES(185, 'Tracks of my Tears');

INSERT INTO Song (SongID, Name)
 VALUES(201, 'Once This Was The Promise Land');

INSERT INTO Song (SongID, Name)
 VALUES(38, 'GOD BLESS THE CHILD');

INSERT INTO Song (SongID, Name)
 VALUES(117, 'Saturday Night Special');

INSERT INTO Song (SongID, Name)
 VALUES(167, 'Talula (BT''s Tornado Mix)');

INSERT INTO Song (SongID, Name)
 VALUES(30, 'Skttrbrain');

INSERT INTO Song (SongID, Name)
 VALUES(121, 'The Moment of Truth');

INSERT INTO Song (SongID, Name)
 VALUES(155, 'Ja, Vi Elsker Dette Landet');

INSERT INTO Song (SongID, Name)
 VALUES(48, 'Der Elfenbeinturm');

INSERT INTO Song (SongID, Name)
 VALUES(119, 'Take Me Back');

INSERT INTO Song (SongID, Name)
 VALUES(163, 'An Irish Party in Third Class');

INSERT INTO Song (SongID, Name)
 VALUES(129, 'Can''t You Hear Me Knocking');

INSERT INTO Song (SongID, Name)
 VALUES(247, 'The Phantom''s Theme');

INSERT INTO Song (SongID, Name)
 VALUES(42, 'Immortals');

INSERT INTO Song (SongID, Name)
 VALUES(32, 'El Condor Pasa');

INSERT INTO Song (SongID, Name)
 VALUES(243, 'Teach Me to Cheat');

INSERT INTO Song (SongID, Name)
 VALUES(239, 'Paint It Black');

INSERT INTO Song (SongID, Name)
 VALUES(115, 'Thunderstruck');

INSERT INTO Song (SongID, Name)
 VALUES(161, 'Dein ist mein ganzes Herz');

INSERT INTO Song (SongID, Name)
 VALUES(183, 'White Rabbit');

INSERT INTO Song (SongID, Name)
 VALUES(91, 'Waiting');

INSERT INTO Song (SongID, Name)
 VALUES(118, 'Long Cool Woman (In a Black Dress)');

INSERT INTO Song (SongID, Name)
 VALUES(181, 'Something''s Gotta Give');

INSERT INTO Song (SongID, Name)
 VALUES(231, 'Miss You');

INSERT INTO Song (SongID, Name)
 VALUES(202, 'This Perfect World');

INSERT INTO Song (SongID, Name)
 VALUES(194, 'Yo Ho (A Pirate''s Life for Me)');

INSERT INTO Song (SongID, Name)
 VALUES(228, 'The Drinking Song');

INSERT INTO Song (SongID, Name)
 VALUES(157, 'Bad to the Bone');

INSERT INTO Song (SongID, Name)
 VALUES(214, 'Unknown Rider');

INSERT INTO Song (SongID, Name)
 VALUES(4, 'The Funeral');

INSERT INTO Song (SongID, Name)
 VALUES(195, 'Crazy');

INSERT INTO Song (SongID, Name)
 VALUES(47, 'Die Unendliche Geschichte');

INSERT INTO Song (SongID, Name)
 VALUES(171, 'More than a Woman');

INSERT INTO Song (SongID, Name)
 VALUES(136, 'William Tell Overture: Finale');

INSERT INTO Song (SongID, Name)
 VALUES(108, 'La Bamba');

INSERT INTO Song (SongID, Name)
 VALUES(238, 'Flirtin'' With Disaster');

INSERT INTO Song (SongID, Name)
 VALUES(80, 'Born to Be Wild');

INSERT INTO Song (SongID, Name)
 VALUES(172, 'Darkness Darkness');

INSERT INTO Song (SongID, Name)
 VALUES(56, 'Balmoral');

INSERT INTO Song (SongID, Name)
 VALUES(62, 'Manhattan Serenade');

INSERT INTO Song (SongID, Name)
 VALUES(182, 'The Best Is Yet To Come');

INSERT INTO Song (SongID, Name)
 VALUES(226, 'Should I Stay or Should I Go');

INSERT INTO Song (SongID, Name)
 VALUES(52, 'A Beautiful Lie');

INSERT INTO Song (SongID, Name)
 VALUES(31, 'Darkly Mix');

INSERT INTO Song (SongID, Name)
 VALUES(224, 'I Wouldn''t Be Here If I Didn''t Love You');

INSERT INTO Song (SongID, Name)
 VALUES(34, 'Tougher Than the Rest');

INSERT INTO Song (SongID, Name)
 VALUES(241, 'I Can See Clearly Now');

INSERT INTO Song (SongID, Name)
 VALUES(196, 'Daydream');

INSERT INTO Song (SongID, Name)
 VALUES(205, 'Skeletons');

INSERT INTO Song (SongID, Name)
 VALUES(89, 'The Crow Descends');

INSERT INTO Song (SongID, Name)
 VALUES(26, 'Nobody knows the trouble I''ve seen');

INSERT INTO Song (SongID, Name)
 VALUES(150, 'Burnin'' In The Third Degree');

INSERT INTO Song (SongID, Name)
 VALUES(44, 'Edge of the Earth');

INSERT INTO Song (SongID, Name)
 VALUES(179, 'Ramblin'' Man');

INSERT INTO Song (SongID, Name)
 VALUES(69, 'It''s Our World');

INSERT INTO Song (SongID, Name)
 VALUES(63, 'Symphony No.9 in D Minor, Opus 125');

INSERT INTO Song (SongID, Name)
 VALUES(165, 'Lament');

INSERT INTO Song (SongID, Name)
 VALUES(148, 'Nocturne in E minor, Op. 72, No. 1');

INSERT INTO Song (SongID, Name)
 VALUES(55, 'Scatterin'' Monkey');

INSERT INTO Song (SongID, Name)
 VALUES(104, 'Sandy');

INSERT INTO Song (SongID, Name)
 VALUES(184, 'Okie from Muskogee');

INSERT INTO Song (SongID, Name)
 VALUES(17, 'Red Baloon');

INSERT INTO Song (SongID, Name)
 VALUES(74, 'Unaccompanied Cello Suite #1 in G Major BWV 1007 - Pr�lud�');

INSERT INTO Song (SongID, Name)
 VALUES(249, 'Wheres the Beef?');

INSERT INTO Song (SongID, Name)
 VALUES(159, 'Macho Man');

INSERT INTO Song (SongID, Name)
 VALUES(127, 'Strip my Mind');

INSERT INTO Song (SongID, Name)
 VALUES(188, 'O Little Town of Bethlehem');

INSERT INTO Song (SongID, Name)
 VALUES(85, 'Rule the World');

INSERT INTO Song (SongID, Name)
 VALUES(215, 'Just Out of Reach (Of My Two Open Arms)');

INSERT INTO Song (SongID, Name)
 VALUES(190, 'Yo Ho Ho and a Bottle of Rum');

INSERT INTO Song (SongID, Name)
 VALUES(158, 'Guitars, Cadillacs');

INSERT INTO Song (SongID, Name)
 VALUES(66, 'THEME FROM THE MONKEES');

INSERT INTO Song (SongID, Name)
 VALUES(54, '4 A Moment of Silence');

INSERT INTO Song (SongID, Name)
 VALUES(20, 'Cinderella at the Grave');

INSERT INTO Song (SongID, Name)
 VALUES(59, 'A Mighty Fortress Is Our God');

INSERT INTO Song (SongID, Name)
 VALUES(3, 'Like You');

INSERT INTO Song (SongID, Name)
 VALUES(198, 'Jessica');

INSERT INTO Song (SongID, Name)
 VALUES(15, 'Sacrifice');

INSERT INTO Song (SongID, Name)
 VALUES(25, 'Circle of Life');

INSERT INTO Song (SongID, Name)
 VALUES(70, 'Fat Bottomed Girls');

INSERT INTO Song (SongID, Name)
 VALUES(192, 'Two Hornpipes');

INSERT INTO Song (SongID, Name)
 VALUES(199, '(EVERYTHING I DO) I DO IT FOR YOU');

INSERT INTO Song (SongID, Name)
 VALUES(143, 'Blazing Saddles');

INSERT INTO Song (SongID, Name)
 VALUES(88, 'Jesu Meine Freude');

INSERT INTO Song (SongID, Name)
 VALUES(151, 'Long Tall Sally');

INSERT INTO Song (SongID, Name)
 VALUES(187, 'It''s Not Unusual');

INSERT INTO Song (SongID, Name)
 VALUES(28, 'Le Freak');

INSERT INTO Song (SongID, Name)
 VALUES(81, 'Hello');

INSERT INTO Song (SongID, Name)
 VALUES(72, 'Super Size Me');

INSERT INTO Song (SongID, Name)
 VALUES(144, 'Springtime for Hitler');

INSERT INTO Song (SongID, Name)
 VALUES(12, 'Blood Hands');

INSERT INTO Song (SongID, Name)
 VALUES(135, 'Tumbling Tumbleweeds');

INSERT INTO Song (SongID, Name)
 VALUES(174, 'Just Maintain');

INSERT INTO Song (SongID, Name)
 VALUES(164, 'My Heart Will Go On');

INSERT INTO Song (SongID, Name)
 VALUES(180, 'What A Girl Wants');

INSERT INTO Song (SongID, Name)
 VALUES(40, 'Szomor� Vas�rnap');

INSERT INTO Song (SongID, Name)
 VALUES(212, 'Alech Taadi');

INSERT INTO Song (SongID, Name)
 VALUES(116, 'Have You Ever Seen the Rain');

INSERT INTO Song (SongID, Name)
 VALUES(222, 'Speed');

INSERT INTO Song (SongID, Name)
 VALUES(36, 'Ole Man Trouble');

INSERT INTO Song (SongID, Name)
 VALUES(73, 'Bunsen Burner');

INSERT INTO Song (SongID, Name)
 VALUES(24, 'She''ll be back');

INSERT INTO Song (SongID, Name)
 VALUES(106, 'Blue Moon');

INSERT INTO Song (SongID, Name)
 VALUES(92, 'Somebody To Love');

INSERT INTO Song (SongID, Name)
 VALUES(154, 'Running out of Air');

INSERT INTO Song (SongID, Name)
 VALUES(128, 'Back in the Saddle');

INSERT INTO Song (SongID, Name)
 VALUES(125, 'Here I Go Again');

INSERT INTO Song (SongID, Name)
 VALUES(9, 'Fanfare for the History of Planet Earth');

INSERT INTO Song (SongID, Name)
 VALUES(123, 'Cruel Summer');

INSERT INTO Song (SongID, Name)
 VALUES(138, 'Red''s Theater Of The Absurd');

INSERT INTO Song (SongID, Name)
 VALUES(197, 'China Grove');

INSERT INTO Song (SongID, Name)
 VALUES(220, 'The Armour Hot Dog Jingle');

INSERT INTO Song (SongID, Name)
 VALUES(153, 'Rubble City');

INSERT INTO Song (SongID, Name)
 VALUES(110, 'I Can Do Better Than That');

INSERT INTO Song (SongID, Name)
 VALUES(240, 'Glowing In The Ashes');

INSERT INTO Song (SongID, Name)
 VALUES(114, 'Something That I Want');

INSERT INTO Song (SongID, Name)
 VALUES(189, 'Pirate Musk');

INSERT INTO Song (SongID, Name)
 VALUES(53, 'Carribean Sea');

INSERT INTO Song (SongID, Name)
 VALUES(139, 'Beautiful Dreamer');

INSERT INTO Song (SongID, Name)
 VALUES(41, 'All Love Cab Be');

INSERT INTO Song (SongID, Name)
 VALUES(112, 'Learn To Be Lonely');

INSERT INTO Song (SongID, Name)
 VALUES(229, 'There You''ll Be');

INSERT INTO Song (SongID, Name)
 VALUES(75, 'Enola Gay');

INSERT INTO Song (SongID, Name)
 VALUES(61, 'Luna mezz'' ''o mare');

INSERT INTO Song (SongID, Name)
 VALUES(97, 'Kagura-No-Netori');

INSERT INTO Song (SongID, Name)
 VALUES(209, 'Mister Big Time');

INSERT INTO Song (SongID, Name)
 VALUES(2, 'Taya''s Theme');

INSERT INTO Song (SongID, Name)
 VALUES(51, 'Down to Earth');

INSERT INTO Song (SongID, Name)
 VALUES(27, 'Accidentally in Love');

INSERT INTO Song (SongID, Name)
 VALUES(170, 'I Never Thought I''d See the Day');

INSERT INTO Song (SongID, Name)
 VALUES(78, 'Love Was My Alibi');

INSERT INTO Song (SongID, Name)
 VALUES(19, 'Drop That');

INSERT INTO Song (SongID, Name)
 VALUES(126, 'Good Times Bad Times');

INSERT INTO Song (SongID, Name)
 VALUES(113, 'When Will My Life Begin');

INSERT INTO Song (SongID, Name)
 VALUES(99, 'The 2nd Law: Isolated System');

INSERT INTO Song (SongID, Name)
 VALUES(87, 'Almost Home');

INSERT INTO Song (SongID, Name)
 VALUES(57, 'If I Didn''t Care');

INSERT INTO Song (SongID, Name)
 VALUES(221, 'My Dog''s Better Than Your Dog');

INSERT INTO Song (SongID, Name)
 VALUES(76, 'Opportunity');

INSERT INTO Song (SongID, Name)
 VALUES(234, 'Love the One You''re with');

INSERT INTO Song (SongID, Name)
 VALUES(16, 'Carry Me Home');

INSERT INTO Song (SongID, Name)
 VALUES(68, 'So Alive');

INSERT INTO Song (SongID, Name)
 VALUES(10, 'Star Spangled Banner');

INSERT INTO Song (SongID, Name)
 VALUES(71, 'Cheeseburger In Paradise');

INSERT INTO Song (SongID, Name)
 VALUES(86, 'The Munchkin Welcome Song');

INSERT INTO Song (SongID, Name)
 VALUES(29, 'Changes');

INSERT INTO Song (SongID, Name)
 VALUES(101, 'Follow Me');

INSERT INTO Song (SongID, Name)
 VALUES(218, 'Demolition Man');

INSERT INTO Song (SongID, Name)
 VALUES(146, 'Le Danse Macabre');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(206, 'Mysterious Processes Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(134, 'Hollywood Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(69, 'RatPac-Dune Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(194, 'Columbia Pictures Television');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(160, 'Cinema 86');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(44, 'Chicago Pacific Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(54, 'Saban Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(148, 'Prime Focus');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(6, 'Walt Disney Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(34, 'Celador Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(149, 'Canal Plus Image International');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(68, 'Energy Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(109, 'Sh-K-Boom Records');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(110, 'Grand Peaks Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(101, 'Original Film');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(174, 'Newmarket Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(113, 'Limelight International Media Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(89, 'Twentieth Century Fox Film Corporation');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(120, 'Closest to the Hole Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(61, 'Novaya Zemlya');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(66, 'DNA Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(204, 'DB Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(196, 'Golan-Globus Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(132, 'Majestic Films International');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(205, 'Missing Homework Inc (MHI)');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(63, 'The Con');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(107, 'Allan Carr');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(188, 'Incorporated Television Company (ITC)');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(74, 'Scott Free Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(178, 'Kopelson Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(121, 'Fighter');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(187, 'Wrather Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(22, 'Walt Disney Feature Animation');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(95, 'Northern Lights Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(181, 'Pacific Data Images (PDI)');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(104, 'Skydance Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(4, 'Lucasfilm');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(127, 'Media Rights Capital');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(28, 'Warner Entertainment Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(56, 'Freedom Media');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(27, 'Pacific Data Images');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(139, 'American Entertainment Partners L.P.');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(136, 'Pacific Western');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(129, 'Blind Wink Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(40, 'Ladd Company');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(65, 'Studio On Hudson');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(32, 'Pacific Standard');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(151, 'Touchstone Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(172, 'Tall Trees Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(189, 'Turner Network Television (TNT)');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(21, 'Anton Capital Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(96, 'Animal Kingdom');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(60, 'Piraya Film A/S');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(35, 'Harpo Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(186, 'China Film Group');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(106, 'Robert Stigwood Organization (RSO)');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(193, 'Joseph M. Schenck Enterprises');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(91, 'Cruise/Wagner Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(81, 'Buttercup Films Ltd.');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(161, 'Second Mate Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(137, 'Euro Film Funding');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(116, 'Chartoff-Winkler Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(153, 'Kennedy/Marshall Company');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(82, 'The Princess Bride Ltd.');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(43, 'Walden Media');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(5, 'Bad Robot');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(150, 'Dino De Laurentis Company');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(75, 'Babieka');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(102, 'Scholastic Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(93, 'Centropolis Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(94, 'Mutual Film');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(131, 'Tig Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(128, 'Jerry Bruckheimer Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(50, 'Syncopy');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(90, 'The Bedford Falls Company');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(58, 'Revelin Studios');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(20, 'Aardman Animations');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(83, 'Marv Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(201, 'Hammer Film Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(197, '21st Century Film Corporation');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(182, 'Albert S. Ruddy Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(73, 'Chernin Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(9, 'Forward Pass');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(159, 'Wind Dancer');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(185, 'Overbrook Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(11, 'Dune Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(157, 'Interscope Communications');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(146, 'IMF Internationale Medien und Film GmbH & Co. 3. produktions KG');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(133, 'Cinergi Pictures Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(135, 'Hemdale Film');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(145, 'Intermedia Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(162, 'Moving Picture Company (MPC)');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(77, 'Hopscotch Features');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(138, 'Amercent Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(79, 'TF1 Films Production');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(23, 'DENTSU Music and Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(16, 'Dreamworks Animation');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(88, 'Constantin Film International');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(29, 'Thousand Words');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(39, 'Icon Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(105, 'Hemisphere Media Capital');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(143, 'Lightstorm Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(198, 'Breton Film Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(72, 'Bristol Automotive');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(164, 'Morgan Creek Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(52, 'Alfran Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(3, 'Village Roadshow Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(51, 'Castle Rock Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(144, 'C-2 Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(167, 'Valhalla Motion Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(154, 'Silver Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(92, 'Columbia Pictures Corporation');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(183, 'Long Road Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(18, 'Marc Platt Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(7, 'Warner Bros.');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(38, 'Imagine Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(31, 'Fox Searchlight Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(86, 'TriStar Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(111, 'Odyssey Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(37, 'Amblin Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(108, 'Lucky Monkey Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(119, 'Delphi Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(48, 'Pixar Animation Studios');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(55, 'Code Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(33, 'Cloud Eight Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(26, 'DreamWorks SKG');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(184, 'Silver Screen Partners IV');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(78, 'RatPac Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(49, 'New Line Cinema');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(191, 'Warner Bros. Television');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(1, 'Marvel Studios');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(76, 'Fear of God Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(123, 'Left Tackle Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(176, 'Blue Light');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(158, 'Badham-Cohen Group');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(85, 'Roth Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(70, 'Vertigo Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(140, 'Davis Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(98, 'Metro-Goldwyn-Mayer (MGM)');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(130, 'Crossbow Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(156, 'Icon Entertainment International');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(36, 'Universal Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(192, 'Cooga Mooga');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(13, 'Red Wagon Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(166, 'Classico');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(155, 'Donner/Shuler-Donner Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(67, 'Film4');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(203, 'Harbor Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(126, 'Fuzzy Door Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(87, 'FilmDistrict');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(125, 'Bluegrass Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(179, 'Carolco Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(64, 'Kathbur Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(53, 'Hawk Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(14, 'Mandeville Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(100, 'Columbia Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(42, 'Walt Disney Animation Studios');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(147, 'Total Recall');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(170, 'Barry Mendel Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(117, 'United Artists');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(202, 'Robert Halmi');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(152, 'Blinding Edge Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(171, 'Regency Enterprises');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(12, 'Paramount Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(62, 'South Central Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(177, 'Relativity Media');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(84, 'Vaughn productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(190, 'Turner Television');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(168, 'Gaumont');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(30, 'Section Eight');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(80, 'Act III Communications');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(15, 'Paragon Studios');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(19, 'StudioCanal');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(45, 'Neue Constantin Film');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(195, 'High Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(46, 'Bavaria Studios');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(122, 'Alcon Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(169, 'Spyglass Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(142, 'Carlco International N.V.');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(200, 'Cine 2000');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(71, 'Black Bear Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(10, 'Legendary Pictures');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(47, 'Westdeutscher Rundfunk');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(163, 'Gordon Company');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(97, 'Two Flints');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(57, 'Wonderspun');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(173, 'Media 8 Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(180, 'Canal+');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(59, 'Final Cut for Real');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(115, 'Happy Madison Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(118, 'Jerry Weintraub Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(103, 'Michael De Luca Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(24, 'Nibariki');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(25, 'Nippon Television network');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(8, 'Mad Chance Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(112, 'Really Useful Films');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(165, 'Atlas Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(41, 'The B.H. Finance C.V.');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(99, 'SLM Production Group');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(17, 'Lucamar Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(124, 'Zucker/Netter productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(199, 'Medusa Film');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(114, 'Goldrush Entertainment');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(2, 'Kennedy Miller Productions');

INSERT INTO Distributor (DistributorID, DistributorName)
 VALUES(175, 'DEJ Productions');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(131, 'Registration Day', '2001-07-13', 0.88, 1.60, 2.1, 'A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(115, 'Beauty and the beast', '1991-09-29', 2.02, 4.28, 8, 'G');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(24, 'WALL-E', '2008-06-27', 2.15, 4.52, 8.4, 'G');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(47, 'Kingdom of Heaven', '2005-05-02', 1.87, 3.85, 7.2, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(56, 'Grease', '1978-06-13', 1.82, 3.89, 7.2, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(61, 'The Longest Yard', '2005-05-27', 1.66, 3.43, 6.3, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(84, 'Bird on a Wire', '1990-05-18', 1.47, 3.06, 5.8, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(57, 'The Last Five Years', '2014-09-07', 1.77, 3.51, 6.1, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(31, 'Monkey Kingdom', '2015-04-17', 2.31, 4.54, 7.3, 'G');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(67, 'The Lone Ranger', '2013-06-22', 1.80, 3.60, 6.5, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(41, 'Paddington', '2014-11-23', 2.04, 4.10, 7.3, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(26, 'The Dark Knight', '2008-07-14', 2.31, 4.86, 9, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(91, 'Pirates of the Caribbean: On Stranger Tides�', '2011-05-07', 1.87, 3.79, 6.7, 'G');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(35, 'Super Size Me', '2004-05-07', 1.98, 4.12, 7.3, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(107, 'Pearl Harbor', '2001-05-21', 1.73, 3.55, 6, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(1, 'Avengers: Age of Ultron', '2015-04-22', 2.17, 4.29, 8.1, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(12, 'The Lion King', '1994-06-15', 1.97, 4.21, 8.5, 'G');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(123, 'Phantom of the Opera', '1943-09-12', 1.47, 3.21, 6.5, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(63, 'The Karate Kid', '1984-06-22', 1.67, 3.56, 7.2, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(77, 'U-571', '2000-04-17', 1.72, 3.56, 6.6, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(74, 'Total Recall', '2012-09-02', 1.94, 3.89, 6.3, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(15, 'A Scanner Darkly', '2006-07-28', 1.90, 3.91, 7.1, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(45, 'OZ the great and Powerful', '2013-02-14', 1.85, 3.68, 6.4, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(23, 'The Neverending Story', '1984-04-06', 1.91, 4.05, 7.4, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(94, 'Waterworld', '1995-07-28', 1.70, 3.54, 6.1, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(60, 'Tangled', '2010-11-24', 2.00, 4.10, 7.8, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(72, 'Predator', '1987-06-12', 1.79, 3.84, 7.8, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(49, 'The Last Samurai', '2003-11-22', 1.89, 3.92, 7.7, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(108, 'Prometheus', '2012-05-30', 1.90, 3.84, 7, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(90, 'Pirates of the Caribbean: At World''s End�', '2007-05-19', 1.80, 3.75, 7.1, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(128, 'Phantom of the Opera', '1983-01-29', 1.32, 2.80, 5.8, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(7, 'Interstellar', '2014-10-29', 2.18, 4.46, 8.7, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(93, 'Robin Hood: Prince of Thieves�', '1991-06-14', 1.60, 3.38, 6.9, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(13, 'Princess Mononke', '1997-07-12', 1.92, 4.09, 8.4, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(101, 'Unbreakable', '2000-11-14', 1.77, 3.69, 7.2, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(82, 'Conspiracy Theory', '1997-09-07', 1.66, 3.49, 6.7, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(33, 'The Act of Killing', '2012-11-01', 2.23, 4.55, 8.2, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(51, 'It Follows', '2015-03-27', 2.17, 4.21, 7.4, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(55, 'World War Z', '2013-06-02', 1.89, 3.80, 7, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(89, 'Pirates of the Caribbean: Dead Man''s Chest�', '2006-06-24', 1.76, 3.68, 7.3, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(28, 'The Godfather', '1972-03-15', 2.06, 4.43, 9.2, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(53, 'Goosebumps', '2015-10-09', 1.96, 3.75, 6, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(109, 'Monster', '2003-11-16', 1.93, 4.01, 7.3, '18A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(132, 'Revenge of the DBA', '2014-08-31', 2.56, 5.27, 9.8, 'U');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(126, 'Phantom of the Opera', '1998-11-20', 1.19, 2.41, 4.2, '18A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(36, 'Ex Machina', '2015-04-10', 2.39, 4.69, 8.1, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(92, 'Field of Dreams', '1989-04-21', 1.85, 3.96, 7.6, 'G');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(43, 'The Goonies', '1985-06-07', 1.92, 4.09, 7.8, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(29, 'A Clockwork Orange', '1971-12-19', 1.99, 4.25, 8.4, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(120, 'Journey to the center of the earth', '1959-12-16', 1.62, 3.53, 7, 'G');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(103, 'Speed', '1994-06-10', 1.75, 3.69, 7.2, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(71, 'Terminator', '1984-10-24', 1.84, 3.96, 8.1, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(76, 'Terminator 3: Rise of the Machines ', '2003-06-30', 1.66, 3.43, 6.4, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(80, 'True Lies', '1994-07-15', 1.92, 4.03, 7.2, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(79, 'Twister', '1996-05-10', 1.78, 3.71, 6.3, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(83, 'The Man Without a Face', '1993-09-25', 1.64, 3.45, 6.7, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(124, 'Phantom of the Opera', '1925-04-26', 1.82, 3.97, 7.7, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(121, 'Journey to the center of the earth', '1993-02-28', 1.02, 2.03, 3, 'G');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(17, 'Selma', '2014-11-11', 2.22, 4.48, 7.6, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(6, 'Jupiter Ascending', '2015-02-04', 1.97, 3.76, 5.6, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(38, 'The Imitation Game', '2014-11-28', 2.04, 4.15, 8.1, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(102, 'Demolition Man', '1993-10-07', 1.56, 3.28, 6.6, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(81, 'Signs', '2002-07-29', 1.71, 3.55, 6.7, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(100, 'The Six Sense', '1999-09-02', 1.91, 4.06, 8.2, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(98, 'Armageddon', '1998-06-30', 1.59, 3.34, 6.6, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(73, 'Total Recall', '1990-06-01', 1.77, 3.71, 7.5, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(106, '28 Days', '2000-02-08', 1.54, 3.17, 6, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(113, 'Antz', '1998-09-19', 1.55, 3.26, 6.6, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(119, 'The Lone Ranger', '2003-02-26', 1.36, 2.78, 5.1, 'G');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(25, 'Journey to the Center of the Earth', '2008-07-11', 1.53, 3.14, 5.8, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(54, 'Dracula Untold', '2014-10-01', 1.74, 3.46, 6.3, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(2, 'Mad Max Fury Road', '2015-05-07', 2.59, 5.13, 9.3, 'A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(86, 'Platoon', '1986-12-19', 1.93, 4.10, 8.1, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(129, 'Phantom of the Paradise', '1974-10-31', 1.88, 4.02, 7.3, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(50, 'The Patriot', '2000-06-27', 1.78, 3.70, 7.1, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(20, 'BraveHeart', '1995-05-19', 2.03, 4.27, 8.4, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(68, 'Blazing Saddles', '1974-02-07', 1.79, 3.82, 7.8, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(85, 'What Women Want', '2000-12-13', 1.64, 3.39, 6.4, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(18, 'Schindlers List', '1993-11-30', 2.24, 4.70, 8.9, 'A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(48, 'Apollo 13', '1995-06-22', 1.85, 3.90, 7.6, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(87, 'Edward Scissorhands', '1990-12-06', 1.99, 4.21, 8, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(39, 'Exodus: Gods and Kings', '2014-12-03', 1.86, 3.69, 6.1, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(4, 'American Sniper', '2015-01-16', 2.04, 3.95, 7.4, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(27, 'The Shawshank Redemption', '1994-09-23', 2.31, 4.88, 9.3, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(42, 'The Princess Bride', '1987-09-25', 2.07, 4.41, 8.2, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(8, 'Insurgent', '2015-03-11', 1.93, 3.75, 6.9, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(78, 'Titanic', '1997-11-01', 1.94, 4.10, 7.7, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(40, 'The Water Diviner', '2014-12-11', 1.97, 3.93, 7.3, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(9, 'Home', '2015-03-27', 2.01, 3.89, 6.8, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(105, 'A Time to Kill', '1996-07-24', 1.83, 3.86, 7.4, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(5, 'Blackhat', '2015-01-15', 1.76, 3.29, 5.4, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(122, 'Journey to the center of the earth', '1988-07-30', 0.85, 1.72, 2.7, 'G');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(112, 'Basic Instinct', '1992-03-20', 1.84, 3.82, 6.9, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(62, 'Rocky', '1976-11-21', 2.00, 4.29, 8.1, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(65, 'The Blind Side', '2009-11-17', 2.00, 4.18, 7.7, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(30, 'The Forger', '2015-04-24', 1.76, 3.28, 5.6, 'A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(69, 'Dances with Wolves', '1990-12-19', 1.98, 4.19, 8, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(34, 'Tales of the Grim Sleeper', '2014-08-29', 2.05, 4.11, 7.2, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(88, 'Pirates of the Caribbean: The Curse of the Black Pearl ', '2003-06-28', 2.02, 4.24, 8.1, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(97, 'Twelve monkeys', '1995-12-27', 1.97, 4.18, 8.1, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(96, 'Die Hard', '1988-07-15', 2.10, 4.45, 8.3, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(10, 'Into the woods', '2014-12-08', 1.82, 3.60, 6.1, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(75, 'Terminator 2: Judgment Day ', '1991-07-01', 2.04, 4.33, 8.5, '18A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(99, 'The Fifth Element', '1997-05-07', 1.81, 3.83, 7.6, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(95, 'The Postman', '1997-12-12', 1.52, 3.17, 5.9, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(14, 'Shrek 2', '2004-05-19', 1.75, 3.64, 7.2, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(66, 'A Million Ways to Die in the West', '2014-05-15', 1.83, 3.59, 6.1, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(11, 'Shaun the Sheep Movie', '2015-02-06', 2.14, 4.21, 7.5, 'G');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(130, 'Whats Up Dude?', '2001-06-11', 0.60, 1.01, 1.1, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(125, 'Phantom of the Opera', '1989-11-04', 1.38, 2.86, 5.4, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(32, 'Manny', '2014-03-08', 1.98, 3.99, 7.3, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(110, 'Hancock', '2008-06-16', 1.69, 3.50, 6.5, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(52, 'Poltergeist', '2015-05-21', 2.18, 4.26, 7.4, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(58, 'The Phantom of the Opera', '2004-12-09', 1.83, 3.82, 7.4, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(104, 'Stolen Hearts (Two if by Sea)', '1996-01-12', 1.59, 3.23, 5.1, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(64, 'The Fighter', '2010-12-17', 2.06, 4.20, 7.9, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(22, 'Holes', '2003-04-18', 1.72, 3.58, 7.1, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(116, 'The Karate Kid', '2010-06-10', 1.65, 3.33, 6.2, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(117, 'The Lone Ranger', '1956-02-10', 1.52, 3.33, 6.9, 'G');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(3, 'Star Wars Episode VII - The Force Awakens', '2015-12-16', 2.79, 5.62, 9.9, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(21, 'Big Hero 6', '2014-10-25', 2.02, 4.09, 7.9, 'PG');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(16, 'Wild', '2014-12-05', 1.89, 3.74, 7.2, 'A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(118, 'The Legend of The Lone Ranger', '1981-05-22', 1.45, 3.03, 4.9, 'G');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(19, 'A Beautiful Mind', '2002-01-04', 1.94, 4.08, 8.2, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(111, 'Devil''s Advocate', '1997-10-17', 1.90, 3.97, 7.5, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(114, 'The Longest Yard', '1974-09-21', 1.62, 3.49, 7.1, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(44, 'Stardust', '2007-09-09', 2.06, 4.30, 7.7, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(127, 'Phantom of the Opera', '1962-06-25', 1.52, 3.27, 6.4, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(59, 'Beauty and the Beast', '2010-02-11', 2.15, 4.43, 8, 'G');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(37, 'Run All Night', '2015-03-13', 1.95, 3.75, 6.9, 'R');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(46, 'Pompei', '2014-02-18', 1.69, 3.32, 5.6, '14A');

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
 VALUES(70, 'Tombstone', '1993-12-24', 1.88, 3.94, 7.8, 'R');

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(131, 866,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(130, 864,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(89, 255,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(99, 596,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(95, 223,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(104, 175,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(1, 672,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(2, 373,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(89, 468,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(87, 815,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(5, 247,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(12, 438,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(38, 350,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(34, 162,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(48, 372,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(36, 791,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(38, 235,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(132, 863,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(89, 145,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(23, 384,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(54, 301,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(107, 382,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(2, 412,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(32, 460,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(85, 341,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(114, 97,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(40, 224,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(88, 255,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(98, 95,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(64, 90,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(32, 604,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(93, 530,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(103, 408,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(52, 599,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(73, 423,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(22, 472,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(99, 776,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(117, 137,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(23, 737,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(25, 413,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(124, 197,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(119, 106,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(83, 341,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(99, 827,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(90, 586,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(62, 697,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(64, 119,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(117, 700,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(40, 231,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(104, 261,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(77, 448,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(89, 586,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(64, 794,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(61, 645,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(78, 833,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(111, 642,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(84, 193,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(105, 538,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(37, 466,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(114, 479,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(8, 758,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(50, 483,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(109, 755,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(118, 715,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(104, 482,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(84, 386,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(108, 525,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(35, 718,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(128, 684,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(123, 635,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(19, 231,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(33, 212,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(91, 255,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(81, 341,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(108, 634,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(80, 614,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(80, 688,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(15, 272,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(13, 531,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(100, 600,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(44, 240,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(44, 226,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(93, 326,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(18, 579,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(68, 624,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(83, 721,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(60, 571,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(110, 755,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(18, 311,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(101, 841,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(119, 163,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(123, 321,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(74, 305,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(94, 408,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(60, 490,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(6, 751,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(107, 95,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(65, 89,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(19, 213,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(44, 550,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(94, 223,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(8, 839,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(91, 134,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(98, 827,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(50, 651,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(7, 200,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(57, 449,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(106, 570,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(96, 654,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(101, 428,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(58, 669,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(108, 755,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(14, 575,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(25, 157,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(82, 657,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(82, 727,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(24, 336,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(127, 253,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(47, 145,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(56, 583,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(91, 233,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(59, 607,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(62, 723,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(72, 688,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(50, 341,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(90, 255,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(58, 831,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(62, 848,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(45, 324,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(18, 465,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(61, 679,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(114, 841,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(55, 627,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(103, 243,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(10, 735,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(66, 755,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(81, 623,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(19, 376,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(3, 314,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(67, 370,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(48, 118,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(105, 428,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(15, 642,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(41, 385,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(28, 182,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(66, 515,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(2, 755,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(97, 733,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(49, 214,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(116, 710,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(82, 341,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(99, 407,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(73, 227,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(100, 211,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(95, 613,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(4, 335,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(30, 629,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(35, 799,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(106, 175,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(39, 119,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(97, 627,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(41, 149,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(75, 688,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(46, 170,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(58, 179,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(3, 368,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(20, 542,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(32, 579,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(54, 219,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(92, 223,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(16, 835,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(132, 867,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(49, 803,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(67, 255,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(78, 851,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(1, 300,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(70, 675,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(47, 354,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(12, 422,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(20, 341,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(9, 855,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(53, 674,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(121, 319,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(21, 93,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(30, 696,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(96, 827,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(46, 374,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(66, 579,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(127, 689,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(38, 468,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(71, 140,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(132, 862,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(123, 288,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(69, 223,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(125, 418,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(16, 257,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(86, 237,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(122, 621,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(122, 135,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(42, 612,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(1, 432,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(35, 425,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(88, 468,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(26, 483,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(110, 123,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(116, 391,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(29, 518,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(57, 553,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(54, 332,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(118, 499,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(63, 514,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(45, 808,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(40, 471,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(132, 866,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(128, 694,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(12, 158,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(28, 156,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(42, 296,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(6, 470,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(6, 640,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(42, 841,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(125, 685,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(33, 469,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(115, 131,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(36, 424,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(63, 565,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(48, 614,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(73, 688,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(53, 142,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(129, 312,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(108, 307,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(37, 376,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(5, 748,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(103, 175,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(71, 369,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(72, 804,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(85, 769,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(33, 109,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(37, 579,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(9, 526,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(79, 416,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(117, 559,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(113, 732,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(79, 296,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(94, 774,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(92, 399,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(100, 827,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(11, 264,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(116, 196,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(60, 560,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(47, 579,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(98, 780,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(10, 449,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(27, 656,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(111, 755,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(76, 501,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(109, 256,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(9, 608,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(11, 714,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(101, 827,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(78, 260,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(103, 642,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(7, 538,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(51, 508,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(107, 127,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(51, 558,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(119, 573,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(4, 218,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(52, 820,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(125, 297,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(69, 540,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(20, 523,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(99, 444,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(121, 275,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(39, 465,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(52, 580,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(106, 811,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(122, 187,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(3, 318,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(4, 550,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(87, 255,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(26, 119,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(15, 676,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(17, 602,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(43, 206,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(67, 309,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(55, 298,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(129, 375,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(92, 438,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(11, 315,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(118, 411,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(57, 442,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(110, 711,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(56, 772,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(96, 128,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(22, 792,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(109, 647,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(59, 343,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(17, 670,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(30, 772,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(88, 673,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(14, 572,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(76, 721,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(115, 594,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(111, 603,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(14, 259,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(29, 541,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(29, 124,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(126, 258,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(24, 467,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(8, 294,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(21, 202,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(65, 543,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(74, 228,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(53, 677,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(61, 661,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(72, 367,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(80, 111,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(120, 529,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(124, 620,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(21, 633,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(84, 341,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(46, 741,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(127, 503,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(49, 232,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(89, 377,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(120, 238,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(91, 673,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(87, 676,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(121, 554,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(102, 712,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(5, 387,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(76, 688,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(10, 625,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(105, 175,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(126, 680,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(129, 352,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(27, 361,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(90, 145,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(69, 358,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(86, 695,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(115, 220,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(45, 821,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(71, 688,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(75, 369,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(95, 750,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(39, 289,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(70, 295,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(70, 459,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(72, 194,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(75, 329,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(83, 814,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(132, 864,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(93, 223,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(112, 270,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(81, 234,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(86, 133,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(90, 377,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(43, 113,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(65, 175,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(16, 399,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(77, 538,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(31, 308,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(90, 468,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(1, 272,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(80, 236,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(13, 426,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(26, 285,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(102, 175,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(77, 614,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(22, 805,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(41, 800,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(102, 723,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(7, 383,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(23, 597,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(90, 673,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(17, 291,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(51, 342,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(79, 614,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(59, 802,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(27, 326,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(68, 498,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(113, 98,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(113, 363,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(28, 603,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(63, 698,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(97, 827,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(88, 145,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(120, 150,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(70, 614,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(132, 865,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(74, 838,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(98, 761,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(25, 325,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(126, 108,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(68, 816,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(85, 416,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(112, 280,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(55, 454,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(73, 732,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(24, 178,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(128, 845,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(36, 346,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(124, 453,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(91, 547,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(13, 747,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(129, 822,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(92, 517,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(43, 159,  null );

INSERT INTO MovieActor (MovieID, ContributorID, Billing)
 VALUES(56, 198,  null );

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(2, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(115, 'AN');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(126, 'HO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(46, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(71, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(43, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(113, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(23, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(15, 'AN');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(60, 'AN');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(14, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(35, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(24, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(89, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(21, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(120, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(5, 'MY');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(65, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(25, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(40, 'WA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(3, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(24, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(70, 'WE');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(79, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(100, 'MY');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(50, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(74, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(78, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(1, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(32, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(4, 'BI');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(98, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(5, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(51, 'MY');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(74, 'MY');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(49, 'WA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(22, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(8, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(9, 'AN');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(97, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(82, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(24, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(95, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(129, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(119, 'WE');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(61, 'CG');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(104, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(103, 'CG');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(84, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(35, 'DO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(85, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(67, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(6, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(59, 'AN');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(9, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(94, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(45, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(24, 'AN');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(9, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(36, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(101, 'MY');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(43, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(56, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(84, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(110, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(21, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(108, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(120, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(104, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(2, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(57, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(43, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(70, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(20, 'EH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(23, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(65, 'SP');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(42, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(88, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(15, 'MY');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(44, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(63, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(87, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(120, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(55, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(57, 'MD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(88, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(55, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(99, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(21, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(23, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(128, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(41, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(117, 'WE');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(29, 'CG');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(26, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(57, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(42, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(67, 'WE');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(19, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(105, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(77, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(11, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(42, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(21, 'AN');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(81, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(12, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(21, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(116, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(55, 'HO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(47, 'EH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(54, 'HO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(59, 'MD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(62, 'SP');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(122, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(55, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(20, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(81, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(53, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(60, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(82, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(37, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(97, 'MY');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(29, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(73, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(97, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(120, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(59, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(125, 'MD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(59, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(106, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(47, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(15, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(127, 'MD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(95, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(58, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(37, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(63, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(109, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(3, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(68, 'WE');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(75, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(58, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(82, 'MY');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(12, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(12, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(84, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(106, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(96, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(86, 'WA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(90, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(105, 'CG');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(42, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(116, 'SP');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(62, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(36, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(11, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(118, 'WE');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(2, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(31, 'DO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(44, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(113, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(37, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(121, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(129, 'MD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(89, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(10, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(34, 'CG');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(42, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(21, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(123, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(96, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(25, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(63, 'SP');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(65, 'BI');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(100, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(6, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(108, 'MY');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(46, 'EH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(80, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(125, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(33, 'DO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(56, 'MD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(3, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(111, 'MY');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(103, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(55, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(118, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(73, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(7, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(79, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(81, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(46, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(39, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(95, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(49, 'EH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(54, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(32, 'SP');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(46, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(114, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(64, 'BI');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(39, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(38, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(102, 'CG');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(37, 'MY');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(35, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(123, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(129, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(91, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(11, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(94, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(5, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(30, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(60, 'MD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(90, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(72, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(48, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(69, 'WE');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(40, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(70, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(115, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(16, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(12, 'MD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(77, 'WA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(45, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(60, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(17, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(8, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(6, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(48, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(48, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(18, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(47, 'WA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(112, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(85, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(92, 'SP');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(54, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(67, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(64, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(58, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(1, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(22, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(105, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(13, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(60, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(94, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(74, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(123, 'MD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(112, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(119, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(63, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(47, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(93, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(61, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(114, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(80, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(92, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(107, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(27, 'CG');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(23, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(26, 'CG');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(41, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(87, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(4, 'WA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(43, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(33, 'EH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(72, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(75, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(102, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(54, 'WA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(14, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(69, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(5, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(57, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(48, 'EH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(52, 'HO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(95, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(13, 'AN');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(118, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(30, 'CG');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(64, 'SP');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(110, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(50, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(14, 'AN');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(37, 'CG');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(39, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(115, 'MD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(66, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(111, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(85, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(89, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(17, 'BI');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(50, 'WA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(22, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(58, 'MD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(102, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(127, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(129, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(25, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(80, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(38, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(29, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(109, 'CG');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(102, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(86, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(14, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(93, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(112, 'MY');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(12, 'AN');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(101, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(127, 'HO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(34, 'DO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(9, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(128, 'HO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(53, 'HO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(115, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(10, 'MD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(70, 'EH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(117, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(125, 'HO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(78, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(69, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(3, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(25, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(13, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(101, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(4, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(107, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(98, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(9, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(79, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(44, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(108, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(84, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(20, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(109, 'BI');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(51, 'HO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(66, 'WE');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(10, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(28, 'CG');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(38, 'WA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(82, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(15, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(44, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(27, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(72, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(85, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(25, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(4, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(79, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(46, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(116, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(93, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(98, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(82, 'CG');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(22, 'MY');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(94, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(127, 'MY');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(71, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(1, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(11, 'AN');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(91, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(22, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(76, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(74, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(129, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(59, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(20, 'WA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(7, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(83, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(123, 'HO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(68, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(101, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(50, 'EH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(60, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(74, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(5, 'CG');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(87, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(107, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(93, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(92, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(45, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(120, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(92, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(114, 'CG');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(123, 'RO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(115, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(28, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(54, 'FA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(103, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(127, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(98, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(8, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(38, 'BI');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(26, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(49, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(20, 'BI');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(53, 'CO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(113, 'AN');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(14, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(76, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(30, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(116, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(49, 'DR');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(100, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(18, 'BI');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(47, 'AC');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(61, 'SP');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(113, 'FM');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(2, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(124, 'HO');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(17, 'EH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(111, 'TH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(99, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(19, 'BI');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(9, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(90, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(18, 'EH');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(107, 'WA');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(114, 'SP');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(91, 'AD');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(99, 'SF');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(16, 'BI');

INSERT INTO MovieGenre (MovieID, GenreID)
 VALUES(32, 'DO');

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(106, 227);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(62, 119);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(61, 116);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(98, 208);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(14, 29);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(113, 241);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(78, 164);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(93, 200);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(56, 105);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(63, 122);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(64, 128);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(75, 158);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(97, 206);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(18, 40);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(107, 229);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(22, 45);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(27, 58);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(29, 65);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(71, 149);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(21, 44);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(9, 17);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(61, 118);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(57, 109);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(26, 55);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(67, 139);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(108, 232);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(101, 216);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(41, 80);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(43, 84);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(36, 73);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(18, 39);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(41, 79);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(15, 31);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(48, 94);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(64, 125);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(31, 69);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(23, 49);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(70, 147);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(80, 172);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(109, 237);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(19, 41);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(107, 230);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(60, 114);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(28, 62);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(90, 193);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(48, 92);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(89, 192);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(26, 56);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(48, 91);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(93, 199);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(55, 100);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(114, 117);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(73, 152);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(108, 234);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(6, 8);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(18, 38);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(84, 177);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(45, 86);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(98, 210);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(17, 37);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(27, 57);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(129, 247);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(83, 175);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(98, 211);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(70, 146);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(89, 190);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(56, 102);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(73, 153);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(14, 27);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(106, 228);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(24, 52);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(102, 218);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(12, 25);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(114, 243);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(109, 238);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(78, 163);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(10, 24);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(48, 95);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(8, 13);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(5, 5);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(101, 217);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(117, 244);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(47, 89);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(56, 103);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(24, 51);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(77, 162);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(56, 107);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(31, 67);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(5, 6);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(8, 12);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(63, 121);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(92, 196);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(64, 124);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(26, 54);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(112, 240);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(99, 212);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(44, 85);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(21, 42);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(47, 88);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(95, 201);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(70, 148);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(103, 223);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(95, 202);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(35, 70);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(61, 117);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(76, 160);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(38, 76);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(68, 143);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(29, 63);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(29, 64);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(79, 169);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(4, 2);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(67, 135);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(85, 181);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(118, 245);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(2, 1);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(73, 154);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(79, 166);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(51, 98);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(68, 144);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(24, 53);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(64, 129);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(79, 167);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(87, 186);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(48, 93);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(17, 35);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(71, 150);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(8, 16);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(21, 43);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(27, 59);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(100, 213);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(8, 15);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(96, 205);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(88, 189);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(69, 145);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(10, 23);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(82, 174);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(101, 215);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(12, 26);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(6, 9);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(8, 14);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(60, 113);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(23, 48);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(9, 19);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(98, 209);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(87, 187);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(72, 151);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(80, 170);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(64, 127);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(79, 168);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(118, 136);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(41, 81);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(80, 171);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(86, 184);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(57, 110);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(31, 68);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(62, 120);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(16, 32);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(16, 34);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(73, 155);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(47, 90);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(10, 22);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(35, 71);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(67, 137);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(36, 75);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(106, 226);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(43, 83);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(67, 136);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(111, 239);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(64, 126);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(56, 106);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(66, 133);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(83, 176);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(55, 101);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(28, 61);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(45, 87);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(109, 236);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(84, 178);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(67, 138);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(65, 131);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(15, 30);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(38, 77);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(97, 207);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(120, 246);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(92, 195);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(65, 130);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(4, 3);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(49, 97);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(23, 50);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(58, 112);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(61, 115);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(82, 173);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(96, 204);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(35, 72);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(58, 111);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(56, 104);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(87, 188);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(5, 7);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(10, 20);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(67, 140);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(22, 46);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(90, 194);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(16, 33);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(63, 123);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(23, 47);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(75, 156);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(107, 231);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(43, 82);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(85, 180);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(28, 60);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(108, 233);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(77, 161);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(67, 141);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(56, 108);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(109, 235);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(14, 28);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(86, 183);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(85, 182);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(66, 134);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(104, 224);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(36, 74);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(84, 179);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(92, 198);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(78, 165);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(10, 21);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(31, 66);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(66, 132);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(17, 36);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(100, 214);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(9, 18);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(55, 99);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(76, 159);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(89, 191);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(4, 4);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(75, 157);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(68, 142);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(86, 185);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(48, 96);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(113, 242);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(95, 203);

INSERT INTO MovieSong (MovieID, SongID)
 VALUES(92, 197);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(131, 204);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(131, 205);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(131, 206);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(130, 205);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(130, 204);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(43, 7);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(100, 169);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(71, 137);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(52, 98);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(90, 6);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(32, 57);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(51, 97);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(45, 6);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(86, 160);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(44, 83);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(66, 127);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(6, 11);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(42, 82);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(16, 31);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(44, 84);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(87, 89);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(98, 151);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(80, 89);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(96, 154);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(16, 32);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(25, 49);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(50, 94);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(63, 92);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(70, 133);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(33, 60);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(6, 3);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(22, 43);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(127, 201);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(33, 61);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(65, 123);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(12, 22);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(10, 6);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(4, 3);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(35, 64);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(121, 195);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(125, 198);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(81, 151);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(37, 70);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(38, 72);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(11, 21);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(116, 100);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(48, 38);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(85, 12);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(70, 134);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(51, 95);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(81, 152);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(26, 7);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(57, 110);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(3, 6);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(46, 87);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(107, 128);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(97, 36);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(48, 36);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(86, 135);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(35, 63);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(40, 78);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(82, 7);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(124, 36);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(21, 6);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(2, 3);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(109, 173);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(111, 178);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(97, 165);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(39, 73);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(3, 5);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(9, 16);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(25, 43);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(5, 9);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(41, 79);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(113, 26);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(97, 166);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(78, 143);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(18, 36);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(126, 200);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(58, 7);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(79, 36);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(74, 148);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(42, 80);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(129, 203);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(41, 21);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(94, 36);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(43, 37);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(62, 117);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(110, 177);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(85, 159);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(67, 6);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(15, 30);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(75, 143);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(76, 144);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(60, 42);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(79, 37);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(21, 42);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(120, 193);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(132, 206);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(32, 58);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(38, 71);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(8, 14);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(42, 81);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(103, 89);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(84, 157);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(39, 74);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(11, 20);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(99, 168);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(63, 118);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(125, 197);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(81, 153);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(89, 6);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(58, 112);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(91, 162);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(55, 12);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(65, 124);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(113, 16);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(126, 199);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(75, 136);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(104, 164);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(44, 12);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(95, 131);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(112, 179);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(35, 65);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(71, 136);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(101, 170);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(105, 171);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(22, 44);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(114, 182);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(76, 146);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(78, 89);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(75, 179);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(119, 191);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(66, 126);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(77, 36);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(27, 51);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(57, 109);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(91, 128);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(36, 67);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(10, 17);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(36, 66);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(59, 114);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(29, 53);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(55, 105);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(61, 92);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(67, 128);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(68, 130);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(101, 152);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(120, 192);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(23, 45);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(115, 184);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(83, 156);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(71, 135);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(90, 128);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(1, 1);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(17, 35);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(88, 6);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(28, 52);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(52, 99);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(49, 91);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(96, 163);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(69, 131);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(79, 7);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(76, 145);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(55, 104);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(47, 74);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(51, 96);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(119, 189);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(101, 151);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(125, 92);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(15, 29);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(19, 38);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(108, 89);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(93, 164);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(59, 113);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(14, 26);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(19, 26);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(13, 24);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(13, 23);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(118, 188);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(7, 7);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(12, 6);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(47, 89);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(98, 167);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(119, 190);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(102, 7);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(102, 154);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(56, 107);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(54, 10);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(100, 153);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(92, 163);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(53, 102);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(49, 7);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(30, 56);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(72, 140);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(74, 147);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(20, 41);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(26, 10);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(108, 74);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(19, 36);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(106, 92);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(54, 103);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(50, 92);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(110, 176);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(5, 10);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(20, 40);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(24, 6);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(39, 75);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(77, 149);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(73, 179);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(58, 111);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(50, 93);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(72, 138);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(4, 8);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(105, 7);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(20, 39);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(100, 134);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(7, 12);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(82, 155);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(17, 34);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(46, 86);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(26, 50);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(61, 115);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(3, 4);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(22, 6);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(111, 171);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(15, 28);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(109, 174);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(53, 101);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(30, 55);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(72, 139);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(30, 54);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(80, 143);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(37, 69);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(113, 181);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(62, 116);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(67, 129);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(91, 6);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(110, 100);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(28, 12);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(114, 183);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(64, 120);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(66, 125);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(33, 59);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(41, 19);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(49, 90);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(120, 89);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(117, 187);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(24, 48);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(56, 12);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(69, 132);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(77, 150);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(114, 12);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(121, 194);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(89, 161);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(88, 128);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(95, 7);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(7, 10);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(56, 106);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(94, 140);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(29, 7);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(116, 186);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(60, 6);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(109, 175);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(84, 158);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(40, 76);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(90, 161);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(111, 7);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(45, 85);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(17, 33);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(14, 27);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(8, 13);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(107, 151);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(23, 46);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(78, 12);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(123, 36);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(10, 18);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(73, 142);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(93, 7);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(115, 2);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(54, 36);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(63, 119);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(11, 19);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(2, 2);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(106, 172);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(98, 128);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(65, 122);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(128, 202);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(74, 101);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(84, 36);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(34, 62);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(46, 88);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(14, 16);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(61, 12);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(118, 187);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(89, 128);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(132, 204);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(18, 37);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(96, 89);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(40, 77);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(82, 154);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(64, 14);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(115, 22);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(53, 100);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(64, 121);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(116, 185);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(23, 47);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(37, 68);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(85, 156);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(112, 180);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(108, 11);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(57, 108);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(8, 15);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(6, 7);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(122, 196);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(4, 7);

INSERT INTO MovieDistributor (MovieID, DistributorID)
 VALUES(13, 25);

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(174, 86,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(205, 836,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(157, 20,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(90, 643,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(38, 401,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(56, 70,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(91, 42,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(45, 60,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(242, 250,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(78, 316,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(200, 511,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(218, 859,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(97, 76,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(26, 115,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(83, 39,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(116, 12,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(135, 116,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(55, 5,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(65, 191,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(211, 34,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(68, 69,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(73, 13,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(101, 31,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(107, 491,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(41, 692,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(140, 35,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(152, 506,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(167, 103,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(151, 27,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(102, 784,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(50, 266,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(29, 152,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(139, 35,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(150, 79,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(13, 84,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(32, 46,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(129, 71,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(215, 177,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(53, 221,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(31, 242,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(150, 863,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(82, 477,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(24, 735,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(128, 3,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(70, 36,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(122, 19,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(217, 22,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(23, 735,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(105, 198,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(39, 556,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(94, 65,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(14, 185,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(36, 638,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(79, 166,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(184, 365,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(207, 797,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(51, 330,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(126, 26,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(196, 66,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(238, 30,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(131, 7,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(190, 545,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(227, 441,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(182, 830,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(199, 867,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(28, 10,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(181, 248,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(112, 274,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(194, 151,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(106, 45,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(150, 865,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(169, 14,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(123, 4,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(216, 99,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(64, 15,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(20, 655,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(199, 91,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(195, 241,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(84, 265,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(42, 17,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(46, 437,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(49, 566,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(81, 652,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(117, 29,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(109, 442,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(121, 51,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(236, 56,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(25, 779,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(124, 54,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(198, 53,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(66, 268,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(189, 282,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(74, 513,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(34, 716,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(33, 83,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(99, 31,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(170, 858,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(222, 419,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(235, 611,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(168, 38,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(120, 25,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(3, 861,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(127, 38,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(179, 53,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(85, 52,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(239, 71,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(231, 67,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(88, 62,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(223, 61,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(75, 33,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(17, 8,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(204, 41,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(183, 24,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(240, 58,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(226, 57,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(43, 51,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(243, 455,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(63, 15,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(175, 817,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(245, 365,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(229, 397,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(193, 649,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(133, 427,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(96, 356,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(104, 772,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(250, 865,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(7, 485,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(95, 49,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(187, 441,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(52, 1,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(12, 40,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(201, 208,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(178, 278,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(92, 24,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(186, 441,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(125, 82,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(156, 21,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(22, 414,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(199, 862,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(58, 819,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(164, 262,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(93, 74,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(72, 78,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(30, 37,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(108, 782,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(147, 254,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(5, 825,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(62, 77,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(115, 2,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(247, 822,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(1, 853,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(148, 403,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(224, 190,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(21, 532,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(110, 449,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(111, 179,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(37, 32,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(57, 64,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(16, 48,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(11, 23,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(158, 843,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(212, 456,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(87, 521,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(249, 863,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(152, 862,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(35, 286,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(180, 96,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(44, 1,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(208, 3,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(197, 59,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(59, 361,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(71, 172,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(159, 73,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(153, 506,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(228, 795,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(138, 35,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(40, 692,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(214, 44,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(19, 855,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(118, 63,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(89, 643,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(202, 208,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(185, 47,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(47, 266,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(54, 5,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(248, 863,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(172, 43,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(132, 181,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(210, 88,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(61, 464,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(241, 313,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(149, 79,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(137, 682,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(86, 292,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(6, 495,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(213, 72,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(4, 568,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(166, 81,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(119, 80,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(143, 473,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(209, 146,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(18, 608,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(76, 493,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(161, 351,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(98, 793,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(27, 11,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(177, 68,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(130, 543,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(48, 266,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(154, 506,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(100, 75,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(171, 55,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(15, 251,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(60, 527,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(80, 49,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(113, 560,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(69, 484,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(152, 867,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(77, 742,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(237, 16,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(87, 188,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(10, 389,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(206, 110,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(2, 502,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(103, 583,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(114, 631,  null );

INSERT INTO SongPerformer (SongID, ContributorID, Featured)
 VALUES(67, 488,  null );

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(47, 266);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(150, 622);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(40, 692);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(187, 641);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(230, 322);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(214, 155);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(125, 524);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(226, 738);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(95, 564);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(129, 430);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(7, 574);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(143, 569);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(66, 154);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(222, 419);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(211, 778);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(219, 249);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(42, 775);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(169, 606);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(67, 229);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(102, 337);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(76, 381);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(211, 519);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(178, 278);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(68, 349);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(33, 535);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(157, 762);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(223, 760);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(235, 585);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(140, 812);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(245, 626);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(30, 846);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(189, 282);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(1, 853);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(135, 759);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(142, 161);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(100, 169);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(38, 401);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(86, 292);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(17, 400);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(151, 27);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(91, 681);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(117, 462);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(211, 476);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(212, 456);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(213, 273);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(32, 659);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(143, 161);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(57, 480);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(93, 770);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(30, 691);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(127, 709);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(24, 713);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(43, 740);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(160, 310);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(52, 489);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(107, 245);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(215, 728);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(106, 664);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(72, 406);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(15, 136);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(239, 430);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(6, 495);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(208, 801);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(190, 726);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(132, 320);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(112, 806);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(210, 125);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(111, 379);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(200, 445);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(235, 152);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(91, 186);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(111, 729);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(118, 216);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(84, 589);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(126, 439);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(55, 576);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(242, 788);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(130, 271);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(204, 539);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(137, 682);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(11, 217);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(17, 8);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(177, 207);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(113, 706);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(150, 184);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(69, 764);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(21, 713);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(133, 515);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(41, 431);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(13, 492);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(68, 323);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(62, 101);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(79, 166);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(6, 809);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(169, 504);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(227, 834);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(17, 299);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(125, 225);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(58, 327);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(186, 246);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(199, 475);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(124, 587);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(91, 165);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(147, 452);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(50, 266);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(85, 601);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(107, 818);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(116, 317);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(210, 396);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(199, 445);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(71, 172);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(144, 161);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(203, 521);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(59, 510);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(99, 129);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(42, 739);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(185, 749);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(2, 284);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(206, 756);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(195, 581);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(171, 304);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(244, 668);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(170, 112);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(146, 678);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(211, 281);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(85, 598);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(231, 766);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(114, 631);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(87, 188);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(218, 859);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(36, 638);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(224, 592);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(150, 102);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(83, 230);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(53, 395);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(72, 718);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(64, 668);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(174, 662);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(156, 734);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(138, 812);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(209, 146);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(119, 722);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(33, 534);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(126, 148);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(169, 143);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(166, 364);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(221, 615);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(13, 139);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(229, 801);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(53, 221);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(127, 18);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(81, 652);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(202, 176);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(19, 628);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(123, 436);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(48, 266);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(105, 195);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(111, 806);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(241, 577);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(204, 555);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(127, 458);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(196, 690);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(151, 144);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(239, 649);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(108, 782);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(169, 347);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(176, 763);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(25, 433);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(74, 117);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(82, 477);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(112, 729);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(159, 130);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(86, 497);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(80, 49);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(170, 94);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(15, 251);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(238, 164);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(242, 183);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(87, 589);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(130, 263);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(129, 649);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(91, 687);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(171, 338);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(18, 608);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(30, 360);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(184, 365);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(85, 269);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(121, 126);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(175, 549);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(200, 511);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(153, 506);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(100, 334);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(155, 141);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(70, 533);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(150, 777);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(237, 646);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(88, 117);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(191, 852);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(168, 578);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(250, 867);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(209, 591);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(173, 859);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(194, 171);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(152, 506);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(122, 344);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(162, 666);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(12, 754);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(15, 333);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(231, 767);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(14, 842);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(66, 378);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(159, 813);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(51, 330);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(166, 787);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(232, 348);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(65, 191);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(110, 168);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(135, 588);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(51, 582);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(128, 781);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(238, 757);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(101, 129);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(96, 356);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(205, 836);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(42, 810);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(206, 807);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(213, 405);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(43, 619);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(61, 204);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(249, 862);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(28, 290);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(90, 643);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(168, 18);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(174, 86);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(92, 707);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(123, 840);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(103, 304);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(123, 303);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(210, 340);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(216, 99);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(91, 665);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(58, 552);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(13, 84);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(228, 795);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(182, 487);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(174, 160);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(181, 549);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(238, 398);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(104, 720);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(154, 506);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(161, 500);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(60, 745);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(187, 551);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(121, 215);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(162, 371);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(234, 730);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(217, 409);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(104, 704);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(115, 850);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(124, 6);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(201, 208);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(113, 548);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(164, 431);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(207, 797);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(186, 699);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(180, 660);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(175, 520);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(149, 622);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(1, 415);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(231, 765);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(168, 458);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(95, 447);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(30, 359);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(145, 174);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(161, 486);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(214, 746);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(54, 576);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(128, 618);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(63, 785);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(166, 105);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(118, 355);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(247, 822);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(131, 829);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(72, 636);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(105, 429);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(9, 731);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(35, 286);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(27, 790);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(55, 446);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(213, 404);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(226, 440);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(69, 132);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(179, 138);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(122, 463);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(87, 299);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(164, 410);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(194, 114);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(148, 201);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(106, 380);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(89, 643);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(38, 392);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(12, 451);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(87, 637);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(126, 605);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(68, 505);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(139, 812);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(87, 353);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(182, 210);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(159, 828);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(185, 562);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(134, 701);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(76, 481);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(168, 709);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(236, 705);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(245, 121);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(75, 537);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(204, 702);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(166, 786);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(19, 855);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(133, 546);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(29, 152);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(121, 474);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(169, 345);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(219, 832);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(237, 753);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(54, 446);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(42, 417);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(5, 825);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(115, 847);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(77, 742);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(217, 595);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(41, 410);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(161, 394);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(136, 668);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(82, 724);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(94, 389);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(222, 725);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(221, 528);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(39, 556);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(158, 843);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(45, 302);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(202, 208);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(8, 731);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(192, 388);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(100, 461);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(123, 744);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(34, 716);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(85, 120);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(159, 563);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(23, 713);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(20, 713);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(118, 205);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(185, 658);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(248, 862);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(109, 168);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(32, 703);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(183, 708);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(30, 593);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(16, 771);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(37, 278);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(167, 103);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(240, 494);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(22, 713);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(216, 616);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(198, 138);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(73, 768);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(199, 91);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(91, 107);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(124, 244);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(87, 393);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(72, 686);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(27, 277);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(236, 671);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(25, 648);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(27, 421);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(112, 379);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(172, 849);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(16, 752);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(76, 590);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(197, 435);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(151, 434);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(171, 339);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(49, 566);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(123, 239);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(180, 617);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(193, 649);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(127, 328);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(233, 201);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(156, 667);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(82, 509);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(60, 306);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(117, 789);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(150, 536);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(17, 393);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(28, 663);

INSERT INTO SongAuthor (SongID, ContributorID)
 VALUES(69, 122);

--This statement allows data to contain an ampersand
--LEAVE IT IN!!
SET DEFINE OFF

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(1, 333,  TO_DATE('2014-01-02 23 43 19', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(2, 633,  TO_DATE('2014-01-02 11 56 53', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(3, 44,  TO_DATE('2014-01-03 14 47 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(4, 434,  TO_DATE('2014-01-03 8 47 46', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(5, 181,  TO_DATE('2014-01-04 18 50 22', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(6, 344,  TO_DATE('2014-01-04 17 0 45', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(7, 933,  TO_DATE('2014-01-04 9 20 46', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(8, 435,  TO_DATE('2014-01-05 15 19 36', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(9, 892,  TO_DATE('2014-01-05 14 52 5', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(10, 931,  TO_DATE('2014-01-08 9 1 18', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(11, 252,  TO_DATE('2014-01-10 7 34 44', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(12, 828,  TO_DATE('2014-01-10 9 30 25', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(13, 932,  TO_DATE('2014-01-11 17 57 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(14, 344,  TO_DATE('2014-01-11 18 47 7', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(15, 434,  TO_DATE('2014-01-12 17 4 21', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(16, 181,  TO_DATE('2014-01-12 2 14 29', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(17, 164,  TO_DATE('2014-01-12 7 32 19', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(18, 343,  TO_DATE('2014-01-12 16 22 32', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(19, 892,  TO_DATE('2014-01-13 19 41 18', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(20, 781,  TO_DATE('2014-01-14 22 10 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(21, 48,  TO_DATE('2014-01-15 23 5 24', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(22, 599,  TO_DATE('2014-01-15 2 41 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(23, 333,  TO_DATE('2014-01-15 12 29 54', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(24, 44,  TO_DATE('2014-01-15 18 41 58', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(25, 933,  TO_DATE('2014-01-15 9 5 15', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(26, 23,  TO_DATE('2014-01-15 18 24 18', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(27, 136,  TO_DATE('2014-01-16 4 42 31', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(28, 599,  TO_DATE('2014-01-18 2 55 33', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(29, 633,  TO_DATE('2014-01-18 20 4 21', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(30, 795,  TO_DATE('2014-01-19 13 0 12', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(31, 892,  TO_DATE('2014-01-19 23 16 48', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(32, 933,  TO_DATE('2014-01-19 0 40 53', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(33, 287,  TO_DATE('2014-01-20 5 15 56', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(34, 256,  TO_DATE('2014-01-21 7 22 15', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(35, 828,  TO_DATE('2014-01-21 15 59 7', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(36, 343,  TO_DATE('2014-01-21 21 19 22', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(37, 633,  TO_DATE('2014-01-21 12 0 29', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(38, 822,  TO_DATE('2014-01-22 9 56 41', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(39, 933,  TO_DATE('2014-01-22 23 41 56', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(40, 287,  TO_DATE('2014-01-23 23 55 47', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(41, 333,  TO_DATE('2014-01-23 16 59 20', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(42, 44,  TO_DATE('2014-01-23 18 48 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(43, 334,  TO_DATE('2014-01-24 17 4 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(44, 682,  TO_DATE('2014-01-24 6 16 54', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(45, 872,  TO_DATE('2014-01-24 18 39 22', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(46, 48,  TO_DATE('2014-01-24 23 30 16', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(47, 931,  TO_DATE('2014-01-24 17 53 52', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(48, 136,  TO_DATE('2014-01-24 3 59 57', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(49, 269,  TO_DATE('2014-01-25 7 14 8', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(50, 795,  TO_DATE('2014-01-25 17 13 7', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(51, 163,  TO_DATE('2014-01-25 19 11 39', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(52, 435,  TO_DATE('2014-01-26 23 28 20', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(53, 135,  TO_DATE('2014-01-26 6 11 58', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(54, 434,  TO_DATE('2014-01-26 2 43 31', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(55, 164,  TO_DATE('2014-01-26 8 44 22', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(56, 287,  TO_DATE('2014-01-26 20 17 29', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(57, 344,  TO_DATE('2014-01-26 9 2 12', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(58, 333,  TO_DATE('2014-01-26 12 14 31', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(59, 252,  TO_DATE('2014-01-27 0 39 35', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(60, 932,  TO_DATE('2014-01-27 12 8 25', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(61, 781,  TO_DATE('2014-01-28 9 1 47', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(62, 343,  TO_DATE('2014-01-28 6 35 43', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(63, 261,  TO_DATE('2014-01-29 23 51 0', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(64, 272,  TO_DATE('2014-01-29 11 19 48', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(65, 599,  TO_DATE('2014-01-29 17 46 13', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(66, 269,  TO_DATE('2014-01-29 11 2 33', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(67, 344,  TO_DATE('2014-01-29 10 50 25', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(68, 828,  TO_DATE('2014-01-30 2 49 21', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(69, 435,  TO_DATE('2014-01-30 12 20 54', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(70, 832,  TO_DATE('2014-01-31 1 56 29', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(71, 256,  TO_DATE('2014-01-31 19 57 46', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(72, 822,  TO_DATE('2014-02-01 18 18 12', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(73, 23,  TO_DATE('2014-02-01 2 40 54', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(74, 892,  TO_DATE('2014-02-01 11 44 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(75, 252,  TO_DATE('2014-02-02 16 1 23', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(76, 164,  TO_DATE('2014-02-02 2 15 29', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(77, 682,  TO_DATE('2014-02-03 21 34 35', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(78, 181,  TO_DATE('2014-02-03 12 45 13', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(79, 333,  TO_DATE('2014-02-03 3 9 51', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(80, 795,  TO_DATE('2014-02-04 15 11 50', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(81, 44,  TO_DATE('2014-02-04 18 13 25', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(82, 932,  TO_DATE('2014-02-05 17 45 57', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(83, 334,  TO_DATE('2014-02-05 19 47 44', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(84, 633,  TO_DATE('2014-02-05 22 25 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(85, 933,  TO_DATE('2014-02-05 19 13 21', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(86, 256,  TO_DATE('2014-02-06 1 55 44', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(87, 261,  TO_DATE('2014-02-06 1 16 36', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(88, 434,  TO_DATE('2014-02-06 8 46 19', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(89, 599,  TO_DATE('2014-02-06 17 35 19', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(90, 872,  TO_DATE('2014-02-08 12 15 54', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(91, 163,  TO_DATE('2014-02-08 13 19 30', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(92, 48,  TO_DATE('2014-02-08 2 40 32', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(93, 343,  TO_DATE('2014-02-08 13 22 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(94, 136,  TO_DATE('2014-02-08 21 11 5', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(95, 333,  TO_DATE('2014-02-08 15 14 32', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(96, 135,  TO_DATE('2014-02-09 6 14 33', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(97, 287,  TO_DATE('2014-02-09 23 28 48', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(98, 252,  TO_DATE('2014-02-09 5 55 33', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(99, 599,  TO_DATE('2014-02-09 18 26 53', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(100, 931,  TO_DATE('2014-02-09 19 33 29', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(101, 828,  TO_DATE('2014-02-11 8 31 58', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(102, 872,  TO_DATE('2014-02-11 14 11 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(103, 272,  TO_DATE('2014-02-12 11 32 12', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(104, 781,  TO_DATE('2014-02-12 21 40 46', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(105, 795,  TO_DATE('2014-02-13 1 16 1', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(106, 164,  TO_DATE('2014-02-13 9 49 15', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(107, 344,  TO_DATE('2014-02-13 7 17 54', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(108, 832,  TO_DATE('2014-02-14 9 27 16', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(109, 435,  TO_DATE('2014-02-14 22 35 18', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(110, 181,  TO_DATE('2014-02-14 21 33 38', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(111, 334,  TO_DATE('2014-02-14 3 58 45', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(112, 163,  TO_DATE('2014-02-14 1 8 11', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(113, 872,  TO_DATE('2014-02-14 5 13 56', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(114, 822,  TO_DATE('2014-02-15 12 36 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(115, 135,  TO_DATE('2014-02-15 14 17 46', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(116, 269,  TO_DATE('2014-02-15 7 10 20', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(117, 23,  TO_DATE('2014-02-16 8 55 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(118, 343,  TO_DATE('2014-02-16 19 13 24', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(119, 892,  TO_DATE('2014-02-17 2 13 9', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(120, 633,  TO_DATE('2014-02-17 9 56 8', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(121, 599,  TO_DATE('2014-02-17 10 3 56', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(122, 682,  TO_DATE('2014-02-18 6 27 32', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(123, 261,  TO_DATE('2014-02-18 17 25 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(124, 252,  TO_DATE('2014-02-18 9 31 11', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(125, 44,  TO_DATE('2014-02-19 14 38 24', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(126, 256,  TO_DATE('2014-02-20 6 4 24', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(127, 181,  TO_DATE('2014-02-20 10 53 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(128, 136,  TO_DATE('2014-02-20 6 46 33', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(129, 931,  TO_DATE('2014-02-20 2 5 59', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(130, 932,  TO_DATE('2014-02-21 16 51 15', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(131, 287,  TO_DATE('2014-02-21 11 44 23', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(132, 252,  TO_DATE('2014-02-21 11 26 44', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(133, 48,  TO_DATE('2014-02-22 10 40 40', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(134, 434,  TO_DATE('2014-02-22 20 30 16', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(135, 344,  TO_DATE('2014-02-22 9 18 22', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(136, 164,  TO_DATE('2014-02-23 11 49 30', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(137, 892,  TO_DATE('2014-02-23 17 1 3', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(138, 333,  TO_DATE('2014-02-23 14 55 24', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(139, 781,  TO_DATE('2014-02-24 11 19 31', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(140, 435,  TO_DATE('2014-02-24 15 7 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(141, 599,  TO_DATE('2014-02-24 17 49 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(142, 135,  TO_DATE('2014-02-25 5 33 42', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(143, 832,  TO_DATE('2014-02-26 21 54 2', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(144, 163,  TO_DATE('2014-02-26 5 20 1', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(145, 872,  TO_DATE('2014-02-26 20 18 26', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(146, 344,  TO_DATE('2014-02-26 14 51 43', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(147, 828,  TO_DATE('2014-02-27 17 32 24', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(148, 795,  TO_DATE('2014-02-27 6 58 21', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(149, 256,  TO_DATE('2014-02-27 3 26 36', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(150, 633,  TO_DATE('2014-02-27 4 19 15', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(151, 272,  TO_DATE('2014-02-28 1 24 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(152, 334,  TO_DATE('2014-03-01 19 12 42', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(153, 23,  TO_DATE('2014-03-01 10 52 58', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(154, 136,  TO_DATE('2014-03-01 22 30 28', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(155, 822,  TO_DATE('2014-03-02 23 51 47', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(156, 343,  TO_DATE('2014-03-02 20 33 21', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(157, 272,  TO_DATE('2014-03-03 22 5 8', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(158, 269,  TO_DATE('2014-03-03 21 57 37', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(159, 287,  TO_DATE('2014-03-03 22 52 45', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(160, 344,  TO_DATE('2014-03-03 6 37 44', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(161, 832,  TO_DATE('2014-03-05 15 21 38', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(162, 261,  TO_DATE('2014-03-05 8 49 38', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(163, 163,  TO_DATE('2014-03-05 2 15 28', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(164, 136,  TO_DATE('2014-03-05 8 29 41', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(165, 931,  TO_DATE('2014-03-05 0 55 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(166, 682,  TO_DATE('2014-03-06 22 52 10', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(167, 272,  TO_DATE('2014-03-06 10 12 20', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(168, 135,  TO_DATE('2014-03-06 9 42 12', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(169, 252,  TO_DATE('2014-03-06 13 56 41', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(170, 333,  TO_DATE('2014-03-06 0 42 22', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(171, 599,  TO_DATE('2014-03-06 23 44 14', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(172, 822,  TO_DATE('2014-03-07 16 29 23', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(173, 181,  TO_DATE('2014-03-07 11 44 21', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(174, 795,  TO_DATE('2014-03-07 17 47 55', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(175, 932,  TO_DATE('2014-03-08 5 55 38', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(176, 435,  TO_DATE('2014-03-08 0 47 31', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(177, 633,  TO_DATE('2014-03-08 18 36 22', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(178, 343,  TO_DATE('2014-03-08 19 22 55', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(179, 163,  TO_DATE('2014-03-08 23 5 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(180, 44,  TO_DATE('2014-03-09 23 7 13', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(181, 931,  TO_DATE('2014-03-09 6 37 48', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(182, 48,  TO_DATE('2014-03-10 23 40 17', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(183, 434,  TO_DATE('2014-03-10 7 7 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(184, 164,  TO_DATE('2014-03-10 11 8 15', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(185, 269,  TO_DATE('2014-03-10 13 12 51', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(186, 23,  TO_DATE('2014-03-11 0 52 50', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(187, 256,  TO_DATE('2014-03-12 11 37 5', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(188, 272,  TO_DATE('2014-03-12 9 1 58', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(189, 781,  TO_DATE('2014-03-12 3 3 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(190, 892,  TO_DATE('2014-03-12 13 11 39', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(191, 872,  TO_DATE('2014-03-12 13 27 57', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(192, 931,  TO_DATE('2014-03-12 3 45 45', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(193, 334,  TO_DATE('2014-03-13 17 39 3', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(194, 435,  TO_DATE('2014-03-13 9 1 46', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(195, 828,  TO_DATE('2014-03-14 9 53 20', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(196, 932,  TO_DATE('2014-03-14 20 30 16', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(197, 48,  TO_DATE('2014-03-16 20 45 58', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(198, 781,  TO_DATE('2014-03-16 9 17 10', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(199, 832,  TO_DATE('2014-03-17 18 17 2', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(200, 44,  TO_DATE('2014-03-17 10 54 15', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(201, 333,  TO_DATE('2014-03-17 1 32 58', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(202, 344,  TO_DATE('2014-03-17 10 2 24', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(203, 682,  TO_DATE('2014-03-18 23 27 10', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(204, 287,  TO_DATE('2014-03-18 8 31 46', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(205, 599,  TO_DATE('2014-03-18 14 45 43', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(206, 135,  TO_DATE('2014-03-19 4 23 23', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(207, 269,  TO_DATE('2014-03-19 22 15 8', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(208, 343,  TO_DATE('2014-03-19 6 23 50', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(209, 261,  TO_DATE('2014-03-20 19 19 46', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(210, 23,  TO_DATE('2014-03-20 7 26 3', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(211, 682,  TO_DATE('2014-03-21 4 16 6', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(212, 181,  TO_DATE('2014-03-21 22 55 6', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(213, 252,  TO_DATE('2014-03-21 7 16 40', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(214, 164,  TO_DATE('2014-03-21 1 10 6', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(215, 892,  TO_DATE('2014-03-21 19 52 42', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(216, 872,  TO_DATE('2014-03-21 20 27 56', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(217, 795,  TO_DATE('2014-03-21 6 40 21', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(218, 781,  TO_DATE('2014-03-22 17 46 7', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(219, 44,  TO_DATE('2014-03-22 18 25 42', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(220, 932,  TO_DATE('2014-03-23 3 36 18', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(221, 633,  TO_DATE('2014-03-23 0 1 41', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(222, 256,  TO_DATE('2014-03-24 3 53 0', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(223, 135,  TO_DATE('2014-03-24 4 31 26', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(224, 163,  TO_DATE('2014-03-24 16 22 9', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(225, 272,  TO_DATE('2014-03-25 21 21 16', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(226, 434,  TO_DATE('2014-03-25 8 19 48', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(227, 435,  TO_DATE('2014-03-25 23 27 34', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(228, 334,  TO_DATE('2014-03-27 20 8 33', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(229, 48,  TO_DATE('2014-03-27 20 45 47', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(230, 136,  TO_DATE('2014-03-27 9 7 11', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(231, 892,  TO_DATE('2014-03-27 13 20 4', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(232, 828,  TO_DATE('2014-03-28 10 37 48', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(233, 256,  TO_DATE('2014-03-28 2 43 8', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(234, 44,  TO_DATE('2014-03-28 0 8 38', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(235, 344,  TO_DATE('2014-03-28 15 1 55', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(236, 931,  TO_DATE('2014-03-28 18 42 50', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(237, 252,  TO_DATE('2014-03-29 15 39 8', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(238, 333,  TO_DATE('2014-03-30 19 2 35', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(239, 633,  TO_DATE('2014-03-30 22 37 6', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(240, 163,  TO_DATE('2014-03-30 17 50 50', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(241, 932,  TO_DATE('2014-03-31 4 6 52', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(242, 135,  TO_DATE('2014-03-31 7 33 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(243, 287,  TO_DATE('2014-04-01 12 0 58', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(244, 828,  TO_DATE('2014-04-01 15 59 43', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(245, 599,  TO_DATE('2014-04-01 8 32 25', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(246, 931,  TO_DATE('2014-04-01 5 37 25', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(247, 832,  TO_DATE('2014-04-02 16 14 23', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(248, 261,  TO_DATE('2014-04-02 3 54 40', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(249, 682,  TO_DATE('2014-04-02 2 25 52', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(250, 181,  TO_DATE('2014-04-02 11 46 50', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(251, 164,  TO_DATE('2014-04-02 23 5 11', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(252, 435,  TO_DATE('2014-04-03 21 10 1', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(253, 23,  TO_DATE('2014-04-04 0 3 10', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(254, 269,  TO_DATE('2014-04-04 18 44 47', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(255, 872,  TO_DATE('2014-04-04 14 34 48', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(256, 781,  TO_DATE('2014-04-04 9 26 40', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(257, 599,  TO_DATE('2014-04-04 22 22 30', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(258, 795,  TO_DATE('2014-04-05 8 59 35', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(259, 135,  TO_DATE('2014-04-05 21 33 11', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(260, 163,  TO_DATE('2014-04-05 13 57 25', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(261, 828,  TO_DATE('2014-04-06 18 40 50', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(262, 48,  TO_DATE('2014-04-08 17 7 16', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(263, 256,  TO_DATE('2014-04-08 6 47 10', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(264, 181,  TO_DATE('2014-04-09 22 19 51', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(265, 23,  TO_DATE('2014-04-09 4 8 57', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(266, 136,  TO_DATE('2014-04-09 22 14 29', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(267, 892,  TO_DATE('2014-04-09 12 38 3', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(268, 269,  TO_DATE('2014-04-09 20 57 43', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(269, 334,  TO_DATE('2014-04-10 18 35 37', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(270, 435,  TO_DATE('2014-04-10 2 28 55', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(271, 343,  TO_DATE('2014-04-10 15 29 27', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(272, 44,  TO_DATE('2014-04-10 7 47 50', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(273, 434,  TO_DATE('2014-04-11 1 3 37', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(274, 287,  TO_DATE('2014-04-11 6 20 52', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(275, 828,  TO_DATE('2014-04-11 11 6 46', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(276, 832,  TO_DATE('2014-04-12 13 51 32', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(277, 272,  TO_DATE('2014-04-12 7 1 45', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(278, 932,  TO_DATE('2014-04-13 0 34 44', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(279, 334,  TO_DATE('2014-04-13 1 1 1', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(280, 256,  TO_DATE('2014-04-13 3 38 24', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(281, 269,  TO_DATE('2014-04-13 13 17 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(282, 44,  TO_DATE('2014-04-13 12 21 52', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(283, 333,  TO_DATE('2014-04-13 6 29 51', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(284, 931,  TO_DATE('2014-04-13 13 58 56', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(285, 181,  TO_DATE('2014-04-14 9 36 19', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(286, 633,  TO_DATE('2014-04-14 15 55 36', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(287, 344,  TO_DATE('2014-04-14 17 38 35', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(288, 682,  TO_DATE('2014-04-15 11 7 25', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(289, 164,  TO_DATE('2014-04-15 1 1 57', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(290, 781,  TO_DATE('2014-04-15 20 28 56', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(291, 435,  TO_DATE('2014-04-15 1 2 14', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(292, 828,  TO_DATE('2014-04-15 9 59 18', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(293, 872,  TO_DATE('2014-04-16 20 45 24', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(294, 892,  TO_DATE('2014-04-16 6 59 3', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(295, 23,  TO_DATE('2014-04-17 18 18 44', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(296, 334,  TO_DATE('2014-04-17 10 45 47', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(297, 135,  TO_DATE('2014-04-17 10 14 22', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(298, 269,  TO_DATE('2014-04-17 1 17 45', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(299, 261,  TO_DATE('2014-04-18 9 46 19', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(300, 48,  TO_DATE('2014-04-18 8 54 54', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(301, 344,  TO_DATE('2014-04-18 11 32 24', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(302, 892,  TO_DATE('2014-04-19 5 16 11', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(303, 164,  TO_DATE('2014-04-20 21 47 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(304, 599,  TO_DATE('2014-04-20 20 27 8', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(305, 795,  TO_DATE('2014-04-21 5 16 25', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(306, 163,  TO_DATE('2014-04-21 15 36 30', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(307, 44,  TO_DATE('2014-04-21 14 25 11', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(308, 344,  TO_DATE('2014-04-21 6 2 33', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(309, 334,  TO_DATE('2014-04-22 6 53 38', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(310, 435,  TO_DATE('2014-04-22 6 13 29', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(311, 287,  TO_DATE('2014-04-24 3 57 30', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(312, 932,  TO_DATE('2014-04-24 17 28 51', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(313, 256,  TO_DATE('2014-04-24 17 49 33', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(314, 23,  TO_DATE('2014-04-24 15 39 8', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(315, 181,  TO_DATE('2014-04-24 4 59 51', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(316, 136,  TO_DATE('2014-04-25 21 58 57', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(317, 164,  TO_DATE('2014-04-25 22 16 31', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(318, 892,  TO_DATE('2014-04-25 6 31 42', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(319, 343,  TO_DATE('2014-04-25 23 42 55', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(320, 272,  TO_DATE('2014-04-26 17 36 1', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(321, 344,  TO_DATE('2014-04-26 1 0 21', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(322, 872,  TO_DATE('2014-04-27 10 40 14', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(323, 832,  TO_DATE('2014-04-28 6 39 0', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(324, 434,  TO_DATE('2014-04-28 5 47 38', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(325, 781,  TO_DATE('2014-04-28 4 13 43', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(326, 633,  TO_DATE('2014-04-28 11 7 10', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(327, 269,  TO_DATE('2014-04-28 13 31 6', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(328, 261,  TO_DATE('2014-04-29 0 14 1', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(329, 333,  TO_DATE('2014-04-29 9 19 2', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(330, 931,  TO_DATE('2014-04-29 19 45 32', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(331, 599,  TO_DATE('2014-04-30 18 12 33', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(332, 344,  TO_DATE('2014-04-30 12 23 9', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(333, 828,  TO_DATE('2014-05-01 23 15 56', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(334, 135,  TO_DATE('2014-05-01 23 22 59', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(335, 343,  TO_DATE('2014-05-01 22 40 50', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(336, 269,  TO_DATE('2014-05-01 3 20 13', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(337, 682,  TO_DATE('2014-05-02 20 47 55', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(338, 334,  TO_DATE('2014-05-02 16 35 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(339, 435,  TO_DATE('2014-05-02 0 14 53', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(340, 44,  TO_DATE('2014-05-02 12 50 30', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(341, 164,  TO_DATE('2014-05-02 19 11 32', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(342, 832,  TO_DATE('2014-05-03 2 45 21', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(343, 795,  TO_DATE('2014-05-03 10 6 1', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(344, 287,  TO_DATE('2014-05-03 8 52 47', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(345, 163,  TO_DATE('2014-05-03 21 5 51', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(346, 781,  TO_DATE('2014-05-04 17 1 2', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(347, 633,  TO_DATE('2014-05-04 20 9 31', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(348, 333,  TO_DATE('2014-05-04 11 12 14', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(349, 181,  TO_DATE('2014-05-05 19 0 22', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(350, 135,  TO_DATE('2014-05-05 2 15 50', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(351, 832,  TO_DATE('2014-05-06 13 46 12', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(352, 23,  TO_DATE('2014-05-06 16 21 8', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(353, 931,  TO_DATE('2014-05-06 19 53 1', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(354, 256,  TO_DATE('2014-05-07 13 2 17', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(355, 164,  TO_DATE('2014-05-07 0 39 12', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(356, 163,  TO_DATE('2014-05-07 5 1 44', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(357, 599,  TO_DATE('2014-05-07 16 59 21', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(358, 872,  TO_DATE('2014-05-08 14 55 22', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(359, 892,  TO_DATE('2014-05-08 11 51 52', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(360, 434,  TO_DATE('2014-05-09 22 22 57', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(361, 932,  TO_DATE('2014-05-10 12 53 3', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(362, 344,  TO_DATE('2014-05-10 18 19 12', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(363, 272,  TO_DATE('2014-05-11 19 33 57', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(364, 256,  TO_DATE('2014-05-11 18 1 58', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(365, 269,  TO_DATE('2014-05-11 16 38 29', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(366, 136,  TO_DATE('2014-05-12 12 15 15', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(367, 435,  TO_DATE('2014-05-13 20 15 8', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(368, 892,  TO_DATE('2014-05-13 16 40 44', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(369, 931,  TO_DATE('2014-05-13 12 34 53', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(370, 23,  TO_DATE('2014-05-14 5 47 35', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(371, 181,  TO_DATE('2014-05-14 22 25 3', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(372, 163,  TO_DATE('2014-05-14 13 1 52', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(373, 334,  TO_DATE('2014-05-15 17 28 45', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(374, 261,  TO_DATE('2014-05-16 1 34 21', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(375, 828,  TO_DATE('2014-05-16 18 13 13', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(376, 343,  TO_DATE('2014-05-16 4 40 10', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(377, 599,  TO_DATE('2014-05-16 3 32 5', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(378, 633,  TO_DATE('2014-05-17 20 1 43', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(379, 795,  TO_DATE('2014-05-18 10 23 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(380, 287,  TO_DATE('2014-05-18 1 45 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(381, 44,  TO_DATE('2014-05-18 4 59 32', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(382, 135,  TO_DATE('2014-05-18 8 52 1', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(383, 164,  TO_DATE('2014-05-18 14 54 58', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(384, 832,  TO_DATE('2014-05-19 11 31 57', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(385, 682,  TO_DATE('2014-05-19 3 49 11', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(386, 136,  TO_DATE('2014-05-19 10 54 6', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(387, 256,  TO_DATE('2014-05-19 4 36 23', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(388, 333,  TO_DATE('2014-05-19 20 48 0', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(389, 272,  TO_DATE('2014-05-20 3 15 33', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(390, 633,  TO_DATE('2014-05-20 0 17 12', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(391, 781,  TO_DATE('2014-05-21 16 27 14', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(392, 334,  TO_DATE('2014-05-21 8 38 30', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(393, 261,  TO_DATE('2014-05-22 23 10 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(394, 872,  TO_DATE('2014-05-22 17 9 33', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(395, 23,  TO_DATE('2014-05-23 17 56 58', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(396, 344,  TO_DATE('2014-05-23 23 36 44', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(397, 269,  TO_DATE('2014-05-23 11 4 44', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(398, 931,  TO_DATE('2014-05-23 2 59 35', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(399, 434,  TO_DATE('2014-05-24 20 43 57', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(400, 181,  TO_DATE('2014-05-24 16 55 7', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(401, 256,  TO_DATE('2014-05-24 6 22 33', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(402, 163,  TO_DATE('2014-05-24 8 58 47', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(403, 932,  TO_DATE('2014-05-27 19 38 17', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(404, 795,  TO_DATE('2014-05-27 19 32 33', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(405, 682,  TO_DATE('2014-05-27 12 2 39', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(406, 23,  TO_DATE('2014-05-27 7 13 59', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(407, 832,  TO_DATE('2014-05-28 6 13 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(408, 261,  TO_DATE('2014-05-28 2 38 0', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(409, 435,  TO_DATE('2014-05-28 7 16 50', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(410, 892,  TO_DATE('2014-05-28 21 37 50', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(411, 931,  TO_DATE('2014-05-28 10 31 36', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(412, 136,  TO_DATE('2014-05-29 4 37 25', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(413, 343,  TO_DATE('2014-05-29 12 17 22', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(414, 333,  TO_DATE('2014-05-29 20 17 9', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(415, 872,  TO_DATE('2014-05-30 8 42 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(416, 795,  TO_DATE('2014-05-31 14 5 13', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(417, 892,  TO_DATE('2014-05-31 20 40 25', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(418, 344,  TO_DATE('2014-05-31 3 40 52', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(419, 828,  TO_DATE('2014-06-01 12 7 0', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(420, 434,  TO_DATE('2014-06-01 8 29 30', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(421, 136,  TO_DATE('2014-06-01 17 17 28', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(422, 44,  TO_DATE('2014-06-01 0 36 18', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(423, 599,  TO_DATE('2014-06-01 15 26 32', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(424, 272,  TO_DATE('2014-06-02 9 5 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(425, 287,  TO_DATE('2014-06-02 16 4 47', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(426, 633,  TO_DATE('2014-06-02 12 25 14', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(427, 135,  TO_DATE('2014-06-03 23 46 5', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(428, 781,  TO_DATE('2014-06-04 23 20 15', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(429, 682,  TO_DATE('2014-06-04 13 46 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(430, 434,  TO_DATE('2014-06-04 19 41 7', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(431, 164,  TO_DATE('2014-06-04 10 6 21', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(432, 269,  TO_DATE('2014-06-05 14 11 59', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(433, 261,  TO_DATE('2014-06-06 17 43 40', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(434, 872,  TO_DATE('2014-06-06 22 22 59', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(435, 181,  TO_DATE('2014-06-06 10 40 28', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(436, 931,  TO_DATE('2014-06-06 3 27 51', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(437, 832,  TO_DATE('2014-06-07 15 40 53', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(438, 795,  TO_DATE('2014-06-07 15 18 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(439, 136,  TO_DATE('2014-06-07 19 21 41', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(440, 23,  TO_DATE('2014-06-08 5 17 51', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(441, 163,  TO_DATE('2014-06-08 22 0 25', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(442, 343,  TO_DATE('2014-06-08 17 15 20', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(443, 633,  TO_DATE('2014-06-08 9 23 10', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(444, 682,  TO_DATE('2014-06-08 16 43 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(445, 872,  TO_DATE('2014-06-09 17 19 39', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(446, 256,  TO_DATE('2014-06-09 17 59 55', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(447, 892,  TO_DATE('2014-06-09 21 59 29', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(448, 164,  TO_DATE('2014-06-09 14 19 47', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(449, 599,  TO_DATE('2014-06-09 18 42 55', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(450, 272,  TO_DATE('2014-06-10 22 0 40', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(451, 781,  TO_DATE('2014-06-10 6 51 48', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(452, 135,  TO_DATE('2014-06-10 4 29 23', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(453, 334,  TO_DATE('2014-06-11 21 23 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(454, 832,  TO_DATE('2014-06-11 16 14 21', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(455, 23,  TO_DATE('2014-06-11 13 24 30', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(456, 932,  TO_DATE('2014-06-12 21 15 1', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(457, 333,  TO_DATE('2014-06-12 16 48 23', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(458, 163,  TO_DATE('2014-06-13 7 33 47', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(459, 344,  TO_DATE('2014-06-13 9 7 18', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(460, 892,  TO_DATE('2014-06-14 6 20 24', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(461, 434,  TO_DATE('2014-06-15 8 34 37', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(462, 23,  TO_DATE('2014-06-15 11 34 50', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(463, 287,  TO_DATE('2014-06-16 18 47 40', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(464, 828,  TO_DATE('2014-06-16 15 2 23', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(465, 181,  TO_DATE('2014-06-16 14 17 25', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(466, 164,  TO_DATE('2014-06-16 20 41 50', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(467, 931,  TO_DATE('2014-06-16 2 0 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(468, 256,  TO_DATE('2014-06-17 1 53 37', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(469, 261,  TO_DATE('2014-06-18 0 35 15', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(470, 269,  TO_DATE('2014-06-18 22 0 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(471, 334,  TO_DATE('2014-06-19 13 23 23', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(472, 682,  TO_DATE('2014-06-19 9 49 45', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(473, 136,  TO_DATE('2014-06-20 12 11 1', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(474, 135,  TO_DATE('2014-06-20 3 12 44', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(475, 828,  TO_DATE('2014-06-21 10 35 40', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(476, 872,  TO_DATE('2014-06-22 17 56 32', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(477, 633,  TO_DATE('2014-06-22 6 36 48', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(478, 892,  TO_DATE('2014-06-23 20 14 39', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(479, 272,  TO_DATE('2014-06-24 2 55 50', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(480, 287,  TO_DATE('2014-06-24 14 26 21', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(481, 682,  TO_DATE('2014-06-24 18 35 3', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(482, 599,  TO_DATE('2014-06-24 5 39 1', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(483, 269,  TO_DATE('2014-06-24 6 50 10', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(484, 344,  TO_DATE('2014-06-24 11 33 41', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(485, 931,  TO_DATE('2014-06-24 21 42 52', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(486, 932,  TO_DATE('2014-06-25 13 47 1', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(487, 781,  TO_DATE('2014-06-25 22 1 53', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(488, 434,  TO_DATE('2014-06-26 9 12 56', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(489, 136,  TO_DATE('2014-06-26 14 2 59', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(490, 333,  TO_DATE('2014-06-26 15 3 37', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(491, 164,  TO_DATE('2014-06-26 20 18 47', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(492, 832,  TO_DATE('2014-06-27 0 13 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(493, 269,  TO_DATE('2014-06-27 1 48 44', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(494, 287,  TO_DATE('2014-06-29 16 29 22', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(495, 334,  TO_DATE('2014-06-29 23 51 39', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(496, 599,  TO_DATE('2014-06-29 14 15 16', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(497, 23,  TO_DATE('2014-06-30 12 4 6', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(498, 682,  TO_DATE('2014-06-30 13 9 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(499, 164,  TO_DATE('2014-06-30 20 13 12', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(500, 931,  TO_DATE('2014-07-01 9 11 15', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(501, 287,  TO_DATE('2014-07-02 10 58 58', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(502, 434,  TO_DATE('2014-07-02 0 4 19', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(503, 256,  TO_DATE('2014-07-02 16 55 32', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(504, 269,  TO_DATE('2014-07-02 11 51 10', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(505, 261,  TO_DATE('2014-07-03 20 43 23', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(506, 164,  TO_DATE('2014-07-03 7 53 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(507, 181,  TO_DATE('2014-07-04 1 12 21', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(508, 872,  TO_DATE('2014-07-04 11 12 13', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(509, 828,  TO_DATE('2014-07-05 7 57 7', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(510, 832,  TO_DATE('2014-07-05 17 5 53', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(511, 272,  TO_DATE('2014-07-06 3 4 28', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(512, 434,  TO_DATE('2014-07-06 3 48 48', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(513, 135,  TO_DATE('2014-07-06 16 15 15', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(514, 633,  TO_DATE('2014-07-06 22 31 43', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(515, 23,  TO_DATE('2014-07-07 22 49 35', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(516, 781,  TO_DATE('2014-07-08 19 56 26', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(517, 136,  TO_DATE('2014-07-08 12 44 25', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(518, 344,  TO_DATE('2014-07-08 18 8 41', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(519, 261,  TO_DATE('2014-07-09 6 25 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(520, 333,  TO_DATE('2014-07-09 16 1 24', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(521, 892,  TO_DATE('2014-07-09 3 30 14', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(522, 682,  TO_DATE('2014-07-09 6 41 15', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(523, 932,  TO_DATE('2014-07-10 11 37 23', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(524, 832,  TO_DATE('2014-07-10 1 27 8', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(525, 599,  TO_DATE('2014-07-10 5 39 55', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(526, 334,  TO_DATE('2014-07-11 4 42 9', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(527, 181,  TO_DATE('2014-07-11 23 48 48', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(528, 931,  TO_DATE('2014-07-11 15 27 6', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(529, 892,  TO_DATE('2014-07-12 12 16 53', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(530, 872,  TO_DATE('2014-07-13 21 37 53', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(531, 256,  TO_DATE('2014-07-13 6 20 5', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(532, 434,  TO_DATE('2014-07-14 15 25 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(533, 135,  TO_DATE('2014-07-14 1 58 9', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(534, 828,  TO_DATE('2014-07-15 16 1 24', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(535, 136,  TO_DATE('2014-07-15 16 43 55', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(536, 333,  TO_DATE('2014-07-15 15 21 27', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(537, 599,  TO_DATE('2014-07-15 18 22 15', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(538, 181,  TO_DATE('2014-07-16 17 44 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(539, 287,  TO_DATE('2014-07-17 3 54 26', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(540, 269,  TO_DATE('2014-07-17 9 19 57', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(541, 932,  TO_DATE('2014-07-19 0 21 42', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(542, 164,  TO_DATE('2014-07-19 3 48 17', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(543, 682,  TO_DATE('2014-07-19 12 9 7', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(544, 344,  TO_DATE('2014-07-19 16 7 51', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(545, 434,  TO_DATE('2014-07-20 15 46 9', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(546, 633,  TO_DATE('2014-07-21 20 41 39', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(547, 892,  TO_DATE('2014-07-21 12 11 26', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(548, 272,  TO_DATE('2014-07-22 22 17 57', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(549, 828,  TO_DATE('2014-07-22 14 36 28', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(550, 23,  TO_DATE('2014-07-22 4 53 59', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(551, 344,  TO_DATE('2014-07-22 0 52 53', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(552, 261,  TO_DATE('2014-07-24 7 1 9', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(553, 781,  TO_DATE('2014-07-24 22 40 18', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(554, 832,  TO_DATE('2014-07-24 10 1 42', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(555, 256,  TO_DATE('2014-07-24 2 45 16', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(556, 135,  TO_DATE('2014-07-24 12 50 19', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(557, 682,  TO_DATE('2014-07-25 6 3 20', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(558, 136,  TO_DATE('2014-07-26 20 19 32', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(559, 181,  TO_DATE('2014-07-26 4 43 28', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(560, 872,  TO_DATE('2014-07-26 7 44 48', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(561, 633,  TO_DATE('2014-07-26 5 4 19', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(562, 269,  TO_DATE('2014-07-26 8 48 10', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(563, 931,  TO_DATE('2014-07-26 11 21 38', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(564, 344,  TO_DATE('2014-07-26 23 27 36', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(565, 261,  TO_DATE('2014-07-27 1 54 40', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(566, 334,  TO_DATE('2014-07-27 11 8 25', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(567, 781,  TO_DATE('2014-07-27 0 48 52', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(568, 333,  TO_DATE('2014-07-27 15 22 0', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(569, 164,  TO_DATE('2014-07-28 19 49 12', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(570, 932,  TO_DATE('2014-07-29 21 3 34', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(571, 287,  TO_DATE('2014-07-29 2 9 6', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(572, 272,  TO_DATE('2014-07-30 17 17 15', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(573, 261,  TO_DATE('2014-07-30 5 4 20', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(574, 892,  TO_DATE('2014-07-30 23 56 55', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(575, 135,  TO_DATE('2014-07-30 8 58 31', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(576, 23,  TO_DATE('2014-08-01 18 23 20', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(577, 599,  TO_DATE('2014-08-01 11 3 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(578, 932,  TO_DATE('2014-08-02 3 1 8', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(579, 434,  TO_DATE('2014-08-02 4 45 44', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(580, 344,  TO_DATE('2014-08-02 17 11 54', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(581, 256,  TO_DATE('2014-08-03 15 47 38', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(582, 892,  TO_DATE('2014-08-03 23 57 54', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(583, 828,  TO_DATE('2014-08-05 1 27 44', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(584, 334,  TO_DATE('2014-08-05 1 20 24', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(585, 181,  TO_DATE('2014-08-05 9 51 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(586, 931,  TO_DATE('2014-08-05 22 49 40', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(587, 599,  TO_DATE('2014-08-06 21 5 46', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(588, 23,  TO_DATE('2014-08-07 15 58 8', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(589, 832,  TO_DATE('2014-08-08 10 13 51', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(590, 269,  TO_DATE('2014-08-08 19 38 20', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(591, 872,  TO_DATE('2014-08-09 11 45 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(592, 334,  TO_DATE('2014-08-09 1 52 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(593, 333,  TO_DATE('2014-08-09 17 22 32', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(594, 633,  TO_DATE('2014-08-09 18 44 11', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(595, 256,  TO_DATE('2014-08-10 16 44 43', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(596, 136,  TO_DATE('2014-08-10 5 13 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(597, 272,  TO_DATE('2014-08-11 14 6 8', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(598, 261,  TO_DATE('2014-08-11 21 20 1', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(599, 932,  TO_DATE('2014-08-12 5 3 59', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(600, 164,  TO_DATE('2014-08-12 2 3 29', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(601, 828,  TO_DATE('2014-08-13 11 5 28', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(602, 781,  TO_DATE('2014-08-14 16 5 56', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(603, 135,  TO_DATE('2014-08-14 4 24 26', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(604, 23,  TO_DATE('2014-08-15 6 49 5', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(605, 287,  TO_DATE('2014-08-16 18 55 18', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(606, 269,  TO_DATE('2014-08-16 9 29 26', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(607, 872,  TO_DATE('2014-08-17 20 52 17', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(608, 931,  TO_DATE('2014-08-17 20 6 12', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(609, 344,  TO_DATE('2014-08-17 2 48 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(610, 334,  TO_DATE('2014-08-18 8 35 27', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(611, 633,  TO_DATE('2014-08-18 8 39 45', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(612, 892,  TO_DATE('2014-08-18 0 3 41', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(613, 932,  TO_DATE('2014-08-19 19 48 34', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(614, 434,  TO_DATE('2014-08-19 23 36 29', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(615, 256,  TO_DATE('2014-08-20 5 20 14', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(616, 599,  TO_DATE('2014-08-20 18 3 25', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(617, 181,  TO_DATE('2014-08-21 8 37 43', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(618, 344,  TO_DATE('2014-08-21 22 43 40', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(619, 164,  TO_DATE('2014-08-22 17 23 50', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(620, 135,  TO_DATE('2014-08-22 5 58 38', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(621, 272,  TO_DATE('2014-08-23 3 36 46', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(622, 333,  TO_DATE('2014-08-23 6 19 51', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(623, 136,  TO_DATE('2014-08-23 23 17 14', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(624, 256,  TO_DATE('2014-08-23 17 15 47', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(625, 892,  TO_DATE('2014-08-23 4 48 24', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(626, 23,  TO_DATE('2014-08-24 15 16 47', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(627, 261,  TO_DATE('2014-08-25 7 8 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(628, 781,  TO_DATE('2014-08-25 20 46 57', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(629, 434,  TO_DATE('2014-08-25 19 31 36', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(630, 256,  TO_DATE('2014-08-26 1 30 51', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(631, 599,  TO_DATE('2014-08-26 19 55 48', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(632, 272,  TO_DATE('2014-08-27 9 54 37', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(633, 23,  TO_DATE('2014-08-27 21 36 41', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(634, 931,  TO_DATE('2014-08-27 20 53 40', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(635, 287,  TO_DATE('2014-08-28 21 4 21', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(636, 828,  TO_DATE('2014-08-28 11 29 46', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(637, 344,  TO_DATE('2014-08-28 11 18 2', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(638, 932,  TO_DATE('2014-08-29 4 26 24', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(639, 261,  TO_DATE('2014-08-29 12 41 23', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(640, 872,  TO_DATE('2014-08-29 10 14 19', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(641, 892,  TO_DATE('2014-08-30 5 11 21', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(642, 287,  TO_DATE('2014-08-31 5 27 43', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(643, 23,  TO_DATE('2014-08-31 6 21 32', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(644, 269,  TO_DATE('2014-08-31 15 0 18', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(645, 334,  TO_DATE('2014-09-01 14 44 37', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(646, 633,  TO_DATE('2014-09-01 23 7 18', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(647, 135,  TO_DATE('2014-09-02 0 49 37', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(648, 932,  TO_DATE('2014-09-03 7 1 48', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(649, 434,  TO_DATE('2014-09-03 16 49 14', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(650, 931,  TO_DATE('2014-09-03 22 41 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(651, 333,  TO_DATE('2014-09-04 9 40 52', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(652, 164,  TO_DATE('2014-09-04 17 55 29', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(653, 256,  TO_DATE('2014-09-04 15 4 3', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(654, 892,  TO_DATE('2014-09-04 17 31 30', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(655, 181,  TO_DATE('2014-09-06 5 39 59', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(656, 872,  TO_DATE('2014-09-06 12 39 15', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(657, 23,  TO_DATE('2014-09-06 3 56 14', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(658, 931,  TO_DATE('2014-09-06 4 12 14', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(659, 633,  TO_DATE('2014-09-08 14 9 56', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(660, 344,  TO_DATE('2014-09-09 10 47 40', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(661, 261,  TO_DATE('2014-09-10 22 44 20', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(662, 164,  TO_DATE('2014-09-10 20 33 24', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(663, 272,  TO_DATE('2014-09-11 22 8 3', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(664, 828,  TO_DATE('2014-09-11 18 6 57', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(665, 287,  TO_DATE('2014-09-11 22 59 28', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(666, 781,  TO_DATE('2014-09-11 7 49 14', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(667, 256,  TO_DATE('2014-09-11 7 45 40', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(668, 334,  TO_DATE('2014-09-13 6 31 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(669, 633,  TO_DATE('2014-09-13 20 59 6', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(670, 269,  TO_DATE('2014-09-13 13 51 51', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(671, 932,  TO_DATE('2014-09-14 4 27 46', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(672, 599,  TO_DATE('2014-09-14 1 42 36', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(673, 23,  TO_DATE('2014-09-14 10 6 45', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(674, 272,  TO_DATE('2014-09-15 8 14 32', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(675, 181,  TO_DATE('2014-09-15 9 26 53', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(676, 333,  TO_DATE('2014-09-15 10 0 2', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(677, 164,  TO_DATE('2014-09-15 12 22 50', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(678, 828,  TO_DATE('2014-09-16 12 50 31', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(679, 781,  TO_DATE('2014-09-16 14 29 23', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(680, 892,  TO_DATE('2014-09-16 3 46 52', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(681, 135,  TO_DATE('2014-09-17 12 18 28', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(682, 434,  TO_DATE('2014-09-18 10 1 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(683, 931,  TO_DATE('2014-09-18 9 23 31', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(684, 344,  TO_DATE('2014-09-18 8 37 18', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(685, 287,  TO_DATE('2014-09-19 17 54 17', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(686, 872,  TO_DATE('2014-09-20 7 5 53', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(687, 633,  TO_DATE('2014-09-20 2 11 51', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(688, 334,  TO_DATE('2014-09-21 6 46 44', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(689, 256,  TO_DATE('2014-09-23 17 4 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(690, 599,  TO_DATE('2014-09-23 4 7 29', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(691, 261,  TO_DATE('2014-09-24 8 9 0', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(692, 344,  TO_DATE('2014-09-24 1 12 7', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(693, 164,  TO_DATE('2014-09-25 18 46 48', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(694, 333,  TO_DATE('2014-09-26 17 18 33', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(695, 932,  TO_DATE('2014-09-27 9 14 47', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(696, 272,  TO_DATE('2014-09-27 16 51 48', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(697, 828,  TO_DATE('2014-09-27 17 14 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(698, 135,  TO_DATE('2014-09-27 4 39 31', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(699, 931,  TO_DATE('2014-09-27 16 6 38', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(700, 781,  TO_DATE('2014-09-28 9 39 2', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(701, 261,  TO_DATE('2014-09-28 2 36 54', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(702, 23,  TO_DATE('2014-09-28 8 41 5', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(703, 269,  TO_DATE('2014-09-28 16 32 11', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(704, 181,  TO_DATE('2014-09-29 12 35 19', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(705, 333,  TO_DATE('2014-09-29 21 31 22', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(706, 334,  TO_DATE('2014-09-30 20 14 3', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(707, 256,  TO_DATE('2014-09-30 21 46 17', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(708, 344,  TO_DATE('2014-09-30 21 53 31', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(709, 434,  TO_DATE('2014-10-01 9 30 9', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(710, 892,  TO_DATE('2014-10-01 9 32 5', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(711, 872,  TO_DATE('2014-10-02 10 44 13', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(712, 287,  TO_DATE('2014-10-03 10 50 26', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(713, 633,  TO_DATE('2014-10-03 1 9 11', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(714, 23,  TO_DATE('2014-10-03 23 6 32', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(715, 164,  TO_DATE('2014-10-04 6 45 3', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(716, 256,  TO_DATE('2014-10-05 22 16 7', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(717, 272,  TO_DATE('2014-10-06 12 49 53', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(718, 633,  TO_DATE('2014-10-06 13 42 36', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(719, 828,  TO_DATE('2014-10-07 0 18 47', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(720, 261,  TO_DATE('2014-10-07 18 27 22', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(721, 872,  TO_DATE('2014-10-07 3 57 11', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(722, 333,  TO_DATE('2014-10-07 11 55 55', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(723, 599,  TO_DATE('2014-10-08 18 10 40', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(724, 931,  TO_DATE('2014-10-08 14 17 22', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(725, 781,  TO_DATE('2014-10-09 19 44 1', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(726, 181,  TO_DATE('2014-10-09 22 17 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(727, 135,  TO_DATE('2014-10-09 1 21 58', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(728, 892,  TO_DATE('2014-10-10 8 41 20', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(729, 932,  TO_DATE('2014-10-11 3 16 43', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(730, 334,  TO_DATE('2014-10-11 23 25 7', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(731, 344,  TO_DATE('2014-10-11 11 32 16', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(732, 828,  TO_DATE('2014-10-12 9 47 53', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(733, 261,  TO_DATE('2014-10-12 7 9 8', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(734, 633,  TO_DATE('2014-10-13 8 48 56', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(735, 269,  TO_DATE('2014-10-13 3 58 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(736, 599,  TO_DATE('2014-10-13 7 4 22', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(737, 333,  TO_DATE('2014-10-14 9 43 0', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(738, 434,  TO_DATE('2014-10-15 5 8 43', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(739, 23,  TO_DATE('2014-10-15 23 59 20', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(740, 287,  TO_DATE('2014-10-16 4 20 31', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(741, 261,  TO_DATE('2014-10-16 1 25 46', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(742, 334,  TO_DATE('2014-10-16 19 18 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(743, 932,  TO_DATE('2014-10-17 9 19 52', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(744, 164,  TO_DATE('2014-10-17 1 18 37', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(745, 256,  TO_DATE('2014-10-17 3 51 52', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(746, 781,  TO_DATE('2014-10-19 7 7 13', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(747, 932,  TO_DATE('2014-10-20 11 6 33', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(748, 872,  TO_DATE('2014-10-20 8 47 22', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(749, 181,  TO_DATE('2014-10-21 6 26 10', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(750, 135,  TO_DATE('2014-10-21 14 29 50', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(751, 269,  TO_DATE('2014-10-21 3 30 13', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(752, 931,  TO_DATE('2014-10-21 4 38 48', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(753, 272,  TO_DATE('2014-10-22 5 47 2', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(754, 261,  TO_DATE('2014-10-22 5 19 44', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(755, 23,  TO_DATE('2014-10-22 15 49 20', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(756, 333,  TO_DATE('2014-10-23 6 37 5', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(757, 344,  TO_DATE('2014-10-24 6 15 58', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(758, 434,  TO_DATE('2014-10-26 5 13 50', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(759, 181,  TO_DATE('2014-10-26 18 29 39', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(760, 272,  TO_DATE('2014-10-26 13 21 38', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(761, 599,  TO_DATE('2014-10-26 23 47 20', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(762, 269,  TO_DATE('2014-10-26 4 50 36', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(763, 931,  TO_DATE('2014-10-26 21 10 17', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(764, 828,  TO_DATE('2014-10-27 18 5 23', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(765, 892,  TO_DATE('2014-10-28 8 9 30', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(766, 633,  TO_DATE('2014-10-29 10 43 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(767, 164,  TO_DATE('2014-10-29 10 24 26', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(768, 256,  TO_DATE('2014-10-29 23 57 15', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(769, 135,  TO_DATE('2014-10-30 3 22 15', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(770, 287,  TO_DATE('2014-10-31 15 49 9', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(771, 272,  TO_DATE('2014-10-31 2 51 1', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(772, 333,  TO_DATE('2014-10-31 11 29 41', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(773, 334,  TO_DATE('2014-11-01 0 42 29', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(774, 828,  TO_DATE('2014-11-02 22 31 44', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(775, 261,  TO_DATE('2014-11-02 23 40 59', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(776, 932,  TO_DATE('2014-11-03 20 57 2', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(777, 434,  TO_DATE('2014-11-04 21 30 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(778, 23,  TO_DATE('2014-11-04 0 42 3', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(779, 599,  TO_DATE('2014-11-04 12 5 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(780, 333,  TO_DATE('2014-11-05 16 51 42', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(781, 269,  TO_DATE('2014-11-06 18 52 16', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(782, 287,  TO_DATE('2014-11-07 16 59 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(783, 164,  TO_DATE('2014-11-07 1 25 58', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(784, 23,  TO_DATE('2014-11-08 8 40 51', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(785, 181,  TO_DATE('2014-11-09 18 46 7', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(786, 828,  TO_DATE('2014-11-09 6 7 41', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(787, 633,  TO_DATE('2014-11-09 11 33 21', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(788, 892,  TO_DATE('2014-11-09 11 14 9', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(789, 261,  TO_DATE('2014-11-10 5 1 15', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(790, 931,  TO_DATE('2014-11-11 18 38 15', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(791, 256,  TO_DATE('2014-11-13 16 23 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(792, 333,  TO_DATE('2014-11-13 20 18 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(793, 272,  TO_DATE('2014-11-14 10 38 2', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(794, 633,  TO_DATE('2014-11-14 15 6 24', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(795, 287,  TO_DATE('2014-11-15 1 33 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(796, 828,  TO_DATE('2014-11-16 8 30 35', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(797, 334,  TO_DATE('2014-11-16 9 52 31', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(798, 599,  TO_DATE('2014-11-16 2 11 48', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(799, 932,  TO_DATE('2014-11-18 17 43 26', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(800, 434,  TO_DATE('2014-11-19 7 58 55', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(801, 261,  TO_DATE('2014-11-19 15 12 2', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(802, 272,  TO_DATE('2014-11-20 14 3 44', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(803, 269,  TO_DATE('2014-11-20 10 39 25', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(804, 599,  TO_DATE('2014-11-20 5 24 33', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(805, 164,  TO_DATE('2014-11-22 18 41 59', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(806, 287,  TO_DATE('2014-11-23 5 0 17', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(807, 256,  TO_DATE('2014-11-23 16 5 17', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(808, 23,  TO_DATE('2014-11-23 14 11 29', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(809, 633,  TO_DATE('2014-11-23 12 43 48', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(810, 334,  TO_DATE('2014-11-24 13 58 0', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(811, 633,  TO_DATE('2014-11-26 21 27 46', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(812, 333,  TO_DATE('2014-11-27 19 52 15', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(813, 164,  TO_DATE('2014-11-27 12 24 3', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(814, 269,  TO_DATE('2014-11-27 13 36 55', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(815, 932,  TO_DATE('2014-11-29 20 9 31', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(816, 828,  TO_DATE('2014-11-30 3 40 50', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(817, 261,  TO_DATE('2014-11-30 15 30 16', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(818, 164,  TO_DATE('2014-11-30 10 43 29', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(819, 287,  TO_DATE('2014-12-01 10 31 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(820, 334,  TO_DATE('2014-12-01 18 6 41', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(821, 434,  TO_DATE('2014-12-03 5 5 24', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(822, 599,  TO_DATE('2014-12-03 18 29 7', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(823, 287,  TO_DATE('2014-12-04 7 14 44', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(824, 256,  TO_DATE('2014-12-05 0 1 11', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(825, 334,  TO_DATE('2014-12-06 23 52 1', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(826, 272,  TO_DATE('2014-12-06 5 40 59', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(827, 23,  TO_DATE('2014-12-06 3 57 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(828, 333,  TO_DATE('2014-12-09 15 46 28', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(829, 23,  TO_DATE('2014-12-09 22 59 56', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(830, 434,  TO_DATE('2014-12-10 19 55 1', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(831, 256,  TO_DATE('2014-12-10 4 49 50', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(832, 633,  TO_DATE('2014-12-10 12 56 13', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(833, 164,  TO_DATE('2014-12-10 7 33 54', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(834, 599,  TO_DATE('2014-12-11 14 4 4', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(835, 932,  TO_DATE('2014-12-13 12 50 3', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(836, 287,  TO_DATE('2014-12-13 8 21 47', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(837, 633,  TO_DATE('2014-12-13 11 39 43', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(838, 333,  TO_DATE('2014-12-14 13 4 7', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(839, 261,  TO_DATE('2014-12-15 23 25 56', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(840, 272,  TO_DATE('2014-12-15 11 37 18', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(841, 272,  TO_DATE('2014-12-18 3 42 29', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(842, 164,  TO_DATE('2014-12-18 18 47 23', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(843, 334,  TO_DATE('2014-12-19 11 8 29', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(844, 932,  TO_DATE('2014-12-20 4 42 29', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(845, 23,  TO_DATE('2014-12-20 15 45 52', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(846, 633,  TO_DATE('2014-12-21 17 59 10', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(847, 434,  TO_DATE('2014-12-22 1 56 6', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(848, 333,  TO_DATE('2014-12-23 17 30 47', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(849, 164,  TO_DATE('2014-12-24 7 39 31', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(850, 599,  TO_DATE('2014-12-25 6 7 41', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(851, 256,  TO_DATE('2014-12-26 1 7 40', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(852, 287,  TO_DATE('2014-12-27 7 50 4', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(853, 633,  TO_DATE('2014-12-27 2 44 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(854, 272,  TO_DATE('2014-12-29 17 26 18', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(855, 261,  TO_DATE('2014-12-31 2 58 7', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(856, 334,  TO_DATE('2015-01-02 13 40 9', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(857, 23,  TO_DATE('2015-01-02 11 23 43', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(858, 932,  TO_DATE('2015-01-03 17 6 28', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(859, 434,  TO_DATE('2015-01-03 7 6 3', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(860, 261,  TO_DATE('2015-01-03 11 17 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(861, 272,  TO_DATE('2015-01-04 20 1 16', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(862, 287,  TO_DATE('2015-01-05 18 24 44', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(863, 164,  TO_DATE('2015-01-07 14 3 28', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(864, 23,  TO_DATE('2015-01-08 1 45 10', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(865, 434,  TO_DATE('2015-01-09 10 33 19', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(866, 256,  TO_DATE('2015-01-09 20 18 38', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(867, 633,  TO_DATE('2015-01-10 2 49 36', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(868, 599,  TO_DATE('2015-01-11 14 11 44', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(869, 261,  TO_DATE('2015-01-17 23 32 38', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(870, 164,  TO_DATE('2015-01-17 10 36 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(871, 633,  TO_DATE('2015-01-17 1 52 42', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(872, 23,  TO_DATE('2015-01-18 15 49 4', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(873, 272,  TO_DATE('2015-01-19 6 11 14', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(874, 434,  TO_DATE('2015-01-20 11 37 13', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(875, 256,  TO_DATE('2015-01-22 9 23 41', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(876, 434,  TO_DATE('2015-01-24 1 56 20', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(877, 164,  TO_DATE('2015-01-26 17 15 57', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(878, 599,  TO_DATE('2015-01-27 9 5 44', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(879, 633,  TO_DATE('2015-01-28 12 10 17', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(880, 434,  TO_DATE('2015-01-31 13 35 40', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(881, 261,  TO_DATE('2015-02-02 22 9 53', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(882, 256,  TO_DATE('2015-02-02 4 31 16', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(883, 599,  TO_DATE('2015-02-03 18 0 27', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(884, 164,  TO_DATE('2015-02-04 6 1 0', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(885, 23,  TO_DATE('2015-02-05 8 48 52', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(886, 434,  TO_DATE('2015-02-08 3 56 19', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(887, 261,  TO_DATE('2015-02-09 6 47 56', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(888, 633,  TO_DATE('2015-02-11 8 5 38', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(889, 256,  TO_DATE('2015-02-17 18 49 7', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(890, 434,  TO_DATE('2015-02-17 6 47 39', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(891, 164,  TO_DATE('2015-02-20 18 59 14', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(892, 261,  TO_DATE('2015-02-21 7 2 49', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(893, 633,  TO_DATE('2015-02-21 5 23 3', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(894, 256,  TO_DATE('2015-02-22 19 38 57', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(895, 434,  TO_DATE('2015-02-22 12 10 34', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(896, 633,  TO_DATE('2015-02-24 3 20 42', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(897, 434,  TO_DATE('2015-02-25 2 55 57', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(898, 164,  TO_DATE('2015-03-02 11 15 21', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(899, 261,  TO_DATE('2015-03-04 2 12 31', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(900, 633,  TO_DATE('2015-03-05 21 11 18', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(901, 164,  TO_DATE('2015-03-09 10 34 19', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(902, 633,  TO_DATE('2015-03-09 15 23 58', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(903, 256,  TO_DATE('2015-03-10 11 26 29', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(904, 434,  TO_DATE('2015-03-10 7 46 48', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(905, 434,  TO_DATE('2015-03-14 3 53 35', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(906, 261,  TO_DATE('2015-03-15 5 56 12', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(907, 256,  TO_DATE('2015-03-16 3 57 11', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(908, 164,  TO_DATE('2015-03-28 5 24 21', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(909, 434,  TO_DATE('2015-03-30 21 35 32', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(910, 256,  TO_DATE('2015-04-01 17 41 39', 'YYYY-MM-DD HH24 MI SS'), 3);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(911, 256,  TO_DATE('2015-04-07 9 33 14', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(912, 164,  TO_DATE('2015-04-08 3 2 41', 'YYYY-MM-DD HH24 MI SS'), 4);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(913, 434,  TO_DATE('2015-04-11 18 43 37', 'YYYY-MM-DD HH24 MI SS'), 1);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(914, 256,  TO_DATE('2015-04-14 10 7 42', 'YYYY-MM-DD HH24 MI SS'), 2);

INSERT INTO RentalAgreement(AgreementID, CustID, AgreementDate, DurationID)
 VALUES(915, 434,  TO_DATE('2015-04-14 4 51 50', 'YYYY-MM-DD HH24 MI SS'), 3);

--This statement allows data to contain an ampersand
--LEAVE IT IN!!
SET DEFINE OFF

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(77, 1, 3.56, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(128, 2, 2.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(107, 3, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(98, 4, 3.34, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(122, 5, 1.63, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(81, 5, 3.36, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(128, 5, 2.65, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(97, 6, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(20, 7, 4.05, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(126, 7, 2.28, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 7, 3.73, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(68, 8, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(25, 8, 3.14, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(59, 8, 4.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(26, 8, 4.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(67, 8, 3.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 8, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(19, 9, 4.08, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 10, 3.94, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(89, 11, 3.45, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(92, 11, 3.71, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(90, 11, 3.52, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(88, 11, 3.98, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(125, 11, 2.68, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(103, 11, 3.46, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(128, 12, 2.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(105, 13, 3.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(85, 14, 3.39, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(79, 15, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(83, 16, 3.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(95, 16, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(80, 16, 4.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(58, 17, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(78, 18, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(120, 19, 3.53, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(109, 20, 4.01, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(50, 21, 3.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(109, 22, 4.01, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(81, 23, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(95, 24, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(87, 25, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(131, 26, 1.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(90, 27, 3.75, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(107, 28, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(62, 29, 4.29, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(131, 30, 1.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(118, 31, 2.87, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(64, 31, 3.98, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(87, 31, 3.99, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(102, 32, 3.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(56, 33, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(108, 34, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(19, 35, 4.08, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(121, 36, 2.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(45, 37, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(20, 38, 4.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(50, 39, 3.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(55, 40, 3.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(96, 41, 4.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 42, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(107, 43, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(123, 44, 3.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(90, 45, 3.75, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(99, 46, 3.83, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(26, 47, 4.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(68, 48, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(59, 49, 4.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(89, 50, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(49, 51, 3.71, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(14, 51, 3.45, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(120, 51, 3.34, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(106, 52, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(111, 53, 3.97, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 54, 3.94, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(82, 55, 3.31, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(95, 55, 3.00, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(111, 55, 3.76, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(20, 56, 4.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(103, 57, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(45, 58, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(129, 59, 4.02, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(56, 60, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(26, 60, 4.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(90, 60, 3.75, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(48, 61, 3.90, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(87, 62, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(127, 63, 3.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(55, 64, 3.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(77, 65, 3.56, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(129, 66, 3.77, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(131, 66, 1.50, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(96, 66, 4.17, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(91, 66, 3.55, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(109, 66, 3.76, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(44, 66, 4.03, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(49, 67, 3.92, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(109, 68, 3.76, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(95, 68, 2.97, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(94, 68, 3.32, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(122, 68, 1.61, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(97, 68, 3.92, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(115, 68, 4.01, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(110, 69, 3.50, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(106, 70, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(15, 71, 3.91, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(129, 72, 4.02, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(116, 73, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(86, 74, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(27, 75, 4.88, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(88, 76, 4.24, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(104, 77, 3.23, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(106, 78, 3.00, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(44, 78, 4.07, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(100, 78, 3.85, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(73, 79, 3.48, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(23, 79, 3.80, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(20, 79, 4.00, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(29, 79, 3.98, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(78, 79, 3.84, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(122, 79, 1.61, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(46, 80, 3.32, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(123, 81, 3.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(48, 82, 3.90, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(123, 83, 3.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(26, 84, 4.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(103, 85, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(73, 86, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(82, 87, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(23, 88, 3.84, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 88, 3.99, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(28, 88, 4.20, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(72, 89, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(50, 90, 3.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(76, 91, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(122, 92, 1.72, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(111, 92, 3.97, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 92, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(95, 93, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(62, 94, 4.29, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(61, 94, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(116, 94, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(60, 95, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(22, 96, 3.58, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(85, 97, 3.39, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(68, 97, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(115, 97, 4.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(72, 98, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(85, 99, 3.39, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(85, 100, 3.39, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(131, 101, 1.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(43, 102, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(89, 103, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(13, 104, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(115, 105, 4.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(75, 106, 4.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(20, 107, 4.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(48, 108, 3.90, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(82, 109, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(69, 110, 4.19, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(67, 111, 3.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(20, 112, 4.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(107, 113, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(102, 114, 3.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(61, 115, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(55, 116, 3.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(87, 117, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(100, 118, 4.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(18, 119, 4.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(114, 120, 3.27, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(67, 120, 3.38, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(75, 120, 4.06, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(86, 120, 3.84, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 120, 3.95, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(129, 120, 3.77, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(19, 121, 4.08, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(60, 122, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(128, 123, 2.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(71, 124, 3.96, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(109, 125, 4.01, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(125, 125, 2.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(44, 125, 4.30, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(43, 126, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(94, 127, 3.54, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(100, 128, 4.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(129, 129, 4.02, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 129, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(105, 129, 3.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(100, 129, 4.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(98, 129, 3.34, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(131, 129, 1.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(69, 129, 4.19, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(101, 129, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(119, 129, 2.78, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(58, 129, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(125, 129, 2.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(122, 129, 1.72, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(27, 129, 4.88, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(62, 130, 4.29, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(101, 131, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(24, 132, 4.52, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(126, 132, 2.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(46, 132, 3.32, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(63, 133, 3.56, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(111, 134, 3.97, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(76, 134, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(108, 134, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(77, 135, 3.56, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(46, 136, 3.32, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(29, 137, 4.25, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(107, 138, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(47, 139, 3.85, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(108, 140, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(81, 141, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(97, 142, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 143, 3.94, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(92, 144, 3.96, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(104, 145, 3.23, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(110, 146, 3.50, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(65, 147, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(64, 148, 4.20, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(86, 149, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(95, 150, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(87, 151, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(82, 152, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(123, 153, 3.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(118, 154, 2.87, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 154, 3.73, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(105, 154, 3.66, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(58, 155, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(127, 156, 3.10, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(88, 156, 4.02, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(102, 156, 3.11, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(84, 157, 3.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(98, 158, 3.34, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(89, 159, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(108, 160, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(76, 161, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(98, 161, 3.34, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(116, 161, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(86, 162, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(73, 163, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(85, 164, 3.39, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(112, 164, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(55, 164, 3.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(113, 164, 3.26, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(69, 164, 4.19, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(18, 164, 4.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(77, 164, 3.56, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(81, 164, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(19, 165, 4.08, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(61, 166, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(65, 167, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(130, 168, 1.01, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(69, 169, 4.19, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(48, 170, 3.90, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(32, 171, 3.99, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(19, 172, 4.08, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(97, 173, 3.92, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(14, 173, 3.41, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(18, 173, 4.41, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(98, 173, 3.13, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(22, 173, 3.36, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(79, 173, 3.48, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(50, 174, 3.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(65, 175, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(65, 176, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(97, 177, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(44, 178, 4.30, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(121, 179, 2.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(116, 180, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(47, 181, 3.85, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 182, 3.94, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(127, 183, 3.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(86, 184, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(20, 184, 4.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(121, 184, 2.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(107, 184, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(14, 184, 3.64, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(15, 184, 3.91, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(74, 184, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(49, 184, 3.92, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(105, 184, 3.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(27, 184, 4.88, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(118, 184, 3.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(60, 184, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(120, 184, 3.53, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(99, 184, 3.83, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(93, 184, 3.38, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(110, 184, 3.50, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(45, 185, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(32, 186, 3.78, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(84, 186, 2.90, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(64, 186, 3.98, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(24, 187, 4.52, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(61, 188, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(74, 189, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(108, 190, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(65, 191, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(94, 192, 3.54, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(84, 193, 3.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(22, 194, 3.58, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(18, 195, 4.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(94, 196, 3.54, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(114, 197, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(23, 198, 4.05, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(125, 199, 2.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(129, 200, 4.02, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(130, 201, 1.01, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(73, 202, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(75, 203, 4.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(104, 204, 3.23, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(62, 205, 4.29, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(87, 205, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(103, 205, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(18, 206, 4.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(22, 207, 3.58, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(112, 208, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(13, 208, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(91, 208, 3.79, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(20, 208, 4.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(105, 208, 3.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(18, 208, 4.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 208, 3.94, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(93, 208, 3.38, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(68, 208, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(69, 208, 4.19, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(103, 208, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(80, 208, 4.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(50, 208, 3.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(74, 208, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(73, 208, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(27, 208, 4.88, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(27, 209, 4.88, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(72, 210, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(24, 211, 4.28, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(107, 211, 3.36, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(46, 211, 3.15, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(47, 212, 3.85, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(116, 213, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(35, 214, 3.90, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(72, 214, 3.64, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(122, 214, 1.63, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(127, 215, 3.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(95, 216, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(66, 217, 3.59, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 218, 3.94, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(69, 219, 4.19, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(45, 220, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(83, 221, 3.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(120, 222, 3.53, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(115, 223, 4.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(123, 224, 3.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(125, 225, 2.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(29, 225, 4.25, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(118, 225, 3.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(90, 226, 3.75, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(75, 227, 4.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(80, 228, 4.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(35, 229, 4.12, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(99, 230, 3.83, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(55, 231, 3.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(66, 232, 3.59, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(49, 233, 3.92, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(75, 234, 4.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(119, 235, 2.63, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(123, 235, 3.04, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(68, 235, 3.62, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(95, 236, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(29, 237, 4.25, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(111, 238, 3.97, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(125, 239, 2.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(89, 240, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(108, 241, 3.64, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(92, 241, 3.75, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(69, 241, 3.97, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(27, 242, 4.88, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(83, 243, 3.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 244, 3.94, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(90, 245, 3.75, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(103, 246, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(43, 247, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(75, 248, 4.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(111, 249, 3.97, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(108, 250, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(114, 251, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(127, 252, 3.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(105, 253, 3.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(47, 254, 3.85, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(125, 255, 2.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(128, 256, 2.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(81, 256, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 256, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(73, 257, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(105, 258, 3.66, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(22, 258, 3.39, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(79, 258, 3.52, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(48, 259, 3.90, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(83, 260, 3.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(59, 261, 4.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(43, 262, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(82, 263, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(112, 264, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(104, 265, 3.23, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(84, 266, 3.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(75, 267, 4.10, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(14, 267, 3.45, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(82, 267, 3.31, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(61, 268, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(99, 269, 3.83, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(93, 270, 3.38, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(76, 271, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(63, 272, 3.56, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(113, 273, 3.09, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(102, 273, 3.11, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(18, 273, 4.45, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(77, 274, 3.56, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(98, 275, 3.34, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(96, 276, 4.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(98, 277, 3.34, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(89, 278, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(26, 279, 4.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(118, 280, 3.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(79, 281, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(27, 282, 4.62, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(59, 282, 4.20, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(127, 282, 3.10, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(87, 283, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(117, 284, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(91, 285, 3.79, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(61, 286, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(72, 287, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(29, 288, 4.03, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 288, 3.99, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(68, 288, 3.62, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(104, 289, 3.23, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(28, 290, 4.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(123, 291, 3.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(90, 292, 3.75, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(108, 293, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(72, 294, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(82, 295, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(27, 296, 4.88, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(99, 297, 3.63, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(78, 297, 3.88, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(86, 297, 3.88, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(111, 298, 3.97, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(83, 299, 3.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(74, 300, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(87, 300, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(62, 300, 4.29, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(67, 300, 3.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(129, 300, 4.02, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(18, 300, 4.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(121, 300, 2.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(23, 300, 4.05, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(98, 300, 3.34, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(55, 300, 3.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(105, 300, 3.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(91, 300, 3.79, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(88, 300, 4.24, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(76, 300, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(113, 300, 3.26, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(128, 300, 2.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(109, 301, 4.01, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(80, 302, 4.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(130, 303, 1.01, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(24, 304, 4.52, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(84, 305, 3.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(29, 306, 4.03, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(79, 306, 3.52, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(22, 306, 3.39, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(55, 307, 3.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(90, 308, 3.75, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(128, 309, 2.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(88, 310, 4.24, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(50, 311, 3.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(130, 312, 1.01, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(47, 313, 3.85, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(69, 314, 4.19, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(89, 315, 3.49, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(56, 315, 3.69, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(20, 315, 4.05, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(20, 316, 4.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(115, 317, 4.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(121, 318, 2.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(43, 319, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(58, 320, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(125, 321, 2.71, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(44, 321, 4.07, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(27, 321, 4.62, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(94, 322, 3.54, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(15, 323, 3.91, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(88, 324, 4.24, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(123, 324, 3.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(43, 324, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(113, 325, 3.26, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(103, 326, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(130, 327, 1.01, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(67, 328, 3.41, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 328, 3.99, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(97, 328, 3.96, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(98, 329, 3.34, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(104, 330, 3.23, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(92, 331, 3.96, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(82, 332, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(29, 333, 4.25, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(71, 334, 3.96, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(49, 335, 3.71, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(59, 335, 4.20, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(48, 335, 3.70, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(112, 336, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(106, 337, 3.00, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(80, 337, 3.82, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(58, 337, 3.62, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(23, 338, 4.05, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(129, 339, 3.77, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(80, 339, 3.78, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(13, 339, 3.83, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(91, 339, 3.55, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(103, 339, 3.46, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(99, 339, 3.59, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(76, 340, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(29, 341, 4.25, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(13, 342, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(123, 343, 3.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(65, 344, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(75, 345, 4.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(33, 346, 4.31, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(59, 346, 4.20, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(76, 346, 3.25, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(111, 347, 3.97, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(46, 348, 3.32, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(103, 349, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(19, 350, 4.08, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(84, 350, 3.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 350, 3.94, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(131, 351, 1.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(81, 352, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(106, 353, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(50, 354, 3.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(128, 355, 2.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(114, 356, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(35, 357, 4.12, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(118, 358, 3.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(111, 359, 3.76, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(130, 359, 0.96, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(50, 359, 3.51, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(114, 360, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(74, 361, 3.69, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(84, 361, 2.90, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(118, 361, 2.87, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(102, 362, 3.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(81, 363, 3.33, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(129, 363, 3.77, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(49, 363, 3.68, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(82, 363, 3.27, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(103, 363, 3.46, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(64, 363, 3.94, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(26, 364, 4.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(108, 365, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(28, 366, 4.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(48, 367, 3.90, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(102, 367, 3.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(72, 367, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(107, 368, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(113, 369, 3.26, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(22, 370, 3.58, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(101, 371, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(128, 372, 2.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(72, 373, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(25, 374, 3.14, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(69, 375, 3.93, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(55, 375, 3.56, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(72, 375, 3.60, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(78, 375, 3.84, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(117, 375, 3.12, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(35, 375, 3.86, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(113, 376, 3.26, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(108, 377, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(85, 378, 3.39, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(94, 379, 3.54, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(22, 380, 3.58, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(104, 381, 3.23, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(131, 382, 1.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(84, 383, 2.90, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(102, 383, 3.11, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(63, 383, 3.37, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(71, 384, 3.96, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(102, 385, 3.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(64, 386, 3.98, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(92, 386, 3.75, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(98, 386, 3.16, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(88, 387, 4.24, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(33, 388, 4.31, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(127, 388, 3.10, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(112, 388, 3.62, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(80, 389, 4.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(60, 390, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(123, 391, 3.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(79, 392, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(104, 392, 3.23, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(50, 392, 3.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(96, 392, 4.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(15, 392, 3.91, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(22, 392, 3.58, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(61, 393, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(64, 394, 4.20, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(106, 395, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(46, 396, 3.32, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(49, 397, 3.92, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(33, 398, 4.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(50, 399, 3.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(24, 400, 4.52, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(121, 401, 2.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(117, 402, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(22, 403, 3.58, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(127, 404, 3.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(18, 405, 4.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(59, 406, 4.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(47, 407, 3.85, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(129, 408, 4.02, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(87, 409, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(25, 410, 3.14, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(46, 411, 3.32, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(65, 412, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(90, 413, 3.75, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(123, 414, 3.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(73, 415, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(65, 416, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(47, 417, 3.85, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(26, 418, 4.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(102, 419, 3.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(105, 420, 3.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(111, 421, 3.97, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(78, 422, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 422, 3.94, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(18, 422, 4.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(86, 422, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(103, 422, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(85, 422, 3.39, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(49, 422, 3.92, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(84, 422, 3.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(80, 422, 4.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(42, 422, 4.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(14, 422, 3.64, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(22, 422, 3.58, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(82, 422, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(29, 423, 4.25, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(116, 424, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(15, 425, 3.91, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(59, 426, 4.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(125, 427, 2.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(65, 428, 3.96, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(60, 428, 3.88, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(92, 428, 3.75, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(33, 429, 4.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(93, 430, 3.38, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(87, 431, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(32, 432, 3.99, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(120, 433, 3.53, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 434, 3.94, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(33, 435, 4.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(42, 436, 4.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(35, 437, 4.12, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(120, 438, 3.53, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(49, 439, 3.92, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(94, 440, 3.54, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(55, 441, 3.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(84, 442, 3.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(63, 443, 3.56, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(81, 444, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(116, 445, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(102, 446, 3.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(116, 447, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(69, 448, 4.19, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(75, 449, 4.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(96, 450, 4.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(97, 451, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(88, 452, 4.24, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(33, 453, 4.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(25, 454, 2.98, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(119, 454, 2.63, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(104, 454, 3.06, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(68, 455, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(64, 456, 4.20, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(43, 456, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(110, 456, 3.50, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(75, 457, 4.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(100, 458, 4.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(120, 459, 3.53, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(34, 460, 4.11, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(80, 461, 4.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(126, 462, 2.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 463, 3.94, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(130, 464, 1.01, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(67, 465, 3.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(108, 466, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(13, 467, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(128, 468, 2.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(108, 469, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(97, 470, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(61, 471, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(90, 472, 3.75, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(95, 473, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(104, 474, 3.23, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(28, 475, 4.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(28, 476, 4.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(14, 477, 3.64, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(48, 478, 3.90, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(19, 479, 4.08, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 480, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(62, 481, 4.29, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(67, 482, 3.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(103, 483, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(23, 484, 4.05, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(71, 485, 3.96, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(120, 486, 3.53, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(44, 487, 4.30, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(24, 488, 4.52, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(13, 489, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(43, 490, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(59, 491, 4.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(29, 492, 4.25, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(33, 493, 4.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(114, 494, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(62, 495, 4.29, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(116, 496, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(56, 497, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(45, 498, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(73, 499, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(88, 500, 4.24, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(24, 501, 4.52, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(103, 502, 3.50, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(14, 502, 3.45, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(86, 502, 3.88, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(33, 503, 4.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(20, 504, 4.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(43, 505, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(112, 506, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(126, 507, 2.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(77, 508, 3.37, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(74, 508, 3.69, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(111, 508, 3.76, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(110, 509, 3.50, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(50, 510, 3.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(13, 511, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(96, 512, 4.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(67, 513, 3.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(92, 514, 3.96, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(58, 515, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(106, 516, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(14, 517, 3.64, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(14, 518, 3.64, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(47, 519, 3.85, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(65, 520, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(98, 521, 3.34, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(125, 522, 2.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(102, 523, 3.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(61, 524, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(93, 525, 3.38, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(85, 526, 3.39, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(114, 527, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(96, 528, 4.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(109, 529, 4.01, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(69, 530, 4.19, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(67, 530, 3.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(24, 530, 4.52, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(112, 531, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(107, 532, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(14, 533, 3.64, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(106, 534, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(23, 535, 3.80, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(131, 535, 1.50, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(29, 535, 3.98, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(89, 535, 3.45, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(102, 535, 3.07, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(47, 535, 3.61, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(58, 536, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(44, 537, 4.30, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(101, 537, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(20, 537, 4.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(119, 538, 2.78, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(66, 539, 3.59, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(89, 540, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(91, 541, 3.59, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(112, 541, 3.62, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(86, 541, 3.88, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(113, 542, 3.26, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(93, 543, 3.38, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(128, 544, 2.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(95, 545, 3.00, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(44, 545, 4.07, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(85, 545, 3.21, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(29, 546, 4.25, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(22, 547, 3.58, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(46, 548, 3.32, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(73, 549, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(96, 550, 4.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(42, 551, 4.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(65, 552, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(73, 553, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(63, 554, 3.56, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(67, 555, 3.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(118, 556, 3.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(98, 557, 3.34, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 558, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(129, 559, 4.02, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(27, 560, 4.88, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(102, 561, 3.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(107, 562, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(66, 563, 3.59, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(99, 564, 3.83, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(106, 565, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(24, 566, 4.52, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(67, 567, 3.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(42, 568, 4.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(117, 568, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(116, 568, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(90, 569, 3.75, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(117, 570, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(13, 571, 3.83, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(126, 571, 2.26, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(81, 571, 3.33, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(94, 571, 3.32, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(109, 571, 3.76, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(82, 571, 3.27, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(60, 572, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(126, 573, 2.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(32, 574, 3.99, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(68, 575, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(93, 575, 3.38, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(60, 575, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(108, 576, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(125, 577, 2.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(104, 578, 3.23, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(19, 579, 4.08, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(130, 579, 1.01, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(106, 579, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(105, 580, 3.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(96, 581, 4.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 582, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(101, 583, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(46, 584, 3.32, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(105, 585, 3.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(22, 586, 3.58, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(23, 587, 4.05, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(45, 588, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(93, 589, 3.38, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(60, 590, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(101, 591, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(94, 592, 3.54, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(24, 593, 4.52, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(35, 594, 4.12, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(114, 595, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(114, 596, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(101, 597, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(22, 598, 3.58, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(97, 599, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(73, 599, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(61, 599, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(68, 600, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(79, 601, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(101, 602, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(100, 603, 4.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(118, 604, 3.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(99, 604, 3.83, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(83, 604, 3.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(13, 604, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(48, 604, 3.90, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(77, 604, 3.56, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(98, 604, 3.34, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(43, 604, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(86, 604, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(74, 604, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(24, 604, 4.52, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(95, 604, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(117, 604, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(35, 605, 4.12, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(101, 606, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(58, 607, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(59, 608, 4.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(60, 609, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(32, 610, 3.99, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(90, 611, 3.75, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(114, 612, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(32, 613, 3.74, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(14, 613, 3.41, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(129, 613, 3.77, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 613, 3.69, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(101, 613, 3.46, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(126, 613, 2.26, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(84, 614, 3.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(116, 615, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(69, 616, 4.19, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(61, 617, 3.25, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(125, 617, 2.71, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(68, 617, 3.62, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(32, 618, 3.99, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(92, 619, 3.96, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(32, 620, 3.99, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(43, 621, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(55, 622, 3.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(32, 623, 3.99, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(115, 624, 4.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(117, 625, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(25, 626, 3.14, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(121, 627, 2.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(32, 628, 3.74, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(131, 628, 1.50, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(64, 628, 3.94, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(15, 628, 3.67, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(99, 628, 3.59, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(96, 628, 4.17, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(74, 629, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(55, 630, 3.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(126, 631, 2.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(28, 631, 4.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(43, 631, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(27, 631, 4.88, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(18, 631, 4.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(50, 631, 3.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(65, 631, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(80, 631, 4.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(45, 631, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(42, 631, 4.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(13, 631, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(56, 631, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(89, 631, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(15, 631, 3.91, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(94, 631, 3.54, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(33, 631, 4.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(76, 632, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(67, 633, 3.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(65, 634, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(46, 635, 3.32, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 636, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(93, 637, 3.38, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(85, 638, 3.39, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(110, 639, 3.50, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(88, 639, 4.24, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(48, 639, 3.90, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(101, 639, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(28, 639, 4.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(123, 639, 3.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(14, 640, 3.64, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(81, 641, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(79, 642, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(44, 643, 4.30, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 644, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(59, 645, 4.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(13, 646, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(123, 647, 3.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(47, 648, 3.85, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(77, 649, 3.56, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(75, 650, 4.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(85, 651, 3.39, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 652, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(25, 653, 3.14, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(46, 654, 3.32, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(29, 655, 4.25, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(42, 656, 4.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(128, 657, 2.65, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(49, 657, 3.71, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(34, 657, 3.89, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(86, 658, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(84, 659, 3.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(130, 660, 1.01, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(18, 661, 4.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(126, 662, 2.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(47, 663, 3.85, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(119, 664, 2.78, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(63, 665, 3.56, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(14, 666, 3.64, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(42, 667, 4.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(131, 668, 1.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(121, 669, 2.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(42, 670, 4.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(93, 671, 3.38, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(121, 672, 2.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(88, 673, 4.02, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(62, 673, 4.06, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(103, 673, 3.50, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(59, 674, 4.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(62, 675, 4.29, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(115, 676, 4.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(48, 677, 3.90, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(104, 678, 3.23, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(43, 679, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(24, 680, 4.52, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(114, 681, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(65, 682, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(62, 683, 4.29, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(56, 684, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(106, 685, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(89, 686, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 687, 3.94, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(19, 688, 4.08, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(117, 689, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 690, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(44, 691, 4.30, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(75, 692, 4.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(125, 693, 2.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(74, 694, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(88, 695, 4.24, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(54, 696, 3.46, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(75, 697, 4.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(105, 698, 3.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(128, 699, 2.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(88, 700, 4.24, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(60, 701, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(110, 702, 3.50, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 703, 3.69, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(119, 703, 2.61, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(117, 703, 3.12, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(64, 703, 3.94, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(106, 703, 2.97, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(50, 703, 3.47, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(118, 704, 3.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(89, 705, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(88, 706, 4.24, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(72, 707, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(94, 708, 3.54, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(48, 709, 3.90, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(35, 710, 4.12, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(54, 711, 3.46, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(92, 712, 3.96, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(116, 713, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(66, 714, 3.59, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(131, 715, 1.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(29, 716, 4.25, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(42, 717, 4.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(81, 718, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(54, 719, 3.46, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(90, 720, 3.75, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(79, 721, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(27, 722, 4.88, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(123, 723, 3.04, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(98, 723, 3.16, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(102, 723, 3.11, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(90, 724, 3.75, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(83, 725, 3.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(13, 726, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(101, 727, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(65, 728, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(98, 729, 3.34, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(95, 730, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(111, 731, 3.72, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(19, 731, 3.83, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(33, 731, 4.27, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(58, 731, 3.58, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(81, 731, 3.33, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(54, 731, 3.24, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(86, 732, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(112, 733, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(123, 734, 3.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(115, 735, 4.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(74, 736, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(105, 737, 3.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(117, 738, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(55, 739, 3.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(80, 740, 4.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(49, 741, 3.92, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(14, 742, 3.64, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(115, 743, 4.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(56, 744, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(106, 745, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(94, 746, 3.54, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(96, 747, 4.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(45, 748, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(63, 749, 3.56, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(103, 750, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(62, 751, 4.29, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(61, 752, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(128, 753, 2.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(116, 754, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(42, 755, 4.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(75, 755, 4.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(114, 755, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(26, 755, 4.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(47, 755, 3.85, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(89, 755, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 755, 3.94, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(100, 755, 4.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(127, 755, 3.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(71, 755, 3.96, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(20, 755, 4.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(132, 756, 5.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(43, 757, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(35, 757, 4.12, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(89, 757, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(125, 758, 2.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(66, 759, 3.59, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(95, 760, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(57, 761, 3.51, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(75, 762, 4.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(78, 763, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(62, 764, 4.29, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(100, 765, 4.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(91, 766, 3.79, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(42, 767, 4.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(84, 768, 3.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(85, 769, 3.39, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(119, 770, 2.78, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(132, 771, 5.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(106, 772, 3.17, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(18, 772, 4.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(76, 772, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(105, 773, 3.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(45, 774, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(24, 775, 4.52, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(81, 776, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(71, 777, 3.96, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(107, 778, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(17, 779, 4.48, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(67, 780, 3.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(113, 781, 3.26, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(128, 782, 2.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(77, 783, 3.56, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(90, 784, 3.75, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(28, 785, 4.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(111, 786, 3.97, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(19, 787, 4.08, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(93, 788, 3.17, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(74, 788, 3.65, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(62, 788, 4.02, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(105, 788, 3.62, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(42, 788, 4.13, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(119, 788, 2.61, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(62, 789, 4.29, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(74, 790, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(105, 791, 3.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(21, 792, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(72, 793, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(76, 794, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(42, 795, 4.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(7, 796, 4.46, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(48, 797, 3.90, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(7, 798, 4.46, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(79, 799, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(62, 800, 4.29, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(91, 801, 3.79, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(107, 802, 3.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(26, 803, 4.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(99, 804, 3.59, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(122, 804, 1.61, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(128, 804, 2.63, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(97, 804, 3.92, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(129, 804, 3.77, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(79, 804, 3.48, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(132, 805, 5.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(91, 806, 3.59, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(105, 806, 3.66, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(44, 806, 4.07, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(20, 807, 4.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(73, 808, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(99, 809, 3.83, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(125, 810, 2.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(101, 811, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(56, 812, 3.69, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(71, 812, 3.75, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(93, 812, 3.20, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(41, 813, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(27, 814, 4.88, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(111, 815, 3.97, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(43, 816, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(35, 817, 4.12, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(78, 818, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(48, 819, 3.90, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(45, 820, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(35, 821, 4.12, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(39, 822, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(27, 823, 4.88, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(85, 824, 3.39, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(111, 825, 3.97, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(7, 826, 4.46, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(39, 827, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(63, 828, 3.56, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(65, 829, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(55, 830, 3.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(80, 831, 4.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(38, 832, 4.15, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(80, 833, 4.03, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(22, 834, 3.58, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(47, 834, 3.85, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(112, 834, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(82, 835, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(5, 836, 3.12, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(88, 836, 4.02, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(28, 836, 4.20, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(73, 837, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(19, 838, 4.08, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(97, 838, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(119, 838, 2.78, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(109, 839, 4.01, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(88, 840, 4.24, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(75, 841, 4.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(112, 841, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(94, 841, 3.54, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(108, 841, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(10, 841, 3.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(56, 841, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(44, 841, 4.30, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(14, 841, 3.64, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(119, 842, 2.63, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(106, 842, 3.00, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(96, 842, 4.22, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(103, 843, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(42, 843, 4.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(89, 843, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(100, 843, 4.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(129, 843, 4.02, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(78, 843, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(76, 843, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(108, 843, 3.84, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(34, 843, 4.11, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(64, 843, 4.20, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(55, 843, 3.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(21, 843, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(101, 843, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 843, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(47, 843, 3.85, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(68, 843, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(54, 844, 3.46, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(33, 845, 4.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(40, 846, 3.93, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(112, 847, 3.62, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(75, 847, 4.10, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(91, 847, 3.59, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(101, 848, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(61, 849, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(46, 850, 3.32, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(16, 851, 3.74, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(39, 852, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(78, 853, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(17, 854, 4.48, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(23, 855, 4.05, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(35, 856, 4.12, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(21, 857, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(28, 858, 4.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(49, 859, 3.92, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(13, 860, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(83, 861, 3.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(78, 862, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(127, 863, 3.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(46, 864, 3.32, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(73, 865, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(68, 866, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(64, 867, 4.20, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(114, 868, 3.49, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(10, 868, 3.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(63, 868, 3.56, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(68, 868, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(130, 868, 1.01, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(26, 868, 4.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(115, 868, 4.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(71, 868, 3.96, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(100, 869, 4.06, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(103, 870, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(7, 871, 4.46, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(85, 872, 3.39, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 873, 3.94, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(42, 874, 4.41, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(132, 875, 5.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(131, 876, 1.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 877, 3.94, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(38, 878, 4.15, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(18, 879, 4.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(16, 880, 3.74, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(74, 881, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(18, 882, 4.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(61, 883, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(44, 884, 4.30, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(23, 885, 4.05, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(115, 886, 4.28, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(20, 887, 4.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(66, 888, 3.59, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(93, 889, 3.38, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(58, 890, 3.82, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(57, 890, 3.51, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(40, 890, 3.93, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(64, 891, 4.20, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(131, 892, 1.60, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(23, 893, 4.05, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(122, 894, 1.72, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(25, 895, 3.14, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(56, 896, 3.89, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(26, 897, 4.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(16, 898, 3.74, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(113, 899, 3.06, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(69, 899, 3.93, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(21, 899, 3.83, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(80, 899, 3.78, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(34, 899, 3.85, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(89, 899, 3.45, 6.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(104, 900, 3.23, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(117, 901, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(116, 901, 3.33, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(25, 901, 3.14, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(33, 901, 4.55, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(76, 901, 3.43, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(18, 901, 4.70, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(91, 901, 3.79, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(38, 901, 4.15, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(22, 901, 3.58, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(19, 901, 4.08, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(23, 901, 4.05, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(11, 902, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(109, 903, 4.01, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(101, 904, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(34, 905, 4.11, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(92, 906, 3.96, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(27, 907, 4.88, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(36, 908, 4.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(78, 909, 4.10, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(21, 910, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(98, 910, 3.34, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(12, 910, 4.21, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(119, 911, 2.78, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(55, 912, 3.80, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(79, 912, 3.71, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(39, 912, 3.69, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(97, 912, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(65, 912, 4.18, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(13, 912, 4.09, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(7, 912, 4.46, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(94, 912, 3.54, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(26, 912, 4.86, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(83, 912, 3.45, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(45, 912, 3.68, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(31, 913, 4.54, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(70, 914, 3.73, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(83, 914, 3.27, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(19, 914, 3.87, 5.25);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(94, 915, 3.54, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(20, 915, 4.27, 0.00);

INSERT INTO MovieRented(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
 VALUES(5, 915, 3.29, 0.00);

commit;

--Change 3 movies so they do not have any stars (required for lecture #1)
UPDATE Movie Set Stars = null where MovieID in (115, 87, 37);

--Update the RentalAgreement table to reflect how many movies are rented
--Not normalized, but that is what I want...
UPDATE RentalAgreement RA
SET MovieCount = (Select COUNT(*)
                  FROM MovieRented MR
                  Where RA.AgreementID = MR.AgreementID);
                  

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(24, 'Zac', 'Oleeskey', 5501, 'Leeds St', 'Halifax', 'NS', 'B3K 2T3', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(29, 'Alan', 'Celone', 2230, 'Gottingen Rd', 'Halifax', 'NS', 'B3K 3C6',  null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(37, 'Jessie', 'Maccoy', 12, 'Fairfax St', 'Halifax', 'NS', 'B3H 1Y8', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(258, 'Jamee', 'Cosens', 3550, 'Bright St', 'Halifax', 'NS', 'B3K 4Z3', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(260, 'Allan', 'Robinson', 51, 'Chipstone Close', 'Halifax', 'NS', 'B3M 4H3', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(278, 'Zack', 'Thomas', 535, 'Tower Rd', 'Halifax', 'NS', 'B3H 2X3', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(283, 'Alun', 'Windatt', 3218, 'Bright St', 'Halifax', 'NS', 'B3K 4Z3', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(361, 'Jamie', 'Dumas', 3441, 'Bright St', 'Halifax', 'NS', 'B3K 4Z3', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(402, 'Jessie', 'Moar', 3793, 'Novalea Dr', 'Halifax', 'NS', 'B3K 3E6', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(788, 'Alin', 'Hinds', 19, 'Sylvania', 'Halifax', 'NS', 'B3Z 1J2', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(803, 'Zach', 'Olesky', 5520, 'Leeds St', 'Halifax', 'NS', 'B3K 2T3', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(829, 'Jessey', 'Oleski', 17, 'Ramsgate Lane', 'Halifax', 'NS', 'B3P 2R7', null);

INSERT INTO Customer (CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
 VALUES(899, 'Jamey', 'Schwartz', 4998, 'Vestry St', 'Halifax', 'NS', 'B3K 2N9', null);
 
INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
VALUES(134, 'San Andreas', '2015-05-28', 1.97, 3.80, 6.6, null);

INSERT INTO Movie (MovieID, Name, Released, DistributionCost, RentalAmount, Stars, RatingID)
VALUES(135, 'Jurrasic World', '2015-06-11', 2.16, 4.23, 7.5, null);
          
--
-- Commit all the inserts
--
COMMIT;