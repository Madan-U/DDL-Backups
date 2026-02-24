-- Object: PROCEDURE dbo.NEW_CLIENT_TRADE_REVERSAL_ALLSEG
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
      
---select  * from [MIS].kyc.dbo.vw_ReActStock_Campaign      
---NEW_CLIENT_TRADE_REVERSAL '2019-07-25' ,'48'      
CREATE PROCEDURE [dbo].[NEW_CLIENT_TRADE_REVERSAL_ALLSEG]      
(@SDATE DATETIME , @TIMELIMIT INT )      
AS      
BEGIN       
      
DECLARE @DAY INT      
SET @DAY = @TIMELIMIT/24       
      
      
SET @DAY = (CASE WHEN  @DAY=1 THEN 0 ELSE @DAY END)      
      
DECLARE @PREVDATE DATETIME ,@CURDATE DATETIME      
       
SELECT @CURDATE = MAX(START_DATE)   FROM SETT_MST WHERE START_DATE < = @SDATE  AND SETT_TYPE ='N'      
      
SELECT @PREVDATE=MAX(START_DATE)  FROM SETT_MST WHERE START_DATE < = @SDATE-@DAY  AND SETT_TYPE ='N'      
      
SELECT CLIENTCODE INTO #CLIENT FROM [MIS].KYC.DBO.vw_Campaign_scratchcard   WHERE CreationDate >=@PREVDATE       
AND CreationDate <=@CURDATE + ' 23:59'    --AND TimeLimitInHour =@TIMELIMIT      
      
