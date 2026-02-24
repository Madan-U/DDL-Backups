-- Object: PROCEDURE dbo.NEW_CLIENT_TRADE_REVERSAL
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
---select  * from [MIS].kyc.dbo.vw_ReActStock_Campaign  
---NEW_CLIENT_TRADE_REVERSAL '2019-07-25' ,'48'  
CREATE PROCEDURE [dbo].[NEW_CLIENT_TRADE_REVERSAL]  
(@SDATE DATETIME , @TIMELIMIT INT )  
AS  
DECLARE @DAY INT  
SET @DAY = @TIMELIMIT/24   
  
  
SET @DAY = (CASE WHEN  @DAY=1 THEN 0 ELSE @DAY END)  
  
DECLARE @PREVDATE DATETIME ,@CURDATE DATETIME  
   
SELECT @CURDATE = MAX(START_DATE)   FROM SETT_MST WHERE START_DATE < = @SDATE  AND SETT_TYPE ='N'  
  
SELECT @PREVDATE=MAX(START_DATE)  FROM SETT_MST WHERE START_DATE < = @SDATE-@DAY  AND SETT_TYPE ='N'  
  
SELECT CLIENTCODE INTO #CLIENT FROM [MIS].KYC.DBO.vw_ReActStock_Campaign   WHERE CreationDate >=@PREVDATE   
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
  
   
  
 SELECT PARTY_cODE,Total_turnover,(CASE WHEN Total_turnover>100 THEN'100'ELSE Total_turnover END)AS REVERSAL_AMOUNT   
 FROM #TURNOVER

GO
