-- Object: PROCEDURE citrus_usr.PR_INS_UPD_UNFREEZE_CDSL
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROC [citrus_usr].[PR_INS_UPD_UNFREEZE_CDSL](@pa_id  VARCHAR(8000)
									,@pa_action       VARCHAR(20)	
									,@pa_login_name   VARCHAR(25)	
									,@pa_fre_id		  VARCHAR(20)	
									,@pa_rmks		  VARCHAR(100)
									,@pa_chk_yn       INT 
									,@rowdelimiter    CHAR(4)       = '*|~*'        
									,@coldelimiter    CHAR(4)       = '|*~|'        
									,@pa_errmsg       VARCHAR(8000)  OUTPUT 
									) 
AS
BEGIN
--

declare @l_dp_id varchar(100)
if @pa_fre_id <> ''
select @l_dp_id = fre_dpmid from freeze_Unfreeze_dtls_CDSL where fre_id = @pa_fre_id

	DECLARE @t_errorstr      VARCHAR(8000)      
      , @l_error         BIGINT      
      , @delimeter       VARCHAR(10)      
      , @remainingstring VARCHAR(8000)      
      , @currstring      VARCHAR(8000)      
      , @foundat         INTEGER      
      , @delimeterlength INT   
	  , @line_no         NUMERIC 
	  , @l_int_id        NUMERIC 
	  , @l_int_idm        NUMERIC 	     
      , @delimeter_value VARCHAR(10)      
      , @delimeterlength_value VARCHAR(10)      
      , @remainingstring_value VARCHAR(8000)      
      , @currstring_value VARCHAR(8000)   
	  , @c_fre_deleted_ind VARCHAR(25)  
      , @@c_access_cursor  cursor  
      , @l_deleted_ind   INT  
	  , @c_fre_id       varchar(25)
	 , @c_fre_id1       varchar(25)  		
	
	SET @l_error         = 0      
	SET @t_errorstr      = ''      
	SET @delimeter        = '%'+ @ROWDELIMITER + '%'      
	SET @delimeter        = '%'+ @ROWDELIMITER + '%'      
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

		IF @currstring <> ''      
		BEGIN    
		--
			IF @pa_action = 'INS'     
			BEGIN
			--
				SELECT @l_int_id =ISNULL(MAX(int_id),0) + 1 FROM  freeze_Unfreeze_dtls_cdsl    
				SELECT @l_int_idm =ISNULL(MAX(int_id),0) + 1 FROM  freeze_Unfreeze_dtls_cdsl_mak  
				IF @l_int_idm > @l_int_id    
				BEGIN  
				--  
				SET @l_int_id  = @l_int_idm   
				--  
				END 
				
				IF @pa_chk_yn = 0 
				BEGIN
				--
					SELECT @l_int_id =ISNULL(MAX(int_id),0) + 1 FROM  freeze_Unfreeze_dtls_CDSL    

					BEGIN TRANSACTION
					UPDATE freeze_Unfreeze_dtls_CDSL
					SET fre_status ='I'						
						,fre_lst_upd_by = @pa_login_name
						,fre_lst_upd_dt = getdate()
					WHERE fre_id = convert(numeric,@pa_fre_id)
					AND	fre_deleted_ind = 1
					AND fre_trans_type = 'S'
					AND fre_status = 'A'

					SET @l_error = @@error
					IF @l_error <> 0
					BEGIN
					--
						ROLLBACK TRANSACTION
						SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)      
					--
					END
					ELSE
					BEGIN
					--
						set identity_insert freeze_unfreeze_dtls_cdsl on
						INSERT INTO freeze_Unfreeze_dtls_CDSL
						(int_id
						,fre_id
                        ,fre_dpmid 
						,fre_trans_type
						,fre_status
						,fre_rmks
						,fre_deleted_ind
						,fre_created_by
						,fre_created_dt
						,fre_lst_upd_by
						,fre_lst_upd_dt		
						)values
						(@l_int_id
						,@pa_fre_id
                        ,@l_dp_id
						,'U'
						,'A'
						,@pa_rmks
						,1
						,@pa_login_name
						,getdate()
						,@pa_login_name
						,getdate()
						)

						SET @l_error = @@error
						IF @l_error <> 0
						BEGIN
						--
							ROLLBACK TRANSACTION
							SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)      
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
				END /*END CHK_YN=0*/
				ELSE IF @pa_chk_yn = 1
				BEGIN
				--
					BEGIN TRANSACTION
					set identity_insert freeze_unfreeze_dtls_cdsl_mak on
					INSERT INTO freeze_Unfreeze_dtls_CDSL_mak
					(int_id
					,fre_id
                    ,fre_dpmid
					,fre_trans_type
					,fre_status
					,fre_rmks
					,fre_deleted_ind
					,fre_created_by
					,fre_created_dt
					,fre_lst_upd_by
					,fre_lst_upd_dt		
					)values
					(@l_int_id
					,@pa_fre_id
                    ,@l_dp_id
					,'U'
					,'A'
					,@pa_rmks
					,0
					,@pa_login_name
					,getdate()
					,@pa_login_name
					,getdate()
					)

					SET @l_error = @@error
					IF @l_error <> 0
					BEGIN
					--
						ROLLBACK TRANSACTION
						SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)      
					--
					END
					ELSE
					BEGIN
					--
						COMMIT TRANSACTION
					--
					END
				--
				END /*END CHK_YN=1*/
			--
			END /*END INS*/
			
			IF @pa_action = 'EDT' 	  
			BEGIN
			--	
				IF @pa_chk_yn = 0
				BEGIN
				--
					BEGIN TRANSACTION
					UPDATE freeze_unfreeze_dtls_cdsl
					SET  fre_rmks = @pa_rmks
						,fre_lst_upd_by = @pa_login_name
						,fre_lst_upd_dt  = getdate()
					WHERE int_id = convert(numeric,@pa_id)	  
					AND	fre_deleted_ind = 1
					AND fre_trans_type = 'U'

					SET @l_error = @@error
					IF @l_error <> 0
					BEGIN
					--
						ROLLBACK TRANSACTION
						SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)      
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
				ELSE IF @pa_chk_yn = 1
				BEGIN
				--
					BEGIN TRANSACTION
					UPDATE freeze_unfreeze_dtls_cdsl_mak
					SET fre_deleted_ind = 2
						,fre_lst_upd_by = @pa_login_name
						,fre_lst_upd_dt = getdate()
					WHERE int_id = convert(numeric,@pa_id)
					AND fre_deleted_ind = 0
					AND	fre_status = 'A' 
					
					SET @l_error = @@error
					IF @l_error <> 0
					BEGIN
					--
						ROLLBACK TRANSACTION
						SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)      
					--
					END
					ELSE
					BEGIN
					--
						IF EXISTS(SELECT fre_id  FROM freeze_unfreeze_dtls_cdsl WHERE int_id = convert(numeric,@pa_id) AND fre_deleted_ind = 1 AND fre_status ='A' AND fre_trans_type ='U' )
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
						set identity_insert freeze_unfreeze_dtls_cdsl_mak on
						INSERT INTO freeze_unfreeze_dtls_cdsl_mak
						(int_id
						,fre_id
                        ,fre_dpmid
						,fre_trans_type
						,fre_status
						,fre_rmks
						,fre_deleted_ind
						,fre_created_by
						,fre_created_dt
						,fre_lst_upd_by
						,fre_lst_upd_dt		
						)values
						(convert(numeric,@pa_id)
						,@pa_fre_id
                        ,@l_dp_id
						,'U'
						,'A'
						,@pa_rmks
						,@l_deleted_ind
						,@pa_login_name
						,getdate()
						,@pa_login_name
						,getdate()
						)

						SET @l_error = @@error
						IF @l_error <> 0
						BEGIN
						--
							ROLLBACK TRANSACTION
							SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)      
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
			END /*EDT*/	
			IF @pa_action='DEL'
			BEGIN
			--
				IF @pa_chk_yn = 0
				BEGIN
				--
					SELECT @l_int_id =int_id FROM  freeze_Unfreeze_dtls_cdsl  where fre_id = convert(numeric,@pa_fre_id) and fre_trans_type = 'U' and fre_deleted_ind =1    
					BEGIN TRANSACTION
					UPDATE freeze_unfreeze_dtls_cdsl
					SET fre_deleted_ind = 0
						,fre_lst_upd_by = @pa_login_name
						,fre_lst_upd_dt = getdate()
					WHERE int_id = convert(numeric,@l_int_id)
					AND	fre_deleted_ind = 1
					AND fre_trans_type = 'U' 
					
					SET @l_error = @@error
					IF @l_error <> 0
					BEGIN
					--
						ROLLBACK TRANSACTION
						SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)      
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
				ELSE IF @pa_chk_yn = 1
				BEGIN
				--
					BEGIN TRANSACTION
					IF EXISTS(select fre_id from freeze_unfreeze_dtls_cdsl_mak WHERE int_id = convert(numeric,@pa_id) AND fre_deleted_ind in (0,4) AND fre_trans_type = 'U' )
					BEGIN	
					--
						DELETE FROM freeze_unfreeze_dtls_cdsl_mak
						WHERE int_id  =  convert(numeric,@pa_id)
						AND fre_trans_type = 'U'
						AND fre_deleted_ind = 0
					--
					END
					ELSE
					BEGIN
					--
						set identity_insert freeze_unfreeze_dtls_cdsl_mak on
						INSERT INTO freeze_unfreeze_dtls_cdsl_mak
						(int_id
						,fre_id
                         ,fre_dpmid
						,fre_trans_type
						,fre_status
						,fre_rmks
						,fre_deleted_ind
						,fre_created_by
						,fre_created_dt
						,fre_lst_upd_by
						,fre_lst_upd_dt		
						)SELECT
						int_id
						,fre_id
                        ,fre_dpmid
						,fre_trans_type
						,fre_status
						,fre_rmks
						,4
						,fre_created_by
						,fre_created_dt
						,@pa_login_name
						,getdate()
						FROM freeze_unfreeze_dtls_cdsl
						WHERE int_id = convert(numeric,@pa_id)
						AND fre_trans_type ='U'
						AND fre_deleted_ind = 1
						AND	fre_status = 'A'  
					--
					END
					SET @l_error = @@error
					IF @l_error <> 0
					BEGIN
					--
						ROLLBACK TRANSACTION
						SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)      
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
			END /*DEL*/		
			IF @pa_action = 'APP'	
			BEGIN
			--
				SET @@c_access_cursor =  CURSOR fast_forward FOR   
				SELECT int_id,fre_id,fre_deleted_ind FROM freeze_unfreeze_dtls_cdsl_mak WHERE int_id = CONVERT(NUMERIC,@currstring) and fre_deleted_ind in (0,4,6) and fre_status ='A' and fre_trans_type = 'U'      
				OPEN @@c_access_cursor 
				FETCH NEXT FROM @@c_access_cursor INTO @c_fre_id,@c_fre_id1,@c_fre_deleted_ind
				
				WHILE @@fetch_status = 0   
				BEGIN
				--
					BEGIN TRANSACTION
					UPDATE freeze_Unfreeze_dtls_CDSL
					SET fre_status ='I'						
						,fre_lst_upd_by = @pa_login_name
						,fre_lst_upd_dt = getdate()
					WHERE fre_id = convert(numeric,@c_fre_id1)
					AND	fre_deleted_ind = 1
					AND fre_trans_type = 'S'
					AND fre_status = 'A'
					
					IF EXISTS(select * from freeze_unfreeze_dtls_CDSL_mak where int_id=CONVERT(NUMERIC,@c_fre_id) and fre_deleted_ind =6 AND  fre_trans_type ='U')  
					BEGIN
					--
						UPDATE freeze_unfreeze_dtls_CDSL
						SET fre_id = frzufrzm.fre_id
							,fre_trans_type = frzufrzm.fre_trans_type
							,fre_rmks			 = frzufrzm.fre_rmks
							,fre_status			 = frzufrzm.fre_status
							,fre_lst_upd_by      = @pa_login_name
							,fre_lst_upd_dt		 = getdate()
						FROM freeze_unfreeze_dtls_cdsl frzufrz  
							,freeze_unfreeze_dtls_cdsl_mak frzufrzm  
						WHERE frzufrzm.int_id=convert(numeric,@c_fre_id)       
						AND   frzufrz.int_id =frzufrzm.int_id  
						AND   frzufrzm.fre_deleted_ind =6 
 	
						SET @l_error = @@error
						IF @l_error <> 0
						BEGIN
						--
							ROLLBACK TRANSACTION
							SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)      
						--
						END
						ELSE
						BEGIN
						--
							UPDATE freeze_unfreeze_dtls_CDSL_mak  
							SET    fre_deleted_ind =7  
							,fre_lst_upd_by  =@pa_login_name  
							,fre_lst_upd_dt  =getdate()  
							WHERE  INT_id = CONVERT(NUMERIC,@c_fre_id)        
							AND    fre_deleted_ind  = 6 
							AND	   fre_trans_type = 'U' 
							COMMIT TRANSACTION
						--
						END
					--
					END
					ELSE IF exists(select * from freeze_unfreeze_dtls_cdsl_mak where int_id = convert(numeric,@c_fre_id) and fre_deleted_ind = 0 AND fre_trans_type = 'U')
					BEGIN
					--
						set identity_insert freeze_unfreeze_dtls_cdsl on
						INSERT INTO freeze_unfreeze_dtls_cdsl
						(int_id
						,fre_id
                        ,fre_dpmid 
						,fre_trans_type
						,fre_status
						,fre_rmks
						,fre_deleted_ind
						,fre_created_by
						,fre_created_dt
						,fre_lst_upd_by
						,fre_lst_upd_dt	
						)select
						int_id
						,fre_id
                        ,fre_dpmid
						,fre_trans_type
						,fre_status
						,fre_rmks
						,1
						,fre_created_by
						,fre_created_dt
						,@pa_login_name
						,getdate()
						FROM  freeze_unfreeze_dtls_cdsl_mak
						WHERE int_id          = convert(numeric,@c_fre_id)
						AND   fre_deleted_ind = 0
						AND   fre_trans_type ='U'
						
						SET @l_error = @@error
						IF @l_error <> 0
						BEGIN
						--
							ROLLBACK TRANSACTION
							SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)      
						--
						END
						ELSE
						BEGIN
						--
							UPDATE freeze_unfreeze_dtls_CDSL_mak  
							SET    fre_deleted_ind =1  
							,fre_lst_upd_by  =@pa_login_name  
							,fre_lst_upd_dt  =getdate()  
							WHERE  INT_id = CONVERT(NUMERIC,@c_fre_id)        
							AND    fre_deleted_ind  = 0 
							AND	   fre_trans_type = 'U' 
							COMMIT TRANSACTION
						--
						END
					--
					END	
					ELSE
					BEGIN
					--
						UPDATE freeze_unfreeze_dtls_cdsl
						SET    fre_deleted_ind =0  
						,fre_lst_upd_by  =@pa_login_name  
						,fre_lst_upd_dt  =getdate()  
						WHERE  int_id = CONVERT(NUMERIC,@c_fre_id)        
						AND    fre_deleted_ind  = 1 
						AND    fre_trans_type = 'U' 

						UPDATE freeze_unfreeze_dtls_cdsl_mak  
						SET    fre_deleted_ind =5  
						,fre_lst_upd_by  =@pa_login_name  
						,fre_lst_upd_dt  =getdate()  
						WHERE  int_id = CONVERT(NUMERIC,@c_fre_id)        
						AND    fre_deleted_ind  = 4  
						AND    fre_trans_type = 'U'
		        
						COMMIT TRANSACTION       	
					--
					END
					FETCH NEXT FROM @@c_access_cursor INTO @c_fre_id,@c_fre_id1,@c_fre_deleted_ind   
				--
				END
				CLOSE      @@c_access_cursor          
				DEALLOCATE @@c_access_cursor  
			--
			END	/*APP*/	
			ELSE IF @pa_action = 'REJ'
			BEGIN
			--
				BEGIN TRANSACTION
				UPDATE freeze_unfreeze_dtls_cdsl_mak  
				SET fre_deleted_ind =3  
					,fre_lst_upd_by  =@pa_login_name  
					,fre_lst_upd_dt  =getdate()  
				WHERE  int_id = CONVERT(NUMERIC,@currstring)
				AND    fre_deleted_ind  in (0,4,6)
				
				SET @l_error = @@error
				IF @l_error <> 0
				BEGIN
				--
					ROLLBACK TRANSACTION
					SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)      
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
		END /*IF @currstring <> ''      */
	--
	END /*WHILE @remainingstring */
--
END

GO
