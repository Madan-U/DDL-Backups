-- Object: PROCEDURE dbo.MANDATE_DATA_KYC
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

 CREATE PROCEDURE [dbo].[MANDATE_DATA_KYC]
 (
 @DATE VARCHAR(20)
 )
 AS 
 BEGIN
 
 
 
SELECT A.cl_code,long_name,EMAIL,mobile_pager,Exchange,SEGMENT,Active_Date,InActive_From,Deactive_Remarks,Deactive_value,
branch_cd,sub_broker,REGION---,(CASE WHEN B2C='Y'THEN 'B2C'ELSE 'B2B'END)AS B2B_B2C,COMB_LAST_DATE
INTO  #CLI2
 FROM  CLIENT_DETAILS A,CLIENT_BROK_DETAILS B
WHERE A.cl_code=B.Cl_Code
AND EMAIL<>'' AND mobile_pager<>''
AND InActive_From<=GETDATE() AND Deactive_Remarks LIKE '%Mandatory%'



SELECT A.cl_code,long_name,EMAIL,mobile_pager,Exchange,SEGMENT,Active_Date,InActive_From,Deactive_Remarks,Deactive_value,
branch_cd,sub_broker,REGION---,(CASE WHEN B2C='Y'THEN 'B2C'ELSE 'B2B'END)AS B2B_B2C,COMB_LAST_DATE
INTO  #CLI1
 FROM  CLIENT_DETAILS A,CLIENT_BROK_DETAILS B
WHERE A.cl_code=B.Cl_Code
AND EMAIL<>'' AND mobile_pager<>''
AND InActive_From<=GETDATE() AND Deactive_Remarks LIKE '%Mandatary%'

SELECT A.cl_code,long_name,EMAIL,mobile_pager,Exchange,SEGMENT,Active_Date,InActive_From,Deactive_Remarks,Deactive_value,
branch_cd,sub_broker,REGION---,(CASE WHEN B2C='Y'THEN 'B2C'ELSE 'B2B'END)AS B2B_B2C,COMB_LAST_DATE
INTO  #CLI3
 FROM  CLIENT_DETAILS A,CLIENT_BROK_DETAILS B
WHERE A.cl_code=B.Cl_Code
AND EMAIL<>'' AND mobile_pager<>''
AND InActive_From<=GETDATE() AND Deactive_Remarks LIKE '%MANDATE%'

SELECT * INTO #FIN FROM #CLI1
UNION ALL
SELECT * FROM #CLI2
UNION ALL
SELECT * FROM #CLI3

SELECT A.*,CLIENT_CODE ,STATUS AS DP_STATUS INTO #DP FROM #FIN A
LEFT OUTER JOIN
AGMUBODPL3.DMAT.CITRUS_USR.TBL_CLIENT_MASTER B
ON A.CL_cODE=B.NISE_PARTY_CODE

 SELECT * into #HOLD21  FROM  AGMUBODPL3.DMAT.dbo.holdingdata  WHERE HLD_HOLD_DATE =@DATE
  
  SELECT * INTO #CLOSIN11 FROM  AGMUBODPL3.DMAT.CITRUS_USR.VW_ISIN_RATE_MASTER A,
  (SELECT ISIN AS ISIN_NO,MAX(RATE_DATE) RATE  FROM  AGMUBODPL3.DMAT.CITRUS_USR.VW_ISIN_RATE_MASTER WHERE  RATE_DATE <=@DATE GROUP BY ISIN )B
  WHERE A.ISIN=B.ISIN_NO  AND A.RATE_DATE =B.RATE 

  
 
 SELECT HLD_AC_CODE,SUM(HLD_AC_POS*CLOSE_PRICE)VALUE into #holding_aug  FROM #HOLD21 H, #CLOSIN11 WHERE ISIN=HLD_ISIN_CODE
 ---and HLD_AC_CODE='1203320005663611'
   GROUP BY HLD_AC_CODE
   
   
   SELECT A.*,VALUE into #dpfin FROM #DP A
   LEFT OUTER JOIN
   #holding_aug B
   ON A.CLIENT_cODE=B.HLD_AC_CODE
   
   select a.*,(CASE WHEN B2C='Y'THEN 'B2C'ELSE 'B2B'END)AS B2B_B2C,COMB_LAST_DATE from #dpfin a
   left outer join
   INTRANET.risk.dbo.client_details b
   on a.cl_code=b.cl_Code
   END

GO
