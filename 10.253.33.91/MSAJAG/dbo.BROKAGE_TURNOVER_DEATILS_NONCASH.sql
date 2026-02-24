-- Object: PROCEDURE dbo.BROKAGE_TURNOVER_DEATILS_NONCASH
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
CREATE PROC [dbo].[BROKAGE_TURNOVER_DEATILS_NONCASH]  
(  
  @PARTY_CODE VARCHAR(20),  
  @Sauda_date VARCHAR(11)  
)  
AS  
  
---EXEC BROKAGE_TURNOVER_DEATILS_NONCASH 'A118320','APR 24 2019'  
  
 SELECT Sauda_date ,party_code,futurestradedvalue , optionstradedvalue , excercisevalue , assignmentvalue ,  
 closeoutvalue ,SUM (futurestradedvalue + optionstradedvalue + excercisevalue + assignmentvalue + closeoutvalue) as TOTAL_TURNOVER ,brokerage,SEGMENT='NSEFO'  
  INTO #DATA  
  FROM (  
 SELECT CONVERT(VARCHAR(11),SAUDA_DATE,120) as Sauda_date ,  
 party_code,  
 (Sum(Case When inst_type LIKE 'FUT%' AND auctionpart <> 'EA'    
 AND auctionpart <> 'CA' Then IsNull(prate*pqty + srate*sqty,0) Else 0 End)) AS futurestradedvalue,  
 (Sum(Case When inst_type LIKE 'OPT%' AND auctionpart <> 'CA' AND auctionpart <> 'EA'  
 --Then ((pqty+sqty)*strike_price) Else 0 End)) AS optionstradedvalue,  
 Then (((pqty*prate)+(sqty*srate))) Else 0 End)) AS optionstradedvalue,  
 (Sum(Case When (inst_type LIKE 'opt%' AND auctionpart <> 'CA' AND auctionpart = 'EA')  
 Then (SQTY*STRIKE_PRICE) Else 0 End)) AS excercisevalue,  
 (Sum(Case When (inst_type like 'Opt%' AND auctionpart<> 'CA' AND auctionpart = 'EA')  
 Then (PQTY*STRIKE_PRICE) Else 0 End)) AS assignmentvalue,  
 (Sum(Case When inst_type LIKE 'FUT%' AND auctionpart = 'EA' AND auctionpart <> 'CA'  
 Then IsNull(prate*pqty + srate*sqty,0) Else 0 End)) AS closeoutvalue,  
 Sum(pbrokamt + sbrokamt) AS brokerage  
 FROM ANGELFO.NSEFO.DBO.FoBillValan A With (nolock)  WHERE A.tradetype = 'BT' --AND A.inst_type IN ('FUTIDX','FUTSTK','OPTIDX','OPTSTK')  
 and a.Sauda_date  >= @Sauda_date and sauda_date <= @Sauda_date + ' 23:59:59'   
 AND PARTY_CODE = @PARTY_CODE  
 Group By Sauda_date, party_code  
 ) acoount  
 Group By Sauda_date, party_code,futurestradedvalue ,brokerage,  
 optionstradedvalue , excercisevalue , assignmentvalue , closeoutvalue  
 UNION  
 SELECT Sauda_date ,party_code,futurestradedvalue , optionstradedvalue , excercisevalue , assignmentvalue ,  
 closeoutvalue ,SUM (futurestradedvalue + optionstradedvalue + excercisevalue + assignmentvalue + closeoutvalue) as TOTAL_TURNOVER ,brokerage,SEGMENT='NSX'  
  FROM (  
 SELECT CONVERT(VARCHAR(11),SAUDA_DATE,120) as Sauda_date ,  
 party_code,  
 (Sum(Case When inst_type LIKE 'FUT%' AND auctionpart <> 'EA'    
 AND auctionpart <> 'CA' Then IsNull(prate*pqty + srate*sqty,0) Else 0 End)) AS futurestradedvalue,  
 (Sum(Case When inst_type LIKE 'OPT%' AND auctionpart <> 'CA' AND auctionpart <> 'EA'  
 --Then ((pqty+sqty)*strike_price) Else 0 End)) AS optionstradedvalue,  
 Then (((pqty*prate)+(sqty*srate))) Else 0 End)) AS optionstradedvalue,  
 (Sum(Case When (inst_type LIKE 'opt%' AND auctionpart <> 'CA' AND auctionpart = 'EA')  
 Then (SQTY*STRIKE_PRICE) Else 0 End)) AS excercisevalue,  
 (Sum(Case When (inst_type like 'Opt%' AND auctionpart<> 'CA' AND auctionpart = 'EA')  
 Then (PQTY*STRIKE_PRICE) Else 0 End)) AS assignmentvalue,  
 (Sum(Case When inst_type LIKE 'FUT%' AND auctionpart = 'EA' AND auctionpart <> 'CA'  
 Then IsNull(prate*pqty + srate*sqty,0) Else 0 End)) AS closeoutvalue,  
 Sum(pbrokamt + sbrokamt) AS brokerage  
 FROM ANGELFO.NSECURFO.DBO.FoBillValan A With (nolock)  WHERE A.tradetype = 'BT' --AND A.inst_type IN ('FUTIDX','FUTSTK','OPTIDX','OPTSTK')  
 and a.Sauda_date  >= @Sauda_date and sauda_date <= @Sauda_date + ' 23:59:59'  
 AND PARTY_CODE = @PARTY_CODE  
 Group By Sauda_date, party_code  
 ) acoount  
 Group By Sauda_date, party_code,futurestradedvalue ,brokerage,  
 optionstradedvalue , excercisevalue , assignmentvalue , closeoutvalue  
 UNION  
 SELECT Sauda_date ,party_code,futurestradedvalue , optionstradedvalue , excercisevalue , assignmentvalue ,  
 closeoutvalue ,SUM (futurestradedvalue + optionstradedvalue + excercisevalue + assignmentvalue + closeoutvalue) as TOTAL_TURNOVER ,brokerage,SEGMENT='MCX'  
  FROM (  
 SELECT CONVERT(VARCHAR(11),SAUDA_DATE,120) as Sauda_date ,  
 party_code,  
 (Sum(Case When inst_type LIKE 'FUT%' AND auctionpart <> 'EA'    
 AND auctionpart <> 'CA' Then IsNull(prate*pqty + srate*sqty,0) Else 0 End)) AS futurestradedvalue,  
 (Sum(Case When inst_type LIKE 'OPT%' AND auctionpart <> 'CA' AND auctionpart <> 'EA'  
 --Then ((pqty+sqty)*strike_price) Else 0 End)) AS optionstradedvalue,  
 Then (((pqty*prate)+(sqty*srate))) Else 0 End)) AS optionstradedvalue,  
 (Sum(Case When (inst_type LIKE 'opt%' AND auctionpart <> 'CA' AND auctionpart = 'EA')  
 Then (SQTY*STRIKE_PRICE) Else 0 End)) AS excercisevalue,  
 (Sum(Case When (inst_type like 'Opt%' AND auctionpart<> 'CA' AND auctionpart = 'EA')  
 Then (PQTY*STRIKE_PRICE) Else 0 End)) AS assignmentvalue,  
 (Sum(Case When inst_type LIKE 'FUT%' AND auctionpart = 'EA' AND auctionpart <> 'CA'  
 Then IsNull(prate*pqty + srate*sqty,0) Else 0 End)) AS closeoutvalue,  
 Sum(pbrokamt + sbrokamt) AS brokerage  
 FROM [AngelCommodity].MCDX.DBO.FoBillValan A With (nolock)  WHERE A.tradetype = 'BT' --AND A.inst_type IN ('FUTIDX','FUTSTK','OPTIDX','OPTSTK')  
 and a.Sauda_date  >= @Sauda_date and sauda_date <= @Sauda_date + ' 23:59:59'  
 AND PARTY_CODE = @PARTY_CODE  
 Group By Sauda_date, party_code  
 ) acoount  
 Group By Sauda_date, party_code,futurestradedvalue ,brokerage,  
 optionstradedvalue , excercisevalue , assignmentvalue , closeoutvalue  
 UNION  
 SELECT Sauda_date ,party_code,futurestradedvalue , optionstradedvalue , excercisevalue , assignmentvalue ,  
 closeoutvalue ,SUM (futurestradedvalue + optionstradedvalue + excercisevalue + assignmentvalue + closeoutvalue) as TOTAL_TURNOVER ,brokerage,SEGMENT='NCX'  
  FROM (  
 SELECT CONVERT(VARCHAR(11),SAUDA_DATE,120) as Sauda_date ,  
 party_code,  
 (Sum(Case When inst_type LIKE 'FUT%' AND auctionpart <> 'EA'    
 AND auctionpart <> 'CA' Then IsNull(prate*pqty + srate*sqty,0) Else 0 End)) AS futurestradedvalue,  
 (Sum(Case When inst_type LIKE 'OPT%' AND auctionpart <> 'CA' AND auctionpart <> 'EA'  
 --Then ((pqty+sqty)*strike_price) Else 0 End)) AS optionstradedvalue,  
 Then (((pqty*prate)+(sqty*srate))) Else 0 End)) AS optionstradedvalue,  
 (Sum(Case When (inst_type LIKE 'opt%' AND auctionpart <> 'CA' AND auctionpart = 'EA')  
 Then (SQTY*STRIKE_PRICE) Else 0 End)) AS excercisevalue,  
 (Sum(Case When (inst_type like 'Opt%' AND auctionpart<> 'CA' AND auctionpart = 'EA')  
 Then (PQTY*STRIKE_PRICE) Else 0 End)) AS assignmentvalue,  
 (Sum(Case When inst_type LIKE 'FUT%' AND auctionpart = 'EA' AND auctionpart <> 'CA'  
 Then IsNull(prate*pqty + srate*sqty,0) Else 0 End)) AS closeoutvalue,  
 Sum(pbrokamt + sbrokamt) AS brokerage  
 FROM [AngelCommodity].NCDX.DBO.FoBillValan A With (nolock)  WHERE A.tradetype = 'BT' --AND A.inst_type IN ('FUTIDX','FUTSTK','OPTIDX','OPTSTK')  
 and a.Sauda_date  >= @Sauda_date and sauda_date <= @Sauda_date + ' 23:59:59'  
 AND PARTY_CODE = @PARTY_CODE  
 Group By Sauda_date, party_code  
 ) acoount  
 Group By Sauda_date, party_code,futurestradedvalue ,brokerage,  
 optionstradedvalue , excercisevalue , assignmentvalue , closeoutvalue  
 UNION  
 SELECT Sauda_date ,party_code,futurestradedvalue , optionstradedvalue , excercisevalue , assignmentvalue ,  
 closeoutvalue ,SUM (futurestradedvalue + optionstradedvalue + excercisevalue + assignmentvalue + closeoutvalue) as TOTAL_TURNOVER ,brokerage,SEGMENT='BSX'  
  FROM (  
 SELECT CONVERT(VARCHAR(11),SAUDA_DATE,120) as Sauda_date ,  
 party_code,  
 (Sum(Case When inst_type LIKE 'FUT%' AND auctionpart <> 'EA'    
 AND auctionpart <> 'CA' Then IsNull(prate*pqty + srate*sqty,0) Else 0 End)) AS futurestradedvalue,  
 (Sum(Case When inst_type LIKE 'OPT%' AND auctionpart <> 'CA' AND auctionpart <> 'EA'  
 --Then ((pqty+sqty)*strike_price) Else 0 End)) AS optionstradedvalue,  
 Then (((pqty*prate)+(sqty*srate))) Else 0 End)) AS optionstradedvalue,  
 (Sum(Case When (inst_type LIKE 'opt%' AND auctionpart <> 'CA' AND auctionpart = 'EA')  
 Then (SQTY*STRIKE_PRICE) Else 0 End)) AS excercisevalue,  
 (Sum(Case When (inst_type like 'Opt%' AND auctionpart<> 'CA' AND auctionpart = 'EA')  
 Then (PQTY*STRIKE_PRICE) Else 0 End)) AS assignmentvalue,  
 (Sum(Case When inst_type LIKE 'FUT%' AND auctionpart = 'EA' AND auctionpart <> 'CA'  
 Then IsNull(prate*pqty + srate*sqty,0) Else 0 End)) AS closeoutvalue,  
 Sum(pbrokamt + sbrokamt) AS brokerage  
 FROM [AngelCommodity].BSECURFO.DBO.FoBillValan A With (nolock)  WHERE A.tradetype = 'BT' --AND A.inst_type IN ('FUTIDX','FUTSTK','OPTIDX','OPTSTK')  
 and a.Sauda_date  >= @Sauda_date and sauda_date <= @Sauda_date + ' 23:59:59'  
 AND PARTY_CODE = @PARTY_CODE  
 Group By Sauda_date, party_code  
 ) acoount  
 Group By Sauda_date, party_code,futurestradedvalue ,brokerage,  
 optionstradedvalue , excercisevalue , assignmentvalue , closeoutvalue  
 order by PARTY_CODE,Sauda_date  
  
 /*  
 Select  Party_code,  
 COUNT(distinct ORDER_NO) AS orderNoCount , Sum (Qty * MarketRate) T_O,  
 sum(a.Brokerage)Brokerage  
 --into #CashCommonContData  
 from  Common_contract_data a with (nolock)  
 where exchange in('NSE') and Segment='FUTURES'  
 and a.Sauda_date  >= @Sauda_date and sauda_date <= @Sauda_date + ' 23:59:59'  
 AND PARTY_CODE  = @PARTY_CODE  
 group by   a.Party_code  
 order by  a.Party_code  
 */  
  
