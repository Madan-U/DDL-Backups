-- Object: PROCEDURE dbo.CLIENT_PAYIN_PAYOUT_DATA
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

--CLIENT_PAYIN_PAYOUT_DATA 'p87029','mar  7 2017','feb 28 2018'      
      
CREATE PROCEDURE [dbo].[CLIENT_PAYIN_PAYOUT_DATA]      
      
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
      
      
SELECT EXCHANGE,CLTCODE,ACNAME,BRANCH_CD,vtyp,(case when VTYP='2' THEN 'PAYIN' ELSE 'PAYOUT' END) AS TYPE,DRCR,VDT,VNO,VAMT  FROM (      
      
SELECT distinct 'NSE' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT      
      
      
      
FROM LEDGER(NOLOCK) A JOIN MSAJAG..CLIENT_DETAILS B ON A.CLTCODE = B.CL_CODE      
      
WHERE a.VTYP IN ('2','3') and CLTCODE = @CLTCODE      
      
AND VDT >=@FROMDATE  AND VDT<=@TODATE + ' 23:59'       
      
UNION ALL      
      
SELECT distinct 'BSE' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT      
      
FROM [AngelBSECM].ACCOUNT_AB.DBO.LEDGER A JOIN [AngelBSECM].BSEDB_AB.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE      
      
WHERE a.VTYP IN ('2','3') and CLTCODE = @CLTCODE      
      
AND VDT >=@FROMDATE  AND VDT<=@TODATE + ' 23:59'       
      
UNION ALL      
      
SELECT distinct 'NSEFO' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT      
      
FROM [AngelFO].ACCOUNTFO.DBO.LEDGER A JOIN [AngelFO].NSEFO.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE      
      
WHERE a.VTYP IN ('2','3') and CLTCODE  = @CLTCODE      
      
AND VDT >=@FROMDATE  AND VDT<=@TODATE + ' 23:59'       
      
UNION ALL      
      
SELECT distinct 'NSX' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT      
      
FROM [AngelFO].ACCOUNTCURFO.DBO.LEDGER A JOIN [AngelFO].NSECURFO.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE      
      
WHERE a.VTYP IN ('2','3') and CLTCODE  = @CLTCODE      
      
AND VDT >=@FROMDATE  AND VDT<=@TODATE + ' 23:59'       
      
UNION ALL      
      
SELECT distinct 'MCDX' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT      
      
FROM [AngelCommodity].ACCOUNTMCDX.DBO.LEDGER A JOIN [AngelCommodity].MCDX.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE      
      
WHERE a.VTYP IN ('2','3') and CLTCODE  = @CLTCODE      
      
AND VDT >=@FROMDATE  AND VDT<=@TODATE + ' 23:59'       
      
UNION ALL      
      
SELECT distinct 'MCDXCDX' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT      
      
FROM [AngelCommodity].ACCOUNTMCDXCDS.DBO.LEDGER A JOIN [AngelCommodity].MCDXCDS.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE      
      
WHERE a.VTYP IN ('2','3') and CLTCODE  = @CLTCODE      
      
AND VDT >=@FROMDATE  AND VDT<=@TODATE + ' 23:59'       
      
UNION ALL      
      
SELECT distinct 'NCDX' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT      
      
FROM [AngelCommodity].ACCOUNTNCDX.DBO.LEDGER A JOIN [AngelCommodity].NCDX.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE      
      
WHERE a.VTYP IN ('2','3') and CLTCODE  = @CLTCODE      
      
AND VDT >=@FROMDATE  AND VDT<=@TODATE + ' 23:59'       
      
UNION ALL      
      
      
      
      
      
SELECT distinct 'NSE' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT      
      
      
      
FROM [10.253.33.239].ACCOUNT.DBO.LEDGER A JOIN [10.253.33.239].MSAJAG.dbo.CLIENT_DETAILS B ON A.CLTCODE = B.CL_CODE      
      
WHERE a.VTYP IN ('2','3') and CLTCODE = @CLTCODE      
      
AND VDT >=@FROMDATE  AND VDT<=@TODATE + ' 23:59'       
      
UNION ALL      
      
SELECT distinct 'BSE' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT      
      
FROM [10.253.33.239].ACCOUNT_AB.DBO.LEDGER A JOIN [10.253.33.239].BSEDB_AB.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE      
      
WHERE a.VTYP IN ('2','3') and CLTCODE = @CLTCODE      
      
AND VDT >=@FROMDATE  AND VDT<=@TODATE + ' 23:59'       
      
UNION ALL      
      
SELECT distinct 'NSEFO' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT      
      
FROM [10.253.33.239].ACCOUNTFO.DBO.LEDGER A JOIN [10.253.33.239].NSEFO.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE      
      
WHERE a.VTYP IN ('2','3') and CLTCODE  = @CLTCODE      
      
AND VDT >=@FROMDATE  AND VDT<=@TODATE + ' 23:59'       
      
UNION ALL      
      
SELECT distinct 'NSX' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT      
      
FROM [10.253.33.239].ACCOUNTCURFO.DBO.LEDGER A JOIN [10.253.33.239].NSECURFO.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE      
      
WHERE a.VTYP IN ('2','3') and CLTCODE  = @CLTCODE      
      
AND VDT >=@FROMDATE  AND VDT<=@TODATE + ' 23:59'       
      
UNION ALL      
      
SELECT distinct 'MCDXCDX' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT      
      
FROM [10.253.33.239].ACCOUNTMCDXCDS.DBO.LEDGER A JOIN [10.253.33.239].MCDXCDS.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE      
      
WHERE a.VTYP IN ('2','3') and CLTCODE  = @CLTCODE      
      
AND VDT >=@FROMDATE  AND VDT<=@TODATE + ' 23:59'       
      
UNION ALL      
      
SELECT distinct 'MCDX' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT      
      
FROM [10.253.33.240].ACCOUNTMCDX.DBO.LEDGER A JOIN [10.253.33.240].MCDX.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE      
      
WHERE a.VTYP IN ('2','3') and CLTCODE  = @CLTCODE      
      
AND VDT >=@FROMDATE  AND VDT<=@TODATE + ' 23:59'       
      
UNION ALL      
      
SELECT distinct 'NCDX' AS EXCHANGE,A.CLTCODE,a.ACNAME,B.REGION,B.BRANCH_CD,b.Sub_Broker,a.vtyp,A.DRCR,A.VDT,A.VNO,A.VAMT      
      
FROM [10.253.33.240].ACCOUNTNCDX.DBO.LEDGER A JOIN [10.253.33.240].NCDX.DBO.CLIENT1 B ON A.CLTCODE = B.CL_CODE      
      
WHERE a.VTYP IN ('2','3') and CLTCODE  = @CLTCODE      
      
AND VDT >=@FROMDATE  AND VDT<=@TODATE + ' 23:59'       
      
      
      
      
      
      
      
      
      
) A ORDER BY EXCHANGE      
      
      
      
END

GO
