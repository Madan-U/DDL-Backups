-- Object: PROCEDURE citrus_usr.PR_INS_UPD_DIS_CANCELLATION_POA_27062014_bak1
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------



create PROCEDURE [citrus_usr].[PR_INS_UPD_DIS_CANCELLATION_POA_27062014_bak1] 
(
	@PA_EXCSM_ID NUMERIC,
	@PA_ACTION VARCHAR(50),
	@PA_TRXINIT_FLG VARCHAR(5),
	@PA_CANCEL_REASON VARCHAR(100),
	@PA_CANCEL_DT DATETIME,
	@PA_BOOK_NO VARCHAR(100),
	@PA_FROM_SLIP VARCHAR(30),
	@PA_TO_SLIP VARCHAR(30),
	@PA_REMARKS VARCHAR(500),
	@PA_LOGIN_NAME VARCHAR(150),
	@PA_TRXTYPE VARCHAR(50), 
	@PA_SERIES_TYPE VARCHAR(50),
	@PA_USES_ID NUMERIC,
	@PA_ERRMSG VARCHAR(8000) OUTPUT  
)
AS 
BEGIN
	DECLARE @l_USES_ID NUMERIC,
			@l_DPM_ID NUMERIC,
			@L_ERROR BIGINT,
			@T_ERRORSTR VARCHAR(8000),
			@L_USES_DPAM_ACCT_NO VARCHAR(20)

	IF convert(varchar,@PA_EXCSM_ID) <> ''
	BEGIN 
		SELECT @l_DPM_ID = DPM_ID FROM DP_MSTR WHERE DPM_EXCSM_ID = @PA_EXCSM_ID AND DEFAULT_DP = DPM_EXCSM_ID
	END
	IF @PA_ACTION = 'SEARCH_CANCELLED_RECORD'
	BEGIN
		if ISNULL(@PA_FROM_SLIP,'')<>'' and ISNULL(@PA_FROM_SLIP,'')<>''
		begin
		SELECT  USES_ID,
				slibm_book_name AS SLIIM_BOOK_NAME,
				USES_SLIP_NO,
				USES_SLIP_NO_TO,
				USES_TRANTM_ID,
				TRASTM_DESC,
				USES_SERIES_TYPE, 
				USES_SLIPREMARKS,
				USES_TRX_INITIATION_FLAG,
				USES_DIS_CANCELLATION_FLAG,
				CONVERT(VARCHAR(11),USES_CANCELLATION_DT,103) USES_CANCELLATION_DT,
				--'1|*~|' + CONVERT(VARCHAR,USES_DPM_ID) AS USES_DPM_ID,
				'1|*~|' + CONVERT(VARCHAR,@PA_EXCSM_ID) as USES_DPM_ID,
				USES_DPAM_ACCT_NO
		FROM USED_SLIP_BLOCK, SLIP_ISSUE_MSTR_POA, SLIP_BOOK_MSTR ,
		TRANSACTION_SUB_TYPE_MSTR
		WHERE  SLIIM_TRATM_ID = USES_TRANTM_ID
		AND SLIIM_SLIP_NO_FR = SLIBM_FROM_NO
		AND SLIIM_SLIP_NO_TO = SLIBM_TO_NO
		AND SLIIM_SERIES_TYPE = SLIBM_SERIES_TYPE
		AND sliim_dpm_id = SLIBM_DPM_ID
		AND TRASTM_ID = SLIBM_TRATM_ID
		AND USES_TRANTM_ID =SLIBM_TRATM_ID
		AND USES_TRANTM_ID = SLIBM_TRATM_ID
		AND slibm_book_name = USED_BOOK_NAME
		AND USES_DPM_ID = SLIBM_DPM_ID
		AND USES_SERIES_TYPE = SLIBM_SERIES_TYPE
		AND SLIIM_SERIES_TYPE = USES_SERIES_TYPE
		AND TRASTM_ID = USES_TRANTM_ID
		AND TRASTM_ID = SLIIM_TRATM_ID
		AND USES_TRANTM_ID = @PA_TRXTYPE
		AND USES_SLIP_NO >= ISNULL(@PA_FROM_SLIP,'') and  USES_SLIP_NO_TO<=@PA_TO_SLIP			                  
		AND USES_CANCELLATION_DT LIKE CASE WHEN ISNULL(@PA_CANCEL_DT,'') = '' THEN USES_CANCELLATION_DT ELSE CONVERT(DATETIME,@PA_CANCEL_DT,103) END
		AND USES_SERIES_TYPE LIKE CASE WHEN ISNULL(@PA_SERIES_TYPE,'') = '' THEN '%' ELSE @PA_SERIES_TYPE END
		AND USES_TRX_INITIATION_FLAG LIKE CASE WHEN ISNULL(@PA_TRXINIT_FLG,'NO') = 'NO' THEN '%' ELSE @PA_TRXINIT_FLG END
		AND USES_DIS_CANCELLATION_FLAG LIKE CASE WHEN ISNULL(@PA_CANCEL_REASON,'') = '' THEN '%' ELSE @PA_CANCEL_REASON END
		AND TRASTM_DELETED_IND = 1
		AND SLIIM_DELETED_IND = 1
		AND USES_DELETED_IND  = 1
		end
		else
		begin
		SELECT  USES_ID,
				slibm_book_name AS SLIIM_BOOK_NAME,
				USES_SLIP_NO,
				USES_SLIP_NO_TO,
				USES_TRANTM_ID,
				TRASTM_DESC,
				USES_SERIES_TYPE, 
				USES_SLIPREMARKS,
				USES_TRX_INITIATION_FLAG,
				USES_DIS_CANCELLATION_FLAG,
				CONVERT(VARCHAR(11),USES_CANCELLATION_DT,103) USES_CANCELLATION_DT,
				--'1|*~|' + CONVERT(VARCHAR,USES_DPM_ID) AS USES_DPM_ID,
				'1|*~|' + CONVERT(VARCHAR,@PA_EXCSM_ID) as USES_DPM_ID,
				USES_DPAM_ACCT_NO
		FROM USED_SLIP_BLOCK, SLIP_ISSUE_MSTR_POA,  SLIP_BOOK_MSTR ,
		TRANSACTION_SUB_TYPE_MSTR
		WHERE  SLIIM_TRATM_ID = USES_TRANTM_ID
		AND SLIIM_SLIP_NO_FR = SLIBM_FROM_NO
		AND SLIIM_SLIP_NO_TO = SLIBM_TO_NO
		AND SLIIM_SERIES_TYPE = SLIBM_SERIES_TYPE
		AND sliim_dpm_id = SLIBM_DPM_ID
		AND TRASTM_ID = SLIBM_TRATM_ID
		AND USES_TRANTM_ID =SLIBM_TRATM_ID
		AND USES_TRANTM_ID = SLIBM_TRATM_ID
		AND slibm_book_name = USED_BOOK_NAME
		AND USES_DPM_ID = SLIBM_DPM_ID
		AND USES_SERIES_TYPE = SLIBM_SERIES_TYPE
		AND SLIIM_SERIES_TYPE = USES_SERIES_TYPE
		AND TRASTM_ID = USES_TRANTM_ID
		AND TRASTM_ID = SLIIM_TRATM_ID
		AND USES_TRANTM_ID = @PA_TRXTYPE
		--AND USES_SLIP_NO LIKE CASE WHEN ISNULL(@PA_FROM_SLIP,'') = '' THEN '%' ELSE  @PA_FROM_SLIP END                                      
		--AND USES_SLIP_NO_TO LIKE CASE WHEN ISNULL(@PA_TO_SLIP,'') = '' THEN '%' ELSE @PA_TO_SLIP  END                    
		AND USES_CANCELLATION_DT LIKE CASE WHEN ISNULL(@PA_CANCEL_DT,'') = '' THEN USES_CANCELLATION_DT ELSE CONVERT(DATETIME,@PA_CANCEL_DT,103) END
		AND USES_SERIES_TYPE LIKE CASE WHEN ISNULL(@PA_SERIES_TYPE,'') = '' THEN '%' ELSE @PA_SERIES_TYPE END
		AND USES_TRX_INITIATION_FLAG LIKE CASE WHEN ISNULL(@PA_TRXINIT_FLG,'NO') = 'NO' THEN '%' ELSE @PA_TRXINIT_FLG END
		AND USES_DIS_CANCELLATION_FLAG LIKE CASE WHEN ISNULL(@PA_CANCEL_REASON,'') = '' THEN '%' ELSE @PA_CANCEL_REASON END
		AND TRASTM_DELETED_IND = 1
		AND SLIIM_DELETED_IND = 1
		AND USES_DELETED_IND  = 1		
		end
	END
	IF @PA_ACTION = 'SELECTBOOK'
	BEGIN
		SELECT slibm_book_name as sliim_book_name, SLIIM_SERIES_TYPE
		FROM SLIP_ISSUE_MSTR_POA ,SLIP_BOOK_MSTR
		where CONVERT(NUMERIC,@PA_FROM_SLIP) BETWEEN SLIIM_SLIP_NO_FR AND SLIIM_SLIP_NO_TO
		and CONVERT(NUMERIC,@PA_TO_SLIP) BETWEEN SLIIM_SLIP_NO_FR AND SLIIM_SLIP_NO_TO
		and SLIIM_TRATM_ID=@PA_TRXTYPE 
		AND SLIIM_SLIP_NO_FR = SLIBM_FROM_NO
		AND SLIIM_SLIP_NO_TO = SLIBM_TO_NO
		AND SLIIM_SERIES_TYPE = SLIBM_SERIES_TYPE
		AND sliim_dpm_id = SLIBM_DPM_ID
		and SLIIM_SERIES_TYPE=@PA_SERIES_TYPE
		AND SLIIM_DELETED_IND = 1
	END

	IF @PA_ACTION = 'SELECTSLIP'
	BEGIN
		SELECT SLIIM_SLIP_NO_FR,SLIIM_SLIP_NO_TO 
		FROM SLIP_ISSUE_MSTR_POA ,SLIP_BOOK_MSTR
		where slibm_book_name=@PA_BOOK_NO 
		AND SLIIM_SLIP_NO_FR = SLIBM_FROM_NO
		AND SLIIM_SLIP_NO_TO = SLIBM_TO_NO
		AND SLIIM_SERIES_TYPE = SLIBM_SERIES_TYPE
		AND sliim_dpm_id = SLIBM_DPM_ID
		and SLIIM_TRATM_ID=CONVERT(NUMERIC,@PA_TRXTYPE)
		and SLIIM_SERIES_TYPE=@PA_SERIES_TYPE
		AND SLIIM_DELETED_IND = 1
	END
	
	IF @PA_ACTION = 'VALIDATESLIP'
	BEGIN
		IF EXISTS (SELECT 1 FROM USED_SLIP WHERE USES_SLIP_NO>=CONVERT(NUMERIC,@PA_FROM_SLIP) AND USES_SLIP_NO<=CONVERT(NUMERIC,@PA_TO_SLIP)
		AND USES_TRANTM_ID=@PA_TRXTYPE AND USES_SERIES_TYPE=@PA_SERIES_TYPE AND USES_DELETED_IND =1)
		BEGIN
		SELECT 'N' -- not allowed
		END
		ELSE
		BEGIN
		SELECT 'Y' -- allowed
		END
	END
	IF @PA_ACTION = 'EDT'
	BEGIN
		BEGIN TRANSACTION
		UPDATE USED_SLIP_BLOCK
		SET USES_SLIP_NO = @PA_FROM_SLIP,
			USES_SLIP_NO_TO = @PA_TO_SLIP,
			USES_TRANTM_ID = @PA_TRXTYPE,
			USES_SERIES_TYPE = @PA_SERIES_TYPE,
			USES_LST_UPD_BY = @PA_LOGIN_NAME,
			USES_LST_UPD_DT = GETDATE(),
			USES_SLIPREMARKS = @PA_REMARKS,
			USES_TRX_INITIATION_FLAG = @PA_TRXINIT_FLG,
			USES_DIS_CANCELLATION_FLAG = @PA_CANCEL_REASON,
			USES_CANCELLATION_DT = convert(datetime,@PA_CANCEL_DT,103)
		WHERE USES_ID = @PA_USES_ID
		AND USES_DELETED_IND  = 1
		SET @L_ERROR = @@ERROR                                
								  IF @L_ERROR <> 0                                
								  BEGIN                                
								  --                            
										IF EXISTS(SELECT ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = @L_ERROR)                                
										BEGIN                                
										--                                
										  SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': '+ ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = CONVERT(VARCHAR,@L_ERROR)                                
										--                                
										END                                
										ELSE                                
										BEGIN                                
										--                                
										  SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': CAN NOT PROCESS, PLEASE CONTACT YOUR ADMINISTRATOR!'                                
										--                                
										END                                
								                                
										ROLLBACK TRANSACTION                                 
								                                
										RETURN                                
								  --                                
								  END    
								  ELSE                                
								  BEGIN                                
								  --                            
										SET  @T_ERRORSTR  = 'SUCCESSFULLY'
								                                
										COMMIT TRANSACTION                                
								  --                                
								  END  
	END
	IF @PA_ACTION = 'DEL'
	BEGIN
		BEGIN TRANSACTION
