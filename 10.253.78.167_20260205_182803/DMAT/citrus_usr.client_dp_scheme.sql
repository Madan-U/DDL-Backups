-- Object: VIEW citrus_usr.client_dp_scheme
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create view [citrus_usr].[client_dp_scheme] 
as 
select  dpam_sba_no , brom_desc  from dp_acct_mstr , client_dp_brkg, brokerage_mstr 
where clidb_dpam_id = dpam_id 
and clidb_brom_id = brom_id 
and getdate() between clidb_eff_from_dt
and isnull(clidb_eff_to_dt,'dec 31 2900')

GO
