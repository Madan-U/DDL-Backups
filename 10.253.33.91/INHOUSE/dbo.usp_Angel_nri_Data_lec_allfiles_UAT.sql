-- Object: PROCEDURE dbo.usp_Angel_nri_Data_lec_allfiles_UAT
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

--use 196-- inhouse                                                      
--exec [usp_Angel_nri_Data_lec_allfiles_UAT] '25/01/2024',0                  
               
CREATE proc [dbo].[usp_Angel_nri_Data_lec_allfiles_UAT]                
(                
@SDATE  AS VARCHAR(11),                                                  
@BANKID AS INT                                  
)                
As                
Begin                
                
                         
  --insert into #output                      
  --Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'                        
                
truncate table tbl_NSEBSE_HEADER_yesHdfcbnk                
truncate table tbl_NSEBSE_Details_yesHdfcbnk                
exec Angel_nri_data_lec_new_15may2023 @SDATE,1,@BANKID,'NSE'                
exec Angel_nri_data_lec_new_15may2023 @SDATE,2,@BANKID,'NSE'                
exec Angel_nri_data_lec_new_15may2023 @SDATE,1,@BANKID,'BSE'                
exec Angel_nri_data_lec_new_15may2023 @SDATE,2,@BANKID,'BSE'  

 SET @SDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @SDATE, 103))    
 
 EXEC USP_LEC_KOTAK @SDATE		--- KOTAK LEC
          
  --declare @SDATE as varchar(11)=CONVERT(VARCHAR(11), CONVERT(DATETIME,'07/12/2023', 103))         
                
--  select *,CONVERT(money,0.00)as NetAmt,CONVERT(varchar,'')as CONTRACTNO_NEW into #aa from tbl_NSEBSE_HEADER_yesHdfcbnk              
               
-- update a set a.CONTRACTNO_NEW=b.CONTRACTNO_NEW,a.NetAmt=b.netAmount from #aa a,              
--(select CONTRACTNO_NEW,sum(netAmount) netAmount,party_code,sauda_date from MSAjag.dbo.common_contract_data b with(nolock) group by              
--CONTRACTNO_NEW,party_code,sauda_date) b where a.sauda_date=b.sauda_date and b.SAUDA_DATE=@SDATE and a.party_code=b.party_code              
              
 select *,CONVERT(money,0.00)as NetAmt,CONVERT(varchar,'')as CONTRACTNO_NEW,CONVERT(money,0.00) as NETRAte,CONVERT(money,0.00) as               
  Brokerage into #aa from tbl_NSEBSE_HEADER_yesHdfcbnk -- where party_code='ZR1196R'               
         
 SELECT PARTY_CODE,SCRIP_CD,sauda_date,scrip_name,isin,CONTRACTNO,SETT_NO,EXCHANGE,              
SEGMENT, LONG_NAME=PARTY_NAME,PTRADEDQTY = SUM(PQTYTRD + PQTYDEL) ,PTRADEDAMT = SUM(PAMTTRD + PAMTDEL) ,              
STRADEDQTY = SUM(SQTYTRD + SQTYDEL), STRADEDAMT = SUM((CASE WHEN SQTYTRD = 0 AND SAMTTRD <> 0 THEN -SAMTTRD ELSE SAMTTRD END)              
+ (CASE WHEN SQTYDEL = 0 AND SAMTDEL <> 0 THEN -SAMTDEL ELSE SAMTDEL END)), BUYBROKERAGE = SUM(PBROKTRD) , SELBROKERAGE=               
SUM(SBROKTRD) , BUYDELIVERYCHRG = SUM(PBROKDEL), SELLDELIVERYCHRG = SUM(SBROKDEL), CLIENTTYPE, BILLPAMT = SUM(PAMT) ,              
 BILLSAMT = SUM(SAMT) , PMARKETRATE = ( SUM(PRATE) / CASE WHEN SUM(PQTYTRD + PQTYDEL) > 0 THEN SUM(PQTYTRD + PQTYDEL) ELSE 1 END) ,              
 SMARKETRATE = ( SUM(SRATE) / (CASE WHEN SUM(SQTYTRD + SQTYDEL) > 0 THEN SUM(SQTYTRD + SQTYDEL) ELSE 1 END ) ),  PNETRATE =               
