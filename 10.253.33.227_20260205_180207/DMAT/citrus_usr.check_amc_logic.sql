-- Object: PROCEDURE citrus_usr.check_amc_logic
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--exec   check_amc_logic '1203320014916077'
CREATE   procedure [citrus_usr].[check_amc_logic](@pa_dpam_sba_no varchar(20), @bbo_code varchar (20) )
as 
begin 

if @pa_dpam_sba_no <> ''
begin 
declare @l_bbocode  varchar (20)
declare @l_dpam_id  varchar (10)
declare @l_dpam_sba_no  varchar (20)

--select * from dp_acct_mstr where dpam_sba_no = @pa_dpam_sba_no
select @l_bbocode = dpam_bbo_code, @l_dpam_id = dpam_id  from dp_acct_mstr where dpam_sba_no = @pa_dpam_sba_no

select boid , BOActDt,BOAcctStatus from dps8_pc1 where boid = @pa_dpam_sba_no

select * from client_dp_brkg where clidb_dpam_id = @l_dpam_id 
and clidb_deleted_ind = '1' order by clidb_eff_from_dt desc 

select *   from [CSOKYC-6].general.dbo.Vw_LedgerBal where client=@l_bbocode

select  cl_code,case  when b2c = 'Y' then 'N' else 'Y' end  B2B   from  [10.253.33.167].INHOUSE.DBO.CLIENT_DETAILS where cl_code = @l_bbocode

select 'DP Ledger', dpam_sba_no , sum(ldg_amount) from ledger5, dp_acct_mstr where ldg_account_id  = dpam_id and  ldg_account_id = @l_dpam_id
and ldg_deleted_ind = '1'
group by dpam_sba_no

select * from client_charges_cdsl where clic_dpam_id =@l_dpam_id and clic_trans_dt > 'May 31 2018'

select * from entity_Relationship where entr_sba = @pa_dpam_sba_no
end 

if @pa_dpam_sba_no = ''
begin 

select @l_dpam_sba_no  = dpam_sba_no, @l_dpam_id = dpam_id  from dp_acct_mstr where dpam_bbo_code = @bbo_code

select boid , BOActDt,BOAcctStatus from dps8_pc1 where boid = @l_dpam_sba_no

select * from client_dp_brkg where clidb_dpam_id = @l_dpam_id 
and clidb_deleted_ind = '1' order by clidb_eff_from_dt desc 

select *   from [CSOKYC-6].general.dbo.Vw_LedgerBal where client=@bbo_code

select  cl_code,case  when b2c = 'Y' then 'N' else 'Y' end  B2B   from  [10.253.33.167].INHOUSE.DBO.CLIENT_DETAILS 
where cl_code = @bbo_code

select 'DP Ledger', dpam_sba_no , sum(ldg_amount) from ledger5, dp_acct_mstr 
where ldg_account_id  = dpam_id and  ldg_account_id = @l_dpam_id
and ldg_deleted_ind = '1'
group by dpam_sba_no

select * from client_charges_cdsl where clic_dpam_id =@l_dpam_id and clic_trans_dt > 'May 31 2018'

select * from entity_Relationship where entr_sba = @l_dpam_sba_no
end 


end

GO
