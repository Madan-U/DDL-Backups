-- Object: PROCEDURE citrus_usr.pr_rpt_creditdebit_grpby
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--SELECTION CRITERIA :  
--select * from financial_yr_mstr
	--3			Jan 14 2008	Sep 14 2009	1	CR			1		
--RECEIPT DATE FROM  08/09/2009 TO 08/09/2009 STATUS A DR / CR  CR ACCOUNT NO  ALL BATCH NO  ALL USER ID  ALL GROUP CD  ALL 
--[pr_rpt_creditdebit_grpby] '3','','','apr 04 2010', 'Sep 14 2010','','','','','',1,'ho|*~|*|~*',''
CREATE PROCEDURE [citrus_usr].[pr_rpt_creditdebit_grpby](@PA_ID  NUMERIC
                                   ,@PA_FROM_ACCT VARCHAR(100)
                                   ,@PA_TO_ACCT   VARCHAR(100)
                                   ,@PA_FROM_DT   DATETIME
                                   ,@PA_TO_DT     DATETIME
                                   ,@PA_STATUS    VARCHAR(1000)
                                   ,@PA_CR_DR     CHAR(1)
                                   ,@PA_BATCH_NO  VARCHAR(10)
                                   ,@PA_ENTRY_ID  VARCHAR(100),@Pa_groupby varchar(1000)
								   ,@pa_login_pr_entm_id numeric                        
								   ,@pa_login_entm_cd_chain  varchar(8000) 
                                   ,@PA_OUT       VARCHAR(8000) OUT )
AS
BEGIN

if @Pa_groupby = 'HO'
begin 


exec  [citrus_usr].[pr_rpt_creditdebit] @PA_ID  ,@PA_FROM_ACCT 
                                   ,@PA_TO_ACCT   
                                   ,@PA_FROM_DT   
                                   ,@PA_TO_DT     
                                   ,@PA_STATUS    
                                   ,@PA_CR_DR     
                                   ,@PA_BATCH_NO  
                                   ,@PA_ENTRY_ID  
								   ,@pa_login_pr_entm_id 
								   ,@pa_login_entm_cd_chain  
                                   ,''
return 

end 

declare @@l_child_entm_id numeric
  , @@dpmid NUMERIC

IF @pa_from_acct = ''                      
 BEGIN                      
  SET @pa_from_acct = '0'                      
  SET @pa_to_acct = '99999999999999999'                      
 END                      
 IF @pa_to_acct = ''                      
 BEGIN                  
   SET @pa_to_acct = @pa_from_acct                      
 END       

select @@dpmid = dpm_id from dp_mstr with(nolock) where DPM_EXCSM_ID = default_dp  AND default_dp = @pa_ID and dpm_deleted_ind =1                      

create table #ledger 
(LDG_DPM_ID numeric
,LDG_VOUCHER_TYPE int
,LDG_BOOK_TYPE_CD varchar(4)
,LDG_VOUCHER_NO numeric
,LDG_REF_NO varchar(50)
,LDG_VOUCHER_DT datetime
,LDG_ACCOUNT_ID numeric
,LDG_ACCOUNT_TYPE char(1)
,LDG_AMOUNT numeric(18,4)
,LDG_NARRATION varchar(250)
,LDG_STATUS char(1)
,LDG_CREATED_BY varchar(50)
,LDG_CREATED_DT datetime
,LDG_LST_UPD_BY varchar(50)
,LDG_LST_UPD_DT datetime
,LDG_DELETED_IND smallint ) 


