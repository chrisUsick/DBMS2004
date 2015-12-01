---- Oracle Catalog Extract Utility V4.0 ----                                   
----                                                                            
---- Run on Nov 30, 2015 at 01:10                                               
----                                                                            
---- S T A R T I N G  T A B L E  D R O P S                                      
----                                                                            
DROP TABLE IMAGE;                                                               
DROP TABLE ORDERDETAILS;                                                        
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
==========================================================================      
=== EXCEPTION -20100 Raised - ORA-20100: *** ORA-20100: Unknown data type: BLOB 
=== Unable to complete table generation for IMAGE                               
==========================================================================      
                    ); -- End of table IMAGE creation                           
--
--                                                                           
-- Start extracting table ORDERDETAILS                                          
CREATE TABLE ORDERDETAILS (                                                     
    ORDERNUM            NUMBER(7, 0)        NOT NULL                            
  , DETAILNUM           NUMBER(7, 0)        NOT NULL                            
  , MANUF               CHAR(3)             NOT NULL                            
  , PROD                CHAR(5)             NOT NULL                            
  , QTY                 NUMBER(5, 0)        NOT NULL                            
  , AMOUNT              NUMBER(5, 2)        NOT NULL                            
-- *** WARNING *** No Primary Key Defined                                       
                           ); -- End of table ORDERDETAILS creation             
--
--                                                                           
-- Start extracting table ORDERS                                                
CREATE TABLE ORDERS (                                                           
    ORDERNUM            NUMBER(7, 0)        NOT NULL                            
  , ORDERDATE           DATE(7)                      DEFAULT CURRENT_DATE       
  , CUST                NUMBER(3, 0)                                            
  , REP                 NUMBER(3, 0)                                            
  , CONSTRAINT ORDERSPK
       PRIMARY KEY (ORDERNUM)                           
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
  , CONSTRAINT PRODUCTSPK
       PRIMARY KEY (MFR, PRODUCT)                     
  , CONSTRAINT UNIQUEDESCRIPTION
       UNIQUE (DESCRIPTION)
  , CONSTRAINT UNIQ
  , CONSTRAINT CHECKPRICE                                                       
       CHECK (Price BETWEEN .01 AND 87.98)                                      
  , CONSTRAINT CHECKQUANTITY                                                    
       CHECK (QtyOnHand >= 0)                                                   
                       ); -- End of table PRODUCTS creation                     
--
--                                                                           
---- T A B L E  C R E A T E  C O M P L E T E D                                  
----                                                                            
----                                                                            
---- S T A R T I N G	 T A B L E  A L T E R                                      
----                                                                            
--                                                                              
--                                                                              
-- Start Alter of table ORDERDETAILS                                            
ALTER TABLE ORDERDETAILS                                                        
    ADD CONSTRAINT COMPRISEFK                                                   
        FORGEIGN KEY (MANUF, PROD)                                              
        REFERENCES PRODUCTS                                                     
        ON DELETE NO ACTION;                                                    
--                                                                              
ALTER TABLE ORDERDETAILS                                                        
    ADD CONSTRAINT BELONGSFK                                                    
        FORGEIGN KEY (ORDERNUM)                                                 
        REFERENCES ORDERS                                                       
        ON DELETE CASCADE;                                                      
--                                                                              
-- End of Alter Table ORDERDETAILS                                              
----                                                                            
---- T A B L E  A L T E R  C O M P L E T E D                                    
----                                                                            
---- Oracle Catalog Extract Utility V4.0 ----                                   
---- Run completed on Nov 30, 2015 at 01:10                                     
