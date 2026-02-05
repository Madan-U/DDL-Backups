-- Object: PROCEDURE citrus_usr.valid_count_email
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[valid_count_email](@pa_mail varchar(100),@pa_out char(1) out)
as
begin
	if 1 < (select count(distinct entac_ent_id) from entity_adr_conc , contact_channels where entac_adr_conc_id = conc_id and conc_value  = @pa_mail and ENTAC_CONCM_CD = 'EMAIL1' and conc_value <> '')
	begin
	   set @pa_out = 'N'
	end 
    else 
    begin
       set @pa_out = 'Y'
    end 
print @pa_out 
end

GO
