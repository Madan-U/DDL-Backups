-- Object: PROCEDURE dbo.DP_RECOVERY_DATA
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

---DP_RECOVERY_DATA 'nov  1 2019','oct 31 2020'  
  
CREATE PROCEDURE [dbo].[DP_RECOVERY_DATA]  
  
(  
  
   
  
@Fdate varchar(15)  ,  
  
@Tdate varchar(15)    
  
  
  
)  
  
AS  
  
BEGIN  
  
   
  
DECLARE @FromDate DATETIME=CAST(@Fdate  AS DATETIME)  
  
DECLARE @ToDate DATETIME=dateadd(ms, -3, (dateadd(day, +1, convert(varchar, @Tdate, 101))))--DATEADD(DD, -1, DATEADD(D, 1, CONVERT(DATETIME2, @Tdate)))   
  
  
  
SELECT NISE_PARTY_CODE,CLIENT_CODE,FIRST_HOLD_NAME,  
STATUS,ACTIVE_DATE,TEMPLATE_CODE  
INTO #TEMP  
 FROM TBL_CLIENT_MASTER WHERE ACTIVE_DATE>=@FromDate  
AND ACTIVE_DATE<=@ToDate  
  
SELECT NISE_PARTY_cODE,A.CLIENT_CODE,FIRST_HOLD_NAME,STATUS,ACTIVE_DATE,TEMPLATE_CODE,B.Actual_amount INTO #TEMP3 FROM #TEMP A  
LEFT OUTER JOIN   
DMAT.CITRUS_USR.Vw_Acc_Curr_Bal B  
ON A.CLIENT_CODE=B.CLIENT_CODE  
  
SELECT NISE_PARTY_cODE,A.CLIENT_CODE,FIRST_HOLD_NAME,A.STATUS,ACTIVE_DATE,TEMPLATE_CODE,Actual_amount,b2c =case when b2c='y' then 'B2C' ELSE 'B2B' end
 
  FROM #TEMP3 A  
LEFT OUTER JOIN   
 INTRANET.risk.dbo.client_details B  
 ON A.NISE_PARTY_CODE=B.CL_CODE  
   
 End

GO
