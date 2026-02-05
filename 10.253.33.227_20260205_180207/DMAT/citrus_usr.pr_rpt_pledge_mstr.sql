-- Object: PROCEDURE citrus_usr.pr_rpt_pledge_mstr
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

-- pr_rpt_pledge_mstr 4,'Aug  1 2009','Oct 30 2010','','','u',1,'HO|*~|',''

CREATE procedure [citrus_usr].[pr_rpt_pledge_mstr]
(
	@pa_excsm_id numeric,
	@pa_fromdt datetime,
	@pa_todt   datetime,
	@pa_frmacct varchar(20),
	@pa_toacct  varchar(20),
	--@pa_pledge_type varchar(10),
	@pa_slipno  varchar(50),
	@pa_login_pr_entm_id numeric,                        
    @pa_login_entm_cd_chain  varchar(8000),
	@pa_output varchar(1000) output

)
as
declare @l_exch_cd varchar(10),@@dpmid int,  @@l_child_entm_id numeric
		--@l_trastm_id varchar(25)
begin 
--
	select @@dpmid = dpm_id from dp_mstr with(nolock) where default_dp = @pa_excsm_id and dpm_deleted_ind =1                      
    select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)

	CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)
	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		

	select @l_exch_cd = excsm_exch_cd from exch_seg_mstr where excsm_id = @pa_excsm_id

	if @pa_frmacct = ''
		set @pa_frmacct = '0000000000000000'
	if @pa_toacct = ''
		set @pa_toacct = '9999999999999999' 
	
	if @l_exch_cd = 'CDSL'
	begin			
  --select * from cdsl_pledge_dtls
	--
--		set @l_trastm_id = case when @pa_pledge_type = 'create'  then 'crte'  --@pa_instr_type = 'P' then '908'    						
--								when @pa_pledge_type = 'close' then 'clos'    
--								when @pa_pledge_type = 'invk' then 'invk'    
--								when @pa_pledge_type = 'cnfcreate' then 'conf'   --and @pa_instr_type = 'P' then '916'    
--								when @pa_pledge_type = 'uniclose' then 'uclos' end 

		select dpam.dpam_sba_no clientid,pldtc_slip_no slipno,pldtc_isin isin,abs(pldtc_qty) qty,pldtc_created_date,
				pldtc_agreement_no agrno,pldtc_setup_dt setupdt, pldtc_expiry_dt expdt, pldtc_pldg_dpid pldpid,
				pldtc_pldg_dpname pldpname, pldtc_pldg_clientid plclid, PLDTC_PLDG_CLIENTNAME plclnm,PLDTC_REASON reason,
				PLDTC_PSN psn,PLDTC_STATUS status,PLDTC_RMKS rmks,PLDTC_SECURITTIES sec,
				case when PLDTC_SUB_STATUS = 'R' then 'Reject'
					 when  PLDTC_SUB_STATUS = 'C' then 'Cancel' end substat
		from cdsl_pledge_dtls,dp_acct_mstr dpam,#ACLIST filter
		where pldtc_dpam_id = dpam.dpam_id 
        and filter.dpam_sba_no = dpam.dpam_sba_no
        and pldtc_slip_no like case when isnull(@pa_slipno,'') = '' then '%' else @pa_slipno end
		--and pldtc_trastm_cd = @l_trastm_id
        and pldtc_created_date >= @pa_fromdt and pldtc_created_date <= @pa_todt + ' 23:59:59'
        and dpam.dpam_sba_no between @pa_frmacct and @pa_toacct
		and pldtc_deleted_ind = 1
		order by dpam.dpam_sba_no,pldtc_slip_no,pldtc_isin

	--
	end
	else if @l_exch_cd = 'NSDL'
	begin
	--
