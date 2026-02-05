-- Object: PROCEDURE citrus_usr.pr_client_lettergen
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--exec pr_client_lettergen '12012000','jun 01 2010','jun 30 2011',''

CREATE procedure [citrus_usr].[pr_client_lettergen]
(@pa_dpid varchar(10),
 @pa_from_dt datetime,
 @pa_to_dt datetime,
 @pa_out varchar(100) output
 )
as
begin

DECLARE @l_dpm_id   varchar(20)

SELECT @l_dpm_id  = dpm_id from dp_mstr where dpm_dpid  = @pa_dpid and dpm_deleted_ind  = 1        

select sliim_dpam_acct_no acctno,sliim_slip_no_fr slipfrom,sliim_slip_no_to slipto,
(convert(numeric,sliim_slip_no_to) - convert(numeric,sliim_slip_no_fr)) + 1 booksize,sliim_loose_y_n,sliim_book_name,
DPAM_ID,dpam_sba_name
from slip_issue_mstr,dp_acct_mstr
where sliim_dt between @pa_from_dt and @pa_to_dt
and sliim_dpm_id  = @l_dpm_id   
and DPAM_SBA_NO = SLIIM_DPAM_ACCT_NO
and sliim_deleted_ind = 1
order by sliim_dpam_acct_no

end

GO
