-- Object: PROCEDURE citrus_usr.pr_rpr_printVoucher_Bak_05092019
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


--select * from ledger1  
--exec pr_rpr_printVoucher '3','101','mar 22 2010', 'mar 22 2010','', '', '', ''   
--exec pr_rpr_printVoucher '4',3,'may 31 2008' ,'may 31 2008','','','',''  
CREATE procedure [citrus_usr].[pr_rpr_printVoucher_Bak_05092019]    
 (@pa_id numeric    
, @pa_voucher_type numeric    
, @pa_voucher_dt_fr datetime    
, @pa_voucher_dt_to datetime    
, @pa_voucher_no_fr varchar(50)    
, @pa_voucher_no_to varchar(50)    
, @pa_ref_no_fr varchar(50)    
--, @pa_ref_no_to varchar(50)    
--, @pa_account_no_fr varchar(50)    
--, @pa_account_no_to varchar(50)    
, @pa_out varchar(8000) out)    
as    
begin    
declare @l_fin_id numeric    
, @l_dpm_id numeric    
, @l_ledgertbl varchar(25)    
, @l_sql varchar(8000)    
, @l_sql2 varchar(8000)    
, @l_sql3 varchar(8000)    
    
if @pa_voucher_no_fr = ''    
begin    
set @pa_voucher_no_fr  = '0'    
set @pa_voucher_no_to  = '999999999999999999999'    
end     
    
--if @pa_ref_no_fr = ''    
--begin     
--set @pa_ref_no_fr  = '0'    
--set @pa_ref_no_to  = '999999999999999999999'    
--end     
    
select @l_dpm_id  = dpm_id from dp_mstr where dpm_excsm_id = default_dp and dpm_excsm_id = @pa_id and dpm_deleted_ind = 1     
select @l_fin_id = fin_id from financial_yr_mstr where  @pa_voucher_dt_fr between fin_start_dt and fin_end_dt     
and @pa_voucher_dt_to between fin_start_dt and fin_end_dt     
and fin_dpm_id = @l_dpm_id and fin_deleted_ind = 1     
  
if @l_fin_id = 0      
set @pa_out = 'No data Found'    
    
set @l_ledgertbl = 'ledger'+convert(varchar,@l_fin_id )    
    PRINT @l_ledgertbl
  
if left(@pa_voucher_type,2) <> '10'  
begin  
    
