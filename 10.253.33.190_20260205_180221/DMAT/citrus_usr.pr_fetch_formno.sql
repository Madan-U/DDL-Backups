-- Object: PROCEDURE citrus_usr.pr_fetch_formno
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--- N, 
CREATE procedure [citrus_usr].[pr_fetch_formno](@pa_sba_no varchar(1000),@pa_flg char(1))
as
begin
if @pa_flg ='Y'
select dpam_sba_name 
, dpam_sba_no 
, dpam_acct_no 
from dp_acct_mstr 
where  dpam_sba_no = @pa_sba_no 
and dpam_deleted_ind = 1
and dpam_batch_no = 1
if @pa_flg ='N'
select dpam_sba_name 
, dpam_sba_no 
, dpam_acct_no 
from dp_acct_mstr 
where  dpam_sba_no = @pa_sba_no 
and dpam_deleted_ind = 1
---and dpam_batch_no <> 1
and isnull(dpam_batch_no,'0') = '0'


end

GO
