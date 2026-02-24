-- Object: PROCEDURE citrus_usr.pr_ins_tariff
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------





CREATE procedure [citrus_usr].[pr_ins_tariff]
(@BOID [varchar](20),
	@pa_old_brok [varchar](50),
	@pa_new_brok [varchar](50),
	@PA_EFF_DATE [varchar](20), 
	@pa_profile_type [varchar](20),
    @pa_out varchar(8000) output
)
as
begin
--
	Insert into ins_tariff  values(@BOID,@pa_old_brok,@pa_new_brok,@PA_EFF_DATE,@pa_profile_type)
--
end

GO
