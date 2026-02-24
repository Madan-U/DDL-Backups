-- Object: PROCEDURE dbo.sp_angel_cms_verifier_data
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE procedure sp_angel_cms_verifier_data              
as              
              
set transaction isolation level read uncommitted                          
set nocount on                          
                          
declare @fdate as varchar(11)                                
select @fdate=convert(varchar(11),sdtcur) from parameter (nolock) where getdate() >= sdtcur and getdate() <= ldtcur                          
--print @fdate                          
                          
                           
declare @getdate as varchar(25)                                
set @getdate = convert(varchar(11),getdate())+' 23:59:59'                              
--print @getdate                              
            
select cltcode into #t from intranet.risk.dbo.cmsdata where chqamt <> 0            
                                     
--------------------- NSE Ledger Balance   T-2 Balance                          
              
set transaction isolation level read uncommitted                                      
select cltcode,ACDL_Balancea=sum(case when upper(drcr)='D' then vamt else -vamt end)                                        
into #nse_led_a                                      
from ledger with (index=lededtind nolock) where               
cltcode in (select cltcode from #t )            
--cltcode >='A0001' and cltcode <='ZZZZZ'                                        
and vdt >=@fdate                                       
and edt <= @getdate                
--and cltcode in (select party_Code from #cli)                                        
group by cltcode                                         
                          
                                     
--------------------- NSe Ledger Balance 2   Current Balance                                   
set transaction isolation level read uncommitted                                      
select cltcode,ACDL_Balanceb=sum(case when upper(drcr)='D' then vamt else -vamt end)                                        
into #nse_led_b                                        
from ledger with (index=lededtind nolock) where               
cltcode in (select cltcode from #t )            
--where cltcode >='A0001' and cltcode <='ZZZZZZ'                                        
and vdt >=@fdate and vdt <= @getdate                                        
group by cltcode                                         
              
------------------- Credit Bill Value              
set transaction isolation level read uncommitted                                      
select cltcode,cr_amt=sum(vamt) into #nse_cramt               
from ledger with (index=lededtind nolock)               
where cltcode in (select cltcode from #t ) and            
vdt <=@getdate  and  edt >= @getdate  and drcr='C'                          
group by cltcode                          
              
------------------- Deducting Credit Value from actual Balance              
set transaction isolation level read uncommitted                                      
update #nse_led_b set acdl_balanceb = acdl_balanceb + cr_Amt from #nse_cramt b (nolock) where #nse_led_b.cltcode=b.cltcode                          
              
------------------ Reco Pending Amt Deducted              
/*              
select cltcode,AcdL_Balancec=sum(cramt)                           
into #nse_led_c                          
from Angel_client_deposit_recno (nolock)              
group by cltcode              
                          
update #nse_led_b set acdl_balanceb = acdl_balanceb+b.ACDL_Balancec                            
from #nse_led_c b where #nse_led_b.cltcode=b.cltcode                          
*/              
-------------------- Updating Table              
truncate table Angel_Cms               
insert into Angel_Cms               
select a.*,b.ACDL_Balanceb from  #nse_led_a a left outer join #nse_led_b b on a.cltcode=b.cltcode --where a.acdl_balancea <> 0              
              
delete from Angel_Cms where acdl_balancea+acdl_balanceb = 0              
         
Truncate table Angel_cms_Del          
      
------------------------------Net Trade ------------------------------------------------              
select Party_code,Net_Trade = ((sum(SAmtTrd) - sum(PAmtTrd)) - sum(service_tax+broker_chrg+Turn_Tax+Ins_Chrg+Sebi_Tax))      
into #trd  from msajag.dbo.cmbillvalan  where party_code in (select cltcode from #t ) and sauda_date >= convert(varchar(11),getdate()) and sauda_date <= convert(varchar(11),getdate())+' 23:59:59'                                    
group by Party_code  having sum(SAmtTrd) <> 0 and sum(PAmtTrd) <> 0      
------------------------------------Net Delivery------------------      
      
select Party_code,Net_Del = (sum(SAmtDel) - sum(PAmtDel)) - sum(service_tax+broker_chrg+Turn_Tax+Ins_Chrg+Sebi_Tax)          
into #Del from msajag.dbo.cmbillvalan   where party_code in (select cltcode from #t ) and sauda_date >= convert(varchar(11),getdate()) and sauda_date <= convert(varchar(11),getdate())+' 23:59:59'                                    
group by Party_code having sum(SAmtDel) <> 0 or sum(PAmtDel) <> 0      
       
select * into #final from      
(      
select a.Party_code,Net_Trade= isnull(sum(Net_Trade),0),Net_del = isnull(sum(Net_Del),0)        
from #trd a left outer join #Del b on a.party_code = b.party_code group by a.Party_code         
union      
select a.Party_code,Net_Trade= isnull(sum(Net_Trade),0),Net_del = isnull(sum(Net_Del),0)        
from #Del a left outer join #trd b on a.party_code = b.party_code  group by a.Party_code               
) x      
      
insert into Angel_cms_Del        
select * from #final where net_trade+Net_del < 0       

                  
SELECT * into #t1 FROM #final WHERE net_trade <> 0 and Net_del <> 0

delete from Angel_cms_Del where party_code in (select party_code from #t1)

insert into Angel_cms_Del
SELECT Party_code,0,sum(SAmtDel)-sum(PAmtDel)+(sum(SAmtTrd)-sum(PAmtTrd)-(sum(service_tax)+sum(broker_chrg)+sum(Turn_Tax)+sum(Ins_Chrg)+sum(Sebi_Tax))) 
FROM msajag.dbo.cmbillvalan  WHERE PARTY_CODE in (select party_code from #t1) AND sauda_date >= convert(varchar(11),getdate()) and sauda_date <= convert(varchar(11),getdate())+' 23:59:59' 
group by Party_code having sum(SAmtDel)-sum(PAmtDel)+(sum(SAmtTrd)-sum(PAmtTrd)-(sum(service_tax)+sum(broker_chrg)+sum(Turn_Tax)+sum(Ins_Chrg)+sum(Sebi_Tax))) < 0                          
      
          
set nocount off

GO
