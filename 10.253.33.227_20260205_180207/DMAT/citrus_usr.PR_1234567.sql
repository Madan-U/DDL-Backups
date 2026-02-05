-- Object: PROCEDURE citrus_usr.PR_1234567
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_1234567](@PA_EXCSM_ID NUMERIC ,@PA_FROM_DT DATETIME, @PA_TO_DT DATETIME ,@PA_OUT VARCHAR(8000) OUT)
AS
BEGIN 


SET DATEFORMAT DMY 

DECLARE @L_DPM_ID NUMERIC 

SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DPM_EXCSM_ID = @PA_EXCSM_ID AND DEFAULT_DP = DPM_EXCSM_ID AND DPM_DELETED_IND = 1 


select convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd into #account_properties from account_properties 
where accp_accpm_prop_cd = 'BILL_START_DT' 

select COUNT(ENTR_SBA), ENTM_SHORT_NAME  
from DP_ACCT_MSTR , entity_relationship , ENTITY_MSTR , #account_properties
WHERE DPAM_SBA_NO = ENTR_SBA AND ACCP_CLISBA_ID = DPAM_ID 
AND ENTR_DUMMY4 = ENTM_ID 
AND ENTM_ENTTM_CD = 'EMP'
AND ENTR_TO_DT >= 'JAN 01 2099'
AND DPAM_DPM_ID = @L_DPM_ID 
AND ACCP_VALUE BETWEEN @PA_FROM_DT AND @PA_TO_DT
AND ENTR_DELETED_IND = 1
AND ENTM_DELETED_IND = 1 
GROUP BY ENTM_SHORT_NAME



END

GO
