-- Object: PROCEDURE citrus_usr.pr_InstrCdslcharges
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--pr_InstrCdslcharges	'1234567890123456','3','10/25/2008 12:00:00 AM','10/25/2008 12:00:00 AM','OF-DR|*~|*|~*0|*~|*|~*INE002A01018|*~|100|*~|1000|*~|*|~*INE117A01022|*~|500|*~|2000|*~|*|~*'

    
  
--[pr_InstrCdslcharges]  '1234567890123456','3','oct 25 2008','oct 25 2008','of-DR|*~|*|~*0|*~|*|~*ine002a01018|*~|100|*~|1000|*~|*|~*'  
CREATE procedure [citrus_usr].[pr_InstrCdslcharges](@pa_dpam_sba VARCHAR(16), @pa_excsm_id bigint,@pa_billing_dt datetime,@pa_exec_dt datetime,@pa_values varchar(8000))  
as  
begin  
--  
 declare @pa_dpm_id bigint  
 select @pa_dpm_id = dpm_id from dp_mstr where default_dp = @pa_excsm_id and dpm_deleted_ind =1                                      
    
           
    
    
  create table #temp_bill  
  (cdshm_tratm_type_desc varchar(20)  
  ,dpam_sba_no varchar(16)  
  ,isin  varchar(12)  
  ,cdshm_qty numeric (18,3)  
  ,clopm_cdsl_rt  numeric(18,5)  
  ,cdshm_dpam_id bigint  
  ,total_certificates int  
  ,cdshm_charge numeric(18,2)  
  ,cdshm_dp_charge numeric(18,2)  
  ,ser_tax numeric(18,2))  
  
    
  DECLARE @l_counter numeric  
  , @l_count NUMERIC  
  , @l_cdshm_tratm_type_desc varchar(20)  
  , @l_dpam_sba_no varchar(16)  
  , @l_isin  varchar(12)  
  , @l_cdshm_qty numeric (18,3)  
  , @l_clopm_cdsl_rt  numeric(18,5)  
  , @l_cdshm_dpam_id bigint  
  , @l_total_certificates int  
  , @l_cdshm_charge numeric(18,2)  
  , @l_cdshm_dp_charge numeric(18,2)  
  , @l_ser_tax numeric(18,2)  
  , @pa_dpam_id VARCHAR(16)  
  , @l_val_by_row VARCHAR(8000)  
    
  SELECT @pa_dpam_id = dpam_id FROM dp_acct_mstr WHERE dpam_sba_no = @pa_dpam_sba AND dpam_deleted_ind = 1  
    
  SET @l_counter = 1  
  SELECT @l_count = citrus_usr.ufn_CountString(@pa_values,'*|~*')  
    
  WHILE @l_counter <=@l_count   
  BEGIN  
    
    SELECT @l_val_by_row = citrus_usr.FN_SPLITVAL_ROW(@pa_values,@l_counter)  
    IF @l_counter = 1  
    BEGIN  
       SELECT @l_cdshm_tratm_type_desc = citrus_usr.FN_SPLITVAL(@l_val_by_row,1)  
    end     
    IF @l_counter = 2  
    begin  
       SELECT @l_total_certificates = citrus_usr.FN_SPLITVAL(@l_val_by_row,1)  
    end  
      
    IF @l_counter >= 3  
    BEGIN  
  INSERT INTO #temp_bill (cdshm_tratm_type_desc  
    ,dpam_sba_no  
    ,isin   
    ,cdshm_qty   
    ,clopm_cdsl_rt  
    ,cdshm_dpam_id  
    ,total_certificates)  
    SELECT @l_cdshm_tratm_type_desc  
    ,@pa_dpam_sba  
    ,citrus_usr.FN_SPLITVAL(@l_val_by_row,1)  
    ,citrus_usr.FN_SPLITVAL(@l_val_by_row,2)  
    ,citrus_usr.FN_SPLITVAL(@l_val_by_row,3)  
    ,@pa_dpam_id  
    ,@l_total_certificates  
 END      
    SET @l_counter = @l_counter + 1  
  END  
    
    
  
