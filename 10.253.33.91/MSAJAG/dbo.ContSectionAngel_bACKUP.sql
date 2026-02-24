-- Object: PROCEDURE dbo.ContSectionAngel_bACKUP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc ContSectionAngel_bACKUP
(        
@Sdate varchar(12),         
@Sett_Type varchar(2),         
@ContNo varchar(7),         
@Sett_no Varchar(10),         
@Party_code Varchar(12)        
)          
        
as           
        
Declare           
@@Getstyle As Cursor,          
@@Sett_no As Varchar(12)          
        
Select @ContNo = Replicate('0',7-len(@ContNo)) + @ContNo        
        
Select @Sdate = Ltrim(Rtrim(@Sdate))          
If Len(@Sdate) = 10           
Begin          
  Select @Sdate = STUFF(@Sdate, 4, 1,'  ')          
End          
        
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
Declare Tax_Flag cursor read_only for   
select Top 1 isnull(Turnover_tax,0), isnull(Sebi_Turn_tax,0),   
isnull(Insurance_Chrg,0), isnull(Service_chrg,2) ,   
isnull(Other_chrg,0) ,isnull(BrokerNote,0)   
from client2  (nolock)  
where client2.party_code = @Party_code          
  
Declare @TurnOver_tax tinyInt,          
@Sebi_turn_tax tinyInt,          
@Insurance_Chrg tinyInt,          
@Service_chrg tinyInt,          
@Other_chrg tinyInt,          
@StampDuty  tinyInt          
Open Tax_flag          
        
fetch next from Tax_flag into @TurnOver_tax ,@Sebi_turn_tax , @Insurance_Chrg , @Service_chrg ,@Other_chrg ,@StampDuty          
Deallocate Tax_flag          
        
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SELECT  S.contractNo,         
S.party_code,         
S.order_no,         
tm=convert(char,sauda_date,108),          
S.trade_no,         
S.sauda_date,         
S.scrip_cd,          
scripname22 = (case when (len(scrip1.long_name) <= 22) then (left((scrip1.long_name + Space(22-Len(scrip1.long_name)-1)), 22)) else (left(scrip1.long_name, 21)) end) + '.',           
scripname=scrip1.long_name,         
sdt=convert(char,sauda_date,103),          
S.sell_buy,         
S.markettype,         
service_tax=( case when service_chrg = 1 then 0  else  isnull(S.service_tax,0) end),          
pqty=isnull((case sell_buy when 1 then S.tradeqty end),0),          
sqty=isnull((case sell_buy when 2 then S.tradeqty end),0),          
prate=isnull((case sell_buy when 1 then S.marketrate end),0),          
srate=isnull((case sell_buy when 2 then S.marketrate end),0),          
--pbrok=isnull((case sell_buy when 1 then  ( case when service_chrg = 1 then S.Brokapplied + (nsertax/tradeqty) else S.Brokapplied end) end),0),          
--sbrok=isnull((case sell_buy when 2 then  ( case when service_chrg = 1 then S.Brokapplied - (nsertax/tradeqty) else S.Brokapplied end) end),0),          
pbrok=0,    
sbrok=0,    
pnetrate=isnull((case sell_buy when 1 then ( case when service_chrg = 1 then S.marketrate + S.Brokapplied + (nsertax/tradeqty) else S.marketrate + S.Brokapplied end) end),0),          
snetrate=isnull((case sell_buy when 2 then ( case when service_chrg = 1 then S.marketrate - S.Brokapplied - (nsertax/tradeqty) else S.marketrate - S.Brokapplied end) end),0),          
pamt=isnull((case sell_buy when 1 then ( case when service_chrg = 1 then (S.marketrate + S.Brokapplied) * tradeqty + nsertax else (S.marketrate + S.Brokapplied) * tradeqty end) end),0),          
samt=isnull((case sell_buy when 2 then ( case when service_chrg = 1 then (S.marketrate - S.Brokapplied) * tradeqty - nsertax else (S.marketrate - S.Brokapplied) * tradeqty end) end),0),          
Brokerage=isnull((tradeqty*Brokapplied),0),         
S.sett_no,         
/*    
turn_tax = Case when @TurnOver_tax = 1 then turn_tax else 0 end ,          
NSERtax = case when @Service_chrg = 0 then nsertax else 0 end ,          
sebi_tax = case when @Sebi_turn_tax = 1 then sebi_tax else 0 end ,          
Ins_chrg = case when @Insurance_Chrg = 1 then Ins_chrg else 0 end ,          
other_chrg = case when @Other_chrg = 1 then S.other_chrg else 0 end ,          
Broker_chrg = case when @stampDuty = 1 then Broker_chrg else 0 end ,          
--Tmark = case when BillFlag = 1 or BillFlag = 4 or BillFlag = 5 then '' else '' end            
*/    
turn_tax = 0,          
NSERtax = 0,    
sebi_tax = 0,    
Ins_chrg = 0,    
other_chrg = 0,    
Broker_chrg = 0,    
    
