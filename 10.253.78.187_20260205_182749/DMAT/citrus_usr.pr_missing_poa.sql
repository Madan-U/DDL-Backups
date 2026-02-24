-- Object: PROCEDURE citrus_usr.pr_missing_poa
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--begin tran 
--exec pr_missing_poa
--select * from dp_poa_dtls , dp_acct_mstr where DPPD_DPAM_ID = DPAM_ID and DPAM_BBO_CODE in (select kit_no from missingpoalist)
--commit
CREATE proc pr_missing_poa
as
begin 
DECLARE @C_CLIENT_SUMMARY CURSOR, @C_BEN_ACCT_NO VARCHAR(16), @L_CLIENT_VALUES VARCHAR(8000), @L_CRN_NO NUMERIC, @L_DPM_DPID VARCHAR(20), @L_COMPM_ID NUMERIC, @L_DP_ACCT_VALUES VARCHAR(8000), @L_EXCSM_ID NUMERIC, @L_ADR VARCHAR(8000), @L_CONC VARCHAR(8000), @L_BR_SH_NAME VARCHAR(50), @L_ENTR_VALUE VARCHAR(8000), @L_DPBA_VALUES VARCHAR(8000), @L_ENTP_VALUE VARCHAR(8000), @C_CX_PANNO VARCHAR(50), @L_ENTPD_VALUE VARCHAR(8000), @L_ACCP_VALUE VARCHAR(8000), @L_ACCPD_VALUE VARCHAR(8000), @L_DPAM_ID NUMERIC, @L_BANK_NAME VARCHAR(150), @L_ADDR_VALUE VARCHAR(8000), @L_BANM_BRANCH VARCHAR(250), @L_MICR_NO VARCHAR(20), @L_BANM_ID NUMERIC, @L_ACC_CONC VARCHAR(8000), @L_CLI_EXISTS_YN CHAR(1), @@BOCTGRY VARCHAR(10), @@HO_CD VARCHAR(20), @L_DPPD_DETAILS VARCHAR(8000), @@l_error INTEGER 
	
	DECLARE @pa_ref_no VARCHAR(100)

	
		
		
	SET @C_CLIENT_SUMMARY = CURSOR FAST_FORWARD
	FOR
	SELECT dpam_sba_no from dp_acct_mstr where  dpam_bbo_code in (select kit_no from missingpoalist)
		
		OPEN @C_CLIENT_SUMMARY

	FETCH NEXT
	FROM @C_CLIENT_SUMMARY
	INTO @C_BEN_ACCT_NO

	WHILE @@FETCH_STATUS = 0
	BEGIN --#CURSOR     

SET @L_DPPD_DETAILS = ''

