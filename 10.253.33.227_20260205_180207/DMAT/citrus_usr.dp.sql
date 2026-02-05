-- Object: PROCEDURE citrus_usr.dp
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create proc dp
as 
begin
select dpm_dpid from dp_mstr where default_dp = dpm_excsm_id 
end

GO
