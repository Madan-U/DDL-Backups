-- Object: PROCEDURE dbo.Angel_NRI_Data
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

--Angel_NRI_Data '10/08/2011',1,3,'bse'
CREATE proc [dbo].[Angel_NRI_Data](@sdate as varchar(11),@Type as varchar(2),@BankId as int,@Seg as varchar(5))  
as                                                                  
                                                              
set @sdate = convert(varchar(11),convert(datetime,@sdate,103))                                                                  
                                                              
create table #temp1                                                                  
(fldcol varchar(150))                                             
                                         
Declare @Bse as int                                              
Declare @Nse as int                                            
                                        
--Select @Bse=Count(*) from NriBse where convert(datetime,convert(varchar(11),sauda_date)) = @sdate                                             
--Select @Nse=Count(*) from NriNse where convert(datetime,convert(varchar(11),sauda_date)) = @sdate                                            
delete  from NriBse where convert(datetime,convert(varchar(11),sauda_date)) = @sdate                                             
delete from NriNse where convert(datetime,convert(varchar(11),sauda_date)) = @sdate                                                
                                    
select distinct party_code into #NRI_Cli from cmbillvalan (nolock) x where                                                                 
sauda_date = convert(datetime,@sdate,103) and ClientType = 'NRI'                                                                                        
union                                                                 
select distinct party_code from AngelBSECM.bsedb_ab.dbo.cmbillvalan x where                                                                 
sauda_date = convert(datetime,@sdate,103) and ClientType = 'NRI'                                           
                                