-- for dp charges  
   
  ----transaction value wise charge  
  
   update #temp_bill  
   set    cdshm_dp_charge   =    
   isnull(case when cham_val_pers  = 'V' then cham_charge_value * -1  
   else case when (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt) <= cham_charge_minval then cham_charge_minval* -1  
   else (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt) * -1 end  
   end,0)    
   from #temp_bill  
   ,dp_charges_mstr  
   ,profile_charges  
   ,charge_mstr   
   where @pa_billing_dt >= dpc_eff_from_dt and  @pa_billing_dt <= dpc_eff_to_dt  
   AND   dpc_dpm_id = @pa_dpm_id  
   AND   dpc_profile_id = proc_profile_id  
   AND   proc_slab_no  = cham_slab_no  
   AND   isnull(cham_charge_graded,0) <> 1  
   AND   cham_charge_baseon           = 'TV'   
   AND   cham_charge_type = cdshm_tratm_type_desc  
   AND   (abs(cdshm_qty)*clopm_cdsl_rt >= cham_from_factor)  and (abs(cdshm_qty)*clopm_cdsl_rt <= cham_to_factor)    
   and   cham_deleted_ind = 1  
   and   dpc_deleted_ind = 1  
   and   proc_deleted_ind = 1  
  
  
  ------  
   update #temp_bill  
   set    cdshm_dp_charge   =  cdshm_dp_charge +  
   isnull(case when cham_val_pers  = 'V' then cham_charge_value* -1   
   else case when (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt) <= cham_charge_minval then cham_charge_minval* -1   
   else (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt)*-1 end  
   end  ,0)  
   from #temp_bill        
   ,dp_charges_mstr  
   ,profile_charges  
   ,charge_mstr   
   where @pa_billing_dt >= dpc_eff_from_dt and  @pa_billing_dt <= dpc_eff_to_dt  
   AND   dpc_dpm_id = @pa_dpm_id  
   AND   dpc_profile_id = proc_profile_id  
   AND   proc_slab_no  = cham_slab_no  
   AND   isnull(cham_charge_graded,0) <> 1  
   AND   cham_charge_baseon           = 'TV'   
   AND   cham_charge_type = 'EXCH_PAYIN'  
   AND   cdshm_tratm_type_desc in ('NSCCL-DR','CSECH-DR','BSECH-DR','ASECH-DR','OTCEI-DR','DSECH-DR')  
   AND   (abs(cdshm_qty)*clopm_cdsl_rt >= cham_from_factor)  and (abs(cdshm_qty)*clopm_cdsl_rt <= cham_to_factor)    
   and   cham_deleted_ind = 1  
   and   dpc_deleted_ind = 1  
   and   proc_deleted_ind = 1  
  
  ------  
  
   update #temp_bill  
   set    cdshm_dp_charge   =  cdshm_dp_charge +  
   isnull(case when cham_val_pers  = 'V' then cham_charge_value*-1   
   else case when (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt) <= cham_charge_minval then cham_charge_minval*-1  
   else (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt)*-1 end  
   end    ,0)  
   from #temp_bill        
   ,dp_charges_mstr  
   ,profile_charges  
   ,charge_mstr   
   where @pa_billing_dt >= dpc_eff_from_dt and  @pa_billing_dt <= dpc_eff_to_dt  
   AND   dpc_dpm_id = @pa_dpm_id  
   AND   dpc_profile_id = proc_profile_id  
   AND   proc_slab_no  = cham_slab_no  
   AND   isnull(cham_charge_graded,0) <> 1  
   AND   cham_charge_baseon           = 'TV'   
   AND   cham_charge_type = 'EXCH_PAYOUT'  
   AND   cdshm_tratm_type_desc in ('NSCCL-CR','CSECH-CR','BSECH-CR','ASECH-CR','OTCEI-CR','DSECH-CR')  
   AND   (abs(cdshm_qty)*clopm_cdsl_rt >= cham_from_factor)  and (abs(cdshm_qty)*clopm_cdsl_rt <= cham_to_factor)    
   and   cham_deleted_ind = 1  
   and   dpc_deleted_ind = 1  
   and   proc_deleted_ind = 1  
  
           
  ------  
  ----transaction value wise charge\  
    
    
  ----transaction qty wise charge  
    
   update #temp_bill  
   set    cdshm_dp_charge   =  cdshm_dp_charge +  
   isnull(cham_charge_value,0)*-1   
   from #temp_bill        
   ,dp_charges_mstr  
   ,profile_charges  
   ,charge_mstr   
   where @pa_billing_dt >= dpc_eff_from_dt and  @pa_billing_dt <= dpc_eff_to_dt  
   AND   dpc_dpm_id = @pa_dpm_id  
   AND   dpc_profile_id = proc_profile_id  
   AND   proc_slab_no  = cham_slab_no  
   AND   isnull(cham_charge_graded,0) <> 1  
   AND   cham_charge_baseon           = 'TQ'   
   AND   cham_charge_type = cdshm_tratm_type_desc  
   AND   (abs(cdshm_qty) >= cham_from_factor)  and (abs(cdshm_qty) <= cham_to_factor)    
   and   cham_deleted_ind = 1  
   and   dpc_deleted_ind = 1  
   and   proc_deleted_ind = 1  
        
        
   update #temp_bill  
   set    cdshm_dp_charge   =  cdshm_dp_charge +  
   isnull(cham_charge_value,0)* -1  
   from #temp_bill        
   ,dp_charges_mstr  
   ,profile_charges  
   ,charge_mstr   
   where @pa_billing_dt >= dpc_eff_from_dt and  @pa_billing_dt <= dpc_eff_to_dt  
   AND   dpc_dpm_id = @pa_dpm_id  
   AND   dpc_profile_id = proc_profile_id  
   AND   proc_slab_no  = cham_slab_no  
   AND   isnull(cham_charge_graded,0) <> 1  
   AND   cham_charge_baseon           = 'TQ'   
   AND   cham_charge_type = 'EXCH_PAYIN'  
   AND   cdshm_tratm_type_desc in ('NSCCL-DR','CSECH-DR','BSECH-DR','ASECH-DR','OTCEI-DR','DSECH-DR')  
   AND   (abs(cdshm_qty) >= cham_from_factor)  and (abs(cdshm_qty) <= cham_to_factor)    
   and   cham_deleted_ind = 1  
   and   dpc_deleted_ind = 1  
   and   proc_deleted_ind = 1  
         
  
        
   update #temp_bill  
   set    cdshm_dp_charge   =  cdshm_dp_charge +  
   isnull(cham_charge_value,0)*-1  
   from #temp_bill        
   ,dp_charges_mstr  
   ,profile_charges  
   ,charge_mstr   
   where @pa_billing_dt >= dpc_eff_from_dt and  @pa_billing_dt <= dpc_eff_to_dt  
   AND   dpc_dpm_id = @pa_dpm_id  
   AND   dpc_profile_id = proc_profile_id  
   AND   proc_slab_no  = cham_slab_no  
   AND   isnull(cham_charge_graded,0) <> 1  
   AND   cham_charge_baseon           = 'TQ'   
   AND   cham_charge_type = 'EXCH_PAYOUT'  
   AND   cdshm_tratm_type_desc in ('NSCCL-CR','CSECH-CR','BSECH-CR','ASECH-CR','OTCEI-CR','DSECH-CR')     AND   (abs(cdshm_qty) >= cham_from_factor)  and (abs(cdshm_qty) <= cham_to_factor)    
   and   cham_deleted_ind = 1  
   and   dpc_deleted_ind = 1  
   and   proc_deleted_ind = 1  
         
        
    
  ----transaction qtywise charge  
    update #temp_bill  
    set CDSHM_DP_CHARGE = isnull(CDSHM_DP_CHARGE,0) +   
    isnull(case when total_certificates*cham_charge_value <= cham_charge_minval then cham_charge_minval*-1  
    else (total_certificates*cham_charge_value)* -1 end,0)  
    from #temp_bill        
    ,dp_charges_mstr  
    ,profile_charges  
    ,charge_mstr   
    where @pa_billing_dt >= DPC_EFF_from_DT and  @pa_billing_dt <= DPC_EFF_TO_DT  
    AND   dpc_dpm_id = @pa_dpm_id  
    AND   dpc_profile_id = proc_profile_id  
    AND   proc_slab_no  = cham_slab_no  
    AND   isnull(cham_charge_graded,0) <> 1  
    AND   cham_charge_baseon           = 'TRANSPERSLIP'   
    AND   cdshm_tratm_type_desc        = 'DEMAT'  
    AND   cham_charge_type = cdshm_tratm_type_desc  
    AND   (total_certificates >= cham_from_factor) and (total_certificates<= cham_to_factor)   
    and   cham_deleted_ind = 1  
    and   dpc_deleted_ind = 1  
    and   proc_deleted_ind = 1  
  
  
    update #temp_bill  
    set CDSHM_DP_CHARGE = isnull(CDSHM_DP_CHARGE,0) +   
    isnull(case when total_certificates*cham_charge_value <= cham_charge_minval then cham_charge_minval*-1  
    else (total_certificates*cham_charge_value)* -1 end,0)  
    from #temp_bill        
    ,dp_charges_mstr  
    ,profile_charges  
    ,charge_mstr   
    where @pa_billing_dt >= DPC_EFF_from_DT and  @pa_billing_dt <= DPC_EFF_TO_DT  
    AND   dpc_dpm_id = @pa_dpm_id  
    AND   dpc_profile_id = proc_profile_id  
    AND   proc_slab_no  = cham_slab_no  
    AND   isnull(cham_charge_graded,0) <> 1  
    AND   cham_charge_baseon           = 'TRANSPERSLIP'   
    AND   cdshm_tratm_type_desc        = 'REMAT'  
    AND   cham_charge_type = cdshm_tratm_type_desc  
    AND   (total_certificates >= cham_from_factor) and (total_certificates<= cham_to_factor)   
    and   cham_deleted_ind = 1  
    and   dpc_deleted_ind = 1  
    and   proc_deleted_ind = 1  
  
