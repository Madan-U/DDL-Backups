-- Object: PROCEDURE citrus_usr.ImportJVVouchers_bak_13032015
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--[ImportJVVouchers] 557,	4,	1,	'may 31 2008',	'may 31 2008',	'VISHAL'
create Proc [citrus_usr].[ImportJVVouchers_bak_13032015]
@pa_task_id bigint,
@pa_dpmid int,
@pa_finid int,
@pa_billing_from_dt datetime,
@pa_billing_to_dt datetime,
@pa_loginname varchar(100)
as
begin

declare @@Vno bigint,
@@ref_no varchar(20),
@@ssql varchar(8000),
@@glaccountid bigint,
@@voucher_dt varchar(11),
@@total_rec_cnt bigint,
@@lst_curr_id bigint




select top 1 @@voucher_dt = convert(varchar(11),TMPBILL_TODATE,109) from tmp_billimp_mstr 

IF @@voucher_dt <> convert(varchar(11),@pa_billing_from_dt,109)
BEGIN
--
	UPDATE filetask
	SET    Status = 'FAILED',usermsg = 'ERROR : User Selected Voucher date and the same available in File does not match, please verify & reimport'
	WHERE  task_id = @pa_task_id
	RETURN
--
END


select @@total_rec_cnt = isnull(count(TMPBILL_SR_NO),0) from tmp_billimp_mstr where (TMPBILL_CREDIT <> 0 or TMPBILL_DEBIT <> 0)
if isnull(@@total_rec_cnt,0) = 0
begin
	UPDATE filetask
	SET    Status = 'FAILED',usermsg = 'ERROR : No Entries found'
	WHERE  task_id = @pa_task_id
	RETURN
end 

SELECT @@ref_no       = 'AC-' +  replace(convert(varchar(11),@pa_billing_to_dt,103),'/','')     
print @pa_dpmid

--set @@glaccountid = 1
SELECT @@glaccountid = ISNULL(BITRM_VALUES,0) FROM BITMAP_REF_MSTR WHERE BITRM_PARENT_CD='DP_GL_ACCNO'  AND BITRM_CHILD_CD = @pa_dpmid 


if isnull(@@glaccountid,0) = 0
begin

	UPDATE filetask
	SET    Status = 'FAILED',usermsg = 'ERROR : Please contact your vendor for configuring GL Account for JV enties'
	WHERE  task_id = @pa_task_id
	RETURN
end



update tmp_billimp_mstr 
set    tmpbill_dpam_id = dpam_id 
from   dp_acct_mstr 
where  tmpbill_acct_no = dpam_sba_no 
--and    tmpbill_dpm_id = dpam_dpm_id 
and    dpam_dpm_id = case when @pa_dpmid='3' then dpam_dpm_id else @pa_dpmid end
and	   dpam_deleted_ind = 1


--IF EXISTS(SELECT * FROM tmp_billimp_mstr WHERE isnull(tmpbill_dpm_id,0) <> @pa_dpmid) 																					
--	BEGIN
--	--
--		UPDATE filetask
--		SET    Status = 'FAILED',usermsg = 'ERROR : File Dpid Not Mached with selected Dpid ' 
--		WHERE  task_id = @pa_task_id
--
--		RETURN
--	--
--	END


	IF EXISTS(SELECT * FROM tmp_billimp_mstr WHERE isnull(tmpbill_dpam_id,0) = 0) 																					
	BEGIN
	--
		UPDATE filetask
		SET    Status = 'FAILED',usermsg = 'ERROR : Following Client Not Mapped, Please map & reimport ' + CHAR(13) + citrus_usr.fn_merge_str('JV_ACPARTY_VOCUCHERS',0,'')  
		WHERE  task_id = @pa_task_id

		RETURN
	--
	END


begin tran

