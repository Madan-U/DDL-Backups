-- Object: PROCEDURE dbo.USP_BROK_MISMATCH_REPORT
-- Server: 10.253.33.91 | DB: scratchpad
--------------------------------------------------

  
---|| DESCRIPTION :- BROK MISMATCH REPORT KYC TEAM (NILESH PAWAR)  
---|| CREATED BY :- HRISHI Y  
---|| CREATED DATE :- 03-NOV-2024  
---Modified under ORE --ORE-4802   AND( ORE-4834 11SEP2025)  
---Modified under ORE --ORE-4998   AND( ORE-4998 20NOV2025) 
CREATE PROC [dbo].[USP_BROK_MISMATCH_REPORT] (@TDATE DATETIME)  
  
AS  
  
  
DECLARE @SQL VARCHAR (MAX) ,@SQL2 VARCHAR (MAX), @SQLFINAL VARCHAR (MAX) , @PATH VARCHAR (MAX)  
--SET @PATH='J:\Backoffice\SL_AUTO\COMPLIANCE_REPORTS\DMS_REPORT\INPUT\INPUT.txt'     
  
IF OBJECT_ID(N'TEMPDB..#CHECKBROK') IS NOT NULL  
DROP TABLE #CHECKBROK  
  
SELECT CL_CODE,EXCH = EXCHANGE+SEGMENT,BROK_SCHEME,TRD_BROK,DEL_BROK,CASH_VBB_TRD='00',CASH_VBB_DEL='00',                  
Fut_Opt_Brok,                  
Fut_Fut_Fin_Brok,                  
Fut_Opt_Exc,                  
Fut_Brok_Applicable                ,  
OPT_VBB_TRD='00',OPT_VBB_DEL='00',BTB_BTC = ''  
INTO #CHECKBROK                      
FROM MSAJAG.DBO.CLIENT_BROK_DETAILS WITH (NOLOCK) WHERE INACTIVE_FROM >= '2049-12-31' AND IMP_STATUS = 1 --AND CL_CODE IN ('RP61','K357','AAAB022593')  
  
  
CREATE INDEX CLIIDX ON #CHECKBROK (CL_CODE,EXCH)      
  
DELETE FROM #CHECKBROK WHERE EXCH IN ('BSXFUTURES','MCDFUTURES','NSESLBS') --5908484+152  
  
  
UPDATE #CHECKBROK SET CASH_VBB_TRD = SP_SCHEME_ID FROM                  
MSAJAG.DBO.SCHEME_MAPPING WITH (NOLOCK) WHERE SP_PARTY_CODE = CL_CODE AND EXCH = 'NSECAPITAL'                    
AND GETDATE () BETWEEN SP_DATE_FROM AND SP_DATE_TO AND SP_TRD_TYPE= 'TRD'        AND SP_SCRIP = 'ALL'            
                  
UPDATE #CHECKBROK SET CASH_VBB_DEL = SP_SCHEME_ID FROM                  
MSAJAG.DBO.SCHEME_MAPPING WITH (NOLOCK) WHERE SP_PARTY_CODE = CL_CODE AND EXCH = 'NSECAPITAL'                    
AND GETDATE () BETWEEN SP_DATE_FROM AND SP_DATE_TO AND SP_TRD_TYPE= 'DEL'           AND SP_SCRIP = 'ALL'         
                  
UPDATE #CHECKBROK SET CASH_VBB_TRD = SP_SCHEME_ID FROM                  
ANAND.BSEDB_AB.DBO.SCHEME_MAPPING WITH (NOLOCK) WHERE SP_PARTY_CODE = CL_CODE AND EXCH = 'BSECAPITAL'                   
AND GETDATE () BETWEEN SP_DATE_FROM AND SP_DATE_TO  AND SP_TRD_TYPE= 'TRD'         AND SP_SCRIP = 'ALL'           
                  
UPDATE #CHECKBROK SET CASH_VBB_DEL = SP_SCHEME_ID FROM                  
ANAND.BSEDB_AB.DBO.SCHEME_MAPPING WITH (NOLOCK) WHERE SP_PARTY_CODE = CL_CODE AND EXCH = 'BSECAPITAL'                    
AND GETDATE () BETWEEN SP_DATE_FROM AND SP_DATE_TO AND SP_TRD_TYPE= 'DEL'           AND SP_SCRIP = 'ALL'         
                  
UPDATE #CHECKBROK SET OPT_VBB_TRD = SP_SCHEME_ID FROM                  
ANGELFO.NSEFO.DBO.SCHEME_MAPPING WITH (NOLOCK) WHERE SP_PARTY_CODE = CL_CODE AND EXCH = 'NSEFUTURES'                   
AND GETDATE () BETWEEN SP_DATE_FROM AND SP_DATE_TO                  
AND SP_INST_TYPE = 'OPT'                  
AND SP_TRD_TYPE= 'TRD'        AND SP_SCRIP = 'ALL'             
                  
