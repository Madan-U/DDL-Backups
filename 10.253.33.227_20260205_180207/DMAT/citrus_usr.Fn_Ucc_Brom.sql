-- Object: FUNCTION citrus_usr.Fn_Ucc_Brom
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


CREATE function [citrus_usr].[Fn_Ucc_Brom] (@pa_dpam_id numeric,@pa_from_date datetime)
returns varchar(200)
as
begin
declare @l_desc varchar(200)
select @l_desc = brom_desc from brokerage_mstr,client_dp_brkg where clidb_dpam_id=@pa_dpam_id and brom_id=clidb_brom_id and 
@pa_from_date between clidb_eff_from_dt and isnull(clidb_eff_to_dt,'2100-12-31 00:00:00.000') and clidb_deleted_ind=1
return @l_desc
end

GO
