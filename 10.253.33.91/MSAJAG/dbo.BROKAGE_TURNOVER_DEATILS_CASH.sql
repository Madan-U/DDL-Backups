-- Object: PROCEDURE dbo.BROKAGE_TURNOVER_DEATILS_CASH
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE PROC [dbo].[BROKAGE_TURNOVER_DEATILS_CASH]
(
	 @PARTY_CODE VARCHAR(20),
	 @Sauda_date VARCHAR(11)
)
AS


select CONVERT(VARCHAR(11),SAUDA_DATE,120) as Sauda_date ,PARTY_CODE, Trading_Turnover=sum(trdamt-delamt),
 Delivery_Turnover=sum(delamt),
 Total_turnover=sum(trdamt-delamt)+ sum(delamt),TOTALBROKRAGE = SUM(PBrokTrd+SBrokTrd+PBrokDel+SBrokDel) ,SEGMENT='NSECM'
   INTO #DATA
   from CMBILLVALAN
where Sauda_date   >= @Sauda_date and sauda_date <= @Sauda_date + ' 23:59:59'
  AND PARTY_CODE = @PARTY_CODE
group by PARTY_CODE,CONVERT(VARCHAR(11),SAUDA_DATE,120) 
UNION
select CONVERT(VARCHAR(11),SAUDA_DATE,120) as Sauda_date ,PARTY_CODE, Trading_Turnover=sum(trdamt-delamt),
 Delivery_Turnover=sum(delamt),
 Total_turnover=sum(trdamt-delamt)+ sum(delamt),TOTALBROKRAGE = SUM(PBrokTrd+SBrokTrd+PBrokDel+SBrokDel) ,SEGMENT='BSECM'
   from AngelBSECM.BSEDB_AB.DBO.CMBILLVALAN
where Sauda_date   >= @Sauda_date and sauda_date <= @Sauda_date + ' 23:59:59'
  AND PARTY_CODE =  @PARTY_CODE
group by PARTY_CODE,CONVERT(VARCHAR(11),SAUDA_DATE,120) 
order by PARTY_CODE


select B.*,ORDER_NO  INTO #FINAL from settlement A with (nolock),#DATA B
WHERE CONVERT(VARCHAR(10),A.Sauda_date,120) = CONVERT(VARCHAR(11),B.Sauda_date,120) 
AND A.Party_Code =B.PARTY_CODE
AND SEGMENT ='NSECM'
AND sett_type not in ( 'A','X','BX','TX','DX')
UNION
select B.*,ORDER_NO from History A with (nolock),#DATA B
WHERE CONVERT(VARCHAR(10),A.Sauda_date,120) = CONVERT(VARCHAR(11),B.Sauda_date,120) 
AND A.Party_Code =B.PARTY_CODE
AND SEGMENT ='NSECM'
AND sett_type not in ( 'A','X','BX','TX','DX')
UNION
select B.*,ORDER_NO  from AngelBSECM.BSEDB_AB.DBO.settlement A with (nolock),#DATA B
WHERE CONVERT(VARCHAR(10),A.Sauda_date,120) = CONVERT(VARCHAR(11),B.Sauda_date,120) 
AND A.Party_Code =B.PARTY_CODE
AND SEGMENT ='BSECM'
AND sett_type not in ( 'AD','AC','OB','TK','DL')  
UNION 
select B.*,ORDER_NO   from AngelBSECM.BSEDB_AB.DBO.History A with (nolock),#DATA B
WHERE CONVERT(VARCHAR(10),A.Sauda_date,120) = CONVERT(VARCHAR(11),B.Sauda_date,120) 
AND A.Party_Code =B.PARTY_CODE
AND SEGMENT ='BSECM'
AND sett_type not in ( 'AD','AC','OB','TK','DL')  


SELECT DISTINCT * FROM #FINAL 

DROP TABLE #FINAL
DROP TABLE #DATA

GO