-- for dp charges  
  
  
  
  
-- for client charges    
  --logic for transaction type wise charge  
    ----transaction value wise charge  
        update #temp_bill  
        set    cdshm_charge   =    
        isnull(case when cham_val_pers  = 'V' then cham_charge_value * -1   
             else case when (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt) <= cham_charge_minval then cham_charge_minval* -1  
                  else (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt)* -1 end  
             end  ,0)  
         
         from #temp_bill  
             ,client_dp_brkg  
       ,profile_charges  
       ,charge_mstr   
         where @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt  
         AND   cdshm_dpam_id = clidb_dpam_id   
         AND   clidb_brom_id = proc_profile_id  
         AND   proc_slab_no  = cham_slab_no  
         AND   isnull(cham_charge_graded,0) <> 1  
         AND   cham_charge_baseon           = 'TV'   
         AND   cham_charge_type = cdshm_tratm_type_desc  
         AND   (abs(cdshm_qty)*clopm_cdsl_rt >= cham_from_factor)  and (abs(cdshm_qty)*clopm_cdsl_rt <= cham_to_factor)    
         and   cham_deleted_ind = 1  
         and   clidb_deleted_ind = 1  
         and   proc_deleted_ind = 1  
          
  
  ------  
      update #temp_bill  
      set    cdshm_charge   =  isnull(cdshm_charge,0) +  
         isnull(case when cham_val_pers  = 'V' then cham_charge_value * -1  
            else case when (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt) <= cham_charge_minval then cham_charge_minval *-1   
                 else (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt)* -1 end  
            end  ,0)  
          
          from #temp_bill  
              ,client_dp_brkg  
              ,profile_charges  
              ,charge_mstr   
          where @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt  
          AND   cdshm_dpam_id = clidb_dpam_id   
          AND   clidb_brom_id = proc_profile_id  
          AND   proc_slab_no  = cham_slab_no  
          AND   isnull(cham_charge_graded,0) <> 1  
          AND   cham_charge_baseon           = 'TV'   
          AND   cham_charge_type = 'EXCHPAYIN'  
          AND   cdshm_tratm_type_desc in ('NSCCL-DR','CSECH-DR','BSECH-DR','ASECH-DR','OTCEI-DR','DSECH-DR')  
          AND   (abs(cdshm_qty)*clopm_cdsl_rt >= cham_from_factor)  and (abs(cdshm_qty)*clopm_cdsl_rt <= cham_to_factor)    
          and   cham_deleted_ind = 1  
          and   clidb_deleted_ind = 1  
          and   proc_deleted_ind = 1  
  
          
           
    
  ------  
