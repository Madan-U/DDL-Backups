-- Object: PROCEDURE citrus_usr.pr_ins_upd_freeze_cdsl
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_ins_upd_freeze_cdsl] ( @pa_id          VARCHAR(8000)
									,@pa_action       VARCHAR(20)	
									,@pa_login_name   VARCHAR(25)		
									,@pa_fre_dpmid	  varchar(8)
									,@pa_fre_trans_type char(1)
									,@pa_fre_level char(1)
									,@pa_fre_initiated_by int
									,@pa_fre_sub_option  int
									,@pa_boid   varchar(16)
									,@pa_fre_isin varchar(12)
									,@pa_fre_qty_type char(1)
									,@pa_fre_qty varchar(20)
									,@pa_fre_frozen_for char(1)
									,@pa_fre_activation_type int
									,@pa_fre_activation_dt varchar(11)
									,@pa_fre_expiry_dt varchar(11)
									,@pa_fre_reason_cd varchar(5)
									,@pa_fre_int_ref_no varchar(16)
									,@pa_fre_rmks varchar(100)
									,@pa_chk_yn       INT 
									,@rowdelimiter    CHAR(4)       = '*|~*'        
									,@coldelimiter    CHAR(4)       = '|*~|'        
									,@pa_errmsg       VARCHAR(8000)  OUTPUT  	
									)
