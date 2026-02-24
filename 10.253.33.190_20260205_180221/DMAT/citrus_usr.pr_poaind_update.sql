-- Object: PROCEDURE citrus_usr.pr_poaind_update
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------





CREATE proc citrus_usr.pr_poaind_update
as
begin 

update dpam set DPAM_STAM_CD = CMIND_IND from dp_acct_mstr dpam , CM_IND_POA_MASTER where CMIND_MASTERPOAID = dpam_sba_no 
and dpam_sba_no like '22%'


update poam set poam_trading_id = CMIND_IND from poa_mstr poam , CM_IND_POA_MASTER where CMIND_MASTERPOAID = poam_master_id 
and poam_master_id like '22%'

end

GO