/*NEW CHARGES*/
--                        update #temp_bill
--						set cdshm_charge= ISNULL(cdshm_charge,0) + 
--                        isnull(case when DEMRM_QTY *(CONVERT(NUMERIC(10,2),cham_charge_value)/CONVERT(NUMERIC(10,2),CHAM_CHARGE_MINVAL)) < DEMRM_TOTAL_CERTIFICATES*CHAM_PER_MIN then  DEMRM_TOTAL_CERTIFICATES*CHAM_PER_MIN * -1 
--		                else DEMRM_QTY *(CONVERT(NUMERIC(10,2),cham_charge_value)/CONVERT(NUMERIC(10,2),CHAM_CHARGE_MINVAL)) end    ,0)  
--						from #temp_bill
--						,client_dp_brkg
--						,profile_charges
--						,charge_mstr 
--						,demat_request_mstr
--						where @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt  
--						AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
--						AND   cdshm_dpam_id = clidb_dpam_id 
--						AND   clidb_brom_id = proc_profile_id
--						AND   proc_slab_no  = cham_slab_no
--						AND   cdshm_dpam_id = demrm_dpam_id
--						AND   cdshm_trans_no = demrm_drf_no
--						AND   isnull(cham_charge_graded,0) <> 1
--						AND   cham_charge_baseon           = 'CQ' 
--						AND   cdshm_tratm_type_desc        = 'DEMAT'
--						AND   demrm_status                 = 'E'
--						AND   cham_charge_type = cdshm_tratm_type_desc
--						AND   cdshm_tratm_cd = '2246'
--						and   cham_deleted_ind  = 1
--						and   clidb_deleted_ind = 1
--						and   cdshm_deleted_ind = 1
--						and   proc_deleted_ind  = 1
--						and	  demrm_deleted_ind = 1
--                        and   CHAM_CHARGE_BASE = 'NORMAL'
/*NEW CHARGES*/



						
  ------
     update #temp_bill  
     set    cdshm_charge   =  isnull(cdshm_charge,0) +  
     isnull(case when cham_val_pers  = 'V' then cham_charge_value* -1    
     else case when (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt) <= cham_charge_minval then cham_charge_minval* -1   
     else (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt)* -1 end  
     end    ,0)  
  
     from #temp_bill  
     ,client_dp_brkg  
     ,profile_charges  
     ,charge_mstr   
     where @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt  
     AND   cdshm_dpam_id = clidb_dpam_id   
     AND   clidb_brom_id = proc_profile_id  
     AND   proc_slab_no  = cham_slab_no  
     AND   isnull(cham_charge_graded,0) <> 1  
     AND   cham_charge_baseon           = 'TV'   
     AND   cham_charge_type = 'EXCHPAYOUT'  
     AND   cdshm_tratm_type_desc in ('NSCCL-CR','CSECH-CR','BSECH-CR','ASECH-CR','OTCEI-CR','DSECH-CR')  
     AND   (abs(cdshm_qty)*clopm_cdsl_rt >= cham_from_factor)  and (abs(cdshm_qty)*clopm_cdsl_rt <= cham_to_factor)    
     and   cham_deleted_ind = 1  
     and   clidb_deleted_ind = 1  
     and   proc_deleted_ind = 1  
  ------  
  ----transaction value wise charge\  
    
  ----transaction qty wise charge  
    
     update #temp_bill  
        set    cdshm_charge   =  isnull(cdshm_charge,0) +  
     (isnull(cham_charge_value,0) * -1 )  
    from #temp_bill  
    ,client_dp_brkg  
    ,profile_charges  
    ,charge_mstr   
    where @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt  
    AND   cdshm_dpam_id = clidb_dpam_id   
    AND   clidb_brom_id = proc_profile_id  
    AND   proc_slab_no  = cham_slab_no  
                AND   isnull(cham_charge_graded,0) <> 1  
    AND   cham_charge_baseon           = 'TQ'   
    AND   cham_charge_type = cdshm_tratm_type_desc  
    AND   (abs(cdshm_qty) >= cham_from_factor)  and (abs(cdshm_qty) <= cham_to_factor)    
    and   cham_deleted_ind = 1  
    and   clidb_deleted_ind = 1  
    and   proc_deleted_ind = 1  
  
        
     update #temp_bill  
     set    cdshm_charge   =  isnull(cdshm_charge,0) +  
     (isnull(cham_charge_value,0)* -1)  
     from #temp_bill  
     ,client_dp_brkg  
     ,profile_charges  
     ,charge_mstr   
     where @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt  
     AND   cdshm_dpam_id = clidb_dpam_id   
     AND   clidb_brom_id = proc_profile_id  
     AND   proc_slab_no  = cham_slab_no  
     AND   isnull(cham_charge_graded,0) <> 1  
     AND   cham_charge_baseon           = 'TQ'   
     AND   cham_charge_type = 'EXCHPAYIN'  
     AND   cdshm_tratm_type_desc in ('NSCCL-DR','CSECH-DR','BSECH-DR','ASECH-DR','OTCEI-DR','DSECH-DR')  
     AND   (abs(cdshm_qty) >= cham_from_factor)  and (abs(cdshm_qty) <= cham_to_factor)    
     and   cham_deleted_ind = 1  
     and   clidb_deleted_ind = 1  
     and   proc_deleted_ind = 1  
  
  