( SUM(PAMTTRD + PAMTDEL) / CASE WHEN SUM(PQTYTRD + PQTYDEL) > 0 THEN SUM(PQTYTRD + PQTYDEL) ELSE 1 END) ,              
SNETRATE = ( SUM((CASE WHEN SQTYTRD =0 AND SAMTTRD<>0 THEN -SAMTTRD ELSE SAMTTRD END) +              
(CASE WHEN SQTYDEL=0 AND SAMTDEL<>0 THEN -SAMTDEL ELSE SAMTDEL END)) / (CASE WHEN SUM(SQTYTRD + SQTYDEL) > 0 THEN               
SUM(SQTYTRD + SQTYDEL) ELSE 1 END ) ), TRDAMT= SUM(TRDAMT) ,DELAMT=SUM(DELAMT), SERINEX=SUM(SERINEX),SERVICE_TAX= SUM(SERVICE_TAX) ,              
EXSERVICE_TAX= SUM(EXSERVICE_TAX),TURN_TAX=SUM(TURN_TAX),SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),              
OTHER_CHRG=SUM(OTHER_CHRG), MEMBERTYPE,COMPANYNAME,PNL = SUM(SAMTTRD-PAMTTRD)            
into #check  from [Anand].bsedb_ab.dbo.CMBILLVALAN S with(nolock) where --party_code='ZR1196R' and              
 sauda_date=@SDATE             
GROUP BY S.PARTY_CODE, PARTY_NAME,CLIENTTYPE ,MEMBERTYPE,COMPANYNAME,SCRIP_CD,sauda_date,scrip_name,ISIN,CONTRACTNO,SETT_NO,EXCHANGE,              
SEGMENT          
        
        
alter table #check        
alter column MEMBERTYPE varchar(10)        
        
 insert into #check        
  SELECT PARTY_CODE,SCRIP_CD,sauda_date,scrip_name,isin,CONTRACTNO,SETT_NO,EXCHANGE,              
SEGMENT, LONG_NAME=PARTY_NAME,PTRADEDQTY = SUM(PQTYTRD + PQTYDEL) ,PTRADEDAMT = SUM(PAMTTRD + PAMTDEL) ,              
STRADEDQTY = SUM(SQTYTRD + SQTYDEL), STRADEDAMT = SUM((CASE WHEN SQTYTRD = 0 AND SAMTTRD <> 0 THEN -SAMTTRD ELSE SAMTTRD END)              
+ (CASE WHEN SQTYDEL = 0 AND SAMTDEL <> 0 THEN -SAMTDEL ELSE SAMTDEL END)), BUYBROKERAGE = SUM(PBROKTRD) , SELBROKERAGE=               
SUM(SBROKTRD) , BUYDELIVERYCHRG = SUM(PBROKDEL), SELLDELIVERYCHRG = SUM(SBROKDEL), CLIENTTYPE, BILLPAMT = SUM(PAMT) ,              
 BILLSAMT = SUM(SAMT) , PMARKETRATE = ( SUM(PRATE) / CASE WHEN SUM(PQTYTRD + PQTYDEL) > 0 THEN SUM(PQTYTRD + PQTYDEL) ELSE 1 END) ,              
 SMARKETRATE = ( SUM(SRATE) / (CASE WHEN SUM(SQTYTRD + SQTYDEL) > 0 THEN SUM(SQTYTRD + SQTYDEL) ELSE 1 END ) ),  PNETRATE =               
