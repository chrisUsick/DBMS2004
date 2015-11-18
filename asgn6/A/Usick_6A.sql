SET SERVEROUTPUT ON SIZE 10000;
CREATE OR REPLACE PROCEDURE Extract_Tables
AS
  cTITLE CONSTANT VARCHAR2(100) := '---- Oracle Catalog Extract Utility V1.0 ----';
  cBLANK CONSTANT VARCHAR(100) := '----';
  
  -- used to get the length of the create statement
  wCreateStatement VARCHAR2(100);
  
  CURSOR tables IS 
  SELECT table_name 
  FROM User_Tables
  ORDER BY table_name;
  
  wTable tables%ROWTYPE;
BEGIN
  
  DBMS_OUTPUT.PUT_LINE(cTITLE);
  DBMS_OUTPUT.PUT_LINE(cBLANK);
  DBMS_OUTPUT.PUT_LINE(Run_On('Run on '));
  DBMS_OUTPUT.PUT_LINE(cBLANK);
  
  -- Analyze each table
  FOR wTable IN Tables LOOP
    DBMS_OUTPUT.PUT_LINE('-- Start extracting table ' || wTable.table_name);
    wCreateStatement := 'CREATE TABLE ' || wTable.table_name || ' (';
    
    DBMS_OUTPUT.PUT_LINE(wCreateStatement);
    Extract_Columns(wTable.table_name);
    DBMS_OUTPUT.PUT_LINE(
      LPAD(' ',LENGTH(wCreateStatement)) || --|| 'y ');
      '); -- End of table ' || wTable.table_name ||' creation' );
    DBMS_OUTPUT.PUT_LINE('--' || CHR(10) || '--');
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE(cTITLE);
  DBMS_OUTPUT.PUT_LINE(Run_On('Run completed on '));
  
  
END;
/

EXEC EXTRACT_TABLES;

CREATE OR REPLACE PROCEDURE Extract_Columns (
  iTableName IN VARCHAR2)
AS
  CURSOR Cols IS 
  SELECT Column_Name
  FROM User_Tab_Columns
  WHERE Table_Name = iTableName
  ORDER BY Column_ID;
  
  wColumnName User_Tab_Columns.Column_Name%TYPE;
  wColumn VARCHAR2(50) := '';
  wOutput User_Tab_Columns.Column_Name%TYPE := '  ';
  
  -- total columns
  cColCount NUMBER;
  
BEGIN
  SELECT COUNT(Column_Name) 
  INTO cColCount
  FROM User_Tab_Columns
  WHERE Table_Name = iTableName;
  
  OPEN Cols;
  LOOP
    -- add comma if the current row isn't the last row
    IF NOT (Cols%ROWCOUNT = 0) THEN
      wOutput :=  ', ';
    END IF;
    FETCH Cols INTO wColumnName;
    EXIT WHEN (Cols%NOTFOUND);
    wOutput :=  wOutput || wColumnName;
    
    
    DBMS_OUTPUT.PUT_LINE('  ' || wOutput);
  END LOOP;
  CLOSE Cols;
END;
/

CREATE OR REPLACE FUNCTION Run_On (
    iStartText IN VARCHAR2
  )
   RETURN VARCHAR2 
   AS return_val VARCHAR2(100);
BEGIN 
   SELECT '-- ' || iStartText || TO_CHAR(SYSDATE, 'Mon DD, YYYY "at" HH:MI')
   INTO return_val
   FROM Dual;
   RETURN(return_val); 
 END;
/

