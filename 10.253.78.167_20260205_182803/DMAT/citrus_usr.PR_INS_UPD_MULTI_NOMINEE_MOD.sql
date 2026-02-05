-- Object: PROCEDURE citrus_usr.PR_INS_UPD_MULTI_NOMINEE_MOD
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


create PROCEDURE [citrus_usr].[PR_INS_UPD_MULTI_NOMINEE_MOD]
(
	@PA_NOM_ID INT,
	@PA_DPAM_ID INT,
	@PA_CRN_NO INT,
	@PA_SRNO INT,
	@PA_REASON_CD CHAR(2),
	@PA_REASON_DESC VARCHAR(200),
	@PA_ACTION VARCHAR(50),
	@PA_NOMINEE_TYPE VARCHAR(50),
	@PA_CHANGE_BY VARCHAR(100),
	@PA_DPAM_SBA_NO VARCHAR(16),
	@PA_MSG VARCHAR(8000) OUTPUT
)
AS BEGIN
	DECLARE @PA_VALUE VARCHAR(10)
	IF @PA_ACTION = 'INS'
	BEGIN
	PRINT 'INS'
		--IF EXISTS (SELECT 1 FROM Nominee_Multi WHERE Nom_dpam_id = @PA_DPAM_ID AND Nom_DELETED_IND = '1')
		--BEGIN
		IF @PA_REASON_CD <> ''
			BEGIN
			IF NOT EXISTS(SELECT 1 FROM name_change_reason_cd WHERE nmcrcd_sba_no = @PA_DPAM_SBA_NO AND nmcrcd_holder_type = @PA_NOMINEE_TYPE AND nmcrcd_deleted_ind = 0 )
			BEGIN
			PRINT '111'
			
				INSERT INTO name_change_reason_cd ( 
												nmcrcd_crn_no,
												nmcrcd_sba_no,
												nmcrcd_reason_cd,
												nmcrd_reason_desc,
												nmcrcd_created_dt,
												nmcrcd_created_by,
												nmcrcd_lst_upd_dt,
												nmcrcd_lst_upd_by,
												nmcrcd_deleted_ind,
												nmcrcd_holder_type)
										SELECT  @PA_CRN_NO,
												@PA_DPAM_SBA_NO,
												@PA_REASON_CD,
												@PA_REASON_DESC,
												GETDATE(),
												@PA_CHANGE_BY,
												GETDATE(),
												@PA_CHANGE_BY,
												'0',
												@PA_NOMINEE_TYPE
				
			END
			ELSE
			BEGIN
			PRINT '112'
				UPDATE name_change_reason_cd SET nmcrcd_deleted_ind = '3' WHERE nmcrcd_sba_no = @PA_DPAM_SBA_NO AND nmcrcd_holder_type = @PA_NOMINEE_TYPE AND nmcrcd_deleted_ind = 0 
				INSERT INTO name_change_reason_cd ( 
												nmcrcd_crn_no,
												nmcrcd_sba_no,
												nmcrcd_reason_cd,
												nmcrd_reason_desc,
												nmcrcd_created_dt,
												nmcrcd_created_by,
												nmcrcd_lst_upd_dt,
												nmcrcd_lst_upd_by,
												nmcrcd_deleted_ind,
												nmcrcd_holder_type)
										SELECT  @PA_CRN_NO,
												@PA_DPAM_SBA_NO,
												@PA_REASON_CD,
												@PA_REASON_DESC,
												GETDATE(),
												@PA_CHANGE_BY,
												GETDATE(),
												@PA_CHANGE_BY,
												'0',
												@PA_NOMINEE_TYPE
			END
		END
		
		PRINT '113'
			INSERT INTO client_list_modified
			SELECT 
				@PA_DPAM_SBA_NO
				,''
				,@PA_NOMINEE_TYPE
				,GETDATE()
				,GETDATE()
				,@PA_CHANGE_BY
				,GETDATE()
				,@PA_CHANGE_BY
				,GETDATE()
				,'0'
				,'0'
	END

	IF @PA_ACTION = 'VALIDATE NAME CHANGE CD'
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM Nominee_Multi WHERE Nom_dpam_id = @PA_DPAM_ID AND Nom_DELETED_IND = '1')
		BEGIN
			SET @PA_VALUE = 'N'
		END
	END

	IF @PA_ACTION = 'INS_CLIENT_LIST'
	BEGIN
		
		EXEC pr_ins_upd_list @PA_CRN_NO, 'I','MULTI NOMINEE', @PA_CHANGE_BY, '*|~*', '|*~|', '' 
	END
	
		--DECLARE @NOMINEE1 VARCHAR(500), 
		--		@NOMINEE2 VARCHAR(500),
		--		@NOMINEE3 VARCHAR(550),
		--		@NOMINEE1_G VARCHAR(500),
		--		@NOMINEE2_G VARCHAR(500),
		--		@NOMINEE3_G VARCHAR(500)

		--DECLARE @NOMINEE1_MAK VARCHAR(500), 
		--		@NOMINEE2_MAK VARCHAR(500),
		--		@NOMINEE3_MAK VARCHAR(550),
		--		@NOMINEE1_G_MAK VARCHAR(500),
		--		@NOMINEE2_G_MAK VARCHAR(500),
		--		@NOMINEE3_G_MAK VARCHAR(500),
		--		@MOD_STRING VARCHAR(200),
		--		@FIND_DOB DATETIME
		--		SET @MOD_STRING = ''

		--		SET @NOMINEE1 = ''
		--		SET @NOMINEE2 = ''
		--		SET @NOMINEE3 = ''
		--		SET @NOMINEE1_G = ''
		--		SET @NOMINEE2_G = ''
		--		SET @NOMINEE3_G = ''
				
		--		SET @NOMINEE1_MAK = ''
		--		SET @NOMINEE2_MAK = ''
		--		SET @NOMINEE3_MAK = ''
		--		SET @NOMINEE1_G_MAK = ''
		--		SET @NOMINEE2_G_MAK = ''
		--		SET @NOMINEE3_G_MAK = ''

		--		SET @NOMINEE1 =		[citrus_usr].[fn_one_string_of_multi_nominee] (@PA_DPAM_ID , 'MSTR' , '1')
		--		SET @NOMINEE2 =		[citrus_usr].[fn_one_string_of_multi_nominee] (@PA_DPAM_ID , 'MSTR' , '2')
		--		SET @NOMINEE3 =		[citrus_usr].[fn_one_string_of_multi_nominee] (@PA_DPAM_ID , 'MSTR' , '3')
		--		SET @NOMINEE1_G =	[citrus_usr].[fn_one_string_of_multi_nominee] (@PA_DPAM_ID , 'MSTR' , '4')
		--		SET @NOMINEE2_G =	[citrus_usr].[fn_one_string_of_multi_nominee] (@PA_DPAM_ID , 'MSTR' , '5')
		--		SET @NOMINEE3_G =	[citrus_usr].[fn_one_string_of_multi_nominee] (@PA_DPAM_ID , 'MSTR' , '6')

		--		SET @NOMINEE1_MAK =		[citrus_usr].[fn_one_string_of_multi_nominee] (@PA_DPAM_ID , 'MAK' , '1')
		--		SET @NOMINEE2_MAK =		[citrus_usr].[fn_one_string_of_multi_nominee] (@PA_DPAM_ID , 'MAK' , '2')
		--		SET @NOMINEE3_MAK =		[citrus_usr].[fn_one_string_of_multi_nominee] (@PA_DPAM_ID , 'MAK' , '3')
		--		SET @NOMINEE1_G_MAK =	[citrus_usr].[fn_one_string_of_multi_nominee] (@PA_DPAM_ID , 'MAK' , '4')
		--		SET @NOMINEE2_G_MAK =	[citrus_usr].[fn_one_string_of_multi_nominee] (@PA_DPAM_ID , 'MAK' , '5')
		--		SET @NOMINEE3_G_MAK =	[citrus_usr].[fn_one_string_of_multi_nominee] (@PA_DPAM_ID , 'MAK' , '6')

		--IF @PA_ACTION ='VALIDATE'
		--BEGIN
		--	IF EXISTS(SELECT 1 FROM Nominee_Multi WHERE Nom_dpam_id = @PA_DPAM_ID AND Nom_DELETED_IND = '1')
		--	BEGIN
		--		IF EXISTS(SELECT 1 FROM Nominee_Multi_mak WHERE Nom_dpam_id = @PA_DPAM_ID AND Nom_DELETED_IND = '0')
		--		BEGIN
		--			IF @NOMINEE1_MAK <> @NOMINEE1
		--			BEGIN
		--				SET @FIND_DOB = DATEDIFF(DAY, CITRUS_USR.FN_SPLITVAL_BY(@NOMINEE1,4,'~'), GetDate()) / 365.25
		--				IF @FIND_DOB <= 18 
		--				BEGIN
		--					SET @MOD_STRING = 'NOMINEE1' + '~' + 'NOMINEE GUARDIAN1'
							
		--				END
		--			END
															
		--			IF @NOMINEE2_MAK <> @NOMINEE2
		--			BEGIN
		--				SET @FIND_DOB = ''
		--				SET @FIND_DOB = DATEDIFF(DAY, CITRUS_USR.FN_SPLITVAL_BY(@NOMINEE2,4,'~'), GetDate()) / 365.25
		--				IF @FIND_DOB <= 18 
		--				BEGIN
		--					SET @MOD_STRING = 'NOMINEE2' + '~' + 'NOMINEE GUARDIAN2'
		--				END
		--			END

		--			IF @NOMINEE3_MAK <> @NOMINEE3
		--			BEGIN
		--				SET @FIND_DOB = ''
		--				SET @FIND_DOB = DATEDIFF(DAY, CITRUS_USR.FN_SPLITVAL_BY(@NOMINEE3,4,'~'), GetDate()) / 365.25
		--				IF @FIND_DOB <= 18 
		--				BEGIN
		--					SET @MOD_STRING = 'NOMINEE3' + '~' + 'NOMINEE GUARDIAN3'
		--				END
		--			END
					
		--		END
		--	END

		--	--IF NOT EXISTS(SELECT 1 FROM Nominee_Multi WHERE Nom_dpam_id = @PA_DPAM_ID AND Nom_DELETED_IND = '1')
		--	--BEGIN
		--	--	IF EXISTS(SELECT 1 FROM Nominee_Multi_mak WHERE Nom_dpam_id = @PA_DPAM_ID AND Nom_DELETED_IND = '0')
		--	--	BEGIN
		--	--		--Only allow modification
		--	--	END
		--	--END

		--	--IF NOT EXISTS(SELECT 1 FROM Nominee_Multi WHERE Nom_dpam_id = @PA_DPAM_ID AND Nom_DELETED_IND = '1')
		--	--BEGIN
		--	--	IF NOT EXISTS(SELECT 1 FROM Nominee_Multi_mak WHERE Nom_dpam_id = @PA_DPAM_ID AND Nom_DELETED_IND = '0')
		--	--	BEGIN
		--	--		--Not allow modification
		--	--	END
		--	--END
			
		--END
	END

GO
