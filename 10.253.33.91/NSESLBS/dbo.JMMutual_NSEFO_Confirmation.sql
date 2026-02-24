-- Object: PROCEDURE dbo.JMMutual_NSEFO_Confirmation
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--select * from isettlement

CREATE Proc JMMutual_NSEFO_Confirmation        
   
--JMMutual_NSEFO_Confirmation 'Nov  7 2003','S052'         
          
(@SaudaDate varchar(12), @FROMFAMILY VARCHAR(15),@TOFAMILY VARCHAR(15),
			 @FROMPARTYCODE varchar(20),@TOPARTYCODE varchar(20))                
                
AS          

if @FROMFAMILY = '' begin set @FROMFAMILY = '0'  end
if @TOFAMILY = '' begin set @TOFAMILY = 'zzzzzz' end
if @FROMPARTYCODE = '' begin set @FROMPARTYCODE = '0'  end
if @TOPARTYCODE = '' begin set @TOPARTYCODE = 'zzzzzz' end  
     
          
Set NoCount On          
          
select segment='EQUITY', Exchange=s2.Exchange,Scrip_cd = s1.short_name,Scrip_cd1 = s.Scrip_Cd,      
Expdate = left(convert(varchar,sauda_date,109),3),          
M.ISIN,      
Sell_buy,          
EQQty = sum(s.tradeqty),           
MktValue = sum(s.marketrate*s.tradeqty),      
Marketrate = sum(s.marketrate*s.tradeqty)/sum(s.tradeqty),      
Brokerage = sum(Brokapplied*s.TradeQty),      
Ins_Chrg = sum(Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End)      
      
into #DEUTSCHEBank            
from Settlement S ,               
Client1 C1, Client2 C2, Multiisin M, scrip1 s1, scrip2 s2           
where S.party_code = C2.party_code                
And C1.cl_code = C2.cl_code                
And S.sauda_date like @SaudaDate +'%'  

and family between @FROMFAMILY and @TOFAMILY 
and c2.party_code=c1.cl_code
and c1.Cl_Code between @FROMPARTYCODE and @TOPARTYCODE  
And c1.cl_code = c2.cl_code     
               
And S.scrip_cd = M.scrip_cd                   
And S.series = M.series              
And S.tradeqty > 0              
and M.Valid = 1          
And S.scrip_cd = S2.scrip_cd                   
And S.series = S2.series            
And S1.co_code = S2.co_code           
Group by  s1.short_name,s.Scrip_Cd,s2.Exchange, M.ISIN,left(convert(varchar,sauda_date,109),3),Sell_buy          
               
Insert into #DEUTSCHEBank            
select segment='EQUITY', Exchange=s2.Exchange,Scrip_cd = s1.short_name,Scrip_cd1 = s.Scrip_Cd,Expdate =left(convert(varchar,sauda_date,109),3),          
M.ISIN,      
Sell_buy,          
EQQty = sum(s.tradeqty),           
MktValue = sum(s.marketrate*s.tradeqty),      
Marketrate = sum(s.marketrate*s.tradeqty)/sum(s.tradeqty),               
Brokerage = sum(Brokapplied*s.TradeQty),      
Ins_Chrg = sum(Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End)      
      
from ISettlement S ,               
Client1 C1, Client2 C2, Multiisin M, scrip1 s1, scrip2 s2          
where S.party_code = C2.party_code                
And C1.cl_code = C2.cl_code                
And S.sauda_date like @SaudaDate +'%'  

and family between @FROMFAMILY and @TOFAMILY 
and c2.party_code=c1.cl_code
and c1.Cl_Code between @FROMPARTYCODE and @TOPARTYCODE  
And c1.cl_code = c2.cl_code     
               
And S.scrip_cd = M.scrip_cd                   
And S.series = M.series              
And S.tradeqty > 0              
and M.Valid = 1          
And S.scrip_cd = S2.scrip_cd                   
And S.series = S2.series            
And S1.co_code = S2.co_code           
Group by s1.short_name,s2.Exchange,s.Scrip_Cd,M.ISIN,left(convert(varchar,sauda_date,109),3),Sell_buy      
          
insert into #DEUTSCHEBank                 
select segment='EQUITY', Exchange=s2.Exchange,Scrip_cd = s1.short_name,Scrip_cd1 = s.Scrip_Cd,Expdate =left(convert(varchar,sauda_date,109),3),          
M.ISIN,          
Sell_buy,      
EQQty = sum(s.tradeqty),           
MktValue = sum(s.marketrate*s.tradeqty),      
Marketrate = sum(s.marketrate*s.tradeqty)/sum(s.tradeqty),               
Brokerage = sum(Brokapplied*s.TradeQty),      
Ins_Chrg = sum(Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End)      
      
