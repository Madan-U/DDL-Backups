-- Object: PROCEDURE dbo.Angel_PMS_trade_data_history
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure Angel_PMS_trade_data_history (@pcode as varchar(10),@fcode as varchar(10),@tdate as varchar(11))                  
as                  
--------------------------------------- NSE Query                  
                  
set nocount on                 
                  
set transaction isolation level read uncommitted                  
--          
--declare @pcode as varchar(10)        
--set @pcode='%'        
        
if @pcode='%'        
begin        
select party_code into #party1 from intranet.testdb.dbo.PMS_info         
        
             
----declare @tdate as varchar(11)        
----set @tdate='May 08 2009'        
        
select  SEBI_NO='INB010996539',ContractNo,Exchange='N',TradeDate=convert(varchar(11),Sauda_Date,103),                  
segment1=(Case when sett_type='N' then 'Rolling' else 'T2T' end),                  
settlement_number=substring(sett_no,5,3),                  
settlement_year=substring(sett_no,1,4),                  
Backofficecode=party_code,                  
bse_code=space(6),                  
nse_symbol=ltrim(rtrim(scrip_cd)),                  
nse_group=series,                  
isin=space(20),                  
scrip_name=space(60),                  
bought_sold=(case when sell_buy='1' then 'B' else 'S' end),                  
traded_quantity=tradeqty,                  
marketrate,                  
N_netrate,                  
--N_netrate=            
--(CASE             
--when sell_buy=1 then ((N_NETRATE*tradeqty)+(NserTax+other_chrg+turn_tax+sebi_tax+Broker_chrg))/tradeqty            
--when sell_buy=2 then ((N_NETRATE*tradeqty)-(NserTax+other_chrg+turn_tax+sebi_tax+Broker_chrg))/tradeqty            
--else 0 end),                  
NserTax=NserTax,                  
Trans_chgs=Ins_chrg,              
other_chrg=other_chrg+turn_tax+sebi_tax+Broker_chrg,                  
--other_chrg=0,                  
stock_payin=space(25),                  
stock_payout=space(25),                  
cash_payin=space(25),                  
cash_payout=space(25)                  
into #bse_file1                  
from history (nolock)            
where party_code IN (SELECT * FROM #party1)                  
and sauda_date>=@tdate+' 00:00:00'                   
and sauda_date<=@tdate+' 23:59:59'                   
and sett_type in ('N','W')                  
and status <> 'N'            
and     
user_id in 
(select Branchd_CTCLUserid  from intranet.risk.dbo.v_ctcl_sb_details where ctcl_odinid='ACME1' and ctcl_status='Active' and Branchd_lineid <> 'IML' and ctclBranch_segment='NSE')

                  
update #bse_file1 set isin=b.isin from                   
(select * from angeldemat.msajag.dbo.multiisin where valid =1 ) b where                   
#bse_file1.bse_code=b.scrip_cd                  
                  
update #bse_file1 set scrip_name=b.long_name from                   
(select b.scrip_cd,b.series,a.long_name from scrip1 a (nolock), scrip2 b (nolock) where a.co_code=b.co_code) b                  
where #bse_file1.nse_symbol=b.scrip_cd and #bse_file1.nse_group=b.series 
                  
                  
                  
update #bse_file1 set                   
stock_payin=convert(varchar(11),sec_payin,103)                  
,stock_payout=convert(varchar(11),sec_payout,103)                  
,cash_payin=convert(varchar(11),b.funds_payin,103)                  
,cash_payout=convert(varchar(11),b.funds_payout,103)                  
from sett_mst b (nolock)                 
where b.sett_type=(Case when #bse_file1.segment1='Rolling' then 'N' else 'W' end)                  
and b.sett_no=settlement_year+''+settlement_number                  
                  
--------------------------------------------------- NSE                  
        
select * from                  
(                  
select * from #bse_file1                  
) a                   
order by exchange,scrip_name,bought_sold         
        
end                 
 -------------------------------------------------------------------------------------------------        
        
if @pcode<>'%'        
begin        
select party_Code into #party2 from client2 (nolock) where cl_code in (                  
(select cl_Code from client1 (nolock) where family=@fcode )                  
union                  
select party_code=@pcode                  
)                   
        
select  SEBI_NO='INB010996539',ContractNo,Exchange='N',TradeDate=convert(varchar(11),Sauda_Date,103),                  
segment1=(Case when sett_type='N' then 'Rolling' else 'T2T' end),                  
settlement_number=substring(sett_no,5,3),                  
settlement_year=substring(sett_no,1,4),                  
Backofficecode=party_code,                  
bse_code=space(6),                  
nse_symbol=ltrim(rtrim(scrip_cd)),                  
nse_group=series,                  
isin=space(20),                  
scrip_name=space(60),                  
bought_sold=(case when sell_buy='1' then 'B' else 'S' end),                  
traded_quantity=tradeqty,                  
marketrate,                  
N_netrate,                  
--N_netrate=            
--(CASE             
--when sell_buy=1 then ((N_NETRATE*tradeqty)+(NserTax+other_chrg+turn_tax+sebi_tax+Broker_chrg))/tradeqty            
--when sell_buy=2 then ((N_NETRATE*tradeqty)-(NserTax+other_chrg+turn_tax+sebi_tax+Broker_chrg))/tradeqty            
--else 0 end),                  
NserTax=NserTax,                  
Trans_chgs=Ins_chrg,              
other_chrg=other_chrg+turn_tax+sebi_tax+Broker_chrg,                  
--other_chrg=0,                  
stock_payin=space(25),                  
stock_payout=space(25),                  
cash_payin=space(25),                  
cash_payout=space(25)                  
into #bse_file2                  
from history (nolock)            
where party_code IN (SELECT * FROM #party2)                  
and sauda_date>=@tdate+' 00:00:00'                   
and sauda_date<=@tdate+' 23:59:59'                   
and sett_type in ('N','W')                  
and status <> 'N'            
and     
user_id in 
(select Branchd_CTCLUserid  from intranet.risk.dbo.v_ctcl_sb_details where ctcl_odinid='ACME1' and ctcl_status='Active' and Branchd_lineid <> 'IML' and ctclBranch_segment='NSE')


update #bse_file2 set isin=b.isin from                   
(select * from angeldemat.msajag.dbo.multiisin where valid =1 ) b where                   
#bse_file2.bse_code=b.scrip_cd                  
                  
update #bse_file2 set scrip_name=b.long_name from                   
(select b.scrip_cd,b.series,a.long_name from scrip1 a (nolock), scrip2 b (nolock) where a.co_code=b.co_code) b                  
where #bse_file2.nse_symbol=b.scrip_cd and #bse_file2.nse_group=b.series 

               
               
                  
update #bse_file2 set                   
stock_payin=convert(varchar(11),sec_payin,103)                  
,stock_payout=convert(varchar(11),sec_payout,103)                  
,cash_payin=convert(varchar(11),b.funds_payin,103)                  
,cash_payout=convert(varchar(11),b.funds_payout,103)                  
from sett_mst b (nolock)                 
where b.sett_type=(Case when #bse_file2.segment1='Rolling' then 'N' else 'W' end)                  
and b.sett_no=settlement_year+''+settlement_number                  
                  
--------------------------------------------------- NSE                  
        
select * from                  
(                  
select * from #bse_file2                  
) a                   
order by exchange,scrip_name,bought_sold         
                  
end                  
set nocount off

GO
