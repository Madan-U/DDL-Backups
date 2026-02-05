-- Object: VIEW citrus_usr.vw_client_details
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create view [citrus_usr].[vw_client_details]
as
select dpam_sba_no [Name of Client] , dpam_sba_no [Client Id] , citrus_usr.fn_ucc_entp(dpam_crn_no, 'Pan_gir_no','') [Pan No] 
from dp_acct_mstr

GO
