-- Object: PROCEDURE citrus_usr.pr_get_monthly_ledger_data_bakmay282013
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--exec pr_get_monthly_ledger_data 'apr 01 2013','apr 30 2013'
create proc [citrus_usr].[pr_get_monthly_ledger_data_bakmay282013](@pa_from_dt datetime,@pa_to_dt datetime)
as
begin 

declare @l_fin_id numeric
set @l_fin_id  = 0 
declare @l_str varchar(4000)

select @l_fin_id   = fin_id from financial_yr_mstr where @pa_from_dt between FIN_START_DT and FIN_END_DT

drop table monthlyledgerdata
set @l_str =''
set @l_str = 'select dpam_sba_no dpcode, 
CONVERT(VARCHAR(8),convert(datetime,ldg_voucher_dt,109), 112)  date,
isnull(ldg_narration,'''') Particular,
case when sum(ldg_amount)<0 then abs(sum(ldg_amount)) else 0 end debit,
case when sum(ldg_amount)>0 then abs(sum(ldg_amount) ) else 0 end credit
,case when (select sum(ldg_amount) from ledger'+convert(varchar(10),@l_fin_id)+' intbl where ldg_deleted_ind = 1 
and intbl.ldg_account_id = outtbl.ldg_account_id 
and intbl.ldg_account_type =''P''
and intbl.ldg_voucher_dt <outtbl.ldg_voucher_dt 
group by intbl.ldg_account_id ) + sum(outtbl.ldg_amount) < 0 then  isnull(convert(varchar,abs((select sum(ldg_amount) from ledger'+convert(varchar(10),@l_fin_id)+' intbl where ldg_deleted_ind = 1 
and intbl.ldg_account_id = outtbl.ldg_account_id 
and intbl.ldg_account_type =''P''
and intbl.ldg_voucher_dt < outtbl.ldg_voucher_dt 
group by intbl.ldg_account_id ) + sum(outtbl.ldg_amount))) + '' DR'','''') else  isnull(convert(varchar,abs((select sum(ldg_amount) from ledger'+convert(varchar(10),@l_fin_id)+' intbl where ldg_deleted_ind = 1 
and intbl.ldg_account_id = outtbl.ldg_account_id 
and intbl.ldg_account_type =''P''
and intbl.ldg_voucher_dt <outtbl.ldg_voucher_dt 
group by intbl.ldg_account_id ) + sum(outtbl.ldg_amount) )) + '' CR'','''') end  balance
,''' + convert(varchar(8),convert(datetime,@pa_to_dt,109),112) + ''' holdingdate


into monthlyledgerdata
from ledger'+convert(varchar(10),@l_fin_id)+' outtbl ,dp_acct_mstr
where ldg_account_id = dpam_id 
and ldg_account_type =''P''
and ldg_voucher_dt between ''' + convert(varchar(11),@pa_from_dt ,109) + ''' and ''' + convert(varchar(11),@pa_to_dt ,109) + ''' 
and ldg_deleted_ind = 1 
group by ldg_account_id , dpam_sba_no ,ldg_voucher_dt ,ldg_narration'
print @l_str
exec( @l_str )




end

GO
