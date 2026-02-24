-- Object: PROCEDURE dbo.GET_AUTOJV_INACTIVE_LIST
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


--EXEC GET_AUTOJV_INACTIVE_LIST 'ANAND1', 'MSAJAG', 'ACCOUNT', 'ANGELFO', 'BSEMFSS', 'BBO_FA', '0000', 'ZZZZZZZZZ', 'JAN 21 2022'

CREATE PROCEDURE GET_AUTOJV_INACTIVE_LIST

       @SOURCE_SERVER VARCHAR(100), -- SOURCE SERVER

       @SOURCE_SHAREDB VARCHAR(100), -- SOURCE SHARE DB

       @SOURCE_DB VARCHAR(100), -- SOURCE ACCOUNT DB

       @DESTINATION_SERVER VARCHAR(100), -- DESTINATION SERVER

       @DESTINATION_SHAREDB VARCHAR(100), -- DESTINATION SHARE DB

       @DESTINATION_DB VARCHAR(100), -- DESTINATION ACCOUNT DB

       @CLTCODE_FR VARCHAR(10), -- FROM CLIENT

       @CLTCODE_TO VARCHAR(10), -- TO CLIENT

       @START_DATENEW VARCHAR(11) -- DATE FOR WHICH THE AUTOJV RUN

 

AS

 

CREATE TABLE #FUND_TRF_CLIENT             

(             

 CLTCODE VARCHAR(10),             

 ACNAME VARCHAR(100),             

 BRANCHCODE VARCHAR(10)             

)             

              

            

CREATE NONCLUSTERED INDEX [IDXCLTCODE] ON [DBO].[#FUND_TRF_CLIENT]                    

(                   

 CLTCODE                 

)                   

 

 

DECLARE             

 @SQL VARCHAR(MAX)             

              

SET @SQL = "INSERT INTO #FUND_TRF_CLIENT "             

SET @SQL = @SQL + "SELECT "             

SET @SQL = @SQL + " A.CLTCODE, "             

SET @SQL = @SQL + " A.ACNAME, "             

SET @SQL = @SQL + " A.BRANCHCODE "             

SET @SQL = @SQL + "FROM "             

SET @SQL = @SQL + " " + @SOURCE_SERVER + "." + @SOURCE_DB + ".DBO.ACMAST A  , "              

SET @SQL = @SQL + " " + @DESTINATION_SERVER + "." + @DESTINATION_DB + ".DBO.ACMAST AA   "             

SET @SQL = @SQL + "WHERE "             

SET @SQL = @SQL + " A.ACCAT = 4 "             

SET @SQL = @SQL + " AND A.CLTCODE BETWEEN '" + @CLTCODE_FR + "' AND '" + @CLTCODE_TO + "'"             

SET @SQL = @SQL + " AND A.CLTCODE = AA.CLTCODE"             

              

EXEC (@SQL)             

              

--PRINT @SQL             

              

SET @SQL = "SELECT L.* "             

SET @SQL = @SQL + " FROM   #FUND_TRF_CLIENT L, "             

SET @SQL = @SQL + " (SELECT CL_CODE, INACTIVEFROM FROM " + @SOURCE_SERVER + "." + @SOURCE_SHAREDB + ".DBO.CLIENT5   WHERE CL_CODE >= '" + @CLTCODE_FR + "' AND CL_CODE <= '" + @CLTCODE_TO + "') C5 "             

SET @SQL = @SQL + " WHERE  CLTCODE = CL_CODE "             

SET @SQL = @SQL + "       AND INACTIVEFROM < '" + @START_DATENEW + "'"                          

              

EXEC (@SQL)             

              

--PRINT @SQL             

              

SET @SQL = "SELECT L.* "             

SET @SQL = @SQL + "FROM   #FUND_TRF_CLIENT L, "             

SET @SQL = @SQL + "  (SELECT CL_CODE, INACTIVEFROM FROM " + @DESTINATION_SERVER + "." + @DESTINATION_SHAREDB + ".DBO.CLIENT5    WHERE CL_CODE >= '" + @CLTCODE_FR + "' AND CL_CODE <= '" + @CLTCODE_TO + "') C5  "             

SET @SQL = @SQL + " WHERE  CLTCODE = CL_CODE "             

SET @SQL = @SQL + "       AND INACTIVEFROM < '" + @START_DATENEW + "'"             

           

EXEC (@SQL)

GO
