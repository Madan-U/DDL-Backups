-- Object: PROCEDURE citrus_usr.pr_billing_nsdl_dp_quant29122010
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create procedure [citrus_usr].[pr_billing_nsdl_dp_quant29122010](@pa_billing_from_dt datetime,@pa_billing_to_dt datetime,@pa_dpm_id numeric,@pa_billing_status   char(1))
as
begin
--
  SET DATEFORMAT dmy
  declare @l_post_toacct numeric(10,0)
         ,@pa_excmid int
         
         
  create table #temp_bill
  (trans_dt datetime
  ,dpm_id   numeric
  ,dpam_id numeric
  ,charge_name varchar(50)
  ,charge_val  numeric(18,5)
  ,post_toacct numeric(10,0))
  
  select top 1 @pa_excmid  = excm_id from dp_mstr,exch_seg_mstr,exchange_mstr 
  where dpm_id = @pa_dpm_id 
  and   dpm_excsm_id = excsm_id 
  and   excsm_exch_cd=  excm_cd
  and dpm_deleted_ind = 1          
  and excm_deleted_ind = 1          
  and excsm_deleted_ind = 1  
  
  --logic for charging for one time charges
  
	insert into #temp_bill
	(trans_dt 
	,dpm_id  
	,dpam_id
	,charge_name 
	,charge_val
	,post_toacct)
	--SELECT trans_dt , dpm_id , cham_slab_name , sum(charge),cham_post_toacct FROM (
    select convert(datetime,accp_value,103) trans_dt
	,dpm_id
	,dpam_id
	,cham_slab_name
	,sum(cham_charge_value) * -1
	,cham_post_toacct
	from dp_mstr
	,dp_charges_mstr
	,profile_charges
	,charge_mstr
	,CHARGE_CTGRY_MAPPING
	,DP_ACCT_MSTR,account_properties 
	where dpm_id = dpc_dpm_id 
	AND   chacm_cham_id = CHAM_SLAB_NO
	AND   dpc_profile_id = proc_profile_id
	AND   proc_slab_no  = cham_slab_no 
    and   dpm_id = @pa_dpm_id 
    and   accp_clisba_id = dpam_id 
    and   accp_accpm_prop_Cd = 'BILL_START_DT'
	and   DPAM_STAM_CD not in('05','04','08','02_BILLSTOP')
	
	AND   CASE WHEN CHACM_SUBCM_CD = '0' THEN '0' ELSE DPAM_SUBCM_CD END = CHACM_SUBCM_CD
	AND   cham_charge_type = 'O'
	and   isdate(accp_value) = 1
    AND   convert(datetime,accp_value,103) >= dpc_eff_from_dt and  convert(datetime,accp_value,103) <= dpc_eff_to_dt
    AND   convert(datetime,accp_value,103) between @pa_billing_from_dt and @pa_billing_to_dt
 	and   cham_deleted_ind = 1
	and   dpc_deleted_ind = 1
	and   dpm_deleted_ind = 1
	and   proc_deleted_ind = 1
    and   CHAM_CHARGE_BASE = 'NORMAL'
	group by dpm_id , dpam_id,cham_slab_name , cham_post_toacct,CHACM_SUBCM_CD,accp_value
	--) A
    --GROUP BY trans_dt , dpm_id , cham_slab_name , cham_post_toacct
  
  
  --logic for charging for one time charges
  
  
  --logic for charging for fix charges
  
	insert into #temp_bill
	(trans_dt 
	,dpm_id  
	,dpam_id
	,charge_name 
	,charge_val
	,post_toacct)
	--SELECT trans_dt , dpm_id , cham_slab_name , sum(charge),cham_post_toacct FROM (
	select citrus_usr.getfixedchargedate(convert(varchar(11),accp_value,103),@pa_billing_from_dt,@pa_billing_to_dt,cham_bill_period,cham_bill_interval,@pa_excmid) trans_dt
	,dpm_id
	,dpam_id
	,cham_slab_name
	,sum(cham_charge_value) * -1
	,cham_post_toacct
	from dp_mstr
	,dp_charges_mstr
	,profile_charges
	,charge_mstr
	,CHARGE_CTGRY_MAPPING
	,DP_ACCT_MSTR,account_properties 
	where dpm_id = @pa_dpm_id 
	AND   dpm_id = dpc_dpm_id 
    AND   chacm_cham_id = CHAM_SLAB_NO
	AND   DPC_PROFILE_ID = proc_profile_id
	AND   proc_slab_no  = cham_slab_no
    and   accp_clisba_id = dpam_id 
    and   accp_accpm_prop_Cd = 'BILL_START_DT'
	and   DPAM_STAM_CD not in('05','04','08','02_BILLSTOP')

	AND   CASE WHEN CHACM_SUBCM_CD = 0 THEN 0 ELSE DPAM_SUBCM_CD END = CHACM_SUBCM_CD
	AND   cham_charge_type = 'F'
	and   isdate(accp_value) = 1
	AND   citrus_usr.getfixedchargedate(convert(varchar(11),accp_value,103),@pa_billing_from_dt,@pa_billing_to_dt,cham_bill_period,cham_bill_interval,@pa_excmid)  between DPC_EFF_FROM_DT and DPC_EFF_TO_DT
	--AND   citrus_usr.getfixedchargedate(convert(varchar(11),accp_value,103),@pa_billing_from_dt,@pa_billing_to_dt,cham_bill_period,cham_bill_interval,@pa_excmid)  between @pa_billing_from_dt and @pa_billing_to_dt
	AND   citrus_usr.getfixedchargedate(convert(varchar(11),accp_value,103),@pa_billing_from_dt,@pa_billing_to_dt,cham_bill_period,cham_bill_interval,@pa_excmid) is not null
	and   cham_deleted_ind = 1
	and   dpc_deleted_ind = 1
	and   dpm_deleted_ind = 1
	and   proc_deleted_ind = 1
    and   CHAM_CHARGE_BASE = 'NORMAL'
	group by dpm_id ,dpam_id, cham_slab_name , cham_post_toacct,CHACM_SUBCM_CD,CHAM_BILL_PERIOD,CHAM_BILL_INTERVAL,accp_value
	--)A
	--	GROUP BY trans_dt , dpm_id , cham_slab_name , cham_post_toacct
  
  --logic for charging for fix charges
  
  
  --logic for account closure charge
  
	insert into #temp_bill
	(trans_dt 
	,dpm_id  
	,dpam_id
	,charge_name 
	,charge_val
	,post_toacct)
	SELECT trans_dt , clsr_dpm_id ,CLSR_DPAM_ID, cham_slab_name , sum(charge),cham_post_toacct FROM (select clsr_date  trans_dt
	,clsr_dpm_id  
	,CLSR_DPAM_ID
	,cham_slab_name  
	, -1 * sum(cham_charge_value )  * (SELECT COUNT(DISTINCT DPAM_SBA_NO) FROM DP_ACCT_MSTR WHERE DPAM_SUBCM_CD = CHACM_SUBCM_CD) charge
	,cham_post_toacct
    FROM CLOSURE_ACCT_MSTR cam
	,dp_charges_mstr  
	,profile_charges  
	,charge_mstr  
	,CHARGE_CTGRY_MAPPING
	where clsr_dpm_id   = @pa_dpm_id   
	AND   clsr_dpm_id   = dpc_dpm_id 
	AND   chacm_cham_id = CHAM_SLAB_NO
    AND   DPC_PROFILE_ID = proc_profile_id  
	AND   proc_slab_no  = cham_slab_no  
	and   clsr_date between @pa_billing_from_dt and @pa_billing_to_dt 
	and   clsr_status = '3' 
	AND   clsr_date >= dpc_eff_from_dt and  clsr_date <= dpc_eff_to_dt  
	
	AND   cham_charge_type = 'A'  
	and   cham_deleted_ind = 1  
	and   dpc_deleted_ind = 1  
	and   clsr_deleted_ind = 1 
	and   proc_deleted_ind = 1  
    and   CHAM_CHARGE_BASE = 'NORMAL'
	group by clsr_dpm_id ,CLSR_DPAM_ID, clsr_date, cham_slab_name  , cham_post_toacct,CHACM_SUBCM_CD) a
	GROUP BY trans_dt , clsr_dpm_id,CLSR_DPAM_ID , cham_slab_name , cham_post_toacct

   
  --logic for account closure charge
  
  --logic for holding charge
	
	insert into #temp_bill
	(trans_dt 
	,dpm_id 
	,DPAM_ID 
	,charge_name 
	,charge_val
	,post_toacct)
	select @pa_billing_to_dt
	,dpdhm_dpm_id
	,DPDHM_DPAM_ID
	,cham_slab_name
	,Charge_amt=COUNT(dpdhm_isin) * cham_charge_value   * -1
	,cham_post_toacct
	from dp_hldg_mstr_nsdl
	,dp_charges_mstr  
	,profile_charges  
	,charge_mstr  
	,dp_acct_mstr  
	where DPDHM_dpm_id= @pa_dpm_id
	AND   DPDHM_HOLDING_DT = @pa_billing_to_dt
	AND   dpdhm_HOLDING_DT >= dpc_eff_from_dt and  dpdhm_HOLDING_DT <= dpc_eff_to_dt  
	AND   dpdhm_dpm_id   = dpc_dpm_id
	and   dpdhm_dpm_id = dpam_id
    AND   dpc_profile_id = proc_profile_id  
	AND   proc_slab_no  = cham_slab_no  
	and   DPAM_STAM_CD not in('05','04','08','02_BILLSTOP')
	
	AND   isnull(cham_charge_graded,0) <> 1  
	AND   cham_charge_type           = 'H'   
	and   cham_deleted_ind = 1  
	and   dpc_deleted_ind = 1  
	and   proc_deleted_ind = 1
	AND   dpdhm_DELETED_IND =1  
    and   CHAM_CHARGE_BASE = 'NORMAL'
	group by dpdhm_dpam_id,cham_slab_name,CHAM_POST_TOACCT,dpdhm_ISIN,cham_charge_value,cham_from_factor,cham_to_factor,DPDHM_DPM_ID
	having COUNT(dpdhm_isin) >= cham_from_factor  and COUNT(dpdhm_isin) <= cham_to_factor   

  --logic for holding charge
  

  
  --logic for transaction type wise charge
  /*MIN MAX CHARGES LOGIC*/
