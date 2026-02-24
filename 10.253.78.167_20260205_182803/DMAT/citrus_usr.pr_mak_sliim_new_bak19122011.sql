-- Object: PROCEDURE citrus_usr.pr_mak_sliim_new_bak19122011
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

/*
SLIIM_ID
SLIIM_TRATM_ID
SLIIM_SERIES_TYPE
SLIIM_ENTM_ID
SLIIM_DPAM_ACCT_NO
SLIIM_SLIP_NO_FR
SLIIM_SLIP_NO_TO
SLIIM_LOOSE_Y_N
SLIIM_NO_USED
SLIIM_ALL_USED
SLIIM_CREATED_BY
SLIIM_CREATED_DT
SLIIM_LST_UPD_BY
SLIIM_LST_UPD_DT
SLIIM_DELETED_IND
SLIIM_DPM_ID
*/
create PROCEDURE [citrus_usr].[pr_mak_sliim_new_bak19122011](
								  @pa_id             VARCHAR(8000)  
								, @pa_action         VARCHAR(20)  
								, @pa_login_name     VARCHAR(20)  
								, @pa_sliim_tratm_id NUMERIC
								, @pa_series_type    VARCHAR(25)
								, @pa_dpm_dpid       VARCHAR(50)
								, @pa_entm_id        varchar(16)
								, @pa_dpam_acct_no   VARCHAR(50)
								, @pa_series_from    NUMERIC
								, @pa_series_to      NUMERIC
								, @pa_loosm_y_n      CHAR(1)
                                , @pa_dt             datetime 
                                , @pa_book_name		 varchar(100)
                                , @pa_rmks			 varchar(1000)
								, @pa_chk_yn         INT  
								, @rowdelimiter      CHAR(4)       = '*|~*'  
								, @coldelimiter      CHAR(4)       = '|*~|'  
																								, @pa_errmsg         VARCHAR(8000) output  
)  
AS
/*
*********************************************************************************
 SYSTEM         : dp
 MODULE NAME    : pr_mak_sliim
 DESCRIPTION    : this procedure will contain the maker checker facility for slip_issue_mstr
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
      , @l_sliim_id      NUMERIC
      , @l_sliimm_id     NUMERIC
      , @delimeter_value varchar(10)
      , @delimeterlength_value varchar(10)
      , @remainingstring_value varchar(8000)
      , @currstring_value varchar(8000)
      , @l_access1      int
      , @l_access       int
      , @l_excm_id      numeric
      , @l_excm_cd      VARCHAR(500)
      , @l_dpm_id       NUMERIC
      , @l_deleted_ind  smallint




select @pa_entm_id = dpam_crn_no from dp_Acct_mstr where dpam_sba_no = @pa_entm_id and dpam_deleted_ind = 1

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
				    IF @pa_action = 'INS' or @pa_action = 'EDT'
				    BEGIN
				    --
				      
										IF NOT EXISTS(SELECT SLIBM_DELETED_IND FROM slip_book_mstr WHERE SLIBM_DELETED_IND = 1 AND SLIBM_TRATM_ID = @pa_sliim_tratm_id AND slibm_series_type = @pa_series_type   and ((@pa_series_from  between slibm_from_no and slibm_to_no) or (@pa_series_to  between slibm_from_no and slibm_to_no)))
										BEGIN
										--
												SET @pa_errmsg = 'ERROR:' + 'The range of slip no not matched with original series type'

												return 
										--
										END
          If @pa_action = 'INS'
          BEGIN
          --
										  IF EXISTS(SELECT SLIIM_DELETED_IND FROM slip_issue_mstr where SLIIM_DELETED_IND = 1 AND SLIIM_TRATM_ID = @pa_sliim_tratm_id AND  sliim_series_type = @pa_series_type and ((@pa_series_from between sliim_slip_no_fr and sliim_slip_no_to ) or (@pa_series_to between sliim_slip_no_to and  sliim_slip_no_fr)) )
										  BEGIN
										  --
										  		SET @pa_errmsg = 'ERROR:' +  'Slip no already assigned to another entity'
  
										  		return 
										  --
										  END
										--
										END
								--
								END
				    
				    
				    SELECT @l_dpm_id     = dpm_id FROM dp_mstr WHERE dpm_deleted_ind = 1   and default_dp = dpm_excsm_id and dpm_dpid = @pa_dpm_dpid
				    
				    IF @PA_ACTION = 'INS'
				    BEGIN
				    --
										BEGIN TRANSACTION
										
										
											
				      SELECT @l_sliim_id   = ISNULL(MAX(sliim_id),0) + 1 FROM slip_issue_mstr
				      
				      
				      INSERT INTO slip_issue_mstr 
				      (sliim_id
										,sliim_tratm_id
										,sliim_dpm_id
										,sliim_series_type
										,sliim_entm_id
										,sliim_dpam_acct_no
										,sliim_slip_no_fr
										,sliim_slip_no_to
										,sliim_loose_y_n
										,sliim_no_used
										,sliim_all_used
										,sliim_created_by
										,sliim_created_dt
										,sliim_lst_upd_by
										,sliim_lst_upd_dt
										,sliim_deleted_ind, sliim_dt,sliim_book_name , sliim_rmks

				      )VALUES
				      (@l_sliim_id   
				      ,@pa_sliim_tratm_id
										,@l_dpm_id
										,@pa_series_type  
										,@pa_entm_id
										,@pa_dpam_acct_no  
										,@pa_series_from   
										,@pa_series_to      
										,@pa_loosm_y_n
										,0
										,0
										,@pa_login_name
										,getdate()
										,@pa_login_name
										,getdate()
										,1,@pa_dt,@pa_book_name, @pa_rmks
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
										--
  								END
				      
				    --
				    END
				    ELSE IF @PA_ACTION = 'EDT'
				    BEGIN
				    --
				      BEGIN TRANSACTION
				    
				    print @l_dpm_id
				    
				      IF not exists(select uses_id from used_slip, slip_issue_mstr where sliim_tratm_id      = @pa_sliim_tratm_id AND uses_dpam_Acct_no = sliim_dpam_acct_no and uses_series_type = sliim_series_type and uses_slip_no between sliim_slip_no_fr and sliim_slip_no_to and uses_deleted_ind = 1 and sliim_id = CONVERT(BIGINT,@currstring)		 )
				      begin
				      --
				        UPDATE slip_issue_mstr
				        SET    sliim_tratm_id      = @pa_sliim_tratm_id
										        ,sliim_dpm_id        = @l_dpm_id
										  						,sliim_series_type   = @pa_series_type  
										   					,sliim_entm_id       = @pa_entm_id
										  						,sliim_dpam_acct_no  = @pa_dpam_acct_no  
										  						,sliim_slip_no_fr    = @pa_series_from     
										  						,sliim_slip_no_to    = @pa_series_to    
										  						,sliim_loose_y_n     = @pa_loosm_y_n
										  					, sliim_lst_upd_dt    = getdate(), sliim_dt = @pa_dt 
										       , sliim_lst_upd_by    = @pa_login_name , sliim_book_name = @pa_book_name, sliim_rmks = @pa_rmks
										  WHERE  sliim_id            = CONVERT(bigINT,@currstring)					
										  AND    sliim_deleted_ind   = 1
										--
										end
										
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
										--
  								END
				    --
				    END
				    ELSE IF @PA_ACTION = 'DEL'
								BEGIN
								--
								  BEGIN TRANSACTION
								  if not exists(select USES_SERIES_TYPE from used_slip where  exists (select sliim_id from slip_issue_mstr where SLIIM_DELETED_IND = 1 AND sliim_tratm_id      = @pa_sliim_tratm_id AND sliim_id = CONVERT(bigINT,@currstring)		and USES_SERIES_TYPE  = sliim_series_type and uses_deleted_ind = 1 and (uses_slip_no between sliim_slip_no_fr and sliim_slip_no_to)))
								  begin
								  --
								    UPDATE slip_issue_mstr
										  SET    sliim_deleted_ind   = 0
										        ,sliim_lst_upd_dt    = getdate()
										        ,sliim_lst_upd_by    = @pa_login_name 
										  WHERE  sliim_id            = CONVERT(bigINT,@currstring)					
										  AND    sliim_deleted_ind   = 1
										--
										end
										else
										begin
										--
										  SELECT @t_errorstr = 'ERROR '+': Can not Delete, Slip No Already Used!'
										--
										end
										
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
										--
  								END
								--
				    END
				  --
				  END
				  ELSE IF @pa_chk_yn = 1
				  BEGIN
				  --
				    SELECT @l_dpm_id     = dpm_id FROM dp_mstr WHERE dpm_deleted_ind = 1   and dpm_dpid = @pa_dpm_dpid 
				    
				    IF @PA_ACTION = 'INS'
								BEGIN
				    --
				      BEGIN TRANSACTIOn
																  
										SELECT @l_sliim_id = ISNULL(MAX(sliim_id),0)+1
										FROM sliim_mak WITH (NOLOCK)
										--
										SELECT @L_sliimm_id = ISNULL(MAX(sliim_id),0)+1
										FROM slip_issue_mstr WITH (NOLOCK)


										

										IF @l_sliimm_id > @l_sliim_id
										BEGIN
										--
												SET  @l_sliim_id = @l_sliimm_id
										--
          END
          
										INSERT INTO sliim_mak 
										(sliim_id
										,sliim_tratm_id
										,sliim_dpm_id
										,sliim_series_type
										,sliim_entm_id
										,sliim_dpam_acct_no
										,sliim_slip_no_fr
										,sliim_slip_no_to
										,sliim_loose_y_n
										,sliim_no_used
										,sliim_all_used
										,sliim_created_by
										,sliim_created_dt
										,sliim_lst_upd_by
										,sliim_lst_upd_dt
										,sliim_deleted_ind, sliim_dt 

										)VALUES
										(@l_sliim_id   
										,@pa_sliim_tratm_id
										,@l_dpm_id
										,@pa_series_type  
										,@pa_entm_id
										,@pa_dpam_acct_no  
										,@pa_series_from   
										,@pa_series_to      
										,@pa_loosm_y_n
										,0
										,0
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
				      
										UPDATE sliim_mak
										SET    sliim_deleted_ind  = 2
															, sliim_lst_upd_dt   = getdate()
															, sliim_lst_upd_by   = @pa_login_name
										WHERE  sliim_id           = convert(numeric,@currstring)
										AND    sliim_deleted_ind  = 0
				    
										IF EXISTS(select sliim_deleted_ind from slip_issue_mstr where sliim_id = CONVERT(bigINT,@currstring) and sliim_deleted_ind = 1)
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
								  
								  INSERT INTO sliim_mak 
										(sliim_id
										,sliim_tratm_id
										,sliim_dpm_id
										,sliim_series_type
										,sliim_entm_id
										,sliim_dpam_acct_no
										,sliim_slip_no_fr
										,sliim_slip_no_to
										,sliim_loose_y_n
										,sliim_no_used
										,sliim_all_used
										,sliim_created_by
										,sliim_created_dt
										,sliim_lst_upd_by
										,sliim_lst_upd_dt
										,sliim_deleted_ind, sliim_dt 

										)VALUES
										(CONVERT(bigINT,@currstring)  
										,@pa_sliim_tratm_id
										,@l_dpm_id
										,@pa_series_type  
										,@pa_entm_id
										,@pa_dpam_acct_no  
										,@pa_series_from   
										,@pa_series_to      
										,@pa_loosm_y_n
										,0
										,0
										,@pa_login_name
										,getdate()
										,@pa_login_name
										,getdate()
										,@l_deleted_ind, @pa_dt 
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
										--
  								END
				    --
				    END
				    ELSE IF @PA_ACTION = 'DEL'
								BEGIN
				    --
				      
				      IF exists(SELECT slibm_deleted_ind FROM slibm_mak WHERE slibm_id = convert(numeric,@currstring) and slibm_deleted_ind in(0,4))
										BEGIN
										--
												DELETE FROM sliim_mak
												WHERE sliim_id = convert(numeric,@currstring)
												AND   sliim_deleted_ind = 0
										--
										END
										ELSE
										BEGIN
										--
												INSERT INTO sliim_mak 
												(sliim_id
												,sliim_tratm_id
												,sliim_dpm_id
												,sliim_series_type
												,sliim_entm_id
												,sliim_dpam_acct_no
												,sliim_slip_no_fr
												,sliim_slip_no_to
												,sliim_loose_y_n
												,sliim_no_used
												,sliim_all_used
												,sliim_created_by
												,sliim_created_dt
												,sliim_lst_upd_by
												,sliim_lst_upd_dt
												,sliim_deleted_ind, sliim_dt 
            )
												SELECT sliim_id
																		,sliim_tratm_id
																		,sliim_dpm_id
																		,sliim_series_type
																		,sliim_entm_id
																		,sliim_dpam_acct_no
																		,sliim_slip_no_fr
																		,sliim_slip_no_to
																		,sliim_loose_y_n
																		,sliim_no_used
																		,sliim_all_used
																		,sliim_created_by
																		,sliim_created_dt
																		,@pa_login_name
																		,getdate()
																		,4, sliim_dt 
												FROM  slip_issue_mstr
												WHERE sliim_id          = convert(numeric,@currstring)
												AND   sliim_deleted_ind = 1
										--
  								END
				    --
				    END
				    ELSE IF @PA_ACTION = 'APP'
								BEGIN
				    --
				      
				      
				      IF EXISTS(select sliim_deleted_ind from sliim_mak where sliim_id = convert(numeric,@currstring) and sliim_deleted_ind in(6))
										BEGIN
										--
										  IF NOT EXISTS(SELECT slibm.slibm_deleted_ind FROM slip_book_mstr slibm,sliim_mak sliimm  WHERE slibm.slibm_deleted_ind = 1 and slibm_series_type = sliimm.sliim_series_type and  (sliimm.sliim_slip_no_fr  between slibm_from_no and slibm_to_no) and (sliimm.sliim_slip_no_to  between slibm_from_no and slibm_to_no) or sliimm.sliim_id = convert(numeric,@currstring))
												BEGIN
												--
														SET @pa_errmsg = 'ERROR:' + 'The range of slip no not matched with original series type'

														return 
												--
												END
				    
												IF EXISTS(SELECT sliim.sliim_deleted_ind FROM slip_issue_mstr sliim,sliim_mak sliimm where sliim.sliim_deleted_ind = 1 and sliim.sliim_series_type = sliimm.sliim_series_type and ((sliimm.sliim_slip_no_fr  between sliim.sliim_slip_no_fr and sliim.sliim_slip_no_to ) or (sliimm.sliim_slip_no_to  between sliim.sliim_slip_no_to and  sliim.sliim_slip_no_fr)) AND sliimm.sliim_id = convert(numeric,@currstring))
												BEGIN
												--
														SET @pa_errmsg = 'ERROR:' +  'Slip no already assigned to another entity'

														return 
												--
												END
												
												BEGIN TRANSACTION
												
										  UPDATE sliim
												SET    sliim_tratm_id      = sliimm.sliim_tratm_id      
																		,sliim_dpm_id        = sliimm.sliim_dpm_id        
																		,sliim_series_type   = sliimm.sliim_series_type   
																		,sliim_entm_id       = sliimm.sliim_entm_id       
																		,sliim_dpam_acct_no  = sliimm.sliim_dpam_acct_no 
																		,sliim_slip_no_fr    = sliimm.sliim_slip_no_fr    
																		,sliim_slip_no_to    = sliimm.sliim_slip_no_to    
																		,sliim_loose_y_n     = sliimm.sliim_loose_y_n     
																	, sliim_lst_upd_dt    = getdate(), sliim_dt = sliimm.sliim_dt
										       , sliim_lst_upd_by    = @pa_login_name  
												FROM   sliim_mak             sliimm
												     , SLIP_ISSUE_MSTR       SLIIM
												WHERE  sliimm.sliim_id          =  convert(numeric,@currstring)
												and    SLIIM.sliim_id           =  sliimm.sliim_id          
												AND    sliimm.sliim_deleted_ind =  6 

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
														UPDATE sliim_mak
														SET    sliim_deleted_ind = 7
																			, sliim_lst_upd_by  = @pa_login_name
																			, sliim_lst_upd_dt  = getdate()
														WHERE  sliim_id          = convert(numeric,@currstring)
														AND    sliim_deleted_ind = 6

														COMMIT TRANSACTION
												--
												END
										--
						    END
						    ELSE IF exists(select * from sliim_mak where sliim_id = convert(numeric,@currstring) and sliim_deleted_ind = 0)
										BEGIN
										--
												INSERT INTO slip_issue_mstr
												(sliim_id
												,sliim_tratm_id
												,sliim_dpm_id
												,sliim_series_type
												,sliim_entm_id
												,sliim_dpam_acct_no
												,sliim_slip_no_fr
												,sliim_slip_no_to
												,sliim_loose_y_n
												,sliim_no_used
												,sliim_all_used
												,sliim_created_by
												,sliim_created_dt
												,sliim_lst_upd_by
												,sliim_lst_upd_dt
												,sliim_deleted_ind, sliim_dt 
            )
												SELECT sliim_id
																		,sliim_tratm_id
																		,sliim_dpm_id
																		,sliim_series_type
																		,sliim_entm_id
																		,sliim_dpam_acct_no
																		,sliim_slip_no_fr
																		,sliim_slip_no_to
																		,sliim_loose_y_n
																		,sliim_no_used
																		,sliim_all_used
																		,sliim_created_by
																		,sliim_created_dt
																		,@pa_login_name
																		,getdate()
																		,1, sliim_dt
												FROM  sliim_mak
												WHERE sliim_id          = convert(numeric,@currstring)
												AND   sliim_deleted_ind = 0

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
														UPDATE sliim_mak
														SET    sliim_deleted_ind = 1
																			, sliim_lst_upd_by  = @pa_login_name
																			, sliim_lst_upd_dt  = getdate()
														WHERE  sliim_id          = convert(numeric,@currstring)
														AND    sliim_deleted_ind = 0


														COMMIT TRANSACTION
												--
												END
										--
						    END
						    ELSE 
										BEGIN
										--
										  if not exists(select USES_SERIES_TYPE from used_slip where  exists (select sliim_id from slip_issue_mstr where sliim_deleted_ind = 1 and sliim_id = CONVERT(BIGINT,@currstring)		and USES_SERIES_TYPE  = sliim_series_type and uses_deleted_ind = 1 and (uses_slip_no between sliim_slip_no_fr and sliim_slip_no_to)))
										  begin
										  --
												  UPDATE slip_issue_mstr
												  SET    sliim_deleted_ind = 0
												  					, sliim_lst_upd_by  = @pa_login_name
												  					, sliim_lst_upd_dt  = getdate()
												  WHERE  sliim_id          = convert(numeric,@currstring)
												  AND    sliim_deleted_ind = 1
												--
												end
												

												UPDATE sliim_mak
												SET    sliim_deleted_ind = 5
																	, sliim_lst_upd_by  = @pa_login_name
																	, sliim_lst_upd_dt  = getdate()
												WHERE  sliim_id          = convert(numeric,@currstring)
												AND    sliim_deleted_ind = 4

												COMMIT TRANSACTION
										--
  						  END
				    --
				    END
				    ELSE IF @PA_ACTION = 'REJ'
								BEGIN
								--
          BEGIN TRANSACTION
          
          
          UPDATE sliim_mak
										SET    sliim_deleted_ind = 3
															, sliim_lst_upd_by  = @pa_login_name
															, sliim_lst_upd_dt  = getdate()
										WHERE  sliim_id          = convert(numeric,@currstring)
										AND    sliim_deleted_ind in (0,4,6)




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
