-- Object: FUNCTION citrus_usr.fn_getbank_details
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create function [citrus_usr].[fn_getbank_details](@pa_sba_no varchar(1000))
returns varchar(2000)
as
begin
return (
select citrus_usr.fn_splitval_by(isnull(BANM_NAME,''),'1','-') +'|'
+banm_branch+'|'
+TMPBA_DP_BANK_ADD1+'|'
+TMPBA_DP_BANK_ADD2+'|'
+TMPBA_DP_BANK_ADD3+'|'
+TMPBA_DP_BANK_CITY+'|'
+TMPBA_DP_BANK_STATE+'|'
+TMPBA_DP_BANK_CNTRY +'|'
+TMPBA_DP_BANK_ZIP+'|'
from client_bank_accts , dp_Acct_mstr 
,bank_mstr left outer join 
 bank_addresses_dtls 
on TMPBA_DP_BANK = banm_micr 
and TMPBA_DP_BR = banm_rtgs_cd 
where cliba_clisba_id = dpam_id and cliba_banm_id = banm_id 
and cliba_deleted_ind = 1 
and dpam_deleted_ind = 1 
and banm_deleted_ind = 1 
and dpam_sba_no =@pa_sba_no)
end

GO