insert into #temp_bill
(trans_dt 
,dpam_id  
,charge_name 
,charge_val
,post_toacct)
SELECT DT 
,nsdhm_dpam_id  
,B.cham_slab_name  
,CASE WHEN SUM(CHARGE) >= CHAM_PER_MAX THEN CHAM_PER_MAX* -1  
      WHEN SUM(CHARGE) <= CHAM_PER_min THEN CHAM_PER_min*-1
      ELSE SUM(CHARGE)*-1 END 
,B.cham_post_toacct  
FROM (
select nsdhm_transaction_dt  DT 
,nsdhm_dpam_id  
,ABS(isnull(count(nsdhm_slip_no)*cham_charge_value ,0)) CHARGE
,CHAM_SLAB_NO SLAB
from nsdl_holding_dtls      
	,dp_charges_mstr
	,profile_charges
	,charge_mstr 
	Where nsdhm_dpm_id = @pa_dpm_id
	AND   nsdhm_dpm_id  = dpc_dpm_id
	AND   dpc_profile_id = proc_profile_id
	AND   proc_slab_no  = cham_slab_no
	AND   citrus_usr.getfixedchargedate(nsdhm_transaction_dt,@pa_billing_from_dt  ,@pa_billing_to_dt  ,cham_bill_period,cham_bill_interval,@pa_excmid) between  DATEADD(month, -3, @pa_billing_from_dt)  and @pa_billing_to_dt 
	AND   nsdhm_transaction_dt >= dpc_eff_from_dt and  nsdhm_transaction_dt <= dpc_eff_to_dt

	AND   isnull(cham_charge_graded,0) <> 1
	AND   cham_charge_baseon           = 'TQ' 
    and   isnull(CHAM_PER_MAX,'0') <> '0'
    and   isnull(CHAM_PER_min,'0') <> '0'
	AND   cham_charge_type = nsdhm_book_naar_cd
	and   cham_deleted_ind = 1
	and   dpc_deleted_ind = 1
	and   nsdhm_deleted_ind = 1
	and   proc_deleted_ind = 1
	and   CHAM_CHARGE_BASE = 'PERIODIC'
    GROUP BY nsdhm_dpam_id  ,cham_slab_name ,cham_post_toacct ,cham_charge_value,CHAM_SLAB_NO, nsdhm_transaction_dt) A, CHARGE_MSTR B  WHERE CHAM_SLAB_NO = SLAB
    GROUP BY A.DT,nsdhm_dpam_id  ,B.cham_slab_name ,B.cham_post_toacct ,B.CHAM_PER_MIN, B.CHAM_PER_MAX
 

