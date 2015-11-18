---- Oracle Catalog Extract Utility V1.0 ----                                   
----                                                                            
-- Run on Nov 16, 2015 at 12:27                                                 
----                                                                            
-- Start extracting table TOPMOVIE                                              
CREATE TABLE TOPMOVIE (                                                         
    The Movie                                                                   
  , In this genre...                                                            
  , Has Stars:                                                                  
                       ); -- End of table TOPMOVIE creation                     
--
--                                                                           
-- Start extracting table MOVIE                                                 
CREATE TABLE MOVIE (                                                            
    MOVIEID                                                                     
  , NAME                                                                        
  , RELEASED                                                                    
  , DISTRIBUTIONCOST                                                            
  , RENTALAMOUNT                                                                
  , STARS                                                                       
  , RATINGID                                                                    
                    ); -- End of table MOVIE creation                           
--
--                                                                           
-- Start extracting table DISTRIBUTOR                                           
CREATE TABLE DISTRIBUTOR (                                                      
    DISTRIBUTORID                                                               
  , DISTRIBUTORNAME                                                             
                          ); -- End of table DISTRIBUTOR creation               
--
--                                                                           
-- Start extracting table CONTRIBUTOR                                           
CREATE TABLE CONTRIBUTOR (                                                      
    CONTRIBUTORID                                                               
  , FNAME                                                                       
  , MNAME                                                                       
  , LNAME                                                                       
  , MUSICALGROUP                                                                
                          ); -- End of table CONTRIBUTOR creation               
--
--                                                                           
-- Start extracting table CUSTOMER                                              
CREATE TABLE CUSTOMER (                                                         
    CUSTID                                                                      
  , FNAME                                                                       
  , LNAME                                                                       
  , STREETNO                                                                    
  , STREET                                                                      
  , CITY                                                                        
  , PROVINCE                                                                    
  , PCODE                                                                       
  , PRIMARYCUSTID                                                               
                       ); -- End of table CUSTOMER creation                     
--
--                                                                           
-- Start extracting table GENRE                                                 
CREATE TABLE GENRE (                                                            
    GENREID                                                                     
  , GENRETYPE                                                                   
                    ); -- End of table GENRE creation                           
--
--                                                                           
-- Start extracting table RATING                                                
CREATE TABLE RATING (                                                           
    RATINGID                                                                    
  , RATINGTYPE                                                                  
  , DESCRIPTION                                                                 
                     ); -- End of table RATING creation                         
--
--                                                                           
-- Start extracting table ORDERS                                                
CREATE TABLE ORDERS (                                                           
    ORDERNUM                                                                    
  , ORDERCHAR                                                                   
  , CUST                                                                        
  , REP                                                                         
  , MANUF                                                                       
  , PROD                                                                        
  , QTY                                                                         
  , AMOUNT                                                                      
                     ); -- End of table ORDERS creation                         
--
--                                                                           
-- Start extracting table PRODUCTS                                              
CREATE TABLE PRODUCTS (                                                         
    MFR                                                                         
  , PRODUCT                                                                     
  , DESCRIPTION                                                                 
  , PRICE                                                                       
  , QTYONHAND                                                                   
                       ); -- End of table PRODUCTS creation                     
--
--                                                                           
-- Start extracting table VOLUMEPROMOTION                                       
CREATE TABLE VOLUMEPROMOTION (                                                  
    MINMOVIES                                                                   
  , MAXMOVIES                                                                   
  , DURATION                                                                    
  , PERCENTREDUCTION                                                            
                              ); -- End of table VOLUMEPROMOTION creation       
--
--                                                                           
-- Start extracting table VALIDDURATION                                         
CREATE TABLE VALIDDURATION (                                                    
    DURATIONID                                                                  
  , NAME                                                                        
  , DURATION                                                                    
                            ); -- End of table VALIDDURATION creation           
--
--                                                                           
-- Start extracting table RENTALAGREEMENT                                       
CREATE TABLE RENTALAGREEMENT (                                                  
    AGREEMENTID                                                                 
  , CUSTID                                                                      
  , AGREEMENTDATE                                                               
  , MOVIECOUNT                                                                  
  , DURATIONID                                                                  
                              ); -- End of table RENTALAGREEMENT creation       
--
--                                                                           
-- Start extracting table TOPMOVIES                                             
CREATE TABLE TOPMOVIES (                                                        
    NAME                                                                        
  , GENRETYPE                                                                   
  , STARS                                                                       
                        ); -- End of table TOPMOVIES creation                   
--
--                                                                           
-- Start extracting table SONGPERFORMER                                         
CREATE TABLE SONGPERFORMER (                                                    
    SONGID                                                                      
  , CONTRIBUTORID                                                               
  , FEATURED                                                                    
                            ); -- End of table SONGPERFORMER creation           
--
--                                                                           
-- Start extracting table SONGAUTHOR                                            
CREATE TABLE SONGAUTHOR (                                                       
    SONGID                                                                      
  , CONTRIBUTORID                                                               
                         ); -- End of table SONGAUTHOR creation                 
--
--                                                                           
-- Start extracting table MOVIERENTED                                           
CREATE TABLE MOVIERENTED (                                                      
    MOVIEID                                                                     
  , AGREEMENTID                                                                 
  , RENTALAMOUNT                                                                
  , PERCENTREDUCTIONAPPLIED                                                     
                          ); -- End of table MOVIERENTED creation               
--
--                                                                           
-- Start extracting table MOVIESONG                                             
CREATE TABLE MOVIESONG (                                                        
    MOVIEID                                                                     
  , SONGID                                                                      
                        ); -- End of table MOVIESONG creation                   
--
--                                                                           
-- Start extracting table MOVIEGENRE                                            
CREATE TABLE MOVIEGENRE (                                                       
    MOVIEID                                                                     
  , GENREID                                                                     
                         ); -- End of table MOVIEGENRE creation                 
--
--                                                                           
-- Start extracting table INDEXEXAMPLE                                          
CREATE TABLE INDEXEXAMPLE (                                                     
    KEYVALUE                                                                    
                           ); -- End of table INDEXEXAMPLE creation             
--
--                                                                           
---- Oracle Catalog Extract Utility V1.0 ----                                   
-- Run completed on Nov 16, 2015 at 12:27                                       

PL/SQL procedure successfully completed.

