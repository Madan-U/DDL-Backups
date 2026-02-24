-- Object: PROCEDURE dbo.Angel_NRI_ClientWiseData_LEC
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE proc [dbo].[Angel_NRI_ClientWiseData_LEC]        
(    
 @fclient as varchar(15),        
 @tclient as varchar(15),     
 @Type as varchar(2),        
 @BankId as int,        
 @Seg as varchar(5)        
)            
        
as          
begin        
Set nocount on        
--declare @sdate as varchar(11),@Type as varchar(2),@BankId as int,@Seg as varchar(5)        
--set @sdate ='16/08/2011' set @Type ='1' set @BankId =9 set @seg='BSE'        
       
        
create table #temp1        
(fldcol varchar(1000))        
        
 Select top 0 ContractNo,Party_Code,Scrip_Cd,TradeQty,Sauda_Date,Sell_Buy,NbrokApp,Ins_Chrg,Turn_tax,Other_chrg,sebi_tax,                                              
 Broker_chrg,Trade_amount,MarketRate  into #NriNse                         
 from msajag.dbo.Settlement(nolock)          
           
 Select top 0 ContractNo,Party_Code,Scrip_Cd,TradeQty,Sauda_Date,Sell_Buy,NbrokApp,Ins_Chrg,Turn_tax,Other_chrg,sebi_tax,                                              
 Broker_chrg,Trade_amount,MarketRate into #NriBse                         
 from AngelBSECM.bsedb_Ab.dbo.Settlement      
     
 if @seg='BSE'        
 begin     
 Insert into #NriBse        
 Select * from        
 (Select ContractNo,Party_Code,Scrip_Cd,TradeQty,Sauda_Date,Sell_Buy,NbrokApp,        
 Ins_Chrg,Turn_tax,Other_chrg,sebi_tax,Broker_chrg,Trade_amount,MarketRate        
 from AngelBSECM.bsedb_Ab.dbo.Settlement         
 where party_code like 'ZR%'     
 and convert(int,[dbo].[NUM_FROM_STR](party_code))>=convert(int,[dbo].[NUM_FROM_STR](@fclient))     
 and convert(int,[dbo].[NUM_FROM_STR](party_code)) <= convert(int,[dbo].[NUM_FROM_STR](@tclient))       
 and Sell_Buy = @Type       
 union all        
 Select ContractNo,Party_Code,Scrip_Cd,TradeQty,Sauda_Date,Sell_Buy,NbrokApp,        
 Ins_Chrg,Turn_tax,Other_chrg,sebi_tax,Broker_chrg,Trade_amount,MarketRate        
 from AngelBSECM.bsedb_Ab.dbo.history         
 where party_code like 'ZR%'     
 and convert(int,[dbo].[NUM_FROM_STR](party_code))>=convert(int,[dbo].[NUM_FROM_STR](@fclient))     
 and convert(int,[dbo].[NUM_FROM_STR](party_code)) <= convert(int,[dbo].[NUM_FROM_STR](@tclient))       
 and Sell_Buy = @Type) a        
 end        
         
 if @seg='NSE'        
 begin     
 Insert into #NriNse        
 Select * from        
 (Select ContractNo,Party_Code,Scrip_Cd,TradeQty,Sauda_Date,Sell_Buy,        
 NbrokApp,Ins_Chrg,Turn_tax,Other_chrg,sebi_tax,Broker_chrg,Trade_amount,MarketRate         
 from msajag.dbo.Settlement(nolock)         
 where party_code like 'ZR%'     
 and convert(int,[dbo].[NUM_FROM_STR](party_code))>=convert(int,[dbo].[NUM_FROM_STR](@fclient))     
 and convert(int,[dbo].[NUM_FROM_STR](party_code)) <= convert(int,[dbo].[NUM_FROM_STR](@tclient))       
 and Sell_Buy = @Type        
 union         
 Select ContractNo,Party_Code,Scrip_Cd,TradeQty,Sauda_Date,Sell_Buy,        
 NbrokApp,Ins_Chrg,Turn_tax,Other_chrg,sebi_tax,Broker_chrg,Trade_amount,MarketRate         
 from msajag.dbo.history(nolock)         
 where party_code like 'ZR%'     
 and convert(int,[dbo].[NUM_FROM_STR](party_code))>=convert(int,[dbo].[NUM_FROM_STR](@fclient))     
 and convert(int,[dbo].[NUM_FROM_STR](party_code)) <= convert(int,[dbo].[NUM_FROM_STR](@tclient))       
 and Sell_Buy = @Type)a        
 end        
        
        
