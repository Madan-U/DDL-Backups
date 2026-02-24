-- Object: PROCEDURE dbo.usp_Angel_nri_Data_lec_allfiles_26July2023_Neha_24Aug2023
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

--use 196-- inhouse                                        
--exec usp_Angel_nri_Data_lec_allfiles_26July2023_Neha '06/06/2023',0    
  
create proc [dbo].[usp_Angel_nri_Data_lec_allfiles_26July2023_Neha_24Aug2023]  
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
  
  select *,CONVERT(money,0.00)as NetAmt,CONVERT(varchar,'')as CONTRACTNO_NEW into #aa from tbl_NSEBSE_HEADER_yesHdfcbnk
 
	update a set a.CONTRACTNO_NEW=b.CONTRACTNO_NEW,a.NetAmt=b.netAmount from #aa a,
(select CONTRACTNO_NEW,sum(netAmount) netAmount,party_code,sauda_date from MSAjag.dbo.common_contract_data b with(nolock) group by
CONTRACTNO_NEW,party_code,sauda_date) b where a.sauda_date=b.sauda_date and b.SAUDA_DATE=@SDATE and a.party_code=b.party_code
  
   truncate table tbl_NRILecYesHdfc_temp 
   select * into ##Header from tbl_NRILecYesHdfc_temp where 1=2
   	 insert into ##Header(Fldcol,BankName)
	 select 'Bank Name,Trade Date,Trading ID,DP ID,Demat A/c No,Investor Name,Exchange,Settlement No,Contract No,Scrip Code,ISIN Number,Scrip Name,Buy/Sell,Quantity,Weighted Average Market Rate,Total Market Value,Net Rate,Brokerage Value,Other Charges,Net Purchase/Sale Value,STT on Buy & Sale,Exact amount paid by / to  the customer (for purchase/sale),RBI Approval No,PIS Account No,Saving Bank Account No,Bank''s Branch Name,Broker Name,Date of Receipt /payment,Demat Debit /Credit Date,Broker A/C No' as Fldcol,''

   insert into tbl_NRILecYesHdfc_temp  
   select distinct a.nseBank+','+Convert(varchar,a.SAUDA_DATE,103)+','+A.PARTY_CODE+','+b.DPid1 +','+cast(right(b.cltdpID1,8) as varchar) +','+b.Short_Name +','+left(C.Exchange,3) +','+isnull(A.nseSett_no2,'') +','+        
     CONVERT(VARCHAR,a.CONTRACTNO_NEW)+','+ltrim(rtrim(c.scripcode))+','+Ltrim(Rtrim(Isnull(c.ISIN,'')))+','+        
     left(c.Scripname,75)+','+CASE WHEN A.Sell_Buy = 1 THEN 'Buy'  WHEN A.Sell_Buy = 2 THEN 'Sell'  END +','+Ltrim(Rtrim(CONVERT(VARCHAR,sum(c.QTY)))) +','+ Convert(Varchar,avg(c.RATE))+','+cast((CONVERT(DEC(15,2),avg(a.NetAmt))) as varchar)--cast((CONVERT(DEC(15,2),avg(c.TRATE)) *sum(c.QTY)) as varchar)
	 +','+  Ltrim(Rtrim(CONVERT(VARCHAR,CONVERT(DEC(15,2), avg(c.TRATE))))) +','+Ltrim(Rtrim(CONVERT(VARCHAR,CONVERT(DEC(10,2), sum(c.BROK_PERSCRIP)))))+','+             
        CONVERT(VARCHAR,CONVERT(DEC(10,2),Isnull(sum(C.OTHERCHARGES+c.OtherTax),0)))+','+        
     cast(Ltrim(Rtrim(CONVERT(DEC(10,2),sum(c.TRANACTIONAMT)))) as varchar) +','+ CONVERT(VARCHAR,CONVERT(DECIMAL(14, 2),Sum(Isnull(C.NseStt, 0))))+','+        
     CONVERT(VARCHAR,CONVERT(DECIMAL(14,2),Case when A.Sell_Buy = 1 THEN ABS(sum(c.TRANACTIONAMT+c.NseStt+c.OtherCharges+c.OtherTax)*-1) else ABS(sum(c.TRANACTIONAMT-(c.NseStt+c.OtherCharges+c.OtherTax))) end))+','
	 +isnull(A.rbi_refno,'')+','+isnull(A.CliPISNo,'')+','+isnull(A.CliBnkAcc,'')+','+A.cliBankBranch+','+'Angel One Ltd'+','+   
  CASE WHEN A.Sell_Buy = 1 THEN  Convert(varchar,(a.sauda_date +1),103)  WHEN A.Sell_Buy = 2 THEN Convert(varchar,(a.sauda_date+2),103)  END+','+        
      CASE WHEN A.Sell_Buy = 1 THEN  Convert(varchar,(a.sauda_date +1),103)  WHEN A.Sell_Buy = 2 THEN Convert(varchar,(a.sauda_date+2),103)  END +','+a.angelAcc,a.nseBank        
     from #aa a             
     left outer join [196.1.115.132].Risk.dbo.client_Details b with (nolock) on a.PARTY_CODE=b.party_code         
     left outer join tbl_NSEBSE_Details_yesHdfcbnk c on a.party_code=c.party_code     and a.SETT_NO=C.Sett_no and  A.contractno=c.Contractno  
     --where  a.SETT_NO=C.Sett_no --and c.SETT_NO=@nseSett_no2        
     group by   A.PARTY_CODE, a.SAUDA_DATE ,b.DPid1 ,right(b.cltdpID1,8) ,b.Short_Name ,        
     CONVERT(VARCHAR, a.CONTRACTNO_NEW) ,Ltrim(Rtrim(Isnull(c.ISIN, ''))),        
     left(c.Scripname,75) ,c.scripcode,        
     --Ltrim(Rtrim(CONVERT(VARCHAR, CONVERT(DEC(10, 2), c.BROK_PERSCRIP)))),        
     a.nseBank,A.rbi_refno,A.Sell_Buy,A.CliPISNo,  
  A.CliBnkAcc,A.cliBankBranch,a.angelAcc,left(C.Exchange,3),isnull(A.nseSett_no2,'')  
  
  
  declare @BCPCOMMAND1 as varchar(1000)   
     DECLARE @hdfcfilename2 as varchar(200)  
     DECLARE @Yesfilename2 as varchar(200)  
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
