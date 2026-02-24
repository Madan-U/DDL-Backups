-- Object: PROCEDURE citrus_usr.pr_billing_cdsl_dp
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--[pr_billing_cdsl_dp] 'jan  1  2005','jan 10 2009',54723,'Y'
CREATE procedure [citrus_usr].[pr_billing_cdsl_dp](@pa_billing_from_dt datetime,@pa_billing_to_dt datetime,@pa_dpm_id numeric,@pa_billing_status   char(1))
as
begin
--
  SET DATEFORMAT dmy
  declare @l_post_toacct numeric(10,0)
         ,@pa_excmid int
         ,@l_bill_date datetime
         
  create table #temp_bill
  (trans_dt datetime
  ,dpm_id   numeric
  ,dpam_id  numeric
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


select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
into #account_properties from account_properties 
where accp_accpm_prop_cd = 'BILL_START_DT' 
and accp_value not in ('')

select distinct convert(datetime,accp_value,103) accp_value_cl
, accp_clisba_id accp_clisba_id_cl , accp_accpm_prop_cd accp_accpm_prop_cd_cl 
into #account_properties_close from account_properties 
where accp_accpm_prop_cd = 'ACC_CLOSE_DT' 
and accp_value not in ('','//') 

create index ix_1 on #account_properties(accp_clisba_id , accp_value )
create index ix_2 on #account_properties_close(accp_clisba_id_cl , accp_value_cl )

create index ix_1 on #account_properties(accp_clisba_id , accp_value )
create index ix_2 on #account_properties_close(accp_clisba_id_cl , accp_value_cl )


  --logic for charging for one time charges
  
  insert into #temp_bill
  (trans_dt 
  ,dpm_id 
  ,dpam_id 
  ,charge_name 
  ,charge_val
  ,post_toacct)
  select accp_value  trasc_dt
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
      ,DP_ACCT_MSTR, #account_properties left outer join #account_properties_close on accp_clisba_id = accp_clisba_id_cl
  where dpm_id = @pa_dpm_id 
and  accp_clisba_id = dpam_id  
  and   ( DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI') or @pa_billing_to_dt between  accp_value and isnull(accp_value_cl,'jan 31 2100'))
  AND   dpm_id = dpc_dpm_id 
  AND   chacm_cham_id = CHAM_SLAB_NO
  AND   CASE WHEN CHACM_SUBCM_CD = '0' THEN '0' ELSE DPAM_SUBCM_CD end = CHACM_SUBCM_CD
  and   isdate(citrus_usr.fn_acct_entp(dpam_id,'BILL_START_DT')) = 1
  AND   convert(datetime,accp_value,103) >= dpc_eff_from_dt 
  and  convert(datetime,accp_value,103) <= dpc_eff_to_dt
  AND   dpc_profile_id = proc_profile_id
  AND   proc_slab_no  = cham_slab_no
  AND   convert(datetime,accp_value,103) between @pa_billing_from_dt and @pa_billing_to_dt
  AND   cham_charge_type = 'O'
  and   cham_deleted_ind = 1
  and   dpm_deleted_ind = 1
  and   proc_deleted_ind = 1
  and   CHAM_CHARGE_BASE = 'NORMAL'
  group by accp_value,dpm_id , dpam_id,cham_slab_name , cham_post_toacct, CHACM_SUBCM_CD

  --logic for charging for one time charges
   
  
  --logic for charging for fix charges
  
--		insert into #temp_bill
--		(trans_dt 
--		,dpm_id  
--		,dpam_id
--		,charge_name 
--		,charge_val
--		,post_toacct)
--  		select citrus_usr.getfixedchargedate(convert(varchar(11),accp_value,103),@pa_billing_from_dt,@pa_billing_to_dt,cham_bill_period,cham_bill_interval,@pa_excmid) tranc_dt
--		,dpm_id
--		,dpam_id
--		,cham_slab_name
--		,sum(cham_charge_value) * -1
--		,cham_post_toacct
--		from dp_mstr
--       ,dp_charges_mstr
--       ,profile_charges
--       ,charge_mstr
--        ,CHARGE_CTGRY_MAPPING
--        ,DP_ACCT_MSTR, #account_properties left outer join #account_properties_close on accp_clisba_id = accp_clisba_id_cl
--		where dpm_id = @pa_dpm_id 
--and  accp_clisba_id = dpam_id  
--  and   ( DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI') or @pa_billing_to_dt between  accp_value and isnull(accp_value_cl,'jan 31 2100'))
-- 	    AND   dpm_id = dpc_dpm_id 
--	    AND   chacm_cham_id = CHAM_SLAB_NO
--	    AND   CASE WHEN CHACM_SUBCM_CD = '0' THEN '0' ELSE DPAM_SUBCM_CD end  = CHACM_SUBCM_CD
--		AND   DPC_PROFILE_ID = proc_profile_id
--		AND   proc_slab_no  = cham_slab_no
--		AND   cham_charge_type = 'F'
--		and   cham_deleted_ind = 1
--		and   dpm_deleted_ind = 1
--		and   proc_deleted_ind = 1
--		
--        and   CHAM_CHARGE_BASE = 'NORMAL'
--		AND   citrus_usr.getfixedchargedate(convert(varchar(11),accp_value,103),@pa_billing_from_dt,@pa_billing_to_dt,cham_bill_period,cham_bill_interval,@pa_excmid)  between DPC_EFF_FROM_DT and DPC_EFF_TO_DT
--		--AND   citrus_usr.getfixedchargedate(convert(varchar(11),citrus_usr.fn_acct_entp(dpam_id,'BILL_START_DT'),103),@pa_billing_from_dt,@pa_billing_to_dt,cham_bill_period,cham_bill_interval,@pa_excmid)  between @pa_billing_from_dt and @pa_billing_to_dt
--		AND   citrus_usr.getfixedchargedate(convert(varchar(11),accp_value,103),@pa_billing_from_dt,@pa_billing_to_dt,cham_bill_period,cham_bill_interval,@pa_excmid) is not null
--		group by accp_value,dpm_id ,dpam_id, cham_slab_name , cham_post_toacct,CHACM_SUBCM_CD,CHAM_BILL_PERIOD,CHAM_BILL_INTERVAL
--  
  --logic for charging for fix charges
  
  
 
  
  --logic for holding charge
  
--    insert into #temp_bill
--	(trans_dt 
--	,dpm_id  
--	 ,dpam_id 
--	,charge_name 
--	,charge_val
--	,post_toacct)
--	select @pa_billing_to_dt
--	,dphmc_dpm_id
--	,DPHMC_DPAM_ID
--	,cham_slab_name
--	,Charge_amt=(COUNT(dphmc_isin) * cham_charge_value   )* -1
--	,cham_post_toacct
--	from dp_hldg_mstr_cdsl
--	 ,dp_charges_mstr  
--	,profile_charges  
--	,charge_mstr    
--	,dp_acct_mstr
--	where DPHMC_dpm_id= @pa_dpm_id
--	AND   DPHMC_HOLDING_DT = @pa_billing_to_dt
--	AND   DPHMC_HOLDING_DT >= DPC_EFF_FROM_DT and  DPHMC_HOLDING_DT <= DPC_EFF_TO_DT  
--	AND   DPHMC_dpm_id   = dpc_dpm_id
--	and   dphmc_dpam_id = dpam_id
--	and   DPAM_STAM_CD not in('05','04','08','02_BILLSTOP')
--	AND   dpc_profile_id = proc_profile_id  
--	AND   proc_slab_no  = cham_slab_no  
--	AND   isnull(cham_charge_graded,0) <> 1  
--	AND   cham_charge_type           = 'H'   
--	and   cham_deleted_ind = 1  
--	and   dpc_deleted_ind = 1  
--	and   proc_deleted_ind = 1
--	AND    DPHMC_DELETED_IND =1  
--    and   CHAM_CHARGE_BASE = 'NORMAL'
--    group by dphmc_dpm_id,DPHMC_DPAM_ID,cham_slab_name,CHAM_POST_TOACCT,DPHMC_ISIN,cham_charge_value,cham_from_factor,cham_to_factor
--    having COUNT(dphmc_isin) >= cham_from_factor  and COUNT(dphmc_isin) <= cham_to_factor   
--     
  --logic for holding charge
  
 /*MIN MAX CHARGES LOGIC*/
insert into #temp_bill
(trans_dt 
,dpam_id  
,charge_name 
,charge_val
,post_toacct)
SELECT CDSHM_TRAS_DT  
,CDSHM_DPAM_ID  
,B.cham_slab_name  
,CASE WHEN SUM(CHARGE) >= CHAM_PER_MAX THEN CHAM_PER_MAX* -1  
       WHEN SUM(CHARGE) <= CHAM_PER_min THEN CHAM_PER_min*-1
      ELSE SUM(CHARGE)*-1 END 
,B.cham_post_toacct 
FROM (
select cdshm_tras_dt  CDSHM_TRAS_DT 
,CDSHM_DPAM_ID  
,ABS(isnull(cham_charge_value ,0)) CHARGE
,CHAM_SLAB_NO SLAB
From cdsl_holding_dtls      
	,dp_charges_mstr
	,profile_charges
	,charge_mstr 
where cdshm_dpm_id = @pa_dpm_id
AND   citrus_usr.getfixedchargedate(CDSHM_TRAS_DT,@pa_billing_from_dt  ,@pa_billing_to_dt  ,cham_bill_period,cham_bill_interval,@pa_excmid)  between  DATEADD(month, cham_bill_interval*-1, @pa_billing_from_dt)  and @pa_billing_to_dt 
AND   cdshm_tras_dt >= dpc_eff_from_dt and  cdshm_tras_dt <= dpc_eff_to_dt
AND   cdshm_dpm_id  = dpc_dpm_id
AND   dpc_profile_id = proc_profile_id
AND   proc_slab_no  = cham_slab_no
AND   isnull(cham_charge_graded,0) <> 1
AND   cham_charge_baseon           = 'TQ' 
AND   cham_charge_type = cdshm_tratm_type_desc
AND   (abs(cdshm_qty) >= cham_from_factor)  and (abs(cdshm_qty) <= cham_to_factor)  
AND   cdshm_tratm_cd in ('2277')
and   cham_deleted_ind = 1
and   cdshm_deleted_ind = 1
and   proc_deleted_ind = 1
	and   CHAM_CHARGE_BASE = 'PERIODIC' ) A , CHARGE_MSTR B WHERE CHAM_SLAB_NO = SLAB
GROUP BY CDSHM_DPAM_ID,CDSHM_TRAS_DT
,B.cham_slab_name, B.cham_from_factor
,B.cham_to_factor,cham_charge_value 
,B.cham_post_toacct ,B.CHAM_PER_MIN, B.CHAM_PER_MAX,CDSHM_DPAM_ID
,B.cham_bill_period,B.cham_bill_interval 
/*MIN MAX CHARGES LOGIC*/

  
  	
  --logic for transaction type wise charge
  
  ----transaction value wise charge

			update cdsl_holding_dtls
			set    cdshm_dp_charge   =  
			isnull(case when cham_val_pers  = 'V' then cham_charge_value * -1
			else case when (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt) <= cham_charge_minval then cham_charge_minval* -1
			else (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt) * -1 end
			end,0)  
			from cdsl_holding_dtls      
			,dp_charges_mstr
			,profile_charges
			,charge_mstr 
			,closing_price_mstr_cdsl
			where 
           --- cdshm_dpm_id = @pa_dpm_id and
			cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
			and   clopm_dt      = cdshm_tras_dt 
			AND   cdshm_tras_dt >= dpc_eff_from_dt and  cdshm_tras_dt <= dpc_eff_to_dt
			AND   cdshm_dpm_id  = dpc_dpm_id
			AND   dpc_profile_id = proc_profile_id
			AND   proc_slab_no  = cham_slab_no
			AND   isnull(cham_charge_graded,0) <> 1
			AND   cham_charge_baseon           = 'TV' 
			AND   cham_charge_type = cdshm_tratm_type_desc
			AND   cdshm_isin       = clopm_isin_cd  
			AND   (abs(cdshm_qty)*clopm_cdsl_rt >= cham_from_factor)  and (abs(cdshm_qty)*clopm_cdsl_rt <= cham_to_factor)  
			AND   cdshm_tratm_cd in ('2246','2277')
			and   cham_deleted_ind = 1
			and   dpc_deleted_ind = 1
			and   cdshm_deleted_ind = 1
			and   proc_deleted_ind = 1
            and   CHAM_CHARGE_BASE = 'NORMAL'
			and   clopm_deleted_ind = 1
 	
  ------
			update cdsl_holding_dtls
			set    cdshm_dp_charge   =  cdshm_dp_charge +
			isnull(case when cham_val_pers  = 'V' then cham_charge_value* -1 
			else case when (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt) <= cham_charge_minval then cham_charge_minval* -1 
			else (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt)*-1 end
			end  ,0)
			from cdsl_holding_dtls      
			,dp_charges_mstr
			,profile_charges
			,charge_mstr 
			,closing_price_mstr_cdsl
			where cdshm_dpm_id = @pa_dpm_id
			AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
			and   clopm_dt      = cdshm_tras_dt 
			AND   cdshm_tras_dt >= dpc_eff_from_dt and  cdshm_tras_dt <= dpc_eff_to_dt
			AND   cdshm_dpm_id  = dpc_dpm_id
			AND   dpc_profile_id = proc_profile_id
			AND   proc_slab_no  = cham_slab_no
			AND   isnull(cham_charge_graded,0) <> 1
			AND   cham_charge_baseon           = 'TV' 
			AND   cham_charge_type = 'EXCH_PAYIN'
			AND   cdshm_tratm_type_desc in ('NSCCL-DR','CSECH-DR','BSECH-DR','ASECH-DR','OTCEI-DR','DSECH-DR')
			AND   cdshm_isin       = clopm_isin_cd  
			AND   (abs(cdshm_qty)*clopm_cdsl_rt >= cham_from_factor)  and (abs(cdshm_qty)*clopm_cdsl_rt <= cham_to_factor)  
			AND   cdshm_tratm_cd = '2277'
			and   cham_deleted_ind = 1
			and   dpc_deleted_ind = 1
			and   cdshm_deleted_ind = 1
			and   proc_deleted_ind = 1
			and   clopm_deleted_ind = 1
            and   CHAM_CHARGE_BASE = 'NORMAL'
		------
 
			update cdsl_holding_dtls
			set    cdshm_dp_charge   =  cdshm_dp_charge +
			isnull(case when cham_val_pers  = 'V' then cham_charge_value*-1 
			else case when (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt) <= cham_charge_minval then cham_charge_minval*-1
			else (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt)*-1 end
			end    ,0)
			from cdsl_holding_dtls      
			,dp_charges_mstr
			,profile_charges
			,charge_mstr 
			,closing_price_mstr_cdsl
			where cdshm_dpm_id = @pa_dpm_id
			AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
			and   clopm_dt      = cdshm_tras_dt 
			AND   cdshm_tras_dt >= dpc_eff_from_dt and  cdshm_tras_dt <= dpc_eff_to_dt
			AND   cdshm_dpm_id  = dpc_dpm_id
			AND   dpc_profile_id = proc_profile_id
			AND   proc_slab_no  = cham_slab_no
			AND   isnull(cham_charge_graded,0) <> 1
			AND   cham_charge_baseon           = 'TV' 
			AND   cham_charge_type = 'EXCH_PAYOUT'
			AND   cdshm_tratm_type_desc in ('NSCCL-CR','CSECH-CR','BSECH-CR','ASECH-CR','OTCEI-CR','DSECH-CR')
			AND   cdshm_isin       = clopm_isin_cd 
			AND   (abs(cdshm_qty)*clopm_cdsl_rt >= cham_from_factor)  and (abs(cdshm_qty)*clopm_cdsl_rt <= cham_to_factor)  
			AND   cdshm_tratm_cd ='2246'
			and   cham_deleted_ind = 1
			and   dpc_deleted_ind = 1
			and   cdshm_deleted_ind = 1
			and   proc_deleted_ind = 1
			and   clopm_deleted_ind = 1
            and   CHAM_CHARGE_BASE = 'NORMAL'
			      
		------
  ----transaction value wise charge\
  
  
  ----transaction qty wise charge
  
			update cdsl_holding_dtls
			set    cdshm_dp_charge   =  cdshm_dp_charge +
			isnull(cham_charge_value,0)*-1 
			from cdsl_holding_dtls      
			,dp_charges_mstr
			,profile_charges
			,charge_mstr 
			where cdshm_dpm_id = @pa_dpm_id
			AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
			AND   cdshm_tras_dt >= dpc_eff_from_dt and  cdshm_tras_dt <= dpc_eff_to_dt
			AND   cdshm_dpm_id  = dpc_dpm_id
			AND   dpc_profile_id = proc_profile_id
			AND   proc_slab_no  = cham_slab_no
			AND   isnull(cham_charge_graded,0) <> 1
			AND   cham_charge_baseon           = 'TQ' 
			AND   cham_charge_type = cdshm_tratm_type_desc
			AND   (abs(cdshm_qty) >= cham_from_factor)  and (abs(cdshm_qty) <= cham_to_factor)  
			AND   cham_charge_type <> 'DEMAT'
			AND   cdshm_tratm_cd ='2277'
			and   cham_deleted_ind = 1
			and   dpc_deleted_ind = 1
			and   cdshm_deleted_ind = 1
			and   proc_deleted_ind = 1
            and   CHAM_CHARGE_BASE = 'NORMAL'


			update cdsl_holding_dtls
			set    cdshm_dp_charge   =  cdshm_dp_charge +
			isnull(cham_charge_value,0)*-1 
			from cdsl_holding_dtls      
			,dp_charges_mstr
			,profile_charges
			,charge_mstr 
			where cdshm_dpm_id = @pa_dpm_id
			AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
			AND   cdshm_tras_dt >= dpc_eff_from_dt and  cdshm_tras_dt <= dpc_eff_to_dt
			AND   cdshm_dpm_id  = dpc_dpm_id
			AND   dpc_profile_id = proc_profile_id
			AND   proc_slab_no  = cham_slab_no
			AND   isnull(cham_charge_graded,0) <> 1
			AND   cham_charge_baseon           = 'TQ' 
			AND   cham_charge_type = cdshm_tratm_type_desc
			AND   (abs(cdshm_qty) >= cham_from_factor)  and (abs(cdshm_qty) <= cham_to_factor)  
			AND   cham_charge_type = 'DEMAT'
			AND   cdshm_tratm_cd = '2246'
			and   cham_deleted_ind = 1
			and   dpc_deleted_ind = 1
			and   cdshm_deleted_ind = 1
			and   proc_deleted_ind = 1
            and   CHAM_CHARGE_BASE = 'NORMAL'



					 
					 
			update cdsl_holding_dtls
			set    cdshm_dp_charge   =  cdshm_dp_charge +
			isnull(cham_charge_value,0)* -1
			from cdsl_holding_dtls      
			,dp_charges_mstr
			,profile_charges
			,charge_mstr 
			where cdshm_dpm_id = @pa_dpm_id
			AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
			AND   cdshm_tras_dt >= dpc_eff_from_dt and  cdshm_tras_dt <= dpc_eff_to_dt
			AND   cdshm_dpm_id  = dpc_dpm_id
			AND   dpc_profile_id = proc_profile_id
			AND   proc_slab_no  = cham_slab_no
			AND   isnull(cham_charge_graded,0) <> 1
			AND   cham_charge_baseon           = 'TQ' 
			AND   cham_charge_type = 'EXCH_PAYIN'
			AND   cdshm_tratm_type_desc in ('NSCCL-DR','CSECH-DR','BSECH-DR','ASECH-DR','OTCEI-DR','DSECH-DR')
			AND   (abs(cdshm_qty) >= cham_from_factor)  and (abs(cdshm_qty) <= cham_to_factor)  
			AND   cdshm_tratm_cd = '2277'
			and   cham_deleted_ind = 1
			and   dpc_deleted_ind = 1
			and   cdshm_deleted_ind = 1
			and   proc_deleted_ind = 1
            and   CHAM_CHARGE_BASE = 'NORMAL'
							

					 
			update cdsl_holding_dtls
			set    cdshm_dp_charge   =  cdshm_dp_charge +
			isnull(cham_charge_value,0)*-1
			from cdsl_holding_dtls      
			,dp_charges_mstr
			,profile_charges
			,charge_mstr 
			where cdshm_dpm_id = @pa_dpm_id
			AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
			AND   cdshm_tras_dt >= dpc_eff_from_dt and  cdshm_tras_dt <= dpc_eff_to_dt
			AND   cdshm_dpm_id  = dpc_dpm_id
			AND   dpc_profile_id = proc_profile_id
			AND   proc_slab_no  = cham_slab_no
			AND   isnull(cham_charge_graded,0) <> 1
			AND   cham_charge_baseon           = 'TQ' 
			AND   cham_charge_type = 'EXCH_PAYOUT'
			AND   cdshm_tratm_type_desc in ('NSCCL-CR','CSECH-CR','BSECH-CR','ASECH-CR','OTCEI-CR','DSECH-CR')
			AND   (abs(cdshm_qty) >= cham_from_factor)  and (abs(cdshm_qty) <= cham_to_factor)  
			AND   cdshm_tratm_cd = '2246'
			and   cham_deleted_ind = 1
			and   dpc_deleted_ind = 1
			and   cdshm_deleted_ind = 1
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
			select cdshm_tras_dt
			,cdshm_dpm_id
			,CDSHM_DPAM_ID
			,cham_slab_name
			,isnull(count(cdshm_slip_no)*cham_charge_value ,0)*-1
			,cham_post_toacct
			from cdsl_holding_dtls      
			,dp_charges_mstr
			,profile_charges
			,charge_mstr 
			where cdshm_dpm_id = @pa_dpm_id
			AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
			AND   cdshm_tras_dt >= DPC_EFF_FROM_DT and  cdshm_tras_dt <= DPC_EFF_TO_DT
			AND   cdshm_dpm_id  = dpc_dpm_id
			AND   dpc_profile_id = proc_profile_id
			AND   proc_slab_no  = cham_slab_no
			AND   isnull(cham_charge_graded,0) <> 1
			AND   cham_charge_baseon           = 'INST' 
			AND   cham_charge_type = cdshm_tratm_type_desc
			AND   cdshm_tratm_cd in ('2246','2277')
			and   cham_deleted_ind = 1
			and   dpc_deleted_ind = 1
			and   cdshm_deleted_ind = 1
			and   proc_deleted_ind = 1
            and   CHAM_CHARGE_BASE = 'NORMAL'
			group by cdshm_dpm_id,CDSHM_DPAM_ID,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value,cdshm_tras_dt,cham_post_toacct
			having (count(cdshm_slip_no) >= cham_from_factor) and (count(cdshm_slip_no) <= cham_to_factor) 
					 
  
			insert into #temp_bill
			(trans_dt 
			,dpm_id 
			,dpaM_ID 
			,charge_name 
			,charge_val
			,post_toacct)
			select cdshm_tras_dt
			,cdshm_dpm_id
			,CDSHM_DPAM_ID
			,cham_slab_name
			,isnull(count(cdshm_slip_no)*cham_charge_value ,0)*-1
			,cham_post_toacct
			from cdsl_holding_dtls      
			,dp_charges_mstr
			,profile_charges
			,charge_mstr 
			where cdshm_dpm_id = @pa_dpm_id
			AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
			AND   cdshm_tras_dt >= DPC_EFF_from_DT and  cdshm_tras_dt <= DPC_EFF_TO_DT
			AND   cdshm_dpm_id  = dpc_dpm_id
			AND   dpc_profile_id = proc_profile_id
			AND   proc_slab_no  = cham_slab_no
			AND   isnull(cham_charge_graded,0) <> 1
			AND   cham_charge_baseon           = 'INST' 
			AND   cham_charge_type = 'EXCH_PAYIN'
			AND   cdshm_tratm_type_desc in ('NSCCL-DR','CSECH-DR','BSECH-DR','ASECH-DR','OTCEI-DR','DSECH-DR')
			AND   cdshm_tratm_cd = '2277'
			and   cham_deleted_ind = 1
			and   dpc_deleted_ind = 1
			and   cdshm_deleted_ind = 1
			and   proc_deleted_ind = 1
            and   CHAM_CHARGE_BASE = 'NORMAL'
			group by cdshm_dpm_id,CDSHM_DPAM_ID,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value,cdshm_tras_dt,cham_post_toacct
			having (count(cdshm_slip_no) >= cham_from_factor) and (count(cdshm_slip_no) <= cham_to_factor) 

					 
				
			insert into #temp_bill
			(trans_dt 
			,dpm_id  
			,DPAM_ID
			,charge_name 
			,charge_val
			,post_toacct)
			select cdshm_tras_dt
			,cdshm_dpm_id
			,CDSHM_DPAM_ID
			,cham_slab_name
			,isnull(count(cdshm_slip_no)*cham_charge_value ,0)*-1
			,cham_post_toacct
			from cdsl_holding_dtls      
			,dp_charges_mstr
			,profile_charges
			,charge_mstr 
			where cdshm_dpm_id = @pa_dpm_id
			AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
			AND   cdshm_tras_dt >= DPC_EFF_from_DT and  cdshm_tras_dt <= DPC_EFF_TO_DT
			AND   cdshm_dpm_id  = dpc_dpm_id
			AND   dpc_profile_id = proc_profile_id
			AND   proc_slab_no  = cham_slab_no
			AND   isnull(cham_charge_graded,0) <> 1
			AND   cham_charge_baseon           = 'INST' 
			AND   cham_charge_type = 'EXCH_PAYOUT'
			AND   cdshm_tratm_type_desc in ('NSCCL-CR','CSECH-CR','BSECH-CR','ASECH-CR','OTCEI-CR','DSECH-CR')
			AND   cdshm_tratm_cd = '2246'
			and   cham_deleted_ind = 1
			and   dpc_deleted_ind = 1
			and   cdshm_deleted_ind = 1
			and   proc_deleted_ind = 1
            and   CHAM_CHARGE_BASE = 'NORMAL'
			group by cdshm_dpm_id,CDSHM_DPAM_ID,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value,cdshm_tras_dt,cham_post_toacct
			having (count(cdshm_slip_no) >= cham_from_factor) and (count(cdshm_slip_no) <= cham_to_factor) 
  
  ----transaction instruction wise charge
  
  ----transaction per transaction no wise charge
      
    /*  update cdsl_holding_dtls
				        set    cdshm_dp_charge   =  cdshm_dp_charge +
				       insert into #temp_bill
												(trans_dt 
												,dpam_id  
												,charge_name 
				        ,charge_val
				        ,post_toacct)
				        select @pa_billing_date
											 ,cdshm_dpam_id
							 ,cham_slab_name
					 isnull(count(cdshm_trans_no)*cham_charge_value ,0)
				
						from cdsl_holding_dtls      
										,dp_charges_mstr
										,profile_charges
										,charge_mstr 
						where cdshm_dpm_id = @pa_dpm_id
								AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
			   AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
						AND   cdshm_dpm_id  = dpc_dpm_id
			   AND   dpc_profile_id = proc_profile_id
						AND   proc_slab_no  = cham_slab_no
						AND   isnull(cham_charge_graded,0) <> 1
						AND   cham_charge_baseon           = 'TRANSNO' 
						AND   cham_charge_type = cdshm_tratm_type_desc
						AND   cdshm_tratm_cd in ('2246','2277')
						AND   cham_charge_type = cdshm_tratm_type_desc
						and   cham_deleted_ind = 1
						and   dpc_deleted_ind = 1
						and   cdshm_deleted_ind = 1
						and   proc_deleted_ind = 1
						group by cdshm_dpam_id,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value
						having (count(cdshm_trans_no) >= cham_from_factor) and (count(cdshm_trans_no) <= cham_to_factor) 


					 update cdsl_holding_dtls
					        set    cdshm_dp_charge   =  cdshm_dp_charge +
					       insert into #temp_bill
													(trans_dt 
													,dpam_id  
													,charge_name 
					        ,charge_val
					        ,post_toacct)
					        select @pa_billing_date
												 ,cdshm_dpam_id
							 ,cham_slab_name
						 isnull(count(cdshm_trans_no)*cham_charge_value ,0)
					
							from cdsl_holding_dtls      
											,dp_charges_mstr
											,profile_charges
											,charge_mstr 
							where cdshm_dpm_id = @pa_dpm_id
							AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
			    AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
							AND   cdshm_dpm_id  = dpc_dpm_id
			    AND   dpc_profile_id = proc_profile_id
							AND   proc_slab_no  = cham_slab_no
							AND   isnull(cham_charge_graded,0) <> 1
							AND   cham_charge_baseon           = 'TRANSNO' 
							AND   cham_charge_type = 'EXCH_PAYIN'
							AND   cdshm_tratm_type_desc in ('NSCCL-DR','CSECH-DR','BSECH-DR','ASECH-DR','OTCEI-DR','DSECH-DR')
							AND   cdshm_tratm_cd = '2277'
							and   cham_deleted_ind = 1
							and   dpc_deleted_ind = 1
							and   cdshm_deleted_ind = 1
							and   proc_deleted_ind = 1
							group by cdshm_dpam_id,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value
						having (count(cdshm_trans_no) >= cham_from_factor) and (count(cdshm_trans_no) <= cham_to_factor) 


				 update cdsl_holding_dtls
				        set    cdshm_dp_charge   = cdshm_dp_charge + 
			      insert into #temp_bill
												(trans_dt 
												,dpam_id  
												,charge_name 
				        ,charge_val
				        ,post_toacct)
				        select @pa_billing_date
											 ,cdshm_dpam_id
							 ,cham_slab_name
					 isnull(count(cdshm_trans_no)*cham_charge_value ,0)
				
						from cdsl_holding_dtls      
										,dp_charges_mstr
										,profile_charges
										,charge_mstr 
						where cdshm_dpm_id = @pa_dpm_id
						AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
			   AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
						AND   cdshm_dpm_id  = dpc_dpm_id
			   AND   dpc_profile_id = proc_profile_id
						AND   proc_slab_no  = cham_slab_no
						AND   isnull(cham_charge_graded,0) <> 1
						AND   cham_charge_baseon           = 'TRANSNO' 
						AND   cham_charge_type = 'EXCH_PAYOUT'
						AND   cdshm_tratm_type_desc in ('NSCCL-CR','CSECH-CR','BSECH-CR','ASECH-CR','OTCEI-CR','DSECH-CR')
						AND   cdshm_tratm_cd = '2246'
						and   cham_deleted_ind = 1
						and   dpc_deleted_ind = 1
						and   cdshm_deleted_ind = 1
						and   proc_deleted_ind = 1
						group by cdshm_dpam_id,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value
					 having (count(cdshm_trans_no) >= cham_from_factor) and (count(cdshm_trans_no) <= cham_to_factor) 
      
      */
  ----transaction per transaction no wise charge
  
   ----transaction per transaction no per slip no wise charge
  
				insert into #temp_bill
				(trans_dt 
				,dpm_id
				,DPAM_ID  
				,charge_name 
				,charge_val
				,post_toacct)
				select cdshm_tras_dt
				,cdshm_dpm_id
				,CDSHM_DPAM_ID
				,cham_slab_name
				,isnull(case when count(cdshm_trans_no)*cham_charge_value <= cham_charge_minval then cham_charge_minval*-1
				else (count(cdshm_trans_no)*cham_charge_value)*-1 end    ,0)
				,cham_post_toacct 
				from cdsl_holding_dtls      
				,dp_charges_mstr
				,profile_charges
				,charge_mstr 
				where cdshm_dpm_id = @pa_dpm_id
				AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
				AND   cdshm_tras_dt >= DPC_EFF_from_DT and  cdshm_tras_dt <= DPC_EFF_TO_DT
				AND   cdshm_dpm_id   = dpc_dpm_id
				AND   dpc_profile_id = proc_profile_id
				AND   proc_slab_no  = cham_slab_no
				AND   isnull(cham_charge_graded,0) <> 1
				AND   cham_charge_baseon           = 'TRANSPERSLIP' 
				AND   cdshm_tratm_type_desc  not in ('DEMAT','REMAT')
				AND   cham_charge_type = cdshm_tratm_type_desc
				AND   cdshm_tratm_cd in ('2246','2277')
				and   cham_deleted_ind = 1
				and   dpc_deleted_ind = 1
				and   cdshm_deleted_ind = 1
				and   proc_deleted_ind = 1
                and   CHAM_CHARGE_BASE = 'NORMAL'
				group by cdshm_dpm_id,CDSHM_DPAM_ID,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value, cham_charge_minval,cdshm_tras_dt,cham_post_toacct
				having (count(cdshm_trans_no) >= cham_from_factor) and (count(cdshm_trans_no) <= cham_to_factor) 


		      
				update cdsl_holding_dtls
				set CDSHM_DP_CHARGE = isnull(CDSHM_DP_CHARGE,0) + 
				isnull(case when demrm_total_certificates*cham_charge_value <= cham_charge_minval then cham_charge_minval*-1
				else (demrm_total_certificates*cham_charge_value)* -1 end,0)
				from cdsl_holding_dtls      
				,dp_charges_mstr
				,profile_charges
				,charge_mstr 
				,demat_request_mstr
				where cdshm_dpm_id = @pa_dpm_id
				AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
				AND   cdshm_tras_dt >= DPC_EFF_from_DT and  cdshm_tras_dt <= DPC_EFF_TO_DT
				AND   cdshm_dpm_id  = dpc_dpm_id
				AND   dpc_profile_id = proc_profile_id
				AND   proc_slab_no  = cham_slab_no
				AND   cdshm_trans_no = demrm_drf_no
				AND   isnull(cham_charge_graded,0) <> 1
				AND   cham_charge_baseon           = 'TRANSPERSLIP' 
				AND   cdshm_tratm_type_desc        = 'DEMAT'
				AND   demrm_status                 = 'E'
				AND   cham_charge_type = cdshm_tratm_type_desc
				AND   cdshm_tratm_cd = '2246'
				AND   (demrm_total_certificates >= cham_from_factor) and (demrm_total_certificates<= cham_to_factor) 
				and   cham_deleted_ind = 1
				and   dpc_deleted_ind = 1
				and   cdshm_deleted_ind = 1
				and   proc_deleted_ind = 1
				and	  demrm_deleted_ind = 1
                and   CHAM_CHARGE_BASE = 'NORMAL'


                update cdsl_holding_dtls
				set CDSHM_DP_CHARGE = isnull(CDSHM_DP_CHARGE,0) + 
				isnull(case when DEMRM_QTY *(CONVERT(NUMERIC(10,2),cham_charge_value)/CONVERT(NUMERIC(10,2),CHAM_CHARGE_MINVAL)) < DEMRM_TOTAL_CERTIFICATES*CHAM_PER_MIN then  DEMRM_TOTAL_CERTIFICATES*CHAM_PER_MIN * -1 
		        else DEMRM_QTY *(CONVERT(NUMERIC(10,2),cham_charge_value)/CONVERT(NUMERIC(10,2),CHAM_CHARGE_MINVAL)) end    ,0)  
				from cdsl_holding_dtls      
				,dp_charges_mstr
				,profile_charges
				,charge_mstr 
				,demat_request_mstr
				where cdshm_dpm_id = @pa_dpm_id
				AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
				AND   cdshm_tras_dt >= DPC_EFF_from_DT and  cdshm_tras_dt <= DPC_EFF_TO_DT
				AND   cdshm_dpm_id  = dpc_dpm_id
				AND   dpc_profile_id = proc_profile_id
				AND   proc_slab_no  = cham_slab_no
				AND   cdshm_trans_no = demrm_drf_no
				AND   isnull(cham_charge_graded,0) <> 1
				AND   cham_charge_baseon           = 'CQ' 
				AND   cdshm_tratm_type_desc        = 'DEMAT'
				AND   demrm_status                 = 'E'
				AND   cham_charge_type = cdshm_tratm_type_desc
				AND   cdshm_tratm_cd = '2246'
				AND   (demrm_total_certificates >= cham_from_factor) and (demrm_total_certificates<= cham_to_factor) 
				and   cham_deleted_ind = 1
				and   dpc_deleted_ind = 1
				and   cdshm_deleted_ind = 1
				and   proc_deleted_ind = 1
				and	  demrm_deleted_ind = 1
                and   CHAM_CHARGE_BASE = 'NORMAL'


				update cdsl_holding_dtls
				set CDSHM_DP_CHARGE = isnull(CDSHM_DP_CHARGE,0) + 
				isnull(case when REMRM_CERTIFICATE_NO*cham_charge_value <= cham_charge_minval then cham_charge_minval*-1
				else (REMRM_CERTIFICATE_NO*cham_charge_value)* -1 end,0)
				from cdsl_holding_dtls      
				,dp_charges_mstr
				,profile_charges
				,charge_mstr 
				,remat_request_mstr
				where cdshm_dpm_id = @pa_dpm_id
				AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
				AND   cdshm_tras_dt >= DPC_EFF_from_DT and  cdshm_tras_dt <= DPC_EFF_TO_DT
				AND   cdshm_dpm_id  = dpc_dpm_id
				AND   dpc_profile_id = proc_profile_id
				AND   proc_slab_no  = cham_slab_no
				AND   cdshm_trans_no = remrm_rrf_no
				AND   isnull(cham_charge_graded,0) <> 1
				AND   cham_charge_baseon           = 'TRANSPERSLIP' 
				AND   cdshm_tratm_type_desc        = 'REMAT'
				AND   remrm_status                 = 'E'
				AND   cham_charge_type = cdshm_tratm_type_desc
				AND   cdshm_tratm_cd = '2277'
				AND   (REMRM_CERTIFICATE_NO >= cham_from_factor) and (REMRM_CERTIFICATE_NO<= cham_to_factor) 
				and   cham_deleted_ind = 1
				and   dpc_deleted_ind = 1
				and   cdshm_deleted_ind = 1
				and   proc_deleted_ind = 1
				and	  remrm_deleted_ind = 1
                and   CHAM_CHARGE_BASE = 'NORMAL'




		
				insert into #temp_bill
				(trans_dt 
				,dpm_id  
				,DPAM_ID
				,charge_name 
				,charge_val
				,post_toacct)
				select cdshm_tras_dt
				,cdshm_dpm_id
				,CDSHM_DPAM_ID
				,cham_slab_name
				,isnull(case when count(cdshm_trans_no)*cham_charge_value <= cham_charge_minval then cham_charge_minval*-1
				else (count(cdshm_trans_no)*cham_charge_value)*-1 end    ,0)
				, cham_post_toacct 
				from cdsl_holding_dtls      
				,dp_charges_mstr
				,profile_charges
				,charge_mstr 
				where cdshm_dpm_id = @pa_dpm_id
				AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
				AND   cdshm_tras_dt >= DPC_EFF_from_DT and  cdshm_tras_dt <= DPC_EFF_TO_DT
				AND   cdshm_dpm_id  = dpc_dpm_id
				AND   dpc_profile_id = proc_profile_id
				AND   proc_slab_no  = cham_slab_no
				AND   isnull(cham_charge_graded,0) <> 1
				AND   cham_charge_baseon           = 'TRANSPERSLIP' 
				AND   cham_charge_type = 'EXCH_PAYIN'
				AND   cdshm_tratm_type_desc in ('NSCCL-DR','CSECH-DR','BSECH-DR','ASECH-DR','OTCEI-DR','DSECH-DR')
				AND   cdshm_tratm_cd = '2277'
				and   cham_deleted_ind = 1
				and   dpc_deleted_ind = 1
				and   cdshm_deleted_ind = 1
				and   proc_deleted_ind = 1
                and   CHAM_CHARGE_BASE = 'NORMAL'
				group by cdshm_dpm_id,CDSHM_DPAM_ID,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value, cham_charge_minval,cdshm_tras_dt,cham_post_toacct
				having (count(cdshm_trans_no) >= cham_from_factor) and (count(cdshm_trans_no) <= cham_to_factor) 
		
		
				insert into #temp_bill
				(trans_dt 
				,dpm_id  
				,DPAM_ID
				,charge_name 
				,charge_val
				,post_toacct)
				select cdshm_tras_dt
				,cdshm_dpm_id
				,CDSHM_DPAM_ID
				,cham_slab_name
				,isnull(case when count(cdshm_trans_no)*cham_charge_value <= cham_charge_minval then cham_charge_minval*-1
				else (count(cdshm_trans_no)*cham_charge_value)* -1 end    ,0)
				, cham_post_toacct	
				from cdsl_holding_dtls      
				,dp_charges_mstr
				,profile_charges
				,charge_mstr 
				where cdshm_dpm_id = @pa_dpm_id
				AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
				AND   cdshm_tras_dt >= DPC_EFF_from_DT and  cdshm_tras_dt <= DPC_EFF_TO_DT
				AND   cdshm_dpm_id  = dpc_dpm_id
				AND   dpc_profile_id = proc_profile_id
				AND   proc_slab_no  = cham_slab_no
				AND   isnull(cham_charge_graded,0) <> 1
				AND   cham_charge_baseon           = 'TRANSPERSLIP' 
				AND   cham_charge_type = 'EXCH_PAYOUT'
				AND   cdshm_tratm_type_desc in ('NSCCL-CR','CSECH-CR','BSECH-CR','ASECH-CR','OTCEI-CR','DSECH-CR')
				AND   cdshm_tratm_cd = '2246'
				and   cham_deleted_ind = 1
				and   dpc_deleted_ind = 1
				and   cdshm_deleted_ind = 1
				and   proc_deleted_ind = 1
                and   CHAM_CHARGE_BASE = 'NORMAL'
				group by cdshm_dpm_id,CDSHM_DPAM_ID,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value, cham_charge_minval,cdshm_tras_dt,cham_post_toacct
				having (count(cdshm_trans_no) >= cham_from_factor) and (count(cdshm_trans_no) <= cham_to_factor)
					 

				update cdsl_holding_dtls 
				set  CDSHM_DP_CHARGE = round(CDSHM_DP_CHARGE,2) 
				where cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
				and isnull(CDSHM_DP_CHARGE,0) <> 0



				select top 1 @l_post_toacct = cham_post_toacct 
				from  charge_mstr,profile_charges,dp_charges_mstr 
				where @pa_billing_to_dt between dpc_eff_from_dt and dpc_eff_to_dt 
				and dpc_profile_id = proc_profile_id
				and proc_slab_no  = cham_slab_no
				and cham_charge_type = 'OF-DR' 
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
				select cdshm_tras_dt 
				, cdshm_dpm_id
				, CDSHM_DPAM_ID
				, 'TRANSACTION CHARGES'
				, sum(cdshm_dp_charge)
				, @l_post_toacct 
				from cdsl_holding_dtls     
				WHERE cdshm_dpm_id = @pa_dpm_id  
				and   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
				and   cdshm_deleted_ind =1 
				group by cdshm_dpm_id,CDSHM_DPAM_ID,cdshm_tras_dt 
						
					 
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
				,Charge_amt=sum(case when cham_val_pers  = 'V' then cham_charge_value *-1  
				else case when (cham_charge_value/100)*Abs(charge_val) <= cham_charge_minval then cham_charge_minval  *-1
				else ((cham_charge_value/100)*Abs(charge_val))* -1 end  
				end)    
				,cham_post_toacct
				from #temp_bill
				,dp_charges_mstr  
				,profile_charges  
				,charge_mstr    
				where trans_dt >= DPC_EFF_FROM_DT 		and  trans_dt <= DPC_EFF_TO_DT  
				AND   dpm_id  = DPC_DPM_ID
				AND   dpc_profile_id = proc_profile_id
				AND   proc_slab_no  = cham_slab_no  
				AND   isnull(cham_charge_graded,0) <> 1  
				AND   cham_charge_type           = 'AMT'   
				and   cham_deleted_ind = 1  
				and   proc_deleted_ind = 1  
                 and   CHAM_CHARGE_BASE = 'NORMAL'
				and not exists(select src_chargename,on_chargename from ExcludeTransCharges E
				where src_chargename = charge_name and on_chargename = cham_slab_name and for_type = 'D' and  E.dpm_id = @pa_dpm_id)
				group by dpm_id,DPAM_ID,cham_slab_name,cham_post_toacct,trans_dt 
				  --logic for charge on amount like service tax
  
					 
				delete from dp_charges_cdsl where dpch_tranc_dt between @pa_billing_from_dt and @pa_billing_to_dt and dpch_flg = 'S' and dpch_dpm_id = @pa_dpm_id
					 
				insert into dp_charges_cdsl(dpch_tranc_dt
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
