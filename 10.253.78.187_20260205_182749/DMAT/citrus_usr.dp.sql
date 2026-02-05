-- Object: PROCEDURE citrus_usr.dp
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


create proc [citrus_usr].[dp]
as 
begin
select dpm_dpid from dp_mstr where default_dp = dpm_excsm_id 
end

GO
