-- Object: PROCEDURE citrus_usr.pr_rpt_demat_status
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--exec pr_rpt_demat_status '2',4

CREATE procedure [citrus_usr].[pr_rpt_demat_status](@pa_drn_no varchar(25),@pa_excsm_id numeric)
as
begin 

declare @l_dpm_id numeric
--select @l_dpm_id = dpm_id from dp_mstr where default_dp = dpm_Excsm_id and dpm_excsm_id = @pa_excsm_id and dpm_deleted_ind =1
select dpam_sba_no ,dpam_sba_name ,demrm_isin [ISIN], ISIN_NAME [ISIN NAME]
     , abs(demrm_qty) [Quantity]	
     , demrm_drf_no [DPM NO]
     , isnull(DISP_NAME,'')  [Courier]
     , convert(varchar(11), disp_dt,103) [Dispatch Dt] 
     , isnull(DISP_DOC_ID,'0')  [Dispatch No]
     ,  case when isnull(DEMRM_INTERNAL_REJ,'') = '' and isnull(DEMRM_COMPANY_OBJ,'') = '' and isnull(DISP_TO,'') = 'R' and isnull(DISP_CONF_RECD,'') = '' AND disp_type ='N'    Then 'OUTWARD TO RTA' 
             when isnull(DEMRM_INTERNAL_REJ,'') = '' and isnull(DEMRM_COMPANY_OBJ,'') = '' and isnull(DISP_TO,'') = 'R' AND  ISNULL(DISP_CONF_RECD,'') <> 'C' Then 'PENDING WITH RTA' 
             when (isnull(DEMRM_INTERNAL_REJ,'') <> '' or isnull(DEMRM_COMPANY_OBJ,'') <> '') and isnull(DISP_TO,'') = 'C' and ISNULL(DISP_CONF_RECD,'') <> 'D'  Then 'OUTWARD TO CLIENT' else '' end   status 
     ,entm_name1 RTANAME  ,DISP_CONF_RECD DISP_CONF_RECD
from   demat_request_mstr 
       left outer join 
       Dmat_Dispatch on disp_demrm_id = demrm_id and ISNULL(DISP_CONF_RECD,'') <> 'D'
       left outer join 
       entity_mstr on disp_rta_cd = entm_short_name and entm_deleted_ind=1     
     , dp_acct_mstr  
     , isin_mstr 
where  demrm_dpam_id = dpam_id 
and    demrm_isin    = isin_cd
and    demrm_slip_serial_no = @pa_drn_no
and    DPAM_EXCSM_ID  = @pa_excsm_id
and    demrm_deleted_ind = 1
and    dpam_deleted_ind = 1
and    ISIN_DELETED_IND =  1 

end

GO