--Create table #tmpVoucher(Vno bigint)
--set @@ssql = 'insert into #tmpVoucher(Vno) select top 1 isnull(LDG_VOUCHER_NO,0) from ledger'+ convert(varchar,@pa_finid) + ' where ldg_dpm_id = ' + convert(varchar,@pa_dpmid) + ' and LDG_VOUCHER_TYPE =''3'' and ldg_ref_no = ''' + convert(varchar,@@ref_no) +''' and ldg_deleted_ind = 1'
--exec(@@ssql)

--select top 1 @@Vno=isnull(Vno,0) from #tmpVoucher

--if (isnull(@@Vno,0) <> 0)
--begin
--	set @@ssql          = 'UPDATE accountbal' + convert(varchar,@pa_finid)    
--	set @@ssql          = @@ssql         + ' SET    accbal_amount    =  accbal_amount - ldg_amount'     
--	set @@ssql          = @@ssql         + ' from   ledger' + convert(varchar,@pa_finid)  
--	set @@ssql          = @@ssql         + ' WHERE  accbal_dpm_id    = '+convert(varchar,@pa_dpmid)
--	set @@ssql          = @@ssql         + ' and    accbal_acct_id   = ldg_account_id'    
--	set @@ssql          = @@ssql         + ' and    accbal_acct_TYPE = ldg_account_type'    
--	set @@ssql          = @@ssql         + ' and    accbal_dpm_id    = ldg_dpm_id      '       
--	set @@ssql          = @@ssql         + ' and    ldg_ref_no       = '''+ convert(varchar,@@ref_no)  +''''    
--	set @@ssql          = @@ssql         + ' and    LDG_VOUCHER_TYPE = ''3'''       
--	set @@ssql          = @@ssql         + ' and    LDG_VOUCHER_NO   = ' + convert(varchar,@@Vno)      
--	exec(@@ssql)
	    

