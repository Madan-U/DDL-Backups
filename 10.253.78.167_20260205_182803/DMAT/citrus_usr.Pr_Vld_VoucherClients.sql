-- Object: PROCEDURE citrus_usr.Pr_Vld_VoucherClients
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--Execute Pr_Vld_VoucherClients 	203412,2,'B','gh',1
CREATE Proc [citrus_usr].[Pr_Vld_VoucherClients]
@dpmid bigint,
@finid int,
@Acc_type varchar(3), -- 'P - party only ,G - GL only ,B bank & cash only,PG party & gl only,A - All accounts
@Acc_code varchar(20),
@pa_login_pr_entm_id numeric                                      
as
begin

declare @@ssql varchar(8000),
@@Acc_code_len int
set @Acc_code = ltrim(rtrim(@Acc_code))
set @@Acc_code_len = len(@Acc_code)

if @Acc_type = 'P'
begin
	SELECT Accid =dpam_id,dpam_sba_no=ltrim(rtrim(dpam_sba_no)),dpam_sba_name=ltrim(rtrim(dpam_sba_name)),ACCTTYPE= 'PARTY'
	,AMOUNT=0,BRANCHID=0,SHORTNAME=''
	FROM citrus_usr.fn_acct_list(@dpmid ,@pa_login_pr_entm_id,0)
	where Right(dpam_sba_no,@@Acc_code_len) = @Acc_code
	and getdate() between EFF_FROM AND EFF_TO 		
end
if @Acc_type = 'G'
begin
	SELECT Accid =FINA_ACC_ID,dpam_sba_no=ltrim(rtrim(FINA_ACC_CODE)),dpam_sba_name=ltrim(rtrim(FINA_ACC_NAME)),ACCTTYPE= 'GL'
	,AMOUNT=0,BRANCHID=0,SHORTNAME=''
	FROM fin_account_mstr
	where Right(FINA_ACC_CODE,@@Acc_code_len) = @Acc_code
	and fina_acc_type = 'G'
	and fina_dpm_id = @dpmid
	and fina_deleted_ind = 1
end
if @Acc_type = 'B'
begin
		Set @@ssql = 'SELECT Accid =FINA_ACC_ID,dpam_sba_no=ltrim(rtrim(FINA_ACC_CODE)),dpam_sba_name=ltrim(rtrim(FINA_ACC_NAME)),ACCTTYPE= CASE WHEN fina_acc_type = ''B'' THEN ''BANK''  ELSE ''CASH'' END
		,ACCBAL_AMOUNT  AMOUNT,BRANCHID=0,SHORTNAME=''''
		FROM fin_account_mstr left outer join ACCOUNTBAL' + convert(varchar,@finid) + '                      
		on FINA_ACC_ID = ACCBAL_ACCT_ID and fina_acc_type = ACCBAL_ACCT_TYPE                         
		and ACCBAL_DELETED_IND = 1 
		where Right(FINA_ACC_CODE,' + convert(varchar,@@Acc_code_len) + ') = ''' + @Acc_code + '''
		and fina_acc_type in (''B'',''C'')
		and fina_dpm_id = ' + convert(varchar,@dpmid) + '
		and fina_deleted_ind = 1'
print(@@ssql)
		Exec(@@ssql)
end
if @Acc_type = 'PG'
begin
	SELECT Accid =dpam_id,dpam_sba_no=ltrim(rtrim(dpam_sba_no)),dpam_sba_name=ltrim(rtrim(dpam_sba_name)),ACCTTYPE= CASE WHEN acct_type = 'B' THEN 'BANK'  WHEN acct_type = 'C' THEN 'CASH' WHEN acct_type = 'P' THEN 'PARTY' WHEN acct_type = 'C' THEN 'CASH' WHEN acct_type = 'G' THEN 'GL' END
	,AMOUNT=0,BRANCHID=0,SHORTNAME=''
	FROM citrus_usr.fn_gl_acct_list(@dpmid ,@pa_login_pr_entm_id,0)
	where Right(dpam_sba_no,@@Acc_code_len) = @Acc_code
	and getdate() between EFF_FROM AND EFF_TO 	
end

end

GO
