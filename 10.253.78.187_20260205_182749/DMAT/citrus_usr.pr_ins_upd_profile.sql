-- Object: PROCEDURE citrus_usr.pr_ins_upd_profile
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

/*
PROC_ID
PROC_PROFILE_ID
PROC_SLAB_NO
PROC_CREATED_BY
PROC_CREATED_DT
PROC_LST_UPD_BY
PROC_LST_UPD_DT
PROC_DELETED_IND 
REMARKS 
*/

CREATE PROCEDURE [citrus_usr].[pr_ins_upd_profile](@pa_id              VARCHAR(8000)  
												,@pa_action          VARCHAR(20)  
												,@pa_login_name      VARCHAR(20)  
												,@pa_excsm_cd        VARCHAR(50)
												,@pa_profile_name    VARCHAR(150)
												,@pa_slab_no         VARCHAR(8000)
												,@pa_rmks        				VARCHAR(250)
												,@pa_chk_yn          INT  
												,@rowdelimiter       CHAR(4)       = '*|~*'  
												,@coldelimiter       CHAR(4)       = '|*~|'  
												,@pa_errmsg          VARCHAR(8000) output 
                                )
AS
/*
*********************************************************************************
 SYSTEM         : dp
 MODULE NAME    : pr_ins_upd_cham
 DESCRIPTION    : this procedure will contain the maker checker facility for charge_mstr
 COPYRIGHT(C)   : marketplace technologies 
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  --------------------------------------------------
 1.0    TUSHAR            09-JAN-2008   VERSION.
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
      , @delimeter_value varchar(10)
						, @delimeterlength_value varchar(10)
						, @remainingstring_value varchar(8000)
		 			, @currstring_value varchar(8000)
		 			, @l_action varchar(20)
		 			
		 			, @l_proc_id numeric(10,0)
		 			, @l_excsm_id numeric(10,0)
		 			, @l_count    numeric(10,0)
		 			, @l_id    varchar(25)
		 			, @l_brom_id numeric
		 			, @l_dtls_id  numeric(10,0)
		 			, @l_dtlsm_id numeric(10,0)
		 			, @l_procm_id numeric(10,0)
		 			, @l_slab_no  varchar(20)
		 			, @l_bromm_id numeric(10,0)
		 			, @l_excpm_id numeric
		 			
		 			SELECT @l_excpm_id = excpm_id FROM EXCSM_PROD_MSTR epm, EXCH_SEG_MSTR esm WHERE excsm_exch_cd = @pa_excsm_cd AND excpm_Excsm_id = excsm_id AND excpm_prom_id = 1
		 			
		 			
		 			
if @PA_ACTION <> 'app'  AND @PA_ACTION <> 'rej'       
begin
--
		create table #proc_mak
		(proc_id numeric(10,0)
		,proc_profile_id numeric(10,0)
		,proc_slab_no varchar(20)
		,remarks  varchar(250)
		,proc_created_by varchar(25)
		,proc_created_dt datetime
		,proc_lst_upd_by varchar(25)
		,proc_lst_upd_dt datetime 
		,proc_deleted_ind smallint 
		)
		insert into #proc_mak
		(proc_id
		,proc_profile_id
		,proc_slab_no
		,remarks 
		,proc_created_by
		,proc_created_dt
		,proc_lst_upd_by
		,proc_lst_upd_dt
		,proc_deleted_ind 
		)
		select proc_id
		,proc_profile_id
		,proc_slab_no
		,remarks 
		,proc_created_by
		,proc_created_dt
		,proc_lst_upd_by
		,proc_lst_upd_dt
		,proc_deleted_ind 
		FROM proc_mak
		WHERE proc_id  = @pa_id
--
END


IF @pa_chk_yn = 0 
BEGIN
--
  SELECT @l_dtls_id   = ISNULL(MAX(proc_id),0) + 1 FROM profile_charges
--
END
ELSE
BEGIN
--

  SELECT @l_dtls_id   = ISNULL(MAX(proc_id),0) + 1 FROM profile_charges
																
		SELECT @l_dtlsm_id   = ISNULL(MAX(proc_id),0) + 1 FROM proc_mak
		
		IF @l_dtlsm_id  > @l_dtls_id   
		BEGIN
		--
		  set @l_dtls_id = @l_dtlsm_id   
		--
		END 
		
  
--
END

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
				    
				    SELECT @l_brom_id   = brom_id FROM brokerage_mstr where brom_desc = @pa_profile_name AND BROM_EXCPM_ID = @l_excpm_id AND brom_deleted_ind = 1
				    IF isnull(@l_brom_id,0) = 0
				    BEGIN
				    --
				      SELECT @l_brom_id   = ISNULL(MAX(convert(numeric,brom_id)),0) + 1 FROM brokerage_mstr
				    --
				    END
				  --
				  END
				  ELSE
				  BEGIN
				  --
				    SELECT @l_brom_id   = brom_id FROM brokerage_mstr where brom_desc = @pa_profile_name AND BROM_EXCPM_ID = @l_excpm_id AND brom_deleted_ind = 1
				    
				    IF isnull(@l_brom_id,0) = 0
				    BEGIN
				    --
				      SELECT @l_brom_id      = ISNULL(MAX(convert(numeric,brom_id)),0) + 1 FROM brokerage_mstr  
								  																										
								  SELECT @l_bromm_id      = ISNULL(MAX(convert(numeric,brom_id)),0) + 1  FROM brom_mak
  
								  IF @l_bromm_id   > @l_brom_id   
								  BEGIN
								  --
								  		SET @l_brom_id = @l_bromm_id   
								  --
								  END
								--
								END
				  --
				  END
						select @l_count = citrus_usr.ufn_countstring(@pa_slab_no,'|*~|')
						set @l_id = 1

						WHILE  @l_count  >= @l_id
						BEGIN
						--
        set @l_slab_no = citrus_usr.fn_splitval(@pa_slab_no,@l_id) 
        
        IF @pa_chk_yn = 0 
								BEGIN
								--
								  IF @PA_ACTION = 'INS' OR @l_action = 'A'
								  BEGIN
								  --
								    BEGIN TRANSACTION
								
								    SELECT @l_proc_id   = ISNULL(MAX(proc_dtls_id),0) + 1 FROM profile_charges
								    
								
								
												SELECT top 1 @l_excsm_id = excsm_id from exch_seg_mstr  where excsm_exch_cd = @pa_excsm_cd order by 1 
            
            
            
												INSERT INTO profile_charges
												(proc_id
												,proc_dtls_id
												,proc_profile_id
												,proc_slab_no
												,remarks 
												,proc_created_by
												,proc_created_dt
												,proc_lst_upd_by
												,proc_lst_upd_dt
												,proc_deleted_ind 
												)VALUES 
												(@l_dtls_id
												,@l_proc_id
												,@l_brom_id
												,@l_slab_no
												,@pa_rmks
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
												  IF NOT EXISTS(select brom_id from brokerage_mstr where brom_desc = @pa_profile_name and brom_deleted_ind =1 AND BROM_EXCPM_ID = @l_excpm_id  )
												  BEGIN
												  --
																insert into brokerage_mstr 
																(brom_id
																,brom_desc
																,brom_excpm_id
																,brom_created_by
																,brom_created_dt
																,brom_lst_upd_by
																,brom_lst_upd_dt
																,brom_deleted_ind )
																	select @l_brom_id
																						, @pa_profile_name
																						, excpm_id 
																						, @pa_login_name
																						, getdate()
																						, @pa_login_name
																						, getdate()
																						, 1
																FROM   exch_seg_mstr 
																					, excsm_prod_mstr 
																WHERE  excsm_exch_cd =  @pa_excsm_cd
																AND    excsm_id      =  excpm_excsm_id 
																AND    excsm_deleted_ind = 1
																AND    excpm_deleted_ind = 1
														--
														END
												  
												  
												  COMMIT TRANSACTION
										  --
										  END
								
								--
								END
								--
        END
        IF @pa_chk_yn = 1 
								BEGIN
								--
										IF @PA_ACTION = 'INS' OR @l_action = 'A'
										BEGIN
										--
												BEGIN TRANSACTION

												SELECT @l_proc_id      = ISNULL(MAX(proc_dtls_id),0) + 1 FROM profile_charges  
																										
												SELECT @l_procm_id      = ISNULL(MAX(proc_dtls_id),0) + 1 FROM proc_mak

												IF @l_procm_id   > @l_proc_id   
												BEGIN
												--
														SET @l_proc_id = @l_procm_id   
												--
												END
												
												
            

												SELECT top 1 @l_excsm_id = excsm_id from exch_seg_mstr  where excsm_exch_cd = @pa_excsm_cd order by 1 

												INSERT INTO proc_mak
												(proc_id
												,proc_dtls_id
												,proc_profile_id
												,proc_slab_no
												,remarks 
												,proc_created_by
												,proc_created_dt
												,proc_lst_upd_by
												,proc_lst_upd_dt
												,proc_deleted_ind 
												)VALUES 
												(@l_dtls_id
												,@l_proc_id 
												,@l_brom_id
												,@l_slab_no
												,@pa_rmks
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
												  IF NOT EXISTS(select brom_id from brom_mak where brom_desc = @pa_profile_name and brom_deleted_ind =0)
														BEGIN
												  --
												  
																insert into brom_mak
																(brom_id
															,brom_desc
															,brom_excpm_id
															,brom_created_by
															,brom_created_dt
															,brom_lst_upd_by
															,brom_lst_upd_dt
															,brom_deleted_ind )
																select @l_brom_id
																					, @pa_profile_name
																					, excpm_id 
																					, @pa_login_name
																					, getdate()
																					, @pa_login_name
																					, getdate()
																					, 0
																FROM   exch_seg_mstr 
																					, excsm_prod_mstr 
																WHERE  excsm_exch_cd =  @pa_excsm_cd
																AND    excsm_id      =  excpm_excsm_id 
																AND    excsm_deleted_ind = 1
																AND    excpm_deleted_ind = 1
														--
														end


														COMMIT TRANSACTION
												--
												END

								--
								END
								--
        END
        
        set @l_id = @l_id + 1 
      --
      END
      IF @pa_action= 'APP'
      BEGIN
      --
        IF EXISTS(select proc_deleted_ind  from proc_mak where proc_deleted_ind = 0 and proc_dtls_id = convert(INT,@currstring))
								BEGIN
								--
								  BEGIN TRANSACTION
								  
								  INSERT INTO profile_charges
								  (proc_id
										,proc_dtls_id
										,proc_profile_id
										,proc_slab_no
										,remarks 
										,proc_created_by
										,proc_created_dt
										,proc_lst_upd_by
										,proc_lst_upd_dt
										,proc_deleted_ind 
								  )
								  select proc_id
																,proc_dtls_id
																,proc_profile_id
																,proc_slab_no
																,remarks 
																,proc_created_by
																,proc_created_dt
																,proc_lst_upd_by
																,proc_lst_upd_dt
																,1
          FROM   proc_mak 
          WHERE  proc_deleted_ind = 0 
										AND    proc_id     = convert(INT,@currstring)
										
										
										update proc_mak 
										set    proc_lst_upd_dt = getdate()
										     , proc_lst_upd_by = @pa_login_name
										     , proc_deleted_ind = 1 
										WHERE   proc_id     = convert(INT,@currstring)   
								  
								  
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
													insert into brokerage_mstr
													(brom_id
													,brom_desc
													,brom_excpm_id
													,brom_created_by
													,brom_created_dt
													,brom_lst_upd_by
													,brom_lst_upd_dt
													,brom_deleted_ind
             )
													SELECT brom_id
																			,brom_desc
																			,brom_excpm_id
																			,brom_created_by
																			,brom_created_dt
																			,brom_lst_upd_by
																			,brom_lst_upd_dt
																			,1
													FROM   brom_mak 
													,      profile_charges
													WHERE  brom_id          = proc_profile_id
													AND    proc_id     = convert(INT,@currstring) 
													AND    brom_deleted_ind = 0
													
													
													
          update brom_mak
          set    brom_lst_upd_dt = getdate()
										     , brom_lst_upd_by = @pa_login_name
										     , brom_deleted_ind = 1 
										FROM   brom_mak 
													,   profile_charges     
										WHERE  proc_id     = convert(INT,@currstring)  
										AND    brom_id          = proc_profile_id
										AND    brom_deleted_ind = 0
            

												COMMIT TRANSACTION
										--
										END
								--
								END
      --
      END
      IF @pa_action= 'REJ'
						BEGIN
						--
						
						    update brom_mak
										set    brom_lst_upd_dt = getdate()
															, brom_lst_upd_by = @pa_login_name
															, brom_deleted_ind = 3 
										FROM   brom_mak 
													,   proc_mak    
										WHERE  proc_id     = convert(INT,@currstring)  
										AND    brom_id          = proc_profile_id
										AND    brom_deleted_ind = 0
										
										
									update proc_mak 
									set    proc_lst_upd_dt = getdate()
														, proc_lst_upd_by = @pa_login_name
														, proc_deleted_ind = 3 
									WHERE  proc_id     = convert(INT,@currstring)   
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