/*MIN MAX CHARGES LOGIC*/

  ----transaction value wise charge
  ------
	update nsdl_holding_dtls
	set    nsdhm_dp_charge   =  
	
	isnull(case when cham_val_pers  = 'V' then cham_charge_value* -1
	else case when (cham_charge_value/100)*(abs(nsdhm_qty)*clopm_nsdl_rt) <= cham_charge_minval then cham_charge_minval* -1
	else (cham_charge_value/100)*(abs(nsdhm_qty)*clopm_nsdl_rt) * -1 end
	end,0)  
	
	from nsdl_holding_dtls      
	,dp_charges_mstr
	,profile_charges
	,charge_mstr 
	,closing_price_mstr_nsdl
	where nsdhm_dpm_id  = dpc_dpm_id
	AND   dpc_profile_id = proc_profile_id
	AND   proc_slab_no  = cham_slab_no
	AND   nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt
	AND   nsdhm_transaction_dt    =  clopm_dt  
	AND   nsdhm_isin       = clopm_isin_cd  
	AND   nsdhm_transaction_dt >= dpc_eff_from_dt and  nsdhm_transaction_dt <= dpc_eff_to_dt
	AND   nsdhm_dpm_id = @pa_dpm_id
	AND   isnull(cham_charge_graded,0) <> 1
	AND   cham_charge_baseon           = 'TV' 
	AND   cham_charge_type = nsdhm_book_naar_cd
	AND   (abs(nsdhm_qty)*clopm_nsdl_rt >= cham_from_factor)  and (abs(nsdhm_qty)*clopm_nsdl_rt <= cham_to_factor) 
	and   ((NSDHM_BEN_ACCT_TYPE in ('10','11','30')) or (NSDHM_BEN_ACCT_TYPE = '14' and nsdhm_book_naar_cd = '093')) 
	and   cham_deleted_ind = 1
	and   dpc_deleted_ind = 1
	and   nsdhm_deleted_ind = 1
	and   proc_deleted_ind = 1
	and   clopm_deleted_ind = 1
    and   CHAM_CHARGE_BASE = 'NORMAL'

  ----transaction value wise charge\
  
    ----transaction qty wise charge

	update nsdl_holding_dtls
	set    nsdhm_dp_charge   =  (nsdhm_dp_charge +
	isnull(cham_charge_value,0)) *  -1
	from nsdl_holding_dtls      
	,dp_charges_mstr
	,profile_charges
	,charge_mstr 
	where nsdhm_dpm_id = @pa_dpm_id
    AND   nsdhm_dpm_id  = dpc_dpm_id
	AND   dpc_profile_id = proc_profile_id
	AND   proc_slab_no  = cham_slab_no
	AND   nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt
	AND   nsdhm_transaction_dt >= dpc_eff_from_dt and  nsdhm_transaction_dt <= dpc_eff_to_dt
	
	AND   isnull(cham_charge_graded,0) <> 1
	AND   cham_charge_baseon           = 'TQ' 
	AND   cham_charge_type = nsdhm_book_naar_cd
	AND   (abs(nsdhm_qty) >= cham_from_factor)  and (abs(nsdhm_qty) <= cham_to_factor)  
	and   ((NSDHM_BEN_ACCT_TYPE in ('10','11','30')) or (NSDHM_BEN_ACCT_TYPE = '14' and nsdhm_book_naar_cd = '093')) 
	and   cham_deleted_ind = 1
	and   dpc_deleted_ind = 1
	and   nsdhm_deleted_ind = 1
	and   proc_deleted_ind = 1
	and   CHAM_CHARGE_BASE = 'NORMAL'
  ----transaction qtywise charge
  ----transaction instruction wise charge
	
	insert into #temp_bill
	(trans_dt 
	,dpm_id  
	,DPAM_ID
	,charge_name 
	,charge_val
	,post_toacct)
	select nsdhm_transaction_dt
	,nsdhm_dpm_id
	,NSDHM_DPAM_ID
	,cham_slab_name
	,isnull(count(nsdhm_slip_no)*cham_charge_value ,0)* -1
	,cham_post_toacct
	from nsdl_holding_dtls      
	,dp_charges_mstr
	,profile_charges
	,charge_mstr 
	where nsdhm_dpm_id = @pa_dpm_id
    AND   nsdhm_dpm_id  = dpc_dpm_id
	AND   dpc_profile_id = proc_profile_id
	AND   proc_slab_no  = cham_slab_no
	AND   nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt
	AND   nsdhm_transaction_dt >= dpc_eff_from_dt and  nsdhm_transaction_dt <= dpc_eff_to_dt
	
	AND   isnull(cham_charge_graded,0) <> 1
	AND   cham_charge_baseon           = 'INST' 
	AND   cham_charge_type = nsdhm_book_naar_cd
	and   cham_deleted_ind = 1
	and   dpc_deleted_ind = 1
	and   nsdhm_deleted_ind = 1
	and   proc_deleted_ind = 1
    and   CHAM_CHARGE_BASE = 'NORMAL'
	and   ((NSDHM_BEN_ACCT_TYPE in ('10','11','30')) or (NSDHM_BEN_ACCT_TYPE = '14' and nsdhm_book_naar_cd = '093')) 
	group by nsdhm_dpm_id,NSDHM_DPAM_ID,nsdhm_transaction_dt,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value,CHAM_POST_TOACCT
	having (count(nsdhm_slip_no) >= cham_from_factor) and (count(nsdhm_slip_no) <= cham_to_factor) 
 
  ----transaction instruction wise charge
  
  
   ----transaction per transaction no per slip no wise charge
  
	insert into #temp_bill
	(trans_dt 
	,dpm_id  
	,DPAM_ID
	,charge_name 
	,charge_val
	,post_toacct)
	select nsdhm_transaction_dt
	,nsdhm_dpm_id
	,NSDHM_DPAM_ID
	,cham_slab_name
	,isnull(case when count(NSDHM_DM_TRANS_NO)*cham_charge_value <= cham_charge_minval then cham_charge_minval* -1
	else (count(NSDHM_DM_TRANS_NO)*cham_charge_value )* -1 end    ,0)
	,cham_post_toacct 
	from nsdl_holding_dtls      
	,dp_charges_mstr
	,profile_charges
	,charge_mstr 
	where nsdhm_dpm_id = @pa_dpm_id
    AND   nsdhm_dpm_id   = dpc_dpm_id
	AND   dpc_profile_id = proc_profile_id
	AND   proc_slab_no  = cham_slab_no
	AND   nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt
	AND   nsdhm_transaction_dt >= dpc_eff_from_dt and  nsdhm_transaction_dt <= dpc_eff_to_dt
	
	AND   isnull(cham_charge_graded,0) <> 1
	AND   cham_charge_baseon           = 'TRANSPERSLIP' 
	AND   nsdhm_book_naar_cd  not in ('011','012','013','021','022','023')
	AND   cham_charge_type = nsdhm_book_naar_cd
	and   cham_deleted_ind = 1
	and   dpc_deleted_ind = 1
	and   nsdhm_deleted_ind = 1
	and   proc_deleted_ind = 1
    and   CHAM_CHARGE_BASE = 'NORMAL'
	group by nsdhm_dpm_id,NSDHM_DPAM_ID,nsdhm_transaction_dt,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value, cham_charge_minval,cham_post_toacct
	having (count(NSDHM_DM_TRANS_NO) >= cham_from_factor) and (count(NSDHM_DM_TRANS_NO) <= cham_to_factor) 
		      
		      
		      
		update nsdl_holding_dtls 
		set  nsdhm_dp_charge = isnull(nsdhm_dp_charge,0) 
		+ isnull(case when demrm_total_certificates*cham_charge_value <= cham_charge_minval then cham_charge_minval * -1 
		else (demrm_total_certificates*cham_charge_value)* -1 end    ,0)
		from nsdl_holding_dtls      
		,dp_charges_mstr
		,profile_charges
		,charge_mstr 
		,demat_request_mstr
		where nsdhm_dpm_id = @pa_dpm_id
        AND   nsdhm_dpm_id  = dpc_dpm_id
		AND   dpc_profile_id = proc_profile_id
		AND   proc_slab_no  = cham_slab_no
		AND   nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt
		AND   nsdhm_transaction_dt >= dpc_eff_from_dt and  nsdhm_transaction_dt <= dpc_eff_to_dt
		
		AND   NSDHM_DM_TRANS_NO = demrm_drf_no
		AND   isnull(cham_charge_graded,0) <> 1
		AND   cham_charge_baseon           = 'TRANSPERSLIP' 
		AND   nsdhm_book_naar_cd  in ('011','012','013')
		AND   demrm_status = 'E'
		AND   cham_charge_type = nsdhm_book_naar_cd
		AND   (demrm_total_certificates >= cham_from_factor) and (demrm_total_certificates<= cham_to_factor) 
		and   cham_deleted_ind = 1
		and   dpc_deleted_ind = 1
		and   nsdhm_deleted_ind = 1
		and   proc_deleted_ind = 1
		and   demrm_deleted_ind =1
        and   CHAM_CHARGE_BASE = 'NORMAL'
		
		/* NEW CHARGES */
		update nsdl_holding_dtls 
		set  nsdhm_dp_charge = isnull(nsdhm_dp_charge,0) +
		isnull(case when DEMRM_QTY *(CONVERT(NUMERIC(10,2),cham_charge_value)/CONVERT(NUMERIC(10,2),CHAM_CHARGE_MINVAL)) < DEMRM_TOTAL_CERTIFICATES*CHAM_PER_MIN then  DEMRM_TOTAL_CERTIFICATES*CHAM_PER_MIN * -1 
		else DEMRM_QTY *(CONVERT(NUMERIC(10,2),cham_charge_value)/CONVERT(NUMERIC(10,2),CHAM_CHARGE_MINVAL)) end    ,0)  
		from nsdl_holding_dtls      
		,dp_charges_mstr
		,profile_charges
		,charge_mstr 
		,demat_request_mstr
		where nsdhm_dpm_id = @pa_dpm_id
	    AND   nsdhm_dpm_id  = dpc_dpm_id
		AND   dpc_profile_id = proc_profile_id
		AND   proc_slab_no  = cham_slab_no
		AND   nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt
		AND   nsdhm_transaction_dt >= dpc_eff_from_dt and  nsdhm_transaction_dt <= dpc_eff_to_dt
	
		AND   NSDHM_DM_TRANS_NO = demrm_drf_no
		AND   isnull(cham_charge_graded,0) <> 1
		AND   cham_charge_baseon           = 'CQ' 
		AND   nsdhm_book_naar_cd  in ('011','012','013')
		AND   demrm_status = 'E'
		AND   cham_charge_type = nsdhm_book_naar_cd
		and   cham_deleted_ind = 1
		and   dpc_deleted_ind = 1
		and   nsdhm_deleted_ind = 1
		and   proc_deleted_ind = 1
		and   demrm_deleted_ind =1
        and   CHAM_CHARGE_BASE = 'NORMAL'
		/* NEW CHARGES */
		
		

		
		
		
		

		
	

		update nsdl_holding_dtls 
		set  nsdhm_dp_charge = isnull(nsdhm_dp_charge,0) 
		+ isnull(case when REMRM_CERTIFICATE_NO*cham_charge_value <= cham_charge_minval then cham_charge_minval * -1 
		else (REMRM_CERTIFICATE_NO*cham_charge_value)* -1 end    ,0)
		from nsdl_holding_dtls      
		,dp_charges_mstr
		,profile_charges
		,charge_mstr 
		,remat_request_mstr
		where nsdhm_dpm_id = @pa_dpm_id
	    AND   nsdhm_dpm_id  = dpc_dpm_id
		AND   dpc_profile_id = proc_profile_id
		AND   proc_slab_no  = cham_slab_no
		AND   nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt
		AND   nsdhm_transaction_dt >= dpc_eff_from_dt and  nsdhm_transaction_dt <= dpc_eff_to_dt
	
		AND   NSDHM_DM_TRANS_NO = remrm_rrf_no
		AND   isnull(cham_charge_graded,0) <> 1
		AND   cham_charge_baseon           = 'TRANSPERSLIP' 
		AND   nsdhm_book_naar_cd  in ('021','022','023')
		AND   remrm_status = 'E'
		AND   cham_charge_type = nsdhm_book_naar_cd
		AND   (REMRM_CERTIFICATE_NO >= cham_from_factor) and (REMRM_CERTIFICATE_NO <= cham_to_factor) 
		and   cham_deleted_ind = 1
		and   dpc_deleted_ind = 1
		and   nsdhm_deleted_ind = 1
		and   proc_deleted_ind = 1
		and   remrm_deleted_ind =1
        and   CHAM_CHARGE_BASE = 'NORMAL'

		update nsdl_holding_dtls 
		set  nsdhm_dp_charge = round(nsdhm_dp_charge,2) 
		where nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt
		and nsdhm_dpm_id = @pa_dpm_id and isnull(nsdhm_dp_charge,0) <> 0
								
					 
	select top 1 @l_post_toacct = cham_post_toacct 
	from  charge_mstr,profile_charges,dp_charges_mstr 
	where @pa_billing_to_dt between dpc_eff_from_dt and dpc_eff_to_dt 
	and dpc_profile_id = proc_profile_id
	and proc_slab_no  = cham_slab_no
	and cham_charge_type = '042' 
	and dpc_dpm_id = @pa_dpm_id 
	and cham_deleted_ind  = 1 	
    and   CHAM_CHARGE_BASE = 'NORMAL'				

			
	insert into #temp_bill
	(trans_dt   
	,dpm_id  
	,DPAM_ID  
	,charge_name   
	,charge_val
	,post_toacct) 
	select nsdhm_transaction_dt 
	, nsdhm_dpm_id
	,NSDHM_DPAM_ID
	, 'TRANSACTION CHARGES'
	, sum(nsdhm_dp_charge)
	, @l_post_toacct 
	from nsdl_holding_dtls     
	WHERE nsdhm_dpm_id = @pa_dpm_id  
	and   nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt
	and   nsdhm_deleted_ind =1 
    group by nsdhm_dpm_id,NSDHM_DPAM_ID,nsdhm_transaction_dt
						
						
					 
	--logic for charge on amount like service tax
	insert into #temp_bill  
	(trans_dt   
	,dpm_id  
	,DPAM_ID  
	,charge_name   
	,charge_val
	,post_toacct) 
	select trans_dt
	,dpm_id
	,DPAM_ID
	,cham_slab_name
	,Charge_amt=sum(case when cham_val_pers  = 'V' then cham_charge_value  * -1 
	else case when (cham_charge_value/100)*Abs(charge_val) <= cham_charge_minval then cham_charge_minval * -1 
	else ((cham_charge_value/100)*Abs(charge_val))* -1 end  
	end)    
	,cham_post_toacct
	from #temp_bill
	,dp_charges_mstr  
	,profile_charges  
	,charge_mstr    
	where trans_dt >= dpc_eff_from_dt and  trans_dt <= dpc_eff_to_dt  
	AND   dpm_id  = dpc_dpm_id
	AND   dpc_profile_id = proc_profile_id
	AND   proc_slab_no  = cham_slab_no  
	AND   isnull(cham_charge_graded,0) <> 1  
	AND   cham_charge_type           = 'AMT'   
	and   cham_deleted_ind = 1  
	and   dpc_deleted_ind = 1  
	and   proc_deleted_ind = 1  
    and   CHAM_CHARGE_BASE = 'NORMAL'
	and not exists(select src_chargename,on_chargename from ExcludeTransCharges E
	where src_chargename = charge_name and on_chargename = cham_slab_name and for_type = 'D' and  E.dpm_id = @pa_dpm_id)
	group by dpm_id,DPAM_ID,cham_slab_name,cham_post_toacct ,trans_dt
	--logic for charge on amount like service tax
  
	 
	delete from dp_charges_nsdl where dpch_tranc_dt between @pa_billing_from_dt and @pa_billing_to_dt and dpch_flg = 'S' and dpch_dpm_id = @pa_dpm_id
			
		 
	insert into dp_charges_nsdl(
	 dpch_tranc_dt
	,dpch_dpm_id
	,dpch_dpam_id
	,dpch_charge_name
	,dpch_charge_amt
	,dpch_post_toacct
	,dpch_flg
	,dpch_created_by
	,dpch_created_dt
	,dpch_lst_upd_by
	,dpch_lst_upd_dt
	,dpch_deleted_ind
	)
	select trans_dt
	,@pa_dpm_id 
	,dpam_id
	,charge_name
	,round(charge_val,2)
	,post_toacct
	,'S'
	,'HO'
	,getdate()
	,'HO'
	,getdate()
	,1
	from  #temp_bill      
	
	
	
	----transaction per transaction no per slip no wise charge
	
  --logic for transaction type wise charge
  
  
  
  
  
--
end

GO