Tmark = ''         
from settlement S With(Index(Party),NoLock),        
scrip1 (NOLOCK),         
scrip2 (NOLOCK),         
client2 (NOLOCK)           
where S.party_code = @Party_code          
and S.party_code = client2.Party_code         
and client2.Party_code = @Party_code          
and S.sett_no <> @Sett_no         
and S.sett_type = @sett_Type          
and S.scrip_cd=scrip2.scrip_cd         
and S.series=scrip2.series          
and S.tradeqty > 0          
and S.sauda_date LIKE  @sdate + '%'          
and scrip2.co_code=scrip1.co_code          
and scrip2.series=scrip1.series          
and S.contractno = @ContNo        
        
        
UNION         
        
SELECT S.contractNo,         
S.party_code,         
S.order_no,         
tm=convert(char,sauda_date,108),          
S.trade_no,         
S.sauda_date,         
S.scrip_cd,          
scripname22 = (case when (len(scrip1.long_name) <= 22) then (left((scrip1.long_name + Space(22-Len(scrip1.long_name)-1)), 22)) else (left(scrip1.long_name, 21)) end) + '.',          
scripname=scrip1.long_name,         
sdt=convert(char,sauda_date,103),          
S.sell_buy,        
S.markettype,         
service_tax=( case when service_chrg = 1 then 0 else isnull(S.service_tax,0) end),         
pqty=isnull((case sell_buy when 1 then S.tradeqty end),0),          
sqty=isnull((case sell_buy when 2 then S.tradeqty end),0),          
prate=isnull((case sell_buy when 1 then S.marketrate end),0),          
srate=isnull((case sell_buy when 2 then S.marketrate end),0),          
pbrok=isnull((case sell_buy when 1 then  ( case when service_chrg = 1 then S.NBrokApp + (nsertax/tradeqty) else S.NBrokApp end) end),0),          
sbrok=isnull((case sell_buy when 2 then  ( case when service_chrg = 1 then S.NBrokApp - (nsertax/tradeqty) else S.NBrokApp end) end),0),          
pnetrate=isnull((case sell_buy when 1 then ( case when service_chrg = 1 then S.marketrate + S.NBrokApp + (nsertax/tradeqty)  else  S.marketrate + S.NBrokApp   end )   end),0),          
snetrate=isnull((case sell_buy  when 2 then ( case when service_chrg = 1 then   S.marketrate - S.NBrokApp - (nsertax/tradeqty)  else  S.marketrate - S.NBrokApp   end )   end),0),          
pamt=isnull((case sell_buy  when 1 then ( case when service_chrg = 1 then   (S.marketrate + S.NBrokApp) * tradeqty + nsertax  else  (S.marketrate + S.NBrokApp) * tradeqty  end )   end),0),          
samt=isnull((case sell_buy  when 2 then ( case when service_chrg = 1 then   (S.marketrate - S.NBrokApp) * tradeqty - nsertax  else  (S.marketrate - S.NBrokApp) * tradeqty  end )   end),0),          
Brokerage=isnull((tradeqty*NBrokApp),0),         
S.sett_no,          
turn_tax = Case when @TurnOver_tax = 1 then turn_tax else 0 end ,          
NSERtax = case when @Service_chrg = 0 then nsertax else 0 end ,          
sebi_tax = case when @Sebi_turn_tax = 1 then sebi_tax else 0 end ,          
Ins_chrg = case when @Insurance_Chrg = 1 then Ins_chrg else 0 end ,          
other_chrg = case when @Other_chrg = 1 then S.other_chrg else 0 end ,          
Broker_chrg = case when @stampDuty = 1 then Broker_chrg else 0 end ,          
Tmark = case when BillFlag in (1,4,5) then 'D' else '' end            
from settlement S With(Index(Party),NoLock),         
scrip1 (NOLOCK),         
scrip2 (NOLOCK),         
client2 (NOLOCK)          
where S.party_code  = client2.Party_code         
and S.party_code = @Party_code          
and client2.Party_code = @Party_code          
and S.sett_no = @Sett_no          
and S.sett_type = @sett_Type          
and S.scrip_cd=scrip2.scrip_cd          
and S.series=scrip2.series          
and S.tradeqty > 0          
and scrip2.co_code=scrip1.co_code          
and scrip2.series=scrip1.series          
order by scrip1.long_name

GO
