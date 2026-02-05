-- Object: PROCEDURE citrus_usr.pr_mak_sliim_poa
-- Server: 10.253.78.187 | DB: DMAT
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
CREATE PROCEDURE [citrus_usr].[pr_mak_sliim_poa](@pa_id             VARCHAR(8000)  
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
 DESCRIPTION    : this procedure will contain the maker checker facility for slip_issue_mstr_poa
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
										  IF EXISTS(SELECT SLIIM_DELETED_IND FROM slip_issue_mstr_poa where SLIIM_DELETED_IND = 1 AND SLIIM_TRATM_ID = @pa_sliim_tratm_id AND  sliim_series_type = @pa_series_type and ((@pa_series_from between sliim_slip_no_fr and sliim_slip_no_to ) or (@pa_series_to between sliim_slip_no_to and  sliim_slip_no_fr)) )
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
										
										
											
				      SELECT @l_sliim_id   = ISNULL(MAX(sliim_id),0) + 1 FROM slip_issue_mstr_poa
				      
				      
				      INSERT INTO slip_issue_mstr_poa 
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
				    
				      IF not exists(select uses_id from used_slip, slip_issue_mstr_poa where sliim_tratm_id      = @pa_sliim_tratm_id AND uses_dpam_Acct_no = sliim_dpam_acct_no and uses_series_type = sliim_series_type and uses_slip_no between sliim_slip_no_fr and sliim_slip_no_to and uses_deleted_ind = 1 and sliim_id = CONVERT(BIGINT,@currstring)		 )
				      begin
				      --
				        UPDATE slip_issue_mstr_poa
				        SET    sliim_tratm_id      = @pa_sliim_tratm_id
										        ,sliim_dpm_id        = @l_dpm_id
										  						,sliim_series_type   = @pa_series_type  
										   					,sliim_entm_id       = @pa_entm_id
										  						,sliim_dpam_acct_no  = @pa_dpam_acct_no  
										  						,sliim_slip_no_fr    = @pa_series_from     
										  						,sliim_slip_no_to    = @pa_series_to    
										  						,sliim_loose_y_n     = @pa_loosm_y_n
										  					, sliim_lst_upd_dt    = getdate(), sliim_dt = @pa_dt 
										       , sliim_lst_upd_by    = @pa_login_name 
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
								  if not exists(select USES_SERIES_TYPE from used_slip where  exists (select sliim_id from slip_issue_mstr_poa where SLIIM_DELETED_IND = 1 AND sliim_tratm_id      = @pa_sliim_tratm_id AND sliim_id = CONVERT(bigINT,@currstring)		and USES_SERIES_TYPE  = sliim_series_type and uses_deleted_ind = 1 and (uses_slip_no between sliim_slip_no_fr and sliim_slip_no_to)))
								  begin
								  --
								    UPDATE slip_issue_mstr_poa
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
				 
						
				--
				END
		--
		END
  SET @pa_errmsg = @t_errorstr
--
END

GO
