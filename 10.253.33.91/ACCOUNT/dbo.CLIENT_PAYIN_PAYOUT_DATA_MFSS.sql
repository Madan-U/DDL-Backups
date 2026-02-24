-- Object: PROCEDURE dbo.CLIENT_PAYIN_PAYOUT_DATA_MFSS
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

--CLIENT_PAYIN_PAYOUT_DATA 'p87029','mar  7 2017','feb 28 2018'  
  
CREATE PROCEDURE [dbo].[CLIENT_PAYIN_PAYOUT_DATA_MFSS]  
  
(  
  
@CLTCODE VARCHAR(20),  
  
@FROMDATE VARCHAR(11),  
  
@TODATE VARCHAR(11)   
  
)  
  
AS                       
  
                    
  
IF LEN(@FROMDATE) = 10 AND CHARINDEX('/', @FROMDATE) > 0               
  
BEGIN                      
  
      SET @FROMDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE, 103), 109)                      
  
  
END     
IF LEN(@TODATE) = 10 AND CHARINDEX('/', @TODATE) > 0                      
  
  
BEGIN                      
  
      SET @TODATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TODATE, 103), 109)                      
  
END                      
  
BEGIN    
  
  
SELECT EXCHANGE,SEGMENT,CLTCODE,ACNAME,BRANCH_CD,VTYPE,(case when VTYPE='2' THEN 'PAYIN' ELSE 'PAYOUT' END) AS TYPE,DRAMOUNT,CRAMOUNT,VDT,VNO,ENTRY_AMT,NARRATION  
   
FROM (  
SELECT  EXCHANGE,SEGMENT,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtypE,A.DRAMOUNT,A.CRAMOUNT,A.VDT,A.VNO,A.ENTRY_AMT  
,A.NARRATION  
FROM [AngelFO].BBO_FA.DBO.acc_LEDGER A with (NOLOCK)  JOIN [AngelFO].bsemfss.DBO.MFSS_CLIENT B with (NOLOCK) ON A.CLTCODE = B.PARTY_CODE  
WHERE a.VTYPE IN ('2','3') and CLTCODE =@cltcode  
AND VDT >=@FROMDATE  AND VDT<=@TODATE + ' 23:59'   
   
) A ORDER BY EXCHANGE  
  
  
  
  
END

GO
