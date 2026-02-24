-- Object: PROCEDURE citrus_usr.PR_PH_DTLS
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--PR_PH_DTLS '1201090004211738',3      
CREATE PROCEDURE [citrus_usr].[PR_PH_DTLS]      
(      
 @PA_BO_ID VARCHAR(20),      
 @PA_EXCSM_ID NUMERIC(10,0)       
)      
as      
begin      
      
declare @l_dpm_id numeric       
,@l_dpam_id numeric      
,@l_ledger_id numeric       
,@l_ledgeramount numeric       
,@last_slip_issue varchar(1000)      
      
  set @l_ledger_id  = 0    
  set @l_dpm_id = 0    
  set @l_dpam_id  = 0    
select @l_dpm_id  = dpam_dpm_id ,@l_dpam_id = dpam_id       
from dp_Acct_mstr       
where dpam_sba_no = @PA_BO_ID and dpam_deleted_ind = 1               
       
select @l_ledger_id  = FIN_ID      
from financial_yr_mstr      
where FIN_DPM_ID = @l_dpm_id       
and FIN_DELETED_IND = 1       
and getdate() between FIN_START_DT and FIN_END_DT      
      
declare @l_sql varchar(8000)      
if @l_ledger_id <> 0
begin    
select @l_sql =' select isnull(sum(ldg_amount),0) ledgeramount into ##ledgeramount from ledger'+convert(varchar(10),@l_ledger_id) + ' where ldg_account_id = ' +convert(varchar(100),@l_dpam_id ) +' and ldg_account_type = ''P'' and ldg_deleted_ind = 1'      
exec(@l_sql)
end
    
if @l_ledger_id = 0    
begin     
select @l_ledgeramount = 0    
end     
else     
begin    
select @l_ledgeramount = ledgeramount from ##ledgeramount      
end     

 
select top 1 @last_slip_issue = SLIIM_SLIP_NO_TO from slip_issue_mstr      
where SLIIM_DPAM_ACCT_NO = @PA_BO_ID       
and sliim_deleted_ind = 1 order by SLIIM_dt desc      
      
      
 select isnull(citrus_usr.[fn_conc_value](dpam_crn_no,'OFF_PH1'),'') [office ph]      
 ,isnull(citrus_usr.[fn_conc_value](dpam_crn_no,'MOBILE1'),'') [mobile]      
 ,isnull(citrus_usr.[fn_conc_value](dpam_crn_no,'RES_PH1'),'') [res ph]      
 ,isnull(citrus_usr.[fn_ucc_entp](dpam_crn_no,'pan_gir_no',''),'') [pan_no]      
 ,case when isnull(citrus_usr.fn_find_relations_nm_by_dpamno(dpam_sba_no,'BR'),'') = '' then isnull(citrus_usr.fn_find_relations_nm_by_dpamno(dpam_sba_no,'BA'),'') else isnull(citrus_usr.fn_find_relations_nm_by_dpamno(dpam_sba_no,'BR'),'') end [Branch Name]      
     
 ,@l_ledgeramount [Ledger]      
 ,@last_slip_issue [Last_slip]      
 ,isnull(citrus_usr.[fn_ucc_accp](dpam_id,'BBO_CODE',''),'') [bbo_code]      
 from dp_acct_mstr       
 where dpam_SBA_NO = @PA_BO_ID      
 --and DPAM_EXCSM_ID = @PA_EXCSM_ID      
 and dpam_deleted_ind =1       
     
   -- drop table ##ledgeramount
      
end

GO
