-- Object: PROCEDURE citrus_usr.pr_rpt_cheque_details
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

-- pr_rpt_cheque_details 4,'Oct  1 2010','Oct 26 2010', 1,'HO|*~|'
--4	Oct  1 2010	Oct 26 2010	HO|*~|GCLA|*~|
CREATE procedure [citrus_usr].[pr_rpt_cheque_details](@pa_id numeric
, @pa_from_dt datetime
, @pa_to_dt datetime
,@pa_login_pr_entm_id numeric                        
,@pa_login_entm_cd_chain  varchar(8000))  
as  
begin   

 declare  @@dpmid int,  @@l_child_entm_id numeric

select @@dpmid = dpm_id from dp_mstr with(nolock) where default_dp = @pa_id and dpm_deleted_ind =1                      
 select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)

 CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)
 INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		
                   
 select @@dpmid = dpm_id from dp_mstr with(nolock) where default_dp = @pa_id and dpm_deleted_ind =1                      
 select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)
 

 
    declare @l_dpm_id numeric  
    select @l_dpm_id  = dpm_id from dp_mstr where default_dp = dpm_excsm_id and dpm_excsm_id = @pa_id and dpm_deleted_ind = 1  
print @l_dpm_id
    select [Bank-Branch Name], [Cheque Number], sum([Received Amount]) [Received Amount] , [trx_dt] ,[Created_by],[created_on] from   
 (select inwcr_clibank_name  [Bank-Branch Name], inwcr_cheque_no [Cheque Number],inwcr_frmno, inwcr_charge_collected [Received Amount], convert(varchar(11),inwcr_recvd_dt,103) [trx_dt],''  [Created_by],''  [created_on]  
 from inw_client_reg,entity_mstr,login_names   ,dp_Acct_mstr dpam ,#ACLIST filter
 where inwcr_dmpdpid = @l_dpm_id     and dpam_acct_no = inwcr_frmno and filter.dpam_sba_no = dpam.dpam_sba_no
    and   inwcr_recvd_dt between @pa_from_dt and @pa_to_dt   
 and   isnull(inwcr_cheque_no,'') <> ''
 and entm_short_name = logn_short_name
 and logn_name = inwcr_created_by
 and entm_short_name = 'HO'   
 and   inwcr_deleted_ind = 1   
    union  all 
 select inwsr_clibank_name  [Bank-Branch Name], inwsr_cheque_no [Cheque Number],'' as inwcr_frmno,inwsr_ufcharge_collected [Received Amount], convert(varchar(11),INWSR_RECD_DT,103) [trx_dt],'' [Created_by],'' [created_on]  
 from INWARD_SLIP_REG inwsr,entity_mstr,login_names   ,dp_Acct_mstr dpam ,#ACLIST filter  
 where inwsr_dpm_id = @l_dpm_id     
 and   INWSR_RECD_DT between @pa_from_dt and @pa_to_dt   
 and   isnull(inwsr_cheque_no,'') <> '' and dpam.DPAM_ID = INWSR_DPAM_ID and filter.dpam_sba_no = dpam.dpam_sba_no
 and   inwsr_deleted_ind = 1 
 and entm_short_name = logn_short_name
 and logn_name = inwsr_created_by
 and entm_short_name = 'HO') a  
 group by [Bank-Branch Name]   
 ,[Cheque Number], [trx_dt] ,[Created_by],[created_on]  
end

GO