declare @@fin_yr_id  numeric
if EXISTS(select FIN_ID from financial_yr_mstr where @PA_FROM_DT  between FIN_START_DT and FIN_END_DT 
and @PA_TO_DT   between FIN_START_DT and FIN_END_DT  and FIN_DPM_ID = @@dpmid)
begin
SELECT @@fin_yr_id  = FIN_ID from financial_yr_mstr where @PA_FROM_DT  between FIN_START_DT and FIN_END_DT 
and @PA_TO_DT   between FIN_START_DT and FIN_END_DT  and FIN_DPM_ID = @@dpmid
end
ELSE 
begin
Select @PA_OUT = 'PLEASE SELECT FROM DATE & TO DATE BETWEEN FINANCIAL YEAR' 
--print @PA_OUT
return
end 
declare @@l_sql varchar(8000)
set @@l_sql = 'insert into #ledger select LDG_DPM_ID 
,LDG_VOUCHER_TYPE 
,LDG_BOOK_TYPE_CD 
,LDG_VOUCHER_NO 
,LDG_REF_NO
,LDG_VOUCHER_DT 
,LDG_ACCOUNT_ID 
,LDG_ACCOUNT_TYPE 
,LDG_AMOUNT 
,LDG_NARRATION 
,LDG_STATUS 
,LDG_CREATED_BY 
,LDG_CREATED_DT 
,LDG_LST_UPD_BY 
,LDG_LST_UPD_DT 
,LDG_DELETED_IND   from ledger' + convert(varchar,@@fin_yr_id )
+ ' where ldg_voucher_dt between ''' + convert(varchar(11),@PA_FROM_DT,109) + ''' and ''' + convert(varchar(11),@PA_TO_DT,109)  + ''''
print @@l_sql

exec(@@l_sql)



select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)
 
CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME,group_cd bigint)

INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO,'' FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		


select @@l_sql  = citrus_usr.fn_createheirarchy_update('#ACLIST',@Pa_groupby)
print @@l_sql  
exec(@@l_sql)


if exists(select excsm_exch_cd from exch_seg_mstr , dp_mstr where default_dp = dpm_excsm_id and dpm_excsm_id = @pa_id and excsm_id = dpm_excsm_id and excsm_id = 1 and excsm_exch_cd = 'CDSL')
begin
	SELECT DISTINCT DPAM.DPAM_SBA_NO  ACCOUNT_NO 
						, DPAM.DPAM_SBA_NAME ACCOUNT_NAME 
						, INWSR_PAY_MODE PAYMENT_MODE 
						, 0 DR_AMOUNT
						, ISNULL(INWSR_UFCHARGE_COLLECTED,'0') CR_AMOUNT
						, INWSR_RMKS NARRATION
						, convert(varchar,INWSR_RECD_DT,103) received_date
						, '' status , '' Batch_no , INWSR_ID
      , INWSR_CREATED_BY [entry_id],group_cd
	FROM   #ledger , INWARD_SLIP_REG  
				,   DP_ACCT_MSTR DPAM
				,   DP_MSTR , #ACLIST ACCOUNT, entity_mstr
	WHERE  ldg_created_by ='INWARDENTRY'  and entm_id = account.group_cd
 and    isnull(inwsr_trastm_cd,'') + '_'+ convert(varchar,isnull(INWSR_id,'0')) =  LDG_REF_NO
 and    INWSR_DPAM_ID     = DPAM.DPAM_ID 
 AND    ACCOUNT.DPAM_ID = dpam.DPAM_ID 	
	AND    DPAM.DPAM_DPM_ID       = DPM_ID 
	AND    DPM_EXCSM_ID      = DEFAULT_DP 
	AND    DPM_EXCSM_ID      = @PA_ID
	and    INWSR_RECD_DT between   @pa_from_dt and @pa_to_dt --+ ' 23:59:00'
   AND DPAM.DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM.DPAM_SBA_NO  <= @PA_TO_ACCT
	AND    DPM_DELETED_IND   = 1
	AND    DPAM.DPAM_DELETED_IND  = 1
	AND    INWSR_DELETED_IND = 1 and INWSR_CREATED_BY like  @pa_entry_id + '%'
 union
 SELECT DISTINCT DPAM.DPAM_SBA_NO  ACCOUNT_NO 
						, DPAM.DPAM_SBA_NAME ACCOUNT_NAME 
						, 'AUTO CREDIT ' PAYMENT_MODE 
						, case when ldg_amount < 0 then convert(varchar,abs(ldg_amount)) else '' end DR_AMOUNT
						, case when ldg_amount > 0 then convert(varchar,abs(ldg_amount)) else '' end CR_AMOUNT
						, LDG_NARRATION NARRATION
						, convert(varchar,ldg_voucher_dt,103) received_date
						, '' status , '' Batch_no ,INWSR_ID
      , ldg_created_by [entry_id],group_cd
	FROM   #ledger ,   DP_ACCT_MSTR DPAM ,INWARD_SLIP_REG
				,   DP_MSTR , #ACLIST ACCOUNT, entity_mstr
	WHERE  ldg_account_id = DPAM.DPAM_ID and entm_id = account.group_cd and ldg_voucher_type = '3'
 and    LDG_NARRATION  like 'Recovered from trading A/C towards Curr O/S on%'
 AND    ACCOUNT.DPAM_ID = dpam.DPAM_ID 
AND    INWSR_DPM_ID      = DPAM.DPAM_DPM_ID 
	AND    ldg_DPM_ID      = DPAM.DPAM_DPM_ID 
    and    INWSR_DPAM_ID     = DPAM.DPAM_ID 
	AND    DPAM.DPAM_DPM_ID       = DPM_ID 
	AND    DPM_EXCSM_ID      = DEFAULT_DP 
	AND    DPM_EXCSM_ID      = @PA_ID
	and    ldg_voucher_dt between   @pa_from_dt and @pa_to_dt + ' 23:59:00'
    AND DPAM.DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM_SBA_NO  <= @PA_TO_ACCT
	AND    DPM_DELETED_IND   = 1
	AND    DPAM.DPAM_DELETED_IND  = 1
	AND    ldg_DELETED_IND = 1  and ldg_created_by like  @pa_entry_id + '%'
 union
 SELECT DISTINCT DPAM.DPAM_SBA_NO  ACCOUNT_NO 
						, DPAM.DPAM_SBA_NAME ACCOUNT_NAME 
						, 'AUTO CREDIT ' PAYMENT_MODE 
						, case when ldg_amount < 0 then convert(varchar,abs(ldg_amount)) else '' end DR_AMOUNT
						, case when ldg_amount > 0 then convert(varchar,abs(ldg_amount)) else '' end CR_AMOUNT
						, LDG_NARRATION NARRATION
						, convert(varchar,ldg_voucher_dt,103) received_date
						, '' status , '' Batch_no ,INWSR_ID
      , ldg_created_by [entry_id],group_cd
	FROM   #ledger ,   DP_ACCT_MSTR DPAM, INWARD_SLIP_REG
				,   DP_MSTR , #ACLIST ACCOUNT, entity_mstr 
	WHERE  ldg_account_id = DPAM.DPAM_ID and entm_id = account.group_cd and ldg_voucher_type = '2'
 and    LDG_NARRATION  like 'Credit Recd. from Party%'
 AND    ACCOUNT.DPAM_ID = dpam.DPAM_ID 
	AND    ldg_DPM_ID      = DPAM.DPAM_DPM_ID 
    and    INWSR_DPAM_ID     = DPAM.DPAM_ID
	AND    INWSR_DPM_ID      = DPAM.DPAM_DPM_ID 
	AND    DPAM.DPAM_DPM_ID       = DPM_ID 
	AND    DPM_EXCSM_ID      = DEFAULT_DP 
	AND    DPM_EXCSM_ID      = @PA_ID
	and    ldg_voucher_dt between   @pa_from_dt and @pa_to_dt + ' 23:59:00'
    AND DPAM.DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM.DPAM_SBA_NO  <= @PA_TO_ACCT
	AND    DPM_DELETED_IND   = 1
	AND    DPAM.DPAM_DELETED_IND  = 1
	AND    ldg_DELETED_IND = 1  and ldg_created_by like  @pa_entry_id + '%'
    order by entm_name1,group_cd  
end 
else 
begin
print 'tt'

	SELECT DISTINCT DPAM.DPAM_SBA_NO  ACCOUNT_NO 
						, DPAM.DPAM_SBA_NAME ACCOUNT_NAME 
						, INWSR_PAY_MODE PAYMENT_MODE 
						, 0 DR_AMOUNT
						, ISNULL(INWSR_UFCHARGE_COLLECTED,'0') CR_AMOUNT
						, INWSR_RMKS NARRATION
						, convert(varchar,INWSR_RECD_DT,103) received_date
						, '' status 
						, '' Batch_no 
						, INWSR_ID
						, INWSR_CREATED_BY [entry_id],group_cd
	FROM    #ledger , INWARD_SLIP_REG 
				,   DP_ACCT_MSTR DPAM
				,   DP_MSTR , #ACLIST ACCOUNT, entity_mstr
	WHERE  ldg_created_by ='INWARDENTRY'   and entm_id = account.group_cd
 and    isnull(inwsr_trastm_cd,'') + '_'+ convert(varchar,isnull(INWSR_id,'0'))=  LDG_REF_NO
 AND DPAM.DPAM_ID = ACCOUNT.DPAM_ID 
	and    INWSR_DPAM_ID     = DPAM.DPAM_ID
	AND    INWSR_DPM_ID      = DPAM.DPAM_DPM_ID 
	AND    DPAM.DPAM_DPM_ID       = DPM_ID 
	AND    DPM_EXCSM_ID      = DEFAULT_DP 
	AND    DPM_EXCSM_ID      = @PA_ID
 and    INWSR_RECD_DT between   convert(datetime,@pa_from_dt,103) and convert(datetime,@pa_to_dt,103) --+ ' 23:59:00'
AND DPAM.DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM.DPAM_SBA_NO  <= @PA_TO_ACCT
	AND    DPM_DELETED_IND   = 1
	AND    DPAM.DPAM_DELETED_IND  = 1
	AND    INWSR_DELETED_IND = 1 and INWSR_CREATED_BY like  @pa_entry_id + '%'
union
 SELECT DISTINCT DPAM.DPAM_SBA_NO  ACCOUNT_NO 
						, DPAM.DPAM_SBA_NAME ACCOUNT_NAME 
						, 'AUTO CREDIT' PAYMENT_MODE 
						, case when ldg_amount < 0 then convert(varchar,abs(ldg_amount)) else '' end DR_AMOUNT
						, case when ldg_amount > 0 then convert(varchar,abs(ldg_amount)) else '' end CR_AMOUNT
						, LDG_NARRATION NARRATION
						, convert(varchar,ldg_voucher_dt,103) received_date
						, '' status , '' Batch_no ,INWSR_ID
      , ldg_created_by [entry_id],group_cd
	FROM   #ledger ,   INWARD_SLIP_REG, DP_ACCT_MSTR DPAM
				,   DP_MSTR , #ACLIST ACCOUNT, entity_mstr
	WHERE  ldg_account_id = DPAM.DPAM_ID and ldg_voucher_type = '3' and entm_id = account.group_cd
 and    LDG_NARRATION  like 'Recovered from trading A/C towards Curr O/S on%'
 AND    ACCOUNT.DPAM_ID = dpam.DPAM_ID 
	AND    ldg_DPM_ID      = DPAM.DPAM_DPM_ID 
    and    INWSR_DPAM_ID     = DPAM.DPAM_ID 
	AND    INWSR_DPM_ID      = DPAM.DPAM_DPM_ID
	AND    DPAM.DPAM_DPM_ID       = DPM_ID 
	AND    DPM_EXCSM_ID      = DEFAULT_DP 
	AND    DPM_EXCSM_ID      = @PA_ID
	and    ldg_voucher_dt between   @pa_from_dt and @pa_to_dt + ' 23:59:00'
AND DPAM.DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM.DPAM_SBA_NO  <= @PA_TO_ACCT
	AND    DPM_DELETED_IND   = 1
	AND    DPAM.DPAM_DELETED_IND  = 1
	AND    ldg_DELETED_IND = 1  and ldg_created_by like  @pa_entry_id + '%'
union
 SELECT DISTINCT DPAM.DPAM_SBA_NO  ACCOUNT_NO 
						, DPAM.DPAM_SBA_NAME ACCOUNT_NAME 
						, 'AUTO CREDIT ' PAYMENT_MODE 
						, case when ldg_amount < 0 then convert(varchar,abs(ldg_amount)) else '' end DR_AMOUNT
						, case when ldg_amount > 0 then convert(varchar,abs(ldg_amount)) else '' end CR_AMOUNT
						, LDG_NARRATION NARRATION
						, convert(varchar,ldg_voucher_dt,103) received_date
						, '' status , '' Batch_no ,INWSR_ID
      , ldg_created_by [entry_id],group_cd
	FROM   #ledger ,  INWARD_SLIP_REG, DP_ACCT_MSTR DPAM
				,   DP_MSTR , #ACLIST ACCOUNT, entity_mstr
	WHERE  ldg_account_id = DPAM.DPAM_ID and ldg_voucher_type = '2' and entm_id = account.group_cd
 and    LDG_NARRATION  like 'Credit Recd. from Party%'
 AND    ACCOUNT.DPAM_ID = dpam.DPAM_ID 
	AND    ldg_DPM_ID      = DPAM.DPAM_DPM_ID 
    and    INWSR_DPAM_ID     = DPAM.DPAM_ID
	AND    INWSR_DPM_ID      = DPAM.DPAM_DPM_ID 
	AND    DPAM.DPAM_DPM_ID       = DPM_ID 
	AND    DPM_EXCSM_ID      = DEFAULT_DP 
	AND    DPM_EXCSM_ID      = @PA_ID  
	and    ldg_voucher_dt between   @pa_from_dt and @pa_to_dt + ' 23:59:00'
	AND DPAM.DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM.DPAM_SBA_NO  <= @PA_TO_ACCT
	AND    DPM_DELETED_IND   = 1
	AND    DPAM.DPAM_DELETED_IND  = 1
	AND    ldg_DELETED_IND = 1  and ldg_created_by like  @pa_entry_id + '%'
end 

END

GO
