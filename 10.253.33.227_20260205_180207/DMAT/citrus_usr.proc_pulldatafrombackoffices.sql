-- Object: VIEW citrus_usr.proc_pulldatafrombackoffices
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create view [citrus_usr].[proc_pulldatafrombackoffices]
as
select dpam_sba_no cb_cmcd,
ISNULL(CITRUS_USR.FN_UCC_ENTP(DPAM_CRN_NO,'PAN_GIR_NO',''),'') cb_panno,
clim_gender cb_sexcode,
CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'COR_ADR1'),4) cb_city,
CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'COR_ADR1'),5) cb_state,
CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'COR_ADR1'),7) cb_pin,
CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'COR_ADR1'),6) cb_country,
--dpam_sba_no cb_cmcd,
CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'COR_ADR1'),1) cb_add1,
ISNULL(CITRUS_USR.FN_CONC_VALUE(DPAM_CRN_NO,'RES_PH1'),'') cb_tele1,
CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'COR_ADR1'),2) cb_add2,
CITRUS_USR.FN_SPLITVAL(CITRUS_USR.FN_ADDR_VALUE(DPAM_CRN_NO,'COR_ADR1'),3) cb_add3 
from dp_acct_mstr,client_mstr where clim_crn_no=dpam_crn_no

GO
