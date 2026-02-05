-- Object: PROCEDURE citrus_usr.ImportJVVouchers_SPML
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--select * from financial_yr_mstr
--BEGIN TRAN
--ImportJVVouchers_SPML 1257,2,4,'aug  9 2010','aug  9 2010',	'VISHAL'
--SELECT ldg_instrument_no,* FROM LEDGER3 ORDER BY 2 DESC
--SELECT COUNT(*) FROM LEDGER4 -- SELECT 7882-8079
--ROLLBACK
CREATE Proc [citrus_usr].[ImportJVVouchers_SPML]
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
@@glaccountid varchar(100),
@@voucher_dt varchar(11),
@@total_rec_cnt bigint,
@@lst_curr_id bigint,
@@filler varchar(50),
@@refadd varchar(50)

select top 1 @@voucher_dt = convert(varchar(11),TMPJV_TODATE,109) from tmp_jv_mstr 

IF UPPER(@@voucher_dt) <> UPPER(convert(varchar(11),@pa_billing_from_dt,109))
BEGIN
--

	UPDATE filetask
	SET    Status = 'FAILED',usermsg = 'ERROR : User Selected Voucher date and the same available in File does not match, please verify & reimport'
	WHERE  task_id = @pa_task_id
	RETURN
--
END


select @@total_rec_cnt = isnull(count(TMPJV_SR_NO),0) from tmp_jv_mstr where (TMPJV_CREDIT <> 0 or TMPJV_DEBIT <> 0)
select top 1 @@refadd =  isnull(TMPJV_filler1,'') from tmp_jv_mstr
if isnull(@@total_rec_cnt,0) = 0
begin

	UPDATE filetask
	SET    Status = 'FAILED',usermsg = 'ERROR : No Entries found'
	WHERE  task_id = @pa_task_id
	RETURN
end 

SELECT @@ref_no       = 'AC-' +  replace(convert(varchar(11),@pa_billing_to_dt,103),'/','') + @@refadd    

--set @@glaccountid = 1
SELECT @@glaccountid = ISNULL(BITRM_VALUES,0) FROM BITMAP_REF_MSTR WHERE BITRM_PARENT_CD='DP_GL_ACCNO'  AND BITRM_CHILD_CD = @pa_dpmid 


if isnull(@@glaccountid,'0') = '0'
begin

	UPDATE filetask
	SET    Status = 'FAILED',usermsg = 'ERROR : Please contact your vendor for configuring GL Account for JV enties'
	WHERE  task_id = @pa_task_id
	RETURN
end




update tmp_jv_mstr 
set    TMPJV_dpam_id = dpam_id 
from   dp_acct_mstr 
where  TMPJV_acct_no = dpam_sba_no 
and    TMPJV_dpm_id = dpam_dpm_id 
and    dpam_dpm_id = @pa_dpmid
and	   dpam_deleted_ind = 1

SELECT TMPJV_dpam_id FROM tmp_jv_mstr WHERE isnull(TMPJV_dpam_id,0) = 0

	IF EXISTS(SELECT TMPJV_dpam_id FROM tmp_jv_mstr WHERE isnull(TMPJV_dpam_id,0) = 0) 																					
	BEGIN
	--
		UPDATE filetask
		SET    Status = 'FAILED',usermsg = 'ERROR : Following Client Not Mapped, Please map & reimport ' + CHAR(13) + citrus_usr.fn_merge_str('JV_ACPARTY_VOCUCHERS',0,'')  
		WHERE  task_id = @pa_task_id
		RETURN
	--
	END


begin tran

Create table #tmpVoucher(Vno bigint)
set @@ssql = 'insert into #tmpVoucher(Vno) select top 1 isnull(LDG_VOUCHER_NO,0) from ledger'+ convert(varchar,@pa_finid) + ' where ldg_dpm_id = ' + convert(varchar,@pa_dpmid) + ' and LDG_VOUCHER_TYPE =''3'' and ldg_ref_no = ''' + convert(varchar,@@ref_no) +''' and ldg_deleted_ind = 1'

exec(@@ssql)

Create table #tmpfiller(filler varchar(50))
set @@ssql = 'insert into #tmpfiller(filler) select top 1 isnull(TMPJV_FILLER1,'''') from TMP_JV_MSTR'


exec(@@ssql)

select top 1 @@Vno=isnull(Vno,0) from #tmpVoucher

select top 1 @@filler=isnull(ltrim(rtrim(filler)),'') from #tmpfiller


