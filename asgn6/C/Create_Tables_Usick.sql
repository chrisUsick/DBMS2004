---- Oracle Catalog Extract Utility V1.0 ----                                   
----                                                                            
-- Run on Nov 23, 2015 at 08:47                                                 
----                                                                            
---- S T A R T I N G  T A B L E  D R O P S                                      
----                                                                            
DROP TABLE IMAGE;                                                               
DROP TABLE ORDERS;                                                              
DROP TABLE PRODUCTS;                                                            
----                                                                            
---- T A B L E  D R O P S  C O M P L E T E D                                    
----                                                                            
----                                                                            
---- S T A R T I N G  T A B L E  C R E A T E                                    
----                                                                            
-- Start extracting table IMAGE                                                 
CREATE TABLE IMAGE (                                                            
    MFR                 CHAR(3)             NOT NULL                            
  , PRODUCT             CHAR(5)             NOT NULL                            
  , IMAGE               BLOB(4000)                                              
                    ); -- End of table IMAGE creation                           
--
--                                                                           
-- Start extracting table ORDERS                                                
CREATE TABLE ORDERS (                                                           
    ORDERNUM            NUMBER(7, 0)        NOT NULL                            
  , ORDERDATE           DATE(7)                      DEFAULT CURRENT_DATE       
  , CUST                NUMBER(3, 0)                                            
  , REP                 NUMBER(3, 0)                                            
  , MANUF               CHAR(3)                                                 
  , PROD                CHAR(5)                                                 
  , QTY                 NUMBER(5, 0)                                            
  , AMOUNT              NUMBER(5, 2)                                            
                     ); -- End of table ORDERS creation                         
--
--                                                                           
-- Start extracting table PRODUCTS                                              
CREATE TABLE PRODUCTS (                                                         
    MFR                 CHAR(3)             NOT NULL                            
  , PRODUCT             CHAR(5)             NOT NULL                            
  , DESCRIPTION         VARCHAR2(100)                DEFAULT 'N/A'              
  , PRICE               NUMBER(5, 2)                                            
  , QTYONHAND           NUMBER(5, 0)                 DEFAULT 0                  
                       ); -- End of table PRODUCTS creation                     
--
--                                                                           
---- T A B L E  C R E A T E  C O M P L E T E D                                  
----                                                                            
---- Oracle Catalog Extract Utility V1.0 ----                                   
-- Run completed on Nov 23, 2015 at 08:47                                       
