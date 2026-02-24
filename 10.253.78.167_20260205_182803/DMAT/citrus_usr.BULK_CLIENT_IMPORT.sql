-- Object: PROCEDURE citrus_usr.BULK_CLIENT_IMPORT
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--begin transaction
--BULK_CLIENT_IMPORT

--rollback transaction
--alter table CLIENT_MSTR alter column clim_name1 varchar(100)
--alter table CLIENT_MSTR_mak alter column clim_name1 varchar(100)
--alter table CLIm_hst alter column clim_name1 varchar(100)
CREATE PROCEDURE [citrus_usr].[BULK_CLIENT_IMPORT]
AS
BEGIN

 

DROP TABLE #tmp_identity_CLINET

SELECT IDENTITY(INT, 1, 1) ID1
, LTRIM(RTRIM(Ben_Fst_Hld_Name)) Ben_Fst_Hld_Name
,LTRIM(RTRIM(Ben_Short_name))+space(30) Ben_Short_name
,LTRIM(RTRIM(Ben_Acct_No)) Ben_Acct_No
, LTRIM(RTRIM(BEN_STATUS)) BEN_STATUS
,LTRIM(RTRIM(Ben_Type)) Ben_Type
, LTRIM(RTRIM(Ben_sub_Type)) Ben_sub_Type 
,LTRIM(RTRIM(Ben_Acct_Ctgry)) Ben_Acct_Ctgry  
, Date_of_Birth 
,ltrim(rtrim(Fst_Hld_Fth_name)) Fst_Hld_Fth_name
,ltrim(rtrim(Ben_Sec_Hld_Name)) Ben_Sec_Hld_Name
,ltrim(rtrim(Sec_Hld_Fth_Name)) Sec_Hld_Fth_Name
,ltrim(rtrim(Sec_Hld_Fin_dtls)) Sec_Hld_Fin_dtls
,ltrim(rtrim(Ben_Thrd_Hld_Name)) Ben_Thrd_Hld_Name
,ltrim(rtrim(Thrd_Hld_Fth_Name)) Thrd_Hld_Fth_Name
,ltrim(rtrim(Thrd_Hld_Fin_dtls)) Thrd_Hld_Fin_dtls
,nom_gua_ind
,ltrim(rtrim(nom_gua_name)) nom_gua_name

INTO #tmp_identity_CLINET FROM DP_CLIENT_SUMMARY  WHERE ISNULL(LTRIM(RTRIM(BEN_STATUS)),'') <> '10'

 

UPDATE #tmp_identity_CLINET SET Ben_Short_name = ltrim(rtrim(Ben_Short_name)) + '_' + CONVERT(VARCHAR,ID1)







INSERT INTO CLIENT_MSTR
(CLIM_CRN_NO
,CLIM_NAME1
,CLIM_NAME2
,CLIM_NAME3
,CLIM_SHORT_NAME
,CLIM_GENDER
,CLIM_DOB
,CLIM_ENTTM_CD
,CLIM_STAM_CD
,CLIM_CLICM_CD
,CLIM_SBUM_ID
,CLIM_RMKS
,CLIM_CREATED_BY
,CLIM_CREATED_DT
,CLIM_LST_UPD_BY
,CLIM_LST_UPD_DT
,CLIM_DELETED_IND)
SELECT ID1 + 100
,CASE WHEN ISNULL(LTRIM(RTRIM(Ben_Fst_Hld_Name)),'') = '' THEN ISNULL(LTRIM(RTRIM(Ben_Short_name)),'') else ISNULL(LTRIM(RTRIM(Ben_Fst_Hld_Name)),'') END 
,''
,''
,ISNULL(ltrim(rtrim(Ben_Short_name)),'') 
,''
,convert(datetime,date_of_birth,103)
,NULL
,CASE WHEN BEN_STATUS = '01' THEN 'ACTIVE' ELSE BEN_STATUS END
,NULL
,0
,''
,'MIG'
,GETDATE()
,'MIG'
,GETDATE()
,1
FROM #tmp_identity_CLINET



