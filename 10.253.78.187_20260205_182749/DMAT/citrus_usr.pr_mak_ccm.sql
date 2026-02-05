-- Object: PROCEDURE citrus_usr.pr_mak_ccm
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create PROCEDURE [citrus_usr].[pr_mak_ccm](@pa_id          VARCHAR(8000)  
																									, @pa_action      VARCHAR(20)  
																									, @pa_login_name  VARCHAR(20)  
																									, @pa_excm_val    VARCHAR(8000)
																									, @pa_ccm_cd      VARCHAR(20)    
																									, @pa_ccm_name    VARCHAR(100)   
																									, @pa_chk_yn      INT  
																									, @rowdelimiter   CHAR(4)       = '*|~*'  
																									, @coldelimiter   CHAR(4)       = '|*~|'  
																									, @pa_errmsg      VARCHAR(8000) output  
)  
AS
/*
*********************************************************************************
 SYSTEM         : dp
 MODULE NAME    : pr_mak_ccm
 DESCRIPTION    : this procedure will contain the maker checker facility for cc_mstr
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
      , @l_ccm_id        NUMERIC
      , @l_ccmm_id       NUMERIC
      , @l_excsm_bit     NUMERIC
      , @delimeter_value varchar(10)
      , @delimeterlength_value varchar(10)
      , @remainingstring_value varchar(8000)
      , @currstring_value varchar(8000)
      , @l_access1      int
      , @l_access       int
      , @l_excm_id      numeric
      , @l_excm_cd      VARCHAR(500)


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
    SET @delimeter_value        = '%'+ @coldelimiter + '%'
				SET @delimeterlength_value = LEN(@coldelimiter)
				SET @remainingstring_value = @pa_excm_val
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
        
											  
								SET  @l_excm_id = CONVERT(NUMERIC,@currstring_value)
								
								SELECT @l_excm_cd = isnull(@l_excm_cd,'') + excm_cd + ',' from exchange_mstr where excm_id = @l_excm_id AND  excm_deleted_ind  = 1 
        
								SET    @c_access_cursor =  CURSOR fast_forward FOR
								SELECT bitrm_bit_location
								FROM   Exch_Seg_Mstr
													, exchange_mstr
													, bitmap_ref_mstr
								WHERE  excm_id           = @l_excm_id
								AND    excm_cd           = excsm_exch_cd
								AND    excsm_desc  = bitrm_child_cd
								AND    excsm_deleted_ind = 1
								AND    excm_deleted_ind  = 1

								OPEN @c_access_cursor
								FETCH NEXT FROM @c_access_cursor INTO @l_access	

								WHILE @@fetch_status = 0
								BEGIN
								--
										SET @l_access1 = POWER(2,@l_access-1) | @l_access1

										FETCH NEXT FROM @c_access_cursor INTO @l_access
								--
								END

								CLOSE      @c_access_cursor
								DEALLOCATE @c_access_cursor
        

						--
						END
    --
    END
    IF @pa_chk_yn = 0
				BEGIN
				--
				  IF @pa_action = 'INS'
						BEGIN
						--
								BEGIN TRANSACTION

								SELECT @l_ccm_id = ISNULL(MAX(ccm_id),0)+ 1 FROM  cc_mstr WITH (NOLOCK) 

								INSERT INTO cc_mstr
								( ccm_id
								, ccm_cd
								, ccm_name
								, ccm_excsm_bit
								, ccm_created_by
								, ccm_created_dt
								, ccm_lst_upd_by
								, ccm_lst_upd_dt
								, ccm_deleted_ind
								)
								VALUES
								( @l_ccm_id 
								, @pa_ccm_cd
								, @pa_ccm_name
								, @l_access1
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

										SET @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar,@pa_ccm_cd)+@coldelimiter+isnull(@pa_ccm_name,'')+ @coldelimiter + @l_excm_cd+ @coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter
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

								UPDATE cc_mstr
								SET    ccm_cd          = @pa_ccm_cd
													, ccm_name        = @pa_ccm_name
													, ccm_excsm_bit   = @l_access1
													, ccm_lst_upd_by  = @pa_login_name
													, ccm_lst_upd_dt  = getdate()
								WHERE  ccm_id          = CONVERT(INT,@currstring)
								AND    ccm_deleted_ind = 1


								SET @l_error = @@error
								IF @l_error <> 0
								BEGIN
								--
										ROLLBACK TRANSACTION 

										SET @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar,@pa_ccm_cd)+@coldelimiter+isnull(@pa_ccm_name,'')+ @coldelimiter +@l_excm_cd+ @coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter
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

								UPDATE cc_mstr
								SET    ccm_deleted_ind = 0 
													, ccm_lst_upd_by  = @pa_login_name
													, ccm_lst_upd_dt  = getdate()
								WHERE  ccm_id          = CONVERT(INT,@currstring)
								AND    ccm_deleted_ind = 1

								SET @l_error = @@error
								IF @l_error <> 0
								BEGIN
								--
										ROLLBACK TRANSACTION 

										SELECT @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar,ccm_cd)+@coldelimiter+isnull(ccm_name,'')+ @coldelimiter + replace(citrus_usr.fn_merge_str('cc_mstr',ccm_id,'cd'),'|*~|',',')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter
										FROM   cc_mstr
										WHERE  ccm_id           = CONVERT(INT,@currstring)
										and    ccm_deleted_ind  = 1
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

								SELECT @l_ccmm_id = ISNULL(MAX(ccm_id),0)+ 1 FROM  ccm_mak WITH (NOLOCK)

								SELECT @l_ccm_id = ISNULL(MAX(ccm_id),0)+ 1 FROM  cc_mstr WITH (NOLOCK)

								IF @l_ccmm_id  > @l_ccm_id 
								BEGIN
								--
										SET @l_ccm_id = @l_ccmm_id
								--
								END

								INSERT INTO ccm_mak
								( ccm_id
								, ccm_cd
								, ccm_name
								, ccm_excsm_bit
								, ccm_created_by
								, ccm_created_dt
								, ccm_lst_upd_by
								, ccm_lst_upd_dt
								, ccm_deleted_ind
								)
								VALUES
								( @l_ccm_id 
								, @pa_ccm_cd
								, @pa_ccm_name
								, @l_access1
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

										SET    @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar,@pa_ccm_cd)+@coldelimiter+isnull(@pa_ccm_name,'')+ @coldelimiter + @l_excm_cd+ @coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter
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

								UPDATE ccm_mak
								SET    ccm_deleted_ind = 2
													, ccm_lst_upd_by  = @pa_login_name
													, ccm_lst_upd_dt  = getdate()
								WHERE  ccm_id          = CONVERT(INT,@currstring)
								AND    ccm_deleted_ind = 0


								SET @l_error = @@error
								IF @l_error <> 0
								BEGIN
								--
										ROLLBACK TRANSACTION

										SET    @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar,@pa_ccm_cd)+@coldelimiter+isnull(@pa_ccm_name,'')+ @coldelimiter + @l_excm_cd+ @coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter
								--
								END
								ELSE
								BEGIN
								--
										SELECT @l_ccmm_id = ISNULL(MAX(ccm_id),0)+ 1 FROM  ccm_mak WITH (NOLOCK)

										SELECT @l_ccm_id = ISNULL(MAX(ccm_id),0)+ 1 FROM  cc_mstr WITH (NOLOCK)

										IF @l_ccmm_id  > @l_ccm_id 
										BEGIN
										--
												SET @l_ccm_id = @l_ccmm_id
										--
										END

										INSERT INTO ccm_mak
										( ccm_id
										, ccm_cd
										, ccm_name
										, ccm_excsm_bit
										, ccm_created_by
										, ccm_created_dt
										, ccm_lst_upd_by
										, ccm_lst_upd_dt
										, ccm_deleted_ind
										)
										VALUES
										( @l_ccm_id 
										, @pa_ccm_cd
										, @pa_ccm_name
										, @l_access1
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

												SET    @t_errorstr = @t_errorstr+@currstring+@coldelimiter+convert(varchar,@pa_ccm_cd)+@coldelimiter+isnull(@pa_ccm_name,'')+ @coldelimiter + @l_excm_cd+ @coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter
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
        end 
        IF @pa_action = 'APP'
								BEGIN
						  --
						    BEGIN TRANSACTION
																  
											IF EXISTS(select * from cc_mstr where ccm_id = convert(numeric,@currstring) and ccm_deleted_ind = 1)
											BEGIN
											--
													UPDATE cc_mstr
													SET    ccm_cd               = ccmm.ccm_cd
																		, ccm_name             = ccmm.ccm_name
																		, ccm_excsm_bit        = ccmm.ccm_excsm_bit
																		, ccm_lst_upd_by       = @pa_login_name
																		, ccm_lst_upd_dt       = getdate()
													FROM   ccm_mak                ccmm					
													WHERE  ccmm.ccm_id          = CONVERT(INT,@currstring)
													AND    ccmm.ccm_deleted_ind = 0

													SET @l_error = @@error
													IF @l_error <> 0
													BEGIN
													--
															ROLLBACK TRANSACTION 

															SELECT @t_errorstr = isnull(@t_errorstr,'')+@currstring+@coldelimiter+convert(varchar,ccm_cd)+@coldelimiter+isnull(ccm_name,'')+ @coldelimiter + isnull(replace(citrus_usr.fn_merge_str('cc_mstr',ccm_id,'cd'),'|*~|',','),'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter
															FROM   ccm_mak 
															WHERE  ccm_id           = CONVERT(INT,@currstring)
															AND    ccm_deleted_ind  = 0
													--
													END
													ELSE
													BEGIN
													--
															UPDATE ccm_mak 
															SET    ccm_deleted_ind = 1
																				, ccm_lst_upd_by  = @pa_login_name
																				, ccm_lst_upd_dt  = getdate()
															WHERE  ccm_id          = convert(numeric,@currstring)
															AND    ccm_deleted_ind = 0

															COMMIT TRANSACTION
													--
													END
											--
						    END
						    ELSE
								  BEGIN
								  --
										INSERT INTO cc_mstr
										( ccm_id
										, ccm_cd
										, ccm_name
										, ccm_excsm_bit
										, ccm_created_by
										, ccm_created_dt
										, ccm_lst_upd_by
										, ccm_lst_upd_dt
										, ccm_deleted_ind
										)
										SELECT ccm_id
										, ccm_cd
										, ccm_name
										, ccm_excsm_bit
										, ccm_created_by
										, ccm_created_dt
										, ccm_lst_upd_by
										, ccm_lst_upd_dt
										, 1
										FROM  ccm_mak
										WHERE ccm_id = convert(numeric,@currstring)
										AND   ccm_deleted_ind = 0

										SET @l_error = @@error
										IF @l_error <> 0
										BEGIN
										--
												ROLLBACK TRANSACTION 

												SELECT @t_errorstr = isnull(@t_errorstr,'')+@currstring+@coldelimiter+convert(varchar,ccm_cd)+@coldelimiter+isnull(ccm_name,'')+ @coldelimiter + isnull(replace(citrus_usr.fn_merge_str('cc_mstr',ccm_id,'cd'),'|*~|',','),'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter
												FROM   ccm_mak 
												WHERE  ccm_id           = CONVERT(INT,@currstring)
												AND    ccm_deleted_ind  = 0
										--
										END
										ELSE
										BEGIN
										--
												UPDATE ccm_mak 
												SET    ccm_deleted_ind = 1
																	, ccm_lst_upd_by  = @pa_login_name
																	, ccm_lst_upd_dt  = getdate()
												WHERE  ccm_id          = convert(numeric,@currstring)
												AND    ccm_deleted_ind = 0


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
										BEGIN TRANSACTION

										UPDATE ccm_mak 
										SET    ccm_deleted_ind = 3
															, ccm_lst_upd_by  = @pa_login_name
															, ccm_lst_upd_dt  = getdate()
										WHERE  ccm_id          = convert(numeric,@currstring)
										AND    ccm_deleted_ind = 0



										SET @l_error = @@error
										IF @l_error <> 0
										BEGIN
										--
												ROLLBACK TRANSACTION 

												SELECT @t_errorstr = isnull(@t_errorstr,'')+@currstring+@coldelimiter+convert(varchar,ccm_cd)+@coldelimiter+isnull(ccm_name,'')+ @coldelimiter + isnull(replace(citrus_usr.fn_merge_str('cc_mstr',ccm_id,'cd'),'|*~|',','),'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter
												FROM   ccm_mak 
												WHERE  ccm_id           = CONVERT(INT,@currstring)
												AND    ccm_deleted_ind  = 0
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
  set @pa_errmsg = @t_errorstr
  
--
END

GO