UPDATE #CHECKBROK SET OPT_VBB_DEL = SP_SCHEME_ID FROM                  
ANGELFO.NSEFO.DBO.SCHEME_MAPPING WITH (NOLOCK) WHERE SP_PARTY_CODE = CL_CODE   AND EXCH = 'NSEFUTURES'                   
AND GETDATE () BETWEEN SP_DATE_FROM AND SP_DATE_TO                  
AND SP_INST_TYPE = 'OPT'                  
AND SP_TRD_TYPE= 'DEL'        AND SP_SCRIP = 'ALL'             
                  
UPDATE #CHECKBROK SET OPT_VBB_TRD = SP_SCHEME_ID FROM                  
ANGELFO.NSECURFO.DBO.SCHEME_MAPPING WITH (NOLOCK) WHERE SP_PARTY_CODE = CL_CODE  AND EXCH = 'NSXFUTURES'                   
AND GETDATE () BETWEEN SP_DATE_FROM AND SP_DATE_TO                  
AND SP_INST_TYPE = 'OPT'                  
AND SP_TRD_TYPE= 'TRD'        AND SP_SCRIP = 'ALL'             
                  
UPDATE #CHECKBROK SET OPT_VBB_DEL = SP_SCHEME_ID FROM                  
ANGELFO.NSECURFO.DBO.SCHEME_MAPPING WITH (NOLOCK) WHERE SP_PARTY_CODE = CL_CODE  AND EXCH = 'NSXFUTURES'                  
AND GETDATE () BETWEEN SP_DATE_FROM AND SP_DATE_TO                  
AND SP_INST_TYPE = 'OPT'                  
AND SP_TRD_TYPE= 'DEL'           AND SP_SCRIP = 'ALL'         
                  
     
UPDATE #CHECKBROK SET OPT_VBB_TRD = SP_SCHEME_ID FROM                  
ANGELCOMMODITY.NCDX.DBO.SCHEME_MAPPING WITH (NOLOCK) WHERE SP_PARTY_CODE = CL_CODE  AND EXCH = 'NCXFUTURES'                    
AND GETDATE () BETWEEN SP_DATE_FROM AND SP_DATE_TO                  
AND SP_INST_TYPE = 'OPT'                  
AND SP_TRD_TYPE= 'TRD'       AND SP_SCRIP = 'ALL'           
                  
UPDATE #CHECKBROK SET OPT_VBB_DEL = SP_SCHEME_ID FROM                  
ANGELCOMMODITY.NCDX.DBO.SCHEME_MAPPING WITH (NOLOCK) WHERE SP_PARTY_CODE = CL_CODE  AND EXCH = 'NCXFUTURES'                    
AND GETDATE () BETWEEN SP_DATE_FROM AND SP_DATE_TO                  
AND SP_INST_TYPE = 'OPT'              AND SP_TRD_TYPE= 'DEL'       AND SP_SCRIP = 'ALL'              
                  
                  
UPDATE #CHECKBROK SET OPT_VBB_TRD = SP_SCHEME_ID FROM                  
ANGELCOMMODITY.MCDX.DBO.SCHEME_MAPPING WITH (NOLOCK) WHERE SP_PARTY_CODE = CL_CODE  AND EXCH = 'MCXFUTURES'                  
AND GETDATE () BETWEEN SP_DATE_FROM AND SP_DATE_TO                   
AND SP_INST_TYPE = 'OPT'                  
AND SP_TRD_TYPE= 'TRD'           AND SP_SCRIP = 'ALL'         
                  
UPDATE #CHECKBROK SET OPT_VBB_DEL = SP_SCHEME_ID FROM                  
ANGELCOMMODITY.MCDX.DBO.SCHEME_MAPPING WITH (NOLOCK) WHERE SP_PARTY_CODE = CL_CODE AND EXCH = 'MCXFUTURES'                    
AND GETDATE () BETWEEN SP_DATE_FROM AND SP_DATE_TO                   
AND SP_INST_TYPE = 'OPT'                  
AND SP_TRD_TYPE= 'DEL'     AND SP_SCRIP = 'ALL'      
  
  
UPDATE #CHECKBROK SET OPT_VBB_TRD = SP_SCHEME_ID FROM                  
ANGELCOMMODITY.BSEFO.DBO.SCHEME_MAPPING WITH (NOLOCK) WHERE SP_PARTY_CODE = CL_CODE  AND EXCH = 'BSEFUTURES'                  
AND GETDATE () BETWEEN SP_DATE_FROM AND SP_DATE_TO                   
AND SP_Product_Type = 'OPT'                  
AND SP_TRD_TYPE= 'TRD'           AND SP_Product_code = 'ALL'         
  
