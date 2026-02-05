-- Object: PROCEDURE citrus_usr.pr_mak_slibm
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

/*
SLIBM_ID
SLIBM_TRATM_ID
SLIBM_DPM_ID
SLIBM_SERIES_TYPE
SLIBM_FROM_NO
SLIBM_TO_NO
SLIBM_NO_OF_SLIPS
SLIBM_REORDER_NO
SLIBM_REORDER_DT
SLIBM_RMKS
SLIBM_CREATED_BY
SLIBM_CREATED_DT
SLIBM_LST_UPD_BY
SLIBM_LST_UPD_DT
SLIBM_DELETED_IND

*/

--alter table slibm_book_type add slibm_book_type char(1)
--alter table slibm_mak add slibm_book_type char(1)
	---0	INS	HO	454	12345678	290 	BULK 		820	2	821	0				Mar 30 2009		*|~*	|*~|	
	---0	INS	HO	454	12345678	290 	BULK 		820	2	821	0				Mar 30 2009		*|~*	|*~|	
--pr_mak_slibm '0','INS','HO',	454,	'12345678',	'290',	'BULK','',	820,	821,	2,	0,	'','','','Mar 30 2009',	0,	'*|~*',	'|*~|',''	
CREATE PROCEDURE [citrus_usr].[pr_mak_slibm](@pa_id             VARCHAR(8000)  
										, @pa_action         VARCHAR(20)  
										, @pa_login_name     VARCHAR(20)  
										, @pa_slibm_tratm_id NUMERIC
										, @pa_dpm_dpid       VARCHAR(50)
										, @pa_slip_book_name varchar(50) 
										, @pa_book_type      char(1)
										, @pa_series_type    VARCHAR(50)
										, @pa_series_from    BIGINT
										, @pa_series_to      BIGINT
										, @pa_no_of_slips    BIGINT
										, @pa_reorder_no     VARCHAR(50)
										, @pa_reorder_dt     VARCHAR(11)
										, @pa_rmks           VARCHAR(11)
                                       	, @pa_values         VARCHAR(8000)
                                        , @pa_dt             datetime
										, @pa_chk_yn         INT  
										, @rowdelimiter      CHAR(4)       = '*|~*'  
										, @coldelimiter      CHAR(4)       = '|*~|'  
										, @pa_errmsg         VARCHAR(8000) output  
)  
AS
/*
*********************************************************************************
 SYSTEM         : dp
 MODULE NAME    : pr_mak_slibm
 DESCRIPTION    : this procedure will contain the maker checker facility for slip_book_mstr
 COPYRIGHT(C)   : marketplace technologies 
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  --------------------------------------------------
 1.0    TUSHAR            29-NOV-2007   VERSION.
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
      , @l_slibm_id      NUMERIC
      , @l_slibmm_id     NUMERIC
      , @delimeter_value varchar(10)
      , @delimeterlength_value varchar(10)
      , @remainingstring_value varchar(8000)
      , @currstring_value varchar(8000)
      , @l_access1      int
      , @l_access       int
      , @l_excm_id      numeric
      , @l_excm_cd      VARCHAR(500)
      , @l_dpm_id       NUMERIC
      , @l_deleted_ind  int 


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
										
				  IF @pa_chk_yn = 0
				  BEGIN
				  --
							if @pa_dpm_dpid='999'
							begin 
							SELECT @l_dpm_id  = '999'
							end 
							else 
							begin
				  			SELECT @l_dpm_id     = dpm_id FROM dp_mstr WHERE dpm_deleted_ind = 1   and dpm_dpid = @pa_dpm_dpid
                            end
				  			
				    IF @PA_ACTION = 'INS'
				    BEGIN
				    --
										
										
										IF EXISTS(SELECT slibm_id FROM slip_book_mstr where slibm_deleted_ind = 1 and slibm_tratm_id = @pa_slibm_tratm_id  and slibm_series_type = @pa_series_type and ((@pa_series_from between slibm_from_no and slibm_to_no ) or (@pa_series_to between slibm_from_no and  slibm_to_no)) )
										BEGIN
										--
												SET @pa_errmsg = 'ERROR:' +  'Slip no already assigned to another entity'

												return 
										--
										END
										
										BEGIN TRANSACTION
										
				      SELECT @l_slibm_id   = isnull(MAX(slibm_id),0) + 1 FROM slip_book_mstr 
				      
				      
				      INSERT INTO slip_book_mstr 
				      (slibm_id
										,slibm_tratm_id
										,slibm_dpm_id
										,slibm_book_name
										,slibm_book_type
										,slibm_series_type
										,slibm_from_no
										,slibm_to_no
										,slibm_no_of_slips
										,slibm_reorder_no
										,slibm_reorder_dt
										,slibm_rmks
										,slibm_created_by
										,slibm_created_dt
										,slibm_lst_upd_by
										,slibm_lst_upd_dt
										,slibm_deleted_ind, slibm_dt 
				      )VALUES
				      (@l_slibm_id   
				      ,@pa_slibm_tratm_id
										,@l_dpm_id
										,@pa_slip_book_name
										,@pa_book_type
										,@pa_series_type    
										,@pa_series_from   
										,@pa_series_to      
										,@pa_no_of_slips
										,@pa_reorder_no     
										,convert(datetime,@pa_reorder_dt,103)     
										,@pa_rmks           
										,@pa_login_name
										,getdate()
										,@pa_login_name
										,getdate()
										,1,@pa_dt
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
												
												RETURN
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
				    ELSE IF @PA_ACTION = 'EDT'
				    BEGIN
				    --
				      BEGIN TRANSACTION
				    
				      UPDATE slip_book_mstr
				      SET    slibm_tratm_id      = @pa_slibm_tratm_id
															, slibm_dpm_id        = @l_dpm_id 
															, slibm_book_name     = @pa_slip_book_name
															, slibm_book_type     = @pa_book_type
															, slibm_series_type   = @pa_series_type    
															, slibm_from_no       = @pa_series_from   
															, slibm_to_no         = @pa_series_to      
															, slibm_no_of_slips   = @pa_no_of_slips
															, slibm_reorder_no    = @pa_reorder_no     
															, slibm_reorder_dt    = convert(datetime,@pa_reorder_dt,103)     
															, slibm_rmks          = @pa_rmks        
															, slibm_lst_upd_dt    = getdate(), slibm_dt = @pa_dt
										     , slibm_lst_upd_by    = @pa_login_name 
										WHERE  slibm_id            = CONVERT(BIGINT,@currstring)					
										AND    slibm_deleted_ind   = 1
										
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

												RETURN
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
				    ELSE IF @PA_ACTION = 'DEL'
								BEGIN
								--
								  BEGIN TRANSACTION
								
								  
								  IF NOT EXISTS(select sliim_id from slip_issue_mstr 
                                                where sliIm_tratm_id = @pa_slibm_tratm_id  
                                                and sliim_deleted_ind = 1 
                                                and sliim_series_type in (select slibm_series_type from slip_book_mstr where slibm_deleted_ind = 1 and slibm_id = CONVERT(BIGINT,@currstring))
                                                and (SLIIM_SLIP_NO_FR between @pa_series_from and @pa_series_to or SLIIM_SLIP_NO_to  between @pa_series_from and @pa_series_to ))
                                              
								  BEGIN
								  --
								      UPDATE slip_book_mstr
									  SET    slibm_deleted_ind   = 0
									        ,slibm_lst_upd_dt    = getdate()
									        ,slibm_lst_upd_by    = @pa_login_name 
									  WHERE  slibm_id            = CONVERT(BIGINT,@currstring)					
									  AND    slibm_deleted_ind   = 1
									 --	   
									 END
									 ELSE
									 BEGIN
									 --
									   SELECT @t_errorstr = 'ERROR '+': Can not Delete, This Slip Already Assigned!'
									 --
									 END
										
										
										
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

												RETURN
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
				  IF @pa_chk_yn = 1
						BEGIN
				  --
				   	SELECT @l_dpm_id     = dpm_id FROM dp_mstr WHERE dpm_deleted_ind = 1   and dpm_dpid = @pa_dpm_dpid
				   	
				    IF @PA_ACTION = 'INS'
								BEGIN
								--
								  BEGIN TRANSACTIOn
								  
								  SELECT @l_slibm_id = ISNULL(MAX(slibm_id),0)+1
										FROM slibm_mak WITH (NOLOCK)
								  --
  								SELECT @L_slibmm_id = ISNULL(MAX(slibm_id),0)+1
  								FROM slip_book_mstr WITH (NOLOCK)
  						
  						
  						 
  						  
								  IF @l_slibmm_id > @l_slibm_id
								  BEGIN
								  --
								  		SET  @l_slibm_id = @l_slibmm_id
								  --
          END
          
          
					INSERT INTO slibm_mak
					(slibm_id
					,slibm_tratm_id
					,slibm_dpm_id
					,slibm_book_name
					,slibm_book_type
					,slibm_series_type
					,slibm_from_no
					,slibm_to_no
					,slibm_no_of_slips
					,slibm_reorder_no
					,slibm_reorder_dt
					,slibm_rmks
					,slibm_created_by
					,slibm_created_dt
					,slibm_lst_upd_by
					,slibm_lst_upd_dt
					,slibm_deleted_ind, slibm_dt 
				      )VALUES
				      (@l_slibm_id   
				      ,@pa_slibm_tratm_id
					,@l_dpm_id
					,@pa_slip_book_name
					,@pa_book_type
					,@pa_series_type    
					,@pa_series_from   
					,@pa_series_to      
					,@pa_no_of_slips
					,@pa_reorder_no     
					,convert(datetime,@pa_reorder_dt,103)     
					,@pa_rmks           
					,@pa_login_name
					,getdate()
					,@pa_login_name
					,getdate()
					,0, @pa_dt
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

												RETURN
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
								ELSE IF @PA_ACTION = 'EDT'
								BEGIN
								--
								  BEGIN TRANSACTION 
								  
										UPDATE slibm_mak
										SET    slibm_deleted_ind  = 2
										, slibm_lst_upd_dt   = getdate()
										, slibm_lst_upd_by   = @pa_login_name
										WHERE  slibm_id           = convert(numeric,@currstring)
										AND    slibm_deleted_ind  = 0
										
										
										IF EXISTS(select slibm_id from slip_book_mstr where slibm_id = CONVERT(BIGINT,@currstring) and slibm_deleted_ind = 1)
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
								
								  INSERT INTO slibm_mak
										(slibm_id
										,slibm_tratm_id
										,slibm_dpm_id
										,slibm_book_name
										,slibm_book_type
										,slibm_series_type
										,slibm_from_no
										,slibm_to_no
										,slibm_no_of_slips
										,slibm_reorder_no
										,slibm_reorder_dt
										,slibm_rmks
										,slibm_created_by
										,slibm_created_dt
										,slibm_lst_upd_by
										,slibm_lst_upd_dt
										,slibm_deleted_ind, slibm_dt
										)VALUES
										(convert(numeric,@currstring)   
										,@pa_slibm_tratm_id
										,@l_dpm_id
										,@pa_slip_book_name
										,@pa_book_type
										,@pa_series_type    
										,@pa_series_from   
										,@pa_series_to      
										,@pa_no_of_slips
										,@pa_reorder_no     
										,convert(datetime,@pa_reorder_dt,103)     
										,@pa_rmks           
										,@pa_login_name
										,getdate()
										,@pa_login_name
										,getdate()
										,@l_deleted_ind,@pa_dt
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

												RETURN
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
								ELSE IF @PA_ACTION = 'DEL'
								BEGIN
								--
								  IF exists(SELECT slibm_id FROM slibm_mak WHERE slibm_id = convert(numeric,@currstring) and slibm_deleted_ind = 0)
										BEGIN
										--
												DELETE FROM slibm_mak
												WHERE slibm_id = convert(numeric,@currstring)
												AND   slibm_deleted_ind = 0
										--
										END
										ELSE
										BEGIN
  								--
  								  INSERT INTO slibm_mak
  								  (slibm_id
												,slibm_tratm_id
												,slibm_dpm_id
												,slibm_book_name
												,slibm_book_type
												,slibm_series_type
												,slibm_from_no
												,slibm_to_no
												,slibm_no_of_slips
												,slibm_reorder_no
												,slibm_reorder_dt
												,slibm_rmks
												,slibm_created_by
												,slibm_created_dt
												,slibm_lst_upd_by
												,slibm_lst_upd_dt
												,slibm_deleted_ind,slibm_dt
  										)
  											SELECT slibm_id
												,slibm_tratm_id
												,slibm_dpm_id
												,slibm_book_name
												,slibm_book_type
												,slibm_series_type
												,slibm_from_no
												,slibm_to_no
												,slibm_no_of_slips
												,slibm_reorder_no
												,slibm_reorder_dt
												,slibm_rmks
												,slibm_created_by
												,slibm_created_dt
												,@pa_login_name
												,getdate()
												,4,@pa_dt
												FROM  slip_book_mstr
												WHERE slibm_id          = convert(numeric,@currstring)
 											AND   slibm_deleted_ind = 1
  								--
  								END
								--
								END
								ELSE IF @PA_ACTION = 'APP'
								BEGIN
								--
								  IF EXISTS(SELECT * FROM slip_book_mstr slibm , slibm_mak slibmm where slibmm.slibm_series_type = slibm.slibm_series_type and ((slibmm.slibm_from_no  between slibm.slibm_from_no and slibm.slibm_to_no ) or ( slibmm.slibm_to_no between slibm.slibm_from_no and  slibm.slibm_to_no)) and  slibmm.slibm_id = convert(numeric,@currstring) and slibm.slibm_deleted_ind = 1)
										BEGIN
										--
												SET @pa_errmsg = 'ERROR:' +  'Slip no already assigned to another entity'

												return 
										--
										END
								
								
								
								  BEGIN TRANSACTION 
								  
								  IF EXISTS(select slibm_id from slibm_mak where slibm_id = convert(numeric,@currstring) and slibm_deleted_ind = 6)
										BEGIN
										--
												UPDATE slip_book_mstr 
												SET    slibm_tratm_id      = slibmm.slibm_tratm_id       
																	, slibm_dpm_id        = slibmm.slibm_dpm_id   
																	, slibm_book_name     = slibmm.slibm_book_name
																	, slibm_book_type     = slibmm.slibm_book_type
																	, slibm_series_type   = slibmm.slibm_series_type
																	, slibm_from_no       = slibmm.slibm_from_no
																	, slibm_to_no         = slibmm.slibm_to_no
																	, slibm_no_of_slips   = slibmm.slibm_no_of_slips
																	, slibm_reorder_no    = slibmm.slibm_reorder_no
																	, slibm_reorder_dt    = slibmm.slibm_reorder_dt
																	, slibm_rmks          = slibmm.slibm_rmks
																	, slibm_lst_upd_dt    = getdate()
																	, slibm_lst_upd_by    = @pa_login_name , slibm_dt = slibmm.slibm_dt
												FROM   slibm_mak             slibmm
												WHERE  slibmm.slibm_id          =  convert(numeric,@currstring)
												AND    slibmm.slibm_deleted_ind =  6 

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
														UPDATE slibm_mak
														SET    slibm_deleted_ind = 7
																			, slibm_lst_upd_by  = @pa_login_name
																			, slibm_lst_upd_dt  = getdate()
														WHERE  slibm_id          = convert(numeric,@currstring)
														AND    slibm_deleted_ind = 6

														COMMIT TRANSACTION
												--
												END
										--
						    END
						    ELSE IF exists(select slibm_id from slibm_mak where slibm_id = convert(numeric,@currstring) and slibm_deleted_ind = 0)
										BEGIN
										--
										  INSERT INTO slip_book_mstr
												(slibm_id
												,slibm_tratm_id
												,slibm_dpm_id
												,slibm_book_name
												,slibm_book_type
												,slibm_series_type
												,slibm_from_no
												,slibm_to_no
												,slibm_no_of_slips
												,slibm_reorder_no
												,slibm_reorder_dt
												,slibm_rmks
												,slibm_created_by
												,slibm_created_dt
												,slibm_lst_upd_by
												,slibm_lst_upd_dt
												,slibm_deleted_ind, slibm_dt
												)
												SELECT slibm_id
																		,slibm_tratm_id
																		,slibm_dpm_id
																		,slibm_book_name
																		,slibm_book_type
																		,slibm_series_type
																		,slibm_from_no
																		,slibm_to_no
																		,slibm_no_of_slips
																		,slibm_reorder_no
																		,slibm_reorder_dt
																		,slibm_rmks
																		,slibm_created_by
																		,slibm_created_dt
																		,@pa_login_name
																		,getdate()
																		,1, slibm_dt
												FROM  slibm_mak
												WHERE slibm_id          = convert(numeric,@currstring)
 											AND   slibm_deleted_ind = 0

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
														UPDATE slibm_mak
														SET    slibm_deleted_ind = 1
																			, slibm_lst_upd_by  = @pa_login_name
																			, slibm_lst_upd_dt  = getdate()
														WHERE  slibm_id          = convert(numeric,@currstring)
														AND    slibm_deleted_ind = 0


														COMMIT TRANSACTION
												--
												END
										--
						    END
						    ELSE 
										BEGIN
										--
												IF NOT EXISTS(select sliim_id from slip_issue_mstr where sliim_series_type in (select slibm_series_type from slip_book_mstr where slibm_deleted_ind = 1 and slibm_id          = convert(numeric,@currstring)))
												BEGIN
												--
														UPDATE slip_book_mstr
														SET    slibm_deleted_ind = 0
																			, slibm_lst_upd_by  = @pa_login_name
																			, slibm_lst_upd_dt  = getdate()
														WHERE  slibm_id          = convert(numeric,@currstring)
														AND    slibm_deleted_ind = 1
												--	   
												END
												ELSE
												BEGIN
												--
														SELECT @t_errorstr = 'ERROR '+': Can not Delete, This Slip Already Assigned!'
												--
												END

												UPDATE slibm_mak
												SET    slibm_deleted_ind = 5
																	, slibm_lst_upd_by  = @pa_login_name
																	, slibm_lst_upd_dt  = getdate()
												WHERE  slibm_id          = convert(numeric,@currstring)
												AND    slibm_deleted_ind = 4

												COMMIT TRANSACTION
										--
  						  END
								--
								END
								ELSE IF @PA_ACTION = 'REJ'
								BEGIN
								--
								  BEGIN TRANSACTION
																  
										UPDATE slibm_mak
										SET    slibm_deleted_ind = 3
															, slibm_lst_upd_by  = @pa_login_name
															, slibm_lst_upd_dt  = getdate()
										WHERE  slibm_id          = convert(numeric,@currstring)
										AND    slibm_deleted_ind in (0,4,6)




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
