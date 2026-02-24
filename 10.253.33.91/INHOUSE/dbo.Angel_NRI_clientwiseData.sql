-- Object: PROCEDURE dbo.Angel_NRI_clientwiseData
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

  
CREATE PROC [dbo].[Angel_NRI_clientwiseData]  
(  
 @fclient as varchar(15),  
 @tclient as varchar(15),    
 @Type as varchar(2),  
 @BankId as int,    
 @segment as varchar(5))                                                              
  
as                                                              
                                                                                                                                                  
 create table #temp1                                                              
 (fldcol varchar(150))                                         
      
 Select top 0 ContractNo,Party_Code,Scrip_Cd,TradeQty,Sauda_Date,Sell_Buy,NbrokApp,Ins_Chrg,Turn_tax,Other_chrg,sebi_tax,                                        
 Broker_chrg,Trade_amount,MarketRate  into #NriNse                   
 from msajag.dbo.Settlement(nolock)    
     
 Select top 0 ContractNo,Party_Code,Scrip_Cd,TradeQty,Sauda_Date,Sell_Buy,NbrokApp,Ins_Chrg,Turn_tax,Other_chrg,sebi_tax,                                        
 Broker_chrg,Trade_amount,MarketRate into #NriBse                   
 from AngelBSECM.bsedb_Ab.dbo.Settlement    
                                                                                                                      
 if @Segment='BSE'    
 Begin           
 Insert into #NriBse                                
 Select ContractNo,Party_Code,Scrip_Cd,TradeQty,Sauda_Date,Sell_Buy,
 --NbrokApp,Ins_Chrg,Turn_tax,Other_chrg,sebi_tax,                                        
 --Broker_chrg,Trade_amount,MarketRate      
 NbrokApp=Convert(decimal(12,2),NbrokApp),
Ins_Chrg=Convert(decimal(12,2),Ins_Chrg),
Turn_tax=Convert(decimal(12,2),Turn_tax),
Other_chrg=Convert(decimal(12,2),Other_chrg),
sebi_tax=Convert(decimal(12,2),sebi_tax),                                                      
Broker_chrg=Convert(decimal(12,2),Broker_chrg),
Trade_amount=Convert(decimal(12,2),Trade_amount),
MarketRate=Convert(decimal(12,2),MarketRate)            
 from AngelBSECM.bsedb_Ab.dbo.Settlement where party_code like 'ZR%' and convert(int,[dbo].[NUM_FROM_STR](party_code))>=convert(int,[dbo].[NUM_FROM_STR](@fclient)) and                     
 convert(int,[dbo].[NUM_FROM_STR](party_code)) <= convert(int,[dbo].[NUM_FROM_STR](@tclient))   and Sell_Buy = @Type                   
 union                                        
 select  ContractNo,Party_Code,Scrip_Cd,TradeQty,Sauda_Date,Sell_Buy,
 --NbrokApp,Ins_Chrg,Turn_tax,Other_chrg,sebi_tax,                                        
 --Broker_chrg,Trade_amount,MarketRate  
 NbrokApp=Convert(decimal(12,2),NbrokApp),
Ins_Chrg=Convert(decimal(12,2),Ins_Chrg),
Turn_tax=Convert(decimal(12,2),Turn_tax),
Other_chrg=Convert(decimal(12,2),Other_chrg),
sebi_tax=Convert(decimal(12,2),sebi_tax),                                                      
Broker_chrg=Convert(decimal(12,2),Broker_chrg),
Trade_amount=Convert(decimal(12,2),Trade_amount),
MarketRate=Convert(decimal(12,2),MarketRate)
 from AngelBSECM.bsedb_Ab.dbo.history with(nolock) where party_code like 'ZR%' and                  
 convert(int,[dbo].[NUM_FROM_STR](party_code)) >= convert(int,[dbo].[NUM_FROM_STR](@fclient)) and                     
 convert(int,[dbo].[NUM_FROM_STR](party_code)) <= convert(int,[dbo].[NUM_FROM_STR](@tclient)) and Sell_Buy = @Type                   
 End    
     
 If @Segment='NSE'    
 Begin                
 Insert into #NriNse                                              
 Select ContractNo,Party_Code,Scrip_Cd,TradeQty,Sauda_Date,Sell_Buy,
 --NbrokApp,Ins_Chrg,Turn_tax,Other_chrg,sebi_tax,                                        
 --Broker_chrg,Trade_amount,MarketRate    
 NbrokApp=Convert(decimal(12,2),NbrokApp),
