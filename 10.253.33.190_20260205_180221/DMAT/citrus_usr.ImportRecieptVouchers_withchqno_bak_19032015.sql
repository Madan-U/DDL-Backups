-- Object: PROCEDURE citrus_usr.ImportRecieptVouchers_withchqno_bak_19032015
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--[ImportRecieptVouchers] 557,	4,	1,	'may 31 2008',	'may 31 2008',	'VISHAL'
create Proc [citrus_usr].[ImportRecieptVouchers_withchqno_bak_19032015]
@pa_task_id bigint,
@pa_dpmid int,
@pa_finid int,
@pa_billing_from_dt datetime,
@pa_billing_to_dt datetime,
@pa_loginname varchar(100)
as
begin

declare @@Vno bigint,
@@ref_no varchar(50),
@@ssql varchar(8000),
@@voucher_dt varchar(11),
@@total_rec_cnt bigint,
@@lst_curr_id bigint,
@@srno bigint



select top 1 @@voucher_dt = convert(varchar(11),TMPREC_TODATE,109) from TMP_RECIEPT_MSTR

print @@voucher_dt 
print @pa_billing_from_dt

IF @@voucher_dt <> convert(varchar(11),@pa_billing_from_dt,109)
BEGIN
--
	UPDATE filetask
	SET    Status = 'FAILED',usermsg = 'ERROR : User Selected Voucher date and the same available in File does not match, please verify & reimport'
	WHERE  task_id = @pa_task_id


	RETURN
--
END




select @@total_rec_cnt = isnull(count(TMPREC_SR_NO),0) from TMP_RECIEPT_MSTR where TMPREC_CREDIT <> 0
if isnull(@@total_rec_cnt,0) = 0
begin
	return
end 


set @@total_rec_cnt = @@total_rec_cnt  

SELECT @@ref_no = 'BR-' + replace(convert(varchar(11),@pa_billing_to_dt,103),'/','')     


delete from TMP_RECIEPT_MSTR where TMPREC_VTYPE <> 'R'


update TMP_RECIEPT_MSTR 
set    TMPREC_DPAM_ID = dpam_id 
from   dp_acct_mstr 
where  TMPREC_ACCT_NO = dpam_sba_no 
and    TMPREC_DPM_ID = dpam_dpm_id 
and    TMPREC_DPM_ID = @pa_dpmid
and	   dpam_deleted_ind = 1

update TMP_RECIEPT_MSTR 
set    TMPREC_BANKGLID = FINA_ACC_ID,
	   TMPREC_BANKGLTYPE = FINA_ACC_TYPE
from   fin_account_mstr 
where  TMPREC_BANKGLCODE = FINA_ACC_CODE 
and    TMPREC_DPM_ID = FINA_DPM_ID 
and    FINA_ACC_TYPE in('B','C')
and    FINA_DPM_ID = @pa_dpmid
and	   FINA_deleted_ind = 1



--	IF EXISTS(SELECT TMPREC_BANKGLID FROM TMP_RECIEPT_MSTR WHERE isnull(TMPREC_BANKGLID,0) = 0 AND  TMPREC_CREDIT <> 0) 																					
--	BEGIN
--	--
--		UPDATE filetask
--		SET    Status = 'FAILED',usermsg = 'ERROR : Following Bank/Cash A/c Not found, Please create & reimport ' + CHAR(13) + citrus_usr.fn_merge_str('REC_ACGLBANK_VOCUCHERS',0,'')  
--		WHERE  task_id = @pa_task_id
--
--		RETURN
--	--
--	END



	IF EXISTS(SELECT TMPREC_DPAM_ID FROM TMP_RECIEPT_MSTR WHERE isnull(TMPREC_DPAM_ID,0) = 0 AND  TMPREC_CREDIT <> 0) 																					
	BEGIN
	--
		UPDATE filetask
		SET    Status = 'FAILED',usermsg = 'ERROR : Following Client Not Mapped, Please map & reimport ' + CHAR(13) + citrus_usr.fn_merge_str('REC_ACPARTY_VOCUCHERS',0,'')  
		WHERE  task_id = @pa_task_id
		RETURN
	--
	END



begin tran


