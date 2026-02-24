-- Object: PROCEDURE citrus_usr.pr_InstrNsdlcharges
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--[pr_InstrNsdlcharges] 	'1234567890123456','3','07/10/2008','07/10/2008','EP-DR|*~|*|~*0|*~|*|~*INE154F01016|*~|12|*~|21|*~|*|~*'
CREATE procedure [citrus_usr].[pr_InstrNsdlcharges](@pa_dpam_sba VARCHAR(16), @pa_excsm_id bigint,@pa_billing_dt datetime,@pa_exec_dt datetime,@pa_values varchar(8000))
as
begin
--
 declare @pa_dpm_id bigint
 select @pa_dpm_id = dpm_id from dp_mstr where default_dp = @pa_excsm_id and dpm_deleted_ind =1                                    
  
         
  
	 
  create table #temp_bill
  (nsdhm_book_naar_cd varchar(20)
  ,dpam_sba_no varchar(16)
  ,isin  varchar(12)
  ,nsdhm_qty numeric (18,3)
  ,clopm_nsdl_rt  numeric(18,5)
  ,nsdhm_dpam_id bigint
  ,total_certificates int
  ,nsdhm_charge numeric(18,2)
  ,nsdhm_dp_charge numeric(18,2)
  ,ser_tax numeric(18,2))

  
  DECLARE @l_counter numeric
  , @l_count NUMERIC
  , @l_nsdhm_tratm_type_desc varchar(20)
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
       SELECT @l_nsdhm_tratm_type_desc = citrus_usr.FN_SPLITVAL(@l_val_by_row,1)
       --INSERT INTO #temp_bill (cdshm_tratm_type_desc) SELECT @l_nsdhm_tratm_type_desc
    end   
    IF @l_counter = 2
    begin
       SELECT @l_total_certificates = citrus_usr.FN_SPLITVAL(@l_val_by_row,1)
       --INSERT INTO #temp_bill (total_certificates) SELECT @l_total_certificates
    end
    
    IF @l_counter >= 3
    BEGIN

		INSERT INTO #temp_bill (nsdhm_book_naar_cd
	   ,dpam_sba_no
	   ,isin 
	   ,nsdhm_qty 
	   ,clopm_nsdl_rt
	   ,nsdhm_dpam_id
	   ,total_certificates)
	   SELECT @l_nsdhm_tratm_type_desc
	   ,@pa_dpam_sba
	   ,citrus_usr.FN_SPLITVAL(@l_val_by_row,1)
	   ,citrus_usr.FN_SPLITVAL(@l_val_by_row,2)
	   ,citrus_usr.FN_SPLITVAL(@l_val_by_row,3)
	   ,@pa_dpam_id
	   ,@l_total_certificates
	END    
    SET @l_counter = @l_counter + 1
  END
  
  --042 |*~|*|~*0|*~|*|~*A|*~|INE031D01011|*~|12|*~|23.9000|*~|*|~*A|*~|INE031D01011|*~|34|*~|23.9000|*~|*|~*
  
  
  
  

