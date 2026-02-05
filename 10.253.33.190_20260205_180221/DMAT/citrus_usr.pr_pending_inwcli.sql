-- Object: PROCEDURE citrus_usr.pr_pending_inwcli
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

-- exec pr_pending_inwcli 4,'Jan 01 2005','Jan 10 2009',''
CREATE procedure [citrus_usr].[pr_pending_inwcli](@pa_id numeric, @pa_from_dt datetime, @pa_to_dt datetime, @pa_errmsg varchar(8000) OUTPUT)  
as  
begin  
   declare @l_excm_cd varchar(100)  
, @l_excm_id  numeric  
, @l_dpm_id   numeric 


   select @l_excm_id = dpm_excsm_id, @l_dpm_id = dpm_id  from dp_mstr where dpm_excsm_id = default_dp and dpm_deleted_ind = 1 and dpm_excsm_id = @pa_id   
  
   select @l_excm_cd = EXCSM_EXCH_CD from exch_seg_mstr where excsm_id = @l_excm_id and excsm_deleted_ind = 1  
   
    print  @l_excm_cd
  

	   select dpm_name,inwcr_id [INWARD NO], inwcr_frmno [FORM NO], dpam_sba_name,DPAM_ID ,INWCR_RECVD_DT ,isnull(inwcr_charge_collected,0) inwcr_charge_collected ,inwcr_PAY_MODE,INWCR_cheque_no,inwcr_clibank_accno,isnull(inwcr_clibank_name,'')  inwcr_clibank_name,dpam_sba_no,inwcr_rmks,INWCR_NAME,isnull(BANM_NAME,'') BANM_NAME ,inwcr_cheque_dt
	   from inw_client_reg left outer join bank_mstr on INWCR_BANK_ID=banm_id and banm_deleted_ind=1 , DP_ACCT_MSTR ,dp_mstr     
	   where isnull(inwcr_frmno,'') <> '' 
	   and    inwcr_frmno   =  dpam_acct_no
	    and   INWCR_RECVD_DT between @pa_from_dt and @pa_to_dt  
	   and   inwcr_dmpdpid = @l_dpm_id     
	   and  inwcr_deleted_ind = 1  
	   and  inwcr_dmpdpid=dpm_id
	   and  dpm_deleted_ind=1
	   and  default_dp=dpm_excsm_id
	   order by [INWARD NO]
  

--    if isnull(@l_excm_cd,'0') =  '0'
--    begin 
--
--		select inwsr_id [INWARD NO], inwsr_slip_no [SLIP NO],  TRASTM_DESC  
--	   from INWARD_SLIP_REG , transaction_type_mstr , transaction_sub_type_mstr   
--	   where isnull(inwsr_slip_no,'') <> ''  
--	   and    trantm_id = TRASTM_TRATM_ID  
--	   and   trantm_code in  ('TRANS_TYPE_CDSL','TRANS_TYPE_NSDL')  
--	   and   TRASTM_CD = left(inwsr_trastm_cd,3)  
--	   and   INWSR_RECD_DT between @pa_from_dt and @pa_to_dt  
--	   and    not exists(select USES_SLIP_NO from used_slip where isnull(ltrim(rtrim(USES_SERIES_TYPE)),'') + convert(varchar,replace(inwsr_slip_no ,isnull(ltrim(rtrim(USES_SERIES_TYPE)),''),'')) = isnull(ltrim(rtrim(USES_SERIES_TYPE)),'') + USES_SLIP_NO and USES_TRANTM_ID = inwsr_trastm_cd and case when isnull(@l_dpm_id,0) = 0 then 0 else   USES_DPM_ID end = isnull(@l_dpm_id,0) and uses_deleted_ind = 1)  
--	   and   INWSR_TRASTM_CD like @pa_trx_cd + '%'
--	   and INWSR_DELETED_IND = 1       
--	 order by [INWARD NO]
--  
--    end 
end

GO