UPDATE #CHECKBROK SET OPT_VBB_DEL = SP_SCHEME_ID FROM                  
ANGELCOMMODITY.BSEFO.DBO.SCHEME_MAPPING WITH (NOLOCK) WHERE SP_PARTY_CODE = CL_CODE AND EXCH = 'BSEFUTURES'                    
AND GETDATE () BETWEEN SP_DATE_FROM AND SP_DATE_TO                   
AND SP_Product_Type = 'OPT'                  
AND SP_TRD_TYPE= 'DEL'     AND SP_Product_code = 'ALL'     
  
UPDATE #CHECKBROK SET OPT_VBB_TRD = SP_SCHEME_ID FROM                  
ANGELCOMMODITY.NCE.DBO.SCHEME_MAPPING WITH (NOLOCK) WHERE SP_PARTY_CODE = CL_CODE  AND EXCH = 'NCEFUTURES'                  
AND GETDATE () BETWEEN SP_DATE_FROM AND SP_DATE_TO                   
AND SP_INST_TYPE = 'OPT'                  
AND SP_TRD_TYPE= 'TRD'           AND SP_SCRIP = 'ALL'         
                  
UPDATE #CHECKBROK SET OPT_VBB_DEL = SP_SCHEME_ID FROM                  
ANGELCOMMODITY.NCE.DBO.SCHEME_MAPPING WITH (NOLOCK) WHERE SP_PARTY_CODE = CL_CODE AND EXCH = 'NCEFUTURES'                    
AND GETDATE () BETWEEN SP_DATE_FROM AND SP_DATE_TO                   
AND SP_INST_TYPE = 'OPT'                  
AND SP_TRD_TYPE= 'DEL'     AND SP_SCRIP = 'ALL'       
                   
--SELECT * FROM #CHECKBROK  
  
SELECT *,  
CASE   
WHEN CASH_VBB_TRD between '52' and '59' THEN 'I Trade'  
WHEN CASH_VBB_TRD between '60' and '82' THEN 'I Trade Prime'  
WHEN CASH_VBB_TRD between '83' and '84' THEN 'SUPER10 K'  
WHEN CASH_VBB_TRD between '85' and '86' THEN 'ITRADE PRIME PLUS'   
WHEN CASH_VBB_TRD between '87' and '88' THEN 'VALUE ADDED'  
WHEN CASH_VBB_TRD between '91' and '92' THEN 'ITRADE PREMIRE' ------  
WHEN CASH_VBB_TRD between '93' and '94' THEN 'ITRADE PREMIER PRO'  
WHEN CASH_VBB_TRD between '95' and '96' THEN 'ITRADE PREMIER PLUS'  
 WHEN OPT_VBB_DEL between '97' and '98' THEN 'ITRADE PREMIER PRO PLUS'   
  
WHEN CASH_VBB_DEL between '52' and '59' THEN 'I Trade'  
WHEN CASH_VBB_DEL between '60' and '82' THEN 'I Trade Prime'  
WHEN CASH_VBB_DEL between '83' and '84' THEN 'SUPER10 K'  
WHEN CASH_VBB_DEL between '85' and '86' THEN 'ITRADE PRIME PLUS'  
WHEN CASH_VBB_DEL between '87' and '88' THEN 'VALUE ADDED'   
WHEN CASH_VBB_DEL between '91' and '92' THEN 'ITRADE PREMIRE' ------  
WHEN CASH_VBB_DEL between '93' and '94' THEN 'ITRADE PREMIER PRO'    
WHEN CASH_VBB_DEL between '95' and '96' THEN 'ITRADE PREMIER PLUS' 
WHEN OPT_VBB_DEL between '97' and '98' THEN 'ITRADE PREMIER PRO PLUS'  

WHEN OPT_VBB_TRD between '52' and '59' THEN 'I Trade'  
WHEN OPT_VBB_TRD between '60' and '82' THEN 'I Trade Prime'  
WHEN OPT_VBB_TRD between '83' and '84' THEN 'SUPER10 K'  
WHEN OPT_VBB_TRD between '85' and '86' THEN 'ITRADE PRIME PLUS'  
WHEN OPT_VBB_TRD between '87' and '88' THEN 'VALUE ADDED'   
WHEN OPT_VBB_TRD between '91' and '92' THEN 'ITRADE PREMIRE' ------  
WHEN OPT_VBB_TRD between '93' and '94' THEN 'ITRADE PREMIER PRO'  
WHEN OPT_VBB_TRD between '95' and '96' THEN 'ITRADE PREMIER PLUS'   
WHEN OPT_VBB_DEL between '97' and '98' THEN 'ITRADE PREMIER PRO PLUS'  
  