-- for dp charges

  ----transaction value wise charge
		update #temp_bill
		set    nsdhm_dp_charge   =  
		isnull(case when cham_val_pers  = 'V' then cham_charge_value* -1
		else case when (cham_charge_value/100)*(abs(nsdhm_qty)*clopm_nsdl_rt) <= cham_charge_minval then cham_charge_minval* -1
		else (cham_charge_value/100)*(abs(nsdhm_qty)*clopm_nsdl_rt) * -1 end
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
		AND   cham_charge_type = nsdhm_book_naar_cd
		AND   (abs(nsdhm_qty)*clopm_nsdl_rt >= cham_from_factor)  and (abs(nsdhm_qty)*clopm_nsdl_rt <= cham_to_factor)  
		and   cham_deleted_ind = 1
		and   dpc_deleted_ind = 1
		and   proc_deleted_ind = 1

  ----transaction value wise charge

 ----transaction qty wise charge
	update #temp_bill
	set    nsdhm_dp_charge   =  (nsdhm_dp_charge +
	isnull(cham_charge_value,0)) *  -1
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
	AND   cham_charge_type = nsdhm_book_naar_cd
	AND   (abs(nsdhm_qty) >= cham_from_factor)  and (abs(nsdhm_qty) <= cham_to_factor)  
	and   cham_deleted_ind = 1
	and   dpc_deleted_ind = 1
	and   proc_deleted_ind = 1
  ----transaction qtywise charge
  

		update #temp_bill 
		set  nsdhm_dp_charge = isnull(nsdhm_dp_charge,0) 
		+ isnull(case when total_certificates*cham_charge_value <= cham_charge_minval then cham_charge_minval * -1 
		else (total_certificates*cham_charge_value)* -1 end    ,0)
		from #temp_bill      
		,dp_charges_mstr
		,profile_charges
		,charge_mstr 
		where @pa_billing_dt >= dpc_eff_from_dt and  @pa_billing_dt <= dpc_eff_to_dt
		AND   dpc_dpm_id = @pa_dpm_id
		AND   dpc_profile_id = proc_profile_id
		AND   proc_slab_no  = cham_slab_no
		AND   isnull(cham_charge_graded,0) <> 1
		AND   cham_charge_baseon           = 'TRANSPERSLIP' 
		AND   nsdhm_book_naar_cd  in ('011','012','013')
		AND   cham_charge_type = nsdhm_book_naar_cd
		AND   (total_certificates >= cham_from_factor) and (total_certificates<= cham_to_factor) 
		and   cham_deleted_ind = 1
		and   dpc_deleted_ind = 1
		and   proc_deleted_ind = 1


		update #temp_bill 
		set  nsdhm_dp_charge = isnull(nsdhm_dp_charge,0) 
		+ isnull(case when total_certificates*cham_charge_value <= cham_charge_minval then cham_charge_minval * -1 
		else (total_certificates*cham_charge_value)* -1 end,0)
		from #temp_bill      
		,dp_charges_mstr
		,profile_charges
		,charge_mstr 
		where @pa_billing_dt >= dpc_eff_from_dt and  @pa_billing_dt <= dpc_eff_to_dt
		AND   dpc_dpm_id = @pa_dpm_id
		AND   dpc_profile_id = proc_profile_id
		AND   proc_slab_no  = cham_slab_no
		AND   isnull(cham_charge_graded,0) <> 1
		AND   cham_charge_baseon           = 'TRANSPERSLIP' 
		AND   nsdhm_book_naar_cd  in ('021','022','023')
		AND   cham_charge_type = nsdhm_book_naar_cd
		AND   (total_certificates >= cham_from_factor) and (total_certificates <= cham_to_factor) 
		and   cham_deleted_ind = 1
		and   dpc_deleted_ind = 1
		and   proc_deleted_ind = 1
-- for dp charges




-- for client charges  
      ----transaction value wise charge

		update #temp_bill  
		set    nsdhm_charge   =    
		isnull(case when cham_val_pers  = 'V' then cham_charge_value * -1   
		else case when (cham_charge_value/100)*(abs(nsdhm_qty)*clopm_nsdl_rt) <= cham_charge_minval then cham_charge_minval* -1  
		else (cham_charge_value/100)*(abs(nsdhm_qty)*clopm_nsdl_rt)* -1 end  
		end  ,0)  
		from #temp_bill        
		,client_dp_brkg  
		,profile_charges  
		,charge_mstr   
		where @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt  
		AND   nsdhm_dpam_id = clidb_dpam_id 
		AND   clidb_brom_id = proc_profile_id  
		AND   proc_slab_no  = cham_slab_no  
		AND   isnull(cham_charge_graded,0) <> 1  
		AND   cham_charge_baseon           = 'TV'   
		AND   cham_charge_type = nsdhm_book_naar_cd  
		AND   (abs(nsdhm_qty)*clopm_nsdl_rt >= cham_from_factor)  and (abs(nsdhm_qty)*clopm_nsdl_rt <= cham_to_factor)    
		and   cham_deleted_ind = 1  
		and   clidb_deleted_ind = 1  
		and   proc_deleted_ind = 1  
  ----transaction value wise charge
----transaction qty wise charge  

	 update #temp_bill  
	 set    nsdhm_charge   =  nsdhm_charge +  
	 isnull(cham_charge_value,0) * -1 
	 from #temp_bill        
	 ,client_dp_brkg  
	 ,profile_charges  
	 ,charge_mstr   
	 where @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt  
	 AND   nsdhm_dpam_id = clidb_dpam_id 
	 AND   clidb_brom_id = proc_profile_id  
	 AND   proc_slab_no  = cham_slab_no  
	 AND   isnull(cham_charge_graded,0) <> 1  
	 AND   cham_charge_baseon           = 'TQ'   
	 AND   cham_charge_type = nsdhm_book_naar_cd  
	 AND   (abs(nsdhm_qty) >= cham_from_factor)  and (abs(nsdhm_qty) <= cham_to_factor)    
	 and   cham_deleted_ind = 1  
	 and   clidb_deleted_ind = 1  
	 and   proc_deleted_ind = 1  
   
  ----transaction qtywise charge  

		update #temp_bill
		set nsdhm_charge = isnull(nsdhm_charge,0) + 
		isnull(case when total_certificates*cham_charge_value <= cham_charge_minval then cham_charge_minval * -1 
		else (total_certificates*cham_charge_value)* -1 end    ,0)  
		from #temp_bill        
		,client_dp_brkg  
		,profile_charges  
		,charge_mstr   
		where @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt  
		AND   nsdhm_dpam_id = clidb_dpam_id  
		AND   clidb_brom_id = proc_profile_id  
		AND   proc_slab_no  = cham_slab_no  
		AND   isnull(cham_charge_graded,0) <> 1  
		AND   cham_charge_baseon           = 'TRANSPERSLIP'   
		AND   nsdhm_book_naar_cd           in( '011','012','013')  
		AND   cham_charge_type      = nsdhm_book_naar_cd  
		AND   (total_certificates >= cham_from_factor) and (total_certificates<= cham_to_factor)   
		and   cham_deleted_ind = 1  
		and   clidb_deleted_ind = 1  
		and   proc_deleted_ind = 1  


		update #temp_bill
		set nsdhm_charge = isnull(nsdhm_charge,0) + 
		isnull(case when total_certificates*cham_charge_value <= cham_charge_minval then cham_charge_minval * -1 
		else (total_certificates*cham_charge_value)* -1 end    ,0)  
		from #temp_bill        
		,client_dp_brkg  
		,profile_charges  
		,charge_mstr   
		,remat_request_mstr  
		where @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt  
		AND   nsdhm_dpam_id = clidb_dpam_id  
		AND   clidb_brom_id = proc_profile_id  
		AND   proc_slab_no  = cham_slab_no  
		AND   isnull(cham_charge_graded,0) <> 1  
		AND   cham_charge_baseon           = 'TRANSPERSLIP'   
		AND   nsdhm_book_naar_cd           in( '021','022','023')  
		AND   cham_charge_type      = nsdhm_book_naar_cd  
		AND   (total_certificates >= cham_from_factor) and (total_certificates<= cham_to_factor)   
		and   cham_deleted_ind = 1  
		and   clidb_deleted_ind = 1  
		and   proc_deleted_ind = 1  

/*NEW CHARGES*/
		update #temp_bill
		set nsdhm_charge = isnull(nsdhm_charge,0) + 
		isnull(case when DEMRM_QTY *(CONVERT(NUMERIC(10,2),cham_charge_value)/CONVERT(NUMERIC(10,2),CHAM_CHARGE_MINVAL)) < DEMRM_TOTAL_CERTIFICATES*CHAM_PER_MIN then  DEMRM_TOTAL_CERTIFICATES*CHAM_PER_MIN * -1 
		else DEMRM_QTY *(CONVERT(NUMERIC(10,2),cham_charge_value)/CONVERT(NUMERIC(10,2),CHAM_CHARGE_MINVAL)) end    ,0)  
		from #temp_bill        
		,client_dp_brkg  
		,profile_charges  
		,charge_mstr   
		,demat_request_mstr  
		where @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt
		AND   DEMRM_REQUEST_DT >= clidb_eff_from_dt and  DEMRM_REQUEST_DT <= clidb_eff_to_dt  
		AND   nsdhm_dpam_id = clidb_dpam_id  
		AND   clidb_brom_id = proc_profile_id  
		AND   proc_slab_no  = cham_slab_no  
		AND   nsdhm_dpam_id = demrm_dpam_id  
		AND   isnull(cham_charge_graded,0) <> 1  
		AND   cham_charge_baseon           = 'CQ'   
		AND   nsdhm_book_naar_cd           in( '011','012','013')  
		AND   demrm_status                 = 'E'  
		AND   cham_charge_type      = nsdhm_book_naar_cd  
		and   cham_deleted_ind = 1  
		and   clidb_deleted_ind = 1  
	
		and   proc_deleted_ind = 1  
        and   CHAM_CHARGE_BASE = 'NORMAL'
		
		and   demrm_deleted_ind = 1
		/*NEW CHARGES*/

        
		update #temp_bill  set  nsdhm_charge = round(nsdhm_charge,2) 

			 

					

				
					IF EXISTS(SELECT bitrm_id FROM bitmap_ref_mstr WHERE bitrm_parent_cd = 'BILL_CLI_ADD_DP_CHRG_NSDL' AND BITRM_BIT_LOCATION = @pa_dpm_id AND BITRM_VALUES = 1 )
					BEGIN
						UPDATE #temp_bill 
						SET nsdhm_charge = isnull(nsdhm_charge,0) + isnull(nsdhm_dp_charge,0)
						where not exists(select clidb_dpam_id from client_dp_brkg,brokerage_mstr 
										where clidb_dpam_id = nsdhm_dpam_id 
										AND   clidb_brom_id = brom_id
										and   brom_desc = 'DUMMY'
										AND   @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt
										and   clidb_deleted_ind = 1 
										and   brom_deleted_ind =1)
	
					END
					
						
						
					 
					   --logic for charge on amount like service tax
					update #temp_bill
					set ser_tax = case when cham_val_pers  = 'V' then cham_charge_value* -1   
					else case when ABS((cham_charge_value/100)*nsdhm_charge) <= cham_charge_minval then cham_charge_minval* -1   
					else (cham_charge_value/100)*nsdhm_charge  end  
					end    
					from #temp_bill a
					,client_dp_brkg  
					,profile_charges  
					,charge_mstr 
					where @pa_billing_dt >= clidb_eff_from_dt and  @pa_billing_dt <= clidb_eff_to_dt  
					AND   a.nsdhm_dpam_id = clidb_dpam_id 
					AND   clidb_brom_id = proc_profile_id  
					AND   proc_slab_no  = cham_slab_no  
					AND   isnull(cham_charge_graded,0) <> 1  
					AND   cham_charge_type = 'AMT'   
					and   cham_deleted_ind = 1  
					and   clidb_deleted_ind = 1  
					and   proc_deleted_ind = 1  
				    --logic for charge on amount like service tax
  
					 
  --logic for transaction type wise charge
  
  
  select isnull(sum(isnull(Abs(nsdhm_charge),0) + isnull(Abs(ser_tax),0)),0) as charge_amt from #temp_bill
  
  
--
end

GO