--	set @@ssql = 'delete from ledger'+convert(varchar,@pa_finid) +' where  LDG_VOUCHER_TYPE = ''3'' and LDG_VOUCHER_NO   = ' + convert(varchar,@@Vno) + ' and ldg_ref_no = ''' + convert(varchar,@@ref_no) + ''' and ldg_dpm_id = ' + convert(varchar,@pa_dpmid)   
--	exec(@@ssql)

--	select  @@lst_curr_id = isnull(ledger_currid,0) from financial_yr_mstr where fin_id = @pa_finid and fin_dpm_id = @pa_dpmid and fin_deleted_ind = 1
--end
--else
--begin
	
--	update financial_yr_mstr set VchNo_jv = isnull(VchNo_jv,0) + 1 where fin_id = @pa_finid and fin_dpm_id = @pa_dpmid and fin_deleted_ind = 1

--	select  @@Vno=isnull(VchNo_jv,0),@@lst_curr_id = isnull(ledger_currid,0) from financial_yr_mstr where fin_id = @pa_finid and fin_dpm_id = @pa_dpmid and fin_deleted_ind = 1
--end

    

--	update financial_yr_mstr set ledger_currid = isnull(ledger_currid,0) + isnull(@@total_rec_cnt,0) + 1 where fin_id = @pa_finid and fin_dpm_id = @pa_dpmid and fin_deleted_ind = 1


--Set @@ssql = 'insert into ledger' + convert(varchar,@pa_finid) + ' (LDG_ID,LDG_DPM_ID,LDG_VOUCHER_TYPE,LDG_BOOK_TYPE_CD,LDG_VOUCHER_NO,LDG_SR_NO,LDG_REF_NO,LDG_VOUCHER_DT,LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,LDG_AMOUNT,LDG_NARRATION,LDG_BANK_ID,LDG_ACCOUNT_NO,LDG_INSTRUMENT_NO,LDG_BANK_CL_DATE,LDG_COST_CD_ID,LDG_BILL_BRKUP_ID,LDG_TRANS_TYPE,LDG_STATUS,LDG_CREATED_BY,LDG_CREATED_DT,LDG_LST_UPD_BY,LDG_LST_UPD_DT,LDG_DELETED_IND,LDG_BRANCH_ID)
--select LDG_ID=' + convert(varchar,isnull(@@lst_curr_id,0)) + ' + 1 ,LDG_DPM_ID=' + convert(varchar,@pa_dpmid) + ',LDG_VOUCHER_TYPE=''3'',LDG_BOOK_TYPE_CD=''01'',LDG_VOUCHER_NO=' + convert(varchar,@@Vno) + ',1,LDG_REF_NO=''' + @@ref_no + ''',''' + @@voucher_dt + ''',' + convert(varchar,@@glaccountid) + ',LDG_ACCOUNT_TYPE=''G'',sum(TMPBILL_CREDIT-TMPBILL_DEBIT)*-1,LDG_NARRATION= ''Recovered from trading A/C towards Curr O/S on ' + @@voucher_dt + ''' ,LDG_BANK_ID='''',LDG_ACCOUNT_NO='''',LDG_INSTRUMENT_NO='''',LDG_BANK_CL_DATE='''',LDG_COST_CD_ID=0,LDG_BILL_BRKUP_ID=0,LDG_TRANS_TYPE=''AC'',LDG_STATUS=''P'',''' + @pa_loginname + ''',getdate(),''' + @pa_loginname + ''',getdate(),1,0 
--from tmp_billimp_mstr 
--WHERE (TMPBILL_CREDIT <> 0 OR TMPBILL_DEBIT <> 0) '
--print @@ssql
--exec(@@ssql)

--Set @@ssql = 'insert into ledger' + convert(varchar,@pa_finid) + ' (LDG_ID,LDG_DPM_ID,LDG_VOUCHER_TYPE,LDG_BOOK_TYPE_CD,LDG_VOUCHER_NO,LDG_SR_NO,LDG_REF_NO,LDG_VOUCHER_DT,LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,LDG_AMOUNT,LDG_NARRATION,LDG_BANK_ID,LDG_ACCOUNT_NO,LDG_INSTRUMENT_NO,LDG_BANK_CL_DATE,LDG_COST_CD_ID,LDG_BILL_BRKUP_ID,LDG_TRANS_TYPE,LDG_STATUS,LDG_CREATED_BY,LDG_CREATED_DT,LDG_LST_UPD_BY,LDG_LST_UPD_DT,LDG_DELETED_IND,LDG_BRANCH_ID)
--select LDG_ID=' + convert(varchar,isnull(@@lst_curr_id,0)) + ' + TMPBILL_SR_NO,LDG_DPM_ID=' + convert(varchar,@pa_dpmid) + ',LDG_VOUCHER_TYPE=''3'',LDG_BOOK_TYPE_CD=''01'',LDG_VOUCHER_NO=' + convert(varchar,@@Vno) + ',TMPBILL_SR_NO,LDG_REF_NO=''' + @@ref_no + ''',''' + @@voucher_dt + ''',TMPBILL_DPAM_ID,LDG_ACCOUNT_TYPE=''P'',CASE WHEN TMPBILL_CREDIT <> 0 THEN TMPBILL_CREDIT ELSE TMPBILL_DEBIT * -1 END  ,LDG_NARRATION=''Recovered from trading A/C towards Curr O/S on ' + @@voucher_dt + ''' ,LDG_BANK_ID='''',LDG_ACCOUNT_NO='''',LDG_INSTRUMENT_NO='''',LDG_BANK_CL_DATE='''',LDG_COST_CD_ID=0,LDG_BILL_BRKUP_ID=0,LDG_TRANS_TYPE=''AC'',LDG_STATUS=''P'',''' + @pa_loginname + ''',getdate(),''' + @pa_loginname + ''',getdate(),1,0 
--from tmp_billimp_mstr WHERE (TMPBILL_CREDIT <> 0 OR TMPBILL_DEBIT <> 0)'

print convert(varchar(11),@pa_billing_to_dt,109)
set @@ssql = 'delete from client_charges_cdsl where  CLIC_FLG = ''B'' and CLIC_TRANS_DT   = ''' + convert(varchar(11),@pa_billing_to_dt,109) + ''''
print @@ssql
exec(@@ssql)

Set @@ssql = 'insert into client_charges_cdsl (CLIC_ID,
CLIC_TRANS_DT,
CLIC_DPM_ID,
CLIC_DPAM_ID,
CLIC_CHARGE_NAME,
CLIC_CHARGE_AMT,
CLIC_FLG,
CLIC_CREATED_BY,
CLIC_CREATED_DT,
CLIC_LST_UPD_BY,
CLIC_LST_UPD_DT,
CLIC_DELETED_IND,
CLIC_POST_TOACCT)
select null ,TMPBILL_TODATE,LDG_DPM_ID=dpam_dpm_id,TMPBILL_DPAM_ID,''Recovered from trading A/C towards Curr O/S on ' + @@voucher_dt + '''