WHEN OPT_VBB_DEL between '52' and '59' THEN 'I Trade'  
WHEN OPT_VBB_DEL between '60' and '82' THEN 'I Trade Prime'  
WHEN OPT_VBB_DEL between '83' and '84' THEN 'SUPER10 K'  
WHEN OPT_VBB_DEL between '85' and '86' THEN 'ITRADE PRIME PLUS'  
WHEN OPT_VBB_DEL between '87' and '88' THEN 'VALUE ADDED'   
WHEN OPT_VBB_DEL between '91' and '92' THEN 'ITRADE PREMIRE' ------  
WHEN OPT_VBB_DEL between '93' and '94' THEN 'ITRADE PREMIER PRO'  
WHEN OPT_VBB_DEL between '95' and '96' THEN 'ITRADE PREMIER PLUS'  
WHEN OPT_VBB_DEL between '97' and '98' THEN 'ITRADE PREMIER PRO PLUS'  
END AS SCHEME  
INTO #RAWDATA  
FROM #CHECKBROK --WHERE CL_CODE<>'A1034344'   
  
SELECT CL_CODE, COUNT(CL_CODE) AS CNT, SCHEME  
INTO #PARTIALDATA   
FROM #RAWDATA GROUP BY CL_CODE,SCHEME  
  
SELECT CL_CODE , '106' AS 'REMARKS'  
INTO #FINALDATA  
FROM (  
SELECT ROW_NUMBER() OVER (PARTITION BY CL_CODE ORDER BY CL_CODE) AS ROW_NUM,* FROM #PARTIALDATA  
) ABC   
WHERE ROW_NUM<>'1'  
  
  
  
TRUNCATE TABLE SCRATCHPAD.DBO.TBL_BROKMISMATCH_DATA    
    
INSERT INTO SCRATCHPAD.DBO.TBL_BROKMISMATCH_DATA    
SELECT CL_CODE,REMARKS FROM #FINALDATA  
  
---------------------- || FILE GENERATION LOGIC || ----------------------  
  
--DECLARE @RPT_DATE VARCHAR(30)=REPLACE(CONVERT(VARCHAR(10),GETDATE(),3),'/','')            
DECLARE @FILENAME VARCHAR(100) = 'J:\Backoffice\SL_AUTO\NILESH_P\MISMATCH_REPORT\OUTPUT\' +'BROK_MISMATCH_REPORT' + '.CSV'            
DECLARE @ALL VARCHAR(MAX)                      
                      
SET @ALL = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''[CL_CODE]'''',''''[REMARKS]'''''                      
SET @ALL = @ALL+ ' UNION ALL SELECT * FROM SCRATCHPAD.DBO.TBL_BROKMISMATCH_DATA'                    
PRINT @ALL                      
SET @ALL=@ALL+' " QUERYOUT ' +@FILENAME+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'                      
PRINT @ALL                      
EXEC(@ALL)                      
  
---------------------- || FILE GENERATION LOGIC || ----------------------  
                  
SELECT 'BROK MISMATCH DATA FILE EXPORTED TO \\10.253.33.91\' + @FILENAME AS 'REMARK'    
  
DECLARE @COUNT INT  
SELECT @COUNT=COUNT(1) FROM SCRATCHPAD.DBO.TBL_BROKMISMATCH_DATA  
----------------send dbmail---------------------------  
  
If @count>=1  
begin   
EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'BO SUPPORT',  
    @RECIPIENTS='nilesh@angelone.in;brokerage.modification@angelone.in',                         
    --@copy_recipients ='BO.SUPPORT@ANGELBROKING.COM',                
    @subject = 'BROKERAGE MISMATCH REPORT',  
 @body = 'Hi Team,<br><br>Please find attachment of Brokerage Mismatch Report.',  
    @body_format = 'HTML',  
    @file_attachments = 'J:\Backoffice\SL_AUTO\NILESH_P\MISMATCH_REPORT\OUTPUT\BROK_MISMATCH_REPORT.CSV';  
  
 END  
 else   
 begin  
 EXEC msdb.dbo.sp_send_dbmail  
   @profile_name = 'BO SUPPORT',  
    @RECIPIENTS='nilesh@angelone.in;brokerage.modification@angelone.in',                         
    --@copy_recipients ='BO.SUPPORT@ANGELBROKING.COM',                
    @subject = 'BROKERAGE MISMATCH REPORT',  
 @body = 'Hi Team,<br><br>No records found in brokerage mismatch report.',  
    @body_format = 'HTML'  
      
  
  
  end

GO
