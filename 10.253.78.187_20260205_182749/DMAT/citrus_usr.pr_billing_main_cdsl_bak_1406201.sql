-- Object: PROCEDURE citrus_usr.pr_billing_main_cdsl_bak_1406201
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


--begin tran
--[pr_billing_main_cdsl] 'apr  1 2013','apr 30 2013','12010900','Y','N','S','MIG'
--select * from client_charges_cdsl where clic_trans_dt between 'apr 05 2013' and 'apr 05 2013'
--select top 100 * from ledger1 order by 1 desc
--rollback

CREATE procedure [citrus_usr].[pr_billing_main_cdsl_bak_1406201]
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
         , @l_ref_no      varchar(500)
			, @l_ref_no_class      varchar(500)
         , @l_sql         varchar(8000)
         , @l_dpm_id      int
         , @l_voucher_no  int
, @l_voucher_no_class  int
         --set @l_sql          = @l_sql         +

  
  select @l_dpm_id = dpm_id from dp_mstr where dpm_dpid = @pa_dp_id and dpm_deleted_ind = 1 
 
  if @pa_bill_post_shw_bill  = 'B'
  BEGIN
  --
	UPDATE cdsl_holding_dtls SET CDSHM_CHARGE = 0 , CDSHM_DP_CHARGE = 0 
    WHERE cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt AND CDSHM_DPM_ID = @l_dpm_id  
  
    --exec pr_billing_cdsl_dp @pa_billing_from_dt,@pa_billing_to_dt, @l_dpm_id,@pa_billing_status 
  
    exec pr_billing_cdsl  @pa_billing_from_dt,@pa_billing_to_dt, @l_dpm_id,@pa_billing_status  
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




create table #exceptionclient(entm_id numeric,entm_enttm_cd varchar(100),sba varchar(100))

if convert(varchar(11),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@pa_billing_from_dt)+1,0)),109) > convert(varchar(11),getdate(),109)
insert into #exceptionclient
select entm_id ,entm_enttm_cd,entr_sba   from entity_mstr with(nolock)
, exceptionclientforpost with(nolock)
, entity_relationship    with(nolock)
where entm_enttm_cd in ('br','ba') and replace(replace(entm_short_name ,'_br',''),'_ba','') = brcode
and (entr_br = entm_id  or entr_sb= entm_id ) 
and getdate() between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')

