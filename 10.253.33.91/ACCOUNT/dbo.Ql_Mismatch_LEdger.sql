-- Object: PROCEDURE dbo.Ql_Mismatch_LEdger
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE  PROC [dbo].[Ql_Mismatch_LEdger] (  
@fdate VARCHAR(11),  
@tdate VARCHAR(11))  
AS  
SELECT Party_Code,Party_Name,Scrip_Cd,Isin,Exchange,sum(NETQTY) as NETQTY  INTO #T  
FROM   
(select Party_Code ,Party_Name,Scrip_Cd,Series,DPId,ClientId,Isin,Sett_No,Sett_Type,  
HoldQty,PledgeQty,Qty NETQTY,  
CONVERT(VARCHAR(11),GETDATE(),120) PROCESS_DATE ,'BSE' AS EXCHANGE      
--Into zzpbseholding1            
from [AngelDemat].HOLDINGCSV.DBO.P_holdingcsv_livebse WITH(NOLOCK)    
UNION ALL  
  
select Party_Code ,Party_Name,Scrip_Cd,DPId,ClientId,Series,Isin,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty NETQTY,  
CONVERT(VARCHAR(11),GETDATE(),120) PROCESS_DATE ,'NSE' AS EXCHANGE        
--Into zzpbseholding1            
from   [AngelDemat].HOLDINGCSV.DBO.P_HoldingCSV_LiveNSE WITH(NOLOCK)) A WHERE party_code NOT LIKE '05%'  
GROUP BY Party_Code,Party_Name,Scrip_Cd,isin,EXCHANGE  
ORDER BY Party_Code ,Scrip_Cd  
  
  
  
SELECT ( CASE WHEN A.party_code LIKE '98%' THEN PARENTCODE ELSE cl_code END ) party_code,  
Party_Name,Scrip_Cd,Isin,Exchange,NETQTY INTO #T2 FROM #T AS A  
LEFT OUTER JOIN   
MSAJAG.DBO.CLIENT_DETAILS AS B  
ON A.PARTY_CODE =B.cl_code  
  
  
--SELECT Party_Code,Party_Name,Scrip_Cd,Isin,Exchange,sum(NETQTY) as NETQTY  FROM #T2  
--GROUP BY Party_Code,Party_Name,Scrip_Cd,Isin,Exchange  
--ORDER BY Party_Code  
  
--- Drop Table #t3  
  
SELECT * INTO #T3  FROM (  
Select party_code,scrip_cd,certno,SUM(qty) as PAYINqty,'NSE' AS EXCHANGE from [AngelDemat].msajag.dbo.deltrans x (nolock)   
where drcr ='d' and transdate >= CONVERT(VARCHAR(11),@fdate,120) and transdate <= CONVERT(VARCHAR(11),@tdate,120)+' 23:59' and Delivered <> 'G' and TrType = 1000  
group by party_code,scrip_cd,certno  
union all  
Select party_code,scrip_cd,certno,SUM(qty) as PAYINqty ,'BSE' AS EXCHANGE from [AngelDemat].BSEDB.DBO.deltrans x (nolock)   
where drcr ='d' and transdate >= CONVERT(VARCHAR(11),@fdate,120) and transdate <= CONVERT(VARCHAR(11),@tdate,120)+' 23:59' and Delivered <> 'G' and TrType = 1000  
group by party_code,scrip_cd,certno )A  
  
--  
  
  
SELECT Party_Code,Scrip_Cd,Isin,SUM(NETQTY) AS QTY,Exchange INTO #T6 FROM (  
SELECT  party_code,scrip_cd,certno AS ISIN, PAYINqty AS NETQTY ,EXCHANGE FROM #T3   
UNION ALL  
SELECT Party_Code,Scrip_Cd,Isin,NETQTY,Exchange FROM #T2 )A  
GROUP BY Party_Code,Scrip_Cd,Isin,Exchange  
  
--Select Segment,Party_code,Scrip_cd,CertNo as ISIN,Sum(CQTY-Dqty) as Net  
-- from PRADNYA.DBO.V2_CLASS_QUARTERLYSECLEDGER  
-- where Reason = 'Closing Balance'  
--group by Segment,Party_code,Scrip_cd,CertNo   
-- Drop table #t9  
  
Select x.party_code,x.Segment,x.Scrip_cd,x.ISIN,x.Net as QL_Hold,isnull(y.Hold,0) as BO_hold,  
Ctyp = case       
when x.party_code = y.partycode and x.scrip_cd = y.ScrpCode and x.ISIN = y.ISIN and x.Net = y.Hold then 'Match'      
when x.party_code = y.partycode and y.ScrpCode is null then 'Mismatch'       
when x.party_code = y.partycode and x.scrip_cd = y.ScrpCode and x.ISIN = y.ISIN and x.net <> y.Hold then 'MisMatch in Qty'      
else 'Misssing'      
 end into #T9  
from       
(Select Segment,Party_code,Scrip_cd,CertNo as ISIN,Sum(CQTY-Dqty) as Net  
 from AngelBSECM.PRADNYA.DBO.V2_CLASS_QUARTERLYSECLEDGER WITH (NOLOCK)  
 where Reason = 'Closing Balance'   
group by Segment,Party_code,Scrip_cd,CertNo )x      
left outer join      
(Select PARTY_CODE AS  partycode,EXCHANGE AS Segment,SCRIP_CD AS ScrpCode,ISIN,QTY AS Hold FROM #T6 with(nolock) )y      
on x.Party_Code = y.Partycode   
and x.Segment = REPLACE(REPLACE(y.Segment,'NSE','NSECM'),'BSE','BSECM') and x.Scrip_cd = y.ScrpCode and x.ISIN = y.ISIN     
Order by Party_Code,Scrip_cd,ISIN  
  
  
  
--SELECT * FROM    
--insert into q3HOLD  
--select * into q3HOLD FROM #T6  
  
--drop table q3HOLD  
  
--- UPDATE #T6 SET PARTY_CODE = 'N33861' WHERE PARTY_CODE = '98N33861' -- 18  
  
  
--Select PARTY_CODE,EXCHANGE,SCRIP_CD,ISIN,SUM(QTY) AS Hold FROM #T6 with(nolock)  
--where EXCHANGE = 'NSE' AND party_code not like '05%'  
--GROUP BY PARTY_CODE,EXCHANGE,SCRIP_CD,ISIN  
--Order by Party_Code,Scrip_cd,ISIN  
  
--Select * from pradnya..V2_CLASS_QUARTERLYSECLEDGER (nolock) where PARTY_CODE = 'CP4142'  
  
  
SELECT * FROM #T9 WHERE Ctyp <> 'Match'  
Order by SEGMENT,PARTY_CODE,scrip_cd  
-- party_code = 'N33861'  
  
  
---SELECT * FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS WITH (NOLOCK) WHERE cl_code = '98N33861'

GO
