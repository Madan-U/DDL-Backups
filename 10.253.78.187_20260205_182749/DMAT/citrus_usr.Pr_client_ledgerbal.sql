-- Object: PROCEDURE citrus_usr.Pr_client_ledgerbal
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--exec [Pr_client_ledgerbal] '203412','Apr  1 2009','Mar 31 2010','1203270000274032','mar 23 2010',''  
  
CREATE Proc [citrus_usr].[Pr_client_ledgerbal]          
@pa_dpmid varchar(100),          
@pa_finyearfrom varchar(50),   
@pa_finyearto varchar(50),   
@pa_sba_no varchar(20),        
@pa_fromdate datetime,          
@pa_output varchar(8000) output  As          
begin  
  
declare @@ssql varchar(8000)  
--declare @@dpmid varchar(200)
declare @@finyrid varchar

--SET @@dpmid = (select dpm_id from dp_mstr where dpm_dpid = @pa_dpm_dpid and dpm_deleted_ind = 1)   
--print @@dpmid

SET @@finyrid = (select fin_id from financial_yr_mstr 
where fin_start_dt between convert(varchar(11),@pa_finyearfrom,109) and convert(varchar(11),@pa_finyearto,109)
and fin_end_dt between convert(varchar(11),@pa_finyearfrom,109) and convert(varchar(11),@pa_finyearto,109)
and fin_dpm_id = @pa_dpmid
and fin_deleted_ind = 1)

print @@finyrid

create Table #temptable          
(          
 dpam_sba_no varchar(20)  
,amt numeric(18,3)      
)      
  
set @@ssql = 'Insert into #temptable'           
set @@ssql = @@ssql + ' select dpam_sba_no, sum(ldg_amount) amt'       
set @@ssql = @@ssql + ' from ledger' + @@finyrid + ' , dp_acct_mstr account '  
set @@ssql = @@ssql + ' where ldg_dpm_id = ' + convert(varchar,@pa_dpmid) + '  and ldg_voucher_dt <= ''' + convert(varchar(11),@pa_fromdate,109) + ''''  
set @@ssql = @@ssql + ' and ldg_account_id = account.dpam_id '              
set @@ssql = @@ssql + ' and ldg_account_type = ''P'' and ldg_deleted_ind =1 and dpam_deleted_ind = 1 '              
set @@ssql = @@ssql + ' and dpam_sba_no = ' + @pa_sba_no   
set @@ssql = @@ssql + 'group by dpam_sba_no '   
exec(@@ssql)       
  print @@ssql
select * from   #temptable     
           
  
end

GO