SELECT  PARTY_cODE,Total_turnover=sum(DELAMT) ,SAUDA_DATE      
INTO #TURNOVER      
FROM CMBILLVALAN WHERE CONVERT(VARCHAR(10),SAUDA_DATE,120)=@SDATE --AND CONVERT(VARCHAR(10),SAUDA_DATE,120) <=      
 --AND PARTY_cODE='DIYD10477'      
 AND PARTY_CODE IN (SELECT * FROM #CLIENT)      
 AND SCRIP_CD NOT IN ('BROKERAGE','BRKSCR')      
 GROUP BY PARTY_cODE,SAUDA_DATE      
 UNION      
 SELECT PARTY_cODE,Total_turnover=sum(DELAMT),SAUDA_DATE      
  FROM [AngelBSECM].BSEDB_AB.DBO.CMBILLVALAN WHERE CONVERT(VARCHAR(10),SAUDA_DATE,120)=@SDATE       
 --AND PARTY_cODE='MA99'      
 AND PARTY_CODE  IN (SELECT * FROM #CLIENT)      
 AND SCRIP_CD NOT IN ('BROKERAGE','BRKSCR')      
 GROUP BY PARTY_cODE,SAUDA_DATE      
  UNION      
 SELECT PARTY_cODE,      
(Sum(Case When (inst_type like 'FUT%' AND auctionpart <> 'CA' )       
Then IsNull(prate*pqty + srate*sqty,0) Else 0 End)) + (Sum(Case When (inst_type like 'OPT%' AND auctionpart <> 'CA' )       
Then IsNull((prate+strike_Price)*pqty + (srate+strike_price)*sqty,0) Else 0 End))  AS TOTAL_TURNOVER,SAUDA_DATE       
FROM [AngelFO].NSEFO.DBO.FoBillValan A With (nolock) , [AngelFO].NSEFO.DBO.Client1 B       
 WHERE A.tradetype = 'BT' AND A.inst_type IN ('FUTIDX','FUTSTK','OPTIDX','OPTSTK')      
 AND A.PARTY_CODE  IN (SELECT * FROM #CLIENT)      
--AND option_type LIKE '%' AND Left(Convert(VarChar,expirydate,109),11) LIKE '%'       
--AND symbol LIKE '%' AND  isnull(party_code,'') >= '00100857' AND  isnull(party_code,'') <= '00100857'       
and A.PARTY_CODE=b.Cl_Code      
AND CONVERT(VARCHAR(10),A.SAUDA_DATE,120)= @SDATE      
GROUP BY PARTY_cODE,SAUDA_DATE      
UNION       
SELECT PARTY_CODE,      
(Sum(Case When (inst_type like 'FUT%' AND auctionpart <> 'CA' )       
Then IsNull(prate*pqty + srate*sqty,0) Else 0 End)) + (Sum(Case When (inst_type like 'OPT%' AND auctionpart <> 'CA' )       
Then IsNull((prate+strike_Price)*pqty + (srate+strike_price)*sqty,0) Else 0 End))  AS TOTAL_TURNOVER, SAUDA_DATE      
FROM [AngelFO].NSECURFO.DBO.FoBillValan A With (nolock) , [AngelFO].NSECURFO.DBO.Client1 B       
 WHERE A.tradetype = 'BT' AND A.inst_type IN ('FUTCUR','FUTIRC','OPTCUR')      
 AND A.PARTY_CODE  IN (SELECT * FROM #CLIENT)      
--AND option_type LIKE '%' AND Left(Convert(VarChar,expirydate,109),11) LIKE '%'       
--AND symbol LIKE '%' AND  isnull(party_code,'') >= '00100857' AND  isnull(party_code,'') <= '00100857'       
AND CONVERT(VARCHAR(10),A.SAUDA_DATE,120)= @SDATE      
and A.PARTY_CODE=b.Cl_Code      
GROUP BY PARTY_cODE,SAUDA_DATE      
UNION      
SELECT PARTY_CODE,      
(Sum(Case When (inst_type like 'FUT%' AND auctionpart <> 'CA' )       
Then IsNull(prate*pqty + srate*sqty,0) Else 0 End)) + (Sum(Case When (inst_type like 'OPT%' AND auctionpart <> 'CA' )       
Then IsNull((prate+strike_Price)*pqty + (srate+strike_price)*sqty,0) Else 0 End))  AS TOTAL_TURNOVER,SAUDA_DATE       
FROM [AngelCommodity].MCDX.DBO.FoBillValan A With (nolock) , [AngelCommodity].MCDX.DBO.Client1 B        
WHERE A.tradetype = 'BT' AND A.inst_type IN ('FUTCOM','OPTFUT')      
AND A.PARTY_CODE  IN (SELECT * FROM #CLIENT)      
--AND option_type LIKE '%' AND Left(Convert(VarChar,expirydate,109),11) LIKE '%'       
--AND symbol LIKE '%' AND  isnull(party_code,'') >= '00100857' AND  isnull(party_code,'') <= '00100857'       
AND CONVERT(VARCHAR(10),A.SAUDA_DATE,120)= @SDATE      
and A.PARTY_CODE=b.Cl_Code      
--AND 1=1        
GROUP BY PARTY_cODE,SAUDA_DATE      
UNION      
SELECT PARTY_CODE,      
(Sum(Case When (inst_type like 'FUT%' AND auctionpart <> 'CA' )       
Then IsNull(prate*pqty + srate*sqty,0) Else 0 End)) + (Sum(Case When (inst_type like 'OPT%' AND auctionpart <> 'CA' )       
Then IsNull((prate+strike_Price)*pqty + (srate+strike_price)*sqty,0) Else 0 End))  AS TOTAL_TURNOVER,SAUDA_DATE       
FROM [AngelCommodity].NCDX.DBO.FoBillValan A With (nolock) , [AngelCommodity].NCDX.DBO.Client1 B       
 WHERE A.tradetype = 'BT' AND A.inst_type IN ('FUTCOM','OPTFUT')      
 AND A.PARTY_CODE  IN (SELECT * FROM #CLIENT)      
--AND option_type LIKE '%' AND Left(Convert(VarChar,expirydate,109),11) LIKE '%'       
--AND symbol LIKE '%' AND  isnull(party_code,'') >= '00100857' AND  isnull(party_code,'') <= '00100857'       
AND CONVERT(VARCHAR(10),A.SAUDA_DATE,120)= @SDATE      
and A.PARTY_CODE=b.Cl_Code      
--AND 1=1        
GROUP BY PARTY_cODE,SAUDA_DATE      
      
 SELECT PARTY_cODE,Total_turnover,(CASE WHEN Total_turnover>100 THEN'100'ELSE Total_turnover END)AS REVERSAL_AMOUNT       
 FROM #TURNOVER      
       
 END

GO
