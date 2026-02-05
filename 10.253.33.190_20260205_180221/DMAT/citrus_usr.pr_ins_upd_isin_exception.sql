-- Object: PROCEDURE citrus_usr.pr_ins_upd_isin_exception
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

Create procedure [citrus_usr].[pr_ins_upd_isin_exception]
(
		@pa_id 		varchar(30)
	,@pa_action 	varchar(10)
	,@pa_login_name varchar(25)
	,@pa_values    	varchar(8000)
	,@rowdelimiter  char(4)  
	,@coldelimiter  char(4)  
	,@Pa_errmsg     VARCHAR(8000) OUT 
)
AS
BEGIN
--
	DECLARE @t_errorstr      VARCHAR(8000)    
								,@l_error         BIGINT    
								,@delimeter       VARCHAR(10)    
								,@remainingstring VARCHAR(8000)    
								,@currstring      VARCHAR(8000)    
								,@foundat         INTEGER    
								,@delimeterlength INT 
								,@delimeter_value VARCHAR(10)    
								,@delimeterlength_value VARCHAR(10)    
								,@remainingstring_value VARCHAR(8000)    
								,@currstring_value VARCHAR(8000) 
								,@l_action       VARCHAR(25)
								,@line_no        int
								,@l_id	            numeric
								,@l_isin_cd   varchar(25)
								,@l_excep_type   varchar(25)
								,@l_intid 	NUMERIC
		
		SET @l_error         = 0
		SET @t_errorstr      = ''
		SET @delimeter        = '%'+ @ROWDELIMITER + '%'
		SET @delimeterlength = LEN(@ROWDELIMITER)
		SET @remainingstring = @pa_id  
		
			IF @pa_action ='INS'
			BEGIN
			--		
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
										  	
										  SET @l_action             = citrus_usr.fn_splitval(@currstring_value,1)      
																				  
												IF @l_action = 'A' OR @l_action ='E'
												BEGIN
												--
												  
													SET @l_action        				=	citrus_usr.fn_splitval(@currstring_value,1)                            
													SET @l_isin_cd      = citrus_usr.fn_splitval(@currstring_value,2)
													SET @l_excep_type      = citrus_usr.fn_splitval(@currstring_value,3)
												--
												END
																						
											  SELECT @l_intid = isnull(max(isinem_id),0) +1 from isin_exception_mstr
											  	
															BEGIN TRANSACTION												
																	INSERT into isin_exception_mstr
																	(isinem_id
																	,isinem_isin_cd
																	,isinem_excep_type
																	,isinem_created_by
																	,isinem_created_dt
																	,isinem_lst_upd_by
																	,isinem_lst_upd_dt
																	,isinem_deleted_ind
																	)values
																	(@l_intid
																	,@l_isin_cd
																	,@l_excep_type
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
																		COMMIT TRANSACTION
																		UPDATE isin_mstr 
																		SET 			isin_filler = @l_excep_type 
																		WHERE 	isin_cd = @l_isin_cd
																	AND   	isin_deleted_ind = 1
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
				--
				END
							
				ELSE IF @pa_action ='DEL'
				BEGIN
				--
						
						UPDATE isin_exception_mstr
						SET 	isinem_deleted_ind = 0
										,isinem_lst_upd_by = @pa_login_name
										,isinem_lst_upd_dt = getdate()
						WHERE isinem_id  = convert(numeric,@pa_id)			 
						AND		isinem_deleted_ind = 1

						UPDATE isin_mstr 
						SET 			isin_filler = '' 
						WHERE 	isin_cd = @pa_values
						AND   	isin_deleted_ind = 1 
					--
			END
  SET @pa_errmsg = @t_errorstr
--
END

GO
