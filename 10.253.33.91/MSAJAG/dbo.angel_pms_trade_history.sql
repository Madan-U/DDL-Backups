-- Object: PROCEDURE dbo.angel_pms_trade_history
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure angel_pms_trade_history(@pcode as varchar(10),@fdate as varchar(11))    
as    
set nocount on    
    
set transaction isolation level read uncommitted    
select scrip_cd,scrip_name=space(25),    
trade_no,marketrate=marketrate*100,tradeqty,user_id,    
cbrk=0,    
cusr=0,    
ttime=convert(varchar(8),sauda_Date,108),    
tdate=convert(varchar(10),sauda_Date,103),    
party_code,    
sell_buy=case when sell_buy=1 then 'B' else 'S' end,    
l='L',    
order_no,    
pro_cli=case when pro_cli='1' then 'CLIENT' else pro_cli end,    
isin=space(25)    
into #file1    
from     
history (nolock)    
where party_Code=@pcode and sauda_Date >=@fdate+' 00:00:00'     
and sauda_date <= @fdate+' 23:59:59'    
and user_id in (select Branchd_CTCLUserid  from intranet.risk.dbo.v_ctcl_sb_details where ctcl_odinid='ACME1' and ctcl_status='Active' and Branchd_lineid <> 'IML' and ctclBranch_segment='NSE')
   
   
update #file1 set scrip_name=b.short_name from                   
(select b.scrip_cd,b.series,a.short_name from scrip1 a (nolock), scrip2 b (nolock) where a.co_code=b.co_code) b                  
where #bse_file1.nse_symbol=b.scrip_cd and #bse_file1.nse_group=b.series 
                  
                      
update #file1 set isin=b.isin from angeldemat.msajag.dbo.multiisin b    
where #file1.scrip_Cd=b.scrip_Cd and b.valid=1    
    
select * from #file1     
    
set nocount off

GO