if (isnull(@@Vno,0) <> 0)
begin
	set @@ssql          = 'UPDATE accountbal' + convert(varchar,@pa_finid)    
	set @@ssql          = @@ssql         + ' SET    accbal_amount    =  accbal_amount - ldg_amount'     
	set @@ssql          = @@ssql         + ' from   ledger' + convert(varchar,@pa_finid)  
	set @@ssql          = @@ssql         + ' WHERE  accbal_dpm_id    = '+convert(varchar,@pa_dpmid)
	set @@ssql          = @@ssql         + ' and    accbal_acct_id   = ldg_account_id'    
	set @@ssql          = @@ssql         + ' and    accbal_acct_TYPE = ldg_account_type'    
	set @@ssql          = @@ssql         + ' and    accbal_dpm_id    = ldg_dpm_id      '       
	set @@ssql          = @@ssql         + ' and    ldg_ref_no       = '''+ convert(varchar,@@ref_no)  +''''    
	set @@ssql          = @@ssql         + ' and    LDG_VOUCHER_TYPE = ''3'''       
	set @@ssql          = @@ssql         + ' and    LDG_VOUCHER_NO   = ' + convert(varchar,@@Vno)   
    set @@ssql          = @@ssql         + ' and    LDG_INSTRUMENT_NO   = ''' + convert(varchar,@@filler) + ''''   
	exec(@@ssql)
	    

	set @@ssql = 'delete from ledger'+convert(varchar,@pa_finid) +' where  LDG_VOUCHER_TYPE = ''3'' and LDG_VOUCHER_NO   = ' + convert(varchar,@@Vno) + ' and ldg_ref_no = ''' + convert(varchar,@@ref_no) + ''' and ldg_instrument_no = ''' + @@filler + ''' and ldg_dpm_id = ' + convert(varchar,@pa_dpmid)   
    
	exec(@@ssql)

	select  @@lst_curr_id = isnull(ledger_currid,0) from financial_yr_mstr where fin_id = @pa_finid and fin_dpm_id = @pa_dpmid and fin_deleted_ind = 1
end
else
begin

	select isnull(VchNo_jv,0) + 1 from financial_yr_mstr where fin_id = @pa_finid and fin_dpm_id = @pa_dpmid and fin_deleted_ind = 1
	update financial_yr_mstr set VchNo_jv = isnull(VchNo_jv,0) + 1 where fin_id = @pa_finid and fin_dpm_id = @pa_dpmid and fin_deleted_ind = 1
    

	select  @@Vno=isnull(VchNo_jv,0),@@lst_curr_id = isnull(ledger_currid,0) from financial_yr_mstr where fin_id = @pa_finid and fin_dpm_id = @pa_dpmid and fin_deleted_ind = 1
end

    
    print @@total_rec_cnt 
    --select isnull(ledger_currid,0) + isnull(@@total_rec_cnt,0) + 1 from financial_yr_mstr where fin_id = @pa_finid and fin_dpm_id = @pa_dpmid and fin_deleted_ind = 1
	update financial_yr_mstr set ledger_currid = isnull(ledger_currid,0) + isnull(@@total_rec_cnt,0) + 1 where fin_id = @pa_finid and fin_dpm_id = @pa_dpmid and fin_deleted_ind = 1



Set @@ssql = 'insert into ledger' + convert(varchar,@pa_finid) + ' (LDG_ID,LDG_DPM_ID,LDG_VOUCHER_TYPE,LDG_BOOK_TYPE_CD,LDG_VOUCHER_NO,LDG_SR_NO,LDG_REF_NO,LDG_VOUCHER_DT,LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,LDG_AMOUNT,LDG_NARRATION,LDG_BANK_ID,LDG_ACCOUNT_NO,LDG_INSTRUMENT_NO,LDG_BANK_CL_DATE,LDG_COST_CD_ID,LDG_BILL_BRKUP_ID,LDG_TRANS_TYPE,LDG_STATUS,LDG_CREATED_BY,LDG_CREATED_DT,LDG_LST_UPD_BY,LDG_LST_UPD_DT,LDG_DELETED_IND,LDG_BRANCH_ID)'

set @@ssql = @@ssql + ' select LDG_ID=' + convert(varchar,isnull(@@lst_curr_id,0)) + ' + 1 ,LDG_DPM_ID=' + convert(varchar,@pa_dpmid) + ',LDG_VOUCHER_TYPE=''3'',LDG_BOOK_TYPE_CD=''01'',LDG_VOUCHER_NO=' + convert(varchar,@@Vno) + ',1,LDG_REF_NO=''' + @@ref_no + ''',''' + @@voucher_dt + ''',' + convert(varchar,@@glaccountid) + ',LDG_ACCOUNT_TYPE=''G'',sum(TMPJV_CREDIT-TMPJV_DEBIT)*-1,LDG_NARRATION= case when LEFT(TMPJV_FILLER1,3)=''AMC'' then ''BEING AMT DEBITED TOWARDS AMC CHARGES'' when LEFT(TMPJV_FILLER1,3)=''OTH'' then ''BEING AMT DEBITED TOWARDS TRANSACTION CHARGES'' else ''BEING AMT DEBITED TOWARDS POA CHARGES'' end ,LDG_BANK_ID='''',LDG_ACCOUNT_NO='''',LDG_INSTRUMENT_NO=TMPJV_FILLER1,LDG_BANK_CL_DATE='''',LDG_COST_CD_ID=0,LDG_BILL_BRKUP_ID=0,LDG_TRANS_TYPE=''AC'',LDG_STATUS=''P'',''' + @pa_loginname + ''',getdate(),''' + @pa_loginname + ''',getdate(),1,0 from tmp_jv_mstr' 

set @@ssql = @@ssql + ' WHERE (TMPJV_CREDIT <> 0 OR TMPJV_DEBIT <> 0) GROUP BY TMPJV_FILLER1 '

print (@@ssql)
exec(@@ssql)


Set @@ssql = 'insert into ledger' + convert(varchar,@pa_finid) + ' (LDG_ID,LDG_DPM_ID,LDG_VOUCHER_TYPE,LDG_BOOK_TYPE_CD,LDG_VOUCHER_NO,LDG_SR_NO,LDG_REF_NO,LDG_VOUCHER_DT,LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,LDG_AMOUNT,LDG_NARRATION,LDG_BANK_ID,LDG_ACCOUNT_NO,LDG_INSTRUMENT_NO,LDG_BANK_CL_DATE,LDG_COST_CD_ID,LDG_BILL_BRKUP_ID,LDG_TRANS_TYPE,LDG_STATUS,LDG_CREATED_BY,LDG_CREATED_DT,LDG_LST_UPD_BY,LDG_LST_UPD_DT,LDG_DELETED_IND,LDG_BRANCH_ID)
select LDG_ID=' + convert(varchar,isnull(@@lst_curr_id,0)) + ' + TMPJV_SR_NO,LDG_DPM_ID=' + convert(varchar,@pa_dpmid) + ',LDG_VOUCHER_TYPE=''3'',LDG_BOOK_TYPE_CD=''01'',LDG_VOUCHER_NO=' + convert(varchar,@@Vno) + ',TMPJV_SR_NO,LDG_REF_NO=''' + @@ref_no + ''',''' + @@voucher_dt + ''',TMPJV_DPAM_ID,LDG_ACCOUNT_TYPE=''P'',CASE WHEN TMPJV_CREDIT <> 0 THEN TMPJV_CREDIT ELSE TMPJV_DEBIT * -1 END  ,LDG_NARRATION=TMPJV_NARRATION,LDG_BANK_ID='''',LDG_ACCOUNT_NO='''',LDG_INSTRUMENT_NO=TMPJV_FILLER1,LDG_BANK_CL_DATE='''',LDG_COST_CD_ID=0,LDG_BILL_BRKUP_ID=0,LDG_TRANS_TYPE=''AC'',LDG_STATUS=''P'',''' + @pa_loginname + ''',getdate(),''' + @pa_loginname + ''',getdate(),1,0 
from tmp_jv_mstr WHERE (TMPJV_CREDIT <> 0 OR TMPJV_DEBIT <> 0)'


exec(@@ssql)

print @@ssql
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
set @@ssql          = @@ssql         + ' and    LDG_INSTRUMENT_NO   = ''' + convert(varchar,@@filler)  + ''''  
set @@ssql          = @@ssql         + ' and    LDG_DELETED_IND =1 '
set @@ssql          = @@ssql         + ' and    ACCBAL_DELETED_IND =1 '
exec (@@ssql)
  
set @@ssql          = 'insert into accountbal' + convert(varchar,@pa_finid)    
set @@ssql          = @@ssql + ' select ' + convert(varchar,@pa_dpmid) + ',TMPJV_DPAM_ID,''P'',CASE WHEN TMPJV_CREDIT <> 0 THEN TMPJV_CREDIT ELSE TMPJV_DEBIT END,''' + @pa_loginname + ''',getdate(),''' + @pa_loginname + ''',getdate(),1'
set @@ssql          = @@ssql + ' from tmp_jv_mstr '
set @@ssql          = @@ssql + ' where (TMPJV_CREDIT <> 0 OR TMPJV_DEBIT <> 0)  and not exists(select ACCBAL_ACCT_ID from accountbal' + convert(varchar,@pa_finid)  + ' where ACCBAL_ACCT_ID = TMPJV_dpam_id and ACCBAL_DELETED_IND = 1)'  
exec (@@ssql)

set @@ssql          = 'if not exists(select ACCBAL_ACCT_ID from accountbal' + convert(varchar,@pa_finid) + ' where ACCBAL_ACCT_ID = ' +  convert(varchar,@@glaccountid) + ' and ACCBAL_DELETED_IND = 1)'
set @@ssql          = @@ssql + ' begin'
set @@ssql          = @@ssql + ' insert into accountbal' + convert(varchar,@pa_finid)    
set @@ssql          = @@ssql + ' select ' + convert(varchar,@pa_dpmid) + ',' + convert(varchar,@@glaccountid) + ',''G'',sum(isnull(TMPJV_CREDIT,0) - isnull(TMPJV_DEBIT,0))*-1,''' + @pa_loginname + ''',getdate(),''' + @pa_loginname + ''',getdate(),1'
set @@ssql          = @@ssql + ' from tmp_jv_mstr '
set @@ssql          = @@ssql + ' where (TMPJV_CREDIT <> 0 OR TMPJV_DEBIT <> 0) and isnull(TMPJV_DPAM_ID,0) <> 0'  
set @@ssql          = @@ssql + ' end'
exec (@@ssql)


commit tran

end

GO
