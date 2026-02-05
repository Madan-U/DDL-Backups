-- Object: FUNCTION citrus_usr.fn_get_brom_id
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create function [citrus_usr].[fn_get_brom_id] (@l_dpam_id numeric,@l_dt varchar(11))  
returns varchar(100)  
as  
begin   
  
return   
(select convert(varchar,clidb_brom_id )from client_dp_brkg   
where clidb_dpam_id = @l_dpam_id and @l_dt between  clidb_eff_from_dt and isnull(clidb_eff_to_dt,'dec 31 2100')     
  
and clidb_deleted_ind = 1)  
   
end

GO
