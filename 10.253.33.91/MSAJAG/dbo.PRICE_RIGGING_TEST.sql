-- Object: PROCEDURE dbo.PRICE_RIGGING_TEST
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE PRICE_RIGGING_TEST
(
	@PCODE AS VARCHAR(11),
	@SCODE AS VARCHAR(10),
	@SETTNO AS VARCHAR(11)
)              
AS              
              
  SET NOCOUNT ON;              
DECLARE @ORDER_NO VARCHAR(50),@CNT INT               
SET @CNT=1              
 SELECT MARKETRATE AS RATE,CASE WHEN SELL_BUY ='1' THEN 'BUY' ELSE 'SELL' END AS [SELL/BUY],TRADEQTY,              
 ORDER_NO AS [ORDER NO],TRADE_NO AS [TRADE NO],RIGHT(SAUDA_DATE,7) AS TIME,FLAG=SPACE(2) INTO #FILE               
 FROM HISTORY WHERE PARTY_CODE=@PCODE  AND SCRIP_CD=@SCODE                
 AND SETT_TYPE IN ('N','W') AND SETT_NO=@SETTNO ORDER BY ORDER_NO                
 INSERT INTO #FILE              
 SELECT  MARKETRATE AS RATE,CASE WHEN SELL_BUY ='1' THEN 'BUY' ELSE 'SELL' END AS [SELL/BUY],TRADEQTY,              
 ORDER_NO  AS [ORDER NO],TRADE_NO AS [TRADE NO],RIGHT(SAUDA_DATE,7) AS TIME,FLAG=SPACE(2) FROM SETTLEMENT               
 WHERE PARTY_CODE=@PCODE  AND SCRIP_CD=@SCODE                
 AND SETT_TYPE IN ('N','W') AND SETT_NO=@SETTNO ORDER BY ORDER_NO       
    
DECLARE @VAL INT,@ABC VARCHAR(20)              
SET @VAL=1              
DECLARE ERROR_CURSOR CURSOR FOR                                               
SELECT [ORDER NO] FROM #FILE ORDER BY  [ORDER NO]              
              
OPEN ERROR_CURSOR                                              
FETCH NEXT FROM ERROR_CURSOR                                               
INTO @ORDER_NO                              
WHILE @@FETCH_STATUS = 0                                              
BEGIN                                  
IF @VAL=1              
      BEGIN               
      UPDATE #FILE SET FLAG=@CNT WHERE [ORDER NO]=@ORDER_NO              
      SET @VAL=@VAL+1              
      SET @ABC=@ORDER_NO              
      END              
ELSE              
    BEGIN              
 IF (@ABC<>@ORDER_NO)                                     
    BEGIN              
----              
   IF (@ABC<>@ORDER_NO AND @CNT=4 )                                     
     BEGIN              
      SET @ABC=@ORDER_NO              
      SET @CNT=0              
      --UPDATE #FILE SET FLAG=@CNT WHERE [ORDER NO]=@ORDER_NO              
      END              
----              
     SET @ABC=@ORDER_NO              
     SET @CNT=@CNT+1              
      UPDATE #FILE SET FLAG=@CNT WHERE [ORDER NO]=@ORDER_NO              
   END              
ELSE              
   BEGIN              
   UPDATE #FILE SET FLAG=@CNT WHERE [ORDER NO]=@ORDER_NO              
------              
--IF (@ABC<>@ORDER_NO AND @CNT=4 )                                     
--BEGIN              
--              
--SET @ABC=@ORDER_NO              
--SET @CNT=1              
--UPDATE #FILE SET FLAG=@CNT WHERE [ORDER NO]=@ORDER_NO              
--END              
------              
END              
END              
--IF ((@ABC<>@ORDER_NO)  AND @CNT=4 )              
--IF @CNT=4               
--              
--    SET @CNT=0              
  FETCH NEXT FROM ERROR_CURSOR                                               
  INTO @ORDER_NO           
END                 
              
CLOSE ERROR_CURSOR                                              
DEALLOCATE ERROR_CURSOR                                              
              
--SELECT * FROM #FILE ORDER BY  [ORDER NO]        
        
SELECT A.*,SELFTRD=CASE WHEN B.CNT=1 THEN 'N' ELSE 'Y' END 
INTO #TEMP_FINAL
FROM        
(SELECT * FROM #FILE)A        
LEFT OUTER JOIN        
(SELECT [TRADE NO],CNT=COUNT(*) FROM #FILE GROUP BY [TRADE NO])B        
ON A.[TRADE NO]=B.[TRADE NO]        
ORDER BY  A.[ORDER NO]    
 
SELECT COUNT(*) FROM #TEMP_FINAL
    
SET NOCOUNT OFF;

GO