/*  
     --slab added for same day payin & execution for slip  
     update #temp_bill  
     set    cdshm_charge   =  isnull(cdshm_charge,0) +  
     (isnull(cham_charge_value,0)* -1)  
     from #temp_bill  
     ,settlement_mstr   
     ,client_dp_brkg  
     ,profile_charges  
     ,charge_mstr  
     where cdshm_dpm_id = @pa_dpm_id  
     AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt  
     and   cdshm_trans_no = dptdc_trans_no  
     and   cdshm_dpam_id  = dptdc_dpam_id  
     and   cdshm_tras_dt = dptdc_execution_dt  
     and   cdshm_isin   = dptdc_isin  
     and   dptdc_request_dt = dptdc_execution_dt  
     and   dptdc_other_settlement_type = setm_settm_id   
     and   dptdc_other_settlement_no = setm_no     
     and   convert(varchar(11),dptdc_request_dt,109) = convert(varchar(11),SETM_PAYIN_DT,109)    
     AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt  
     AND   cdshm_dpam_id = clidb_dpam_id   
     AND   clidb_brom_id = proc_profile_id  
     AND   proc_slab_no  = cham_slab_no  
     AND   isnull(cham_charge_graded,0) <> 1  
     AND   cham_charge_baseon           = 'TQ'   
     AND   cham_charge_type = 'EXCHPAYIN_SAMEDAY_PAYIN'  
     AND   cdshm_tratm_type_desc in ('NSCCL-DR','CSECH-DR','BSECH-DR','ASECH-DR','OTCEI-DR','DSECH-DR')  
     AND   (abs(cdshm_qty) >= cham_from_factor)  and (abs(cdshm_qty) <= cham_to_factor)    
     AND   cdshm_tratm_cd = '2277'  
     and   cham_deleted_ind = 1  
     and   clidb_deleted_ind = 1  
     and   cdshm_deleted_ind = 1  
     and   proc_deleted_ind =  1  
     and   dptdc_deleted_ind = 1  
     --slab added for same day payin & execution for slip  
*/  
  
     --slab added for same day execution after notified timings for slip -- not complete  
  
     declare @notified_time varchar(8)  
      
     select @notified_time=ISNULL(bitrm_values,'') from bitmap_ref_mstr where BITRM_PARENT_CD = 'CDSL_NOTIFIED_TM'  
     if ltrim(rtrim(isnull(@notified_time,''))) <> ''  
     begin  
        update #temp_bill  
        set    cdshm_charge   =  isnull(cdshm_charge,0) +  
        (isnull(cham_charge_value,0)* -1)  
        from #temp_bill  
        ,client_dp_brkg  
        ,profile_charges  
        ,charge_mstr  
        where @pa_billing_dt = @pa_exec_dt  
        and   CONVERT(DATETIME,CONVERT(VARCHAR,getdate(),108)) >= CONVERT(DATETIME,@notified_time)  
        AND   @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt  
        AND   cdshm_dpam_id = clidb_dpam_id   
        AND   clidb_brom_id = proc_profile_id  
        AND   proc_slab_no  = cham_slab_no  
        AND   isnull(cham_charge_graded,0) <> 1  
        AND   cham_charge_baseon           = 'TQ'   
        AND   cham_charge_type = 'LATE_EXEC'  
        AND   cdshm_tratm_type_desc in ('INTDEP-DR','OF-DR')  
        AND   (abs(cdshm_qty) >= cham_from_factor)  and (abs(cdshm_qty) <= cham_to_factor)    
        and   cham_deleted_ind = 1  
        and   clidb_deleted_ind = 1  
        and   proc_deleted_ind = 1  
     end  
     --slab added for same day execution after notified timings for slip  
  
        
     update #temp_bill  
     set    cdshm_charge   =  ISNULL(cdshm_charge,0) +  
     (isnull(cham_charge_value,0)* -1 )  
     from #temp_bill  
     ,client_dp_brkg  
     ,profile_charges  
     ,charge_mstr   
     where @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt  
     AND   cdshm_dpam_id = clidb_dpam_id   
     AND   clidb_brom_id = proc_profile_id  
     AND   proc_slab_no  = cham_slab_no  
     AND   isnull(cham_charge_graded,0) <> 1  
     AND   cham_charge_baseon           = 'TQ'   
     AND   cham_charge_type = 'EXCHPAYOUT'  
     AND   cdshm_tratm_type_desc in ('NSCCL-CR','CSECH-CR','BSECH-CR','ASECH-CR','OTCEI-CR','DSECH-CR')  
     AND   (abs(cdshm_qty) >= cham_from_factor)  and (abs(cdshm_qty) <= cham_to_factor)    
     and   cham_deleted_ind = 1  
     and   clidb_deleted_ind = 1  
     and   proc_deleted_ind = 1  
          
  
    
  ----transaction qtywise charge  
  ----transaction instruction wise charge  
          
      update #temp_bill  
      set cdshm_charge= ISNULL(cdshm_charge,0) + isnull(case when total_certificates*cham_charge_value <= cham_charge_minval then cham_charge_minval* -1  
      else total_certificates*cham_charge_value*-1 end    ,0)  
      from #temp_bill        
      ,client_dp_brkg  
      ,profile_charges  
      ,charge_mstr   
      where @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt  
      AND   cdshm_dpam_id = clidb_dpam_id   
      AND   clidb_brom_id = proc_profile_id  
      AND   proc_slab_no  = cham_slab_no  
      AND   isnull(cham_charge_graded,0) <> 1  
      AND   cham_charge_baseon           = 'TRANSPERSLIP'   
      AND   cdshm_tratm_type_desc        = 'DEMAT'  
      AND   cham_charge_type = cdshm_tratm_type_desc  
      AND   (total_certificates >= cham_from_factor) and (total_certificates<= cham_to_factor)   
      and   cham_deleted_ind  = 1  
      and   clidb_deleted_ind = 1  
      and   proc_deleted_ind  = 1  
  
  
  
      update #temp_bill        
      set cdshm_charge= ISNULL(cdshm_charge,0) + isnull(case when total_certificates*cham_charge_value <= cham_charge_minval then cham_charge_minval* -1  
      else total_certificates*cham_charge_value*-1 end    ,0)  
      from #temp_bill        
      ,client_dp_brkg  
      ,profile_charges  
      ,charge_mstr   
      where @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt  
      AND   cdshm_dpam_id = clidb_dpam_id   
      AND   clidb_brom_id = proc_profile_id  
      AND   proc_slab_no  = cham_slab_no  
      AND   isnull(cham_charge_graded,0) <> 1  
      AND   cham_charge_baseon           = 'TRANSPERSLIP'   
      AND   cdshm_tratm_type_desc        = 'REMAT'  
      AND   cham_charge_type = cdshm_tratm_type_desc  
      AND   (total_certificates >= cham_from_factor) and (total_certificates <= cham_to_factor)   
      and   cham_deleted_ind  = 1  
      and   clidb_deleted_ind = 1  
      and   proc_deleted_ind  = 1  
  
  
  
      ----transaction per transaction no per slip no wise charge    
  
  
     update #temp_bill  set  cdshm_charge = round(cdshm_charge,2)   
  
      
  
       
  
  
  
     IF EXISTS(SELECT bitrm_id FROM bitmap_ref_mstr WHERE bitrm_parent_cd = 'BILL_CLI_ADD_DP_CHRG_CDSL' AND BITRM_BIT_LOCATION = @pa_dpm_id AND BITRM_VALUES = 1 )  
     BEGIN  
      UPDATE #temp_bill   
      SET cdshm_charge = isnull(cdshm_charge,0) + isnull(CDSHM_DP_CHARGE,0)  
      where not exists(select clidb_dpam_id from client_dp_brkg,brokerage_mstr   
          where clidb_dpam_id = cdshm_dpam_id   
          AND   clidb_brom_id = brom_id  
          and   brom_desc = 'DUMMY'  
          AND   @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt  
          and   clidb_deleted_ind = 1   
          and   brom_deleted_ind =1)  
   
     END  
       
        
        
        
        --logic for charge on amount like service tax  
     update #temp_bill  
     set ser_tax = case when cham_val_pers  = 'V' then cham_charge_value* -1     
     else case when ABS((cham_charge_value/100)*cdshm_charge) <= cham_charge_minval then cham_charge_minval* -1     
     else (cham_charge_value/100)*cdshm_charge  end    
     end      
     from #temp_bill a  
     ,client_dp_brkg    
     ,profile_charges    
     ,charge_mstr   
     where @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt    
     AND   a.cdshm_dpam_id = clidb_dpam_id   
     AND   clidb_brom_id = proc_profile_id    
     AND   proc_slab_no  = cham_slab_no    
     AND   isnull(cham_charge_graded,0) <> 1    
     AND   cham_charge_type = 'AMT'     
     and   cham_deleted_ind = 1    
     and   clidb_deleted_ind = 1    
     and   proc_deleted_ind = 1    
        --logic for charge on amount like service tax  
    
        
  --logic for transaction type wise charge  
    
    
  select isnull(sum(isnull(Abs(cdshm_charge),0) + isnull(Abs(ser_tax),0)),0) as charge_amt from #temp_bill  
    
    
--  
end

GO
