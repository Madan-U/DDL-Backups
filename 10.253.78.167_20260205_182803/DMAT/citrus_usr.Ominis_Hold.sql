-- Object: VIEW citrus_usr.Ominis_Hold
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


Create view Ominis_Hold 
as
select NISE_PARTY_CODE as AccountId
,hld_isin_code ISINCode
,HLD_AC_POS as Holdings_Qty
,'1' ISCollateral
,'0' EvaluationMethod
,HLD_AC_POS as CollateralQty
,'100' as Haircut
from HoldingData t with(nolock),tbl_client_master m with(nolock)
where hld_ac_code =client_code
and HLD_AC_TYPE ='11'

GO