( SUM(PAMTTRD + PAMTDEL) / CASE WHEN SUM(PQTYTRD + PQTYDEL) > 0 THEN SUM(PQTYTRD + PQTYDEL) ELSE 1 END) ,              
SNETRATE = ( SUM((CASE WHEN SQTYTRD =0 AND SAMTTRD<>0 THEN -SAMTTRD ELSE SAMTTRD END) +              
(CASE WHEN SQTYDEL=0 AND SAMTDEL<>0 THEN -SAMTDEL ELSE SAMTDEL END)) / (CASE WHEN SUM(SQTYTRD + SQTYDEL) > 0 THEN               
SUM(SQTYTRD + SQTYDEL) ELSE 1 END ) ), TRDAMT= SUM(TRDAMT) ,DELAMT=SUM(DELAMT), SERINEX=SUM(SERINEX),SERVICE_TAX= SUM(SERVICE_TAX) ,              
EXSERVICE_TAX= SUM(EXSERVICE_TAX),TURN_TAX=SUM(TURN_TAX),SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),              
OTHER_CHRG=SUM(OTHER_CHRG), MEMBERTYPE,COMPANYNAME,PNL = SUM(SAMTTRD-PAMTTRD)              
FROM MSAJAG.dbo.CMBILLVALAN S with(nolock) where --party_code='ZR1196R' and              
 sauda_date=@SDATE             
GROUP BY S.PARTY_CODE, PARTY_NAME,CLIENTTYPE ,MEMBERTYPE,COMPANYNAME,SCRIP_CD,sauda_date,scrip_name,ISIN,CONTRACTNO,SETT_NO,EXCHANGE,              
SEGMENT              
  
---------------------- CHANGES STARTS On 09 MAY 2025  
  
SELECT * INTO #MAIN_DATA FROM #check WHERE CONTRACTNO<>'0000000'    
SELECT * INTO #C_ZERO FROM #check WHERE CONTRACTNO='0000000'    
  
SELECT M.PARTY_CODE,M.SCRIP_CD,M.SAUDA_DATE,M.scrip_name,M.ISIN,M.CONTRACTNO,M.SETT_NO,M.EXCHANGE,M.SEGMENT,M.LONG_NAME, (M.PTRADEDQTY+Z.PTRADEDQTY) AS PTRADEDQTY,  
(M.PTRADEDAMT+Z.PTRADEDAMT) AS PTRADEDAMT,M.STRADEDQTY,M.STRADEDAMT,M.BUYBROKERAGE,M.SELBROKERAGE,  
(M.BUYDELIVERYCHRG+Z.BUYDELIVERYCHRG) AS BUYDELIVERYCHRG , (M.SELLDELIVERYCHRG+Z.SELLDELIVERYCHRG) AS SELLDELIVERYCHRG, M.CLIENTTYPE,(M.BILLPAMT+Z.BILLPAMT) AS BILLPAMT ,   
(M.BILLSAMT+Z.BILLSAMT) AS BILLSAMT , M.PMARKETRATE,M.SMARKETRATE,(M.PNETRATE+Z.PNETRATE) AS PNETRATE ,(M.SNETRATE+Z.SNETRATE) AS SNETRATE,  
M.TRDAMT,M.DELAMT,M.SERINEX,  
(M.SERVICE_TAX+Z.SERVICE_TAX) AS SERVICE_TAX , (M.EXSERVICE_TAX+Z.EXSERVICE_TAX) AS EXSERVICE_TAX , (M.TURN_TAX+Z.TURN_TAX) AS TURN_TAX , (M.SEBI_TAX+Z.SEBI_TAX) AS SEBI_TAX ,  
(M.INS_CHRG+Z.INS_CHRG) AS INS_CHRG , (M.BROKER_CHRG+Z.BROKER_CHRG) AS BROKER_CHRG , (M.OTHER_CHRG+Z.OTHER_CHRG) AS OTHER_CHRG , M.MEMBERTYPE,M.COMPANYNAME,M.PNL  
INTO #CONTRACT_ZERO    
FROM #MAIN_DATA M INNER JOIN #C_ZERO Z ON Z.PARTY_CODE=M.PARTY_CODE AND Z.SETT_NO=M.SETT_NO AND M.SCRIP_CD=Z.SCRIP_CD  
  
