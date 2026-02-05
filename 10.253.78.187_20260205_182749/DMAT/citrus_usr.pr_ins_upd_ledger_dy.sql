-- Object: PROCEDURE citrus_usr.pr_ins_upd_ledger_dy
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_ins_upd_ledger_dy](@pa_id              VARCHAR(8000)        
                                 ,@pa_action          VARCHAR(20)        
                                 ,@pa_login_name      VARCHAR(20)        
                                 ,@pa_dpm_id          NUMERIC      
                                 ,@pa_voucher_type    INT      
                                 ,@pa_book_type_cd    VARCHAR(4)      
                                 ,@pa_voucher_no      NUMERIC      
                                 ,@pa_ref_no          VARCHAR(25)        
                                 ,@pa_voucher_dt      VARCHAR(11)      
                                 ,@pa_values          VARCHAR(8000)       
                                 ,@pa_chk_yn          INT        
                                 ,@rowdelimiter       CHAR(4)       = '*|~*'        
                                 ,@coldelimiter       CHAR(4)       = '|*~|'        
                                 ,@pa_errmsg          VARCHAR(8000) output        
 )        
AS      
/*      
*********************************************************************************      
 SYSTEM         : dp      
 MODULE NAME    : pr_ins_upd_ledge      
 DESCRIPTION    : this procedure will contain the maker checker facility for leger      
 COPYRIGHT(C)   : marketplace technologies       
 VERSION HISTORY: 1.0      
 VERS.  AUTHOR            DATE          REASON      
 -----  -------------     ------------  --------------------------------------------      
 1.0    TUSHAR            22-JAN-2008   VERSION.      
-----------------------------------------------------------------------------------*/      
BEGIN      
--      
DECLARE @t_errorstr      VARCHAR(8000)      
      , @l_error         BIGINT      
      , @delimeter       VARCHAR(10)      
      , @remainingstring VARCHAR(8000)      
      , @currstring      VARCHAR(8000)      
      , @foundat         INTEGER      
      , @delimeterlength INT      
      , @l_dptd_id       NUMERIC      
      , @l_dptdm_id      NUMERIC      
      , @delimeter_value varchar(10)      
      , @delimeterlength_value varchar(10)      
      , @remainingstring_value varchar(8000)      
      , @currstring_value varchar(8000)      
      , @l_access1       int      
      , @l_access        int      
      , @l_excm_id       numeric      
      , @l_excm_cd       VARCHAR(500)      
      , @l_dpm_id        NUMERIC      
      , @l_deleted_ind   smallint      
      , @l_dpam_id       numeric      
      , @line_no         NUMERIC      
      , @l_tr_dpid       VARCHAR(25)       
      , @l_tr_sett_type  VARCHAR(50)      
      , @l_tr_setm_no    VARCHAR(50)      
      , @l_isin          VARCHAR(25)       
      , @l_qty           VARCHAR(25)       
      , @l_trastm_id     VARCHAR(25)      
      , @l_action        VARCHAR(25)      
      , @l_dtls_id       NUMERIC      
      , @l_tr_account_no varchar(20)      
      , @l_id            VARCHAR(20)      
      , @l_dtlsm_id      NUMERIC      
      , @@c_access_cursor cursor      
      , @c_deleted_ind    varchar(20)      
      , @c_dptd_id        varchar(20)      
      , @l_trastm_desc    varchar(20)      
      , @l_counter        INT      
      , @l_acct_type_1    CHAR(1)      
      , @l_bank_id        INT      
      , @l_amount_1       MONEY      
      , @l_acct_type_2    CHAR(1)       
      , @l_account_id_2   NUMERIC(10,0)      
      , @l_branch_id_2    INT      
      , @l_amount_2       MONEY      
      , @l_cheque_2       VARCHAR(15)       
      , @l_narration_2    VARCHAr(250)      
      , @l_led_id         NUMERIC(10,0)      
      , @l_cost_cntr_2    INT       
      , @l_accbal_id      NUMERIC(10,0)      
      , @old_ldg_account_id NUMERIC      
      , @new_ldg_amount  MONEY      
      , @NEW_ldg_account_id NUMERIC      
      , @oLD_ldg_amount  MONEY      
      , @l_acct_no_2      varchar(25)      
      , @l_ledm_id        numeric(10,0)      
            
      , @tmp_voucher_no   numeric(10,0)       
      , @tmp_voucher_dt   varchar(11)      
      , @tmp_voucher_type varchar(5)      
      , @tmp_dpm_id       int      
      , @tmp_bookty_cd    varchar(4)          
      , @pa_voucher_no_1  numeric      
          
            
      
