-- Object: PROCEDURE dbo.CLS_PROC_F2CONFIG
-- Server: 10.253.33.91 | DB: PRADNYA
--------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 
CREATE PROC [dbo].[CLS_PROC_F2CONFIG]    
(    
  @F2CODE VARCHAR(10),          
  @F2PARAMS VARCHAR(500),          
  @F2WHFLDS VARCHAR(1000) = '',          
  @F2WHVALS VARCHAR(1000) = '',          
  @F2WHOPR VARCHAR(100) = '',          
  @USEXML BIT = 0,              
  @WINDOWTITLE VARCHAR(100) = '' OUTPUT,          
  @TABLEHEADER VARCHAR(200) = '' OUTPUT        
     
)    
AS    
--EXEC .dbo.PROC_F2CONFIG 'F000000002','IN','','','',0,'TITLE','TAB'    

--SELECT * FROM F2CONFIG   
/*
declare @p8 varchar(100)
set @p8='CODE'
declare @p9 varchar(200)
set @p9='CODE,DESCRIPTION'
exec Pradnya..CLS_F2CONFIG_WRAPPER @F2CODE='F000000077',@F2PARAMS='1|||T|%',@F2WHFLDS='EXCHANGE,',@F2WHVALS='NSE,',@F2WHOPR='=,',@ENTITY='',@ENTITY_LIST='',@WINDOWTITLE=@p8 output,@TABLEHEADER=@p9 output
select @p8, @p9



SELECT  DISTINCT CONVERT(VARCHAR,TABLE_NO)TABLE_NO,UPPER(TABLE_NAME) FROM Msajag..BRANCHBROKTABLE WHERE 1 = 1  AND TABLE_NO LIKE '1' + '%'  
AND EXCHANGE = 'NSE' + ''  
AND SEGMENT = 'CAPITAL' + ''  AND TABLE_TYPE = 'T' + ''  ORDER BY TABLE_NO

*/
 
SET NOCOUNT ON          
DECLARE          
 @OBJID INT,          
 @OBJNAME VARCHAR(256),          
 @OBJTYPE VARCHAR(1),          
 @DATABASENAME VARCHAR(256),          
 @PARAMFIELDS VARCHAR(500),          
 @OBJECTOUT VARCHAR(500),          
 @PARAMCUR CURSOR,          
 @PARAMPOS TINYINT,          
 @PARAMNAME VARCHAR(60),          
 @PARAMVAL VARCHAR(500),          
 @PARAMOPR VARCHAR(8),          
 @PARAMOPRLIST VARCHAR(100),          
 @ORDERLIST VARCHAR(100),          
 @CONNECTIONDB VARCHAR(1),          
 @SQL NVARCHAR(MAX),          
 @DBNAME VARCHAR(256),    
 @SCHEMA_NAME VARCHAR(50)    
 SET @SCHEMA_NAME = (SELECT SCHEMA_NAME())    
 SET @DBNAME = ''          
       
BEGIN TRY        
 SELECT          
  @OBJNAME = F2OBJECT,          
  @OBJTYPE = F2OBJECTTYPE,          
  @OBJECTOUT = ISNULL(F2OUTPUT, ''),          
  @PARAMFIELDS = ISNULL(F2PARAMFIELDS, ''),          
  @PARAMOPRLIST = ISNULL(F2OPRLIST, ''),          
  @ORDERLIST = ISNULL(F2ORDERLIST, ''),          
  @DATABASENAME = ISNULL(DATABASENAME, ''),          
  @WINDOWTITLE = ISNULL(WINDOWTITLE, 'HELP LIST'),          
  @TABLEHEADER = ISNULL(TABLEHEADER, ''),          
  @CONNECTIONDB = ISNULL(CONNECTIONDB, '')          
 FROM          
  CLS_F2CONFIG          
 WHERE          
  F2CODE = @F2CODE   
  
  
  
  IF @OBJTYPE = 'T' or @OBJTYPE = 'P'
  BEGIN
	  DECLARE
		@@PATIDX INT,
		@EXCHANGE VARCHAR(3),
		@SEGMENT VARCHAR(7)
	  
	  SELECT @@PATIDX = PATINDEX('%|FUTURES|%', @F2PARAMS)
	  
	  IF @@PATIDX > 0
	  BEGIN
		SELECT @SEGMENT = SUBSTRING (@F2PARAMS, PATINDEX('%|FUTURES|%', @F2PARAMS) + 1, 7)

		SELECT @EXCHANGE = SUBSTRING (@F2PARAMS, PATINDEX('%|FUTURES|%', @F2PARAMS) - 3, 3)
	  END
	  
	  IF @@PATIDX < 1
	  BEGIN
		  SELECT @@PATIDX = PATINDEX('%|CAPITAL|%', @F2PARAMS)
		  
		  IF @@PATIDX > 0
		  BEGIN
			SELECT @SEGMENT = SUBSTRING (@F2PARAMS, PATINDEX('%|CAPITAL|%', @F2PARAMS) + 1, 7)

			SELECT @EXCHANGE = SUBSTRING (@F2PARAMS, PATINDEX('%|CAPITAL|%', @F2PARAMS) - 3, 3)
		  END
		END
			
		  
		DECLARE @STRSHAREDB VARCHAR(30)
		SET @STRSHAREDB = ''
		SELECT TOP 1 @STRSHAREDB = SHAREDB FROM CLS_MULTICOMPANY (NOLOCK) 
		WHERE EXCHANGE =@EXCHANGE AND SEGMENT = @SEGMENT

		DECLARE @STRACCDB VARCHAR(30)
		SET @STRACCDB = ''
		SELECT TOP 1 @STRACCDB = AccountDb FROM CLS_MULTICOMPANY (NOLOCK) 
		WHERE EXCHANGE =@EXCHANGE AND SEGMENT = @SEGMENT


	END

