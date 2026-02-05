-- Object: PROCEDURE citrus_usr.pr_ins_tariff_bak_30122015
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------



create procedure [citrus_usr].[pr_ins_tariff_bak_30122015]
(@BOID [varchar](20),
	@pa_old_brok [varchar](20),
	@pa_new_brok [varchar](20),
	@PA_EFF_DATE [varchar](20), 
 @pa_out varchar(8000) output
)
as
begin
--
	Insert into ins_tariff  values(@BOID,@pa_old_brok,@pa_new_brok,@PA_EFF_DATE)
--
end

GO
