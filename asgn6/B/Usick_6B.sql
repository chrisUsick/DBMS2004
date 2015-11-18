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
  DBMS_OUTPUT.PUT_LINE('---- S T A R T I N G  T A B L E  D R O P S');
  DBMS_OUTPUT.PUT_LINE(cBLANK);
  Drop_Tables;
  DBMS_OUTPUT.PUT_LINE(cBLANK);
  DBMS_OUTPUT.PUT_LINE(cBLANK || ' T A B L E  D R O P S  C O M P L E T E D ');
  DBMS_OUTPUT.PUT_LINE(cBLANK);
  DBMS_OUTPUT.PUT_LINE(cBLANK);
  DBMS_OUTPUT.PUT_LINE(cBLANK || ' S T A R T I N G  T A B L E  C R E A T E ');
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
  
  DBMS_OUTPUT.PUT_LINE(cBLANK || ' T A B L E  C R E A T E  C O M P L E T E D ');
  DBMS_OUTPUT.PUT_LINE(cBLANK);
  DBMS_OUTPUT.PUT_LINE(cTITLE);
  DBMS_OUTPUT.PUT_LINE(Run_On('Run completed on '));
  
  
END;
/
EXEC EXTRACT_TABLES;

CREATE OR REPLACE PROCEDURE Drop_Tables 
AS
  CURSOR tables IS 
  SELECT table_name 
  FROM User_Tables
  ORDER BY table_name;
  
  wTable tables%ROWTYPE;
BEGIN
  FOR wTable IN tables LOOP
    DBMS_OUTPUT.PUT_LINE('DROP TABLE ' || wTable.table_name || ';');
  END LOOP;
END;
/


CREATE OR REPLACE PROCEDURE Extract_Columns (
  iTableName IN VARCHAR2)
AS
  CURSOR Cols IS 
  SELECT Column_Name, Data_Type, Data_Length, Data_Precision, Data_Scale, Nullable, Data_Default
  FROM User_Tab_Columns
  WHERE Table_Name = iTableName
  ORDER BY Column_ID;
  
  wColumn Cols%ROWTYPE;
  wOutput VARCHAR2(120);
  wDataType VARCHAR2(30) := '(';
  wNotNull VARCHAR2(10) := '';
  wDefault VARCHAR2(50) := 'DEFAULT ';
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
    ELSE
      wOutput := '  ';
    END IF;
    FETCH Cols INTO wColumn;
    EXIT WHEN (Cols%NOTFOUND);
    
    wDataType := '(';
    IF wColumn.Data_Precision IS NOT NULL THEN
      wDataType := wDataType || 
                wColumn.Data_Precision || ', ' || 
                wColumn.Data_Scale || ')';
    ELSE
      wDataType := wDataType || 
                wColumn.Data_Length || ')';
    END IF;
    
    IF wColumn.Nullable = 'N' THEN
      wNotNull := 'NOT NULL';
    ELSE
      wNotNull :='';
    END IF;
    
    IF wColumn.Data_Default IS NOT NULL THEN
      wDefault := wDefault || TO_CHAR(wColumn.Data_Default);
    ELSE 
      wDefault := '';
    END IF;
    
    wOutput :=  wOutput || 
            RPAD(wColumn.Column_Name, 20) || 
            RPAD(wColumn.Data_Type || wDataType, 20) || 
            RPAD(wNotNull, 9) ||
            wDefault
            ;
    
    
    DBMS_OUTPUT.PUT_LINE('  ' || wOutput);
  END LOOP;
  CLOSE Cols;
END;
/
SHOW ERRORS;
exec extract_tables;

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

