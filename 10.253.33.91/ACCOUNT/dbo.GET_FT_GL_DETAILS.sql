-- Object: PROCEDURE dbo.GET_FT_GL_DETAILS
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


--EXEC [ANAND1].[ACCOUNT].[DBO].[GET_FT_GL_DETAILS] 	'NSECM', 	'Aug 23 2021', 	'Aug 23 2021', 	'0', 	'ZZZZ' 
        
CREATE PROCEDURE [dbo].[GET_FT_GL_DETAILS]        
 @EXCH VARCHAR(10),        
 @FROM_DATE VARCHAR(11),        
 @TO_DATE VARCHAR(11),
 @CTRLCODE_FROM VARCHAR(10) = '00',
 @CTRLCODE_TO VARCHAR(10) = '99'
AS        
        
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
        
 IF LEN(@FROM_DATE) = 10        
 BEGIN        
  SELECT @FROM_DATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROM_DATE, 103), 109)        
  SELECT @TO_DATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TO_DATE, 103), 109)        
 END        
        
 CREATE TABLE #FT_GL_DETAILS        
 (        
  JV_CODE VARCHAR(10)        
  --JV_NAME VARCHAR(100) 
 )
        
 INSERT INTO #FT_GL_DETAILS        
 SELECT         
  JV_CODE         
  --JV_NAME         
 FROM         
  FT_GL         
 WHERE         
  EXCH_FR = @EXCH
  AND JV_CODE BETWEEN @CTRLCODE_FROM AND @CTRLCODE_TO
         
 UNION       
         
 SELECT         
  JV_CODE         
  --JV_NAME         
 FROM         
  FT_GL         
 WHERE         
  EXCH_TO = @EXCH
  AND JV_CODE BETWEEN @CTRLCODE_FROM AND @CTRLCODE_TO       
        
--SELECT * FROM #FT_GL_DETAILS     
--RETURN 
        
 SELECT         
  CTRL_CODE = JV_CODE,         
  --CTRL_NAME = JV_NAME,        
  EXCHANGE = @EXCH,        
  AMOUNT = SUM(CASE DRCR WHEN 'D' THEN VAMT ELSE -VAMT END)        
 FROM        
  LEDGER L WITH (NOLOCK),         
  #FT_GL_DETAILS F        
 WHERE         
  CLTCODE = JV_CODE        
  AND VDT BETWEEN @FROM_DATE AND @TO_DATE        
  AND VTYP = 88        
 GROUP BY        
  JV_CODE        
  --JV_NAME        
 ORDER BY        
  1        


           
 DROP TABLE #FT_GL_DETAILS

GO
