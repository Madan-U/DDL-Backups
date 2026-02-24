-- Object: PROCEDURE citrus_usr.pr_rpt_marginpledge_mstr
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------



create   procedure [citrus_usr].[pr_rpt_marginpledge_mstr]
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
	print 'cdsl'
  --select * from cdsl_pledge_dtls
	--
--		set @l_trastm_id = case when @pa_pledge_type = 'create'  then 'crte'  --@pa_instr_type = 'P' then '908'    						
--								when @pa_pledge_type = 'close' then 'clos'    
--								when @pa_pledge_type = 'invk' then 'invk'    
--								when @pa_pledge_type = 'cnfcreate' then 'conf'   --and @pa_instr_type = 'P' then '916'    
--								when @pa_pledge_type = 'uniclose' then 'uclos' end 

		select distinct dpam.dpam_sba_no clientid,pldtcM_slip_no slipno,pldtcM_isin isin,
		--abs(citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(pldtcM_setup_dt,pldtcM_ISIN,pldtcM_QTY),2,'|*~|')),
		abs(pldtcM_qty) qty,-- (CONVERT(VARCHAR,abs(pldtcM_qty)) + ' (VALUE - '+  str((abs(citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(pldtcM_setup_dt,pldtcM_ISIN,pldtcM_QTY),2,'|*~|'))),15,3)) +')'  qty,
		pldtcM_created_date,
				pldtcM_agreement_no agrno,pldtcM_setup_dt setupdt, pldtcM_expiry_dt expdt, pldtcM_pldg_dpid pldpid,
				pldtcM_pldg_dpname pldpname, pldtcM_pldg_clientid plclid, pldtcM_PLDG_CLIENTNAME plclnm,pldtcM_REASON reason,
				pldtcM_TRANS_NO psn,pldtcM_STATUS status,pldtcM_RMKS rmks,pldtcM_SECURITTIES sec,'' prf,
				case when pldtcM_SUB_STATUS = 'R' then 'Reject'
					 when  pldtcM_SUB_STATUS = 'C' then 'Cancel' end substat,pldtcM_CREATED_BY,pldtcM_UPDATED_BY,pldtcM_UPDATED_DATE
					 --,value = (abs(citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(pldtcM_setup_dt,pldtcM_ISIN,pldtcM_QTY),2,'|*~|')))
					 ,abs(citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(pldtcM_setup_dt,pldtcM_ISIN,pldtcM_QTY),2,'|*~|')) valuation
					 , case when pldtcM_trastm_cd in ( 'UCLOS','CLOS') then 'UNPLEDGE' 
					 WHEN  pldtcM_trastm_cd in ( 'CRTE') then 'PLEDGE' 
					  WHEN  pldtcM_trastm_cd in ( 'INVK') then 'INVOCATION'
					  WHEN  pldtcM_trastm_cd in ( 'CREATEMR') then 'MARGIN RE-PLEDGE' WHEN  pldtcM_trastm_cd in ( 'CRTEMP') then 'MARGIN PLEDGE' 
					   ELSE  pldtcM_trastm_cd END 
		from CDSL_MARGINPLEDGE_DTLS,dp_acct_mstr dpam,#ACLIST filter
		where pldtcM_dpam_id = dpam.dpam_id 
        and filter.dpam_sba_no = dpam.dpam_sba_no
        and pldtcM_slip_no like case when isnull(@pa_slipno,'') = '' then '%' else @pa_slipno end
		--and pldtcM_trastm_cd = @l_trastm_id
        and pldtcM_created_date >= @pa_fromdt and pldtcM_created_date <= @pa_todt + ' 23:59:59'
        and dpam.dpam_sba_no between @pa_frmacct and @pa_toacct
		and pldtcM_deleted_ind = 1
		order by dpam.dpam_sba_no,pldtcM_slip_no,pldtcM_isin

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
,Closingqty = '0',PLDT_CREATED_BY,PLDT_UPDATED_BY,pldt_created_date,PLDT_UPDATED_DATE					
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
