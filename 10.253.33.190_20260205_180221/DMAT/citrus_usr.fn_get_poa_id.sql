-- Object: FUNCTION citrus_usr.fn_get_poa_id
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------



create  function [citrus_usr].[fn_get_poa_id](@pa_slip_no varchar(25))  
returns varchar(16)  
as  
begin   
  
declare @l_poa_master varchar(16)  
--set @pa_slip_no = ''  
set @l_poa_master = ''  
select @l_poa_master  = SLIIM_DPAM_ACCT_NO  
from slip_issue_mstr_poa  
where isnumeric(replace(@pa_slip_no,ltrim (rtrim(SLIIM_SERIES_TYPE )) ,'') )= 1   
and convert(numeric(18,0),(replace(@pa_slip_no,ltrim(rtrim(SLIIM_SERIES_TYPE )) ,''))) between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO   
and sliim_deleted_ind = 1   
and SLIIM_DPAM_ACCT_NO like '2%'  
  
  
return @l_poa_master  
  
  
end

GO