--SELECT * FROM #MAIN_DATA WHERE PARTY_CODE='ZR1688R'  
--SELECT * FROM #C_ZERO WHERE PARTY_CODE='ZR1688R'  
--SELECT * FROM #CONTRACT_ZERO  
  
DELETE FROM #check WHERE PARTY_CODE IN (SELECT PARTY_CODE FROM #C_ZERO)    
  
INSERT INTO #check    
SELECT * FROM #CONTRACT_ZERO    
  
---------------------- CHANGES END On 09 MAY 2025  
   
--#check where party_Code='ZR1672R' -- 4757610        
           
 --select PARTY_CODE,SAUDA_DATE,CONTRACTNO_NEW,isin,SCRIPNAME into #contract from MSAjag.dbo.common_contract_data with(nolock) where sauda_date=@SDATE --and party_code='zr1196r'               
  
select PARTY_CODE,SAUDA_DATE,CONTRACTNO_NEW,isin,SCRIPNAME,SUM(IPFT_CHRG) AS IPFT_CHRG into #contract   
from MSAjag.dbo.common_contract_data with(nolock) where sauda_date=@SDATE --and party_code IN ('ZR1703R')  --- CHANGES ON 09 MAY 2025  
GROUP BY party_code,SAUDA_DATE,CONTRACTNO_NEW,isin,SCRIPNAME  
   
  
 --insert into #contract         
 --select PARTY_CODE,SAUDA_DATE,CONTRACTNO,isin,SCRIPNAME from [Anand].bsedb_ab.dbo.contract_data with(nolock) where sauda_date=@SDATE        
        
 alter table #check add CONTRACTNO_NEW varchar(100)               
 alter table #check add IPFT MONEY       ---- ADDED ON 09 MAY 2025  
    
 update a set a.CONTRACTNO_NEW=b.CONTRACTNO_NEW, A.IPFT=b.IPFT_CHRG from #check a, ---- ADDED ON 09 MAY 2025  (A.IPFT=b.IPFT_CHRG)              
#contract b where a.PARTY_CODE=b.PARTY_CODE and a.sauda_date=b.SAUDA_DATE and a.isin=b.isin               
 --and left(a.SCRIP_NAME,18)=left(b.SCRIPNAME,18)              ---- COMMENTED ON 05 JUN 2025 DISCUSSED WITH BHAVIKA SUB:HDFC LEC SCRIPT Missing
              
  select a.PARTY_CODE,a.SAUDA_DATE,a.SELL_BUY,a.CONTRACTNO,EDUCESS,EXCHAGE_LEVIES,STT,STAMPDUTY,MINBROKERAGE,NO_OF_TRANSACTIONS,              
 TOTALAMT,TYPE,nseSett_no2,nseBank,rbi_refno,CliPISNo,CliBnkAcc,cliBankBranch,angelAcc,c.CONTRACTNO_NEW              
