-- Object: PROCEDURE citrus_usr.pr_billing_main_nsdl_quant_closed
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--select * from dp_mstr
--begin tran
--pr_billing_main_nsdl 'feb 01 2009','feb 28 2009','IN303614','Y','N','B','HO'  
--rollback
CREATE procedure [citrus_usr].[pr_billing_main_nsdl_quant_closed]    
(@pa_billing_from_dt datetime    
,@pa_billing_to_dt   datetime    
,@pa_dp_id          varchar(16)    
,@pa_billing_status  CHAR(1)    
,@pa_posted_flg      char(1)    
,@pa_bill_post_shw_bill   char(1)--'P'-posting bill 'S' = show bill 'B' = billing    
,@pa_login_name   VARCHAR(20)    
    
)    
as    
begin    
--    
      

  declare  @dppostaccount numeric(10,0)    
         , @l_fin_id      int    
         , @l_ref_no      varchar(16)    
         , @l_sql         varchar(8000)    
         , @l_dpm_id      int    
         , @l_voucher_no  int    
         --set @l_sql          = @l_sql         +    
    
	
  select  dpam_id into #account_properties_cl from account_properties,dp_acct_mstr 
  where accp_accpm_prop_cd = 'ACC_CLOSE_DT' 
  and dpam_id = accp_clisba_id
  and accp_value between @pa_billing_from_dt and @pa_billing_to_dt
  and ltrim(rtrim(accp_value)) not in ('/ /', '/ /','','//') 
  and left(accp_value,2)<>'00'
      

  select @l_dpm_id = dpm_id from dp_mstr where dpm_dpid = @pa_dp_id and dpm_deleted_ind = 1     
    
  if @pa_bill_post_shw_bill  = 'B'    
  BEGIN    
  --    
    UPDATE nsdl_holding_dtls SET NSDHM_CHARGE = 0 , NSDHM_DP_CHARGE = 0 WHERE NSDHM_TRANSACTION_DT between  @pa_billing_from_dt and @pa_billing_to_dt AND NSDHM_DPM_ID = @l_dpm_id
  
    exec pr_billing_nsdl_dp @pa_billing_from_dt,@pa_billing_to_dt, @l_dpm_id,@pa_billing_status     
    
    exec pr_billing_nsdl  @pa_billing_from_dt,@pa_billing_to_dt, @l_dpm_id,@pa_billing_status      
    --    
   
        
     set @pa_bill_post_shw_bill  = 'S'    
         
     update Bill_cycle    
     set    billc_flg = 'Y'    
     where  billc_Dpm_id     = @l_dpm_id    
     AND    billc_from_dt    = @pa_billing_from_dt     
     AND    billc_to_dt      = @pa_billing_to_dt     
     AND    billc_deleted_ind      = 1    
  --    
  END    
  if @pa_bill_post_shw_bill  = 'S' or @pa_bill_post_shw_bill  = 'P'    
  BEGIN    
  --    
  
    create table  #main_bill    
    (id         int identity(1,1)    
    ,account_id numeric(10,0)    
    ,amount     money    
    ,acct_type char(1)
    ,Post_type VARchar(2)         
    )    
    
    --     
      INSERT INTO  #main_bill    
      SELECT clic_dpam_id,sum(clic_charge_amt),'P','C'    
      FROM client_charges_nsdl,#account_properties_cl    
      WHERE clic_dpm_id = @l_dpm_id     
	  and clic_dpam_id	= dpam_id
      AND clic_trans_dt between @pa_billing_from_dt and @pa_billing_to_dt     
      AND clic_deleted_ind =1    
      GROUP BY clic_dpam_id    
    
    
    
      INSERT INTO  #main_bill    
      SELECT clic_post_toacct,sum(clic_charge_amt) *-1 ,'G','C'     
      FROM client_charges_nsdl,#account_properties_cl   
      WHERE clic_dpm_id = @l_dpm_id    
	  and clic_dpam_id	= dpam_id 
      AND clic_trans_dt between @pa_billing_from_dt and @pa_billing_to_dt     
      AND clic_deleted_ind =1    
      GROUP BY clic_post_toacct    
    
    -- CHARGES FOR DP    
