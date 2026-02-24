-- Object: PROCEDURE dbo.RPT_STALE_CHEQUE_EMAIL
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------




CREATE PROC [dbo].[RPT_STALE_CHEQUE_EMAIL]    
    
AS    
    
DECLARE @RPTDATE VARCHAR(11)    
    
SET @RPTDATE = GETDATE()    
    
SELECT CLTCODE = CONVERT(VARCHAR(10),''),BANKCODE = CLTCODE,VDT,EDT,VNO,DDNO = CONVERT(VARCHAR(100),''),    
DRCR,VAMT,CDT,ENTEREDBY,CHECKEDBY,NARRATION,EXCHANGE = 'NSECM',VTYP,BOOKTYPE,RELDT = CONVERT(VARCHAR(11),'')     
INTO #LEDGER    
FROM LEDGER WITH (NOLOCK) WHERE VDT >= 'JAN  6 2023' AND VTYP = 3    
AND BOOKTYPE = '01' AND NARRATION LIKE '%CHEQUE%'    
AND CLTCODE = '02019'    
    
UPDATE #LEDGER SET CLTCODE = L.CLTCODE, DRCR = L.DRCR FROM LEDGER L WITH (NOLOCK) WHERE    
L.VNO = #LEDGER.VNO AND L.VTYP = #LEDGER.VTYP AND L.BOOKTYPE = #LEDGER.BOOKTYPE AND L.CLTCODE <> #LEDGER.BANKCODE    
    
UPDATE #LEDGER SET DDNO = L.DDNO,RELDT = L.RELDT FROM LEDGER1 L WITH (NOLOCK) WHERE    
L.VNO = #LEDGER.VNO AND L.VTYP = #LEDGER.VTYP AND L.BOOKTYPE = #LEDGER.BOOKTYPE     
    
DELETE FROM #LEDGER WHERE RELDT <> 'Jan  1 1900'    
    
DELETE RPT_STALE_CHEQUE_DATA_ANG WHERE SRNO = 2    
    
INSERT INTO RPT_STALE_CHEQUE_DATA_ANG    
SELECT CLTCODE,BANKCODE,CONVERT(VARCHAR(10),VDT,105) AS VDT,CONVERT(VARCHAR(10),EDT,105) AS EDT,VNO,DDNO,DRCR,VAMT,CDT,NARRATION,CONVERT(VARCHAR(10),CONVERT(DATETIME,RELDT),105) AS RELDT,2 FROM #LEDGER     
ORDER BY CONVERT(DATETIME,VDT)    
    
    
DECLARE @bodycontent VARCHAR(max),@SUB varchar(500)                            
                             
SET @SUB = 'Stale Cheque report for - '+ CONVERT(VARCHAR(11),GETDATE(),105)                            
                            
DECLARE @ADNAME VARCHAR(100) = 'J:\BACKOFFICE\EXPORT\' + 'STALE_CHEQUE_DATA_ANG_'+ REPLACE(CONVERT(VARCHAR(10), GETDATE(), 104), '.', '') + '.CSV'                            
--DECLARE @ADSTMT NVARCHAR(4000) = 'EXEC [MSAJAG].[DBO].[RPT_ACTIVE_CLIENT_VDT]  ''' + @RUNDATE + ''''                            
DECLARE @ADSTMT NVARCHAR(4000) = 'SELECT CLTCODE,BANKCODE,VDT,EDT,VNO,DDNO,DRCR,VAMT,CDT,NARRATION,RELDT FROM [ACCOUNT].[DBO].RPT_STALE_CHEQUE_DATA_ANG ORDER BY SRNO'                            
DECLARE @ADBCP VARCHAR(4000) = 'BCP "' + @ADSTMT + '" QUERYOUT "' + @ADNAME + '" -c -t"," -r"\n" -T'                            
                            
EXEC MASTER..XP_CMDSHELL @ADBCP , NO_OUTPUT                            
                            
                            
SELECT @bodycontent = '<p>Dear Team,</p>                            
<p>Please see the location of the file for State Cheque of Client data.</p>                            
<p>&nbsp;</p>'   + @ADNAME     
    
EXEC MSDB.DBO.SP_SEND_DBMAIL                   
@PROFILE_NAME='BO SUPPORT',                   
@RECIPIENTS='fundspayout@angelbroking.com;csobankreco@angelbroking.com;Banking@angelbroking.com',                   
@copy_recipients ='rahulc.shah@angelbroking.com;rajesh.mendon@angelbroking.com;narayan.patankar@angelbroking.com;sandip.tote@angelbroking.com;chirag.thakkar@angelbroking.com',        
@blind_copy_recipients='ganesh.jagdale@angelbroking.com',                  
@SUBJECT=@SUB,                  
@BODY=@BODYCONTENT,                  
@IMPORTANCE = 'HIGH',                  
@BODY_FORMAT ='HTML'        
    
DROP TABLE #LEDGER

GO