from                
--ExnBse.BseDb.Dbo.Settlement S, ExnBse.BseDb.Dbo.Client1 C1, ExnBse.BseDb.Dbo.Client2 C2, ExnBse.BseDb.Dbo.Multiisin M, ExnBse.BseDb.Dbo.scrip1 s1, ExnBse.BseDb.Dbo.scrip2 s2          
BseDb.Dbo.Settlement S,BseDb.Dbo.Client1 C1, BseDb.Dbo.Client2 C2, BseDb.Dbo.Multiisin M, BseDb.Dbo.scrip1 s1, BseDb.Dbo.scrip2 s2        
where  S.party_code = C2.party_code                
And C1.cl_code = C2.cl_code                
And S.sauda_date like @SaudaDate +'%' 

and family between @FROMFAMILY and @TOFAMILY 
and c2.party_code=c1.cl_code
and c1.Cl_Code between @FROMPARTYCODE and @TOPARTYCODE  
And c1.cl_code = c2.cl_code     

                
And S.scrip_cd = M.scrip_cd                   
And S.tradeqty > 0              
and M.Valid = 1          
And s.scrip_cd = s2.BSECODE                   
And S1.co_code = S2.co_code           
Group by  s1.short_name,s2.Exchange,s.Scrip_Cd,M.ISIN,left(convert(varchar,sauda_date,109),3),Sell_buy          
            
insert into #DEUTSCHEBank                 
select segment='EQUITY', Exchange=s2.Exchange,Scrip_cd = s1.short_name,Scrip_cd1 = s.Scrip_Cd,Expdate =left(convert(varchar,sauda_date,109),3),          
M.ISIN,          
Sell_buy,      
EQQty = sum(s.tradeqty),           
MktValue = sum(s.marketrate*s.tradeqty),      
Marketrate = sum(s.marketrate*s.tradeqty)/sum(s.tradeqty),               
Brokerage = sum(Brokapplied*s.TradeQty),      
Ins_Chrg = sum(Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End)      
      
from BseDb.Dbo.ISettlement S, BseDb.Dbo.Client1 C1, BseDb.Dbo.Client2 C2, BseDb.Dbo.Multiisin M, BseDb.Dbo.scrip1 s1, BseDb.Dbo.scrip2 s2          
--ExnBse.BseDb.Dbo.ISettlement S, ExnBse.BseDb.Dbo.Client1 C1, ExnBse.BseDb.Dbo.Client2 C2, ExnBse.BseDb.Dbo.Multiisin M, ExnBse.BseDb.Dbo.scrip1 s1, ExnBse.BseDb.Dbo.scrip2 s2          
where  S.party_code = C2.party_code                
And C1.cl_code = C2.cl_code                
And S.sauda_date like @SaudaDate +'%'  

and family between @FROMFAMILY and @TOFAMILY 
and c2.party_code=c1.cl_code
and c1.Cl_Code between @FROMPARTYCODE and @TOPARTYCODE  
And c1.cl_code = c2.cl_code     

               
And S.scrip_cd = M.scrip_cd                   
And S.tradeqty > 0              
and M.Valid = 1          
And s.scrip_cd = s2.BSECODE                   
And S1.co_code = S2.co_code           
Group by  s2.Exchange,s1.short_name,s.Scrip_Cd, M.ISIN,left(convert(varchar,sauda_date,109),3),Sell_buy          
            
select segment='FUTSTK',exchange='nsefo',Scrip_Cd1 = S.Symbol,Scrip_Cd = S.Sec_Name,Expdate =convert(varchar,Expirydate,101),          
ISIN = isnull(M.ISIN,Symbol),          
Sell_buy,      
EQQty = sum(s.tradeqty),           
MktValue = sum(s.price*s.tradeqty),      
Marketrate = sum(s.price*s.tradeqty)/sum(s.tradeqty),               
Brokerage = sum(isnull(((s.brokapplied*s.tradeqty) + (case when c2.service_chrg=1 then               
    isnull(s.SERVICE_TAX/s.tradeqty,0) Else 0 end )),0)),      
Ins_Chrg = sum(Case When Insurance_Chrg = 1 Then (S.Ins_chrg) Else 0 End)              
      
into #DEUTSCHEBank_FO          
from --nsefo.Dbo.Client1 C1, nsefo.Dbo.Client2 C2,nsefo.dbo.fosettlement S      
nsefo.Dbo.Client1 C1, nsefo.Dbo.Client2 C2,nsefo.dbo.fosettlement S         
left outer join MultiIsin M on (S.Symbol = M.Scrip_Cd and M.Valid = 1)          
where S.sauda_date like @SaudaDate +'%'  

and family between @FROMFAMILY and @TOFAMILY 
and c2.party_code=c1.cl_code
and c1.Cl_Code between @FROMPARTYCODE and @TOPARTYCODE  
And c1.cl_code = c2.cl_code     
               
--And S.party_code = @FROMPARTYCODE                
And S.party_code = C2.party_code                
And C1.cl_code = C2.cl_code       
And S.tradeqty > 0           
Group by S.Sec_Name,S.Symbol,M.ISIN,convert(varchar,Expirydate,101),Sell_buy          
        
  
select * from #DEUTSCHEBank  
UNION  
select * from #DEUTSCHEBank_FO  
Order By      
segment,Scrip_Cd,Sell_buy

GO
