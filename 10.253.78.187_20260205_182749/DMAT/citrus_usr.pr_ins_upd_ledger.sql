-- Object: PROCEDURE citrus_usr.pr_ins_upd_ledger
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--pr_ins_upd_ledger '0','INS','HO','2','1','01','0','2','10/07/2008','B|*~|1|*~|135|*~|*|~*P|*~|2664|*~|0|*~||*~|135|*~|34656|*~|NAR1|*~|*|~*|*~||*~|0|*~||*~||*~||*~||*~|*|~*',0,'*|~*','|*~|',''	
--pr_ins_upd_ledger	'0','INS','HO','2','1','01','0','22','14/07/2008','B|*~|1|*~|566|*~|*|~*P|*~|32744|*~|0|*~||*~|566|*~|5666|*~|ffffh|*~|*|~*|*~||*~|0|*~||*~||*~||*~||*~|*|~*',0,'*|~*','|*~|',''
CREATE PROCEDURE [citrus_usr].[pr_ins_upd_ledger](@pa_id              VARCHAR(8000)      
                                  ,@pa_action          VARCHAR(20)      
                                  ,@pa_login_name      VARCHAR(20)      
                                  ,@pa_dpm_id          VARCHAR(50)    
                                  ,@pa_voucher_type    varchar(2)    
                                  ,@pa_book_type_cd    VARCHAR(4)    
                                  ,@pa_voucher_no      varchar(10)    
                                  ,@pa_ref_no          VARCHAR(25)      
                                  ,@pa_voucher_dt      VARCHAR(11)    
                                  ,@pa_values          VARCHAR(8000)     
                                  ,@pa_chk_yn          INT      
                                  ,@rowdelimiter       CHAR(4)       = '*|~*'      
                                  ,@coldelimiter       CHAR(4)       = '|*~|'      
                                  ,@pa_errmsg          VARCHAR(8000) output      
 )      
