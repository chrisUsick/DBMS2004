SET SERVEROUTPUT ON SIZE 10000 FORMAT TRUNCATED;
-- Extract All tables in the schema 
CREATE OR REPLACE PROCEDURE Extract_Tables
AS
  cTITLE CONSTANT VARCHAR2(100) := '---- Oracle Catalog Extract Utility V1.0 ----';
  cBLANK CONSTANT VARCHAR(100) := '----';
  
  -- used to get the length of the create statement
  wCreateStatement VARCHAR2(100);
  
  CURSOR tables IS 
  SELECT table_name 
  FROM User_Tables
	WHERE table_name NOT LIKE 'BIN%'
  ORDER BY table_name;
  
  wTable tables%ROWTYPE;
	
	-- exception type 
	INVALID_COLUMN_TYPE EXCEPTION;
	PRAGMA EXCEPTION_INIT(INVALID_COLUMN_TYPE, -20100);
BEGIN
  -- initial output
  DBMS_OUTPUT.PUT_LINE(cTITLE);
  DBMS_OUTPUT.PUT_LINE(cBLANK);
  DBMS_OUTPUT.PUT_LINE(Run_On('Run on '));
  DBMS_OUTPUT.PUT_LINE(cBLANK);
  DBMS_OUTPUT.PUT_LINE('---- S T A R T I N G  T A B L E  D R O P S');
  DBMS_OUTPUT.PUT_LINE(cBLANK);
  
  -- show drop table statements
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
    
    -- extract columns
		BEGIN -- catch exceptions thrown by extract columns
			Extract_Columns(wTable.table_name);
			
			-- extract constraints
			Extract_PK_Constraint(wTable.table_name);
			Extract_Unique_Constraint(wTable.table_name);
			EXCEPTION
				WHEN INVALID_COLUMN_TYPE THEN
					DBMS_OUTPUT.PUT_LINE('==========================================================================');
					DBMS_OUTPUT.PUT_LINE('=== EXCEPTION ' || SQLCODE || ' Raised - ORA-20100: *** ' || SQLERRM || ' ***');
					DBMS_OUTPUT.PUT_LINE('=== Unable to complete table generation for ' || wTable.table_name);
					DBMS_OUTPUT.PUT_LINE('==========================================================================');
		END;
    
    -- add the closing parenthesis
    DBMS_OUTPUT.PUT_LINE(
      LPAD(' ',LENGTH(wCreateStatement)) || 
      '); -- End of table ' || wTable.table_name ||' creation' );
    DBMS_OUTPUT.PUT_LINE('--' || CHR(10) || '--');
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE(cBLANK || ' T A B L E  C R E A T E  C O M P L E T E D ');
  DBMS_OUTPUT.PUT_LINE(cBLANK);
  DBMS_OUTPUT.PUT_LINE(cTITLE);
  DBMS_OUTPUT.PUT_LINE(Run_On('Run completed on '));
  
  
END;
/
exec extract_tables;
exec extract_pk_constraint('PRODUCTS');
-- Extract primary key constraint for a given table
CREATE OR REPLACE PROCEDURE Extract_PK_Constraint (
  iTableName IN VARCHAR2)
AS
  wOutput VARCHAR2(200) := '';
BEGIN
	wOutput := Extract_Constraint(iTableName, 'P', 'PRIMARY KEY');
	DBMS_OUTPUT.PUT_LINE(wOutput);
	
END;
/

exec Extract_Unique_Constraint('PRODUCTS');
-- Extract unique constraint(s) for a given table
CREATE OR REPLACE PROCEDURE Extract_Unique_Constraint (
  iTableName IN VARCHAR2)
AS
  wOutput VARCHAR2(200) := '';
BEGIN
	wOutput := Extract_Constraint(iTableName, 'U', 'UNIQUE');
	DBMS_OUTPUT.PUT_LINE(wOutput);
	
END;
/

-- Extract unique constraint(s) for a given table
CREATE OR REPLACE PROCEDURE Extract_Check_Constraint (
  iTableName IN VARCHAR2)
AS
	wConstraintName VARCHAR2(50);
	wSearchCondition VARCHAR2(10000);
	wOutput VARCHAR2(10000) := '';
	wSearchCast VARCHAR2(10000);