/*    
	  SELECT top 1 @dppostaccount = dpc_post_toacct FROM dp_charges_mstr WHERE dpc_dpm_id = @l_dpm_id AND @pa_billing_to_dt between dpc_eff_from_dt and dpc_eff_to_dt and dpc_deleted_ind =1

	  IF 	ISNULL(@dppostaccount,0) <> 0
	  BEGIN
		  INSERT INTO  #main_bill    
		  SELECT dpch_post_toacct=@dppostaccount,sum(dpch_charge_amt) * -1,'G','DP'     
		  FROM dp_charges_nsdl    
		  WHERE dpch_dpm_id     = @l_dpm_id     
		  AND   dpch_tranc_dt between @pa_billing_from_dt and @pa_billing_to_dt     
		  AND   dpch_deleted_ind =1    
		  GROUP BY dpch_dpm_id    
   
    
    
		  INSERT INTO #main_bill    
		  SELECT dpch_post_toacct,sum(dpch_charge_amt), 'G','D'    
		  FROM dp_charges_nsdl    
		  WHERE dpch_dpm_id     = @l_dpm_id     
		  AND dpch_tranc_dt between @pa_billing_from_dt and @pa_billing_to_dt     
		  AND dpch_deleted_ind  = 1    
		  GROUP BY dpch_post_toacct    
	  END  
*/
  -- CHARGES FOR DP    
   
    
       
    --    
    END    
    if @pa_bill_post_shw_bill  = 'S'     
    BEGIN    

    			SELECT account_id,fina_acc_code,fina_acc_name, dr_amount = case when amount < 0 then abs(amount) else 0 end , cr_amount = case when amount >= 0 then abs(amount) else 0 end ,acct_type , isnull(fina_branch_id,0) fina_branch_id,Post_type
    			from   #main_bill 
							left outer join 
							(SELECT fina_acc_id=DPAM_ID,fina_acc_code=DPAM_SBA_NO,fina_acc_name=DPAM_SBA_NAME,fina_acc_type='P',fina_branch_id=0 FROM DP_ACCT_MSTR
							 UNION
							 SELECT fina_acc_id,fina_acc_code,fina_acc_name,fina_acc_type,fina_branch_id FROM fin_account_mstr
							 ) T
							on account_id = fina_acc_id
 						    and fina_acc_type = acct_type
				ORDER BY  Post_type,acct_type   
    --    
    END    
    if @pa_bill_post_shw_bill  = 'P'     
    BEGIN    
    --    
	  declare @@l_led_id 	bigint,
	  @@l_posting_dt datetime  

	  Select @@l_posting_dt= isnull(billc_posting_dt,@pa_billing_to_dt) from bill_cycle where billc_from_dt = @pa_billing_from_dt and billc_to_dt =  @pa_billing_to_dt and billc_dpm_id = @l_dpm_id

      SELECT @l_fin_id = fin_id from financial_yr_mstr where fin_dpm_id = @l_dpm_id and @@l_posting_dt between fin_start_dt and fin_end_dt    
          
      SELECT @l_ref_no       = replace(convert(varchar(11),@pa_billing_from_dt,103),'/','') + replace(convert(varchar(11),@pa_billing_to_dt,103),'/','')     
	  SELECT @@l_led_id = ISNULL(COUNT(ID),0) FROM #main_bill

          
	  BEGIN TRAN
			update financial_yr_mstr set Ledger_currid = isnull(Ledger_currid,0) + @@l_led_id,VchNo_Bill = isnull(VchNo_Bill,0) + 1 where fin_id = @l_fin_id and FIN_DPM_ID = @l_dpm_id and fin_deleted_ind = 1
			select @l_voucher_no = ISNULL(VchNo_Bill,0) from financial_yr_mstr where fin_id = @l_fin_id and FIN_DPM_ID = @l_dpm_id and fin_deleted_ind = 1
	  COMMIT TRAN           
          
      if @pa_posted_flg    = 'Y'    
      BEGIN    
      --    
        set @l_sql          = 'UPDATE accountbal' + convert(varchar,@l_fin_id)    
        set @l_sql          = @l_sql         + ' SET    accbal_amount    =  accbal_amount - ldg_amount'     
        set @l_sql          = @l_sql         + ' from   ledger' + convert(varchar,@l_fin_id)  
        set @l_sql          = @l_sql         + ' , #account_properties_cl WHERE  accbal_dpm_id    = '+convert(varchar,@l_dpm_id)
        set @l_sql          = @l_sql         + ' and    accbal_acct_id   = ldg_account_id' 
		set @l_sql          = @l_sql         + ' and    dpam_id  = ldg_account_id'     
        set @l_sql          = @l_sql         + ' and    accbal_acct_TYPE = ldg_account_type'    
        set @l_sql          = @l_sql         + ' and    accbal_dpm_id    = ldg_dpm_id      '       
        set @l_sql          = @l_sql         + ' and    ldg_ref_no       = '''+ convert(varchar,@l_ref_no)  +''''    
    
        exec (@l_sql)    
    
        set @l_sql          = 'delete from ledger'+convert(varchar,@l_fin_id) +' where ldg_voucher_type = ''5'' and ldg_ref_no = ''' + convert(varchar,@l_ref_no) +''''    
            
        exec (@l_sql)    
      --    
      END    
          
  	  --set @l_sql          = 'declare @@L_Mac_id 	bigint '
	  --set @l_sql          = @l_sql + ' SELECT  @@L_Mac_id = isnull(max(ldg_id),0) FROM ledger'+convert(varchar,@l_fin_id)
      set @l_sql          = 'insert into ledger'+convert(varchar,@l_fin_id)    
      set @l_sql          = @l_sql + '(ldg_id'    
      set @l_sql          = @l_sql + ',ldg_dpm_id'    
      set @l_sql          = @l_sql + ',ldg_voucher_type'    
      set @l_sql          = @l_sql + ',ldg_book_type_cd'    
      set @l_sql          = @l_sql + ',ldg_voucher_no'    
      set @l_sql          = @l_sql + ',ldg_sr_no'    
      set @l_sql          = @l_sql + ',ldg_ref_no'    
      set @l_sql          = @l_sql + ',ldg_voucher_dt'    
      set @l_sql          = @l_sql + ',ldg_account_id'    
      set @l_sql          = @l_sql + ',ldg_branch_id'    
      set @l_sql          = @l_sql + ',ldg_account_type'    
      set @l_sql          = @l_sql + ',ldg_amount'    
      set @l_sql          = @l_sql + ',ldg_narration'    
      set @l_sql          = @l_sql + ',ldg_trans_type'    
      set @l_sql          = @l_sql + ',ldg_status'    
      set @l_sql          = @l_sql + ',ldg_created_by'    
      set @l_sql          = @l_sql + ',ldg_created_dt'    
      set @l_sql          = @l_sql + ',ldg_lst_upd_by'    
      set @l_sql          = @l_sql + ',ldg_lst_upd_dt'    
      set @l_sql          = @l_sql + ',ldg_deleted_ind'    
      set @l_sql          = @l_sql + ')'    
      set @l_sql          = @l_sql + 'select ' + CONVERT(VARCHAR,@@l_led_id) + ' + id'    
      set @l_sql          = @l_sql + ',' + convert(varchar,@l_dpm_id)    
      set @l_sql          = @l_sql + ',''5'''    
      set @l_sql          = @l_sql + ',''01'''    
      set @l_sql          = @l_sql + ',' + convert(varchar,@l_voucher_no)    
      set @l_sql          = @l_sql + ',id'    
      set @l_sql          = @l_sql + ',''' + @l_ref_no       + ''''    
      set @l_sql          = @l_sql + ',''' + convert(varchar,@@l_posting_dt) + ''''    
      set @l_sql          = @l_sql + ',account_id'    
      set @l_sql          = @l_sql + ',isnull(fina_branch_id,0)'    
      set @l_sql          = @l_sql + ',acct_type'    
      set @l_sql          = @l_sql + ',amount'    
      set @l_sql          = @l_sql + ',''BILL FOR ' + convert(varchar(11),@pa_billing_from_dt,109) + '-' + convert(varchar(11),@pa_billing_to_dt,109) + ''''    
      set @l_sql          = @l_sql + ',''N'''    
      set @l_sql          = @l_sql + ',''A'''    
      set @l_sql          = @l_sql + ','''+@pa_login_name   + ''''    
      set @l_sql          = @l_sql + ',getdate()'    
      set @l_sql          = @l_sql + ','''+@pa_login_name   + ''''    
      set @l_sql          = @l_sql + ',getdate()'    
      set @l_sql          = @l_sql + ',1'    
      set @l_sql          = @l_sql + ' from   #main_bill'     
      set @l_sql          = @l_sql + ' left outer join '    
      set @l_sql          = @l_sql + ' fin_account_mstr'    
      set @l_sql          = @l_sql + ' on account_id = FINA_ACC_ID'    
      set @l_sql          = @l_sql + ' and fina_acc_type = acct_type'    
          
     exec(@l_sql)    
         
         
     set @l_sql          = 'UPDATE accountbal' + convert(varchar,@l_fin_id)    
     set @l_sql          = @l_sql +' SET    accbal_amount    = accbal_amount +  amount'    
     set @l_sql          = @l_sql +' FROM   #main_bill'    
     set @l_sql          = @l_sql +' WHERE  accbal_dpm_id    = ' + convert(varchar,@l_dpm_id)    
     set @l_sql          = @l_sql +' and    accbal_acct_id   = account_id'    
     set @l_sql          = @l_sql +' AND    accbal_acct_TYPE = acct_type'    
         
         
     exec (@l_sql)    
    
     set @l_sql          = 'INSERT INTO accountbal'+ convert(varchar,@l_fin_id)    
     set @l_sql          = @l_sql +'(accbal_dpm_id'    
     set @l_sql          = @l_sql +',accbal_acct_id'    
     set @l_sql          = @l_sql +',accbal_acct_type'    
     set @l_sql          = @l_sql +',accbal_amount'    
     set @l_sql          = @l_sql +',accbal_created_by'    
     set @l_sql          = @l_sql +',accbal_created_dt'    
     set @l_sql          = @l_sql +',accbal_lst_upd__by'    
     set @l_sql          = @l_sql +',accbal_lst_upd__dt'    
     set @l_sql          = @l_sql +',accbal_deleted_ind'    
     set @l_sql          = @l_sql +')'    
     set @l_sql          = @l_sql +'SELECT ' + convert(varchar,@l_dpm_id)    
     set @l_sql          = @l_sql +', account_id'    
     set @l_sql          = @l_sql +', acct_type'    
     set @l_sql          = @l_sql +', amount'    
     set @l_sql          = @l_sql +','''+@pa_login_name   +''''    
     set @l_sql          = @l_sql +',GETDATE()'    
     set @l_sql          = @l_sql +','''+@pa_login_name   + ''''    
     set @l_sql          = @l_sql +',GETDATE()'    
     set @l_sql          = @l_sql +',1'    
     set @l_sql          = @l_sql +'from  #main_bill main'    
     set @l_sql          = @l_sql +' where NOT EXISTS(SELECT ACCBAL_DPM_ID FROM ACCOUNTBAL' + convert(varchar,@l_fin_id) + ' WHERE accbal_dpm_id = '+ convert(varchar,@l_dpm_id) +' and accbal_acct_id = main.account_id)'    
     exec (@l_sql)           
          
     update Bill_cycle    
     set    billc_posted_flg = 'Y'    
     where  billc_Dpm_id     = @l_dpm_id    
     AND    billc_from_dt    = @pa_billing_from_dt     
     AND    billc_to_dt      = @pa_billing_to_dt     
     AND    billc_deleted_ind      = 1    
         
     update financial_yr_mstr     
     set    fin_cf_balances = 'Y'    
     WHERE  fin_id          = @l_fin_id    
     and    FIN_DELETED_IND = 1    
     
          
    --    
    END    
        
          
--    
END

GO
