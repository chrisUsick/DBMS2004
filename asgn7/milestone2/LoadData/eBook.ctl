LOAD DATA
INFILE eBook.csv
APPEND INTO TABLE eBook
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY "'"
(BookID, ISBN, Title, Publisher, Published, NoOfPages, RentalCost)