,b.DPid1,b.cltdpID1,b.Short_Name,c.SCRIP_CD,c.EXCHANGE,c.ISIN,c.SCRIP_NAME,c.BUYDELIVERYCHRG+c.SELLDELIVERYCHRG as Brokearge,c.PTRADEDQTY+c.STRADEDQTY as Qty,c.PMARKETRATE+c.SMARKETRATE as Rate,              
c.BILLPAMT+c.BILLSAMT as ExactAmount,c.PNETRATE+c.SNETRATE as Weighted,case when PMARKETRATE<>0 and PTRADEDQTY<>0 then (c.PMARKETRATE*PTRADEDQTY) when SMARKETRATE<>0 and STRADEDQTY<>0 then (SMARKETRATE*STRADEDQTY) end as TotalMarketVal,  
c.SERVICE_TAX+c.TURN_TAX+c.SEBI_TAX+c.BROKER_CHRG+c.IPFT as OtherCharges,     ---- ADDED ON 09 MAY 2025  (+c.IPFT)   
 c.SETT_NO,c.INS_CHRG as nsestt into #final from #aa a join  #check c on a.party_code=c.party_code     and a.SETT_NO=C.Sett_no and               
 A.contractno=c.Contractno                
 left outer join [Intranet].Risk.dbo.client_Details b with (nolock) on a.PARTY_CODE=b.party_code                       
                      
              
                
   truncate table tbl_NRILecYesHdfc_temp               
   select * into ##Header from tbl_NRILecYesHdfc_temp where 1=2              
     insert into ##Header(Fldcol,BankName)              
  select 'Bank Name,Trade Date,Trading ID,DP ID,Demat A/c No,Investor Name,Exchange,Settlement No,Contract No,Scrip Code,ISIN Number,Scrip Name,Buy/Sell,Quantity,Weighted Average Market Rate,Total Market Value,Net Rate,Brokerage Value,Other Charges,Net Purchase/Sale Value,STT on Buy & Sale,Exact amount paid by / to  the customer (for purchase/sale),RBI Approval No,PIS Account No,Saving Bank Account No,Bank''s Branch Name,Broker Name,Date of Receipt /payment,Demat Debit /Credit Date,Broker A/C No' as Fldcol,''              
              
   insert into tbl_NRILecYesHdfc_temp                