set @l_sql = 'select ldg_voucher_no [Voucher No], convert(varchar(11),ldg_voucher_dt,103) [Voucher Date],case when ldg_account_type = ''G'' then (select fina_acc_code from fin_account_mstr where FINA_ACC_ID = ldg_account_id and FINA_ACC_TYPE =''G'' and fina_deleted_ind = 1)     
                          when ldg_account_type = ''B'' then (select fina_acc_code from fin_account_mstr where FINA_ACC_ID = ldg_account_id and FINA_ACC_TYPE =''B'' and fina_deleted_ind = 1)     
                          when ldg_account_type = ''C'' then (select fina_acc_code from fin_account_mstr where FINA_ACC_ID = ldg_account_id and FINA_ACC_TYPE =''C'' and fina_deleted_ind = 1)     
                          when ldg_account_type = ''P'' then (select dpam_sba_no from dp_acct_mstr where dpam_id = ldg_account_id and dpam_deleted_ind = 1) else '''' end [A/c Code]'     
set @l_sql = @l_sql + ' , LDG_NARRATION Description , LDG_REF_NO [Ref No], case when ldg_amount < 0 then abs(ldg_amount) else 0.00 end [Credit Amt] , case when ldg_amount > 0 then abs(ldg_amount) else 0.00 end [Debit Amt] '    
  
set @l_sql = @l_sql + ' from ' + @l_ledgertbl    
set @l_sql = @l_sql + ' where ldg_voucher_type  = ' +  convert(varchar,@pa_voucher_type)    
set @l_sql = @l_sql + ' and ldg_voucher_dt  between ''' +  convert(varchar(11),@pa_voucher_dt_fr,109) + ''' and ''' + convert(varchar(11),@pa_voucher_dt_to,109) + ''''    
  
if @pa_voucher_no_fr <> '' and @pa_voucher_no_to = ''    
begin    
set @pa_voucher_no_to  = @pa_voucher_no_fr     
set @l_sql = @l_sql + ' and ldg_voucher_no  between ' +  @pa_voucher_no_fr + ' and ' + @pa_voucher_no_to    
end     
if @pa_ref_no_fr <> ''     
begin     
--set @pa_ref_no_to = @pa_ref_no_fr     
set @l_sql = @l_sql + ' and ldg_ref_no      = ''' +  @pa_ref_no_fr   +''''  
end     
set @l_sql = @l_sql + ' and ldg_deleted_ind=1 and ldg_voucher_no<>0 '    
  print @l_sql  
  
end   
else   
begin   
  
set @l_sql = 'select ldg_voucher_no [Voucher No], convert(varchar(11),ldg_voucher_dt,103) [Voucher Date],case when ldg_account_type = ''G'' then (select fina_acc_code from fin_account_mstr where FINA_ACC_ID = ldg_account_id and FINA_ACC_TYPE =''G'' and fina_deleted_ind = 1)     
                          when ldg_account_type = ''B'' then (select fina_acc_code from fin_account_mstr where FINA_ACC_ID = ldg_account_id and FINA_ACC_TYPE =''B'' and fina_deleted_ind = 1)     
                          when ldg_account_type = ''C'' then (select fina_acc_code from fin_account_mstr where FINA_ACC_ID = ldg_account_id and FINA_ACC_TYPE =''C'' and fina_deleted_ind = 1)     
                          when ldg_account_type = ''P'' then (select dpam_sba_no from dp_acct_mstr where dpam_id = ldg_account_id and dpam_deleted_ind = 1) else '''' end [A/c Code] '     
set @l_sql = @l_sql + ' ,dpam_id ,dpam_sba_no ,dpam_sba_name,ldg_instrument_no , isnull(banm_name,'''') banm_name, LDG_NARRATION Description , LDG_REF_NO [Ref No], case when ldg_amount < 0 then abs(ldg_amount) else 0.00 end [Credit Amt] , case when ldg_amount > 0 then abs(ldg_amount) else 0.00 end [Debit Amt] '    
  
set @l_sql = @l_sql + ' from ' + @l_ledgertbl + ' ,dp_Acct_mstr left outer join client_bank_accts  on cliba_clisba_id = convert(varchar,dpam_id) left outer join bank_mstr  on cliba_banm_id = convert(varchar,banm_id) '   
set @l_sql = @l_sql + ' where ldg_voucher_type  = ' +  convert(varchar,right(@pa_voucher_type,1))  
  
set @l_sql = @l_sql + ' and ldg_account_id = dpam_id '  
set @l_sql = @l_sql + ' and ldg_voucher_dt  between ''' +  convert(varchar(11),@pa_voucher_dt_fr,109) + ''' and ''' + convert(varchar(11),@pa_voucher_dt_to,109) + ''''    
set @l_sql = @l_sql + ' and LDG_ACCOUNT_TYPE= ''P'' '  
if @pa_voucher_no_fr <> '' and @pa_voucher_no_to = ''    
begin    
set @pa_voucher_no_to  = @pa_voucher_no_fr     
set @l_sql = @l_sql + ' and ldg_voucher_no  between ' +  @pa_voucher_no_fr + ' and ' + @pa_voucher_no_to    
end     
if @pa_ref_no_fr <> ''     
begin     
--set @pa_ref_no_to = @pa_ref_no_fr     
set @l_sql = @l_sql + ' and ldg_ref_no      = ''' +  @pa_ref_no_fr   +''''  
end     
set @l_sql = @l_sql + ' and ldg_deleted_ind=1 and ldg_voucher_no<>0 '    
  print @l_sql  
  
  
end  
PRINT  @l_sql
exec(@l_sql)     
    
    
end

GO