as
BEGIN
--
	DECLARE @t_errorstr      VARCHAR(8000)      
      , @l_error         BIGINT      
      , @delimeter       VARCHAR(10)      
      , @remainingstring VARCHAR(8000)      
      , @currstring      VARCHAR(8000)      
      , @foundat         INTEGER      
      , @delimeterlength INT   
      , @l_dpm_id        NUMERIC 
	  , @l_int_id        NUMERIC 
	  , @l_int_idm        NUMERIC 	
	  , @l_fre_id        NUMERIC
	  , @l_fre_idm        NUMERIC 
      , @l_dpam_id       NUMERIC     
      , @line_no         NUMERIC      
      , @delimeter_value VARCHAR(10)      
      , @delimeterlength_value VARCHAR(10)      
      , @remainingstring_value VARCHAR(8000)      
      , @currstring_value VARCHAR(8000)   
	  , @c_fre_deleted_ind VARCHAR(25)  
      , @@c_access_cursor  cursor  
      , @l_deleted_ind   INT  
	  , @c_fre_id       varchar(25)  	

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
			SELECT @l_fre_id =ISNULL(MAX(fre_id),0) + 1 FROM  freeze_Unfreeze_dtls_cdsl
			SELECT @l_fre_idm =ISNULL(MAX(fre_id),0) + 1 FROM  freeze_Unfreeze_dtls_cdsl_mak
			IF @l_fre_idm > @l_fre_id
			BEGIN
			--
				SET @l_fre_id = @l_fre_idm
			--
			END
			IF @l_int_idm > @l_int_id    
			BEGIN  
			--  
			SET @l_int_id  = @l_int_idm   
			--  
			END  
			IF @pa_chk_yn = 0     
			BEGIN  
			--  
				SELECT @l_fre_id =ISNULL(MAX(fre_id),0) + 1 FROM  freeze_Unfreeze_dtls_cdsl
				SELECT @l_int_id =ISNULL(MAX(int_id),0) + 1 FROM  freeze_Unfreeze_dtls_CDSL    
			--  
			END
			SELECT @l_dpm_id = dpm_id from dp_mstr where dpm_dpid =@pa_fre_dpmid and dpm_deleted_ind = 1 
			SELECT @l_dpam_id  = dpam_id FROM dp_acct_mstr ,dp_mstr WHERE dpm_deleted_ind = 1  and dpm_id = dpam_dpm_id and dpm_id = @l_dpm_id and dpam_sba_no  = @pa_boid			
			
			IF @pa_chk_yn = 0 
			BEGIN
			--
				if exists(select fre_id from freeze_Unfreeze_dtls_CDSL where fre_DPAM_ID = @l_dpam_id and fre_deleted_ind =1 and fre_status ='A' )
				BEGIN
				--
					SET  @t_errorstr  = 'ERROR:-  Account No. ' +  convert(varchar,@pa_boid) + ' is already freezed'
					SET  @pa_errmsg =  @t_errorstr
					RETURN  
				--
				END
				ELSE
				BEGIN
				--
					BEGIN TRANSACTION
					SET IDENTITY_INSERT freeze_unfreeze_dtls_cdsl on
					INSERT INTO  freeze_Unfreeze_dtls_CDSL
					(
					int_id
					,fre_id
					,fre_trans_type
					,fre_dpmid
					,fre_level
					,fre_initiated_by
					,fre_sub_option
					,fre_DPAM_ID
					,fre_isin
					,fre_qty_type
					,fre_qty
					,fre_frozen_for
					,fre_activation_type
					,fre_activation_dt
					,fre_expiry_dt
					,fre_reason_cd
					,fre_int_ref_no
					,fre_rmks
					,fre_status
					,fre_deleted_ind
					,fre_created_by
					,fre_created_dt
					,fre_lst_upd_by
					,fre_lst_upd_dt
					) VALUES
					(
					@l_int_id
					,@l_fre_id
					,@pa_fre_trans_type
					,@l_dpm_id
					,@pa_fre_level
					,@pa_fre_initiated_by
					,@pa_fre_sub_option
					,@l_dpam_id
					,@pa_fre_isin
					,@pa_fre_qty_type
					,convert(numeric(16,3),@pa_fre_qty)
					,@pa_fre_frozen_for
					,@pa_fre_activation_type 
					,convert(datetime,@pa_fre_activation_dt,103)
					,convert(datetime,@pa_fre_expiry_dt,103)
					,convert(numeric,@pa_fre_reason_cd)
					,@pa_fre_int_ref_no
					,@pa_fre_rmks
					,'A'	
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
			END  --END CHKYN=0
			ELSE IF @pa_chk_yn = 1
			BEGIN
			--
				if exists(select fre_id from freeze_Unfreeze_dtls_CDSL where fre_DPAM_ID = @l_dpam_id and fre_deleted_ind =1 and fre_status ='A' )
				BEGIN
				--
					SET  @t_errorstr  = 'ERROR:- Account No. ' +  convert(varchar,@pa_boid) + ' is already freezed'
					SET  @pa_errmsg =  @t_errorstr
					RETURN  
				--
				END
				ELSE
				BEGIN
				--
					BEGIN TRANSACTION
					SET IDENTITY_INSERT freeze_Unfreeze_dtls_CDSL_MAK on
					INSERT INTO  freeze_Unfreeze_dtls_CDSL_MAK
					(
					int_id
					,fre_id
					,fre_trans_type
					,fre_dpmid
					,fre_level
					,fre_initiated_by
					,fre_sub_option
					,fre_DPAM_ID
					,fre_isin
					,fre_qty_type
					,fre_qty
					,fre_frozen_for
					,fre_activation_type
					,fre_activation_dt
					,fre_expiry_dt
					,fre_reason_cd
					,fre_int_ref_no
					,fre_rmks
					,fre_status
					,fre_deleted_ind
					,fre_created_by
					,fre_created_dt
					,fre_lst_upd_by
					,fre_lst_upd_dt
					) VALUES
					(
					@l_int_idm
					,@l_fre_idm
					,@pa_fre_trans_type
					,@l_dpm_id
					,@pa_fre_level
					,@pa_fre_initiated_by
					,@pa_fre_sub_option
					,@l_dpam_id
					,@pa_fre_isin
					,@pa_fre_qty_type
					,convert(numeric(16,3),@pa_fre_qty)
					,@pa_fre_frozen_for
					,@pa_fre_activation_type 
					,convert(datetime,@pa_fre_activation_dt,103)
					,convert(datetime,@pa_fre_expiry_dt,103)
					,convert(numeric,@pa_fre_reason_cd)
					,@pa_fre_int_ref_no
					,@pa_fre_rmks
					,'A'	
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
			END  --chk_yn =1	
	--
	END
  --
  IF @pa_action='DEL'
  BEGIN
  --
	IF @pa_chk_yn = 0
	BEGIN
	--
		BEGIN TRANSACTION
		UPDATE freeze_unfreeze_dtls_cdsl
		SET fre_deleted_ind = 0
			,fre_lst_upd_by = @pa_login_name
			,fre_lst_upd_dt = getdate()
		WHERE int_id = convert(numeric,@pa_id)
		AND	fre_deleted_ind = 1
		  
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
		IF EXISTS(select fre_id from freeze_unfreeze_dtls_cdsl_mak WHERE int_id = convert(numeric,@pa_id) AND fre_deleted_ind in (0,4) AND fre_trans_type = 'S' )
		BEGIN
		--
			DELETE FROM freeze_unfreeze_dtls_cdsl_mak
			WHERE int_id  =  convert(numeric,@pa_id)
			AND fre_trans_type = 'S'
			AND fre_deleted_ind = 0
		--
		END
		ELSE
		BEGIN
		--
			INSERT INTO freeze_unfreeze_dtls_cdsl_mak
			(int_id
			,fre_id
			,fre_trans_type
			,fre_dpmid
			,fre_level
			,fre_initiated_by
			,fre_sub_option
			,fre_DPAM_ID
			,fre_isin
			,fre_qty_type
			,fre_qty
			,fre_frozen_for
			,fre_activation_type
			,fre_activation_dt
			,fre_expiry_dt
			,fre_reason_cd
			,fre_int_ref_no
			,fre_rmks
			,fre_status
			,fre_deleted_ind
			,fre_created_by
			,fre_created_dt
			,fre_lst_upd_by
			,fre_lst_upd_dt
			)SELECT
			int_id
			,fre_id
			,fre_trans_type
			,fre_dpmid
			,fre_level
			,fre_initiated_by
			,fre_sub_option
			,fre_DPAM_ID
			,fre_isin
			,fre_qty_type
			,fre_qty
			,fre_frozen_for
			,fre_activation_type
			,fre_activation_dt
			,fre_expiry_dt
			,fre_reason_cd
			,fre_int_ref_no
			,fre_rmks
			,fre_status
			,4
			,fre_created_by
			,fre_created_dt
			,@pa_login_name
			,getdate()
			FROM freeze_unfreeze_dtls_cdsl
			WHERE int_id = convert(numeric,@pa_id)
			AND fre_trans_type ='S'
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
  END	 /*del*/
		
	IF @pa_action = 'EDT' 	  
	BEGIN
	-- 
		SELECT @l_dpm_id = dpm_id from dp_mstr where dpm_dpid =@pa_fre_dpmid and dpm_deleted_ind = 1 
		SELECT @l_dpam_id  = dpam_id FROM dp_acct_mstr ,dp_mstr WHERE dpm_deleted_ind = 1  and dpm_id = dpam_dpm_id and dpm_id = @l_dpm_id and dpam_sba_no  = @pa_boid			
		IF @pa_chk_yn = 0
		BEGIN
		--	
		BEGIN TRANSACTION
		UPDATE freeze_unfreeze_dtls_cdsl
		SET fre_dpmid	= @l_dpm_id
			,fre_level  = @pa_fre_level
			,fre_initiated_by = @pa_fre_initiated_by
			,fre_sub_option = @pa_fre_sub_option
			,fre_DPAM_ID = @l_dpam_id
			,fre_isin = @pa_fre_isin
			,fre_qty_type = @pa_fre_qty_type
			,fre_qty = convert(numeric(16,3),@pa_fre_qty)
			,fre_frozen_for = @pa_fre_frozen_for
			,fre_activation_type = @pa_fre_activation_type
			,fre_activation_dt = convert(datetime,@pa_fre_activation_dt,103)
			,fre_expiry_dt = convert(datetime,@pa_fre_expiry_dt,103)
			,fre_reason_cd = convert(numeric,@pa_fre_reason_cd)
			,fre_int_ref_no = @pa_fre_int_ref_no
			,fre_rmks = @pa_fre_rmks
			,fre_lst_upd_by = @pa_login_name
			,fre_lst_upd_dt = getdate()
		WHERE int_id = convert(numeric,@pa_id)
			and fre_deleted_ind = 1
			and fre_status ='A'	
	
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
	END  --chk_yn =0
	
	ELSE IF @pa_chk_yn = 1
	BEGIN	
	--
	  BEGIN TRANSACTION			
	  UPDATE freeze_unfreeze_dtls_cdsl_mak
	  SET fre_deleted_ind = 2
		,fre_lst_upd_by = @pa_login_name
		,fre_lst_upd_dt = getdate()
	  WHERE int_id = convert(numeric,@pa_id)
		AND fre_deleted_ind IN(0,4,6)
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
		IF EXISTS(SELECT fre_id  FROM freeze_unfreeze_dtls_cdsl WHERE int_id = convert(numeric,@pa_id) AND fre_deleted_ind = 1 AND fre_status ='A' )
		BEGIN
		--
			SELECT @l_fre_id =fre_id FROM  freeze_Unfreeze_dtls_cdsl WHERE int_id = convert(numeric,@pa_id) AND fre_deleted_ind = 1 AND fre_status ='A'
			SET @l_deleted_ind = 6
		--
		END
		ELSE
		BEGIN
		--
		  SELECT @l_fre_id =fre_id FROM  freeze_Unfreeze_dtls_cdsl_mak WHERE int_id = convert(numeric,@pa_id) AND fre_status ='A'	
		  SET @l_deleted_ind = 0	
		--
		END
		set identity_insert freeze_unfreeze_dtls_cdsl_mak on
		INSERT INTO freeze_unfreeze_dtls_cdsl_mak
		(int_id
		,fre_id
		,fre_trans_type
		,fre_dpmid
		,fre_level
		,fre_initiated_by
		,fre_sub_option
		,fre_DPAM_ID
		,fre_isin
		,fre_qty_type
		,fre_qty
		,fre_frozen_for
		,fre_activation_type
		,fre_activation_dt
		,fre_expiry_dt
		,fre_reason_cd
		,fre_int_ref_no
		,fre_rmks
		,fre_status
		,fre_deleted_ind
		,fre_created_by
		,fre_created_dt
		,fre_lst_upd_by
		,fre_lst_upd_dt
		)VALUES
		(convert(numeric,@pa_id)	
		,@l_fre_id
		,@pa_fre_trans_type
		,@l_dpm_id
		,@pa_fre_level
		,@pa_fre_initiated_by
		,@pa_fre_sub_option
		,@l_dpam_id
		,@pa_fre_isin
		,@pa_fre_qty_type
		,convert(numeric(16,3),@pa_fre_qty)
		,@pa_fre_frozen_for
		,@pa_fre_activation_type 
		,convert(datetime,@pa_fre_activation_dt,103)
		,convert(datetime,@pa_fre_expiry_dt,103)
		,convert(numeric,@pa_fre_reason_cd)
		,@pa_fre_int_ref_no
		,@pa_fre_rmks
		,'A'	
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
END /*edt*/	

 IF @pa_action = 'APP'
  BEGIN
  --					
	SET @@c_access_cursor =  CURSOR fast_forward FOR   
	SELECT int_id,fre_deleted_ind FROM freeze_unfreeze_dtls_cdsl_mak WHERE int_id = CONVERT(NUMERIC,@currstring) and fre_deleted_ind in (0,4,6) and fre_status ='A' and fre_trans_type = 'S'      
	OPEN @@c_access_cursor 
	FETCH NEXT FROM @@c_access_cursor INTO @c_fre_id, @c_fre_deleted_ind	
	
	WHILE @@fetch_status = 0   
	BEGIN  
	--  		
		BEGIN TRANSACTION	
		IF EXISTS(select * from freeze_unfreeze_dtls_CDSL_mak where int_id=CONVERT(NUMERIC,@c_fre_id) and fre_deleted_ind =6)  
		BEGIN  
		--
			UPDATE freeze_unfreeze_dtls_CDSL
			SET  fre_id = frzufrzm.fre_id
				,fre_trans_type = frzufrzm.fre_trans_type
				,fre_dpmid		= frzufrzm.fre_dpmid
				,fre_level		= frzufrzm.fre_level	
				,fre_initiated_by = frzufrzm.fre_initiated_by
				,fre_sub_option   = frzufrzm.fre_sub_option
				,fre_DPAM_ID      = frzufrzm.fre_DPAM_ID
				,fre_isin		  = frzufrzm.fre_isin	
				,fre_qty_type     = frzufrzm.fre_qty_type
				,fre_qty		  = frzufrzm.fre_qty	
				,fre_frozen_for   = frzufrzm.fre_frozen_for
				,fre_activation_type = frzufrzm.fre_activation_type
				,fre_activation_dt	 = frzufrzm.fre_activation_dt 	
				,fre_expiry_dt		 = frzufrzm.fre_expiry_dt
				,fre_reason_cd		 = frzufrzm.fre_reason_cd	
				,fre_int_ref_no		 = frzufrzm.fre_int_ref_no
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
					UPDATE freeze_unfreeze_dtls_cdsl_mak
					SET    fre_deleted_ind = 7
					, fre_lst_upd_by  = @pa_login_name
					, fre_lst_upd_dt  = getdate()
					WHERE  int_id          = convert(numeric,@c_fre_id)
					AND    fre_deleted_ind = 6

					COMMIT TRANSACTION
					--
					END
				--
				END  --idf
				ELSE IF exists(select * from freeze_unfreeze_dtls_cdsl_mak where int_id = convert(numeric,@c_fre_id) and fre_deleted_ind = 0)
				BEGIN
				--
					set identity_insert freeze_unfreeze_dtls_cdsl on
					INSERT INTO freeze_unfreeze_dtls_cdsl
					(int_id
					,fre_id
					,fre_trans_type
					,fre_dpmid
					,fre_level
					,fre_initiated_by
					,fre_sub_option
					,fre_DPAM_ID
					,fre_isin
					,fre_qty_type
					,fre_qty
					,fre_frozen_for
					,fre_activation_type
					,fre_activation_dt
					,fre_expiry_dt
					,fre_reason_cd
					,fre_int_ref_no
					,fre_rmks
					,fre_status
					,fre_deleted_ind
					,fre_created_by
					,fre_created_dt
					,fre_lst_upd_by
					,fre_lst_upd_dt
					) select 
					 int_id
					,fre_id
					,fre_trans_type
					,fre_dpmid
					,fre_level
					,fre_initiated_by
					,fre_sub_option
					,fre_DPAM_ID
					,fre_isin
					,fre_qty_type
					,fre_qty
					,fre_frozen_for
					,fre_activation_type
					,fre_activation_dt
					,fre_expiry_dt
					,fre_reason_cd
					,fre_int_ref_no
					,fre_rmks
					,fre_status
					,1
					,fre_created_by
					,fre_created_dt
					,@pa_login_name
					,getdate()
					
					FROM  freeze_unfreeze_dtls_cdsl_mak
					WHERE int_id          = convert(numeric,@c_fre_id)
					AND   fre_deleted_ind = 0

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
						UPDATE freeze_unfreeze_dtls_CDSL_mak  
						SET    fre_deleted_ind =1  
						,fre_lst_upd_by  =@pa_login_name  
						,fre_lst_upd_dt  =getdate()  
						WHERE  INT_id = CONVERT(NUMERIC,@c_fre_id)        
						AND    fre_deleted_ind  = 0  

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

					UPDATE freeze_unfreeze_dtls_cdsl_mak  
					SET    fre_deleted_ind =5  
					,fre_lst_upd_by  =@pa_login_name  
					,fre_lst_upd_dt  =getdate()  
					WHERE  int_id = CONVERT(NUMERIC,@c_fre_id)        
					AND    fre_deleted_ind  = 4  
	        
					COMMIT TRANSACTION       	
				--
				END
				FETCH NEXT FROM @@c_access_cursor INTO @c_fre_id, @c_fre_deleted_ind   
			--
			END	
			 CLOSE      @@c_access_cursor          
			DEALLOCATE @@c_access_cursor  
		--
	   END --APP
	   ELSE IF @pa_action = 'REJ'
		BEGIN
		--
			BEGIN TRANSACTION  
			UPDATE freeze_unfreeze_dtls_cdsl_mak  
			SET    fre_deleted_ind =3  
			,fre_lst_upd_by  =@pa_login_name  
			,fre_lst_upd_dt  =getdate()  
			WHERE  int_id = CONVERT(NUMERIC,@currstring)        
			AND    fre_deleted_ind  in (0,4,6)  

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
		END --REJ	

--
END /*loop1*/
--
END /*loop2*/
SET  @pa_errmsg =  @t_errorstr
--
END

GO
