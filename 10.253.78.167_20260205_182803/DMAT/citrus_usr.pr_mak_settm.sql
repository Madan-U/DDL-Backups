-- Object: PROCEDURE citrus_usr.pr_mak_settm
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_mak_settm](@pa_id              VARCHAR(8000)  
                            , @pa_action          VARCHAR(20)  
                            , @pa_login_name      VARCHAR(20)  
                            , @pa_excm_id         VARCHAR(8000)
                            , @pa_settm_type      VARCHAR(20) 
                            , @pa_settm_type_cdsl VARCHAR(20) 
                            , @pa_settm_desc      VARCHAR(200)  
                            , @pa_chk_yn          INT  
                            , @rowdelimiter       CHAR(4)       = '*|~*'  
                            , @coldelimiter       CHAR(4)       = '|*~|'  
                            , @pa_errmsg          VARCHAR(8000) output  
)  
AS
/*
*********************************************************************************
 SYSTEM         : dp
 MODULE NAME    : pr_mak_settm
 DESCRIPTION    : this procedure will contain the maker checker facility for settlement_type_mstr
 COPYRIGHT(C)   : marketplace technologies 
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  --------------------------------------------------
 1.0    TUSHAR            08-OCT-2007   VERSION.
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
      , @l_settm_id      NUMERIC
      , @l_settmm_id     NUMERIC
      , @l_deleted_ind   smallint
SET @l_error         = 0
SET @t_errorstr      = ''
SET @delimeter        = '%'+ @rowdelimiter + '%'
SET @delimeterlength = LEN(@rowdelimiter)
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
    IF @pa_chk_yn = 0
    BEGIN
    --
						IF @pa_action = 'INS'
						BEGIN
						--
						  BEGIN TRANSACTION
						  
						  SELECT @l_settm_id = ISNULL(MAX(settm_id),0)+ 1  FROM settlement_type_mstr  WITH (NOLOCK)
						  
						  INSERT INTO settlement_type_mstr
								( settm_id
								,	settm_excm_id
								,	settm_type
								,	settm_type_cdsl
								,	settm_desc
								,	settm_created_by
								,	settm_created_dt
								,	settm_lst_upd_by
								,	settm_lst_upd_dt
								,	settm_deleted_ind
        )
								VALUES
								( @l_settm_id
								, @pa_excm_id
								, @pa_settm_type
								, @pa_settm_type_cdsl
								, @pa_settm_desc
								, @pa_login_name
								, getdate()
								, @pa_login_name
								, getdate()
								, 1
								)

								
						  SET @l_error = @@error
						  IF @l_error <> 0
						  BEGIN
						  --
          ROLLBACK TRANSACTION 
          
          SET @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar,@pa_excm_id)+@coldelimiter+isnull(@pa_settm_type,'')+@COLDELIMITER+ISNULL(@pa_settm_desc,'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter
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
        
						  UPDATE settlement_type_mstr
								SET    settm_excm_id     = @pa_excm_id
								     , settm_type        = @pa_settm_type
             , settm_type_cdsl   = @pa_settm_type_cdsl
													, settm_desc        = @pa_settm_desc
													, settm_lst_upd_dt  = getdate()
													, settm_lst_upd_by  = @pa_login_name
								WHERE  settm_id          = convert(numeric,@currstring)
								AND    settm_deleted_ind  = 1
								
								
						  SET @l_error = @@error
						  IF @l_error <> 0
						  BEGIN
						  --
          ROLLBACK TRANSACTION
          
          SET @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar,@pa_excm_id)+@coldelimiter+isnull(@pa_settm_type,'')+@COLDELIMITER+ISNULL(@pa_settm_desc,'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter
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
								
								UPDATE settlement_type_mstr
								SET    settm_lst_upd_dt  = getdate()
								      ,settm_lst_upd_by  = @pa_login_name
														,settm_deleted_ind = 0
								WHERE  settm_id          = convert(numeric,@currstring)
								AND    settm_deleted_ind = 1
								
								SET @l_error = @@error
								IF @l_error <> 0
								BEGIN
								--
										ROLLBACK TRANSACTION 
										
										SELECT @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar,settm_excm_id)+@coldelimiter+isnull(settm_type,'')+@COLDELIMITER+ISNULL(settm_desc,'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter
										FROM   settlement_type_mstr
										WHERE  settm_id    = convert(numeric,@currstring)
										and    settm_deleted_ind  = 1
										
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
        
        SELECT @l_settmm_id = ISNULL(MAX(settm_id),0)+1
								FROM settm_mak WITH (NOLOCK)
								--
								SELECT @L_settm_ID = ISNULL(MAX(settm_id),0)+1
								FROM settlement_type_mstr WITH (NOLOCK)

								IF @l_settmm_id > @l_settm_id
								BEGIN
								--
										SET  @l_settm_id = @l_settmm_id
								--
        END
        
								INSERT INTO settm_mak
								( settm_id
								,	settm_excm_id
								,	settm_type
								,	settm_type_cdsl
								,	settm_desc
								,	settm_created_by
								,	settm_created_dt
								,	settm_lst_upd_by
								,	settm_lst_upd_dt
								,	settm_deleted_ind
								)
								VALUES
								( @l_settm_id
								, @pa_excm_id
								, @pa_settm_type
								, @pa_settm_type_cdsl
								, @pa_settm_desc
								, @pa_login_name
								, getdate()
								, @pa_login_name
								, getdate()
								, 0
								)

								
								SET @l_error = @@error
								IF @l_error <> 0
								BEGIN
								--
										ROLLBACK TRANSACTION 
										
										SET @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar,@pa_excm_id)+@coldelimiter+isnull(@pa_settm_type,'')+@COLDELIMITER+ISNULL(@pa_settm_desc,'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter
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
								
							 UPDATE settm_mak
								SET    settm_deleted_ind  = 2
													, settm_lst_upd_dt   = getdate()
													, settm_lst_upd_by   = @pa_login_name
								WHERE  settm_id           = convert(numeric,@currstring)
								AND    settm_deleted_ind   = 0
								
								
								SET @l_error = @@error
								IF @l_error <> 0
								BEGIN
								--
										ROLLBACK TRANSACTION
										
										SET @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar,@pa_excm_id)+@coldelimiter+isnull(@pa_settm_type,'')+@coldelimiter+isnull(@pa_settm_type_cdsl,'')+@COLDELIMITER+ISNULL(@pa_settm_desc,'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter
								--
								END
								ELSE
								BEGIN
								--
								  IF EXISTS(select * from settlement_type_mstr where settm_id = CONVERT(INT,@currstring) and settm_deleted_ind = 1)
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
								
								
								  INSERT INTO settm_mak
										( settm_id
										,	settm_excm_id
										,	settm_type
										,	settm_type_cdsl
										,	settm_desc
										,	settm_created_by
										,	settm_created_dt
										,	settm_lst_upd_by
										,	settm_lst_upd_dt
										,	settm_deleted_ind
										)
										VALUES
										( convert(numeric,@currstring)
										, @pa_excm_id
										, @pa_settm_type
										, @pa_settm_type_cdsl
										, @pa_settm_desc
										, @pa_login_name
										, getdate()
										, @pa_login_name
										, getdate()
										, @l_deleted_ind
								  )
										
								  SET @l_error = @@error
										IF @l_error <> 0
										BEGIN
										--
												ROLLBACK TRANSACTION 
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
									IF exists(SELECT * FROM settm_mak WHERE settm_id = convert(numeric,@currstring) and settm_deleted_ind in(0,4))
									BEGIN
									--
											DELETE FROM settm_mak 
											WHERE settm_id = convert(numeric,@currstring)
											AND   settm_deleted_ind = 0
									--
									END
									ELSE
									BEGIN
									--
											INSERT INTO settm_mak
											( settm_id
											,	settm_excm_id
											,	settm_type
											,	settm_type_cdsl
											,	settm_desc
											,	settm_created_by
											,	settm_created_dt
											,	settm_lst_upd_by
											,	settm_lst_upd_dt
											,	settm_deleted_ind
										)
											SELECT settm_id
											,	settm_excm_id
											,	settm_type
											,	settm_type_cdsl
											,	settm_desc
											,	settm_created_by
											,	settm_created_dt
											, @pa_login_name
											, getdate()
											, 4
											FROM  settlement_type_mstr
											WHERE settm_id          = convert(numeric,@currstring)
											AND   settm_deleted_ind = 1
									--
									END
						--
						END
						IF @pa_action = 'APP'
						BEGIN
						--
        BEGIN TRANSACTION
						  
						  IF EXISTS(select * from settlement_type_mstr where settm_id = convert(numeric,@currstring) and settm_deleted_ind = 1)
						  BEGIN
						  --
						    UPDATE settlement_type_mstr
										SET    settm_excm_id            = settmm.settm_excm_id 
										     , settm_type               = settmm.settm_type        
										     , settm_type_cdsl          = settmm.settm_type_cdsl        
															, settm_desc               = settmm.settm_desc       
															, settm_lst_upd_dt         = settmm.settm_lst_upd_dt
															, settm_lst_upd_by         = settmm.settm_lst_upd_by 
										FROM   settm_mak                  settmm					
										WHERE  settmm.settm_id          = convert(numeric,@currstring)
								  AND    settmm.settm_deleted_ind = 6
								  
										SET @l_error = @@error
										IF @l_error <> 0
										BEGIN
										--
												ROLLBACK TRANSACTION 
												
												SELECT @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar,@pa_excm_id)+@coldelimiter+isnull(@pa_settm_type,'')+@coldelimiter+isnull(@pa_settm_type_cdsl,'')+@COLDELIMITER+ISNULL(@pa_settm_desc,'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter
												FROM   settm_mak
												WHERE  settm_id    = convert(numeric,@currstring)
										  and    settm_deleted_ind  = 0
										--
										END
										ELSE
										BEGIN
										--
												UPDATE settm_mak 
												SET    settm_deleted_ind = 7
												     , settm_lst_upd_by  = @pa_login_name
                 , settm_lst_upd_dt  = getdate()
												WHERE  settm_id          = convert(numeric,@currstring)
												AND    settm_deleted_ind = 6

												COMMIT TRANSACTION
										--
										END
        --
						  END
						  ELSE
						  BEGIN
						  --
						    INSERT INTO settlement_type_mstr
										( settm_id
										,	settm_excm_id
										,	settm_type
										,	settm_type_cdsl
										,	settm_desc
										,	settm_created_by
										,	settm_created_dt
										,	settm_lst_upd_by
										,	settm_lst_upd_dt
										,	settm_deleted_ind
										)
									 SELECT settm_id
										,	settm_excm_id
										,	settm_type
										,	settm_type_cdsl
										,	settm_desc
										,	settm_created_by
										,	settm_created_dt
										,	settm_lst_upd_by
										,	settm_lst_upd_dt
										,	1
										FROM  settm_mak
										WHERE settm_id = convert(numeric,@currstring)
										AND   settm_deleted_ind = 0
										
										SET @l_error = @@error
										IF @l_error <> 0
										BEGIN
										--
												ROLLBACK TRANSACTION 
												
												SELECT @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar,@pa_excm_id)+@coldelimiter+isnull(@pa_settm_type,'')+@coldelimiter+isnull(@pa_settm_type_cdsl,'')+@COLDELIMITER+ISNULL(@pa_settm_desc,'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter
												FROM   settm_mak
												WHERE  settm_id    = convert(numeric,@currstring)
										  and    settm_deleted_ind  = 0
										--
										END
										ELSE
										BEGIN
										--
												UPDATE settm_mak 
												SET    settm_deleted_ind = 1
																	, settm_lst_upd_by  = @pa_login_name
																	, settm_lst_upd_dt  = getdate()
												WHERE  settm_id          = convert(numeric,@currstring)
												AND    settm_deleted_ind = 0


												COMMIT TRANSACTION
										--
										END
						  --
						  END
						--
						END
						IF @pa_action = 'REJ'
						BEGIN
						--
						  UPDATE settlement_type_mstr 
								SET    settm_deleted_ind = 0
													, settm_lst_upd_by  = @pa_login_name
													, settm_lst_upd_dt  = getdate()
								WHERE  settm_id          = convert(numeric,@currstring)
								AND    settm_deleted_ind = 1

								UPDATE settm_mak
								SET    settm_deleted_ind = 5
													, settm_lst_upd_by  = @pa_login_name
													, settm_lst_upd_dt  = getdate()
								WHERE  settm_id          = convert(numeric,@currstring)
								AND    settm_deleted_ind = 4
						
						--
						END
						IF @pa_action = 'REJ'
						BEGIN
						--
        BEGIN TRANSACTION
						  
						  UPDATE settm_mak 
								SET    settm_deleted_ind = 3
													, settm_lst_upd_by  = @pa_login_name
													, settm_lst_upd_dt  = getdate()
								WHERE  settm_id          = convert(numeric,@currstring)
								AND    settm_deleted_ind = 0
						  
						  
						  SET @l_error = @@error
						  IF @l_error <> 0
						  BEGIN
						  --
          ROLLBACK TRANSACTION 
          
          SELECT @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar,@pa_excm_id)+@coldelimiter+isnull(@pa_settm_type,'')+@coldelimiter+isnull(@pa_settm_type_cdsl,'')+@COLDELIMITER+ISNULL(@pa_settm_desc,'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter
										FROM   settm_mak
										WHERE  settm_id    = convert(numeric,@currstring)
								  and    settm_deleted_ind  = 0
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

  set @pa_errmsg = @t_errorstr
--
END

GO
