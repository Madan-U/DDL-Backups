-- Object: PROCEDURE citrus_usr.pr_mak_loosm
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--begin transaction
--pr_mak_loosm '54*|~*','APP','HEAD','',0,'','',0,0,0,1,'*|~*','|*~|',''	
--rollback transaction


create PROCEDURE [citrus_usr].[pr_mak_loosm](@pa_id                VARCHAR(8000)  
                           , @pa_action            VARCHAR(20)  
                           , @pa_login_name        VARCHAR(20)  
                           , @pa_loosm_seri_type   VARCHAR(20)   = ''  
                           , @pa_loosm_entm_id     NUMERIC
                           , @pa_loosm_dpm_id      varchar(20)
                           , @pa_loosm_sba_no      VARCHAR(20)
                           , @pa_loosm_sl_bk_no    NUMERIC
                           , @pa_loosm_sl_bk_no_fr NUMERIC
                           , @pa_loosm_sl_bk_no_to NUMERIC
                           , @pa_chk_yn            INT  
                           , @rowdelimiter         CHAR(4)       = '*|~*'  
                           , @coldelimiter         CHAR(4)       = '|*~|'  
                           , @pa_errmsg            VARCHAR(8000) output  
)  
AS
/*********************************************************************************
 SYSTEM         : dp
 MODULE NAME    : pr_mak_loosm
 DESCRIPTION    : this procedure will contain the maker checker facility for loose_slip_mstr
 COPYRIGHT(C)   : marketplace technologies 
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  --------------------------------------------------
 1.0    TUSHAR            10-OCT-2007   VERSION.
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
      , @l_loosm_id           NUMERIC
      , @l_loosmm_id          NUMERIC
      , @l_excm_id            NUMERIC
      , @l_loosm_series_type	 VARCHAR(50)
      , @l_loosm_slip_book_no NUMERIC
      , @l_loosm_slip_no_from	VARCHAR(25)
      , @l_loosm_slip_no_to  	VARCHAR(25)
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
    SELECT @l_dp_id = dpm_id FROM dp_mstr WHERE dpm_dpid  = @pa_loosm_dpm_id AND  dpm_deleted_ind = 1
    
    IF @pa_chk_yn = 0
    BEGIN
    --
						IF @pa_action = 'INS'
						BEGIN
						--
						  BEGIN TRANSACTION
						  
						  IF EXISTS(SELECT loosm_id FROM loose_slip_mstr WITH(NOLOCK) WHERE loosm_series_type = @pa_loosm_seri_type AND ((@pa_loosm_sl_bk_no_fr BETWEEN loosm_slip_no_from AND loosm_slip_no_to) OR (@pa_loosm_sl_bk_no_to BETWEEN loosm_slip_no_from AND loosm_slip_no_to)) AND loosm_deleted_ind = 1)
					   BEGIN
					   --
					     SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'
					   --   
					   END
						  ELSE
						  BEGIN
						  
										SELECT @l_loosm_id = ISNULL(MAX(loosm_id),0)+ 1 FROM  loose_slip_mstr WITH (NOLOCK) 

										INSERT INTO loose_slip_mstr
										( loosm_id
										, loosm_series_type
										, loosm_entm_id
										, loosm_dpm_id
										, loosm_dpam_sba_no
										, loosm_slip_book_no
										, loosm_slip_no_from
										, loosm_slip_no_to
										, loosm_created_by
										, loosm_created_dt
										, loosm_lst_upd_by
										, loosm_lst_upd_dt
										, loosm_deleted_ind
										)
										VALUES
										( @l_loosm_id 
										, @pa_loosm_seri_type
										, @pa_loosm_entm_id
										, @l_dp_id
										, @pa_loosm_sba_no
										, @pa_loosm_sl_bk_no
										, @pa_loosm_sl_bk_no_fr
										, @pa_loosm_sl_bk_no_to
										, @pa_login_name
										, getdate()
										, @pa_login_name
										, getdate()
										, 1
										)
										
        END
								
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
        
						  UPDATE loose_slip_mstr
								SET    loosm_series_type = @pa_loosm_seri_type
													, loosm_entm_id     = @pa_loosm_entm_id
													, loosm_dpm_id      = @l_dp_id
													, loosm_dpam_sba_no = @pa_loosm_sba_no
													, loosm_slip_book_no= @pa_loosm_sl_bk_no 
													, loosm_slip_no_from= @pa_loosm_sl_bk_no_fr
													, loosm_slip_no_to  = @pa_loosm_sl_bk_no_to
													, loosm_lst_upd_dt  = getdate()
													, loosm_lst_upd_by  = @pa_login_name
								WHERE  loosm_id          = CONVERT(INT,@currstring)
        AND    loosm_deleted_ind = 1
								
								
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
								
								UPDATE loose_slip_mstr
								SET    loosm_lst_upd_dt  = getdate()
								      ,loosm_lst_upd_by  = @pa_login_name
														,loosm_deleted_ind = 0
								WHERE  loosm_id          = CONVERT(INT,@currstring)
        AND    loosm_deleted_ind = 1
								
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
        
        SELECT @l_loosmm_id = ISNULL(MAX(loosm_id),0)+ 1 FROM  loose_slip_mstr WITH (NOLOCK)

        SELECT @l_loosm_id = ISNULL(MAX(loosm_id),0)+ 1 FROM  loosm_mak WITH (NOLOCK)

        IF @l_loosmm_id  > @l_loosm_id 
        BEGIN
        --
          SET @l_loosm_id = @l_loosmm_id
        --
        END
        
								INSERT INTO loosm_mak
								( loosm_id
							 , loosm_series_type
								, loosm_entm_id
								, loosm_dpm_id
								, loosm_dpam_sba_no
								, loosm_slip_book_no
								, loosm_slip_no_from
								, loosm_slip_no_to
								, loosm_created_by
								, loosm_created_dt
								, loosm_lst_upd_by
								, loosm_lst_upd_dt
								, loosm_deleted_ind 
								)
								VALUES
								( @l_loosm_id 
        , @pa_loosm_seri_type
								, @pa_loosm_entm_id
								, @l_dp_id
								, @pa_loosm_sba_no
								, @pa_loosm_sl_bk_no
								, @pa_loosm_sl_bk_no_fr
								, @pa_loosm_sl_bk_no_to
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
								
							 UPDATE loosm_mak
								SET    loosm_deleted_ind = 2
								     , loosm_lst_upd_dt  = getdate()
								     , loosm_lst_upd_by  = @pa_login_name
								WHERE  loosm_id          = CONVERT(INT,@currstring)
        AND    loosm_deleted_ind = 0
								
								
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
								  IF EXISTS(select * from loose_slip_mstr where loosm_id = CONVERT(INT,@currstring) and loosm_deleted_ind = 1)
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
								  
								  SELECT @l_loosmm_id = ISNULL(MAX(loosm_id),0)+ 1 FROM  loosm_mak WITH (NOLOCK)

          SELECT @l_loosm_id = ISNULL(MAX(loosm_id),0)+ 1 FROM  loose_slip_mstr WITH (NOLOCK)

		        IF @l_loosmm_id  > @l_loosm_id 
		        BEGIN
		        --
		          SET @l_loosm_id = @l_loosmm_id
		        --
		        END
								        
										INSERT INTO loosm_mak
										( loosm_id
										, loosm_series_type
										, loosm_entm_id
										, loosm_dpm_id
										, loosm_dpam_sba_no
										, loosm_slip_book_no
										, loosm_slip_no_from
										, loosm_slip_no_to
										, loosm_created_by
										, loosm_created_dt
										, loosm_lst_upd_by
										, loosm_lst_upd_dt
										, loosm_deleted_ind  
										)
										VALUES
										( @l_loosm_id 
										, @pa_loosm_seri_type
										, @pa_loosm_entm_id
										, @l_dp_id
										, @pa_loosm_sba_no
										, @pa_loosm_sl_bk_no
										, @pa_loosm_sl_bk_no_fr
										, @pa_loosm_sl_bk_no_to
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
									IF exists(SELECT * FROM loosm_mak WHERE loosm_id = convert(numeric,@currstring) and loosm_deleted_ind in(0,4))
									BEGIN
									--
									  DELETE FROM loosm_mak 
									  WHERE loosm_id = convert(numeric,@currstring)
									  AND   loosm_deleted_ind = 0
									--
									END
									ELSE
									BEGIN
									--
									  INSERT INTO loosm_mak
											( loosm_id
											, loosm_series_type
											, loosm_entm_id
											, loosm_dpm_id
											, loosm_dpam_sba_no
											, loosm_slip_book_no
											, loosm_slip_no_from
											, loosm_slip_no_to
											, loosm_created_by
											, loosm_created_dt
											, loosm_lst_upd_by
											, loosm_lst_upd_dt
											, loosm_deleted_ind  
 										)
 										SELECT loosm_id
											, loosm_series_type
											, loosm_entm_id
											, loosm_dpm_id
											, loosm_dpam_sba_no
											, loosm_slip_book_no
											, loosm_slip_no_from
											, loosm_slip_no_to
											, loosm_created_by
											, loosm_created_dt
											, @pa_login_name
											, getdate()
											, 4
											FROM  loose_slip_mstr
											WHERE loosm_id          = convert(numeric,@currstring)
											AND   loosm_deleted_ind = 1
									--
									END
						--
						END
						IF @pa_action = 'APP'
						BEGIN
						--
        BEGIN TRANSACTION
						  
						  
						  
						  IF EXISTS(select * from loosm_mak where loosm_id = convert(numeric,@currstring) and loosm_deleted_ind = 4)
						  BEGIN
						  --
						    UPDATE loose_slip_mstr            
								  SET    loosm_series_type        =		loosmm.loosm_series_type     
															, loosm_entm_id            = 	loosmm.loosm_entm_id         
															, loosm_dpm_id             =		loosmm.loosm_dpm_id          
															, loosm_dpam_sba_no        =		loosmm.loosm_dpam_sba_no     
															, loosm_slip_book_no       =		loosmm.loosm_slip_book_no    
															, loosm_slip_no_from       =		loosmm.loosm_slip_no_from    
															, loosm_slip_no_to         =		loosmm.loosm_slip_no_to      
															, loosm_lst_upd_by         =		loosmm.loosm_lst_upd_by      
										     , loosm_lst_upd_dt         =		loosmm.loosm_lst_upd_dt      
								  FROM   loosm_mak                   loosmm
								  WHERE  loosmm.loosm_id          =  convert(numeric,@currstring)
								  AND    loosmm.loosm_deleted_ind =  6 
								  
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
												UPDATE loosm_mak 
												SET    loosm_deleted_ind = 7
												     , loosm_lst_upd_by  = @pa_login_name
                 , loosm_lst_upd_dt  = getdate()
												WHERE  loosm_id          = convert(numeric,@currstring)
												AND    loosm_deleted_ind = 6

												COMMIT TRANSACTION
										--
										END
        --
						  END
						  ELSE IF exists(select * from loosm_mak where loosm_id = convert(numeric,@currstring) and loosm_deleted_ind = 0)
						  BEGIN
						  --
          

						    IF EXISTS(SELECT loosm.loosm_id FROM loose_slip_mstr loosm , loosm_mak loosmm WITH(NOLOCK) WHERE loosm.loosm_series_type = loosmm.loosm_series_type AND ((loosm.loosm_slip_no_from BETWEEN loosmm.loosm_slip_no_from AND loosmm.loosm_slip_no_to) OR (loosm.loosm_slip_no_to BETWEEN loosmm.loosm_slip_no_from AND loosmm.loosm_slip_no_to)) AND loosm.loosm_deleted_ind = 1 and loosmm.loosm_id = CONVERT(int,@currstring))
										BEGIN
										--
												SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'
										--   
  					   END
  					   ELSE
  					   BEGIN
						    --
												INSERT INTO loose_slip_mstr
												( loosm_id
												, loosm_series_type
												, loosm_entm_id
												, loosm_dpm_id
												, loosm_dpam_sba_no
												, loosm_slip_book_no
												, loosm_slip_no_from
												, loosm_slip_no_to
												, loosm_created_by
												, loosm_created_dt
												, loosm_lst_upd_by
												, loosm_lst_upd_dt
												, loosm_deleted_ind  
												)
												SELECT loosm_id
												, loosm_series_type
												, loosm_entm_id
												, loosm_dpm_id
												, loosm_dpam_sba_no
												, loosm_slip_book_no
												, loosm_slip_no_from
												, loosm_slip_no_to
												, loosm_created_by
												, loosm_created_dt
												, loosm_lst_upd_by
												, loosm_lst_upd_dt

												, 1
												FROM  loosm_mak
												WHERE loosm_id          = convert(numeric,@currstring)
												AND   loosm_deleted_ind = 0
										
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
														UPDATE loosm_mak 
														SET    loosm_deleted_ind = 1
																			, loosm_lst_upd_by  = @pa_login_name
																			, loosm_lst_upd_dt  = getdate()
														WHERE  loosm_id          = convert(numeric,@currstring)
														AND    loosm_deleted_ind = 0
		
		
														COMMIT TRANSACTION
												--
												END
								  --
										END		
						  --
						  END
						  ELSE 
						  BEGIN
						  --
         

						    UPDATE loose_slip_mstr 
										SET    loosm_deleted_ind = 0
															, loosm_lst_upd_by  = @pa_login_name
															, loosm_lst_upd_dt  = getdate()
										WHERE  loosm_id          = convert(numeric,@currstring)
										AND    loosm_deleted_ind = 1
										
										UPDATE loosm_mak
										SET    loosm_deleted_ind = 5
															, loosm_lst_upd_by  = @pa_login_name
															, loosm_lst_upd_dt  = getdate()
										WHERE  loosm_id          = convert(numeric,@currstring)
										AND    loosm_deleted_ind = 4
										
										COMMIT TRANSACTION
						  --
						  END
						--
						END
						IF @pa_action = 'REJ'
						BEGIN
						--
        BEGIN TRANSACTION
						  
						  UPDATE loosm_mak 
								SET    loosm_deleted_ind = 3
													, loosm_lst_upd_by  = @pa_login_name
													, loosm_lst_upd_dt  = getdate()
								WHERE  loosm_id          = convert(numeric,@currstring)
								AND    loosm_deleted_ind IN (0,4,6)
						  
						  
						  
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
