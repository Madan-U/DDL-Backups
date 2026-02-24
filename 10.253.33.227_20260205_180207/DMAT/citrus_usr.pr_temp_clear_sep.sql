-- Object: PROCEDURE citrus_usr.pr_temp_clear_sep
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


create   proc pr_temp_clear_sep 

 @pa_boid varchar (16) 

as 

 declare @pa_eff_dt datetime 

begin 

 

select @pa_eff_dt =  clidb_eff_from_dt  from client_dp_brkg where 
CLIDB_DPAM_ID in (select DPAM_ID  from dp_acct_mstr where DPAM_SBA_NO = @pa_boid)
and CLIDB_BROM_ID = 96 


delete  from client_dp_brkg where CLIDB_DPAM_ID in (select DPAM_ID  from dp_acct_mstr where DPAM_SBA_NO = @pa_boid)
and clidb_eff_to_dt = '2100-12-31 00:00:00.000'
and CLIDB_BROM_ID in( 18,19)

update   client_dp_brkg set  clidb_eff_to_dt = '2100-12-31 00:00:00.000' 
where CLIDB_DPAM_ID in (select DPAM_ID  from dp_acct_mstr where DPAM_SBA_NO = @pa_boid)
and clidb_eff_from_dt = @pa_eff_dt

select * from client_dp_brkg where CLIDB_DPAM_ID in (select DPAM_ID  from dp_acct_mstr where DPAM_SBA_NO = @pa_boid)
order by clidb_eff_from_dt desc 

end

GO
