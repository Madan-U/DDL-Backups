-- Object: VIEW citrus_usr.security
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE view [citrus_usr].[security]

as

select 
ISIN_COMP_NAME sc_company_name
,ISIN_CD sc_isincode
,ISIN_NAME sc_isinname
,CLOPM_CDSL_RT sc_rate ,isnull(ISIN_SECURITY_TYPE_DESCRIPTION,'') sc_security_type ,
CLOPM_DT as Closing_Date
from closing_price_mstr_cdsl,isin_mstr
where clopm_isin_cd=isin_cd

GO
