-- Object: PROCEDURE citrus_usr.bankdetails
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE proc bankdetails(@pa_sba_no varchar(100))
as
begin 
select dpam_sba_no , banm_name , banm_rtgs_cd, banm_micr , banm_branch , cliba_ac_no , CLIBA_AC_TYPE
,case when CLIBA_FLG in (1,3) then 'Y' else 'N' end defflag
from dp_acct_mstr , client_bank_accts 
, BANK_MSTR 
,dps8_pc1 
where DPAM_ID = cliba_clisba_id 
and banm_id = cliba_banm_id 
and boid = DPAM_SBA_NO 
and DPAM_DELETED_IND = 1 
and BANM_DELETED_IND = 1 
and DPAM_DELETED_IND = 1 
and DPAM_SBA_NO = @pa_sba_no 

end

GO
