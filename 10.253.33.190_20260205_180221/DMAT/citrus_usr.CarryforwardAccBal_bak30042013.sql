-- Object: PROCEDURE citrus_usr.CarryforwardAccBal_bak30042013
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--drop table ##LEDGERTEMP

--select * from dp_mstr where default_dp = dpm_excsm_id
--CarryforwardAccBal 12345678,'HO'  
create Proc [citrus_usr].[CarryforwardAccBal_bak30042013]  
@pa_dpmid varchar(10),  
@pa_loginname varchar(50)  
As  
begin  
  
  
declare @@prev_fin_id varchar(10),  
@@next_fin_id varchar(10),  
@@next_start_dt varchar(11),  
@@next_end_dt varchar(11),  
@@incomegroup varchar(10),  
@@expensegroup varchar(10),  
@@profitlossacc varchar(20),  
@@ssql varchar(8000),  
@@dpm_id VARCHAR(10)
  
select @@incomegroup = isnull(convert(varchar,fingm_group_code),'99999999999999999') from fin_group_mstr where fingm_group_name = 'INCOME' and fingm_deleted_ind = 1
select @@expensegroup = isnull(convert(varchar,fingm_group_code),'99999999999999999') from fin_group_mstr where fingm_group_name = 'EXPENDITURE' and fingm_deleted_ind = 1 
select @@profitlossacc = isnull(convert(varchar,fina_acc_id),'99999999999999999') from fin_account_mstr where fina_acc_name = 'PROFIT & LOSS' and fina_deleted_ind = 1
 
