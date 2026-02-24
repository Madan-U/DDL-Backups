-- Object: PROCEDURE dbo.USP_MAX_LAST_TRADE_DATE
-- Server: 10.253.33.91 | DB: scratchpad
--------------------------------------------------

  ------------------SP CREATED UNDER SRE-ORE-5145----------------23FEB2026-------------------------
CREATE PROC [dbo].[USP_MAX_LAST_TRADE_DATE]  
AS 

DECLARE @SQL VARCHAR (MAX) ,@SQL2 VARCHAR (MAX), @SQLFINAL VARCHAR (MAX) , @PATH VARCHAR (MAX)  
SET @PATH='J:\BACKOFFICE\SANTOSH\INPUT\CLIENT_DATA.CSV'  
 IF OBJECT_ID(N'tempdb..#CODE') IS NOT NULL  
    DROP TABLE #CODE  
CREATE TABLE #CODE (CLTCODE VARCHAR(50))  
SET @SQL='BULK INSERT #CODE FROM ' + ''''+ @PATH +''''  
SET @SQL2=' WITH  
    (  
           FIRSTROW = 1,  
           FIELDTERMINATOR = '','',  --CSV FIELD DELIMITER  
           ROWTERMINATOR = ''\n'',   --USE TO SHIFT THE CONTROL TO NEXT ROW  
           TABLOCK  
    )'  
SET @SQLFINAL= @SQL + @SQL2  
PRINT @SQLFINAL  
EXEC (@SQLFINAL)  
--SELECT TOP 10 * FROM #CODE  
IF OBJECT_ID(N'SCRATCHPAD..CLIENT_MAX_LAST_TRADE_DATE') IS NOT NULL  
  
DROP TABLE CLIENT_MAX_LAST_TRADE_DATE 
  
;WITH combined_settlements AS (

    SELECT 'NSE' AS exchange, 'CAPITAL' AS segment, party_code, sauda_date

    FROM msajag.dbo.settlement 

    WHERE party_code IN (SELECT CLTCODE FROM #CODE)

    UNION ALL

    SELECT 'BSE', 'CAPITAL', party_code, sauda_date

    FROM anand.bsedb_ab.dbo.settlement 

    WHERE party_code IN (SELECT CLTCODE FROM #CODE)

    UNION ALL

    SELECT 'NSE', 'FUTURES', party_code, sauda_date

    FROM ANGELFO.NSEFO.dbo.settlement 

    WHERE party_code IN (SELECT CLTCODE FROM #CODE)

    UNION ALL

    SELECT 'NSX', 'FUTURES', party_code, sauda_date

    FROM ANGELFO.NSECURFO.dbo.FOsettlement 

    WHERE party_code IN (SELECT CLTCODE FROM #CODE)

    UNION ALL

    SELECT 'BSE', 'FUTURES', party_code, sauda_date

    FROM ANGELCOMMODITY.BSEFO.dbo.FOsettlement 

    WHERE party_code IN (SELECT CLTCODE FROM #CODE)

    UNION ALL

    SELECT 'BSX', 'FUTURES', party_code, sauda_date

    FROM ANGELCOMMODITY.BSECURFO.dbo.FOsettlement 

    WHERE party_code IN (SELECT CLTCODE FROM #CODE)

    UNION ALL

    SELECT 'NCE', 'FUTURES', party_code, sauda_date

    FROM ANGELCOMMODITY.NCE.dbo.FOsettlement 

    WHERE party_code IN (SELECT CLTCODE FROM #CODE)

    UNION ALL

    SELECT 'NCX', 'FUTURES', party_code, sauda_date

    FROM ANGELCOMMODITY.NCDX.dbo.FOsettlement 

    WHERE party_code IN (SELECT CLTCODE FROM #CODE)

    UNION ALL

    SELECT 'MCX', 'FUTURES', party_code, sauda_date

    FROM ANGELCOMMODITY.MCDX.dbo.FOsettlement 

    WHERE party_code IN (SELECT CLTCODE FROM #CODE)

)

, ranked_settlements AS (

    SELECT *,

           ROW_NUMBER() OVER (PARTITION BY party_code ORDER BY sauda_date DESC) AS rn

    FROM combined_settlements

)

SELECT party_code, exchange, segment, sauda_date AS max_sauda_date INTO CLIENT_MAX_LAST_TRADE_DATE

FROM ranked_settlements

WHERE rn = 1

ORDER BY party_code;
 
DECLARE @FILENAME VARCHAR(100) = 'J:\Backoffice\SANTOSH\OUTPUT\' +'CLIENT_DATA' + '.CSV'          
DECLARE @ALL VARCHAR(MAX)                    
                    
SET @all = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''EXCHANGE'''',''''SEGMENT'''',''''PARTY_CODE'''',''''LAST_TRADED_DATE'''''  
SET @all = @all+ ' UNION ALL SELECT EXCHANGE,SEGMENT,PARTY_CODE,CONVERT(VARCHAR(10),MAX_SAUDA_DATE,120) FROM SCRATCHPAD.DBO.CLIENT_MAX_LAST_TRADE_DATE'                  
              
set @all=@all+' " queryout ' +@filename+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'  
                   
EXEC(@all)      
  
DROP TABLE #CODE  
DROP TABLE CLIENT_MAX_LAST_TRADE_DATE  
SELECT 'CLIENT DATA FILE EXPORTED TO ' + @FILENAME AS 'REMARK'

GO
