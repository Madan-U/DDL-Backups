-- Object: PROCEDURE dbo.V2_Frag_Query
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc V2_Frag_Query  
as    
    
    
/*Perform a 'USE <database name>' to select the database in which to run the script.*/    
-- Declare variables    
SET NOCOUNT ON    
DECLARE @tablename VARCHAR (128)    
DECLARE @execstr   VARCHAR (255)    
DECLARE @objectid  INT    
DECLARE @indexid   INT    
DECLARE @frag      DECIMAL    
DECLARE @maxfrag   DECIMAL    
    
-- Decide on the maximum fragmentation to allow    
SELECT @maxfrag = 30.0    
    
-- Declare cursor    
DECLARE tables CURSOR FOR    
   SELECT TABLE_NAME    
   FROM INFORMATION_SCHEMA.TABLES    
   WHERE TABLE_TYPE = 'BASE TABLE'    
   and TABLE_NAME IN (Select Table_Name from V2_Defrag_Tables where CheckFlag = 1)  
    
    
-- Create the table    
CREATE TABLE #fraglist (    
   ObjectName CHAR (255),    
   ObjectId INT,    
   IndexName CHAR (255),    
   IndexId INT,    
   Lvl INT,    
   CountPages INT,    
   CountRows INT,    
   MinRecSize INT,    
   MaxRecSize INT,    
   AvgRecSize INT,    
   ForRecCount INT,    
   Extents INT,    
   ExtentSwitches INT,    
   AvgFreeBytes INT,    
   AvgPageDensity INT,    
   ScanDensity DECIMAL,    
   BestCount INT,    
   ActualCount INT,    
   LogicalFrag DECIMAL,    
   ExtentFrag DECIMAL)    
    
-- Open the cursor    
OPEN tables    
    
-- Loop through all the tables in the database    
FETCH NEXT    
   FROM tables    
   INTO @tablename    
    
WHILE @@FETCH_STATUS = 0    
BEGIN    
-- Do the showcontig of all indexes of the table    
   INSERT INTO #fraglist     
   EXEC ('DBCC SHOWCONTIG (''' + @tablename + ''')     
      WITH FAST, TABLERESULTS, ALL_INDEXES, NO_INFOMSGS')    
   FETCH NEXT    
      FROM tables    
      INTO @tablename    
END    
    
-- Close and deallocate the cursor    
CLOSE tables    
DEALLOCATE tables    
   SELECT ObjectName, ObjectId, IndexId, IndexName,  LogicalFrag    
   FROM #fraglist    
   WHERE INDEXPROPERTY (ObjectId, IndexName, 'IndexDepth') > 0    
  
DROP TABLE #fraglist

GO
