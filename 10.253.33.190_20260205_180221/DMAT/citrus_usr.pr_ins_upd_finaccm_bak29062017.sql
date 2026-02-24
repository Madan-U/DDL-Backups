-- Object: PROCEDURE citrus_usr.pr_ins_upd_finaccm_bak29062017
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/*
FINA_ACC_ID
FINA_ACC_CODE
FINA_ACC_NAME
FINA_ACC_TYPE
FINA_GROUP_ID
FINA_BRANCH_ID
FINA_DPM_ID
FINA_CREATED_BY
FINA_CREATED_DT
FINA_LST_UPD_BY
FINA_LST_UPD_DT
FINA_DELETED_IND


FIN_ACCOUNT_MSTR_MAK
*/
create PROCEDURE [citrus_usr].[pr_ins_upd_finaccm_bak29062017](@pa_id                VARCHAR(8000)  
																																	, @pa_action            VARCHAR(20)  
																																	, @pa_login_name        VARCHAR(20)  
																																	, @pa_acc_code          VARCHAR(20)
																																	, @pa_acc_name          VARCHAR(50)
																																	, @pa_acc_type          CHAR(1)
																																	, @pa_group_id          INT 
																																	, @pa_branch_id         INT 
																																	, @pa_dpm_id            VARCHAR(16)
																																	, @pa_chk_yn            INT  
																																	, @rowdelimiter         CHAR(4)       = '*|~*'  
																																	, @coldelimiter         CHAR(4)       = '|*~|'  
																																	, @pa_errmsg            VARCHAR(8000) output  
)  
AS
/*********************************************************************************
 SYSTEM         : dp
 MODULE NAME    : pr_ins_upd_finaccm
 DESCRIPTION    : this procedure will contain the maker checker facility for fin_account_mstr
 COPYRIGHT(C)   : marketplace technologies 
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  --------------------------------------------------
 1.0    TUSHAR            10-JAN-2008   VERSION.
-----------------------------------------------------------------------------------*/
BEGIN
--
DECLARE @t_errorstr           VARCHAR(8000)
      , @l_error              BIGINT
      , @delimeter            VARCHAR(10)
      , @remainingstring      VARCHAR(8000)
      , @currstring           VARCHAR(8000)
      , @foundat              INT
      , @delimeterlength      INT
      , @l_finam_id           NUMERIC
      , @l_finamm_id          NUMERIC
      , @l_dp_id              NUMERIC 
      , @l_deleted_ind        smallint
      
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
    --SELECT @l_dp_id = dpm_id FROM dp_mstr WHERE dpm_dpid  = @pa_dpm_id AND  dpm_deleted_ind = 1
	--Added by pankaj on 12/09/2012 for MOSL for all dp
	IF @pa_dpm_id = 'ALL'
	BEGIN
		SET @l_dp_id = '999'
	END
	ELSE
	BEGIN
		SELECT @l_dp_id = dpm_id FROM dp_mstr WHERE dpm_dpid  = @pa_dpm_id AND  dpm_deleted_ind = 1
    END
	--Added by pankaj on 12/09/2012 for MOSL for all dp
    
    IF @pa_chk_yn = 0
    BEGIN
    --
						IF @pa_action = 'INS'
						BEGIN
						--
						  BEGIN TRANSACTION
						  
						  		SELECT @l_finam_id = ISNULL(MAX(fina_acc_id),0)+ 1 FROM  fin_account_mstr WITH (NOLOCK) 

										INSERT INTO fin_account_mstr
										(fina_acc_id
										,fina_acc_code
										,fina_acc_name
										,fina_acc_type
										,fina_group_id
										,fina_branch_id
										,fina_dpm_id
										,fina_created_by
										,fina_created_dt
										,fina_lst_upd_by
										,fina_lst_upd_dt
										,fina_deleted_ind
										)
										VALUES
										(@l_finam_id 
										,@pa_acc_code          
										,@pa_acc_name          
										,@pa_acc_type          
										,@pa_group_id          
										,@pa_branch_id         
										,@l_dp_id
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
          ROLLBACK TRANSACTION 
          
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
        --
        END
        ELSE
        BEGIN
        --
          COMMIT TRANSACTION
        --
        END
						--
						END
						ELSE IF @pa_action = 'EDT'
						BEGIN
						--
        BEGIN TRANSACTION
        
						  UPDATE fin_account_mstr 
								SET    fina_acc_code     = @pa_acc_code
														,fina_acc_name     = @pa_acc_name
														,fina_acc_type     = @pa_acc_type
														,fina_group_id     = @pa_group_id
														,fina_branch_id    = @pa_branch_id
														,fina_dpm_id       = @l_dp_id
														,fina_lst_upd_by   = @pa_login_name
														,fina_lst_upd_dt   = getdate()
								WHERE  fina_acc_id       = CONVERT(INT,@currstring)
        AND    fina_deleted_ind   = 1
								
								
						  SET @l_error = @@error
						  IF @l_error <> 0
						  BEGIN
						  --
          ROLLBACK TRANSACTION 
          
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
        --
        END
        ELSE
        BEGIN
        --
          COMMIT TRANSACTION
        --
        END
						--
						END
						ELSE IF @pa_action = 'DEL'
						BEGIN
						--
        BEGIN TRANSACTION
								
								UPDATE fin_account_mstr 
								SET    fina_lst_upd_dt  = getdate()
								      ,fina_lst_upd_by  = @pa_login_name
														,fina_deleted_ind = 0
								WHERE  fina_acc_id          = CONVERT(INT,@currstring)
        AND    fina_deleted_ind = 1
								
								SET @l_error = @@error
								IF @l_error <> 0
								BEGIN
								--
										ROLLBACK TRANSACTION 
										
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
								--
								END
								ELSE
								BEGIN
								--
										COMMIT TRANSACTION
								--
        END
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
        
        SELECT @l_finamm_id = ISNULL(MAX(fina_acc_id),0)+ 1 FROM  fin_account_mstr_mak WITH (NOLOCK)

        SELECT @l_finam_id = ISNULL(MAX(fina_acc_id),0)+ 1 FROM  fin_account_mstr WITH (NOLOCK)

        IF @l_finamm_id  > @l_finam_id 
        BEGIN
        --
          SET @l_finam_id = @l_finamm_id
        --
        END
        
								INSERT INTO fin_account_mstr_mak
								(fina_acc_id
								,fina_acc_code
								,fina_acc_name
								,fina_acc_type
								,fina_group_id
								,fina_branch_id
								,fina_dpm_id
								,fina_created_by
								,fina_created_dt
								,fina_lst_upd_by
								,fina_lst_upd_dt
								,fina_deleted_ind
								)
								VALUES
								(@l_finam_id 
								,@pa_acc_code          
								,@pa_acc_name          
								,@pa_acc_type          
								,@pa_group_id          
								,@pa_branch_id         
								,@l_dp_id
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
										ROLLBACK TRANSACTION 
										
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
								--
								END
								ELSE
								BEGIN
								--
										COMMIT TRANSACTION
								--
        END
						--
						END
						ELSE IF @pa_action = 'EDT'
						BEGIN
						--
        BEGIN TRANSACTION
								
							 UPDATE fin_account_mstr_mak
								SET    fina_deleted_ind = 2
								     , fina_lst_upd_dt  = getdate()
								     , fina_lst_upd_by  = @pa_login_name
								WHERE  fina_acc_id          = CONVERT(INT,@currstring)
        AND    fina_deleted_ind = 0
								
								
								SET @l_error = @@error
								IF @l_error <> 0
								BEGIN
								--
										ROLLBACK TRANSACTION 
										
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
								--
								END
								ELSE
								BEGIN
								--
								  IF EXISTS(select * from fin_account_mstr where fina_acc_id = CONVERT(INT,@currstring) and fina_deleted_ind = 1)
								  BEGIN
								  --
								    SET @l_deleted_ind = 6
								  --
								  END
								  ELSE
								  BEGIN
								  --
								    SET @l_deleted_ind = 0
								  --
								  END
								  
								 
										INSERT INTO fin_account_mstr_mak
										(fina_acc_id
										,fina_acc_code
										,fina_acc_name
										,fina_acc_type
										,fina_group_id
										,fina_branch_id
										,fina_dpm_id
										,fina_created_by
										,fina_created_dt
										,fina_lst_upd_by
										,fina_lst_upd_dt
										,fina_deleted_ind
										)
										VALUES
										(CONVERT(INT,@currstring)
										,@pa_acc_code          
										,@pa_acc_name          
										,@pa_acc_type          
										,@pa_group_id          
										,@pa_branch_id         
										,@l_dp_id
										,@pa_login_name
										,getdate()
										,@pa_login_name
										,getdate()
										,@l_deleted_ind
									 )
										
										
								  SET @l_error = @@error
										IF @l_error <> 0
										BEGIN
										--
												ROLLBACK TRANSACTION 
												
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
										--
  								END
  								ELSE
  								BEGIN
  								--
  										COMMIT TRANSACTION
  								--
  								END
  								
								--
        END
						--
						END
						IF @pa_action = 'DEL'
						BEGIN
						--
									IF exists(SELECT * FROM fin_account_mstr_mak  WHERE fina_acc_id = convert(numeric,@currstring) and fina_deleted_ind in(0,4))
									BEGIN
									--
									  DELETE FROM fin_account_mstr_mak
									  WHERE fina_acc_id = convert(numeric,@currstring)
									  AND   fina_deleted_ind = 0
									--
									END
									ELSE
									BEGIN
									--
									  INSERT INTO fin_account_mstr_mak
										(fina_acc_id
										,fina_acc_code
										,fina_acc_name
										,fina_acc_type
										,fina_group_id
										,fina_branch_id
										,fina_dpm_id
										,fina_created_by
										,fina_created_dt
										,fina_lst_upd_by
										,fina_lst_upd_dt
										,fina_deleted_ind
										)
										SELECT fina_acc_id
											,fina_acc_code
											,fina_acc_name
											,fina_acc_type
											,fina_group_id
											,fina_branch_id
											,fina_dpm_id
											,fina_created_by
											,fina_created_dt
											,@pa_login_name
											,getdate()
											,4
											FROM  fin_account_mstr
											WHERE fina_acc_id          = convert(numeric,@currstring)
											AND   fina_deleted_ind = 1
									--
									END
						--
						END
						IF @pa_action = 'APP'
						BEGIN
						--
        BEGIN TRANSACTION
						  
						  
						  
						  IF EXISTS(select * from fin_account_mstr_mak where fina_acc_id = convert(numeric,@currstring) and fina_deleted_ind = 6)
						  BEGIN
						  --
						    UPDATE fin
										SET    fin.fina_acc_code     = finamm.fina_acc_code
																,fin.fina_acc_name     = finamm.fina_acc_name
																,fin.fina_acc_type     = finamm.fina_acc_type
																,fin.fina_group_id     = finamm.fina_group_id
																,fin.fina_branch_id    = finamm.fina_branch_id
																,fin.fina_dpm_id       = finamm.fina_dpm_id
																,fin.fina_lst_upd_by   = @pa_login_name
																,fin.fina_lst_upd_dt   = getdate()  
								  FROM   fin_account_mstr_mak        finamm 
								        ,fin_account_mstr            fin 
								  WHERE  finamm.fina_acc_id       =  convert(numeric,@currstring)
								  AND    finamm.fina_acc_id       =  fin.fina_acc_id
								  AND    finamm.fina_deleted_ind =  6 
								  
										SET @l_error = @@error
										IF @l_error <> 0
										BEGIN
										--
												ROLLBACK TRANSACTION 
												
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
										--
										END
										ELSE
										BEGIN
										--
												UPDATE fin_account_mstr_mak 
												SET    fina_deleted_ind = 7
												     , fina_lst_upd_by  = @pa_login_name
                 , fina_lst_upd_dt  = getdate()
												WHERE  fina_acc_id          = convert(numeric,@currstring)
												AND    fina_deleted_ind = 6

												COMMIT TRANSACTION
										--
										END
        --
						  END
						  ELSE IF exists(select * from fin_account_mstr_mak where fina_acc_id = convert(numeric,@currstring) and fina_deleted_ind = 0)
						  BEGIN
						  --
        				 INSERT INTO fin_account_mstr
													(fina_acc_id
													,fina_acc_code
													,fina_acc_name
													,fina_acc_type
													,fina_group_id
													,fina_branch_id
													,fina_dpm_id
													,fina_created_by
													,fina_created_dt
													,fina_lst_upd_by
													,fina_lst_upd_dt
													,fina_deleted_ind
										   )
												SELECT fina_acc_id
													,fina_acc_code
													,fina_acc_name
													,fina_acc_type
													,fina_group_id
													,fina_branch_id
													,fina_dpm_id
													,fina_created_by
													,fina_created_dt
													,fina_lst_upd_by
													,fina_lst_upd_dt
													,1
												FROM  fin_account_mstr_mak
												WHERE fina_acc_id          = convert(numeric,@currstring)
												AND   fina_deleted_ind = 0
										
												SET @l_error = @@error
												IF @l_error <> 0
												BEGIN
												--
														ROLLBACK TRANSACTION 

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
												--
												END
												ELSE
												BEGIN
												--
														UPDATE fin_account_mstr_mak 
														SET    fina_deleted_ind = 1
																			, fina_lst_upd_by  = @pa_login_name
																			, fina_lst_upd_dt  = getdate()
														WHERE  fina_acc_id          = convert(numeric,@currstring)
														AND    fina_deleted_ind = 0
		
		
														COMMIT TRANSACTION
												--
												END
								  
						  --
						  END
						  ELSE 
						  BEGIN
						  --
          UPDATE fin_account_mstr 
										SET    fina_deleted_ind = 0
															, fina_lst_upd_by  = @pa_login_name
															, fina_lst_upd_dt  = getdate()
										WHERE  fina_acc_id          = convert(numeric,@currstring)
										AND    fina_deleted_ind = 1
										
										UPDATE fin_account_mstr_mak
										SET    fina_deleted_ind = 5
															, fina_lst_upd_by  = @pa_login_name
															, fina_lst_upd_dt  = getdate()
										WHERE  fina_acc_id          = convert(numeric,@currstring)
										AND    fina_deleted_ind = 4
										
										COMMIT TRANSACTION
						  --
						  END
						--
						END
						IF @pa_action = 'REJ'
						BEGIN
						--
        BEGIN TRANSACTION
						  
						  UPDATE fin_account_mstr_mak 
								SET    fina_deleted_ind = 3
													, fina_lst_upd_by  = @pa_login_name
													, fina_lst_upd_dt  = getdate()
								WHERE  fina_acc_id          = convert(numeric,@currstring)
								AND    fina_deleted_ind IN (0,4,6)
						  
						  
						  
						  SET @l_error = @@error
						  IF @l_error <> 0
						  BEGIN
						  --
          ROLLBACK TRANSACTION 
          
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
        --
        END
        ELSE
        BEGIN
        --
          COMMIT TRANSACTION
        --
        END
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