select distinct nseBank+','+Convert(varchar,SAUDA_DATE,103)+','+PARTY_CODE+','+DPid1 +','+cast(right(cltdpID1,8) as varchar) +','+Short_Name +','+Exchange +','+isnull(nseSett_no2,'') +','+                      
     CONVERT(VARCHAR,isnull(CONTRACTNO_NEW,''))+','+ltrim(rtrim(SCRIP_CD))+','+Ltrim(Rtrim(Isnull(ISIN,'')))+','+                      
     left(SCRIP_NAME,75)+','+CASE WHEN Sell_Buy = 1 THEN 'B'  WHEN Sell_Buy = 2 THEN 'S'  END +','+Ltrim(Rtrim(CONVERT(VARCHAR,sum(QTY)))) +','+ Convert(Varchar,avg(Weighted))+','+cast((CONVERT(DEC(15,2),avg(TotalMarketVal))) as varchar)              
  +','+  Ltrim(Rtrim(CONVERT(VARCHAR,CONVERT(DEC(15,2), avg(RATE))))) +','+Ltrim(Rtrim(CONVERT(VARCHAR,CONVERT(DEC(10,2), sum(Brokearge)))))+','+                           
        CONVERT(VARCHAR,CONVERT(DEC(10,2),Isnull(sum(OtherCharges),0)))+','+                      
    -- cast(Ltrim(Rtrim(CONVERT(DEC(10,2),sum(TotalMarketVal+Brokearge+OtherCharges)))) as varchar)              
   CONVERT(VARCHAR,CONVERT(DECIMAL(14,2),Case when Sell_Buy = 1 THEN sum((TotalMarketVal+Brokearge+OtherCharges)) else sum(TotalMarketVal-Brokearge-OtherCharges) end))              
  +','+ CONVERT(VARCHAR,CONVERT(DECIMAL(14, 2),Sum(Isnull(NseStt, 0))))+','+         
  CONVERT(VARCHAR,(CONVERT(DECIMAL(14, 2),(Case when Sell_Buy = 1 THEN sum(TotalMarketVal+Brokearge+OtherCharges)+Sum(Isnull(NseStt, 0)) else sum(TotalMarketVal-Brokearge-OtherCharges)-Sum(Isnull(NseStt, 0)) end)))) +','          
    -- CONVERT(VARCHAR,CONVERT(DECIMAL(14,2),ABS(sum(ExactAmount))))+','              
  +isnull(rbi_refno,'')+','+isnull(CliPISNo,'')+','+isnull(CliBnkAcc,'')+','+case when nseBank like 'HDFC%' then 'Tulsiani' else cliBankBranch end+','+'Angel One Ltd'+','+                 
  CASE WHEN Sell_Buy = 1 THEN  Convert(varchar,(sauda_date +1),103)  WHEN Sell_Buy = 2 THEN Convert(varchar,(sauda_date+2),103)  END+','+                      
      CASE WHEN Sell_Buy = 1 THEN  Convert(varchar,(sauda_date +1),103)  WHEN Sell_Buy = 2 THEN Convert(varchar,(sauda_date+2),103)  END +','+angelAcc,nseBank                      
     from #final group by  PARTY_CODE, SAUDA_DATE ,DPid1 ,right(cltdpID1,8) ,Short_Name ,                      
     CONVERT(VARCHAR, isnull(CONTRACTNO_NEW,'')) ,ISIN,                     
     SCRIP_NAME,SCRIP_CD,                      
     nseBank,rbi_refno,Sell_Buy,CliPISNo,                
  CliBnkAcc,cliBankBranch,angelAcc,Exchange,isnull(nseSett_no2,'')                
              
                
                
  declare @BCPCOMMAND1 as varchar(5000)                 
     DECLARE @hdfcfilename2 as varchar(1000)                
     DECLARE @Yesfilename2 as varchar(1000)                
     declare @link as varchar(2000)=''                      
                
    if ((select count(1) from tbl_NRILecYesHdfc_temp where bankname like '%HDFC%')>0)                      
    Begin                      
    SET @hdfcfilename2 = '\\INHOUSELIVEAPP1-FS.angelone.in\upload1\NRI_CLients\HDFC_'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.csv'                       
    SET @BCPCOMMAND1 = 'BCP "select Fldcol from ##Header union all select FLDCOL from Inhouse.dbo.tbl_NRILecYesHdfc_temp where bankname like ''%HDFC%''" QUERYOUT "'                                                  
    -- print(@BCPCOMMAND1)                                            
   SET @BCPCOMMAND1 = @BCPCOMMAND1 + @hdfcfilename2 + '" -c -t, -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                                     
   EXEC MASTER..XP_CMDSHELL @BCPCOMMAND1                       
  -- set @link=@link +'<a href='+replace(@hdfcfilename2,'\\INHOUSELIVEAPP1-FS.angelone.in','')+'>Right click and save -- HDFC</a><br>'                      
  select '<a href='+replace(@hdfcfilename2,'\\INHOUSELIVEAPP1-FS.angelone.in','')+'>Right click and save -- HDFC</a><br>'                      
   End                
                
  if ((select count(1) from tbl_NRILecYesHdfc_temp where bankname like '%YES%')>0)                      
      Begin                      
        SET @YESfilename2 = '\\INHOUSELIVEAPP1-FS.angelone.in\upload1\NRI_CLients\YES_'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.csv'                       
        SET @BCPCOMMAND1 = 'BCP "select Fldcol from ##Header union all select FLDCOL from Inhouse.dbo.tbl_NRILecYesHdfc_temp where bankname like ''%YES%''" QUERYOUT "'                                                  
       -- print(@BCPCOMMAND1)                                            
       SET @BCPCOMMAND1 = @BCPCOMMAND1 + @YESfilename2 + '" -c -t, -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                                        
       EXEC MASTER..XP_CMDSHELL @BCPCOMMAND1                       
       --set @link=@link +'<a href='+replace(@YESfilename2,'\\INHOUSELIVEAPP1-FS.angelone.in','')+'>Right click and save -- Yes Bank</a><br>'                          
        select '<a href='+replace(@YESfilename2,'\\INHOUSELIVEAPP1-FS.angelone.in','')+'>Right click and save -- Yes Bank</a><br>'                      
      End                
 Drop table ##Header              
                 
End

GO
