-- Object: PROCEDURE citrus_usr.pr_mak_isin
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_mak_isin](@pa_id           VARCHAR(8000)  
                           , @pa_action       VARCHAR(20)  
                           , @pa_login_name   VARCHAR(20)  
                           , @pa_isin_cd      VARCHAr(25)
                           , @pa_isin_name    VARCHAR(20)     
                           , @pa_isin_reg_cd  VARCHAR(20)  
                           , @pa_isin_conv_dt DATETIME
                           , @pa_isin_status  VARCHAR(25)
                           , @pa_isin_bit     NUMERIC
                           , @pa_chk_yn       INT  
                           , @rowdelimiter    CHAR(4)       = '*|~*'  
                           , @coldelimiter    CHAR(4)       = '|*~|'  
                           , @pa_errmsg       VARCHAR(8000) output  
)  
AS
/*
*********************************************************************************
 SYSTEM         : dp
 MODULE NAME    : pr_mak_holm
 DESCRIPTION    : this procedure will contain the maker checker facility for holiday_mstr
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
      , @l_isin_id       NUMERIC 
      , @l_isin_cd       VARCHAR(25)
      , @l_isin_name     VARCHAR(50)
      
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
    IF @pa_chk_yn = 0
    BEGIN
    --
						IF @pa_action = 'INS'
						BEGIN
						--
						  BEGIN TRANSACTION
						  
						  INSERT INTO isin_mstr
								( isin_cd
								, isin_name
								, isin_reg_cd
								, isin_conv_dt
								, isin_status
								, isin_bit
								, isin_created_by
								, isin_created_dt
								, isin_lst_upd_by
								, isin_lst_upd_dt
								, isin_deleted_ind
								)
								VALUES
								( @pa_isin_cd
								, @pa_isin_name
								, @pa_isin_reg_cd
								, @pa_isin_conv_dt
							 , @pa_isin_status
							 , @pa_isin_bit
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
        
						  UPDATE isin_mstr
								SET    isin_name        = @pa_isin_name   
								     , isin_reg_cd      = @pa_isin_reg_cd
								     , isin_conv_dt     = @pa_isin_conv_dt
								     , isin_status      = @pa_isin_status
								     , isin_bit         = @pa_isin_bit
								     , isin_lst_upd_by  = @pa_login_name
								     , isin_lst_upd_dt  = getdate()
								WHERE  isin_cd          = @pa_isin_cd
								AND    isin_deleted_ind = 1
								
								
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
						ELSE IF @pa_action = 'DEL'
						BEGIN
						--
        BEGIN TRANSACTION
								
								UPDATE isin_mstr
								SET    isin_lst_upd_dt  = getdate()
								      ,isin_lst_upd_by  = @pa_login_name
														,isin_deleted_ind = 0
								WHERE  isin_cd          = @pa_isin_cd
								AND    isin_deleted_ind = 1
								
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
				ELSE IF @pa_chk_yn = 1
				BEGIN
				--
				  IF @pa_action = 'INS'
						BEGIN
						--
        BEGIN TRANSACTION
        
        SELECT @l_isin_id = ISNULL(MAX(isin_id),0)+ 1 FROM  isin_mstr_mak WITH (NOLOCK)
        
								INSERT INTO isin_mstr_mak
								( isin_id 
								, isin_cd
								, isin_name
								, isin_reg_cd
								, isin_conv_dt
								, isin_status
								, isin_bit
								, isin_created_by
								, isin_created_dt
								, isin_lst_upd_by
								, isin_lst_upd_dt
								, isin_deleted_ind
								)
								VALUES
								( @l_isin_id
								, @pa_isin_cd
								, @pa_isin_name
								, @pa_isin_reg_cd
								, @pa_isin_conv_dt
								, @pa_isin_status
								, @pa_isin_bit
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
								
							 UPDATE isin_mstr_mak
								SET    isin_deleted_ind = 2
								     , isin_lst_upd_dt  = getdate()
								     , isin_lst_upd_by  = @pa_login_name
								WHERE  isin_cd          = @pa_isin_cd
								AND    isin_deleted_ind = 0
								
								
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
								  SELECT @l_isin_id = ISNULL(MAX(isin_id),0)+ 1 FROM  isin_mstr_mak WITH (NOLOCK)
										        
										INSERT INTO isin_mstr_mak
										( isin_id 
										, isin_cd
										, isin_name
										, isin_reg_cd
										, isin_conv_dt
										, isin_status
										, isin_bit
										, isin_created_by
										, isin_created_dt
										, isin_lst_upd_by
										, isin_lst_upd_dt
										, isin_deleted_ind
										)
										VALUES
										( @l_isin_id
										, @pa_isin_cd
										, @pa_isin_name
										, @pa_isin_reg_cd
										, @pa_isin_conv_dt
										, @pa_isin_status
										, @pa_isin_bit
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
						ELSE IF @pa_action = 'APP'
						BEGIN
						--
        BEGIN TRANSACTION
						  
						  SELECT @l_isin_cd  = isin_cd FROM isin_matr_mak where isin_id  = convert(numeric,@currstring)
						  
						  IF EXISTS(select * from isin_mstr where isin_cd  = @l_isin_cd and isin_deleted_ind = 1)
						  BEGIN
						  --
						    UPDATE isin_mstr
										SET    isin_name              = isinm.isin_name         
															, isin_reg_cd            = isinm.isin_reg_cd     
															, isin_conv_dt           = isinm.isin_conv_dt     
															, isin_status            = isinm.isin_status      
															, isin_bit               = isinm.isin_bit         
															, isin_lst_upd_by        = isinm.isin_lst_upd_by  
															, isin_lst_upd_dt        = isinm.isin_lst_upd_dt  
										FROM   isin_mstr_mak            isinm 					
										WHERE  isinm.isin_cd          = @pa_isin_cd
								  AND    isinm.isin_deleted_ind = 0
								  
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
												UPDATE isin_mstr_mak
												SET    isin_deleted_ind = 1
												     , isin_lst_upd_by  = @pa_login_name
                 , isin_lst_upd_dt  = getdate()
												WHERE  isin_id          = convert(numeric,@currstring)
												AND    isin_deleted_ind = 0

												COMMIT TRANSACTION
										--
										END
        --
						  END
						  ELSE
						  BEGIN
						  --
						    INSERT INTO isin_mstr
										( isin_cd
										, isin_name
										, isin_reg_cd
										, isin_conv_dt
										, isin_status
										, isin_bit
										, isin_created_by
										, isin_created_dt
										, isin_lst_upd_by
										, isin_lst_upd_dt
										, isin_deleted_ind
										)
									 SELECT isin_cd
										, isin_name
										, isin_reg_cd
										, isin_conv_dt
										, isin_status
										, isin_bit
										, isin_created_by
										, isin_created_dt
										, isin_lst_upd_by
										, isin_lst_upd_dt
										, 1
										FROM  isin_mstr_mak
										WHERE isin_id          = convert(numeric,@currstring)
										AND   isin_deleted_ind = 0
										
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
												UPDATE isin_mstr_mak
												SET    isin_deleted_ind = 1
																	, isin_lst_upd_by  = @pa_login_name
																	, isin_lst_upd_dt  = getdate()
												WHERE  isin_id          = convert(numeric,@currstring)
												AND    isin_deleted_ind = 0

												COMMIT TRANSACTION
										--
										END
						  --
						  END
						--
						END
						ELSE IF @pa_action = 'REJ'
						BEGIN
						--
        BEGIN TRANSACTION
						  
						  UPDATE isin_mstr_mak
								SET    isin_deleted_ind = 3
													, isin_lst_upd_by  = @pa_login_name
													, isin_lst_upd_dt  = getdate()
								WHERE  isin_id          = convert(numeric,@currstring)
								AND    isin_deleted_ind = 0
						  
						  
						  
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
				
			
  --
  END
 --
 END


--
END

GO