insert into TMP_RECIEPT_MSTR(TMPREC_SR_NO,TMPREC_DPAM_ID,TMPREC_DPM_ID,TMPREC_TODATE,TMPREC_ACCT_NO,TMPREC_CREDIT,TMPREC_BANKGLID,TMPREC_BANKGLTYPE,TMPREC_BANKGLCODE,TMPREC_CHEQUE_NO)
select TMPREC_SR_NO,TMPREC_BANKGLID,TMPREC_DPM_ID,TMPREC_TODATE,TMPREC_BANKGLCODE,TMPREC_CREDIT,0,TMPREC_BANKGLTYPE,TMPREC_ACCT_NO,TMPREC_CHEQUE_NO
from TMP_RECIEPT_MSTR where TMPREC_CREDIT <> 0





Create table #tmpVoucher(Vno bigint)
set @@ssql = 'insert into #tmpVoucher(Vno) select top 1 isnull(LDG_VOUCHER_NO,0) from ledger'+ convert(varchar,@pa_finid) + ' where ldg_dpm_id = ' + convert(varchar,@pa_dpmid) + ' and LDG_VOUCHER_TYPE =''2'' and ldg_ref_no like ''' + convert(varchar,@@ref_no) +'%'' and ldg_deleted_ind = 1'
exec(@@ssql)

select top 1 @@Vno=isnull(Vno,0) from #tmpVoucher

if (isnull(@@Vno,0) <> 0)
begin
   


set @@ssql          = 'update accountbal' + convert(varchar,@pa_finid) + ' set accbal_amount =  isnull((select sum(ldg_amount) from ledger' + convert(varchar,@pa_finid) 
set @@ssql          = @@ssql         + ' where accbal_dpm_id    = '+convert(varchar,@pa_dpmid)
set @@ssql          = @@ssql         + ' and    accbal_acct_id   = ldg_account_id'    
set @@ssql          = @@ssql         + ' and    accbal_acct_TYPE = ldg_account_type'    
set @@ssql          = @@ssql         + ' and    accbal_dpm_id    = ldg_dpm_id      '    
set @@ssql          = @@ssql         + ' and    (LDG_VOUCHER_TYPE <> ''2'' or ldg_ref_no not like '''+ convert(varchar,@@ref_no)  +'%'')'      
set @@ssql          = @@ssql         + ' and    LDG_DELETED_IND =1 '
set @@ssql          = @@ssql         + ' and    ACCBAL_DELETED_IND =1),0) '
set @@ssql          = @@ssql         + ' where exists(select ldg_account_id from ledger' + convert(varchar,@pa_finid) + ' where ldg_account_id = ACCBAL_ACCT_ID and ldg_account_type = ACCBAL_ACCT_TYPE AND LDG_VOUCHER_TYPE = ''2'' AND ldg_ref_no like '''+ convert(varchar,@@ref_no)  +'%'' and LDG_DELETED_IND = 1)'
exec(@@ssql)
	    

	set @@ssql = 'delete from ledger'+convert(varchar,@pa_finid) +' where  LDG_VOUCHER_TYPE = ''2'' and ldg_ref_no like ''' + convert(varchar,@@ref_no) +'%'' and ldg_dpm_id = ' + convert(varchar,@pa_dpmid)  
	exec(@@ssql)

	select  @@Vno=isnull(VchNo_Reciept,0),@@lst_curr_id = isnull(ledger_currid,0) from financial_yr_mstr where fin_id = @pa_finid and fin_dpm_id = @pa_dpmid and fin_deleted_ind = 1
end
else
begin
	
	update financial_yr_mstr set VchNo_Reciept = isnull(VchNo_Reciept,0) + 1 where fin_id = @pa_finid and fin_dpm_id = @pa_dpmid and fin_deleted_ind = 1

	select  @@Vno=isnull(VchNo_Reciept,0),@@lst_curr_id = isnull(ledger_currid,0) from financial_yr_mstr where fin_id = @pa_finid and fin_dpm_id = @pa_dpmid and fin_deleted_ind = 1
end

    

	update financial_yr_mstr set ledger_currid = isnull(ledger_currid,0) + isnull(@@total_rec_cnt,0)  where fin_id = @pa_finid and fin_dpm_id = @pa_dpmid and fin_deleted_ind = 1


declare rscursor  cursor for
SELECT distinct TMPREC_SR_NO from TMP_RECIEPT_MSTR where TMPREC_CREDIT <> 0 order by TMPREC_SR_NO
open rscursor
fetch next from rscursor into @@srno
WHILE @@Fetch_Status = 0
Begin
		update TMP_RECIEPT_MSTR set TMPREC_VNO = isnull(@@Vno,0) where  TMPREC_SR_NO = @@srno
		set @@Vno = isnull(@@Vno,0) + 1 
	fetch next from rscursor into @@srno
