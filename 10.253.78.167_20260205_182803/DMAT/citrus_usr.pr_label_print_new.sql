-- Object: PROCEDURE citrus_usr.pr_label_print_new
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--exec pr_label_print 3,'jan 01 1997','sep 01 2009','','','1','ho|*~|',''

Create procedure [citrus_usr].[pr_label_print_new]
( @pa_id numeric
, @pa_from_dt datetime
, @pa_to_dt datetime
, @pa_from_acct varchar(1000)
, @pa_to_acct varchar(1000)
, @pa_login_pr_entm_id numeric                        
, @pa_login_entm_cd_chain  varchar(8000) 
, @pa_out varchar(8000) out)
as
begin
  
  SET DATEFORMAT dmy

  declare @@l_child_entm_id numeric
  , @@dpmid NUMERIC
  select convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd into #account_properties 
  from account_properties 
  where accp_accpm_prop_cd = 'BILL_START_DT' 
  and isnull(accp_value ,'') not in ( '','//')
  and substring(accp_value,1,2) <> '00' 


  
IF @pa_from_acct = ''                      
 BEGIN                      
  SET @pa_from_acct = '0'                      
  SET @pa_to_acct = '99999999999999999'                      
 END                      
 IF @pa_to_acct = ''                      
 BEGIN                  
   SET @pa_to_acct = @pa_from_acct                      
 END       

select @@dpmid = dpm_id from dp_mstr with(nolock) where default_dp = @pa_ID and dpm_deleted_ind =1                      


select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)
 
CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)

INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		


  select  DPAM.dpam_sba_no 
,DPAM.dpam_sba_NAME 
,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM.DPAM_CRN_NO,'COR_ADR1'),1) [CADDRESS1]
		,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM.DPAM_CRN_NO,'COR_ADR1'),2)+' '+ISNULL(CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM.DPAM_CRN_NO,'COR_ADR1'),3),'') [CADDRESS2]
		,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM.DPAM_CRN_NO,'COR_ADR1'),4) [CCITY]
		,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM.DPAM_CRN_NO,'COR_ADR1'),5) [CSTATE]
		,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM.DPAM_CRN_NO,'COR_ADR1'),6) [CCOUNTRY]
		,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM.DPAM_CRN_NO,'COR_ADR1'),7) [CPIN CODE]
		,CITRUS_USR.FN_CONC_VALUE(DPAM.DPAM_CRN_NO,'OFF_PH1') [OFFPHONENO]
      

  from dp_acct_mstr dpam
    ,  dp_mstr ,#account_properties , #ACLIST account
  where accp_clisba_id = dpam.dpam_id and account.dpam_id = dpam.dpam_id 
  and   dpam.dpam_dpm_id = dpm_id 
  and  default_dp = dpm_excsm_id 
  and  dpm_excsm_id = @pa_id
  and  isnumeric(DPAM.dpam_sba_no)=1
  and  accp_value between   @pa_from_dt and @pa_to_dt
  and  dpam.dpam_sba_no >= @pa_from_acct and dpam.dpam_sba_no <=  @pa_to_acct
  and  citrus_usr.fn_addr_value(dpam.dpam_crn_no,'COR_ADR1') <> '' 
  
end

GO
