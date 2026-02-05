-- Object: PROCEDURE citrus_usr.pr_get_quaterly_ledger_data
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--exec [pr_get_quaterly_ledger_data] 'MAy 01 2013','MAy 31 2013'
CREATE proc [citrus_usr].[pr_get_quaterly_ledger_data](@pa_from_dt datetime,@pa_to_dt datetime)
as
begin 

SET @pa_from_dt = DATEADD(QQ, DATEDIFF(QQ,0,GETDATE()-10),0) 
SET @pa_to_dt   = DATEADD(s,-1,DATEADD(QQ, DATEDIFF(QQ,0,GETDATE()-10)+1,0)) 


declare @l_fin_id numeric
set @l_fin_id  = 0 
declare @l_str varchar(4000)

select @l_fin_id   = fin_id from financial_yr_mstr where @pa_from_dt between FIN_START_DT and FIN_END_DT


declare @l_str_new varchar(8000)
set @l_str_new = ''
set @l_str_new = @l_str_new + ' select * into #ledger_temp from (select LDG_VOUCHER_DT'
set @l_str_new = @l_str_new + ' ,LDG_ACCOUNT_ID'
set @l_str_new = @l_str_new + ' ,LDG_ACCOUNT_TYPE'
set @l_str_new = @l_str_new + ' ,LDG_AMOUNT,LDG_NARRATION,LDG_DELETED_IND from ledger'+convert(varchar(10),@l_fin_id)+'' 
set @l_str_new = @l_str_new + ' where ldg_voucher_dt between ''' + convert(varchar(11),@pa_from_dt ,109) + ''' and ''' + convert(varchar(11),@pa_to_dt ,109) + ''' '
set @l_str_new = @l_str_new + ' and ldg_deleted_ind = 1 and ldg_account_type =''P'' '
set @l_str_new = @l_str_new + ' and ldg_voucher_no <> ''0'' '
set @l_str_new = @l_str_new + ' union all'
set @l_str_new = @l_str_new + ' select ldg_voucher_dt,LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,sum(ldg_amount) ldg_amount , narr,LDG_DELETED_IND from ( '
set @l_str_new = @l_str_new + ' select ''' + convert(varchar(11),@pa_from_dt ,109) + ''' ldg_voucher_dt '
set @l_str_new = @l_str_new + ' ,LDG_ACCOUNT_ID'
set @l_str_new = @l_str_new + ' ,LDG_ACCOUNT_TYPE'
set @l_str_new = @l_str_new + ' ,LDG_AMOUNT,''Opening balance'' narr,LDG_DELETED_IND from ledger'+convert(varchar(10),@l_fin_id)+'' 
set @l_str_new = @l_str_new + ' where ldg_voucher_dt < ''' + convert(varchar(11),@pa_from_dt ,109) + '''  and ldg_account_type =''P'' '
set @l_str_new = @l_str_new + ' and ldg_deleted_ind = 1  '
set @l_str_new = @l_str_new + ' and ldg_voucher_no <> ''0'' '
set @l_str_new = @l_str_new + ' union all'
set @l_str_new = @l_str_new + ' select ''' + convert(varchar(11),@pa_from_dt ,109) + ''' '
set @l_str_new = @l_str_new + ' ,LDG_ACCOUNT_ID'
set @l_str_new = @l_str_new + ' ,LDG_ACCOUNT_TYPE'
set @l_str_new = @l_str_new + ' ,LDG_AMOUNT,''Opening balance'',LDG_DELETED_IND from ledger'+convert(varchar(10),@l_fin_id)+''  
set @l_str_new = @l_str_new + ' where ldg_deleted_ind = 1  and ldg_account_type =''P'' ' 
set @l_str_new = @l_str_new + ' and ldg_voucher_no = ''0'''
set @l_str_new = @l_str_new + ' union all '
set @l_str_new = @l_str_new + ' select ''' + convert(varchar(11),@pa_from_dt ,109) + ''',dpam_id,''P'',''0'',''opening balance'',1 from dp_acct_mstr with(nolock) '
set @l_str_new = @l_str_new + ' where not exists (select ldg_account_id from ledger'+convert(varchar(10),@l_fin_id)+' where ldg_deleted_ind = 1 and ldg_account_id = dpam_id  '
set @l_str_new = @l_str_new + ' and ldg_voucher_dt < ''' + convert(varchar(11),@pa_from_dt ,109) + ''' '
set @l_str_new = @l_str_new + ' and ldg_deleted_ind = 1 and ldg_account_type =''P'') )  a '
set @l_str_new = @l_str_new + ' group by ldg_voucher_dt,LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,narr,LDG_DELETED_IND'
set @l_str_new = @l_str_new + ' ) main' --where ldg_account_id = 592144

print @l_str_new

 

truncate  table quaterlyledgerdata

set @l_str =''
set @l_str = @l_str_new + ' select dpam_sba_no dpcode, 
CONVERT(VARCHAR(8),convert(datetime,ldg_voucher_dt,109), 112)  date,
isnull(ldg_narration,'''') Particular,
case when sum(ldg_amount)<0 then abs(sum(ldg_amount)) else 0 end debit,
case when sum(ldg_amount)>0 then abs(sum(ldg_amount) ) else 0 end credit
,case when (select sum(ldg_amount) from #ledger_temp intbl where ldg_deleted_ind = 1 
and intbl.ldg_account_id = outtbl.ldg_account_id 
and intbl.ldg_account_type =''P''
and intbl.ldg_voucher_dt <outtbl.ldg_voucher_dt 
group by intbl.ldg_account_id ) + sum(outtbl.ldg_amount) < 0 then  isnull(convert(varchar,abs((select sum(ldg_amount) from #ledger_temp intbl where ldg_deleted_ind = 1 
and intbl.ldg_account_id = outtbl.ldg_account_id 
and intbl.ldg_account_type =''P''
and intbl.ldg_voucher_dt < outtbl.ldg_voucher_dt 
group by intbl.ldg_account_id ) + sum(outtbl.ldg_amount))) + '' DR'','''') else  isnull(convert(varchar,abs((select sum(ldg_amount) from #ledger_temp intbl where ldg_deleted_ind = 1 
and intbl.ldg_account_id = outtbl.ldg_account_id 
and intbl.ldg_account_type =''P''
and intbl.ldg_voucher_dt <outtbl.ldg_voucher_dt 
group by intbl.ldg_account_id ) + sum(outtbl.ldg_amount) )) + '' CR'','''') end  balance
,''' + convert(varchar(8),convert(datetime,@pa_to_dt,109),112) + ''' holdingdate


into #quaterlyledgerdata1
from #ledger_temp outtbl ,dp_acct_mstr
where ldg_account_id = dpam_id 
and ldg_account_type =''P''
and ldg_voucher_dt between ''' + convert(varchar(11),@pa_from_dt ,109) + ''' and ''' + convert(varchar(11),@pa_to_dt ,109) + ''' 
and ldg_deleted_ind = 1 
group by ldg_account_id , dpam_sba_no ,ldg_voucher_dt ,ldg_narration


insert into quaterlyledgerdata 
select dpcode,date,particular,debit,credit,case when balance ='''' then case when debit <> 0 then convert(varchar,debit)+ '' DR''
when credit <> 0 then convert(varchar,credit)+ '' CR'' 
when credit = 0  and debit = 0 then ''0'' end else  balance end balance 
,holdingdate
--into quaterlyledgerdata
   from #quaterlyledgerdata1'
print @l_str 
exec( @l_str )

select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
into #account_properties from account_properties 
where accp_accpm_prop_cd = 'BILL_START_DT' 
and accp_value not in ('')

select distinct convert(datetime,accp_value,103) accp_value_cl
, accp_clisba_id accp_clisba_id_cl , accp_accpm_prop_cd accp_accpm_prop_cd_cl 
into #account_properties_close from account_properties 
where accp_accpm_prop_cd = 'ACC_CLOSE_DT' 
and accp_value not in ('','//') 

create index ix_1 on #account_properties(accp_clisba_id , accp_value )
create index ix_2 on #account_properties_close(accp_clisba_id_cl , accp_value_cl )





delete  from quaterlyledgerdata where dpcode in (select distinct dpcode from quaterlyledgerdata group by dpcode 
having count(1)=1--418595
) and debit = 0 and credit = 0 

delete a from quaterlyledgerdata a
where dpcode in (select dpam_sba_no from #account_properties_close,dp_acct_mstr where dpam_id = accp_clisba_id_cl 
and accp_value_cl < @pa_from_dt
)



truncate table #account_properties
truncate table #account_properties_close

end

GO
