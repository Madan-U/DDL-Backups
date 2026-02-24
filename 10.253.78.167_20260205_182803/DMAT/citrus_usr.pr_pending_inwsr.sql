-- Object: PROCEDURE citrus_usr.pr_pending_inwsr
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

/*
--  	0	Aug  1 2009	Aug 27 2009	904_ACT	
exec pr_pending_inwsr '','Jan 01 2005','Jan 10 2011','',''  

*/ 
 
CREATE procedure [citrus_usr].[pr_pending_inwsr]
(
@pa_id numeric, 
@pa_from_dt datetime, 
@pa_to_dt datetime,
@pa_trx_cd varchar(16), 
@pa_errmsg varchar(8000) OUTPUT
)  
as  
begin  
   declare @l_excm_cd varchar(100)  
, @l_excm_id  numeric  
, @l_dpm_id   numeric 

   select @l_excm_id = dpm_excsm_id, @l_dpm_id = dpm_id  from dp_mstr where dpm_excsm_id = default_dp and dpm_deleted_ind = 1 and dpm_excsm_id = @pa_id   
  
   select @l_excm_cd = EXCSM_EXCH_CD from exch_seg_mstr where excsm_id = @l_excm_id and excsm_deleted_ind = 1  
   
    print  @l_excm_cd
   if @l_excm_cd =  'NSDL'  
   begin 

if (@pa_trx_cd='GENERAL')
BEGIN 
	   select dpm_name,INWSR_DPAM_ID,inwsr_id [INWARD NO], inwsr_slip_no [SLIP NO],'GENERAL' TRASTM_DESC , dpam_sba_name,INWSR_RECD_DT ,INWSR_EXEC_DT,INWSR_NO_OF_TRANS,INWSR_RECEIVED_MODE,isnull(inwsr_ufcharge_collected,0) inwsr_ufcharge_collected ,inwsr_PAY_MODE,inwsr_cheque_no,inwsr_clibank_accno,isnull(inwsr_clibank_name,'')  inwsr_clibank_name,dpam_sba_no,INWSR_RMKS,isnull(BANM_NAME,'') BANM_NAME ,inwsr_bankid , isnull(inwsr_bank_branch,'') inwsr_bank_branch , inwsr_cheque_dt
	   from INWARD_SLIP_REG left outer join bank_mstr on inwsr_bankid=banm_id and banm_deleted_ind=1 ,
       DP_ACCT_MSTR ,dp_mstr     
	   where   INWSR_DPAM_ID   =  DPAM_ID	   
	   and   INWSR_RECD_DT between @pa_from_dt and @pa_to_dt  
	   and    not exists(select USES_SLIP_NO from used_slip where isnull(ltrim(rtrim(USES_SERIES_TYPE)),'') + convert(varchar,replace(inwsr_slip_no ,isnull(ltrim(rtrim(USES_SERIES_TYPE)),''),'')) = isnull(ltrim(rtrim(USES_SERIES_TYPE)),'') + USES_SLIP_NO and USES_TRANTM_ID = inwsr_trastm_cd and USES_DPM_ID = @l_dpm_id and uses_deleted_ind = 1)  
	   and   INWSR_DPM_ID = @l_dpm_id     
	   and   INWSR_TRASTM_CD LIKE  @pa_trx_cd + '%'
	   and INWSR_DELETED_IND = 1  
	   and INWSR_DPM_ID=dpm_id
	   and dpm_deleted_ind=1
	   and default_dp=dpm_excsm_id
	   order by [INWARD NO]
END
ELSE
BEGIN 
	   select dpm_name,inwsr_id [INWARD NO],dpam_sba_no INWSR_DPAM_ID, inwsr_slip_no [SLIP NO],TRASTM_DESC , dpam_sba_name,INWSR_RECD_DT ,INWSR_EXEC_DT,INWSR_NO_OF_TRANS,INWSR_RECEIVED_MODE,isnull(inwsr_ufcharge_collected,0) inwsr_ufcharge_collected ,inwsr_PAY_MODE,inwsr_cheque_no,inwsr_clibank_accno,isnull(inwsr_clibank_name,'')  inwsr_clibank_name,dpam_sba_no,INWSR_RMKS,isnull(BANM_NAME,'') BANM_NAME ,inwsr_bankid , isnull(inwsr_bank_branch,'') inwsr_bank_branch , inwsr_cheque_dt
	   from INWARD_SLIP_REG left outer join bank_mstr on inwsr_bankid=banm_id and banm_deleted_ind=1 , DP_ACCT_MSTR ,transaction_type_mstr , transaction_sub_type_mstr,dp_mstr     
	   where isnull(inwsr_slip_no,'') <> '' 
	   and    INWSR_DPAM_ID   =  DPAM_ID
	   and    trantm_id = TRASTM_TRATM_ID  
	   and   trantm_code = 'TRANS_TYPE_NSDL'  
	   and   TRASTM_CD = inwsr_trastm_cd  
	   and   INWSR_RECD_DT between @pa_from_dt and @pa_to_dt  
	   and    not exists(select USES_SLIP_NO from used_slip where isnull(ltrim(rtrim(USES_SERIES_TYPE)),'') + convert(varchar,replace(inwsr_slip_no ,isnull(ltrim(rtrim(USES_SERIES_TYPE)),''),'')) = isnull(ltrim(rtrim(USES_SERIES_TYPE)),'') + USES_SLIP_NO and USES_TRANTM_ID = inwsr_trastm_cd and USES_DPM_ID = @l_dpm_id and uses_deleted_ind = 1)  
	   and   INWSR_DPM_ID = @l_dpm_id     
	   and   INWSR_TRASTM_CD LIKE  @pa_trx_cd + '%'
	   and INWSR_DELETED_IND = 1  
	   and INWSR_DPM_ID=dpm_id
	   and dpm_deleted_ind=1
	   and default_dp=dpm_excsm_id
	   order by [INWARD NO]