declare @l_dpm_ID numeric
, @l_excsm_id  numeric
select @l_dpm_ID = dpm_ID , @l_excsm_id = default_dp from dp_mstr , exch_seg_mstr where default_dp = excsm_id and  excsm_exch_cd= 'NSDL'


INSERT INTO DP_ACCT_MSTR 
(DPAM_ID
,DPAM_CRN_NO
,DPAM_ACCT_NO
,DPAM_SBA_NAME
,DPAM_SBA_NO
,DPAM_EXCSM_ID
,DPAM_DPM_ID
,DPAM_ENTTM_CD
,DPAM_CLICM_CD
,DPAM_STAM_CD
,DPAM_CREATED_BY
,DPAM_CREATED_DT
,DPAM_LST_UPD_BY
,DPAM_LST_UPD_DT
,DPAM_DELETED_IND
,dpam_subcm_cd
)
SELECT ID1 + 100
, CLIM_CRN_NO
, Ben_Acct_No
, Ben_Fst_Hld_Name
, Ben_Acct_No
, @l_excsm_id
, @l_dpm_ID
, Ben_Acct_Ctgry
, CLICM_CD
,CASE WHEN BEN_STATUS = '01' THEN 'ACTIVE' ELSE BEN_STATUS END
,'MIG'
,GETDATE()
,'MIG'
,GETDATE()
,1
,subcm_cd
FROM #tmp_identity_CLINET
, CLIENT_CTGRY_MSTR
, SUB_CTGRY_MSTR
,client_mstr
WHERE clicm_id = subcm_clicm_id
AND isnull(ltrim(rtrim(Ben_Type)),'')+isnull(ltrim(rtrim(Ben_sub_Type)),'') = subcm_cd
and  clim_short_name = Ben_Short_name



insert into entity_relationship 
(ENTR_CRN_NO
,ENTR_ACCT_NO
,ENTR_SBA
,ENTR_HO
,ENTR_FROM_DT
,ENTR_TO_DT
,ENTR_CREATED_BY
,ENTR_CREATED_DT
,ENTR_LST_UPD_BY
,ENTR_LST_UPD_DT
,ENTR_DELETED_IND
,entr_excpm_id
)select clim_crn_no
,Ben_Acct_No
,Ben_Acct_No
,1
,'01/01/1990'
,'01/01/2900'
,'MIG'
,GETDATE()
,'MIG'
,GETDATE()
,1
,4
FROM #tmp_identity_CLINET
,client_mstr
WHERE  clim_short_name = Ben_Short_name




INSERT INTO DP_HOLDER_DTLS 
(DPHD_DPAM_ID
,DPHD_DPAM_SBA_NO
,DPHD_FH_FTHNAME
,DPHD_SH_FNAME
,DPHD_SH_FTHNAME
,DPHD_SH_PAN_NO
,DPHD_TH_FNAME
,DPHD_TH_FTHNAME
,DPHD_TH_PAN_NO
,dphd_nomgau_fname
,DPHD_CREATED_BY
,DPHD_CREATED_DT
,DPHD_LST_UPD_BY
,DPHD_LST_UPD_DT
,DPHD_DELETED_IND
)
SELECT DPAM_ID
,Ben_Acct_No
,Fst_Hld_Fth_name
,Ben_Sec_Hld_Name
,Sec_Hld_Fth_Name
,Sec_Hld_Fin_dtls
,Ben_Thrd_Hld_Name
,Thrd_Hld_Fth_Name
,Thrd_Hld_Fin_dtls
,CASE WHEN nom_gua_ind = 'N' THEN  nom_gua_name ELSE '' END
,'MIG'
,GETDATE()
,'MIG'
,GETDATE()
,1
FROM #tmp_identity_CLINET
, DP_ACCT_MSTR
, CLIENT_MSTR
WHERE DPAM_CRN_NO = CLIM_CRN_NO 
AND   CLIM_SHORT_NAME = Ben_Short_name



END

GO