if @PA_ACTION <> 'app'  AND @PA_ACTION <> 'rej'             
begin      
--      
print 'dasd'      
--      
END      
set    @l_dpm_id  = @pa_dpm_id       

      
      
declare @c_access_cursor cursor      
set @l_excm_cd = ''      
set @l_access1       = 0       
SET @l_error         = 0      
SET @t_errorstr      = ''      
SET @delimeter        = '%'+ @ROWDELIMITER + '%'      
SET @delimeterlength = LEN(@ROWDELIMITER)      
SET @remainingstring = @pa_id        
      
  WHILE @remainingstring <> ''      
  BEGIN      
  --      
    SET @foundat = 0      
    SET @foundat =  PATINDEX('%'+@delimeter+'%',@remainingstring)    
    --      
    IF @foundat > 0      
    BEGIN      
    --      
      SET @currstring      = SUBSTRING(@remainingstring, 0,@foundat)      
      SET @remainingstring = SUBSTRING(@remainingstring, @foundat+@delimeterlength,LEN(@remainingstring)- @foundat+@delimeterlength)      
    --      
    END      
    ELSE      
    BEGIN      
    --      
      SET @currstring      = @remainingstring      
      SET @remainingstring = ''      
   --      
    END      
    --      
    IF @currstring <> ''      
    BEGIN      
    --      
      SET @delimeter_value        = '%'+ @rowdelimiter + '%'      
      SET @delimeterlength_value = LEN(@rowdelimiter)      
      SET @remainingstring_value = @pa_values      
      set @l_counter = 1      
      IF @pa_action = 'INS'       
      BEGIN      
      --      
        IF @pa_chk_yn = 0       
        BEGIN      
        --      
          select @pa_voucher_no = ISNULL(MAX(ldg_voucher_no),0) + 1 FROM ledger1      
        --      
        END      
        IF @pa_chk_yn = 1       
        BEGIN      
        --      
          select @pa_voucher_no = ISNULL(MAX(ldg_voucher_no),0) + 1 FROM ledger1      
          select @pa_voucher_no_1 = ISNULL(MAX(ldg_voucher_no),0) + 1 FROM ledger1_mak      
                
          IF @pa_voucher_no_1 > @pa_voucher_no      
          BEGIN      
          --      
            set @pa_voucher_no = @pa_voucher_no_1       
          --      
          END      
        --      
        END      
      --      
      END      
      --      
      WHILE @remainingstring_value <> ''      
      BEGIN      
      --      
      
        SET @foundat = 0      
        SET @foundat = PATINDEX('%'+@delimeter_value+'%',@remainingstring_value)      
        --      
        IF @foundat > 0      
        BEGIN      
          --      
          SET @currstring_value      = SUBSTRING(@remainingstring_value, 0,@foundat)      
          SET @remainingstring_value = SUBSTRING(@remainingstring_value, @foundat+@delimeterlength_value,LEN(@remainingstring_value)- @foundat+@delimeterlength_value)      
          --      
        END      
        ELSE      
        BEGIN      
          --      
          SET @CURRSTRING_VALUE = @REMAININGSTRING_VALUE      
          SET @REMAININGSTRING_VALUE = ''      
        --      
        END      
        --      
        IF @currstring_value <> ''      
        BEGIN      
        --      
          if @l_counter = 1      
          BEGIN      
          --      
            SET @l_acct_type_1 = citrus_usr.fn_splitval(@currstring_value,1)                    
            SET @l_bank_id     = citrus_usr.fn_splitval(@currstring_value,2)            
            SET @l_amount_1    = convert(money,citrus_usr.fn_splitval(@currstring_value,3))      
          --      
          END      
          ELSE      
          BEGIN      
          --      
            SET @l_acct_type_2 = citrus_usr.fn_splitval(@currstring_value,1)            
            SET @l_account_id_2= citrus_usr.fn_splitval(@currstring_value,2)            
            SET @l_branch_id_2 = citrus_usr.fn_splitval(@currstring_value,3)            
            SET @l_cost_cntr_2 = citrus_usr.fn_splitval(@currstring_value,4)            
            SET @l_amount_2    = convert(money,citrus_usr.fn_splitval(@currstring_value,5))      
            SET @l_cheque_2    = citrus_usr.fn_splitval(@currstring_value,6)         
            SET @l_narration_2 = citrus_usr.fn_splitval(@currstring_value,7)         
          --      
          END      
                
                
                
          IF @pa_chk_yn = 0      
          BEGIN      
          --      
            --select @l_dpm_id = dpm_id from dp_mstr where dpm_dpid = @pa_dpm_dpid and  dpm_deleted_ind = 1      
                  
                  
                  
      
            IF @pa_action = 'INS'        
            BEGIN      
            --      
                    
              SELECT @l_led_id   = ISNULL(MAX(ldg_id),0) + 1 FROM ledger1      
                    
              BEGIN TRANSACTION       
                    
              INSERT INTO ledger1      
              (ldg_id       
              ,ldg_dpm_id      
              ,ldg_voucher_type      
              ,ldg_book_type_cd      
              ,ldg_voucher_no       
              ,ldg_sr_no       
              ,ldg_ref_no       
              ,ldg_voucher_dt       
              ,ldg_account_id       
              ,ldg_account_type       
              ,ldg_amount       
              ,ldg_narration       
              ,ldg_account_no       
              ,ldg_instrument_no       
              ,ldg_branch_id       
              ,ldg_cost_cd_id       
              ,ldg_bill_brkup_id     
              ,ldg_trans_type  
              ,ldg_status  
              ,ldg_created_by       
              ,ldg_created_dt       
              ,ldg_lst_upd_by       
              ,ldg_lst_upd_dt       
              ,ldg_deleted_ind      
                    
              )VALUES      
              (@l_led_id      
              ,@l_dpm_id      
              ,@pa_voucher_type      
              ,@pa_book_type_cd      
              ,@pa_voucher_no      
              ,@l_counter      
              ,@pa_ref_no      
              ,convert(datetime,@pa_voucher_dt,103)      
              ,case when @l_counter = 1 then @l_bank_id else @l_account_id_2 end      
              ,case when @l_counter = 1 then @l_acct_type_1 else @l_acct_type_2 end      
              ,case when @l_counter = 1 then @l_amount_1 else -1*convert(int,@l_amount_2) end      
              ,case when @l_counter = 1 then '' else @l_narration_2 end      
              ,''      
              ,case when @l_counter = 1 then '' else @l_cheque_2 end      
              ,case when @l_counter = 1 then '' else @l_branch_id_2 end      
              ,case when @l_counter = 1 then 0 else case when @l_cost_cntr_2 ='' then 0 end end      
              ,0     
              ,'N'  
              ,'p'  
              ,@pa_login_name      
              ,getdate()      
              ,@pa_login_name      
              ,getdate()      
              ,1      
              )      
                    
              SET @l_error = @@error      
              IF @l_error <> 0      
              BEGIN      
              --      
                IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)      
                BEGIN      
                --      
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)      
                --      
                END      
                ELSE      
                BEGIN      
                --      
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'      
                --      
                END      
      
                ROLLBACK TRANSACTION       
              --      
              END      
              ELSE      
              BEGIN      
              --      
                IF @l_counter = 2      
                BEGIN      
                --      
                  update ledger1 set ldg_narration = @l_narration_2 where ldg_id =  @l_led_id - 1        
                --      
                END      
                     
                IF EXISTS(SELECT * FROM ACCOUNTBAL1 WHERE accbal_dpm_id = @l_dpm_id and accbal_acct_id = case when @l_counter = 1 then @l_bank_id else @l_account_id_2 end)      
                BEGIN      
                --      
                  UPDATE accountbal1       
                  SET    accbal_amount  = case when @l_counter = 1  then accbal_amount +  @l_amount_1       
                                              else accbal_amount -  @l_amount_2  end      
                  WHERE  accbal_dpm_id  = @l_dpm_id       
                  and    accbal_acct_id = case when @l_counter = 1 then @l_bank_id else @l_account_id_2 end                                                     
                --      
                END      
                ELSE      
                BEGIN      
                --      
                        
                  INSERT INTO accountbal1      
                  (accbal_dpm_id      
                  ,accbal_acct_id      
                  ,accbal_acct_type      
                  ,accbal_amount      
                  ,accbal_created_by      
                  ,accbal_created_dt      
                  ,accbal_lst_upd__by      
                  ,accbal_lst_upd__dt      
                  ,accbal_deleted_ind      
                  )      
                  VALUES      
                  (@l_dpm_id       
                  ,case when @l_counter = 1 then @l_bank_id else @l_account_id_2 end       
                  ,case when @l_counter = 1 then @l_acct_type_1 else @l_acct_type_2 end      
                  ,case when @l_counter = 1 then @l_amount_1 else @l_amount_2 end      
                  ,@pa_login_name      
                  ,getdate()      
                  ,@pa_login_name      
                  ,getdate()      
                  ,1      
                  )      
                --      
                END   
                
                
                UPDATE FINANCIAL_YR_MSTR      
																SET    FIN_CF_BALANCES = 'Y'        
														  WHERE  FIN_DPM_ID      = @l_dpm_id  
                      
                COMMIT TRANSACTION      
              --      
              END      
            --      
            END     
            ELSE IF @pa_action = 'DEL'    
            BEGIN  
            --  
              UPDATE accb      
               SET    accbal_amount  = case when ldg_account_type = 'B' then accbal_amount - ldg_amount else accbal_amount + -1*ldg_amount end        
               FROM   accountbal1 accb      
                   ,  ledger1            
               WHERE  ldg_account_id   = accbal_acct_id         
               and    ldg_account_type =  ACCBAL_ACCT_TYPE      
               AND    ldg_voucher_no  = @pa_voucher_no      
               AND    ldg_dpm_id      = @l_dpm_id        
               AND    ldg_voucher_type = @pa_voucher_type      
               AND    ldg_voucher_dt   = convert(datetime,@pa_voucher_dt,103)      
  
  
  
  
  
              UPDATE ledger1  
              set    ldg_deleted_ind = 0  
                   , ldg_lst_upd_by = @pa_login_name  
                   , ldg_lst_upd_dt = getdate()  
              WHERE  ldg_voucher_type = @pa_voucher_type      
              and    ldg_voucher_no   = @pa_voucher_no      
              and    ldg_voucher_dt   = convert(datetime,@pa_voucher_dt,103)      
              AND    ldg_dpm_id       = @l_dpm_id 
              
              
              
              UPDATE FINANCIAL_YR_MSTR      
														SET    FIN_CF_BALANCES = 'Y'        
														WHERE  FIN_DPM_ID      = @l_dpm_id  
            --  
            END  
            ELSE IF @pa_action = 'EDT'        
            BEGIN      
            --

               SELECT  @old_ldg_account_id  = ldg_account_id       
					  ,@old_ldg_amount      = ldg_amount      
			   FROM    ledger1      
			   WHERE   ldg_voucher_type = @pa_voucher_type      
			   and     ldg_voucher_no   = @pa_voucher_no      
			   and     ldg_voucher_dt   = convert(datetime,@pa_voucher_dt,103)      
			   AND     ldg_dpm_id       = @l_dpm_id 
       
              SELECT @new_ldg_amount      =  case when @l_counter = 1 then @l_amount_1 else convert(int,@l_amount_2) end      
              SELECT @new_ldg_account_id  =  Case when @l_counter = 1 then @l_bank_id else @l_account_id_2 end      
                    
                    
              if  (@old_ldg_account_id <> @new_ldg_account_id) OR (@old_ldg_amount <>  @new_ldg_amount)      
              begin      
              --      
                UPDATE LEDGER1      
                SET    ldg_bank_cl_date = ''      
                WHERE   ldg_account_type = case when @l_counter = 1 then 'B' ELSE 'G' END      
                AND     ldg_voucher_type = @pa_voucher_type      
                and     ldg_voucher_no   = @pa_voucher_no      
                and     ldg_voucher_dt   = convert(datetime,@pa_voucher_dt,103)      
                      
                      
                UPDATE FINANCIAL_YR_MSTR      
			    SET    FIN_CF_BALANCES = 'Y'        
			    WHERE  FIN_DPM_ID      = @l_dpm_id        
            
                exec  [citrus_usr].[pr_ins_upd_ledger_dy]
                                  @pa_id
                                 ,'INS'
                                 ,@pa_login_name      
                                 ,@pa_dpm_id          
                                 ,@pa_voucher_type    
                                 ,@pa_book_type_cd    
                                 ,@pa_voucher_no      
                                 ,@pa_ref_no          
                                 ,@pa_voucher_dt      
                                 ,@pa_values          
                                 ,@pa_chk_yn          
                                 ,@rowdelimiter       
                                 ,@coldelimiter       
                                 ,@pa_errmsg          
        
              --      
              end      
                  
                  
													
                    
                  
            --      
            END      
                 
          --      
          END      
          ELSE IF @pa_chk_yn = 1      
          BEGIN      
          --      
            IF @pa_action = 'INS'        
            BEGIN      
            --      
      
              BEGIN TRANSACTION       
      
              INSERT INTO ledger1_mak      
              (ldg_id       
              ,ldg_dpm_id      
              ,ldg_voucher_type      
              ,ldg_book_type_cd      
              ,ldg_voucher_no       
              ,ldg_sr_no       
              ,ldg_ref_no       
              ,ldg_voucher_dt       
              ,ldg_account_id       
              ,ldg_account_type       
              ,ldg_amount       
              ,ldg_narration       
              ,ldg_account_no       
              ,ldg_instrument_no       
              ,ldg_branch_id       
              ,ldg_cost_cd_id       
              ,ldg_bill_brkup_id    
              ,ldg_trans_type  
              ,ldg_status  
              ,ldg_created_by       
              ,ldg_created_dt       
              ,ldg_lst_upd_by       
              ,ldg_lst_upd_dt       
              ,ldg_deleted_ind      
      
              )VALUES      
              (@l_led_id      
              ,@l_dpm_id      
              ,@pa_voucher_type      
              ,@pa_book_type_cd      
              ,@pa_voucher_no      
              ,@l_counter      
              ,@pa_ref_no      
              ,convert(datetime,@pa_voucher_dt,103)      
              ,case when @l_counter = 1 then @l_bank_id else @l_account_id_2 end      
              ,case when @l_counter = 1 then @l_acct_type_1 else @l_acct_type_2 end      
              ,case when @l_counter = 1 then  @l_amount_1 else -1*convert(int,@l_amount_2) end      
              ,case when @l_counter = 1 then '' else @l_narration_2 end      
              ,0      
              ,case when @l_counter = 1 then '' else @l_cheque_2 end      
              ,case when @l_counter = 1 then '' else @l_branch_id_2 end      
              ,case when @l_counter = 1 then 0 else case when @l_cost_cntr_2 ='' then 0 end end      
              ,0      
              ,'N'  
              ,'P'  
              ,@pa_login_name      
              ,getdate()      
              ,@pa_login_name      
              ,getdate()      
              ,0      
              )      
      
              SET @l_error = @@error      
              IF @l_error <> 0      
              BEGIN      
              --      
                IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)      
                BEGIN      
                --      
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)      
                --      
                END      
                ELSE      
                BEGIN      
                --      
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'      
                --      
                END      
      
                ROLLBACK TRANSACTION       
              --      
              END      
              ELSE      
              BEGIN      
              --      
                IF @l_counter = 2      
                BEGIN      
                --      
                  update ledger1_mak set ldg_narration = @l_narration_2 where ldg_id =  @l_led_id - 1        
                --      
                END      
      
                COMMIT TRANSACTION   
                
                
                UPDATE FINANCIAL_YR_MSTR      
														  SET    FIN_CF_BALANCES = 'Y'        
														  WHERE  FIN_DPM_ID      = @l_dpm_id  
														
              --      
              END      
            --      
            END      
            ELSE IF @pa_action = 'EDT'        
            BEGIN      
            --      
              IF @l_counter = 1     
              begin    
              --    
              DELETE FROM  ledger1_mak      
              WHERE ldg_voucher_no = @pa_voucher_no      
              AND   ldg_dpm_id     = @l_dpm_id       
              AND   ldg_voucher_type = @pa_voucher_type      
              AND   ldg_book_type_cd = @pa_book_type_cd      
              AND   ldg_voucher_dt   = convert(datetime,@pa_voucher_dt,103)      
              --    
              end       
              --      
              if exists(select ldg_id from ledger1       
                        where  ldg_voucher_no = @pa_voucher_no      
                        AND   ldg_dpm_id      = @l_dpm_id      
                        AND   ldg_voucher_type = @pa_voucher_type      
                        AND   ldg_book_type_cd = @pa_book_type_cd      
                        AND   ldg_voucher_dt   = convert(datetime,@pa_voucher_dt,103))      
      
              BEGIN      
              --      
                select @l_led_id =  ldg_id from ledger1       
                where  ldg_voucher_no = @pa_voucher_no      
                and    ldg_dpm_id      = @l_dpm_id      
              --      
              END      
              ELSE      
              BEGIN      
              --      
                SELECT @l_led_id    = ISNULL(MAX(ldg_id),0) + 1 FROM ledger1      
                SELECT @l_ledm_id   = ISNULL(MAX(ldg_id),0) + 1 FROM ledger1_mak      
      
                IF @l_ledm_id   > @l_led_id          
                BEGIN      
                --      
                  set @l_led_id   =   @l_ledm_id         
                --      
                END      
              --      
              END      
      
      
      
      
      
              BEGIN TRANSACTION      
      
              insert into ledger1_mak      
              (ldg_id       
              ,ldg_dpm_id      
              ,ldg_voucher_type      
              ,ldg_book_type_cd      
              ,ldg_voucher_no       
              ,ldg_sr_no       
              ,ldg_ref_no       
              ,ldg_voucher_dt       
              ,ldg_account_id       
              ,ldg_account_type       
              ,ldg_amount       
              ,ldg_narration       
              ,ldg_account_no       
              ,ldg_instrument_no       
              ,ldg_branch_id       
              ,ldg_cost_cd_id       
              ,ldg_bill_brkup_id   
              ,ldg_trans_type  
              ,ldg_status  
              ,ldg_created_by       
              ,ldg_created_dt       
              ,ldg_lst_upd_by       
              ,ldg_lst_upd_dt       
              ,ldg_deleted_ind      
              )      
              select @l_led_id      
              ,@l_dpm_id      
              ,@pa_voucher_type      
              ,@pa_book_type_cd      
              ,@pa_voucher_no      
              ,@l_counter      
              ,@pa_ref_no      
              ,convert(datetime,@pa_voucher_dt,103)      
              ,case when @l_counter = 1 then @l_bank_id else @l_account_id_2 end      
              ,case when @l_counter = 1 then @l_acct_type_1 else @l_acct_type_2 end      
              ,case when @l_counter = 1 then @l_amount_1 else -1*convert(int,@l_amount_2) end      
              ,case when @l_counter = 1 then '' else @l_narration_2 end      
              ,0      
              ,case when @l_counter = 1 then '' else @l_cheque_2 end      
              ,case when @l_counter = 1 then '' else @l_branch_id_2 end      
              ,case when @l_counter = 1 then 0 else case when  @l_cost_cntr_2 ='' then 0 end end      
              ,0      
              ,'N'  
              ,'P'  
              ,@pa_login_name      
              ,getdate()      
              ,@pa_login_name      
              ,getdate()      
              ,0      
                    
      
      
              SET @l_error = @@error      
              IF @l_error <> 0      
              BEGIN      
              --      
                IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)      
                BEGIN      
                --      
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)      
                --      
                END      
                ELSE      
                BEGIN      
                --      
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'      
                --      
                END      
      
                ROLLBACK TRANSACTION       
              --      
              END      
              ELSE      
              BEGIN      
              --      
                IF @l_counter = 2      
                BEGIN      
                --      
                  update ledger1_mak set ldg_narration = @l_narration_2 where ldg_id =  @l_led_id - 1        
                --      
                END      
      
      
                COMMIT TRANSACTION  
                
                UPDATE FINANCIAL_YR_MSTR      
				SET    FIN_CF_BALANCES = 'Y'        
				WHERE  FIN_DPM_ID      = @l_dpm_id  
              --      
              END      
            --      
            END      
            
                
          --      
          END      
                
                
          SET @L_COUNTER = @L_COUNTER + 1       
        --      
        END      
                
      --      
      END      
    --      
    END      
  --      
  END      
  SET @pa_errmsg = @t_errorstr      
        
--      
END

GO