END

   end 
    
  
   if @l_excm_cd =  'CDSL'
   begin   

 print 'hetal'
	   select inwsr_id [INWARD NO],INWSR_DPAM_ID,dpam_sba_name, inwsr_slip_no [SLIP NO],  TRASTM_DESC , dpam_sba_name,INWSR_RECD_DT,INWSR_EXEC_DT,INWSR_NO_OF_TRANS,INWSR_RECEIVED_MODE,isnull(inwsr_ufcharge_collected,0) inwsr_ufcharge_collected,inwsr_PAY_MODE,inwsr_cheque_no,inwsr_clibank_accno,isnull(inwsr_clibank_name,'') inwsr_clibank_name,dpam_sba_no,INWSR_RMKS,isnull(BANM_NAME,'')BANM_NAME , inwsr_bankid , isnull(inwsr_bank_branch,'') inwsr_bank_branch ,inwsr_cheque_dt
	   from INWARD_SLIP_REG left outer join bank_mstr on inwsr_bankid=banm_id and banm_deleted_ind=1 , transaction_type_mstr , transaction_sub_type_mstr  , DP_ACCT_MSTR  ,dp_mstr 
	   where isnull(inwsr_slip_no,'') <> ''
	   and    INWSR_DPAM_ID   =  DPAM_ID  
	   and    trantm_id = TRASTM_TRATM_ID  
	 --  and   trantm_code = 'TRANS_TYPE_CDSL'  
       and   trantm_code in  ('TRANS_TYPE_CDSL','TRANS_TYPE_NSDL','INT_TRANS_TYPE_CDSL')  
	   and   TRASTM_CD = inwsr_trastm_cd 
       and   INWSR_RECD_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'       
	  --and   INWSR_RECD_DT between @pa_from_dt and @pa_to_dt  
	   and    not exists(select USES_SLIP_NO from used_slip where isnull(ltrim(rtrim(USES_SERIES_TYPE)),'') + convert(varchar,replace(inwsr_slip_no ,isnull(ltrim(rtrim(USES_SERIES_TYPE)),''),'')) = isnull(ltrim(rtrim(USES_SERIES_TYPE)),'') + USES_SLIP_NO and USES_TRANTM_ID = inwsr_trastm_cd and USES_DPM_ID = @l_dpm_id and uses_deleted_ind = 1)  
	   and   INWSR_DPM_ID = @l_dpm_id   
	   and   INWSR_TRASTM_CD like @pa_trx_cd + '%'
	   and INWSR_DELETED_IND = 1    
		 and INWSR_DPM_ID=dpm_id
	   and dpm_deleted_ind=1
	   and default_dp=dpm_excsm_id
	 order by [INWARD NO]

    end 

    if isnull(@l_excm_cd,'0') =  '0'
    begin 
		print 'sachin'
		select inwsr_id [INWARD NO], inwsr_slip_no [SLIP NO],  TRASTM_DESC,isnull(inwsr_ufcharge_collected,0) inwsr_ufcharge_collected  
	   from INWARD_SLIP_REG , transaction_type_mstr , transaction_sub_type_mstr   
	   where isnull(inwsr_slip_no,'') <> ''  
	   and    trantm_id = TRASTM_TRATM_ID  
	   and   trantm_code in  ('TRANS_TYPE_CDSL','TRANS_TYPE_NSDL','INT_TRANS_TYPE_CDSL')  
	  -- and   TRASTM_CD =  left(inwsr_trastm_cd,3) 
		and   TRASTM_CD =  inwsr_trastm_cd 
	   --and   INWSR_RECD_DT between @pa_from_dt and @pa_to_dt  
       and   INWSR_RECD_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'       
	   --and    not exists(select USES_SLIP_NO from used_slip where isnull(ltrim(rtrim(USES_SERIES_TYPE)),'') + convert(varchar,replace(inwsr_slip_no ,isnull(ltrim(rtrim(USES_SERIES_TYPE)),''),'')) = isnull(ltrim(rtrim(USES_SERIES_TYPE)),'') + USES_SLIP_NO and USES_TRANTM_ID = inwsr_trastm_cd and case when isnull(@l_dpm_id,0) = 0 then 0 else   USES_DPM_ID end = isnull(@l_dpm_id,0) and uses_deleted_ind = 1)  
	   and   INWSR_TRASTM_CD like @pa_trx_cd + '%'
	   and INWSR_DELETED_IND = 1       
	 order by [INWARD NO]
  
    end 
end

GO