IF @CONNECTIONDB = ''
	SET @DATABASENAME = @DATABASENAME
else IF @STRSHAREDB <> '' AND @CONNECTIONDB <> 'A'
    SET @DATABASENAME = @STRSHAREDB
ELSE IF @EXCHANGE <> '' AND @SEGMENT <> ''
	SET @DATABASENAME = @STRACCDB
 

 
 IF @OBJTYPE = 'T' OR @OBJTYPE = 'V'          
  BEGIN          
  
  -- SET @OBJNAME = @MULTISERVER + @OBJNAME          
   SET @SQL = "SELECT  " + @OBJECTOUT + " FROM "+ @DATABASENAME + ".." + @OBJNAME + " WHERE 1 = 1 "          
   IF LEN(@PARAMFIELDS) > 0          
    BEGIN          
     SET @PARAMPOS = 1          
     WHILE 1 = 1          
      BEGIN          
       SET @PARAMNAME = .dbo.CLS_Piece(@PARAMFIELDS, ',', @PARAMPOS)          
       IF @PARAMNAME = '' OR @PARAMNAME IS NULL          
        BEGIN          
					BREAK          
        END    
       SET @PARAMVAL = .dbo.CLS_Piece(@F2PARAMS, '|', @PARAMPOS)          
       SET @PARAMOPR = .dbo.CLS_Piece(@PARAMOPRLIST, ',', @PARAMPOS)          
       SET @SQL = @SQL + " AND " + @PARAMNAME + " " + (CASE WHEN @PARAMOPR = '' OR @PARAMOPR IS NULL THEN '=' ELSE @PARAMOPR END) + " '" + (CASE WHEN @PARAMVAL = '' OR @PARAMVAL IS NULL THEN CASE WHEN @PARAMOPR = 'LIKE' THEN '' ELSE '0' END ELSE @PARAMVAL END) + "' + '" + (CASE WHEN @PARAMOPR = 'LIKE' THEN '%' ELSE '' END) + "' "          
       SET @PARAMPOS = @PARAMPOS + 1          
      END          
    END          
   IF LEN(@F2WHFLDS) > 0          
    BEGIN   
     SET @PARAMPOS = 1          
     WHILE 1 = 1          
      BEGIN          
       SET @PARAMNAME = .dbo.CLS_Piece(@F2WHFLDS, ',', @PARAMPOS)       
			 IF @PARAMNAME IS NULL          
        BEGIN          
         BREAK          
        END          
       IF CHARINDEX('~',@PARAMNAME) > 0    
       BEGIN   
			 SET @PARAMNAME = REPLACE(@PARAMNAME, '~', ',')    
       END  
       SET @PARAMVAL = .dbo.CLS_Piece(@F2WHVALS, ',', @PARAMPOS)          
       SET @PARAMOPR = .dbo.CLS_Piece(@F2WHOPR, ',', @PARAMPOS)    
			 SET @SQL = @SQL + " AND " + @PARAMNAME + " " + (CASE WHEN @PARAMOPR = '' OR @PARAMOPR IS NULL THEN '=' ELSE CASE WHEN @PARAMOPR = 'NL' THEN ' NOT LIKE ' ELSE @PARAMOPR END END) + " '" + (CASE WHEN @PARAMVAL = '' OR @PARAMVAL IS NULL THEN CASE WHEN @PARAMOPR = 'LIKE' OR @PARAMOPR = 'NL' THEN '' ELSE '0' END ELSE @PARAMVAL END) + "' + '" + (CASE WHEN @PARAMOPR = 'LIKE' OR @PARAMOPR = 'NL' THEN '%' ELSE '' END) + "' "          
       SET @PARAMPOS = @PARAMPOS + 1          
      END          
    END          
   IF LEN(@ORDERLIST) > 0          
    BEGIN          
     SET @SQL = @SQL + " ORDER BY " + @ORDERLIST          
    END          
   ELSE          
    BEGIN          
     SET @SQL = @SQL + " ORDER BY 1 "          
    END          
   IF @USEXML = 1          
    BEGIN          
     SET @SQL = @SQL + " FOR XML AUTO "          
    END          
   PRINT @SQL          
   EXEC(@SQL)          
  END        
 ELSE IF @OBJTYPE = 'P'          
  BEGIN          
  print 'p'       
   CREATE TABLE #PARANAMES (PARANAME VARCHAR(256))          
   IF @DATABASENAME <> ''          
    BEGIN          
	 SET @SQL = "SELECT NAME INTO #PARAMTEMP FROM " + @DATABASENAME + "..SYSCOLUMNS WHERE ID = (SELECT ID FROM " + @DATABASENAME + "..SYSOBJECTS WHERE NAME = '" + @OBJNAME + "' AND XTYPE = 'P' AND USER_NAME(UID) = '" + @SCHEMA_NAME + "')   order by colorder"  		
     --SET @SQL = @SQL + " INSERT INTO #PARANAMES (PARANAME) SELECT NAME FROM " + @DATABASENAME + "..SYSCOLUMNS WHERE ID = (SELECT ID FROM " + @DATABASENAME + "..SYSOBJECTS WHERE NAME = '" + @OBJNAME + "' AND XTYPE = 'P' AND USER_NAME(UID) = '" + @SCHEMA_NAME + "')  "          
	 SET @SQL = @SQL + " INSERT INTO #PARANAMES (PARANAME) SELECT NAME FROM #PARAMTEMP "
     print @SQL        
     EXEC (@SQL)          
     SET @PARAMCUR = CURSOR FOR SELECT PARANAME FROM #PARANAMES          
    END   
   
   --ELSE          
   -- IF @MULTISERVER <> ''          
   --  BEGIN         
   --   SET @DATABASENAME = @MULTISERVER          
   --   SET @SQL = "INSERT INTO #PARANAMES (PARANAME) SELECT NAME FROM " + @MULTISERVER + "SYSCOLUMNS WHERE ID = (SELECT ID FROM " + @MULTISERVER + "SYSOBJECTS WHERE NAME = '" + @OBJNAME + "' AND XTYPE = 'P')"          
   --   --PRINT @SQL           
   --   EXEC (@SQL)          
   --   SET @PARAMCUR = CURSOR FOR SELECT PARANAME FROM #PARANAMES          
   --  END          
    ELSE          
     BEGIN   
	  
     print 'C'             
      SET @PARAMCUR = CURSOR FOR SELECT NAME FROM SYSCOLUMNS WHERE ID = (SELECT ID FROM SYSOBJECTS WHERE NAME = @OBJNAME AND XTYPE = 'P')          
     END          
               
   OPEN @PARAMCUR  
   print 'D'               
   FETCH NEXT FROM @PARAMCUR INTO @PARAMFIELDS          
   SET @SQL = ''      
       
   SET @PARAMPOS = 1          
   WHILE @@FETCH_STATUS = 0          
    BEGIN          
     SET @PARAMVAL = .dbo.CLS_Piece(@F2PARAMS, '|', @PARAMPOS)          
     IF @PARAMVAL IS NULL          
      BEGIN          
       SET @SQL = @SQL + @PARAMFIELDS + "=NULL,"          
      END        
     ELSE          
      BEGIN          
       SET @SQL = @SQL + @PARAMFIELDS + "='" + @PARAMVAL + "',"          

      END          
     SET @PARAMPOS = @PARAMPOS + 1          
     FETCH NEXT FROM @PARAMCUR INTO @PARAMFIELDS          
    END          
   print @SQL        
   IF LEN(@SQL) > 0          
    BEGIN         
    
     SET @SQL = @DATABASENAME + '..' + @OBJNAME + ' ' + SUBSTRING(@SQL, 1, LEN(@SQL)-1)          
    END          
   ELSE          
    BEGIN          
     SET @SQL = @DATABASENAME + '..' + @OBJNAME          
    END          
      EXEC SP_EXECUTESQL @SQL          
   print @SQL         
  END          
    
    
END TRY          
BEGIN CATCH          
  DECLARE @ERRMSG VARCHAR(1000)          
  SET @ERRMSG = ERROR_MESSAGE()          
  RAISERROR(@ERRMSG, 16, 1)          
END CATCH     
    
--COMMIT

GO
