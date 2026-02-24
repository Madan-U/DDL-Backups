-- Object: PROCEDURE citrus_usr.pr_valid_sendchk
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create procedure [citrus_usr].[pr_valid_sendchk](@pa_crn_no numeric(10,0),@pa_out char(1) out)
as 
begin 
--
  if exists(select clim_crn_no from client_list where clim_crn_no = @pa_crn_no and clim_deleted_ind = 1 and clim_status in (1,3,10)) 
  select 'N'
  else 
  select 'Y'
--
end

GO