Delete from #NRI_Cli where not exists                                        
(Select Fld_ClientCode from Intranet.risk.dbo.tbl_NRIClientMaster b where #NRI_Cli.Party_code = b.Fld_ClientCode)                   
              
if(@BankId<>0)                  
begin                                       
Delete from #NRI_Cli   where    Party_code  in                  
(Select Fld_ClientCode from Intranet.risk.dbo.tbl_NRIClientMaster where fld_bankid<>@BankId)                   
end                        
if @Seg='Bse'  
begin                    
Insert into NriBse                                                      
Select ContractNo,Party_Code,Scrip_Cd,TradeQty,Sauda_Date,Sell_Buy,
NbrokApp=Convert(decimal(12,2),NbrokApp),
Ins_Chrg=Convert(decimal(12,2),Ins_Chrg),
Turn_tax=Convert(decimal(12,2),Turn_tax),
Other_chrg=Convert(decimal(12,2),Other_chrg),
sebi_tax=Convert(decimal(12,2),sebi_tax),                                                      
Broker_chrg=Convert(decimal(12,2),Broker_chrg),
Trade_amount=Convert(decimal(12,2),Trade_amount),
MarketRate=Convert(decimal(12,2),MarketRate) 
from AngelBSECM.bsedb_Ab.dbo.Settlement where party_code in (Select party_code from #NRI_Cli) and                                                         
convert(char(11),sauda_date) = convert(datetime,@sdate,103)  and Sell_Buy = @Type    and trade_amount>0 and auctionpart not like  'a%'                                            
union  all          
Select  ContractNo,Party_Code,Scrip_Cd,TradeQty,Sauda_Date,Sell_Buy,
NbrokApp=Convert(decimal(12,2),NbrokApp),
Ins_Chrg=Convert(decimal(12,2),Ins_Chrg),
Turn_tax=Convert(decimal(12,2),Turn_tax),
Other_chrg=Convert(decimal(12,2),Other_chrg),
sebi_tax=Convert(decimal(12,2),sebi_tax),                                                      
Broker_chrg=Convert(decimal(12,2),Broker_chrg),
Trade_amount=Convert(decimal(12,2),Trade_amount),
MarketRate =Convert(decimal(12,2),MarketRate)
from  AngelBSECM.bsedb_Ab.dbo.history where party_code in (Select party_code from #NRI_Cli) and                                                         
convert(char(11),sauda_date) = convert(datetime,@sdate,103)  and Sell_Buy = @Type    and trade_amount>0 and auctionpart not like  'a%'                                            
End  

if @Seg='NSE'  
begin                                    
Insert into NriNse                                                 
Select ContractNo,Party_Code,Scrip_Cd,TradeQty,Sauda_Date,Sell_Buy,
NbrokApp=Convert(decimal(12,2),NbrokApp),
Ins_Chrg=Convert(decimal(12,2),Ins_Chrg),
Turn_tax=Convert(decimal(12,2),Turn_tax),
Other_chrg=Convert(decimal(12,2),Other_chrg),
sebi_tax=Convert(decimal(12,2),sebi_tax),              
Broker_chrg=Convert(decimal(12,2),Broker_chrg),
Trade_amount=Convert(decimal(12,2),Trade_amount),
MarketRate =Convert(decimal(12,2),MarketRate)
from Settlement(nolock) where party_code in (Select party_code from #NRI_Cli) and                                                         
convert(char(11),sauda_date) = convert(datetime,@sdate,103)   and Sell_Buy = @Type   and trade_amount>0  and auctionpart not like  'a%'                                           
union all           
Select ContractNo,Party_Code,Scrip_Cd,TradeQty,Sauda_Date,Sell_Buy,
 NbrokApp=Convert(decimal(12,2),NbrokApp),
Ins_Chrg=Convert(decimal(12,2),Ins_Chrg),
Turn_tax=Convert(decimal(12,2),Turn_tax),
Other_chrg=Convert(decimal(12,2),Other_chrg),
sebi_tax=Convert(decimal(12,2),sebi_tax),              
Broker_chrg=Convert(decimal(12,2),Broker_chrg),
Trade_amount=Convert(decimal(12,2),Trade_amount),
MarketRate =Convert(decimal(12,2),MarketRate)
from  msajag.dbo.history where party_code in (Select party_code from #NRI_Cli) and                                                         
convert(char(11),sauda_date) = convert(datetime,@sdate,103)  and Sell_Buy = @Type    and trade_amount>0 and auctionpart not like  'a%'                                            
End                                     
                                        
Select distinct Party_Code into #Clients from NriBse where convert(datetime,convert(varchar(11),sauda_date)) = @sdate and Sell_Buy = @Type                                      
union                                          
Select distinct Party_Code from NriNse where convert(datetime,convert(varchar(11),sauda_date)) = @sdate and Sell_Buy = @Type                                        
                                  
--IF @BankId <> 0                                      
--Begin                                      
-- Select #Clients.party_code,b.Fld_BankId into #t from #Clients,Intranet.risk.dbo.tbl_NRIClientMaster b where #Clients.Party_Code = b.Fld_ClientCode                                      
-- Delete from #Clients where party_code in (Select party_code from #t where Fld_BankId <> @BankId)                                      
--End                                          
--                                       
Declare @PartyCode as varchar(25)                                                                
                                                 
DECLARE Curosr_Nri CURSOR FOR select distinct party_code from #Clients                                                                
OPEN Curosr_Nri                                                                                                                                                
                                                                                                                    
FETCH NEXT FROM Curosr_Nri                                                                                                                         
INTO @PartyCode                                                                                                     
                                                    
WHILE @@FETCH_STATUS = 0                                                                     
                                                         
Begin                                                         
                                            
-----------------------------BSE-------------------------------------------   

                   
Select Party_code,replace(convert(varchar(11),sauda_date,102),'.','') Sauda_date,ContractNo,sum(NbrokApp*TradeQty) Brok,sum(Ins_chrg) Ins_chrg,                                                
sum(turn_tax) turn_tax,sum(Broker_chrg+other_chrg) Chrg,sum(other_chrg+sebi_tax) Sebi_Tax,                                                
sum(Trade_amount) Trade_amount,Count(ContractNo) Cnt into #bt from NriBse where party_code = @PartyCode and convert(datetime,convert(varchar(11),sauda_date)) = @sdate and Sell_Buy = @Type                                  
Group by Party_code,replace(convert(varchar(11),sauda_date,102),'.',''),ContractNo                                                
                                            
Select party_code,sauda_date,contractNo,              
Cnt,(Brok) Brok,              
(st) Stax,              
(St*0.03) ECess,                                                          
((St*0.03)+st) OStax,              
(Ins_chrg) Ins_chrg,              
(turn_tax) turn_tax,              
(Sebi_Tax) as Sebi_Tax,              
(Chrg) Chrg,              
(trade_amount) trade_amount,                      
Case When @Type = 1 then               
(Brok+Trade_amount) else               
(Trade_amount-Brok) end NetObl into #btt from                                                          
(Select ((brok+turn_tax)*0.10) ST,* from #bt)a      
                                            
Insert into #temp1                                                
Select 'H'+'|'+ltrim(rtrim(party_code))+'|'+sauda_date+'|'+                                                                   
ltrim(rtrim(ContractNo))+'|'+ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Stax) )))+'|'+                                                               
ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Ecess))))+'|'+ltrim(rtrim(convert(varchar,Convert(decimal(12,2),turn_tax))))+'|'+                                                                   
ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Ins_chrg))))+'|'+ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Chrg))))+'|'+                                                                   
ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Sebi_Tax))))+'|'+Convert(varchar,Cnt)+'|'+                            
case when @Type = 2 then ltrim(rtrim(convert(varchar,convert(decimal(14,2),Netobl-(turn_tax+Chrg+Ostax+Ins_chrg+sebi_tax))))) else                                
ltrim(rtrim(convert(varchar,convert(decimal(14,2),Netobl+turn_tax+Chrg+Ostax+Ins_chrg+sebi_tax)))) end                                              
from #btt                                                
                                            
