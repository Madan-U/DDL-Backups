-- Object: PROCEDURE dbo.usp_Angel_nri_Data_lec_allfiles_26July2023_Neha
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

--use 196-- inhouse                                        
--exec usp_Angel_nri_Data_lec_allfiles_26July2023_Neha '25/09/2023',0    
  
CREATE proc [dbo].[usp_Angel_nri_Data_lec_allfiles_26July2023_Neha]  
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
  
--  select *,CONVERT(money,0.00)as NetAmt,CONVERT(varchar,'')as CONTRACTNO_NEW into #aa from tbl_NSEBSE_HEADER_yesHdfcbnk
 
--	update a set a.CONTRACTNO_NEW=b.CONTRACTNO_NEW,a.NetAmt=b.netAmount from #aa a,
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
into #check FROM MSAJAG.dbo.CMBILLVALAN S with(nolock) where --party_code='ZR1196R' and
 sauda_date=@SDATE
GROUP BY S.PARTY_CODE, PARTY_NAME,CLIENTTYPE ,MEMBERTYPE,COMPANYNAME,SCRIP_CD,sauda_date,scrip_name,ISIN,CONTRACTNO,SETT_NO,EXCHANGE,
SEGMENT

 select * into #contract from MSAjag.dbo.common_contract_data where sauda_date=@SDATE --and party_code='zr1196r' 
 alter table #check add CONTRACTNO_NEW varchar(100) 

	update a set a.CONTRACTNO_NEW=b.CONTRACTNO_NEW from #check a,
#contract b where a.PARTY_CODE=b.PARTY_CODE and a.sauda_date=b.SAUDA_DATE and a.isin=b.isin and
 a.SCRIP_NAME=b.SCRIPNAME

  select a.PARTY_CODE,a.SAUDA_DATE,a.SELL_BUY,a.CONTRACTNO,EDUCESS,EXCHAGE_LEVIES,STT,STAMPDUTY,MINBROKERAGE,NO_OF_TRANSACTIONS,
 TOTALAMT,TYPE,nseSett_no2,nseBank,rbi_refno,CliPISNo,CliBnkAcc,cliBankBranch,angelAcc,c.CONTRACTNO_NEW
,b.DPid1,b.cltdpID1,b.Short_Name,c.SCRIP_CD,c.EXCHANGE,c.ISIN,c.SCRIP_NAME,c.BUYDELIVERYCHRG+c.SELLDELIVERYCHRG as Brokearge,c.PTRADEDQTY+c.STRADEDQTY as Qty,c.PMARKETRATE+c.SMARKETRATE as Rate,
 c.BILLPAMT+c.BILLSAMT as ExactAmount,c.PNETRATE+c.SNETRATE as Weighted,case when PMARKETRATE<>0 and PTRADEDQTY<>0 then (c.PMARKETRATE*PTRADEDQTY) when SMARKETRATE<>0 and STRADEDQTY<>0 then (SMARKETRATE*STRADEDQTY) end as TotalMarketVal,c.SERVICE_TAX+c.TURN_TAX+c.SEBI_TAX+c.BROKER_CHRG as OtherCharges,
 c.SETT_NO,c.INS_CHRG as nsestt into #final from #aa a join  #check c on a.party_code=c.party_code     and a.SETT_NO=C.Sett_no and 
 A.contractno=c.Contractno  
 left outer join [196.1.115.132].Risk.dbo.client_Details b with (nolock) on a.PARTY_CODE=b.party_code         
        

  
   truncate table tbl_NRILecYesHdfc_temp 
   select * into ##Header from tbl_NRILecYesHdfc_temp where 1=2
   	 insert into ##Header(Fldcol,BankName)
	 select 'Bank Name,Trade Date,Trading ID,DP ID,Demat A/c No,Investor Name,Exchange,Settlement No,Contract No,Scrip Code,ISIN Number,Scrip Name,Buy/Sell,Quantity,Weighted Average Market Rate,Total Market Value,Net Rate,Brokerage Value,Other Charges,Net Purchase/Sale Value,STT on Buy & Sale,Exact amount paid by / to  the customer (for purchase/sale),RBI Approval No,PIS Account No,Saving Bank Account No,Bank''s Branch Name,Broker Name,Date of Receipt /payment,Demat Debit /Credit Date,Broker A/C No' as Fldcol,''

   insert into tbl_NRILecYesHdfc_temp  