--		DELETE FROM USED_SLIP_BLOCK
--		WHERE USES_ID = @PA_USES_ID
		UPDATE USED_SLIP_BLOCK SET USES_DELETED_IND = '9', USES_LST_UPD_BY = @PA_LOGIN_NAME,USES_LST_UPD_DT = getdate()
		WHERE USES_ID = @PA_USES_ID
		AND USES_DELETED_IND  = 1
		SET @L_ERROR = @@ERROR                                
								  IF @L_ERROR <> 0                                
								  BEGIN                                
								  --                            
										IF EXISTS(SELECT ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = @L_ERROR)                                
										BEGIN                                
										--                                
										  SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': '+ ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = CONVERT(VARCHAR,@L_ERROR)                                
										--                                
										END                                
										ELSE                                
										BEGIN                                
										--                                
										  SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': CAN NOT PROCESS, PLEASE CONTACT YOUR ADMINISTRATOR!'                                
										--                                
										END                                
								                                
										ROLLBACK TRANSACTION                                 
								                                
										RETURN                                
								  --                                
								  END    
								  ELSE                                
								  BEGIN                                
								  --                            
										SET  @T_ERRORSTR  = 'SUCCESSFULLY'
								                                
										COMMIT TRANSACTION                                
								  --                                
								  END 
	END
	IF @PA_ACTION = 'INS'
	BEGIN
		SET @L_USES_DPAM_ACCT_NO = ''
		SELECT DISTINCT @L_USES_DPAM_ACCT_NO = SLIIM_DPAM_ACCT_NO 
		FROM SLIP_ISSUE_MSTR_POA 
		WHERE SLIIM_TRATM_ID = @PA_TRXTYPE
		AND SLIIM_SERIES_TYPE = @PA_SERIES_TYPE
		AND CONVERT(NUMERIC,@PA_FROM_SLIP) BETWEEN SLIIM_SLIP_NO_FR AND SLIIM_SLIP_NO_TO
		AND CONVERT(NUMERIC,@PA_TO_SLIP) BETWEEN SLIIM_SLIP_NO_FR AND SLIIM_SLIP_NO_TO
		AND SLIIM_DELETED_IND = 1
		SELECT @l_USES_ID = MAX(USES_ID) + 1 FROM USED_SLIP_BLOCK
		IF ISNULL(@l_USES_ID,'0') = '0'
		BEGIN
			SET @l_USES_ID = 1
		END
		BEGIN TRANSACTION
		IF NOT EXISTS (SELECT 1 FROM USED_SLIP_BLOCK 
						WHERE ((CONVERT(NUMERIC,@PA_FROM_SLIP) BETWEEN USES_SLIP_NO AND USES_SLIP_NO_to) OR
						(CONVERT(NUMERIC,@PA_TO_SLIP) BETWEEN USES_SLIP_NO AND USES_SLIP_NO_to)) 
						AND USES_TRANTM_ID = @PA_TRXTYPE
						AND USES_SERIES_TYPE = @PA_SERIES_TYPE AND USES_DELETED_IND = 1)
		BEGIN
		PRINT 'INSERT'
		INSERT INTO USED_SLIP_BLOCK(
									USES_ID,
									USES_DPM_ID,
									USES_DPAM_ACCT_NO,
									USES_SLIP_NO,
									USES_SLIP_NO_TO,
									USES_TRANTM_ID,
									USES_SERIES_TYPE,
									USES_USED_DESTR,
									USES_CREATED_BY,
									USES_CREATED_DT,
									USES_LST_UPD_BY,
									USES_LST_UPD_DT,
									USES_DELETED_IND, 
									uses_slipremarks,
									uses_batch_no,
									USES_TRX_INITIATION_FLAG,
									USES_DIS_CANCELLATION_FLAG,
									USES_CANCELLATION_DT,
									USED_BOOK_NAME,
									USED_ENTITY_TYPE
								    )
									VALUES
									(
									@l_USES_ID,
									@l_DPM_ID,
									@L_USES_DPAM_ACCT_NO,
									@PA_FROM_SLIP,
									@PA_TO_SLIP,
									@PA_TRXTYPE,
									@PA_SERIES_TYPE,
									'',
									@PA_LOGIN_NAME,
									GETDATE(),
									@PA_LOGIN_NAME,
									GETDATE(),
									'1',
									@PA_REMARKS,
									'',
									@PA_TRXINIT_FLG,
									@PA_CANCEL_REASON,
									convert(datetime,@PA_CANCEL_DT,103),
									@PA_BOOK_NO,
									'B'
									--CASE WHEN @PA_TRXTYPE = '1000' THEN 'P' ELSE 'B' END
									)
									
								  SET @L_ERROR = @@ERROR                                
								  IF @L_ERROR <> 0                                
								  BEGIN                                
								  --                            
										IF EXISTS(SELECT ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = @L_ERROR)                                
										BEGIN                                
										--                                
										  SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': '+ ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = CONVERT(VARCHAR,@L_ERROR)                                
										--                                
										END                                
										ELSE                                
										BEGIN                                
										--                                
										  SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': CAN NOT PROCESS, PLEASE CONTACT YOUR ADMINISTRATOR!'                                
										--                                
										END                                
								                                
										ROLLBACK TRANSACTION                                 
								                                
										RETURN                                
								  --                                
								  END    
								  ELSE                                
								  BEGIN                                
								  --                            
										SET  @T_ERRORSTR  = 'SUCCESSFULLY'
								                                
										COMMIT TRANSACTION                                
								  --                                
								  END         									
									
			END
			ELSE
			BEGIN
				PRINT 'NOT INSERT'
				SET @T_ERRORSTR = 'SLIP IS ALREADY CANCELLED!!!'
			
			END
	END
SET @PA_ERRMSG = ISNULL(@T_ERRORSTR,'')
END

GO