BEGIN
	OPEN Consts;
	LOOP 
		FETCH Consts INTO wConstraintName, wSearchCondition;
		EXIT WHEN Consts%NOTFOUND;
		wSearchCondition := wSearchCondition;
		wSearchCast := wSearchCondition || ' ';
		
		wOutput := wOutput || '  , CONSTRAINT ' || 
							wConstraintName || CHR(10) || '       ' || 
							iTypeText || ' (';
		DBMS_OUTPUT.PUT_LINE(wSearchCast);
	END LOOP;
	
END;
/

exec Extract_Check_Constraint('PRODUCTS');
CREATE OR REPLACE FUNCTION Extract_Constraint (
	iTableName IN VARCHAR2, 
	iConstraintType IN VARCHAR2, 
	iTypeText IN VARCHAR2) RETURN VARCHAR2
AS
	wFirstColumn NUMBER(1) := 0;
	wOutput VARCHAR2(10000) := '';
BEGIN
	FOR wConst IN (
		SELECT Constraint_Name
		FROM User_Constraints
		WHERE Table_Name = iTableName 
		AND Constraint_Type = iConstraintType
	) LOOP
		
		wOutput := wOutput || '  , CONSTRAINT ' || 
							wConst.Constraint_Name || CHR(10) || '       ' || 
							iTypeText || ' (';
							
		wFirstColumn := 0;
		IF (iConstraintType = 'C') THEN 
			wOutput := wOutput || ' '; --wSearchCondition;
		ELSE
			FOR wColumn IN (
				SELECT Column_Name
				FROM User_Cons_Columns
				WHERE Table_Name = iTableName
				AND Constraint_Name = wConst.Constraint_Name
			) LOOP 
				IF wFirstColumn = 0 THEN
					wFirstColumn := 1;
					wOutput := wOutput || wColumn.Column_Name;
				ELSE 
					wOutput := wOutput || ', ' || wColumn.Column_Name;
				END IF;
			END LOOP;
			
		END IF;
		wOutput := wOutput || ')' || CHR(10);
	END LOOP;
	
	RETURN SUBSTR(wOutput, 0, LENGTH(wOutput) - 1);
END;
/

-- Create and output all the drop tables statements for all tables in schema
CREATE OR REPLACE PROCEDURE Drop_Tables 
AS
  CURSOR tables IS 
  SELECT table_name 
  FROM User_Tables
	WHERE table_name NOT LIKE 'BIN%'
  ORDER BY table_name;
  
  wTable tables%ROWTYPE;
BEGIN
  FOR wTable IN tables LOOP
    DBMS_OUTPUT.PUT_LINE('DROP TABLE ' || wTable.table_name || ';');
  END LOOP;
END;
/

-- Extract columns for a given table
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
  wNotNull VARCHAR2(10) := '          ';
  wDefault VARCHAR2(50);
  
BEGIN
  
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
    
    -- add the datatype
    wDataType := '(';
    IF wColumn.Data_Precision IS NOT NULL THEN
      wDataType := wDataType || 
                wColumn.Data_Precision || ', ' || 
                wColumn.Data_Scale || ')';
    ELSE
      wDataType := wDataType || 
                wColumn.Data_Length || ')';
    END IF;
    
    -- add the not null statement
    IF wColumn.Nullable = 'N' THEN
      wNotNull := 'NOT NULL';
    ELSE
      wNotNull :='          ';
    END IF;
    
    -- add the default value, if any
    IF wColumn.Data_Default IS NOT NULL THEN
      wDefault := 'DEFAULT ';
      wDefault := wDefault || TRIM(REPLACE(TO_CHAR(wColumn.Data_Default), CHR(10), ' '));
    ELSE 
      wDefault := '';
    END IF;
    
    -- build the output string
    wOutput :=  wOutput || RPAD(wColumn.Column_Name, 20);
    IF (wColumn.Data_Type LIKE '%CHAR%'
        OR wColumn.Data_Type LIKE '%DATE%'
        OR wColumn.Data_Type LIKE '%VARCHAR2%'
        OR wColumn.Data_Type LIKE '%NUMBER%') THEN
      wOutput :=  wOutput || 
            RPAD(wColumn.Data_Type || wDataType, 20) || 
            RPAD(wNotNull, 9) ||
            wDefault
            ;
    ELSE
			-- throw error
			RAISE_APPLICATION_ERROR(-20100, 'Unknown data type: ' || wColumn.Data_Type);
    END IF;
    -- ouput the output string
    DBMS_OUTPUT.PUT_LINE('  ' || wOutput);
  END LOOP;
  CLOSE Cols;
END;
/

exec extract_tables;

-- Function to create the `run on` statements
-- takes a message to prepend to the output 
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