--		set @l_trastm_id = case when @pa_pledge_type = 'create'  then '908'  --@pa_instr_type = 'P' then '908'    
--							--when @pa_pledge_type = 'create' and @pa_instr_type = 'H' then '909'    
--							when @pa_pledge_type = 'close' then '911'    
--							when @pa_pledge_type = 'invk' then '910'    
--							when @pa_pledge_type = 'cnfcreate' then '916'   --and @pa_instr_type = 'P' then '916'    
--							--when @pa_pledge_type = 'cnfcreate' and @pa_instr_type = 'H' then '917'    
--							when @pa_pledge_type = 'cnfclose' then '919'    
--							when @pa_pledge_type = 'cnfinvk' then '918'  
--							when @pa_pledge_type = 'uniclose' then '999' end 

		select dpam.dpam_sba_no clientid,dpam.dpam_sba_name clientname,pldt_slip_no slipno,pldt_isin isin,isin_name,abs(pldt_qty) qty,pldt_agreement_no agrno,
	    pldt_closure_dt,pldt_pledgee_dpid,pldt_pledgee_demat_acct_no,isnull(dpam_des.dpam_sba_name,'') pledgee_name,pldt_exec_dt,pldt_rel_dt,
			   case when PLDT_REL_RSN = '01' then 'DIRECTOR/RELATIVE QUOTA' 
					when PLDT_REL_RSN = '02' then 'EMPLOYEE QUOTA'		
					when PLDT_REL_RSN = '03' then 'PREFERENTIAL QUOTA'	
					when PLDT_REL_RSN = '04' then 'PROMOTERS QUOTA'	
					when PLDT_REL_RSN = '05' then 'UNDERWRITERS QUOTA'	
					when PLDT_REL_RSN = '06' then 'PROMOTERS PLACEMENT QUOTA'	
					when PLDT_REL_RSN = '07' then '54EA OF IT ACT 1961'	
					when PLDT_REL_RSN = '08' then '54EB OF IT ACT 1961'	
					when PLDT_REL_RSN = '99' then 'OTHERS' end relreason,
				pldt_rej_rsn rejreason,
				case when pldt_trastm_cd = '908'  then 'Pledge Created'  --@pa_instr_type = 'P' then '908'    
							--when @pa_pledge_type = 'create' and @pa_instr_type = 'H' then '909'    
							when pldt_trastm_cd = '911' then 'Pledge Closed'    
							when pldt_trastm_cd = '910' then 'Pledge Invoked'    
							when pldt_trastm_cd = '916' then 'Confirm Pledge Creation'   --and @pa_instr_type = 'P' then '916'    
							--when @pa_pledge_type = 'cnfcreate' and @pa_instr_type = 'H' then '917'    
							when pldt_trastm_cd = '919' then 'Confirm Pledge Closure'    
							when pldt_trastm_cd = '918' then 'Confirm Pledge Invoked'  
							when pldt_trastm_cd = '999' then 'Uniclose' end  status,
				pldt_seq_no ordno				
     		  ,case when pldt_instr_type = 'P' then 'Pledge'
					when pldt_instr_type = 'H' then 'Hypothecation' 
					else '' end instype	
              ,case when isnull(dpam_des.dpam_sba_name,'')='' then (select top 1 dpm_name from dp_mstr where dpm_dpid=pldt_pledgee_dpid and dpm_deleted_ind=1) else '' end [Pledgee Dp Id]
              ,valuation = isnull(convert(numeric(18,2),(select top 1 isnull(abs(pldt_qty)*CLOPM_NSDL_RT,'0') from CLOSING_LAST_NSDL where CLOPM_ISIN_CD=pldt_isin and clopm_deleted_ind=1)),'0')
,Closingqty = '0'					
		from nsdl_pledge_dtls left join dp_acct_mstr dpam_des on pldt_pledgee_demat_acct_no = dpam_des.dpam_sba_no,dp_acct_mstr dpam,#ACLIST filter,isin_mstr
		where pldt_dpam_id = dpam.dpam_id 
        and filter.dpam_sba_no = dpam.dpam_sba_no
		and isin_cd = pldt_isin
		and pldt_slip_no like case when isnull(@pa_slipno,'') = '' then '%' else @pa_slipno + '%' end
		--and pldt_trastm_cd = @l_trastm_id
        and pldt_created_date >= @pa_fromdt and pldt_created_date <= @pa_todt + ' 23:59:59'
        and dpam.dpam_sba_no between @pa_frmacct and @pa_toacct
		and pldt_deleted_ind = 1
		order by dpam.dpam_sba_no,pldt_slip_no,pldt_isin
	--
	end
--
end

GO