select B.*,ORDER_NO  INTO #FINAL from ANGELFO.PRADNYA.DBO.History_Fosettlement_Nsefo A with (nolock),#DATA B  
WHERE CONVERT(VARCHAR(10),A.Sauda_date,120) = CONVERT(VARCHAR(11),B.Sauda_date,120)   
AND A.Party_Code =B.PARTY_CODE  
AND SEGMENT ='NSEFO'  
AND AuctionPart <> 'CA' AND Price <> 0  
UNION  
select B.*,ORDER_NO from ANGELFO.NSEFO.DBO.Fosettlement A with (nolock),#DATA B  
WHERE CONVERT(VARCHAR(10),A.Sauda_date,120) = CONVERT(VARCHAR(11),B.Sauda_date,120)   
AND A.Party_Code =B.PARTY_CODE  
AND SEGMENT ='NSEFO'  
AND AuctionPart <> 'CA' AND Price <> 0  
UNION   
select B.*,ORDER_NO from ANGELFO.NSECURFO.DBO.Fosettlement A with (nolock),#DATA B  
WHERE CONVERT(VARCHAR(10),A.Sauda_date,120) = CONVERT(VARCHAR(11),B.Sauda_date,120)   
AND A.Party_Code =B.PARTY_CODE  
AND AuctionPart <> 'CA' AND Price <> 0  
AND SEGMENT ='NSX'  
UNION   
select B.*,ORDER_NO from ANGELCOMMODITY.MCDX.DBO.Fosettlement A with (nolock),#DATA B  
WHERE CONVERT(VARCHAR(10),A.Sauda_date,120) = CONVERT(VARCHAR(11),B.Sauda_date,120)   
AND A.Party_Code =B.PARTY_CODE  
AND AuctionPart <> 'CA' AND Price <> 0  
AND SEGMENT ='MCX'  
UNION  
select B.*,ORDER_NO from ANGELCOMMODITY.PRADNYA.DBO.History_Fosettlement_Mcdx A with (nolock),#DATA B  
WHERE CONVERT(VARCHAR(10),A.Sauda_date,120) = CONVERT(VARCHAR(11),B.Sauda_date,120)   
AND A.Party_Code =B.PARTY_CODE  
AND AuctionPart <> 'CA' AND Price <> 0  
AND SEGMENT ='MCX'  
UNION   
select B.*,ORDER_NO from ANGELCOMMODITY.NCDX.DBO.Fosettlement A with (nolock),#DATA B  
WHERE CONVERT(VARCHAR(10),A.Sauda_date,120) = CONVERT(VARCHAR(11),B.Sauda_date,120)   
AND A.Party_Code =B.PARTY_CODE  
AND AuctionPart <> 'CA' AND Price <> 0  
AND SEGMENT ='NCX'  
UNION  
select B.*,ORDER_NO from ANGELCOMMODITY.PRADNYA.DBO.History_Fosettlement_ncdx A with (nolock),#DATA B  
WHERE CONVERT(VARCHAR(10),A.Sauda_date,120) = CONVERT(VARCHAR(11),B.Sauda_date,120)   
AND A.Party_Code =B.PARTY_CODE  
AND AuctionPart <> 'CA' AND Price <> 0  
AND SEGMENT ='NCX'  
UNION   
select B.*,ORDER_NO from ANGELCOMMODITY.BSECURFO.DBO.Fosettlement A with (nolock),#DATA B  
WHERE CONVERT(VARCHAR(10),A.Sauda_date,120) = CONVERT(VARCHAR(11),B.Sauda_date,120)   
AND A.Party_Code =B.PARTY_CODE  
AND AuctionPart <> 'CA' AND Price <> 0  
AND SEGMENT ='BSX'  
  
SELECT DISTINCT * FROM #FINAL   
  
DROP TABLE #FINAL  
DROP TABLE #DATA

GO
