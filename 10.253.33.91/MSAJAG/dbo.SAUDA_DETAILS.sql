-- Object: PROCEDURE dbo.SAUDA_DETAILS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
  
--SAUDA_DETAILS 'MAY  1 2019','JUN 29 2019'  
--SELECT DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)  
  
CREATE PROCEDURE [dbo].[SAUDA_DETAILS]  
   
AS  
BEGIN  
   
----  
DECLARE @FromDate date=DATEADD(day,-2,getdate() )  
DECLARE @ToDate DATETIME=GETDATE()---DATEADD(MS, -1, DATEADD(D, 1, CONVERT(DATETIME2, @TDATE)))    
  
  
SELECT   
'NSE'AS EXCHANGE,'CASH'AS SEGMENT,A.PARTY_CODE,PARTY_NAME,A.branch_cd, A.sub_broker,b2c =case when b2c='y' then 'B2C' ELSE 'B2B' end,SAUDA_DATE,SCRIP_CD,SCRIP_NAME,Isin,  
PTradedqty = Sum(PQtyTrd + PQtyDel),  
PtradedAmt = Sum(PAmtTrd + PAmtDel) ,  
PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) ,   
PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) ,   
BillPamt = Sum(Pamt),  
STradedQty = Sum(SQtyTrd + SQtyDel),   
 STradedAmt = Sum(SAmtTrd + SAmtDel),   
 SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),    
 SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   
 BillSAmt = Sum(Samt) ,   
 TrdAmt= Sum(TrdAmt),   
 DelAmt=Sum(DelAmt),  
 TOTALBROKRAGE =SUM(PBrokTrd+SBrokTrd+PBrokDel+SBrokDel),  
 Total_turnover=sum(trdamt-delamt)+ sum(delamt)  
  
 FROM CMBILLVALAN  A,INTRANET.RISK.DBO.CLIENT_DETAILS B WHERE SAUDA_DATE>='2018-05-01'  
AND A.PARTY_CODE IN (SELECT * FROM CLIENT_DND)   
AND ISIN IN (SELECT * FROM ISIN_DND)  
AND A.PARTY_CODE=B.CL_CODE  
AND SAUDA_DATE>=@FromDate   
AND SAUDA_DATE<=@ToDate  
  
GROUP BY A.PARTY_CODE,PARTY_NAME,A.branch_cd, A.sub_broker,SAUDA_DATE,SCRIP_CD,SCRIP_NAME,Isin,B2C  
UNION   
SELECT   
'BSE'AS EXCHANGE,'CASH'AS SEGMENT,A.PARTY_CODE,PARTY_NAME,A.branch_cd, A.sub_broker,b2c =case when b2c='y' then 'B2C' ELSE 'B2B' end,SAUDA_DATE,SCRIP_CD,SCRIP_NAME,Isin,  
PTradedqty = Sum(PQtyTrd + PQtyDel),  
PtradedAmt = Sum(PAmtTrd + PAmtDel) ,  
PMarketrate = ( Sum(PRate) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) ,   
PNetrate = ( Sum(PAmtTrd + PamtDel) / Case When Sum(PQtyTrd + PQtyDel) > 0 Then Sum(PQtyTrd + PQtyDel) Else 1 End) ,   
  
BillPamt = Sum(Pamt),  
STradedQty = Sum(SQtyTrd + SQtyDel),    
 STradedAmt = Sum(SAmtTrd + SAmtDel),   
 SMarketrate = ( Sum(SRate) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),    
 SNetrate = ( Sum(SAmtTrd+SAmtDel) / (Case When Sum(SQtyTrd + SQtyDel) > 0 Then Sum(SQtyTrd + SQtyDel) Else 1 End ) ),   
 BillSAmt = Sum(Samt) ,   
  
 TrdAmt= Sum(TrdAmt),   
 DelAmt=Sum(DelAmt),  
 TOTALBROKRAGE =SUM(PBrokTrd+SBrokTrd+PBrokDel+SBrokDel),  
 Total_turnover=sum(trdamt-delamt)+ sum(delamt)  
  
 FROM [AngelBSECM].BSEDB_AB.DBO.CMBILLVALAN A ,INTRANET.RISK.DBO.CLIENT_DETAILS B WHERE SAUDA_DATE>='2018-05-01'  
AND A.PARTY_CODE IN (SELECT * FROM CLIENT_DND)   
AND ISIN IN (SELECT * FROM ISIN_DND)  
AND A.PARTY_CODE=B.CL_CODE  
AND SAUDA_DATE>=@FromDate   
AND SAUDA_DATE<=@ToDate  
  
GROUP BY A.PARTY_CODE,PARTY_NAME,A.branch_cd,A.sub_broker,SAUDA_DATE,SCRIP_CD,SCRIP_NAME,Isin,B2C  
END

GO