Insert into #temp1                         
Select 'T'+'|'+ltrim(rtrim(party_code))+'|'+                                                                   
ltrim(rtrim(ContractNo))+'|'+             
case when @Type = 1 then 'P'                                                      
when @Type = 2 then 'S' end                                                      
+'|'+                                         
ltrim(rtrim(isnull(y.Isin,'')))+'|'+                                                                   
ltrim(rtrim(convert(varchar,TradeQty)))+'|'+                                      
ltrim(rtrim(MarketRate))+'|'+                                                                   
ltrim(rtrim(convert(varchar,convert(dec(10,2),NBrokApp))))+'|'+                              
ltrim(rtrim(convert(varchar,case                                                       
when @Type = 1 then  convert(int,TradeQty)*(MarketRate+NBrokApp)                                                                  
when @Type = 2 then  convert(int,TradeQty)*(MarketRate-NBrokApp)                                                                  
end)))                                                       
from NriBse x                                                
left outer join                                                                  
(Select * from AngelDemat.Msajag.dbo.V_Isin_BseNse where Series = 'BSE')y                                                                  
on x.scrip_cd = y.scrip_cd collate SQL_Latin1_General_CP1_CI_AS where x.party_code = @PartyCode and convert(datetime,convert(varchar(11),sauda_date)) = @sdate and Sell_Buy = @Type                                                                  


                                            
-------------------NSE------------------------------------------      
                                                                     
Select Party_code,replace(convert(varchar(11),sauda_date,102),'.','') Sauda_date,ContractNo,sum(NbrokApp*TradeQty) Brok,sum(Ins_chrg) Ins_chrg,                                                
sum(turn_tax) turn_tax,sum(Broker_chrg+other_chrg) Chrg,sum(other_chrg+sebi_tax) Sebi_Tax,                                                
sum(Trade_amount) Trade_amount,Count(ContractNo) Cnt into #nt from NriNse where party_code = @PartyCode and convert(datetime,convert(varchar(11),sauda_date)) = @sdate and Sell_Buy = @Type                                       
Group by Party_code,replace(convert(varchar(11),sauda_date,102),'.',''),ContractNo                                
                                            
Select party_code,sauda_date,              
contractNo,Cnt,              
(Brok) Brok,              
(st) Stax,              
(St*0.03) ECess,                                                          
((St*0.03)+st) OStax,               
(Ins_chrg) Ins_chrg,              
(turn_tax) turn_tax,               
(Sebi_Tax) as Sebi_Tax,              
(Chrg) Chrg,              
(trade_amount) trade_amount,                                         
Case When @Type = 1 then (Brok+Trade_amount) else (Trade_amount-Brok) end NetObl into #ntt from                                                          
(Select ((brok+turn_tax)*0.10) ST,* from #nt)a                                                          
 
Insert into #temp1                                                
Select 'H'+'|'+ltrim(rtrim(party_code))+'|'+sauda_date+'|'+                                                                   
ltrim(rtrim(ContractNo))+'|'+ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Stax))))+'|'+                                                                 
ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Ecess))))+'|'+ltrim(rtrim(convert(varchar,Convert(decimal(12,2),turn_tax))))+'|'+                                                                   
ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Ins_chrg))))+'|'+ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Chrg))))+'|'+                                                                   
ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Sebi_Tax))))+'|'+Convert(varchar,Cnt)+'|'+                            
case when @Type = 2 then ltrim(rtrim(convert(varchar,convert(decimal(14,2),Netobl-(turn_tax+Chrg+Ostax+Ins_chrg+sebi_tax))))) else                                
ltrim(rtrim(convert(varchar,convert(decimal(14,2),Netobl+turn_tax+Chrg+Ostax+Ins_chrg+sebi_tax)))) end                                                 
from #ntt                                                
               
Insert into #temp1                                                
Select 'T'+'|'+ltrim(rtrim(party_code))+'|'+                                                                   
ltrim(rtrim(ContractNo))+'|'+                                                                   
case when @Type = 1 then 'P'                                                      
when @Type = 2 then 'S' end                                                      
+'|'+                                                        
ltrim(rtrim(isnull(y.Isin,'')))+'|'+                                     
ltrim(rtrim(convert(varchar,TradeQty)))+'|'+                                                                   
ltrim(rtrim(MarketRate))+'|'+                                                                   
ltrim(rtrim(convert(varchar,convert(dec(10,2),NBrokApp))))+'|'+                                                      
ltrim(rtrim(convert(varchar,case                                                       
when @Type = 1 then  convert(int,TradeQty)*(MarketRate+NBrokApp)                                                                  
when @Type = 2 then  convert(int,TradeQty)*(MarketRate-NBrokApp)                                                                  
end)))                                                       
from NriNse x                                                
left outer join                                                                  
(Select * from AngelDemat.Msajag.dbo.V_Isin_BseNse where Series in('EQ','BE') )y                                                                  
on x.scrip_cd = y.scrip_cd  collate SQL_Latin1_General_CP1_CI_AS where x.party_code = @PartyCode and convert(datetime,convert(varchar(11),sauda_date)) = @sdate and Sell_Buy = @Type       
                                                   
Drop table #bt;Drop table #btt;Drop table #nt;Drop table #ntt                                                
                                                                                 
FETCH NEXT FROM Curosr_Nri                                                                           
INTO @PartyCode                                                                                         
                                                                                              
END                                                                                                                        
                                                               
CLOSE Curosr_Nri                                                                                                  
DEALLOCATE Curosr_Nri       

                                                           
                                                       
Select * from #temp1

GO