select @@dpm_id = '999'--dpm_id from dp_mstr where default_dp=dpm_excsm_id and dpm_deleted_ind=1 AND DPM_DPID=@pa_dpmid
  
  
Declare fincursor cursor  for  
select prev_fin_id=Convert(varchar,fin_id),  
next_fin_id =isnull((SELECT top 1 Convert(varchar,fin_id) from Financial_Yr_Mstr f1 where f1.fin_dpm_id = f.fin_dpm_id and f1.fin_start_dt > f.fin_start_dt order by f1.fin_start_dt),'COMPLETE')  
from Financial_Yr_Mstr f  
--where fin_dpm_id = @pa_dpmid   
where fin_dpm_id = @@dpm_id
and fin_start_dt >=   
isnull((select Min(fin_start_dt) from Financial_Yr_Mstr where fin_dpm_id = @@dpm_id  and isnull(fin_cf_balances,'N') = 'Y'),'Dec 31 2100')   
and fin_deleted_ind = 1
order by fin_start_dt asc  
  
  
open fincursor  
fetch next from fincursor into @@prev_fin_id,@@next_fin_id  
while @@fetch_status = 0   
begin  
 if @@next_fin_id <> 'COMPLETE'  
 begin  
    
        select @@next_start_dt= convert(varchar(11),fin_start_dt,109),@@next_end_dt= convert(varchar(11),fin_end_dt,109) from Financial_Yr_Mstr with(nolock) where fin_id = @@next_fin_id  and fin_deleted_ind = 1
    
  
  set @@ssql = 'update ledger' + @@next_fin_id + ' set LDG_DELETED_IND = 0 where LDG_VOUCHER_DT = ''' + @@next_start_dt + ''' and LDG_VOUCHER_NO = 0 and ldg_trans_type = ''O'''  
  exec(@@ssql)  
    

  --
  SET @@SSQL = 'select IDENTITY(BIGINT,1,1) ID,LDG_DPM_ID=' + @@dpm_id + ',LDG_VOUCHER_TYPE=''3'',LDG_BOOK_TYPE_CD=''0'',LDG_VOUCHER_NO=0,LDG_SR_NO=0,LDG_REF_NO='''',LDG_VOUCHER_DT=''' + @@next_start_dt + ''',LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,sum(isnull(LDG_AMOUNT,0)) LDG_AMOUNT,LDG_NARRATION=''Opening Balance'',LDG_BANK_ID=null,LDG_ACCOUNT_NO=null,LDG_INSTRUMENT_NO=null,LDG_BANK_CL_DATE=null,LDG_COST_CD_ID=null,LDG_BILL_BRKUP_ID=null,LDG_TRANS_TYPE=''O'',LDG_STATUS=''A'',LDG_CREATED_BY=''' + @pa_loginname+ ''',LDG_CREATED_DT=getdate(),LDG_LST_UPD_BY=''' + @pa_loginname+ ''',LDG_LST_UPD_DT=getdate(),LDG_DELETED_IND=1,LDG_BRANCH_ID=null  
  INTO #LEDGERTEMP from ledger' + @@prev_fin_id + ' with(nolock) left outer join fin_account_mstr with(nolock) on ldg_account_id = fina_acc_id  and fina_deleted_ind = 1
  where citrus_usr.Fn_ChildExists(' + @@incomegroup + ',fina_group_id) = 0 and citrus_usr.Fn_ChildExists(' + @@expensegroup + ',fina_group_id) = 0  
  and LDG_DELETED_IND = 1 
  group by LDG_ACCOUNT_ID  , LDG_ACCOUNT_TYPE
  having sum(isnull(LDG_AMOUNT,0)) <> 0
  
  DECLARE @L_ID NUMERIC 
  SELECT @L_ID = ISNULL(MAX(LDG_ID),0)+1 FROM LEDGER' + @@next_fin_id +
  ' insert into ledger' + @@next_fin_id + '(LDG_ID,LDG_DPM_ID,LDG_VOUCHER_TYPE,LDG_BOOK_TYPE_CD,LDG_VOUCHER_NO,LDG_SR_NO,LDG_REF_NO,LDG_VOUCHER_DT,LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,LDG_AMOUNT,LDG_NARRATION,LDG_BANK_ID,LDG_ACCOUNT_NO,LDG_INSTRUMENT_NO,LDG_BANK_CL_DATE,LDG_COST_CD_ID,LDG_BILL_BRKUP_ID,LDG_TRANS_TYPE,LDG_STATUS,LDG_CREATED_BY,LDG_CREATED_DT,LDG_LST_UPD_BY,LDG_LST_UPD_DT,LDG_DELETED_IND,LDG_BRANCH_ID)  
  select ID + @L_ID ,LDG_DPM_ID,LDG_VOUCHER_TYPE,LDG_BOOK_TYPE_CD,LDG_VOUCHER_NO,LDG_SR_NO,LDG_REF_NO,LDG_VOUCHER_DT,LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,LDG_AMOUNT,LDG_NARRATION,LDG_BANK_ID,LDG_ACCOUNT_NO,LDG_INSTRUMENT_NO,LDG_BANK_CL_DATE,LDG_COST_CD_ID,LDG_BILL_BRKUP_ID,LDG_TRANS_TYPE,LDG_STATUS,LDG_CREATED_BY,LDG_CREATED_DT,LDG_LST_UPD_BY,LDG_LST_UPD_DT,LDG_DELETED_IND,LDG_BRANCH_ID  
  from #LEDGERTEMP'  

  print @@ssql
  exec(@@ssql)  
  
  
  set @@ssql = 'insert into ledger' + @@next_fin_id + '(LDG_ID,LDG_DPM_ID,LDG_VOUCHER_TYPE,LDG_BOOK_TYPE_CD,LDG_VOUCHER_NO,LDG_SR_NO,LDG_REF_NO,LDG_VOUCHER_DT,LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,LDG_AMOUNT,LDG_NARRATION,LDG_BANK_ID,LDG_ACCOUNT_NO,LDG_INSTRUMENT_NO,LDG_BANK_CL_DATE,LDG_COST_CD_ID,LDG_BILL_BRKUP_ID,LDG_TRANS_TYPE,LDG_STATUS,LDG_CREATED_BY,LDG_CREATED_DT,LDG_LST_UPD_BY,LDG_LST_UPD_DT,LDG_DELETED_IND,LDG_BRANCH_ID)  
  select LDG_ID,LDG_DPM_ID=' + @@dpm_id + ',LDG_VOUCHER_TYPE=''3'',LDG_BOOK_TYPE_CD=''0'',LDG_VOUCHER_NO=0,LDG_SR_NO=0,LDG_REF_NO='''',LDG_VOUCHER_DT=''' + @@next_start_dt + ''',LDG_ACCOUNT_ID=' + @@profitlossacc + ',LDG_ACCOUNT_TYPE,sum(isnull(LDG_AMOUNT,0)),LDG_NARRATION=''Opening Balance'',LDG_BANK_ID=null,LDG_ACCOUNT_NO=null,LDG_INSTRUMENT_NO=null,LDG_BANK_CL_DATE=null,LDG_COST_CD_ID=null,LDG_BILL_BRKUP_ID=null,LDG_TRANS_TYPE=''O'',LDG_STATUS=''A'',LDG_CREATED_BY=''' + @pa_loginname+ ''',LDG_CREATED_DT=getdate(),LDG_LST_UPD_BY=''' + @pa_loginname+ ''',LDG_LST_UPD_DT=getdate(),LDG_DELETED_IND=1,LDG_BRANCH_ID=null  
  from ledger' + @@prev_fin_id + ' with(nolock) left outer join fin_account_mstr with(nolock) on ldg_account_id = fin_acc_id  
  where LDG_DELETED_IND = 1 and fina_deleted_ind = 1 and (citrus_usr.Fn_ChildExists(' + @@incomegroup + ',fina_group_id) = 1 or citrus_usr.Fn_ChildExists(' + @@expensegroup + ',fina_group_id) = 1))  
  group by LDG_ACCOUNT_ID  
  having sum(isnull(LDG_AMOUNT,0)) <> 0'  
print @@ssql
  exec(@@ssql)  
  
  
  set @@ssql = 'update a   
         set ACCBAL_AMOUNT = isnull((select isnull(sum(LDG_AMOUNT),0) from ledger' + @@prev_fin_id + ' where ACCBAL_ACCT_ID = LDG_ACCOUNT_ID and ACCBAL_ACCT_TYPE = LDG_ACCOUNT_TYPE and LDG_DELETED_IND = 1 and ACCBAL_DELETED_IND = 1),0)  
         from Accountbal' + @@next_fin_id + ' a with(nolock) where ACCBAL_DELETED_IND = 1'  
  print @@ssql
  exec(@@ssql)  
  
  set @@ssql = 'insert into Accountbal' + @@next_fin_id + '(ACCBAL_DPM_ID,ACCBAL_ACCT_ID,ACCBAL_ACCT_TYPE,ACCBAL_AMOUNT,ACCBAL_CREATED_BY,ACCBAL_CREATED_DT,ACCBAL_LST_UPD__BY,ACCBAL_LST_UPD__DT,ACCBAL_DELETED_IND)  
  select ACCBAL_DPM_ID=' + @@dpm_id + ',LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,AMOUNT=sum(isnull(LDG_AMOUNT,0)),ACCBAL_CREATED_BY=''' + @pa_loginname + ''',ACCBAL_CREATED_DT=getdate(),ACCBAL_LST_UPD__BY=''' + @pa_loginname + ''',ACCBAL_LST_UPD__DT=getdate(),ACCBAL_DELETED_IND=1
  from ledger' + @@prev_fin_id + ' with(nolock)  
  where not exists(select ACCBAL_ACCT_ID,ACCBAL_ACCT_TYPE from Accountbal' + @@next_fin_id + ' with(nolock) where ACCBAL_ACCT_ID = LDG_ACCOUNT_ID and ACCBAL_ACCT_TYPE = LDG_ACCOUNT_TYPE and LDG_DELETED_IND = 1 and ACCBAL_DELETED_IND = 1 ) 
  group by LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE'  
print @@ssql
  exec(@@ssql)  
  
  
  
  
  update Financial_Yr_Mstr set fin_cf_balances = 'N' where fin_dpm_id = @@dpm_id and fin_id = @@prev_fin_id  
 end  
  
  
fetch next from fincursor into @@prev_fin_id,@@next_fin_id  
end  
  
Close fincursor  
Deallocate fincursor  
  
  
end

GO