AS    
BEGIN
DECLARE @@l_acct_type    CHAR(1)    
      , @@l_amount       numeric(18,2)    
      , @@l_account_id   varchar(30)      
      , @@l_branch_id    INT    
      , @@l_cheque       VARCHAR(15)     
      , @@l_narration    VARCHAr(250)    
      , @@l_led_id         NUMERIC(10,0)    
      , @@l_cost_cntr    Int    
      , @@l_acct_no      VARCHAR(25)
	  , @@fin_id		  varchar(10)
	  , @@currstring_value VARCHAR(8000)
	  , @@currstring_value2 VARCHAR(8000)
	  , @@ledgertable varchar(20)
	  , @@SSQL VARCHAR(8000)
	  , @@CTR INT
      , @@TOTALRECORDS INT
	  , @@delind char(1)
	  SET @@CTR = 1

	IF @PA_ACTION = 'APP' OR  @PA_ACTION = 'EDT'
	BEGIN
	 Create table #tmpvch(Acct_id bigint,dpm_id int,Vch_dt datetime,Vch_no bigint,Amt numeric(18,2),clrg_dt datetime)
	END

	IF @PA_ACTION = 'APP'  
	BEGIN
			  SET @@TOTALRECORDS = citrus_usr.ufn_countstring(@pa_id,@rowdelimiter)
			  WHILE @@CTR <= @@TOTALRECORDS
			  BEGIN
  					  SET @@currstring_value = citrus_usr.FN_SPLITVALWITHDELIMETER(@rowdelimiter,@pa_id,@@CTR) 
			  
					  set @pa_voucher_no   = citrus_usr.fn_splitval(@@currstring_value,1)    
					  set @pa_voucher_dt   = citrus_usr.fn_splitval(@@currstring_value,2)    
					  set @pa_voucher_type = citrus_usr.fn_splitval(@@currstring_value,3)    
					  set @pa_dpm_id       = citrus_usr.fn_splitval(@@currstring_value,4)    
					  set @pa_book_type_cd = citrus_usr.fn_splitval(@@currstring_value,5) 

					  IF @@CTR = 1
					  BEGIN
							SELECT @@fin_id = FIN_ID FROM FINANCIAL_YR_MSTR WHERE FIN_DPM_ID = @pa_dpm_id AND (CONVERT(DATETIME,@pa_voucher_dt,103) BETWEEN FIN_START_DT AND FIN_END_DT)AND FIN_DELETED_IND =1  
					  END

				
					  SET @@SSQL= 'Insert into #tmpvch(Acct_id,dpm_id,Vch_dt,Vch_no,Amt,clrg_dt)
									 select ldg_account_id,ldg_dpm_id,ldg_voucher_dt,ldg_voucher_no,ldg_amount,ldg_bank_cl_date
									 from ledger' + @@fin_id + ' where ldg_voucher_dt   = convert(datetime,''' + @pa_voucher_dt + ''',103)
									 and ldg_voucher_type = ' + @pa_voucher_type + ' and ldg_voucher_no   = ' + @pa_voucher_no + ' and ldg_dpm_id = ' + @pa_dpm_id 
					  EXEC(@@SSQL)
					  IF @@rowcount > 0
					  BEGIN    
							SET @@SSQL=   'Update ledger' + @@fin_id + '  
										  Set ldg_deleted_ind = 0  
										  WHERE ldg_voucher_no   = ' + @pa_voucher_no + '
										  AND   ldg_voucher_dt   = convert(datetime,''' + @pa_voucher_dt + ''',103)  
										  AND   ldg_dpm_id       = ' + @pa_dpm_id + '
										  AND   ldg_voucher_type = ' + @pa_voucher_type + '
										  AND   ldg_book_type_cd = ''' + @pa_book_type_cd + ''''
							EXEC(@@SSQL)


							SET @@SSQL = 'Update acbal 
										  SET accbal_amount = accbal_amount - Amt
										  FROM #tmpvch,ACCOUNTBAL' + @@fin_id + ' acbal
										  WHERE Acct_id = ACCBAL_ACCT_ID AND dpm_id = accbal_dpm_id'
							EXEC(@@SSQL)

 							truncate table #tmpvch
							drop table #tmpvch
					  END


						SET @@SSQL= 'Insert into ledger' + @@fin_id + ' (LDG_ID,LDG_DPM_ID,LDG_VOUCHER_TYPE,LDG_BOOK_TYPE_CD,LDG_VOUCHER_NO,LDG_SR_NO,LDG_REF_NO,LDG_VOUCHER_DT,LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,LDG_AMOUNT,LDG_NARRATION,LDG_BANK_ID,LDG_ACCOUNT_NO,LDG_INSTRUMENT_NO,LDG_BANK_CL_DATE,LDG_COST_CD_ID,LDG_BILL_BRKUP_ID,LDG_TRANS_TYPE,LDG_STATUS,LDG_CREATED_BY,LDG_CREATED_DT,LDG_LST_UPD_BY,LDG_LST_UPD_DT,LDG_DELETED_IND,LDG_BRANCH_ID)
									 select LDG_ID,LDG_DPM_ID,LDG_VOUCHER_TYPE,LDG_BOOK_TYPE_CD,LDG_VOUCHER_NO,LDG_SR_NO,LDG_REF_NO,LDG_VOUCHER_DT,LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,LDG_AMOUNT,LDG_NARRATION,LDG_BANK_ID,LDG_ACCOUNT_NO,LDG_INSTRUMENT_NO,LDG_BANK_CL_DATE,LDG_COST_CD_ID,LDG_BILL_BRKUP_ID,LDG_TRANS_TYPE,LDG_STATUS,LDG_CREATED_BY,LDG_CREATED_DT,LDG_LST_UPD_BY=''' + @pa_login_name + ''',LDG_LST_UPD_DT=getdate(),LDG_DELETED_IND=1,LDG_BRANCH_ID
									 from ledger' + @@fin_id + '_mak where ldg_voucher_dt   = convert(datetime,''' + @pa_voucher_dt + ''',103)
									 and ldg_voucher_type = ' + @pa_voucher_type + ' and ldg_voucher_no   = ' + @pa_voucher_no + ' and ldg_dpm_id = ' + @pa_dpm_id + ' and ldg_deleted_ind in (0,6)'
						EXEC(@@SSQL)

						SET @@SSQL=   'Update ledger' + @@fin_id + '_mak  
									  Set ldg_deleted_ind = LDG_DELETED_IND+1  
									  WHERE ldg_voucher_no   = ' + @pa_voucher_no + '
									  AND   ldg_voucher_dt   = convert(datetime,''' + @pa_voucher_dt + ''',103)  
									  AND   ldg_dpm_id       = ' + @pa_dpm_id + '
									  AND   ldg_voucher_type = ' + @pa_voucher_type + '
									  AND   ldg_book_type_cd = ''' + @pa_book_type_cd + ''' 
									  AND ldg_deleted_ind in (0,4,6)'
						EXEC(@@SSQL)

						SET @@SSQL =  'Update accbal
									   Set accbal_amount = accbal_amount + LDG_AMOUNT
									   FROM ACCOUNTBAL' + @@fin_id + ' accbal,ledger' + @@fin_id + '
									   where accbal_acct_id = ldg_account_id and accbal_dpm_id = LDG_DPM_ID
									   and ldg_voucher_no   = ' + @pa_voucher_no + '
									   and ldg_voucher_type = ' + @pa_voucher_type + ' 
									   and ldg_book_type_cd = ''' + @pa_book_type_cd + '''
									   and ldg_deleted_ind=1
									   and exists(select accbal_acct_id from ACCOUNTBAL' + @@fin_id + ' where accbal_acct_id = LDG_ACCOUNT_ID and accbal_dpm_id = LDG_DPM_ID and accbal_deleted_ind = 1)'
						EXEC(@@SSQL)

						SET @@SSQL =  'INSERT INTO ACCOUNTBAL' + @@fin_id + '(accbal_dpm_id,accbal_acct_id,accbal_acct_type,accbal_amount,accbal_created_by,accbal_created_dt,accbal_lst_upd__by,accbal_lst_upd__dt,accbal_deleted_ind)
									   SELECT LDG_DPM_ID,LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,LDG_AMOUNT,''' + @pa_login_name + ''',getdate(),''' + @pa_login_name + ''',getdate(),1
									   FROM ledger' + @@fin_id + ' WHERE ldg_voucher_dt = convert(datetime,''' + @pa_voucher_dt + ''',103)
									   and ldg_voucher_type = ' + @pa_voucher_type + ' and ldg_voucher_no = ' + @pa_voucher_no + ' and ldg_dpm_id = ' + @pa_dpm_id + ' and ldg_deleted_ind=1 
									   and not exists(select accbal_acct_id from ACCOUNTBAL' + @@fin_id + ' where accbal_acct_id = LDG_ACCOUNT_ID and accbal_dpm_id = LDG_DPM_ID and accbal_deleted_ind = 1)'
						EXEC(@@SSQL)

						SET @@CTR = @@CTR + 1
			END

				
			UPDATE FINANCIAL_YR_MSTR SET FIN_CF_BALANCES = 'Y' WHERE  FIN_ID = @@fin_id and FIN_DPM_ID = @pa_dpm_id and FIN_DELETED_IND =1  

	END
	IF @PA_ACTION = 'REJ'
	BEGIN
			  SET @@TOTALRECORDS = citrus_usr.ufn_countstring(@pa_id,@rowdelimiter)
			  WHILE @@CTR <= @@TOTALRECORDS
			  BEGIN
  					  SET @@currstring_value = citrus_usr.FN_SPLITVALWITHDELIMETER(@rowdelimiter,@pa_id,@@CTR) 
					  set @pa_voucher_no   = citrus_usr.fn_splitval(@@currstring_value,1)    
					  set @pa_voucher_dt   = citrus_usr.fn_splitval(@@currstring_value,2)    
					  set @pa_voucher_type = citrus_usr.fn_splitval(@@currstring_value,3)    
					  set @pa_dpm_id       = citrus_usr.fn_splitval(@@currstring_value,4)    
					  set @pa_book_type_cd = citrus_usr.fn_splitval(@@currstring_value,5)    
					  IF @@CTR = 1
					  BEGIN
							SELECT @@fin_id = FIN_ID FROM FINANCIAL_YR_MSTR WHERE FIN_DPM_ID = @pa_dpm_id AND (CONVERT(DATETIME,@pa_voucher_dt,103) BETWEEN FIN_START_DT AND FIN_END_DT)AND FIN_DELETED_IND =1  
					  END


					  Set @@ssql = 'update ledger' + @@fin_id + '_mak     
					  set    ldg_deleted_ind  = 3    
					  WHERE  ldg_voucher_no   = ' + @pa_voucher_no + '    
					  AND    ldg_voucher_dt   = convert(datetime,''' + @pa_voucher_dt + ''',103)   
					  AND    ldg_dpm_id       = ' + @pa_dpm_id + '   
					  AND    ldg_voucher_type = ' + @pa_voucher_type + '   
					  AND    ldg_book_type_cd = ''' + @pa_book_type_cd + '''
					  AND    ldg_deleted_ind in (0,4,6)'
					  exec(@@ssql)
					  SET @@CTR = @@CTR + 1
			  END
	END

	IF (@PA_ACTION = 'INS' OR @PA_ACTION = 'EDT' OR @PA_ACTION = 'DEL') 
	BEGIN
		SELECT @@fin_id = FIN_ID FROM FINANCIAL_YR_MSTR WHERE FIN_DPM_ID = @pa_dpm_id AND (CONVERT(DATETIME,@pa_voucher_dt,103) BETWEEN FIN_START_DT AND FIN_END_DT)AND FIN_DELETED_IND =1  
		IF @pa_chk_yn = 0 -- MASTER    
		BEGIN    
			SET @@ledgertable = 'Ledger' + + @@fin_id 
			SET @@delind = CASE WHEN @PA_ACTION = 'DEL'	THEN '0' ELSE '1' END 
		END
		ELSE
		BEGIN
			SET @@ledgertable = 'Ledger' + + @@fin_id + '_mak'		  
			SET @@delind = CASE WHEN @PA_ACTION = 'DEL'	THEN 4 WHEN  @PA_ACTION = 'EDT' THEN 6 ELSE 0 END 
		END		 
	END


	IF @PA_ACTION = 'INS'
	BEGIN

		  BEGIN TRANSACTION
		  UPDATE FINANCIAL_YR_MSTR SET Ledger_currid = isnull(Ledger_currid,0) + 3,VchNo_Payment=ISNULL(VchNo_Payment,0) + 1 WHERE fin_id = @@fin_id and fin_dpm_id = @pa_dpm_id and fin_deleted_ind =1
          SELECT @@l_led_id    = ISNULL(Ledger_currid,0)-2,@pa_voucher_no=VchNo_Payment FROM FINANCIAL_YR_MSTR WHERE fin_id = @@fin_id and fin_dpm_id = @pa_dpm_id and fin_deleted_ind =1
		  COMMIT TRANSACTION



				SET @@currstring_value = citrus_usr.FN_SPLITVALWITHDELIMETER(@rowdelimiter,@pa_values,1)  
				SET @@currstring_value2 = citrus_usr.FN_SPLITVALWITHDELIMETER(@rowdelimiter,@pa_values,2)  
				SET @@l_acct_type = citrus_usr.fn_splitval(@@currstring_value,1)                  
				SET @@l_account_id     = citrus_usr.fn_splitval(@@currstring_value,2)          
				SET @@l_amount    = convert(numeric(18,2),citrus_usr.fn_splitval(@@currstring_value,3))
				SET @@l_narration = citrus_usr.fn_splitval(@@currstring_value2,7) 

				SET @@SSQL = 'INSERT INTO ' + @@ledgertable + '(ldg_id,ldg_dpm_id,ldg_voucher_type,ldg_book_type_cd,ldg_voucher_no,ldg_sr_no,ldg_ref_no,ldg_voucher_dt,ldg_account_id,ldg_account_type,ldg_amount,ldg_narration,ldg_account_no,ldg_instrument_no,ldg_branch_id,ldg_cost_cd_id,ldg_bill_brkup_id,ldg_trans_type,ldg_status,ldg_created_by,ldg_created_dt,ldg_lst_upd_by,ldg_lst_upd_dt,ldg_deleted_ind)
				VALUES(' + convert(varchar,@@l_led_id) + ',' + @pa_dpm_id + ',' + @pa_voucher_type +',''' + @pa_book_type_cd + ''',' + @pa_voucher_no +',1 ,''' + @pa_ref_no + ''',convert(datetime,''' + @pa_voucher_dt+ ''',103) ,' + @@l_account_id  + ',''' + @@l_acct_type + ''',' + convert(varchar,@@l_amount) + ',''' + @@l_narration + ''',''' + isnull(@@l_acct_no,'') + ''','''',0,0,0 ,''N'',''P'' ,''' + @pa_login_name + ''',getdate(),''' + @pa_login_name+ ''',getdate(),' + @@delind + ')'     
--print @@SSQL
				EXEC(@@SSQL)
				
                set @pa_errmsg = 'Generated Voucher No :  '+ @pa_voucher_no

				IF @pa_chk_yn = 0 -- MASTER ONLY   
				BEGIN    
						SET @@SSQL =   'IF EXISTS(SELECT accbal_acct_id FROM ACCOUNTBAL' + @@fin_id + ' WHERE accbal_dpm_id = ' + @pa_dpm_id + ' and accbal_acct_id = ' + @@l_account_id + ' and accbal_deleted_ind = 1)    
										BEGIN    
												UPDATE ACCOUNTBAL' + @@fin_id + '     
												SET    accbal_amount = accbal_amount + ' + convert(varchar,@@l_amount) + '    
												WHERE  accbal_dpm_id  = ' + @pa_dpm_id + ' and accbal_acct_id = ' + @@l_account_id + ' and accbal_deleted_ind = 1
										END    
										ELSE    
										BEGIN    
												INSERT INTO ACCOUNTBAL' + @@fin_id + '(accbal_dpm_id,accbal_acct_id,accbal_acct_type,accbal_amount,accbal_created_by,accbal_created_dt,accbal_lst_upd__by,accbal_lst_upd__dt,accbal_deleted_ind)
												VALUES (' + @pa_dpm_id + ',' + @@l_account_id + ',''' + @@l_acct_type + ''',' + convert(varchar,@@l_amount) + ',''' + @pa_login_name + ''',getdate(),''' + @pa_login_name + ''',getdate(),1)    
										END'    
						EXEC(@@SSQL)
				END


				SET @@l_acct_type = citrus_usr.fn_splitval(@@currstring_value2,1)          
				SET @@l_account_id= citrus_usr.fn_splitval(@@currstring_value2,2)          
				--SET @@l_branch_id = citrus_usr.fn_splitval(@@currstring_value2,3)          
				--SET @@l_cost_cntr = citrus_usr.fn_splitval(@@currstring_value2,4)          
				SET @@l_amount    = convert(numeric(18,2),citrus_usr.fn_splitval(@@currstring_value2,5)) * -1   
				SET @@l_cheque    = citrus_usr.fn_splitval(@@currstring_value2,6)       
				SET @@l_acct_no   = '' --
				SET @@l_led_id  = @@l_led_id + 1

				SET @@SSQL = 'INSERT INTO ' + @@ledgertable + '(ldg_id,ldg_dpm_id,ldg_voucher_type,ldg_book_type_cd,ldg_voucher_no,ldg_sr_no,ldg_ref_no,ldg_voucher_dt,ldg_account_id,ldg_account_type,ldg_amount,ldg_narration,ldg_account_no,ldg_instrument_no,ldg_branch_id,ldg_cost_cd_id,ldg_bill_brkup_id,ldg_trans_type,ldg_status,ldg_created_by,ldg_created_dt,ldg_lst_upd_by,ldg_lst_upd_dt,ldg_deleted_ind)
				VALUES(' + convert(varchar,@@l_led_id)  + ',' + @pa_dpm_id + ',' + @pa_voucher_type +',''' + @pa_book_type_cd + ''',' + @pa_voucher_no +',2,''' + @pa_ref_no + ''',convert(datetime,''' + @pa_voucher_dt+ ''',103) ,' + @@l_account_id  + ',''' + @@l_acct_type + ''',' + convert(varchar,@@l_amount) + ',''' + @@l_narration + ''',''' + isnull(@@l_acct_no,'') + ''',''' + @@l_cheque + ''',0,0,0 ,''N'',''P'' ,''' + @pa_login_name + ''',getdate(),''' + @pa_login_name+ ''',getdate() ,' + @@delind + ')'     
				EXEC(@@SSQL)
print @@SSQL
				IF @pa_chk_yn = 0 -- MASTER ONLY   
				BEGIN    
						SET @@SSQL =   'IF EXISTS(SELECT accbal_acct_id FROM ACCOUNTBAL' + @@fin_id + ' WHERE accbal_dpm_id = ' + @pa_dpm_id + ' and accbal_acct_id = ' + @@l_account_id + ' and accbal_deleted_ind = 1)    
										BEGIN    
												UPDATE ACCOUNTBAL' + @@fin_id + '     
												SET    accbal_amount = accbal_amount + ' + convert(varchar,@@l_amount) + '    
												WHERE  accbal_dpm_id  = ' + @pa_dpm_id + ' and accbal_acct_id = ' + @@l_account_id + ' and accbal_deleted_ind = 1
										END    
										ELSE    
										BEGIN    
												INSERT INTO ACCOUNTBAL' + @@fin_id + '(accbal_dpm_id,accbal_acct_id,accbal_acct_type,accbal_amount,accbal_created_by,accbal_created_dt,accbal_lst_upd__by,accbal_lst_upd__dt,accbal_deleted_ind)
												VALUES (' + @pa_dpm_id + ',' + @@l_account_id + ',''' + @@l_acct_type + ''',' + convert(varchar,@@l_amount) + ',''' + @pa_login_name + ''',getdate(),''' + @pa_login_name + ''',getdate(),1)    
										END'    
						EXEC(@@SSQL)
						
						UPDATE FINANCIAL_YR_MSTR SET FIN_CF_BALANCES = 'Y' WHERE FIN_ID = @@fin_id and FIN_DPM_ID = @pa_dpm_id and FIN_DELETED_IND =1   
				END

				IF citrus_usr.ufn_countstring(@pa_values,@rowdelimiter) = 3
				BEGIN
					SET @@currstring_value2 = citrus_usr.FN_SPLITVALWITHDELIMETER(@rowdelimiter,@pa_values,3)  
					SET @@l_account_id= citrus_usr.fn_splitval(@@currstring_value2,2)          
					IF LTRIM(RTRIM(ISNULL(@@l_account_id,''))) <> ''
					BEGIN
					
							SET @@l_acct_type = citrus_usr.fn_splitval(@@currstring_value2,1)          

							--SET @@l_branch_id = citrus_usr.fn_splitval(@@currstring_value2,3)          
							--SET @@l_cost_cntr = citrus_usr.fn_splitval(@@currstring_value2,4)          
							SET @@l_amount    = convert(numeric(18,2),citrus_usr.fn_splitval(@@currstring_value2,5)) * -1   
							SET @@l_cheque    = citrus_usr.fn_splitval(@@currstring_value2,6)       
							SET @@l_acct_no   = '' --citrus_usr.fn_splitval(@@currstring_value2,8)
							SET @@l_narration = citrus_usr.fn_splitval(@@currstring_value2,7)     
							SET @@l_led_id  = @@l_led_id + 1
							SET @@SSQL = 'INSERT INTO ' + @@ledgertable + '(ldg_id,ldg_dpm_id,ldg_voucher_type,ldg_book_type_cd,ldg_voucher_no,ldg_sr_no,ldg_ref_no,ldg_voucher_dt,ldg_account_id,ldg_account_type,ldg_amount,ldg_narration,ldg_account_no,ldg_instrument_no,ldg_branch_id,ldg_cost_cd_id,ldg_bill_brkup_id,ldg_trans_type,ldg_status,ldg_created_by,ldg_created_dt,ldg_lst_upd_by,ldg_lst_upd_dt,ldg_deleted_ind)
							VALUES(' + convert(varchar,@@l_led_id)  + ',' + @pa_dpm_id + ',' + @pa_voucher_type +',''' + @pa_book_type_cd + ''',' + @pa_voucher_no +',3,''' + @pa_ref_no + ''',convert(datetime,''' + @pa_voucher_dt+ ''',103) ,' + @@l_account_id  + ',''' + @@l_acct_type + ''',' + convert(varchar,@@l_amount) + ',''' + @@l_narration + ''',''' + isnull(@@l_acct_no,'') + ''',''' + @@l_cheque + ''',0,0,0 ,''N'',''P'' ,''' + @pa_login_name + ''',getdate(),''' + @pa_login_name+ ''',getdate() ,' + @@delind + ')'     
							EXEC(@@SSQL)

							IF @pa_chk_yn = 0 -- MASTER ONLY   
							BEGIN    
									SET @@SSQL =   'IF EXISTS(SELECT accbal_acct_id FROM ACCOUNTBAL' + @@fin_id + ' WHERE accbal_dpm_id = ' + @pa_dpm_id + ' and accbal_acct_id = ' + @@l_account_id + ' and accbal_deleted_ind = 1)    
													BEGIN    
															UPDATE ACCOUNTBAL' + @@fin_id + '     
															SET    accbal_amount = accbal_amount + ' + convert(varchar,@@l_amount) + '    
															WHERE  accbal_dpm_id  = ' + @pa_dpm_id + ' and accbal_acct_id = ' + @@l_account_id + ' and accbal_deleted_ind = 1
													END    
													ELSE    
													BEGIN    
															INSERT INTO ACCOUNTBAL' + @@fin_id + '(accbal_dpm_id,accbal_acct_id,accbal_acct_type,accbal_amount,accbal_created_by,accbal_created_dt,accbal_lst_upd__by,accbal_lst_upd__dt,accbal_deleted_ind)
															VALUES (' + @pa_dpm_id + ',' + @@l_account_id + ',''' + @@l_acct_type + ''',' + convert(varchar,@@l_amount) + ',''' + @pa_login_name + ''',getdate(),''' + @pa_login_name + ''',getdate(),1)    
													END'    
									EXEC(@@SSQL)
							END
					END
				END
	END

	IF @PA_ACTION = 'EDT'
	BEGIN

				SET @@SSQL= 'Insert into #tmpvch(Acct_id,dpm_id,Vch_dt,Vch_no,Amt,clrg_dt)
							 select ldg_account_id,ldg_dpm_id,ldg_voucher_dt,ldg_voucher_no,ldg_amount,ldg_bank_cl_date
							 from ledger' + @@fin_id + ' where ldg_voucher_dt   = convert(datetime,''' + @pa_voucher_dt + ''',103)
							 and ldg_voucher_type = ' + @pa_voucher_type + ' and ldg_voucher_no   = ' + @pa_voucher_no + ' and ldg_dpm_id = ' + @pa_dpm_id 
				EXEC(@@SSQL)

                SET @@SSQL=   'DELETE FROM  ' + @@ledgertable + '    
							  WHERE ldg_voucher_no   = ' + @pa_voucher_no + '
							  AND   ldg_dpm_id       = ' + @pa_dpm_id + '
							  AND   ldg_voucher_type = ' + @pa_voucher_type + '
							  AND   ldg_book_type_cd = ''' + @pa_book_type_cd + ''''
				EXEC(@@SSQL)

				IF @pa_chk_yn = 0 -- MASTER ONLY   
				BEGIN  
						SET @@SSQL = 'Update acbal 
									  SET accbal_amount = accbal_amount - Amt
									  FROM #tmpvch,ACCOUNTBAL' + @@fin_id + ' acbal
									  WHERE Acct_id = accbal_acct_id AND dpm_id = accbal_dpm_id'
						EXEC(@@SSQL)


				END

				SET @@SSQL = 'Update ldg 
							  SET ldg_bank_cl_date = clrg_dt
							  FROM #tmpvch,' + @@ledgertable + ' ldg
							  WHERE Acct_id = ldg_account_id and dpm_id = ldg_dpm_id
							  and ldg_voucher_no = Vch_no and ldg_voucher_dt = Vch_dt
							  and ldg_voucher_no   = ' + @pa_voucher_no + '
							  and ldg_voucher_type = ' + @pa_voucher_type + ' 
							  and ldg_book_type_cd = ''' + @pa_book_type_cd + '''
							  and ldg_amount = Amt'
				EXEC(@@SSQL)
 			    truncate table #tmpvch
			    drop table #tmpvch
				
				
			  BEGIN TRANSACTION
			  UPDATE FINANCIAL_YR_MSTR SET Ledger_currid = isnull(Ledger_currid,0) + 3 WHERE fin_id = @@fin_id and fin_dpm_id = @pa_dpm_id and fin_deleted_ind =1
			  SELECT @@l_led_id    = ISNULL(Ledger_currid,0) -2 FROM FINANCIAL_YR_MSTR WHERE fin_id = @@fin_id and fin_dpm_id = @pa_dpm_id and fin_deleted_ind =1
			  COMMIT TRANSACTION

				
				SET @@currstring_value = citrus_usr.FN_SPLITVALWITHDELIMETER(@rowdelimiter,@pa_values,1)  
				SET @@currstring_value2 = citrus_usr.FN_SPLITVALWITHDELIMETER(@rowdelimiter,@pa_values,2)  
				SET @@l_acct_type = citrus_usr.fn_splitval(@@currstring_value,1)                  
				SET @@l_account_id     = citrus_usr.fn_splitval(@@currstring_value,2)          
				SET @@l_amount    = convert(numeric(18,2),citrus_usr.fn_splitval(@@currstring_value,3))
				SET @@l_narration = citrus_usr.fn_splitval(@@currstring_value2,7)     
				SET @@SSQL = 'INSERT INTO ' + @@ledgertable + '(ldg_id,ldg_dpm_id,ldg_voucher_type,ldg_book_type_cd,ldg_voucher_no,ldg_sr_no,ldg_ref_no,ldg_voucher_dt,ldg_account_id,ldg_account_type,ldg_amount,ldg_narration,ldg_account_no,ldg_instrument_no,ldg_branch_id,ldg_cost_cd_id,ldg_bill_brkup_id,ldg_trans_type,ldg_status,ldg_created_by,ldg_created_dt,ldg_lst_upd_by,ldg_lst_upd_dt,ldg_deleted_ind)
				VALUES(' + convert(varchar,@@l_led_id) + ',' + @pa_dpm_id + ',''' + @pa_voucher_type +''',''' + @pa_book_type_cd + ''',''' + @pa_voucher_no +''',1 ,''' + @pa_ref_no + ''',convert(datetime,''' + @pa_voucher_dt+ ''',103) ,' + @@l_account_id  + ',''' + @@l_acct_type + ''',' + convert(varchar,@@l_amount) + ',''' + @@l_narration + ''',''' + isnull(@@l_acct_no,'') + ''','''',0,0,0 ,''N'',''P'' ,''' + @pa_login_name + ''',getdate(),''' + @pa_login_name+ ''',getdate() ,' + @@delind + ')'     
				EXEC(@@SSQL)

				IF @pa_chk_yn = 0 -- MASTER ONLY   
				BEGIN    
						SET @@SSQL =   'IF EXISTS(SELECT accbal_acct_id FROM ACCOUNTBAL' + @@fin_id + ' WHERE accbal_dpm_id = ' + @pa_dpm_id + ' and accbal_acct_id = ' + @@l_account_id + ')    
										BEGIN    
												UPDATE ACCOUNTBAL' + @@fin_id + '     
												SET    accbal_amount = accbal_amount + ' + convert(varchar,@@l_amount) + '    
												WHERE  accbal_dpm_id  = ' + @pa_dpm_id + ' and accbal_acct_id = ' + @@l_account_id + '
										END    
										ELSE    
										BEGIN    
												INSERT INTO ACCOUNTBAL' + @@fin_id + '(accbal_dpm_id,accbal_acct_id,accbal_acct_type,accbal_amount,accbal_created_by,accbal_created_dt,accbal_lst_upd__by,accbal_lst_upd__dt,accbal_deleted_ind)
												VALUES (' + @pa_dpm_id + ',' + @@l_account_id + ',''' + @@l_acct_type + ''',' + convert(varchar,@@l_amount) + ',''' + @pa_login_name + ''',getdate(),''' + @pa_login_name + ''',getdate(),1)    
										END'    
						EXEC(@@SSQL)
				END

				SET @@l_acct_type = citrus_usr.fn_splitval(@@currstring_value2,1)          
				SET @@l_account_id= citrus_usr.fn_splitval(@@currstring_value2,2)          
				SET @@l_branch_id = citrus_usr.fn_splitval(@@currstring_value2,3)          
				SET @@l_cost_cntr = citrus_usr.fn_splitval(@@currstring_value2,4)          
				SET @@l_amount    = convert(numeric(18,2),citrus_usr.fn_splitval(@@currstring_value2,5)) * -1   
				SET @@l_cheque    = citrus_usr.fn_splitval(@@currstring_value2,6)       
				SET @@l_acct_no   = citrus_usr.fn_splitval(@@currstring_value2,8)
				SET @@l_led_id  = @@l_led_id + 1

				SET @@SSQL = 'INSERT INTO ' + @@ledgertable + '(ldg_id,ldg_dpm_id,ldg_voucher_type,ldg_book_type_cd,ldg_voucher_no,ldg_sr_no,ldg_ref_no,ldg_voucher_dt,ldg_account_id,ldg_account_type,ldg_amount,ldg_narration,ldg_account_no,ldg_instrument_no,ldg_branch_id,ldg_cost_cd_id,ldg_bill_brkup_id,ldg_trans_type,ldg_status,ldg_created_by,ldg_created_dt,ldg_lst_upd_by,ldg_lst_upd_dt,ldg_deleted_ind)
				VALUES(' + convert(varchar,@@l_led_id)  + ',' + @pa_dpm_id + ',''' + @pa_voucher_type +''',''' + @pa_book_type_cd + ''',''' + @pa_voucher_no +''',2,''' + @pa_ref_no + ''',convert(datetime,''' + @pa_voucher_dt+ ''',103) ,' + @@l_account_id  + ',''' + @@l_acct_type + ''',' + convert(varchar,@@l_amount) + ',''' + @@l_narration + ''',''' + isnull(@@l_acct_no,'') + ''',''' + @@l_cheque + ''',0,0,0 ,''N'',''P'' ,''' + @pa_login_name + ''',getdate(),''' + @pa_login_name+ ''',getdate() ,' + @@delind + ')'     
				EXEC(@@SSQL)

				IF @pa_chk_yn = 0 -- MASTER ONLY   
				BEGIN    
						SET @@SSQL =   'IF EXISTS(SELECT accbal_acct_id FROM ACCOUNTBAL' + @@fin_id + ' WHERE accbal_dpm_id = ' + @pa_dpm_id + ' and accbal_acct_id = ' + @@l_account_id + ')    
										BEGIN    
												UPDATE ACCOUNTBAL' + @@fin_id + '     
												SET    accbal_amount = accbal_amount + ' + convert(varchar,@@l_amount) + '    
												WHERE  accbal_dpm_id  = ' + @pa_dpm_id + ' and accbal_acct_id = ' + @@l_account_id + '
										END    
										ELSE    
										BEGIN    
												INSERT INTO ACCOUNTBAL' + @@fin_id + '(accbal_dpm_id,accbal_acct_id,accbal_acct_type,accbal_amount,accbal_created_by,accbal_created_dt,accbal_lst_upd__by,accbal_lst_upd__dt,accbal_deleted_ind)
												VALUES (' + @pa_dpm_id + ',' + @@l_account_id + ',''' + @@l_acct_type + ''',' + convert(varchar,@@l_amount) + ',''' + @pa_login_name + ''',getdate(),''' + @pa_login_name + ''',getdate(),1)    
										END'    
						EXEC(@@SSQL)
						
						UPDATE FINANCIAL_YR_MSTR SET FIN_CF_BALANCES = 'Y' WHERE  FIN_ID = @@fin_id and FIN_DPM_ID = @pa_dpm_id and FIN_DELETED_IND =1  
				END
				IF citrus_usr.ufn_countstring(@pa_values,@rowdelimiter) = 3
				BEGIN
					SET @@currstring_value2 = citrus_usr.FN_SPLITVALWITHDELIMETER(@rowdelimiter,@pa_values,3)  
					SET @@l_acct_type = citrus_usr.fn_splitval(@@currstring_value2,1)          
					SET @@l_account_id= citrus_usr.fn_splitval(@@currstring_value2,2)          
					SET @@l_branch_id = citrus_usr.fn_splitval(@@currstring_value2,3)          
					SET @@l_cost_cntr = citrus_usr.fn_splitval(@@currstring_value2,4)          
					SET @@l_amount    = convert(numeric(18,2),citrus_usr.fn_splitval(@@currstring_value2,5)) * -1   
					SET @@l_cheque    = citrus_usr.fn_splitval(@@currstring_value2,6)       
					SET @@l_acct_no   = citrus_usr.fn_splitval(@@currstring_value2,8)
					SET @@l_led_id  = @@l_led_id + 1
					SET @@SSQL = 'INSERT INTO ' + @@ledgertable + '(ldg_id,ldg_dpm_id,ldg_voucher_type,ldg_book_type_cd,ldg_voucher_no,ldg_sr_no,ldg_ref_no,ldg_voucher_dt,ldg_account_id,ldg_account_type,ldg_amount,ldg_narration,ldg_account_no,ldg_instrument_no,ldg_branch_id,ldg_cost_cd_id,ldg_bill_brkup_id,ldg_trans_type,ldg_status,ldg_created_by,ldg_created_dt,ldg_lst_upd_by,ldg_lst_upd_dt,ldg_deleted_ind)
					VALUES(' + convert(varchar,@@l_led_id)  + ',' + @pa_dpm_id + ',''' + @pa_voucher_type +''',''' + @pa_book_type_cd + ''',''' + @pa_voucher_no +''',2,''' + @pa_ref_no + ''',convert(datetime,''' + @pa_voucher_dt+ ''',103) ,' + @@l_account_id  + ',''' + @@l_acct_type + ''',' + convert(varchar,@@l_amount) + ',''' + @@l_narration + ''',''' + isnull(@@l_acct_no,'') + ''',''' + @@l_cheque + ''',0,0,0 ,''N'',''P'' ,''' + @pa_login_name + ''',getdate(),''' + @pa_login_name+ ''',getdate() ,' + @@delind + ')'     
					EXEC(@@SSQL)

					IF @pa_chk_yn = 0 -- MASTER ONLY   
					BEGIN    
							SET @@SSQL =   'IF EXISTS(SELECT accbal_acct_id FROM ACCOUNTBAL' + @@fin_id + ' WHERE accbal_dpm_id = ' + @pa_dpm_id + ' and accbal_acct_id = ' + @@l_account_id + ' and accbal_deleted_ind = 1)    
											BEGIN    
													UPDATE ACCOUNTBAL' + @@fin_id + '     
													SET    accbal_amount = accbal_amount + ' + convert(varchar,@@l_amount) + '    
													WHERE  accbal_dpm_id  = ' + @pa_dpm_id + ' and accbal_acct_id = ' + @@l_account_id + ' and accbal_deleted_ind = 1
											END    
											ELSE    
											BEGIN    
													INSERT INTO ACCOUNTBAL' + @@fin_id + '(accbal_dpm_id,accbal_acct_id,accbal_acct_type,accbal_amount,accbal_created_by,accbal_created_dt,accbal_lst_upd__by,accbal_lst_upd__dt,accbal_deleted_ind)
													VALUES (' + @pa_dpm_id + ',' + @@l_account_id + ',''' + @@l_acct_type + ''',' + convert(varchar,@@l_amount) + ',''' + @pa_login_name + ''',getdate(),''' + @pa_login_name + ''',getdate(),1)    
											END'    
							EXEC(@@SSQL)
					END
			END

	END
	IF @PA_ACTION = 'DEL'
	BEGIN
				IF @pa_chk_yn = 0 -- MASTER ONLY   
				BEGIN    

					  SET @@SSQL= 'UPDATE accb        
					  SET    accbal_amount  = accbal_amount - ldg_amount 
					  FROM   ACCOUNTBAL' + @@fin_id + ' accb, ' + @@ledgertable + '
					  WHERE  ldg_account_id   = accbal_acct_id  
					  AND	 ldg_dpm_id		  = accbal_dpm_id         
					  AND    ldg_account_type = accbal_acct_type     
					  AND    ldg_voucher_no   = ' + @pa_voucher_no + '      
					  AND    ldg_dpm_id       = ' + @pa_dpm_id + ' 
					  AND    ldg_voucher_type = ' + @pa_voucher_type + '
					  AND    ldg_voucher_dt   = convert(datetime,''' + @pa_voucher_dt + ''',103)'
					  EXEC(@@SSQL)
     
					  UPDATE FINANCIAL_YR_MSTR SET FIN_CF_BALANCES = 'Y' WHERE FIN_ID = @@fin_id and FIN_DPM_ID = @pa_dpm_id and FIN_DELETED_IND =1                 

			    END    


					  SET @@SSQL= 'UPDATE ' + @@ledgertable  + '  
					  set    ldg_deleted_ind = ' + @@delind + '    
						   , ldg_lst_upd_by = ''' + @pa_login_name + '''
						   , ldg_lst_upd_dt = getdate()    
					  WHERE  ldg_voucher_type = ' + @pa_voucher_type + '
					  AND    ldg_voucher_no   = ' + @pa_voucher_no + '
					  AND    ldg_voucher_dt   = convert(datetime,''' + @pa_voucher_dt + ''',103)        
					  AND    ldg_dpm_id       = ' + @pa_dpm_id                      
					  EXEC(@@SSQL)              
			


	END




END

GO