Select distinct Party_Code,Sauda_Date=convert(Varchar,Sauda_Date,106) into #Clients from #NriBse with (nolock)     
union        
Select distinct Party_Code,Sauda_Date=convert(Varchar,Sauda_Date,106) from #NriNse with (nolock)     
IF @BankId <> 0        
Begin        
 Select #Clients.party_code,b.Fld_BankId into #t         
 from #Clients,Intranet.risk.dbo.tbl_NRIClientMaster b with (nolock)        
 where #Clients.Party_Code = b.Fld_ClientCode        
 Delete from #Clients where party_code in (Select party_code from #t where Fld_BankId <> @BankId)        
End        
        
Create table #tt        
(        
 Cnt int Identity (1,1),        
 Party_Code varchar(20),    
 Sauda_Date varchar(11)       
)        
Insert into #tt        
Select * from #Clients        
        
Declare @Cnt int        
Select @Cnt=Count(*) from #Clients    
Declare @sdate varchar(11)    
while @Cnt>0        
 Begin        
 Declare @TranCnt as int,@PartyCode as varchar(20)        
 Select @PartyCode=ltrim(rtrim(Party_code)),    
 @sdate=convert(varchar(11),convert(datetime,Sauda_Date,103)) from #tt where @Cnt=Cnt        
        
 if @seg='BSE'        
 Begin        
  Select @TranCnt=Count(ContractNo) from #NriBse        
  where party_code = @PartyCode and convert(datetime,convert(varchar(11),sauda_date)) = @sdate        
  and Sell_Buy = @Type        
  Group by Party_code,replace(convert(varchar(11),sauda_date,102),'.',''),ContractNo        
        
  Insert into #temp1        
  Select 'H'+'|'+        
  ltrim(rtrim(Party_code))+'|'+        
  replace(convert(varchar(11),sauda_date,102),'.','')+'|'+        
  convert(varchar,ContractNo)+'|'+          
  convert(varchar,convert(decimal(14,2),Sum(isnull(Service_Tax,0))))+'|'+
   '0.00'+'|'+       
  --ExService_Tax=Sum(isnull(ExService_Tax,0))+'|'+        
  convert(varchar,convert(decimal(14,2),Sum(isnull(Turn_Tax,0))))+'|'+        
  convert(varchar,convert(decimal(14,2),Sum(isnull(Ins_Chrg,0))))+'|'+         
  convert(varchar,convert(decimal(14,2),Sum(isnull(Broker_Chrg,0))))+'|'+        
  convert(varchar,convert(decimal(14,2),Sum(isnull(Sebi_Tax,0))))+'|'+        
  convert(varchar,@TranCnt)+'|'+        
  convert(varchar,convert(decimal(14,2),case when @Type = '1' then (-1)*(Sum(ISNULL(pamt,0)))else        
  Sum(ISNULL(samt,0)) end))        
  from AngelBSECM.BSEDB_AB.dbo.CMBillValan with (nolock)        
  where sauda_date=@sdate and party_code=@PartyCode        
  and ((@Type ='1' and pamt<>0) or (@Type ='2' and samt<>0) )        
  group by Party_code,ContractNo,replace(convert(varchar(11),sauda_date,102),'.','')        
        
        
  Insert into #temp1        
  Select 'T'+'|'+ltrim(rtrim(party_code))+'|'+        
  ltrim(rtrim(ContractNo))+'|'+        
  case when @Type = 1 then 'P'        
  when @Type = 2 then 'S' end        
  +'|'+        
  ltrim(rtrim(isnull(y.Isin,'')))+'|'+        
  ltrim(rtrim(convert(varchar,TradeQty)))+'|'+        
  convert(decimal(14,2),ltrim(rtrim(MarketRate)))+'|'+        
  ltrim(rtrim(convert(varchar,convert(dec(10,2),NBrokApp))))+'|'+        
  ltrim(rtrim(convert(varchar,convert(decimal(14,2),case        
  when @Type = 1 then (-1)*(convert(int,TradeQty)*(MarketRate+NBrokApp))        
  when @Type = 2 then convert(int,TradeQty)*(MarketRate-NBrokApp)        
  end))))        
  from #NriBse x        
  left outer join        
  (Select * from AngelDemat.Msajag.dbo.V_Isin_BseNse with (nolock)where Series = 'BSE')y        
  on x.scrip_cd = y.scrip_cd collate SQL_Latin1_General_CP1_CI_AS        
  where x.party_code = @PartyCode        
  and convert(datetime,convert(varchar(11),sauda_date)) = @sdate and Sell_Buy = @Type        
 end        
        
 ---- NSE        
 if @seg='NSE'        
 Begin        
  Select @TranCnt=Count(ContractNo) from #NriNse        
  where party_code = @PartyCode and convert(datetime,convert(varchar(11),sauda_date)) = @sdate        
  and Sell_Buy = @Type        
  Group by Party_code,replace(convert(varchar(11),sauda_date,102),'.',''),ContractNo        
        
  Insert into #temp1        
  Select 'H'+'|'+        
  ltrim(rtrim(Party_code))+'|'+        
  replace(convert(varchar(11),sauda_date,102),'.','')+'|'+        
  convert(varchar,ContractNo)+'|'+          
  convert(varchar,convert(decimal(14,2),Sum(isnull(Service_Tax,0))))+'|'+
   '0.00'+'|'+      
  --ExService_Tax=Sum(isnull(ExService_Tax,0))+'|'+          
  convert(varchar,convert(decimal(14,2),Sum(isnull(Turn_Tax,0))))+'|'+        
  convert(varchar,convert(decimal(14,2),Sum(isnull(Ins_Chrg,0))))+'|'+         
  convert(varchar,convert(decimal(14,2),Sum(isnull(Broker_Chrg,0))))+'|'+        
  convert(varchar,convert(decimal(14,2),Sum(isnull(Sebi_Tax,0))))+'|'+        
  convert(varchar,@TranCnt)+'|'+        
  convert(varchar,convert(decimal(14,2),case when @Type = '1' then (-1)*(Sum(ISNULL(pamt,0)))else        
  Sum(ISNULL(samt,0)) end))        
  from msajag.dbo.CMBillValan with (nolock) where sauda_date=@sdate and party_code=@PartyCode        
  and ((@Type ='1' and pamt<>0) or (@Type ='2' and samt<>0) )        
  group by Party_code,ContractNo,replace(convert(varchar(11),sauda_date,102),'.','')        
        
        
  Insert into #temp1        
  Select 'T'+'|'+ltrim(rtrim(party_code))+'|'+        
  ltrim(rtrim(ContractNo))+'|'+        
  case when @Type = 1 then 'P'        
  when @Type = 2 then 'S' end        
  +'|'+        
  ltrim(rtrim(isnull(y.Isin,'')))+'|'+        
  ltrim(rtrim(convert(varchar,TradeQty)))+'|'+        
  convert(decimal(14,2),ltrim(rtrim(MarketRate)))+'|'+        
  ltrim(rtrim(convert(varchar,convert(dec(10,2),NBrokApp))))+'|'+        
  ltrim(rtrim(convert(varchar,convert(decimal(14,2),case        
  when @Type = 1 then (-1)*(convert(int,TradeQty)*(MarketRate+NBrokApp))        
  when @Type = 2 then convert(int,TradeQty)*(MarketRate-NBrokApp)        
  end))))        
  from #NriNse x        
  left outer join        
  (Select * from AngelDemat.Msajag.dbo.V_Isin_BseNse with (nolock)where Series = 'EQ')y        
  on x.scrip_cd = y.scrip_cd collate SQL_Latin1_General_CP1_CI_AS        
  where x.party_code = @PartyCode        
  and convert(datetime,convert(varchar(11),sauda_date)) = @sdate and Sell_Buy = @Type        
 end        
        
 Set @Cnt=@Cnt-1        
End        
        
Select * from #temp1        
Set nocount off        
end

GO
