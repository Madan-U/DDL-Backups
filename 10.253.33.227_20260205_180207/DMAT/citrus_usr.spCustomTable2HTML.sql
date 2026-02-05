-- Object: PROCEDURE citrus_usr.spCustomTable2HTML
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

    
    
CREATE PROCEDURE [citrus_usr].[spCustomTable2HTML] (    
@TABLENAME  NVARCHAR(MAX),    
@OUTPUT   NVARCHAR(MAX) OUTPUT,    
@TBL_STYLE NVARCHAR(1024) = '',    
@HDR_STYLE NVARCHAR(1024) = '')    
AS    
    
    
-- Author:  Ian Atkin (ian.atkin@ict.ox.ac.uk)    
    
-- Description     
--    Stored Procedure to take an arbitraty temporary table and return     
--    the equivalent HTML string .    
    
-- Version History    
--   1.0 - Initial Release For Symantec Connect (Sept 2011)    
    
    
    
-- @exec_str stores the dynamic SQL Query    
-- @ParmDefinition stores the parameter definition for the dynamic SQL    
DECLARE @exec_str  NVARCHAR(MAX)    
DECLARE @ParmDefinition NVARCHAR(500)    
    
    
--We need to use Dynamic SQL at this point so we can expand the input table name parameter    
SET @exec_str= N'    
DECLARE @exec_str  NVARCHAR(MAX)    
DECLARE @ParmDefinition NVARCHAR(500)    
    
--Make a copy of the original table adding an indexing columnWe need to add an index column to the table to facilitate sorting so we can maintain the    
--original table order as we iterate through adding HTML tags to the table fields.    
--New column called CustColHTML_ID (unlikely to be used by someone else!)    
--    
    
select CustColHTML_ID=0,* INTO #CustomTable2HTML FROM (' + @TABLENAME + ') A     
    
--Now alter the table to add the auto-incrementing index. This will facilitate row finding    
DECLARE @COUNTER INT    
SET @COUNTER=0    
UPDATE #CustomTable2HTML SET @COUNTER = CustColHTML_ID=@COUNTER+1     
    
-- @HTMLROWS will store all the rows in HTML format    
-- @ROW will store each HTML row as fields on each row are iterated through     
-- using dymamic SQL and a cursor    
-- @FIELDS will store the header row for the HTML Table    
    
DECLARE @HTMLROWS NVARCHAR(MAX) DECLARE @FIELDS NVARCHAR(MAX)     
SET @HTMLROWS='''' DECLARE @ROW NVARCHAR(MAX)     
    
-- Create the first HTML row for the table (the table header). Ignore our indexing column!    
SET @FIELDS=''<tr ' + @HDR_STYLE + '>''    
SELECT @FIELDS=COALESCE(@FIELDS, '' '','''')+''<td>'' + name + ''</td>''    
FROM tempdb.sys.Columns    
WHERE object_id=object_id(''tempdb..#CustomTable2HTML'')    
AND name not like ''CustColHTML_ID''    
SET @FIELDS=@FIELDS + ''</tr>''    
    
-- @ColumnName stores the column name as found by the table cursor    
-- @maxrows is a count of the rows in the table, and @rownum is for marking the    
-- ''current'' row whilst processing    
    
DECLARE @ColumnName  NVARCHAR(500)    
DECLARE @maxrows INT    
DECLARE @rownum INT    
    
--Find row count of our temporary table    
SELECT @maxrows=count(*) FROM  #CustomTable2HTML    
    
    
--Create a cursor which will look through all the column names specified in the temporary table    
--but exclude the index column we added (CustColHTML_ID)    
DECLARE col CURSOR FOR    
SELECT name FROM tempdb.sys.Columns    
WHERE object_id=object_id(''tempdb..#CustomTable2HTML'')    
AND name not like ''CustColHTML_ID''    
ORDER BY column_id ASC    
    
--For each row, generate dymanic SQL which requests the each column name in turn by     
--iterating through a cursor    
SET @rowNum=0    
SET @ParmDefinition=N''@ROWOUT NVARCHAR(MAX) OUTPUT,@rowNum_IN INT''    
    
While @rowNum < @maxrows    
BEGIN    
  SET @HTMLROWS=@HTMLROWS + ''<tr>''    
    
  SET @rowNum=@rowNum +1    
  OPEN col    
  FETCH NEXT FROM col INTO @ColumnName    
  WHILE @@FETCH_STATUS=0    
    BEGIN    
      --Get nth row from table    
      --SET @exec_str=''SELECT @ROWOUT=(select top 1 ['' + @ColumnName + ''] from (select top '' + cast(@rownum as varchar) + '' * from #CustomTable2HTML order by CustColHTML_ID ASC) xxx order by CustColHTML_ID DESC)''    
      SET @exec_str=''SELECT @ROWOUT=(select ['' + @ColumnName + ''] from #CustomTable2HTML where CustColHTML_ID=@rowNum_IN)''    
    
   EXEC sp_executesql     
   @exec_str,    
   @ParmDefinition,    
   @ROWOUT=@ROW OUTPUT,    
            @rowNum_IN=@rownum    
    
      SET @HTMLROWS =@HTMLROWS +  ''<td>'' + @ROW + ''</td>''    
      FETCH NEXT FROM col INTO @ColumnName    
    END    
  CLOSE col    
  SET @HTMLROWS=@HTMLROWS + ''</tr>''    
END    
    
SET @OUTPUT=''''    
IF @maxrows>0    
SET @OUTPUT= ''<table ' + @TBL_STYLE + '>'' + @FIELDS + @HTMLROWS + ''</table>''    
    
DEALLOCATE col    
'    
    
DECLARE @ParamDefinition nvarchar(max)    
SET @ParamDefinition=N'@OUTPUT NVARCHAR(MAX) OUTPUT'    
    
--PRINT @exec_str    
--Execute Dynamic SQL. HTML table is stored in @OUTPUT which is passed back up (as it's    
--a parameter to this SP)    
EXEC sp_executesql @exec_str,    
@ParamDefinition,    
@OUTPUT=@OUTPUT OUTPUT    
    
RETURN 1

GO