select distinct nseBank+','+Convert(varchar,SAUDA_DATE,103)+','+PARTY_CODE+','+DPid1 +','+cast(right(cltdpID1,8) as varchar) +','+Short_Name +','+Exchange +','+isnull(nseSett_no2,'') +','+        
     CONVERT(VARCHAR,CONTRACTNO_NEW)+','+ltrim(rtrim(SCRIP_CD))+','+Ltrim(Rtrim(Isnull(ISIN,'')))+','+        
     left(SCRIP_NAME,75)+','+CASE WHEN Sell_Buy = 1 THEN 'Buy'  WHEN Sell_Buy = 2 THEN 'Sell'  END +','+Ltrim(Rtrim(CONVERT(VARCHAR,sum(QTY)))) +','+ Convert(Varchar,avg(Weighted))+','+cast((CONVERT(DEC(15,2),avg(TotalMarketVal))) as varchar)
	 +','+  Ltrim(Rtrim(CONVERT(VARCHAR,CONVERT(DEC(15,2), avg(RATE))))) +','+Ltrim(Rtrim(CONVERT(VARCHAR,CONVERT(DEC(10,2), sum(Brokearge)))))+','+             
        CONVERT(VARCHAR,CONVERT(DEC(10,2),Isnull(sum(OtherCharges),0)))+','+        
    -- cast(Ltrim(Rtrim(CONVERT(DEC(10,2),sum(TotalMarketVal+Brokearge+OtherCharges)))) as varchar)
		 CONVERT(VARCHAR,CONVERT(DECIMAL(14,2),Case when Sell_Buy = 1 THEN sum((TotalMarketVal+Brokearge+OtherCharges)) else sum(TotalMarketVal-Brokearge-OtherCharges) end))
	 +','+ CONVERT(VARCHAR,CONVERT(DECIMAL(14, 2),Sum(Isnull(NseStt, 0))))+','+        
     CONVERT(VARCHAR,CONVERT(DECIMAL(14,2),ABS(sum(ExactAmount))))+','
	 +isnull(rbi_refno,'')+','+isnull(CliPISNo,'')+','+isnull(CliBnkAcc,'')+','+case when nseBank like 'HDFC%' then 'Tulsiani' else cliBankBranch end+','+'Angel One Ltd'+','+   
  CASE WHEN Sell_Buy = 1 THEN  Convert(varchar,(sauda_date +1),103)  WHEN Sell_Buy = 2 THEN Convert(varchar,(sauda_date+2),103)  END+','+        
      CASE WHEN Sell_Buy = 1 THEN  Convert(varchar,(sauda_date +1),103)  WHEN Sell_Buy = 2 THEN Convert(varchar,(sauda_date+2),103)  END +','+angelAcc,nseBank        
     from #final group by  PARTY_CODE, SAUDA_DATE ,DPid1 ,right(cltdpID1,8) ,Short_Name ,        
     CONVERT(VARCHAR, CONTRACTNO_NEW) ,ISIN,       
     SCRIP_NAME,SCRIP_CD,        
     nseBank,rbi_refno,Sell_Buy,CliPISNo,  
  CliBnkAcc,cliBankBranch,angelAcc,Exchange,isnull(nseSett_no2,'')  

  
  
  declare @BCPCOMMAND1 as varchar(5000)   
     DECLARE @hdfcfilename2 as varchar(1000)  
     DECLARE @Yesfilename2 as varchar(1000)  
     declare @link as varchar(2000)=''        
  
    if ((select count(1) from tbl_NRILecYesHdfc_temp where bankname like '%HDFC%')>0)        
    Begin        
    SET @hdfcfilename2 = '\\196.1.115.147\upload1\NRI_CLients\HDFC_'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.csv'         
    SET @BCPCOMMAND1 = 'BCP "select Fldcol from ##Header union all select FLDCOL from Inhouse.dbo.tbl_NRILecYesHdfc_temp where bankname like ''%HDFC%''" QUERYOUT "'                                    
    -- print(@BCPCOMMAND1)                              
   SET @BCPCOMMAND1 = @BCPCOMMAND1 + @hdfcfilename2 + '" -c -t, -S196.1.115.196 -Uclassmkt -Pdd$$gnfDTVs244648ysjgZAcc'                                          
   EXEC MASTER..XP_CMDSHELL @BCPCOMMAND1         
  -- set @link=@link +'<a href='+replace(@hdfcfilename2,'\\196.1.115.147','')+'>Right click and save -- HDFC</a><br>'        
  select '<a href='+replace(@hdfcfilename2,'\\196.1.115.147','')+'>Right click and save -- HDFC</a><br>'        
   End  
  
  if ((select count(1) from tbl_NRILecYesHdfc_temp where bankname like '%YES%')>0)        
      Begin        
        SET @YESfilename2 = '\\196.1.115.147\upload1\NRI_CLients\YES_'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.csv'         
        SET @BCPCOMMAND1 = 'BCP "select Fldcol from ##Header union all select FLDCOL from Inhouse.dbo.tbl_NRILecYesHdfc_temp where bankname like ''%YES%''" QUERYOUT "'                                    
       -- print(@BCPCOMMAND1)                              
       SET @BCPCOMMAND1 = @BCPCOMMAND1 + @YESfilename2 + '" -c -t, -S196.1.115.196 -Uclassmkt -Pdd$$gnfDTVs244648ysjgZAcc'                                          
       EXEC MASTER..XP_CMDSHELL @BCPCOMMAND1         
       --set @link=@link +'<a href='+replace(@YESfilename2,'\\196.1.115.147','')+'>Right click and save -- Yes Bank</a><br>'            
        select '<a href='+replace(@YESfilename2,'\\196.1.115.147','')+'>Right click and save -- Yes Bank</a><br>'        
      End  
	Drop table ##Header  
   
End

GO