End
Close rscursor
Deallocate rscursor




Set @@ssql = 'insert into ledger' + convert(varchar,@pa_finid) + ' (LDG_ID,LDG_DPM_ID,LDG_VOUCHER_TYPE,LDG_BOOK_TYPE_CD,LDG_VOUCHER_NO,LDG_SR_NO,LDG_REF_NO,LDG_VOUCHER_DT,LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,LDG_AMOUNT,LDG_NARRATION,LDG_BANK_ID,LDG_ACCOUNT_NO,LDG_INSTRUMENT_NO,LDG_BANK_CL_DATE,LDG_COST_CD_ID,LDG_BILL_BRKUP_ID,LDG_TRANS_TYPE,LDG_STATUS,LDG_CREATED_BY,LDG_CREATED_DT,LDG_LST_UPD_BY,LDG_LST_UPD_DT,LDG_DELETED_IND,LDG_BRANCH_ID)
select LDG_ID=' + convert(varchar,isnull(@@lst_curr_id,0)) + ' + TMPREC_SR_NO -1,LDG_DPM_ID=' + convert(varchar,@pa_dpmid) + ',LDG_VOUCHER_TYPE=''2'',LDG_BOOK_TYPE_CD=''01'',LDG_VOUCHER_NO=TMPREC_VNO,1,LDG_REF_NO=''' + @@ref_no + ''' + ''_'' + convert(varchar,TMPREC_VNO),''' + @@voucher_dt + ''',TMPREC_DPAM_ID,LDG_ACCOUNT_TYPE=TMPREC_BANKGLTYPE,TMPREC_CREDIT*-1,LDG_NARRATION=''Credit Recd. from Party '' + TMPREC_BANKGLCODE + ''(Bulk Import)'',LDG_BANK_ID='''',LDG_ACCOUNT_NO='''',LDG_INSTRUMENT_NO='''',LDG_BANK_CL_DATE='''',LDG_COST_CD_ID=0,LDG_BILL_BRKUP_ID=0,LDG_TRANS_TYPE=''N'',LDG_STATUS=''P'',''' + @pa_loginname + ''',getdate(),''' + @pa_loginname + ''',getdate(),1,0 
from TMP_RECIEPT_MSTR WHERE TMPREC_CREDIT <> 0 and isnull(TMPREC_BANKGLID,0) = 0'

print @@ssql
exec(@@ssql)




select  @@lst_curr_id = isnull(ledger_currid,0) from financial_yr_mstr where fin_id = @pa_finid and fin_dpm_id = @pa_dpmid and fin_deleted_ind = 1

update financial_yr_mstr set VchNo_Reciept = @@Vno -1,ledger_currid = isnull(ledger_currid,0) + isnull(@@total_rec_cnt,0)  where fin_id = @pa_finid and fin_dpm_id = @pa_dpmid and fin_deleted_ind = 1


Set @@ssql = 'insert into ledger' + convert(varchar,@pa_finid) + ' (LDG_ID,LDG_DPM_ID,LDG_VOUCHER_TYPE,LDG_BOOK_TYPE_CD,LDG_VOUCHER_NO,LDG_SR_NO,LDG_REF_NO,LDG_VOUCHER_DT,LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,LDG_AMOUNT,LDG_NARRATION,LDG_BANK_ID,LDG_ACCOUNT_NO,LDG_INSTRUMENT_NO,LDG_BANK_CL_DATE,LDG_COST_CD_ID,LDG_BILL_BRKUP_ID,LDG_TRANS_TYPE,LDG_STATUS,LDG_CREATED_BY,LDG_CREATED_DT,LDG_LST_UPD_BY,LDG_LST_UPD_DT,LDG_DELETED_IND,LDG_BRANCH_ID)
select LDG_ID=' + convert(varchar,isnull(@@lst_curr_id,0)) + ' + TMPREC_SR_NO -1,LDG_DPM_ID=' + convert(varchar,@pa_dpmid) + ',LDG_VOUCHER_TYPE=''2'',LDG_BOOK_TYPE_CD=''01'',LDG_VOUCHER_NO=TMPREC_VNO,2,LDG_REF_NO=''' + @@ref_no + ''' + ''_'' + convert(varchar,TMPREC_VNO),''' + @@voucher_dt + ''',tmprec_DPAM_ID,LDG_ACCOUNT_TYPE=''P'',tmprec_CREDIT,LDG_NARRATION=''Credit Recd. from Party '' + TMPREC_ACCT_NO + ''(Bulk Import)'',LDG_BANK_ID='''',LDG_ACCOUNT_NO='''',LDG_INSTRUMENT_NO=TMPREC_CHEQUE_NO,LDG_BANK_CL_DATE='''',LDG_COST_CD_ID=0,LDG_BILL_BRKUP_ID=0,LDG_TRANS_TYPE=''N'',LDG_STATUS=''P'',''' + @pa_loginname + ''',getdate(),''' + @pa_loginname + ''',getdate(),1,0 
from TMP_RECIEPT_MSTR WHERE TMPREC_CREDIT <> 0 and isnull(TMPREC_BANKGLID,0) <> 0'
exec(@@ssql)






set @@ssql          = 'update accountbal' + convert(varchar,@pa_finid)  
set @@ssql          = @@ssql         + ' set accbal_amount =  isnull((select sum(ldg_amount) from ledger' + convert(varchar,@pa_finid) 
set @@ssql          = @@ssql         + ' where accbal_dpm_id    = '+convert(varchar,@pa_dpmid)
set @@ssql          = @@ssql         + ' and    accbal_acct_id   = ldg_account_id'    
set @@ssql          = @@ssql         + ' and    accbal_acct_TYPE = ldg_account_type'    
set @@ssql          = @@ssql         + ' and    accbal_dpm_id    = ldg_dpm_id      '       
set @@ssql          = @@ssql         + ' and    LDG_DELETED_IND =1 '
set @@ssql          = @@ssql         + ' and    ACCBAL_DELETED_IND =1),0) '
set @@ssql          = @@ssql         + ' where exists(select TMPREC_dpam_ID from TMP_RECIEPT_MSTR where ACCBAL_ACCT_ID = tmpREC_dpam_id and ACCBAL_ACCT_TYPE = case when TMPREC_BANKGLid = 0 then TMPREC_BANKGLTYPE else ''P'' end and ACCBAL_DELETED_IND = 1)'

exec (@@ssql)


    
set @@ssql          = 'insert into accountbal' + convert(varchar,@pa_finid)    
set @@ssql          = @@ssql + ' select ' + convert(varchar,@pa_dpmid) + ',TMPREC_DPAM_ID,''P'',sum(TMPREC_CREDIT),''' + @pa_loginname + ''',getdate(),''' + @pa_loginname + ''',getdate(),1'
set @@ssql          = @@ssql + ' from TMP_RECIEPT_MSTR '
set @@ssql          = @@ssql + ' where  isnull(TMPREC_BANKGLID,0) <> 0 and TMPREC_CREDIT <> 0 and not exists(select ACCBAL_ACCT_ID from accountbal' + convert(varchar,@pa_finid)  + ' where ACCBAL_ACCT_ID = tmpREC_dpam_id and isnull(TMPREC_BANKGLID,0) <> 0 and ACCBAL_ACCT_TYPE = ''P'' and ACCBAL_DELETED_IND = 1)'  
set @@ssql          = @@ssql + ' group by TMPREC_DPAM_ID'  
exec (@@ssql)

set @@ssql          = 'insert into accountbal' + convert(varchar,@pa_finid)    
set @@ssql          = @@ssql + ' select ' + convert(varchar,@pa_dpmid) + ',tmprec_DPAM_ID,TMPREC_BANKGLTYPE,sum(TMPREC_CREDIT)*-1,''' + @pa_loginname + ''',getdate(),''' + @pa_loginname + ''',getdate(),1'
set @@ssql          = @@ssql + ' from TMP_RECIEPT_MSTR '
set @@ssql          = @@ssql + ' where isnull(TMPREC_BANKGLID,0) = 0 and TMPREC_CREDIT <> 0 and not exists(select ACCBAL_ACCT_ID from accountbal' + convert(varchar,@pa_finid)  + ' where ACCBAL_ACCT_ID = tmpREC_dpam_id and ACCBAL_ACCT_TYPE = TMPREC_BANKGLTYPE and isnull(TMPREC_BANKGLID,0) = 0 and ACCBAL_DELETED_IND = 1)'  
set @@ssql          = @@ssql + ' group by TMPREC_DPAM_ID,TMPREC_BANKGLTYPE'  



exec (@@ssql)




commit tran

end

GO
