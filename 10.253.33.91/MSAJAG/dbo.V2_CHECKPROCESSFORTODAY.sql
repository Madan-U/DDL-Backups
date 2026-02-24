-- Object: PROCEDURE dbo.V2_CHECKPROCESSFORTODAY
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------






CREATE    PROC V2_CHECKPROCESSFORTODAY(
           @PROCESSFLAG VARCHAR(15),
	   @SETT_NO VARCHAR(7),
	   @SETT_TYPE VARCHAR(2),
	   @PROCESSDATE VARCHAR(11))
AS
                        
  SELECT FLAG = (CASE 
                   WHEN @PROCESSFLAG = 'BILLING'
                        AND IMPORT_TRADE > 0 THEN 1
                   WHEN @PROCESSFLAG = 'VBB'
                        AND BILLING > 0 THEN 1
                   WHEN @PROCESSFLAG = 'STT'
                        AND VBB > 0 THEN 1
                   WHEN @PROCESSFLAG = 'VALAN'
                        AND STT > 0 THEN 1
                   WHEN @PROCESSFLAG = 'CONTRACTPOP'
                        AND VALAN > 0 THEN 1
                   WHEN @PROCESSFLAG = 'POSTING'
                        AND CONTRACT > 0 THEN 1
                   WHEN @PROCESSFLAG = 'CLOSE'
                        AND POSTING > 0 THEN 1
                   ELSE 0
                 END),
         PROCESSNAME = (CASE 
                          WHEN @PROCESSFLAG = 'BILLING' THEN 'IMPORT_TRADE'
                          WHEN @PROCESSFLAG = 'VBB' THEN 'BILLING'
                          WHEN @PROCESSFLAG = 'STT' THEN 'VBB'
                          WHEN @PROCESSFLAG = 'VALAN' THEN 'STT'
                          WHEN @PROCESSFLAG = 'CONTRACTPOP' THEN 'VALAN'
                          WHEN @PROCESSFLAG = 'POSTING' THEN 'CONTRACTPOP'
                          WHEN @PROCESSFLAG = 'CLOSE' THEN 'POSTING'
                          ELSE 'SOME PROCESS'
                        END)
  FROM   V2_BUSINESS_PROCESS
  WHERE  SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE 
  AND LEFT(BUSINESS_DATE,11) = @PROCESSDATE
  AND Open_Close = 0

GO
