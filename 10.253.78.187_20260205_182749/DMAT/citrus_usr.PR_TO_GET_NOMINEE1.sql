-- Object: PROCEDURE citrus_usr.PR_TO_GET_NOMINEE1
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE  PROCEDURE [citrus_usr].[PR_TO_GET_NOMINEE1]
(
@PA_CRN_NO NUMERIC,
@PA_NOM_SRNO NUMERIC,
@PA_ACTION VARCHAR(50),
@PA_OUT VARCHAR(8000) OUTPUT
)
AS
BEGIN

DECLARE @@PA_DPAM_ID NUMERIC
--SELECT @@PA_DPAM_ID = DPAM_ID FROM DP_ACCT_MSTR_mak WHERE DPAM_CRN_NO = @PA_CRN_NO --AND DPAM_DELETED_IND = '1' AND DPAM_STAM_CD = 'ACTIVE'

set @@PA_DPAM_ID = 0
  SELECT @@PA_DPAM_ID = DPAM_ID  FROM DP_ACCT_MSTR_mak WHERE DPAM_CRN_NO = @PA_CRN_NO --AND DPAM_DELETED_IND = '1' --AND DPAM_STAM_CD = 'ACTIVE'
	if @@PA_DPAM_ID = 0
	begin 
		
	SELECT @@PA_DPAM_ID = DPAM_ID FROM DP_ACCT_MSTR WHERE DPAM_CRN_NO = @PA_CRN_NO --AND DPAM_DELETED_IND = '1' --AND DPAM_STAM_CD = 'ACTIVE'
	end
	PRINT @@PA_DPAM_ID
