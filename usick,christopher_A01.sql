SET PAGESIZE 80;
SET LINESIZE 900;
-- Question 1
SELECT LName || ', ' || FName || CHR(10) 
  || StreetNo || ' ' || Street || CHR(10)
  || City || ', ' || Province || CHR(10)
  || PCode || CHR(10) AS Address
FROM Customer
WHERE EXISTS (
  SELECT CustID
  FROM RentalAgreement
  WHERE AgreementDate >= '2015-Jan-01')  
ORDER BY LName
;

-- Question 2
SELECT RPAD(Name, 50, ' ') AS Name, LPAD(TO_CHAR(Released, 'yyyy'), 50, ' ') AS "Released In", 
  TO_CHAR((RentalAmount - DistributionCost) / DistributionCost * 100, '999.999') AS "% Profit"
FROM Movie
ORDER BY "% Profit" DESC
;

-- Question 3
SELECT Name AS "Movies Never Rented"
FROM Movie
WHERE MovieID IN (
  SELECT MovieID
  FROM Movie
  MINUS 
  -- select movies with more than 0 rents
  SELECT MovieID
  FROM Movie NATURAL JOIN MovieRented
  GROUP BY (MovieID)
  HAVING COUNT(AgreementID) >= 1)
;

-- Question 4
SELECT Name AS "Movie Name", 
  RatingType AS "Rating", 
  TO_CHAR(RentalAmount, '$999.99') AS "Current", 
  TO_CHAR(RentalAmount * DECODE(TRIM(RatingType), 
                                  '14 Accompaniment', 1.25, 
                                  '18 Accompaniment', 1.15,
                                  'Adult', 1.1,
                                  1.05), '$999.99') AS "New Rent"
FROM Movie NATURAL JOIN Rating
ORDER BY RatingType, Name;

-- Question 5
SELECT Name, 
  TO_CHAR((RentalAmount - DistributionCost) / DistributionCost * 100, '999.9') AS "Profit %",
  COUNT(AgreementID) AS Rented
FROM Movie NATURAL JOIN MovieRented
WHERE (RentalAmount - DistributionCost) / DistributionCost * 100 < 100
GROUP BY (Name, TO_CHAR((RentalAmount - DistributionCost) / DistributionCost * 100, '999.9'))
ORDER BY "Profit %" DESC
;

-- Question 6
--    A)
SELECT Name, ROUND(MONTHS_BETWEEN(CURRENT_DATE, MAX(AgreementDate))) AS MonthsAgo
FROM Movie NATURAL JOIN MovieRented NATURAL JOIN RentalAgreement 
GROUP BY (Name)
ORDER BY MonthsAgo DESC
;

--    B)
SELECT Next_Day(current_date, 'Tuesday')
FROM Dual;

--    C)
SELECT Min(LENGTH(Name)) AS "MIN Length"
FROM Movie;

SELECT MAX(LENGTH(Name)) AS "MAX Length"
FROM Movie;

SELECT AVG(LENGTH(Name)) AS "AVG Length"
FROM Movie;

-- Question 7 
SELECT TO_CHAR(AVG(SUM(RentalAmount)), '$9.99') AS "Average"
FROM RentalAgreement NATURAL JOIN MovieRented
GROUP BY (AgreementID);

-- Question 8 
SELECT REPLACE(Name, ': ', CHR(10)) || CHR(10) AS  "Movie"
FROM Movie
WHERE Name LIKE '%: %';

-- Question 9
SELECT CustID, FName, LName
FROM Customer
WHERE SOUNDEX(FName) = SOUNDEX('Allan');

-- Question 10
DROP MATERIALIZED VIEW TopMovie;
CREATE MATERIALIZED VIEW TopMovie
REFRESH COMPLETE
AS SELECT Name AS "The Movie", S.GenreType AS "In this genre...", S.Stars AS "Has Stars:"
FROM Movie NATURAL JOIN MovieGenre MG, (
  SELECT GenreID, GenreType, Max(Stars) AS Stars
  FROM Genre NATURAL JOIN MovieGenre NATURAL JOIN Movie
  GROUP BY (GenreID, GenreType)) S
WHERE Movie.Stars = S.Stars
AND MG.GenreID = S.GenreID
ORDER BY GenreType;

select * from topMovie;