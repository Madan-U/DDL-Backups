-- Object: PROCEDURE dbo.sp_angel_JV_verifier_data
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE procedure sp_angel_JV_verifier_data  
as  
  
set transaction isolation level read uncommitted              
set nocount on              
              
declare @fdate as varchar(11)                    
select @fdate=convert(varchar(11),sdtcur) from parameter (nolock) where getdate() >= sdtcur and getdate() <= ldtcur              
print @fdate              
              
            
declare @getdate as varchar(25)                    
set @getdate = convert(varchar(11),getdate())+' 23:59:59'                  
print @getdate

declare @gdate as varchar(25)                            
set @gdate = convert(varchar(11),getdate())+' 00:00:00'                          
print @gdate                          
                              
                         
--------------------- NSE Ledger Balance   T-2 Balance              
  
set transaction isolation level read uncommitted                          
select cltcode,ACDL_Balancea=sum(case when upper(drcr)='D' then vamt else -vamt end)                            
into #nse_led_a                          
from ledger with (index=lededtind nolock) where   
cltcode >='A0001' and cltcode <='ZZZZZ'                            
and vdt >=@fdate                           
and edt <= @getdate    
--and cltcode in (select party_Code from #cli)                            
group by cltcode                             
              
                         
--------------------- NSe Ledger Balance 2   Current Balance                       
set transaction isolation level read uncommitted                          
select cltcode,ACDL_Balanceb=sum(case when upper(drcr)='D' then vamt else -vamt end)                            
into #nse_led_b                            
from ledger with (index=lededtind nolock)   
where cltcode >='A0001' and cltcode <='ZZZZZZ'                            
and vdt >=@fdate and vdt <= @getdate                            
group by cltcode                             
  
------------------- Credit Bill Value  
set transaction isolation level read uncommitted                          
select cltcode,cr_amt=sum(vamt) into #nse_cramt   
from ledger with (index=lededtind nolock)   
where vdt <=@getdate  and  edt >= @getdate  and drcr='C'              
group by cltcode              
  
------------------- Deducting Credit Value from actual Balance  
set transaction isolation level read uncommitted                          
update #nse_led_b set acdl_balanceb = acdl_balanceb + cr_Amt from #nse_cramt b (nolock) where #nse_led_b.cltcode=b.cltcode              
  
------------------ Reco Pending Amt Deducted  
  
select cltcode,AcdL_Balancec=sum(cramt)               
into #nse_led_c              
from Angel_client_deposit_recno (nolock)  
group by cltcode  
              
update #nse_led_b set acdl_balanceb = acdl_balanceb+b.ACDL_Balancec                
from #nse_led_c b where #nse_led_b.cltcode=b.cltcode              
  
-------------------- Updating Table  
  
truncate table Angel_JV1  
  
insert into Angel_JV1  
select a.*,b.ACDL_Balanceb from  #nse_led_a a left outer join #nse_led_b b on a.cltcode=b.cltcode --where a.acdl_balancea <> 0  
  
delete from Angel_JV1 where acdl_balancea+acdl_balanceb = 0  
  
  
set nocount off

GO