,CASE WHEN TMPBILL_CREDIT <> 0 THEN TMPBILL_CREDIT ELSE TMPBILL_DEBIT * -1 END  ,
''B'',
''' + @pa_loginname + ''',getdate(),''' + @pa_loginname + ''',getdate(),1,' + convert(varchar,@@glaccountid) + ' 
from tmp_billimp_mstr,dp_acct_mstr WHERE dpam_id = TMPBILL_DPAM_ID and (TMPBILL_CREDIT <> 0 OR TMPBILL_DEBIT <> 0)'

print @@ssql
exec(@@ssql)


set @@ssql          = 'UPDATE accountbal' + convert(varchar,@pa_finid)    
set @@ssql          = @@ssql         + ' SET    accbal_amount    =  accbal_amount + ldg_amount'     
set @@ssql          = @@ssql         + ' from   ledger' + convert(varchar,@pa_finid)  
set @@ssql          = @@ssql         + ' WHERE  accbal_dpm_id    = '+convert(varchar,@pa_dpmid)
set @@ssql          = @@ssql         + ' and    accbal_acct_id   = ldg_account_id'    
set @@ssql          = @@ssql         + ' and    accbal_acct_TYPE = ldg_account_type'    
set @@ssql          = @@ssql         + ' and    accbal_dpm_id    = ldg_dpm_id      '       
set @@ssql          = @@ssql         + ' and    ldg_ref_no       = '''+ convert(varchar,@@ref_no)  +''''    
set @@ssql          = @@ssql         + ' and    LDG_VOUCHER_TYPE = ''3'''       
set @@ssql          = @@ssql         + ' and    LDG_VOUCHER_NO   = ' + convert(varchar,@@Vno)    
set @@ssql          = @@ssql         + ' and    LDG_DELETED_IND =1 '
set @@ssql          = @@ssql         + ' and    ACCBAL_DELETED_IND =1 '
exec (@@ssql)
    
set @@ssql          = 'insert into accountbal' + convert(varchar,@pa_finid)    
set @@ssql          = @@ssql + ' select ' + convert(varchar,@pa_dpmid) + ',TMPBILL_DPAM_ID,''P'',CASE WHEN TMPBILL_CREDIT <> 0 THEN TMPBILL_CREDIT ELSE TMPBILL_DEBIT END,''' + @pa_loginname + ''',getdate(),''' + @pa_loginname + ''',getdate(),1'
set @@ssql          = @@ssql + ' from tmp_billimp_mstr '
set @@ssql          = @@ssql + ' where (TMPBILL_CREDIT <> 0 OR TMPBILL_DEBIT <> 0)  and not exists(select ACCBAL_ACCT_ID from accountbal' + convert(varchar,@pa_finid)  + ' where ACCBAL_ACCT_ID = tmpbill_dpam_id and ACCBAL_DELETED_IND = 1)'  
exec (@@ssql)

set @@ssql          = 'if not exists(select ACCBAL_ACCT_ID from accountbal' + convert(varchar,@pa_finid) + ' where ACCBAL_ACCT_ID = ' +  convert(varchar,@@glaccountid) + ' and ACCBAL_DELETED_IND = 1)'
set @@ssql          = @@ssql + ' begin'
set @@ssql          = @@ssql + ' insert into accountbal' + convert(varchar,@pa_finid)    
set @@ssql          = @@ssql + ' select ' + convert(varchar,@pa_dpmid) + ',' + convert(varchar,@@glaccountid) + ',''G'',sum(isnull(TMPBILL_CREDIT,0) - isnull(TMPBILL_DEBIT,0))*-1,''' + @pa_loginname + ''',getdate(),''' + @pa_loginname + ''',getdate(),1'
set @@ssql          = @@ssql + ' from tmp_billimp_mstr '
set @@ssql          = @@ssql + ' where (TMPBILL_CREDIT <> 0 OR TMPBILL_DEBIT <> 0) and isnull(TMPBILL_DPAM_ID,0) <> 0'  
set @@ssql          = @@ssql + ' end'
exec (@@ssql)


commit tran

end

GO
