-- Object: PROCEDURE citrus_usr.pr_Scheme_Data
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

-- exec pr_scheme_data
create   proc [citrus_usr].[pr_Scheme_Data]
as 
begin
truncate table  Scheme_data
insert into Scheme_data
select dpam_sba_no SSBA , brom_Desc scheme    from DP_ACCT_MSTR ,  client_dp_brkg , brokerage_mstr 
where dpam_id = clidb_dpam_id 
and clidb_brom_id = brom_id 
and DPAM_DELETED_IND = 1 
and CLIDB_DELETED_IND = 1 
and BROM_DELETED_IND = 1 
and getdate () between clidb_eff_from_dt and isnull(clidb_eff_to_dt , 'Dec 31 2900')
end

GO