create index ix_1 on #exceptionclient (sba)
--alter table exceptionclientforpost alter column brcode varchar(500)
--
--select * FROM #main_bill 
--WHERE acct_type = 'p' 
--AND EXISTS(SELECT DPAM_ID FROM #exceptionclient,DP_ACCT_MSTR WHERE DPAM_SBA_NO = SBA AND ACCOUNT_ID = DPAM_ID )
--
--delete FROM #main_bill 
--WHERE acct_type = 'p' 
--AND EXISTS(SELECT DPAM_ID FROM #exceptionclient,DP_ACCT_MSTR WHERE DPAM_SBA_NO = SBA AND ACCOUNT_ID = DPAM_ID )
--  




				create table  #main_bill
				(id         numeric identity(1,1)
				,account_id numeric(10,0)
				,amount     money
				,acct_type char(1) 
				,Post_type VARchar(2) 
				,postdt datetime
				)



				-- 
						INSERT INTO  #main_bill
						SELECT clic_dpam_id,sum(clic_charge_amt),'P','C',@pa_billing_to_dt 
						FROM client_charges_cdsl
						WHERE clic_dpm_id     = @l_dpm_id 
						AND clic_trans_dt between @pa_billing_from_dt and @pa_billing_to_dt 
						AND clic_deleted_ind =1 and CLIC_FLG in ('S','M')
						AND not EXISTS(SELECT DPAM_ID FROM #exceptionclient,DP_ACCT_MSTR WHERE DPAM_SBA_NO = SBA AND clic_dpam_id = DPAM_ID )
						--GROUP BY clic_dpam_id,CLIC_TRANS_DT 
						GROUP BY clic_dpam_id

 


						INSERT INTO  #main_bill
						SELECT clic_post_toacct,sum(clic_charge_amt)  *-1,'G','C',@pa_billing_to_dt 
						FROM client_charges_cdsl
						WHERE clic_dpm_id     = @l_dpm_id 
						AND clic_trans_dt between @pa_billing_from_dt and @pa_billing_to_dt 
						AND clic_deleted_ind =1 and CLIC_FLG in ('S','M')
AND not EXISTS(SELECT DPAM_ID FROM #exceptionclient,DP_ACCT_MSTR WHERE DPAM_SBA_NO = SBA AND clic_dpam_id = DPAM_ID )
						--GROUP BY clic_post_toacct,CLIC_TRANS_DT 
						GROUP BY clic_post_toacct
						
						

				create table  #main_bill_class
				(id         int identity(1,1)
				,account_id numeric(10,0)
				,amount     money
				,acct_type char(1) 
				,Post_type VARchar(2) 
				,postdt datetime
				)



				-- 
						

						INSERT INTO  #main_bill_class
						SELECT clic_dpam_id,sum(clic_charge_amt),'P','C',@pa_billing_to_dt 
						FROM client_charges_cdsl
						WHERE clic_dpm_id     = @l_dpm_id 
						AND clic_trans_dt between @pa_billing_from_dt and @pa_billing_to_dt 
						AND clic_deleted_ind =1 and CLIC_FLG in ('B')
AND not EXISTS(SELECT DPAM_ID FROM #exceptionclient,DP_ACCT_MSTR WHERE DPAM_SBA_NO = SBA AND clic_dpam_id = DPAM_ID )
						--GROUP BY clic_dpam_id,CLIC_TRANS_DT 
						GROUP BY clic_dpam_id



						INSERT INTO  #main_bill_class
						SELECT clic_post_toacct,sum(clic_charge_amt)  *-1,'G','C',@pa_billing_to_dt 
						FROM client_charges_cdsl
						WHERE clic_dpm_id     = @l_dpm_id 
						AND clic_trans_dt between @pa_billing_from_dt and @pa_billing_to_dt 
						AND clic_deleted_ind =1 and CLIC_FLG in ('B')
AND not EXISTS(SELECT DPAM_ID FROM #exceptionclient,DP_ACCT_MSTR WHERE DPAM_SBA_NO = SBA AND clic_dpam_id = DPAM_ID )
						--GROUP BY clic_post_toacct,CLIC_TRANS_DT 
						GROUP BY clic_post_toacct



				-- CHARGES FOR DP
/*
						SELECT top 1 @dppostaccount = dpc_post_toacct FROM dp_charges_mstr WHERE dpc_dpm_id = @l_dpm_id AND @pa_billing_to_dt between dpc_eff_from_dt and dpc_eff_to_dt and dpc_deleted_ind =1



						IF 	ISNULL(@dppostaccount,0) <> 0
						BEGIN
						INSERT INTO  #main_bill
						SELECT dpch_post_toacct=@dppostaccount,sum(dpch_charge_amt)  *-1,'G','DP'
						FROM dp_charges_cdsl
						WHERE dpch_dpm_id     = @l_dpm_id 
						AND   dpch_tranc_dt between @pa_billing_from_dt and @pa_billing_to_dt 
						AND   dpch_deleted_ind =1
						GROUP BY dpch_dpm_id



						INSERT INTO #main_bill
						SELECT dpch_post_toacct,sum(dpch_charge_amt), 'G','D'
						FROM dp_charges_cdsl
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
    --
--    select top 75000 account_id
--,fina_acc_code
--,replace(fina_acc_name,'.','') fina_acc_name
--,dr_amount
--,cr_amount
--,acct_type
--,fina_branch_id
--,Post_type from billshowdata05032021
--    return
    			SELECT  account_id,fina_acc_code
    			--,fina_acc_name -- top 75350
    			,case when RIGHT(ltrim(rtrim(fina_acc_name )),4) = 'NULL' then  replace (replace(fina_acc_name,'NULL',''),',','') else  fina_acc_name end fina_acc_name
				, dr_amount = case when sum(amount) < 0 then abs(sum(amount)) else 0 end 
				, cr_amount = case when sum(amount) >= 0 then abs(sum(amount)) else 0 end 
				, acct_type 
				, isnull(fina_branch_id,0) fina_branch_id
				, Post_type
				--into billshowdata05032021
    			from   #main_bill 
							left outer join 
							(
							SELECT fina_acc_id=DPAM_ID,fina_acc_code=DPAM_SBA_NO,
							fina_acc_name=DPAM_SBA_NAME -- case when RIGHT(ltrim(rtrim(DPAM_SBA_NAME )),4) = 'NULL' then  replace (replace(DPAM_SBA_NAME,'NULL',''),',','') else  DPAM_SBA_NAME end 
							,fina_acc_type='P',fina_branch_id=0
							--SELECT fina_acc_id=DPAM_ID,fina_acc_code=DPAM_SBA_NO,fina_acc_name= DPAM_SBA_NAME  ,fina_acc_type='P',fina_branch_id=0
							 FROM DP_ACCT_MSTR
								UNION
							 SELECT fina_acc_id,fina_acc_code,fina_acc_name,fina_acc_type,fina_branch_id FROM fin_account_mstr
							 ) T
							on account_id = fina_acc_id
 						    and fina_acc_type = acct_type
				group by account_id,fina_acc_code,fina_acc_name,acct_type,fina_branch_id,Post_type
				ORDER BY  Post_type,acct_type 
 			--
 			END
    if @pa_bill_post_shw_bill  = 'P' 
 			BEGIN
 			--

print 'latesh'
alter table #main_bill add  dpm_id numeric
alter table #main_bill_class add  dpm_id numeric

update a set dpm_id = dpam_dpm_id   from #main_bill a left outer join dp_acct_mstr on account_id = dpam_id 
where acct_type ='P'

update a set dpm_id = fina_dpm_id  from #main_bill a left outer join fin_account_mstr on account_id = FINA_ACC_ID
where acct_type <>'P'


update a set dpm_id = dpam_dpm_id   from #main_bill_class a left outer join dp_acct_mstr on account_id = dpam_id 
where acct_type ='P'

update a set dpm_id = fina_dpm_id  from #main_bill_class a left outer join fin_account_mstr on account_id = FINA_ACC_ID
where acct_type <>'P'


	  		declare @@l_led_id 	numeric,
			@@l_posting_dt datetime, 
@@l_led_id1 	numeric

			Select @@l_posting_dt= isnull(billc_posting_dt,@pa_billing_to_dt) 
			from bill_cycle where billc_from_dt = @pa_billing_from_dt and billc_to_dt =  @pa_billing_to_dt 
			and billc_dpm_id = @l_dpm_id
 			  
			SELECT @l_fin_id = fin_id from financial_yr_mstr 
where --fin_dpm_id = @l_dpm_id and 
@@l_posting_dt between fin_start_dt and fin_end_dt
 			  print @l_fin_id 
 			SELECT @l_ref_no       = replace(convert(varchar(11),@pa_billing_from_dt,103),'/','') + replace(convert(varchar(11),@pa_billing_to_dt,103),'/','') 
						+ isnull(@pa_dp_id,'')
		  print @l_ref_no
		    SELECT @@l_led_id = COUNT(ISNULL(ID,0)) FROM #main_bill
		    SELECT @@l_led_id1 = ISNULL(Ledger_currid,0) + 1  
			FROM financial_yr_mstr where fin_id = @l_fin_id and fin_deleted_ind = 1




 			  print @@l_led_id 

			  BEGIN TRAN
					update financial_yr_mstr set Ledger_currid = isnull(Ledger_currid,0) + @@l_led_id + 1 ,VchNo_Bill = isnull(VchNo_Bill,0) + 1 where fin_id = @l_fin_id and fin_deleted_ind = 1
					select @l_voucher_no = ISNULL(VchNo_Bill,0) from financial_yr_mstr where fin_id = @l_fin_id  and fin_deleted_ind = 1
			  COMMIT TRAN
 			  
 			  
 			  if @pa_posted_flg    = 'Y'
 			  BEGIN
 			  --
								set @l_sql          = 'UPDATE accountbal' + convert(varchar,@l_fin_id)
								set @l_sql          = @l_sql         + ' SET    accbal_amount    =  accbal_amount - ldg_amount' 
								set @l_sql          = @l_sql         + ' from   ledger' + convert(varchar,@l_fin_id)
								set @l_sql          = @l_sql         + ' WHERE  accbal_dpm_id    = '+convert(varchar,@l_dpm_id)
								set @l_sql          = @l_sql         + ' and    accbal_acct_id   = ldg_account_id'
								set @l_sql          = @l_sql         + ' and    accbal_acct_TYPE = ldg_account_type'
								set @l_sql          = @l_sql         + ' and    accbal_dpm_id    = ldg_dpm_id      '   
								set @l_sql          = @l_sql         + ' and    ldg_ref_no       = '''+ @l_ref_no  +''''

								exec (@l_sql)

								set @l_sql          = 'delete from ledger'+convert(varchar,@l_fin_id) +' where ldg_ref_no = ''' + @l_ref_no +''''
								
								exec (@l_sql)
						--
						END
 			  

						--set @l_sql          = 'declare @@L_Mac_id 	bigint '
						--set @l_sql          = @l_sql + ' SELECT  @@L_Mac_id = isnull(max(ldg_id),0) FROM ledger'+convert(varchar,@l_fin_id)
						set @l_sql          =  ' insert into ledger'+convert(varchar,@l_fin_id)
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
					    set @l_sql          = @l_sql + 'select ' + CONVERT(VARCHAR,@@l_led_id1) + ' + id'
						set @l_sql          = @l_sql + ',' + convert(varchar,@l_dpm_id)
					    set @l_sql          = @l_sql + ',''5'''
						set @l_sql          = @l_sql + ',''01'''
						set @l_sql          = @l_sql + ',' + convert(varchar,@l_voucher_no)
						set @l_sql          = @l_sql + ',id'
						set @l_sql          = @l_sql + ',''' + @l_ref_no       + ''''
						set @l_sql          = @l_sql + ',postdt ' --CLIC_TRANS_DT
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
 				set @l_sql          = @l_sql +' from  #main_bill main'
 				set @l_sql          = @l_sql +' where NOT EXISTS(SELECT ACCBAL_DPM_ID FROM ACCOUNTBAL' + convert(varchar,@l_fin_id) + ' WHERE accbal_dpm_id = '+ convert(varchar,@l_dpm_id) +' and accbal_acct_id = main.account_id)'
 					exec (@l_sql)	


declare @@l_led_id_class 	bigint,
			@@l_posting_dt_class datetime 

			Select @@l_posting_dt_class= isnull(billc_posting_dt,@pa_billing_to_dt) 
			from bill_cycle where billc_from_dt = @pa_billing_from_dt and billc_to_dt =  @pa_billing_to_dt 
			and billc_dpm_id = @l_dpm_id
 			  
			SELECT @l_fin_id = fin_id from financial_yr_mstr 
where --fin_dpm_id = @l_dpm_id and 
@@l_posting_dt between fin_start_dt and fin_end_dt
 			  print @l_fin_id 
 			SELECT @l_ref_no_class       = 'CLASS-'+replace(convert(varchar(11),@pa_billing_from_dt,103),'/','') + replace(convert(varchar(11),@pa_billing_to_dt,103),'/','') 
						+ isnull(@pa_dp_id,'')
		  print @l_ref_no_class
		    SELECT @@l_led_id_class = COUNT(ISNULL(ID,0)) FROM #main_bill

 			  

			  BEGIN TRAN
					update financial_yr_mstr set Ledger_currid = isnull(Ledger_currid,0) + @@l_led_id_class,VchNo_Jv = isnull(VchNo_Jv,0) + 1 where fin_id = @l_fin_id and fin_deleted_ind = 1
					select @l_voucher_no_class = ISNULL(VchNo_Jv,0) from financial_yr_mstr where fin_id = @l_fin_id  and fin_deleted_ind = 1
			  COMMIT TRAN 				  

 			  
 			  
 			  if @pa_posted_flg    = 'Y'
 			  BEGIN
 			  --
								set @l_sql          = 'UPDATE accountbal' + convert(varchar,@l_fin_id)
								set @l_sql          = @l_sql         + ' SET    accbal_amount    =  accbal_amount - ldg_amount' 
								set @l_sql          = @l_sql         + ' from   ledger' + convert(varchar,@l_fin_id)
								set @l_sql          = @l_sql         + ' WHERE  accbal_dpm_id    = '+convert(varchar,@l_dpm_id)
								set @l_sql          = @l_sql         + ' and    accbal_acct_id   = ldg_account_id'
								set @l_sql          = @l_sql         + ' and    accbal_acct_TYPE = ldg_account_type'
								set @l_sql          = @l_sql         + ' and    accbal_dpm_id    = ldg_dpm_id      '   
								set @l_sql          = @l_sql         + ' and    ldg_ref_no       = '''+ @l_ref_no_class  +''''

								exec (@l_sql)

								set @l_sql          = 'delete from ledger'+convert(varchar,@l_fin_id) +' where ldg_ref_no = ''' + @l_ref_no_class +''''
								
								exec (@l_sql)
						--
						END
 			  

						--set @l_sql          = 'declare @@L_Mac_id 	bigint '
						--set @l_sql          = @l_sql + ' SELECT  @@L_Mac_id = isnull(max(ldg_id),0) FROM ledger'+convert(varchar,@l_fin_id)
						set @l_sql          =  ' insert into ledger'+convert(varchar,@l_fin_id)
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
					    set @l_sql          = @l_sql + 'select ' + CONVERT(VARCHAR,@@l_led_id1) + ' + id'
						set @l_sql          = @l_sql + ',' + convert(varchar,@l_dpm_id)
					    set @l_sql          = @l_sql + ',''3'''
						set @l_sql          = @l_sql + ',''01'''
						set @l_sql          = @l_sql + ',' + convert(varchar,@l_voucher_no_class)
						set @l_sql          = @l_sql + ',id'
						set @l_sql          = @l_sql + ',''' + @l_ref_no_class       + ''''
						set @l_sql          = @l_sql + ',postdt ' --CLIC_TRANS_DT
						set @l_sql          = @l_sql + ',account_id'
						set @l_sql          = @l_sql + ',isnull(fina_branch_id,0)'
						set @l_sql          = @l_sql + ',acct_type'
						set @l_sql          = @l_sql + ',amount'
						set @l_sql          = @l_sql + ',''RECIEPT FOR ' + convert(varchar(11),@pa_billing_from_dt,109) + '-' + convert(varchar(11),@pa_billing_to_dt,109) + ''''
						set @l_sql          = @l_sql + ',''N'''
						set @l_sql          = @l_sql + ',''A'''
						set @l_sql          = @l_sql + ','''+@pa_login_name   + ''''
						set @l_sql          = @l_sql + ',getdate()'
						set @l_sql          = @l_sql + ','''+@pa_login_name   + ''''
						set @l_sql          = @l_sql + ',getdate()'
						set @l_sql          = @l_sql + ',1'
 						set @l_sql          = @l_sql + ' from   #main_bill_class ' 
						set @l_sql          = @l_sql + ' left outer join '
						set @l_sql          = @l_sql + ' fin_account_mstr'
						set @l_sql          = @l_sql + ' on account_id = FINA_ACC_ID'
 					set @l_sql          = @l_sql + ' and fina_acc_type = acct_type'
 				exec(@l_sql)
 				
 				
					set @l_sql          = 'UPDATE accountbal' + convert(varchar,@l_fin_id)
					set @l_sql          = @l_sql +' SET    accbal_amount    = accbal_amount +  amount'
					set @l_sql          = @l_sql +' FROM   #main_bill_class '
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
 				set @l_sql          = @l_sql +' from  #main_bill_class main'
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