Ins_Chrg=Convert(decimal(12,2),Ins_Chrg),
Turn_tax=Convert(decimal(12,2),Turn_tax),
Other_chrg=Convert(decimal(12,2),Other_chrg),
sebi_tax=Convert(decimal(12,2),sebi_tax),                                                      
Broker_chrg=Convert(decimal(12,2),Broker_chrg),
Trade_amount=Convert(decimal(12,2),Trade_amount),
MarketRate=Convert(decimal(12,2),MarketRate)       
 from msajag.dbo.Settlement(nolock) where party_code like 'ZR%' and convert(int,[dbo].[NUM_FROM_STR](party_code))>=convert(int,[dbo].[NUM_FROM_STR](@fclient)) and                     
 convert(int,[dbo].[NUM_FROM_STR](party_code))<=convert(int,[dbo].[NUM_FROM_STR](@tclient)) and Sell_Buy = @Type                     
 union                  
 select ContractNo,Party_Code,Scrip_Cd,TradeQty,Sauda_Date,Sell_Buy,
 --NbrokApp,Ins_Chrg,Turn_tax,Other_chrg,sebi_tax,                                        
 --Broker_chrg,Trade_amount,MarketRate 
 NbrokApp=Convert(decimal(12,2),NbrokApp),
Ins_Chrg=Convert(decimal(12,2),Ins_Chrg),
Turn_tax=Convert(decimal(12,2),Turn_tax),
Other_chrg=Convert(decimal(12,2),Other_chrg),
sebi_tax=Convert(decimal(12,2),sebi_tax),                                                      
Broker_chrg=Convert(decimal(12,2),Broker_chrg),
Trade_amount=Convert(decimal(12,2),Trade_amount),
MarketRate=Convert(decimal(12,2),MarketRate) 
 from msajag.dbo.history(nolock) where party_code like 'ZR%' and convert(int,[dbo].[NUM_FROM_STR](party_code))>=convert(int,[dbo].[NUM_FROM_STR](@fclient)) and                     
 convert(int,[dbo].[NUM_FROM_STR](party_code))<=convert(int,[dbo].[NUM_FROM_STR](@tclient))  and Sell_Buy = @Type                    
 End    
          
              
 Select distinct Party_Code into #Clients from #NriBse                               
 union                                      
 Select distinct Party_Code from #NriNse                                  
                       
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
 sum(Trade_amount) Trade_amount,Count(ContractNo) Cnt into #bt from #NriBse where party_code = @PartyCode and                  
 Sell_Buy = @Type                              
 Group by Party_code,replace(convert(varchar(11),sauda_date,102),'.',''),ContractNo                                            
                                             
 Select party_code,sauda_date,contractNo,Cnt,convert(dec(10,2),Brok) Brok,convert(dec(10,2),st) Stax,convert(dec(10,2),St*0.03) ECess,                                            
 (St*0.03)+st OStax, convert(dec(10,2),Ins_chrg) Ins_chrg,convert(dec(10,2),turn_tax) turn_tax,Sebi_Tax,convert(dec(10,2),Chrg) Chrg,convert(dec(10,2),trade_amount) trade_amount,            
 Case When @Type = 1 then convert(dec(10,2),Brok+Trade_amount) else convert(dec(10,2),Trade_amount-Brok) end NetObl                  
 into #btt from                                            
 (Select(brok+turn_tax)*0.10 ST,* from #bt)a                                            
                      
 Declare @sdate as varchar(25)                                                                                                     
 DECLARE Curosr_bse CURSOR FOR select  distinct sauda_date from #bt order by sauda_Date                                                            
 OPEN Curosr_bse                                                                                                                                                        
 FETCH NEXT FROM Curosr_bse                                                                                                                     
 INTO @sdate                                                                                                                                                      
 WHILE @@FETCH_STATUS = 0                                                                                                          
 Begin                   
                                        
 Insert into #temp1                                            
 Select 'H'+'|'+ltrim(rtrim(party_code))+'|'+sauda_date+'|'+                                                               
 ltrim(rtrim(ContractNo))+'|'+ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Stax))))+'|'+                                                               
 ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Ecess))))+'|'+ltrim(rtrim(convert(varchar,Convert(decimal(12,2),turn_tax))))+'|'+                                                               
 ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Ins_chrg))))+'|'+ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Chrg))))+'|'+                                                               
 ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Sebi_Tax))))+'|'+Convert(varchar,Cnt)+'|'+                        
 case when @Type = 2 then ltrim(rtrim(convert(varchar,convert(decimal(14,2),Netobl-(turn_tax+Chrg+Ostax+Ins_chrg+sebi_tax))))) else                
   ltrim(rtrim(convert(varchar,convert(decimal(14,2),Netobl+turn_tax+Chrg+Ostax+Ins_chrg+sebi_tax)))) end                                          
 from #btt  where sauda_date=@sdate                                           
              
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
 from #NriBse x                                            
 left outer join                                                              
 (Select * from AngelDemat.Msajag.dbo.V_Isin_BseNse where Series = 'BSE')y                                                              
 on x.scrip_cd = y.scrip_cd collate SQL_Latin1_General_CP1_CI_AS where x.party_code = @PartyCode and  Sell_Buy = @Type                                                              
 and  replace(convert(varchar(11),x.sauda_date,102),'.','')= @sdate                   
                 
                  
 FETCH NEXT FROM Curosr_bse                                                                      
 INTO @sdate                                                                                                                                                                   
 END                                                                                                                                                                   
 CLOSE Curosr_bse                                                                                              
 DEALLOCATE Curosr_bse      
  
                                    
 -------------------NSE------------------------------------------                                               
                                                                             
 Select Party_code,replace(convert(varchar(11),sauda_date,102),'.','') Sauda_date,ContractNo,sum(NbrokApp*TradeQty) Brok,sum(Ins_chrg) Ins_chrg,                                            
 sum(turn_tax) turn_tax,sum(Broker_chrg+other_chrg) Chrg,sum(other_chrg+sebi_tax) Sebi_Tax,                                            
 sum(Trade_amount) Trade_amount,Count(ContractNo) Cnt into #nt from #NriNse where  party_code = @PartyCode and                   
 Sell_Buy = @Type                                           
 Group by Party_code,replace(convert(varchar(11),sauda_date,102),'.',''),ContractNo                            
                                             
 Select party_code,sauda_date,contractNo,Cnt,convert(dec(10,2),Brok) Brok,convert(dec(10,2),st) Stax,convert(dec(10,2),St*0.03) ECess,                                            
 (St*0.03)+st OStax, convert(dec(10,2),Ins_chrg) Ins_chrg,convert(dec(10,2),turn_tax) turn_tax, Sebi_Tax,convert(dec(10,2),Chrg) Chrg,convert(dec(10,2),trade_amount) trade_amount,                                           
              
 Case When @Type = 1 then convert(dec(10,2),Brok+Trade_amount) else convert(dec(10,2),Trade_amount-Brok) end NetObl into #ntt from                                            
 (Select(brok+turn_tax)*0.10 ST,* from #nt)a                                            
                      
 Declare @s1date as varchar(25)                                       
 DECLARE Curosr_nse CURSOR FOR select  distinct sauda_date from #nt order by sauda_Date                                                            
 OPEN Curosr_nse                                                                                                                                                        
 FETCH NEXT FROM Curosr_nse                                                                                                                     
 INTO @s1date                                                                                                                                                      
 WHILE @@FETCH_STATUS = 0                                                                                                          
 Begin                      
                                     
 Insert into #temp1                                           
 Select 'H'+'|'+ltrim(rtrim(party_code))+'|'+sauda_date+'|'+                                                               
 ltrim(rtrim(ContractNo))+'|'+ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Stax))))+'|'+                                                        
 ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Ecess))))+'|'+ltrim(rtrim(convert(varchar,Convert(decimal(12,2),turn_tax))))+'|'+                 
 ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Ins_chrg))))+'|'+ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Chrg))))+'|'+                                                               
 ltrim(rtrim(convert(varchar,Convert(decimal(12,2),Sebi_Tax))))+'|'+Convert(varchar,Cnt)+'|'+                        
 case when @Type = 2 then ltrim(rtrim(convert(varchar,convert(decimal(14,2),Netobl-(turn_tax+Chrg+Ostax+Ins_chrg+sebi_tax))))) else                        
   ltrim(rtrim(convert(varchar,convert(decimal(14,2),Netobl+turn_tax+Chrg+Ostax+Ins_chrg+sebi_tax)))) end                                              
 from #ntt  where sauda_date=@s1date                                             
                                             
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
 from #NriNse x                                            
 left outer join                                                              
 (Select * from AngelDemat.Msajag.dbo.V_Isin_BseNse where Series in('EQ','BE') )y                                                              
 on x.scrip_cd = y.scrip_cd  collate SQL_Latin1_General_CP1_CI_AS where  x.party_code = @PartyCode and  Sell_Buy = @Type                                                           
 and  replace(convert(varchar(11),x.sauda_date,102),'.','')= @s1date                   
                                                  
                   
                 
 FETCH NEXT FROM Curosr_nse                                                                      
 INTO @s1date                 
 END                                                                                                                                                                   
 CLOSE Curosr_nse                                                                                              
 DEALLOCATE Curosr_nse                  
                 
 Drop table #bt;Drop table #btt;Drop table #nt;Drop table #ntt                  
                 
                                         
 FETCH NEXT FROM Curosr_Nri                                                                       
 INTO @PartyCode                                                                                                                                                                   
 END                                                                                                                                                                   
 CLOSE Curosr_Nri                                                                        
 DEALLOCATE Curosr_Nri                  
                 
                                                    
 Select * from #temp1

GO
