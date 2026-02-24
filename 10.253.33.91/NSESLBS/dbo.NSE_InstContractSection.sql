-- Object: PROCEDURE dbo.NSE_InstContractSection
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE proc NSE_InstContractSection        
@StatusId Varchar(15),                
@StatusName Varchar(25),                     
@Sdate varchar(12),                            
@Sett_Type varchar(2),                            
@FromParty varchar(10),                            
@ToParty varchar(10),                          
@Branch Varchar(10),                 
@Sub_broker Varchar(10),             
@FromContNo varchar(14),                
@ToContNo varchar(14)              
              
as               
begin              
--select  s.contractno , scripname= scrip1.short_name, min(s.Series)  Series,Tradeqty =               
select  s.contractno , scripname = scrip2.scrip_cd, min(s.Series)  Series,Tradeqty =               
Sum( s.Tradeqty),          
MarketRate = Sum( s.TradeQty* s.Marketrate)/Sum( s.TradeQty),          
Brokapplied = sum( s.Brokapplied*tradeqty)/sum(tradeqty),               
service_tax =  sum(case when service_chrg <> 2 then nSerTax else 0 end),          
s.sell_buy,          
ins_chrg = sum ( case when Insurance_chrg = 1  then ins_chrg   else 0 end),              
pbrok=isnull((case  s.sell_buy              
 when 1 then  ( case when service_chrg = 1 then                
sum(s.nbrokapp*tradeqty)/sum(tradeqty) + (sum(s.nsertax)/sum( s.tradeqty))  
 else               
 sum( s.nbrokapp*tradeqty)/sum(tradeqty)  
 end)              
 end),0),               
sbrok=isnull((case  s.sell_buy              
 when 2 then  ( case when service_chrg = 1 then                
 sum( s.nbrokapp*tradeqty)/sum(tradeqty) + (sum(s.nsertax)/sum( s.tradeqty))  
 else               
sum( s.nbrokapp*tradeqty)/sum(tradeqty)  
 end)              
 end),0),               
pnetrate=isnull((case sell_buy  when 1 then ( case when service_chrg = 1 then                
 sum(N_netRate * tradeqty)/sum(tradeqty) + sum(s.nsertax)/sum(s.tradeqty)              
 else              
 sum(N_netRate * tradeqty)/sum(tradeqty)               
 end )               
 end),0),              
Snetrate=isnull((case sell_buy  when 2 then ( case when service_chrg = 1 then                
 sum(N_netRate * tradeqty)/sum(tradeqty) - sum(s.nsertax)/sum(s.tradeqty)              
 else              
 sum(N_netRate * tradeqty)/sum(tradeqty)               
 end )               
 end),0),              
pamt=isnull((case sell_buy when 1 then ( case when service_chrg = 1 then             
 round(sum(N_netRate * tradeqty)/sum(tradeqty),2) + round(sum(s.nsertax)/sum(s.tradeqty),2) * sum(tradeqty)            
 else            
 round(sum(N_netRate * tradeqty)/sum(tradeqty),2) * sum(s.tradeqty)            
 end)             
 end),0),            
Samt=isnull((case sell_buy when 2 then ( case when service_chrg = 1 then             
 round(sum(N_netRate * tradeqty)/sum(tradeqty),2) - round(sum(s.nsertax)/sum(s.tradeqty),2) * sum(tradeqty)            
 else            
 round(sum(N_netRate * tradeqty)/sum(tradeqty),2) * sum(s.tradeqty)            
 end)             
 end),0),             
s.party_code,service_chrg,TMARK , Order_no = min(order_no)  ,Trade_no = Min(trade_no) ,               
--tdate1=convert(char,MIn(sauda_date),103),            
tm= (convert(char,min(sauda_date),108)),              
min(s.dummy1) dummy1,              
SETT_NO = MIN(s.sett_No),              
s.Party_code,          
sauda_date = convert(char,(s.sauda_date),103),          
Start_date = convert(char,(Start_date),103),                                                     
End_Date   = convert(char,(End_Date),103),          
 Funds_Payin = left(convert(varchar,Funds_Payin,103),11) ,          
 Funds_PayOut =left(convert(varchar,Funds_Payout,103),11),          
/*          
 T_TTYPE = (cASE WHEN SELL_BUY = 1 AND s.sauda_date like(select start_Date from sett_mst where start_date like @Sdate + '%'  and sett_type =@SETT_TYPE)  THEN 'CFPD' ELSE          
     (CASE WHEN SELL_BUY = 2 AND  s.sauda_date like(select start_Date from sett_mst where start_date like @Sdate + '%'  and sett_type =@SETT_TYPE)  THEN 'CFSD' ELSE          
     (cASE WHEN SELL_BUY = 1 AND s.sauda_date like(select start_Date from sett_mst where start_date like  @Sdate + '%'  and sett_type = @SETT_TYPE) THEN 'CFP' ELSE          
     (CASE WHEN SELL_BUY = 2 AND s.sauda_date like(select start_Date from sett_mst where start_date like @Sdate + '%'  and sett_type =@SETT_TYPE) THEN 'CFS' ELSE          
    (cASE WHEN s.SELL_BUY =1 AND  tmark  ='D' THEN  'PD' ELSE           
     (CASE WHEN s.SELL_BUY = 2 AND tmark  ='D' THEN 'SD' ELSE          
    (CASE WHEN s.SELL_BUY = 1 THEN 'PC' ELSE 'SC' END) END) END) END) END) END)END) ,          
*/          
T_TTYPE =  (CASE WHEN s.SELL_BUY =1 THEN  'PD' ELSE 'SD' End),          
face_val, book_cl_dt = isnull(convert(varchar,book_cl_dt,03) ,0),          
 s.sett_type            
from isettlement s,scrip1,scrip2, client2  , client1, sett_mst              
WHERE              
rtrim( s.sett_type) = @sett_Type            
and s.scrip_cd=scrip2.scrip_cd            
and s.series=scrip2.series            
and scrip2.co_code=scrip1.co_code            
and scrip2.series=scrip1.series                
and s.sauda_date LIKE @sdate + '%'                
and s.tradeqty <> 0                
and s.Party_code between @FromParty   and  @ToParty                
and s.contractno  between @FromContNo    and   @ToContNo                
and client2.Party_code =  s.party_code                
and client1.cl_code = client2.cl_code                 
and s.sett_type = sett_mst.sett_type            
and s.sett_no = sett_mst.sett_no            
        
and Branch_cd Like (Case When @StatusId = 'branch' Then @statusname else '%' End)                
and client1.Sub_broker Like (Case When @StatusId = 'subbroker' Then @statusname else '%' End)                
and Trader Like (Case When @StatusId = 'trader' Then @statusname else '%' End)                
and Family Like (Case When @StatusId = 'family' Then @statusname else '%' End)                
and client2.Party_Code Like (Case When @StatusId = 'client' Then @statusname else '%' End)                
and Branch_cd like @Branch                
and client1.Sub_Broker like @Sub_Broker                
        
        
--group by  s.ContractNo, s.sett_type,scrip1.short_name, s.Series, s.Sell_buy,                
group by  s.ContractNo, s.sett_type,scrip2.scrip_cd, s.Sell_buy,                
s.party_code,service_chrg,Insurance_chrg,TMARK,           
 convert(char,(s.sauda_date),103), left(convert(varchar,Funds_Payin,103),11) ,left(convert(varchar,Funds_Payout,103),11),          
  face_val,book_cl_dt,convert(char,(End_Date),103),convert(char,(End_Date),103),  convert(char,(Start_date),103)            
end

GO
