-- Object: VIEW citrus_usr.EMAIL_API
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create view EMAIL_API
as
Select distinct DPAM_BBO_CODE,ACCP_VALUE from dp_acct_mstr ,ACCOUNT_PROPERTIES where ACCP_CLISBA_ID=DPAM_ID 
and ACCP_DELETED_IND=1 and DPAM_DELETED_IND=1
and ACCP_ACCPM_PROP_CD='ECN_FLAG'

GO