if @PA_ACTION = 'BY_NOM_SIR_NO'
begin
	IF @PA_NOM_SRNO = '1'
	BEGIN
		PRINT 'SRNO1'

		--IF EXISTS(SELECT 1 FROM Nominee_Multi WHERE NOM_ID = @PA_NOM_SRNO AND Nom_dpam_id = @@PA_DPAM_ID  AND Nom_DELETED_IND = '0')
		--BEGIN
			SELECT 
			nom_id,
			nom_srno,
			nom_fname,
			nom_mname,
			nom_tname,
			replace(convert(varchar, nom_dob,103),'01/01/1900','') nom_dob,
			nom_adr1,
			nom_adr2,
			nom_adr3,
			nom_city,
			nom_state,
			nom_country,
			nom_zip,
			nom_pan,
			nom_relation,
			nom_percentage,
			--replace(nom_percentage,.00,'')nom_percentage,
			nom_res_sec_flag
			,isnull(nom_Uid,'')nom_Uid
					,isnull(NOM_TRXPRINTFLAG,'') NOM_TRXPRINTFLAG
		,isnull(NOM_DRIVINGLIC,'')NOM_DRIVINGLIC
		,isnull(NOM_PASSUIC,'')NOM_PASSUIC
		,isnull(NOM_ISDCODE,'')NOM_ISDCODE
		,isnull(nom_phone1 ,'')nom_phone1
		, isnull(nom_email ,'')nom_email
			FROM Nominee_Multi 
			WHERE Nom_DELETED_IND = '1'
			and Nom_dpam_id not in (select Nom_dpam_id FROM Nominee_Multi_mak WHERE Nom_DELETED_IND in(0,4,8) and nom_srno = @PA_NOM_SRNO AND Nom_dpam_id = @@PA_DPAM_ID)
			AND nom_srno = @PA_NOM_SRNO
			and Nom_dpam_id = @@PA_DPAM_ID

			union

			SELECT
			nom_id, 
			nom_srno,
			nom_fname,
			nom_mname,
			nom_tname,
			replace(convert(varchar, nom_dob,103),'01/01/1900','') nom_dob,
			nom_adr1,
			nom_adr2,
			nom_adr3,
			nom_city,
			nom_state,
			nom_country,
			nom_zip,
			nom_pan,
			nom_relation,
			nom_percentage,
			--replace(nom_percentage,.00,'')nom_percentage,
			nom_res_sec_flag
			,isnull(nom_Uid,'')nom_Uid
					,isnull(NOM_TRXPRINTFLAG,'') NOM_TRXPRINTFLAG
		,isnull(NOM_DRIVINGLIC,'')NOM_DRIVINGLIC
		,isnull(NOM_PASSUIC,'')NOM_PASSUIC
		,isnull(NOM_ISDCODE,'')NOM_ISDCODE
		,isnull(nom_phone1 ,'')nom_phone1
		, isnull(nom_email ,'')nom_email
			FROM Nominee_Multi_mak
			WHERE Nom_DELETED_IND in (0,4,8) 
			AND nom_srno = @PA_NOM_SRNO
			and Nom_dpam_id = @@PA_DPAM_ID

			union 

			SELECT top 1
			0 nom_id,
			1 nom_srno,
			DPHD_NOM_FNAME nom_fname
			,DPHD_NOM_MNAME nom_mname
			,DPHD_NOM_LNAME nom_tname
			,replace(convert(varchar, DPHD_NOM_DOB,103),'01/01/1900','') nom_dob
			,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(DPAM_ID ,'NOMINEE_ADR1'),1) nom_adr1
			,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(DPAM_ID ,'NOMINEE_ADR1'),2) nom_adr2 
			,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(DPAM_ID ,'NOMINEE_ADR1'),3) nom_adr3
			,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(DPAM_ID ,'NOMINEE_ADR1'),4) nom_city
			,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(DPAM_ID ,'NOMINEE_ADR1'),5) nom_state
			,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(DPAM_ID ,'NOMINEE_ADR1'),6) nom_country
			,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.fn_acct_addr_value(DPAM_ID ,'NOMINEE_ADR1'),7) nom_zip
			,DPHD_NOM_PAN_NO nom_pan
			,'' nom_relation
			,'0' nom_percentage
			,'' nom_res_sec_flag
			, '' nom_Uid
					,'' NOM_TRXPRINTFLAG
		,'' NOM_DRIVINGLIC
		,'' NOM_PASSUIC
		,'' NOM_ISDCODE
		,'' nom_phone1 
		,''  nom_email 
			FROM DP_HOLDER_DTLS,DP_ACCT_MSTR 
			WHERE DPHD_DPAM_ID = DPAM_ID--DPHD_DPAM_SBA_NO=DPAM_SBA_NO 
			AND DPAM_DELETED_IND=1 
			AND DPHD_DELETED_IND=1 
			AND DPAM_CRN_NO=@PA_CRN_NO
			and DPHD_DPAM_ID not in (select Nom_dpam_id from Nominee_Multi_mak where Nom_DELETED_IND in (0,4,8) and nom_srno = @PA_NOM_SRNO and Nom_dpam_id = @@PA_DPAM_ID)
			and ISNULL(DPHD_NOM_FNAME,'') <> ''
			and DPHD_DPAM_ID not in (select Nom_dpam_id from Nominee_Multi where Nom_DELETED_IND = 1 and nom_srno = @PA_NOM_SRNO and Nom_dpam_id = @@PA_DPAM_ID)
			--AND DPHD_DPAM_ID NOT IN (SELECT DPHD_DPAM_ID FROM DP_HOLDER_DTLS_MAK WHERE DPHD_DELETED_IND = '1' AND DPHD_DPAM_ID= @@PA_DPAM_ID )	
			
			union 
			SELECT top 1
			0 nom_id,
			1 nom_srno,
			DPHD_NOM_FNAME nom_fname
			,DPHD_NOM_MNAME nom_mname
			,DPHD_NOM_LNAME nom_tname
			,replace(convert(varchar, DPHD_NOM_DOB,103),'01/01/1900','') nom_dob
			--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),1) nom_adr1
			--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),2) nom_adr2 
			--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),3) nom_adr3
			--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),4) nom_city
			--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),5) nom_state
			--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),6) nom_country
			--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),7) nom_zip
			,isnull(ADR_1,'') 
			,isnull(ADR_2,'') 
			,isnull(ADR_3,'') 
			,isnull(ADR_CITY,'') 
			,isnull(ADR_STATE,'') 
			,isnull(ADR_COUNTRY,'') 
			,isnull(ADR_ZIP,'') 
			,DPHD_NOM_PAN_NO nom_pan
			,'' nom_relation
			,'0' nom_percentage
			,'' nom_res_sec_flag
			, '' nom_Uid
					,'' NOM_TRXPRINTFLAG
		,'' NOM_DRIVINGLIC
		,'' NOM_PASSUIC
		,'' NOM_ISDCODE
		,'' nom_phone1 
		,'' nom_email  
			FROM DP_HOLDER_DTLS_mak,DP_ACCT_MSTR_mak left outer join ADDR_ACCT_MAK on dpam_id = ADR_CLISBA_ID and ADR_CONCM_CD ='NOMINEE_ADR1'
			WHERE DPHD_DPAM_ID = DPAM_ID--DPHD_DPAM_SBA_NO=DPAM_SBA_NO 
			AND DPAM_DELETED_INd in(0,4,8)  
			AND DPHD_DELETED_IND  in(0,4,8)  
			AND DPAM_CRN_NO=@PA_CRN_NO
			and DPHD_DPAM_ID not in (select Nom_dpam_id from Nominee_Multi_mak where Nom_DELETED_IND in (0,4,8) and nom_srno = @PA_NOM_SRNO and Nom_dpam_id = @@PA_DPAM_ID)
			and DPHD_DPAM_ID not in (select Nom_dpam_id from Nominee_Multi where Nom_DELETED_IND = 1 and nom_srno = @PA_NOM_SRNO and Nom_dpam_id = @@PA_DPAM_ID)
			union
			SELECT top 1
			0 nom_id,
			1 nom_srno,
			DPHD_NOM_FNAME nom_fname
			,DPHD_NOM_MNAME nom_mname
			,DPHD_NOM_LNAME nom_tname
			,replace(convert(varchar, DPHD_NOM_DOB,103),'01/01/1900','') nom_dob
			--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),1) nom_adr1
			--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),2) nom_adr2 
			--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),3) nom_adr3
			--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),4) nom_city
			--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),5) nom_state
			--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),6) nom_country
			--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),7) nom_zip
			,isnull(ADR_1,'') 
			,isnull(ADR_2,'') 
			,isnull(ADR_3,'') 
			,isnull(ADR_CITY,'') 
			,isnull(ADR_STATE,'') 
			,isnull(ADR_COUNTRY,'') 
			,isnull(ADR_ZIP,'') 
			,DPHD_NOM_PAN_NO nom_pan
			,'' nom_relation
			,'0' nom_percentage
			,'' nom_res_sec_flag
			, '' nom_Uid
		,'' NOM_TRXPRINTFLAG
		,'' NOM_DRIVINGLIC
		,'' NOM_PASSUIC
		,'' NOM_ISDCODE
		, '' nom_phone1 
		, '' nom_email 
			FROM DP_HOLDER_DTLS_mak,DP_ACCT_MSTR left outer join ADDR_ACCT_MAK on dpam_id = ADR_CLISBA_ID and ADR_CONCM_CD ='NOMINEE_ADR1'
			WHERE DPHD_DPAM_ID = DPAM_ID--DPHD_DPAM_SBA_NO=DPAM_SBA_NO 
			AND DPAM_DELETED_INd in(1)  
			AND DPHD_DELETED_IND  in(0,4,8)  
			AND DPAM_CRN_NO=@PA_CRN_NO
			and DPHD_DPAM_ID not in (select Nom_dpam_id from Nominee_Multi_mak where Nom_DELETED_IND in (0,4,8) and nom_srno = @PA_NOM_SRNO and Nom_dpam_id = @@PA_DPAM_ID)
			and DPHD_DPAM_ID not in (select Nom_dpam_id from Nominee_Multi where Nom_DELETED_IND = 1 and nom_srno = @PA_NOM_SRNO and Nom_dpam_id = @@PA_DPAM_ID)
		END
	--	ELSE
	--	BEGIN
	--	PRINT '1122'
	--		SELECT top 1
	--		1 nom_srno,
	--		DPHD_NOM_FNAME nom_fname
	--		,DPHD_NOM_MNAME nom_mname
	--		,DPHD_NOM_LNAME nom_tname
	--		,replace(convert(varchar, DPHD_NOM_DOB,103),'01/01/1900','') nom_dob
	--		,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),1) nom_adr1
	--		,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),2) nom_adr2 
	--		,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),3) nom_adr3
	--		,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),4) nom_city
	--		,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),5) nom_state
	--		,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),6) nom_country
	--		,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),7) nom_zip
	--		,DPHD_NOM_PAN_NO nom_pan
	--		,'' nom_relation
	--		,'' nom_percentage
	--		,'' nom_res_sec_flag
	--		FROM DP_HOLDER_DTLS,DP_ACCT_MSTR 
	--		WHERE DPHD_DPAM_SBA_NO=DPAM_SBA_NO 
	--		AND DPAM_DELETED_IND=1 
	--		AND DPHD_DELETED_IND=1 
	--		AND DPAM_CRN_NO=@PA_CRN_NO
	--		order by DPHD_LST_UPD_DT desc
			
	--END
	IF @PA_NOM_SRNO = '4'
	BEGIN
		PRINT '04'

		--IF EXISTS(SELECT 1 FROM Nominee_Multi WHERE NOM_ID = @PA_NOM_SRNO AND Nom_dpam_id = @@PA_DPAM_ID  AND Nom_DELETED_IND = '0')
		--BEGIN
			SELECT 
			nom_id,
			nom_srno,
			nom_fname,
			nom_mname,
			nom_tname,
			replace(convert(varchar, nom_dob,103),'01/01/1900','') nom_dob,
			nom_adr1,
			nom_adr2,
			nom_adr3,
			nom_city,
			nom_state,
			nom_country,
			nom_zip,
			nom_pan,
			nom_relation,
			nom_percentage,
			--replace(nom_percentage,.00,'')nom_percentage,
			nom_res_sec_flag
			,isnull(nom_Uid,'')nom_Uid
					,isnull(NOM_TRXPRINTFLAG,'') NOM_TRXPRINTFLAG
		,isnull(NOM_DRIVINGLIC,'')NOM_DRIVINGLIC
		,isnull(NOM_PASSUIC,'')NOM_PASSUIC
		,isnull(NOM_ISDCODE,'')NOM_ISDCODE
		,isnull(nom_phone1 ,'')nom_phone1
		, isnull(nom_email ,'')nom_email
			FROM Nominee_Multi 
			WHERE Nom_DELETED_IND = '1'
			and Nom_dpam_id not in (select Nom_dpam_id FROM Nominee_Multi_mak WHERE Nom_DELETED_IND in(0,4,8) and nom_srno = @PA_NOM_SRNO AND Nom_dpam_id = @@PA_DPAM_ID)
			AND nom_srno = @PA_NOM_SRNO
			and Nom_dpam_id = @@PA_DPAM_ID

			union

			SELECT
			nom_id, 
			nom_srno,
			nom_fname,
			nom_mname,
			nom_tname,
			replace(convert(varchar, nom_dob,103),'01/01/1900','') nom_dob,
			nom_adr1,
			nom_adr2,
			nom_adr3,
			nom_city,
			nom_state,
			nom_country,
			nom_zip,
			nom_pan,
			nom_relation,
			nom_percentage,
			--replace(nom_percentage,.00,'')nom_percentage,
			nom_res_sec_flag
			,isnull(nom_Uid,'')nom_Uid
					,isnull(NOM_TRXPRINTFLAG,'') NOM_TRXPRINTFLAG
		,isnull(NOM_DRIVINGLIC,'')NOM_DRIVINGLIC
		,isnull(NOM_PASSUIC,'')NOM_PASSUIC
		,isnull(NOM_ISDCODE,'')NOM_ISDCODE
		,isnull(nom_phone1 ,'')nom_phone1
		, isnull(nom_email ,'')nom_email
			FROM Nominee_Multi_mak
			WHERE Nom_DELETED_IND in (0,4,8) 
			AND nom_srno = @PA_NOM_SRNO
			and Nom_dpam_id = @@PA_DPAM_ID

			union 

				SELECT top 1
				0 nom_id,
				1 nom_srno,
				dphd_nomgau_fname nom_fname
				,dphd_nomgau_mname nom_mname
				,DPHD_NOMgau_LNAME nom_tname
				,replace(convert(varchar, dphd_nomgau_dob,103),'01/01/1900','') nom_dob
				,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOM_GUARDIAN_ADDR'),1) nom_adr1
				,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOM_GUARDIAN_ADDR'),2) nom_adr2 
				,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOM_GUARDIAN_ADDR'),3) nom_adr3
				,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOM_GUARDIAN_ADDR'),4) nom_city
				,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOM_GUARDIAN_ADDR'),5) nom_state
				,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOM_GUARDIAN_ADDR'),6) nom_country
				,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOM_GUARDIAN_ADDR'),7) nom_zip
				,dphd_nomgau_pan_no nom_pan
				,'' nom_relation
				,'0' nom_percentage
				,'' nom_res_sec_flag
				, ''  nom_Uid
						,'' NOM_TRXPRINTFLAG
		,'' NOM_DRIVINGLIC
		,'' NOM_PASSUIC
		,'' NOM_ISDCODE
		,'' nom_phone1 
		,'' nom_email 
				FROM DP_HOLDER_DTLS,DP_ACCT_MSTR 
				WHERE DPHD_DPAM_ID = DPAM_ID--DPHD_DPAM_SBA_NO=DPAM_SBA_NO 
				AND DPAM_DELETED_IND=1 
				AND DPHD_DELETED_IND=1 
				AND DPAM_CRN_NO=@PA_CRN_NO
				and DPHD_DPAM_ID not in (select Nom_dpam_id from Nominee_Multi_mak where Nom_DELETED_IND in (0,4,8) and nom_srno = @PA_NOM_SRNO and Nom_dpam_id = @@PA_DPAM_ID)
				and DPHD_DPAM_ID not in (select Nom_dpam_id from Nominee_Multi where Nom_DELETED_IND = 1 and nom_srno = @PA_NOM_SRNO and Nom_dpam_id = @@PA_DPAM_ID)
				AND ISNULL(dphd_nomgau_fname,'')<>''
				union 
				SELECT top 1
				0 nom_id,
				1 nom_srno,
				dphd_nomgau_fname nom_fname
				,dphd_nomgau_mname nom_mname
				,dphd_nomgau_lname nom_tname
				,replace(convert(varchar, dphd_nomgau_dob,103),'01/01/1900','') nom_dob
				--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),1) nom_adr1
				--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),2) nom_adr2 
				--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),3) nom_adr3
				--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),4) nom_city
				--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),5) nom_state
				--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),6) nom_country
				--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),7) nom_zip
				,isnull(ADR_1,'') 
				,isnull(ADR_2,'') 
				,isnull(ADR_3,'') 
				,isnull(ADR_CITY,'') 
				,isnull(ADR_STATE,'') 
				,isnull(ADR_COUNTRY,'') 
				,isnull(ADR_ZIP,'') 
				,dphd_nomgau_pan_no nom_pan
				,'' nom_relation
				,'0' nom_percentage
				,'' nom_res_sec_flag
				,''  nom_Uid
						,'' NOM_TRXPRINTFLAG
		,'' NOM_DRIVINGLIC
		,'' NOM_PASSUIC
		,'' NOM_ISDCODE
		,'' nom_phone1 
		,'' nom_email 
				FROM DP_HOLDER_DTLS_mak,DP_ACCT_MSTR_mak left outer join ADDR_ACCT_MAK on dpam_id = ADR_CLISBA_ID and ADR_CONCM_CD ='NOM_GUARDIAN_ADDR'
				WHERE DPHD_DPAM_ID = DPAM_ID--DPHD_DPAM_SBA_NO=DPAM_SBA_NO 
				AND DPAM_DELETED_INd in (0,4,8)  
				AND DPHD_DELETED_IND  in(0,4,8)  
				AND DPAM_CRN_NO=@PA_CRN_NO
				and DPHD_DPAM_ID not in (select Nom_dpam_id from Nominee_Multi_mak where Nom_DELETED_IND in (0,4,8) and nom_srno = @PA_NOM_SRNO and Nom_dpam_id = @@PA_DPAM_ID)
				and DPHD_DPAM_ID not in (select Nom_dpam_id from Nominee_Multi where Nom_DELETED_IND = 1 and nom_srno = @PA_NOM_SRNO and Nom_dpam_id = @@PA_DPAM_ID)
				AND ISNULL(dphd_nomgau_fname,'')<>''
				union 
				SELECT top 1
				0 nom_id,
				1 nom_srno,
				dphd_nomgau_fname nom_fname
				,dphd_nomgau_mname nom_mname
				,dphd_nomgau_lname nom_tname
				,replace(convert(varchar, dphd_nomgau_dob,103),'01/01/1900','') nom_dob
				--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),1) nom_adr1
				--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),2) nom_adr2 
				--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),3) nom_adr3
				--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),4) nom_city
				--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),5) nom_state
				--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),6) nom_country
				--,CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'NOMINEE_ADR1'),7) nom_zip
				,isnull(ADR_1,'') 
				,isnull(ADR_2,'') 
				,isnull(ADR_3,'') 
				,isnull(ADR_CITY,'') 
				,isnull(ADR_STATE,'') 
				,isnull(ADR_COUNTRY,'') 
				,isnull(ADR_ZIP,'') 
				,dphd_nomgau_pan_no nom_pan
				,'' nom_relation
				,'0' nom_percentage
				,'' nom_res_sec_flag
				,'' nom_Uid
						,'' NOM_TRXPRINTFLAG
		,'' NOM_DRIVINGLIC
		,'' NOM_PASSUIC
		,'' NOM_ISDCODE
		,'' nom_phone1 
		,'' nom_email 
				FROM DP_HOLDER_DTLS_mak,DP_ACCT_MSTR left outer join ADDR_ACCT_MAK on dpam_id = ADR_CLISBA_ID and ADR_CONCM_CD ='NOM_GUARDIAN_ADDR'
				WHERE DPHD_DPAM_ID = DPAM_ID--DPHD_DPAM_SBA_NO=DPAM_SBA_NO 
				AND DPAM_DELETED_INd = '1'  
				AND DPHD_DELETED_IND  in(0,4,8)  
				AND DPAM_CRN_NO=@PA_CRN_NO
				and DPHD_DPAM_ID not in (select Nom_dpam_id from Nominee_Multi_mak where Nom_DELETED_IND in (0,4,8) and nom_srno = @PA_NOM_SRNO and Nom_dpam_id = @@PA_DPAM_ID)
				and DPHD_DPAM_ID not in (select Nom_dpam_id from Nominee_Multi where Nom_DELETED_IND = 1 and nom_srno = @PA_NOM_SRNO and Nom_dpam_id = @@PA_DPAM_ID)
				AND ISNULL(dphd_nomgau_fname,'')<>''
	END


	IF @PA_NOM_SRNO = '2' OR @PA_NOM_SRNO = '3'  OR @PA_NOM_SRNO = '5' OR @PA_NOM_SRNO = '6' 
	BEGIN
	PRINT 'PPPPP'
	PRINT @@PA_DPAM_ID
		SELECT 
			nom_id,
			nom_srno,
			nom_fname,
			nom_mname,
			nom_tname,
			replace(convert(varchar, nom_dob,103),'01/01/1900','') nom_dob,
			nom_adr1,
			nom_adr2,
			nom_adr3,
			nom_city,
			nom_state,
			nom_country,
			nom_zip,
			nom_pan,
			nom_relation,
			nom_percentage,
			--replace(nom_percentage,.00,'')nom_percentage,
			nom_res_sec_flag
			,isnull(nom_Uid,'')nom_Uid
					,isnull(NOM_TRXPRINTFLAG,'') NOM_TRXPRINTFLAG
		,isnull(NOM_DRIVINGLIC,'')NOM_DRIVINGLIC
		,isnull(NOM_PASSUIC,'')NOM_PASSUIC
		,isnull(NOM_ISDCODE,'')NOM_ISDCODE
		,isnull(nom_phone1 ,'')nom_phone1
		, isnull(nom_email ,'')nom_email
			FROM Nominee_Multi 
			WHERE Nom_DELETED_IND = '1'
			and Nom_dpam_id not in (select Nom_dpam_id FROM Nominee_Multi_mak WHERE Nom_DELETED_IND in(0,4,8) and nom_srno = @PA_NOM_SRNO AND Nom_dpam_id = @@PA_DPAM_ID)
			AND nom_srno = @PA_NOM_SRNO
			and Nom_dpam_id = @@PA_DPAM_ID

			union
		SELECT 
			nom_id,
			nom_srno,
			nom_fname,
			nom_mname,
			nom_tname,
			replace(convert(varchar, nom_dob,103),'01/01/1900','') nom_dob,
			nom_adr1,
			nom_adr2,
			nom_adr3,
			nom_city,
			nom_state,
			nom_country,
			nom_zip,
			nom_pan,
			nom_relation,
			nom_percentage,
			--replace(nom_percentage,.00,'')nom_percentage,
			nom_res_sec_flag
			,isnull(nom_Uid,'')nom_Uid
					,isnull(NOM_TRXPRINTFLAG,'') NOM_TRXPRINTFLAG
		,isnull(NOM_DRIVINGLIC,'')NOM_DRIVINGLIC
		,isnull(NOM_PASSUIC,'')NOM_PASSUIC
		,isnull(NOM_ISDCODE,'')NOM_ISDCODE
		,isnull(nom_phone1 ,'')nom_phone1
		, isnull(nom_email ,'')nom_email
			FROM Nominee_Multi_MAK
			WHERE  Nom_DELETED_IND in (0,4,8)  
			AND nom_srno = @PA_NOM_SRNO
			and Nom_dpam_id = @@PA_DPAM_ID
	END
	end
	if @PA_ACTION = 'BY_CRN_NO'
	begin
		
		SELECT 
			nom_id,
			nom_srno,
			nom_fname,
			nom_mname,
			nom_tname,
			replace(convert(varchar, nom_dob,103),'01/01/1900','') nom_dob,
			nom_adr1,
			nom_adr2,
			nom_adr3,
			nom_city,
			nom_state,
			nom_country,
			nom_zip,
			nom_pan,
			nom_relation,
			nom_percentage,
			--replace(nom_percentage,.00,'')nom_percentage,
			nom_res_sec_flag
			,isnull(nom_Uid,'')nom_Uid
				,isnull(NOM_TRXPRINTFLAG,'') NOM_TRXPRINTFLAG
		,isnull(NOM_DRIVINGLIC,'')NOM_DRIVINGLIC
		,isnull(NOM_PASSUIC,'')NOM_PASSUIC
		,isnull(NOM_ISDCODE,'')NOM_ISDCODE
		,isnull(nom_phone1 ,'')nom_phone1
		, isnull(nom_email ,'')nom_email
			FROM Nominee_Multi 
			WHERE Nom_DELETED_IND= '1' --not in (select Nom_DELETED_IND FROM Nominee_Multi_mak	WHERE Nom_DELETED_IND = '1' and NOM_ID = @PA_NOM_SRNO AND Nom_dpam_id = @@PA_DPAM_ID)
			--AND nom_srno = @PA_NOM_SRNO
			and Nom_dpam_id = @@PA_DPAM_ID

			union

			SELECT
			nom_id, 
			nom_srno,
			nom_fname,
			nom_mname,
			nom_tname,
			replace(convert(varchar, nom_dob,103),'01/01/1900','') nom_dob,
			nom_adr1,
			nom_adr2,
			nom_adr3,
			nom_city,
			nom_state,
			nom_country,
			nom_zip,
			nom_pan,
			nom_relation,
			nom_percentage,
			--replace(nom_percentage,.00,'')nom_percentage,
			nom_res_sec_flag
			,isnull(nom_Uid,'')nom_Uid
					,isnull(NOM_TRXPRINTFLAG,'') NOM_TRXPRINTFLAG
		,isnull(NOM_DRIVINGLIC,'')NOM_DRIVINGLIC
		,isnull(NOM_PASSUIC,'')NOM_PASSUIC
		,isnull(NOM_ISDCODE,'')NOM_ISDCODE
		,isnull(nom_phone1 ,'')nom_phone1
		, isnull(nom_email ,'')nom_email
			FROM Nominee_Multi_mak
			WHERE Nom_DELETED_IND in (0,4,8) 
			AND NOM_DPAM_ID NOT IN (SELECT NOM_DPAM_ID FROM NOMINEE_MULTI WHERE NOM_DELETED_IND = '1')
			--AND nom_srno = @PA_NOM_SRNO
			and Nom_dpam_id = @@PA_DPAM_ID
			order by nom_srno
			
	end

END

GO
