-- Object: PROCEDURE citrus_usr.TOGETSPARK_PARTYCODE
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------




CREATE PROCEDURE [citrus_usr].[TOGETSPARK_PARTYCODE]
(
@PA_SBA_NO VARCHAR(16),
@PA_OUTPUT VARCHAR(800) OUTPUT
)
AS 
BEGIN 
TRUNCATE TABLE TMP_GET_SPARKPARTYCODE
INSERT INTO TMP_GET_SPARKPARTYCODE 

SELECT LTRIM(RTRIM(isnull(ACCP_VALUE,'0'))) SPARK_PARTY_CODE,DPAM_SBA_NO 
FROM dp_acct_mstr 
left outer join ACCOUNT_PROPERTIES
on accp_clisba_id = dpam_id 
and accp_deleted_ind=1 
and ACCP_ACCPM_PROP_CD='BBO_CODE'
where   dpam_deleted_ind=1 

/*SELECT LTRIM(RTRIM(isnull(ENTP_VALUE,'0'))) SPARK_PARTY_CODE,DPAM_SBA_NO 
FROM dp_acct_mstr left outer join ENTITY_PROPERTIES
on ENTP_ENT_ID = dpam_crn_no and entp_deleted_ind=1 
and ENTP_ENTPM_CD='BBO_CODE'
where   dpam_deleted_ind=1 */


--SELECT LTRIM(RTRIM(SPARK_PARTY_CODE)) SPARK_PARTY_CODE,DEMAT_ID FROM TMP_GET_SPARKPARTYCODE WHERE DEMAT_ID LIKE @PA_SBA_NO + '%'    
END

GO