select @L_CRN_NO = dpam_crn_no from dp_Acct_mstr where DPAM_SBA_NO  = @C_BEN_ACCT_NO

	SELECT @pa_ref_no = DPAM_SBA_NO 
		FROM dp_acct_mstr 
		WHERE DPAM_SBA_NO = @C_BEN_ACCT_NO
			
		SELECT @L_DPM_DPID = DPM_DPID, @L_EXCSM_ID = DEFAULT_DP
		FROM DP_MSTR, EXCH_SEG_MSTR, dp_acct_mstr
		WHERE DEFAULT_DP = EXCSM_ID
			AND EXCSM_EXCH_CD = 'CDSL'
			AND dpm_excsm_id = default_dp
			AND DPAM_SBA_NO = @C_BEN_ACCT_NO

		SELECT @L_COMPM_ID = EXCSM_COMPM_ID
		FROM EXCH_SEG_MSTR
		WHERE EXCSM_ID = @L_EXCSM_ID
		
		
 
		SELECT @L_DPPD_DETAILS = @L_DPPD_DETAILS + ISNULL(CONVERT(VARCHAR, @L_COMPM_ID), '') + '|*~|' + ISNULL(CONVERT(VARCHAR, @L_EXCSM_ID), '') + '|*~|' 
		+ ISNULL(CONVERT(VARCHAR, @L_DPM_DPID), '') + '|*~|' + @pa_ref_no + '|*~|' + ISNULL(LTRIM(RTRIM('FULL')), '') + '|*~|' + CASE 
				WHEN holder_number = '1'
					THEN ISNULL(LTRIM(RTRIM('1ST HOLDER')), '')
				WHEN holder_number = '2'
					THEN ISNULL(LTRIM(RTRIM('2ND HOLDER')), '')
				WHEN holder_number = '3'
					THEN ISNULL(LTRIM(RTRIM('3RD HOLDER')), '')
				END + '|*~|' + ISNULL(LTRIM(RTRIM(a.DPAM_SBA_NAME)), '') + '|*~|' + ISNULL(LTRIM(RTRIM('')), '') + '|*~|' 
				+ ISNULL(LTRIM(RTRIM('')), '') + '|*~|' + ISNULL(LTRIM(RTRIM('')), '') + '|*~|' + ISNULL(LTRIM(RTRIM('')), '') 
				+ '|*~|' + ISNULL(LTRIM(RTRIM('')), '') + '|*~|' + ISNULL(LTRIM(RTRIM('')), '') + '|*~|' + ISNULL(LTRIM(RTRIM(0)), '')
				 + '|*~|' + ISNULL(LTRIM(RTRIM(GPA_BPA_FLAG)), '') + '|*~|' + CONVERT(VARCHAR(11), getdate(), 103) + '|*~|' 
				 + CONVERT(VARCHAR(11), getdate(), 103) + '|*~|' + CONVERT(VARCHAR(11), isnull(EFFECTIVE_TO_DATE, ''), 103)
				  + '|*~|' + LTRIM(RTRIM(POAM_MASTER_ID)) + '|*~|' + '0' + '|*~|' + '0|*~||*~||*~||*~|' + 'A*|~*'
		FROM kyc..API_CLIENT_POA poa, poam, API_CLIENT_MASTER_SYNERGY_DP main,dp_acct_mstr  a
		WHERE main.KIT_NO = DPAM_BBO_CODE and a.dpam_sba_no = @C_BEN_ACCT_NO 
			AND main.purpose_code = '1'
			AND LTRIM(RTRIM(MASTER_POA_ID)) = LTRIM(RTRIM(poam_master_id))
			AND poa.kit_no = main.kit_no

		SELECT @L_DPPD_DETAILS = @L_DPPD_DETAILS + ISNULL(CONVERT(VARCHAR, @L_COMPM_ID), '') + '|*~|' + ISNULL(CONVERT(VARCHAR, @L_EXCSM_ID), '') + '|*~|' + ISNULL(CONVERT(VARCHAR, @L_DPM_DPID), '') + '|*~|' + @pa_ref_no + '|*~|' + ISNULL(LTRIM(RTRIM('AUTHORISED SIGNATORY')), '') + '|*~|' + ISNULL(LTRIM(RTRIM('1ST HOLDER')), '') + '|*~|' + ISNULL(LTRIM(RTRIM(FIRST_NAME)), '') + '|*~|' + ISNULL(LTRIM(RTRIM(MIDDLE_NAME)), '') + '|*~|' + ISNULL(LTRIM(RTRIM(LAST_NAME)), '') + '|*~|' + ISNULL(LTRIM(RTRIM('')), '') + '|*~|' + ISNULL(LTRIM(RTRIM('')), '') + '|*~|' + ISNULL(LTRIM(RTRIM('')), '') + '|*~|' + ISNULL(LTRIM(RTRIM(pan_gir)), '') + '|*~|' + ISNULL(LTRIM(RTRIM(0)), '') + '|*~|' + ISNULL(LTRIM(RTRIM('')), '') + '|*~|' + CONVERT(VARCHAR(11), '', 103) + '|*~|' + CONVERT(VARCHAR(11), '', 103) + '|*~|' + CONVERT(VARCHAR(11), isnull('', 'dec 31 2100'), 103) + '|*~|' + LTRIM(RTRIM('')) + '|*~|' + '0' + '|*~|' + '0|*~||*~||*~||*~|' + 'A*|~*'
		FROM API_CLIENT_MASTER_SYNERGY_DP main,dp_acct_mstr 
		WHERE main.KIT_NO = dpam_bbo_code and dpam_sba_no = @C_BEN_ACCT_NO
			AND main.purpose_code = '18'
			
			print @L_DPPD_DETAILS
			print @L_CRN_NO

		EXEC CITRUS_USR.[pr_ins_upd_dppd] '1', @L_CRN_NO, 'EDT', 'KYC', @L_DPPD_DETAILS, 0, '*|~*', '|*~|', ''
FETCH NEXT
		FROM @C_CLIENT_SUMMARY
		INTO @C_BEN_ACCT_NO
			--  
	END

	CLOSE @C_CLIENT_SUMMARY

	DEALLOCATE @C_CLIENT_SUMMARY
	
	
end

GO
