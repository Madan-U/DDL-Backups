-- Object: PROCEDURE citrus_usr.pr_bulk_scheme_change
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


--exec pr_rpt_mismatch @pa_tab='BROKERAGE'--75
--begin tran
--exec [pr_bulk_scheme_change] 'jul 01 2023'
--exec pr_rpt_mismatch @pa_tab='BROKERAGE'
--commit
--rollback

--create table schemechanged (boid varchar(100),old_scheme varchar(1000),new_scheme varchar(1000),eff_from_dt datetime)

--select * from  schemechanged

CREATE proc [citrus_usr].[pr_bulk_scheme_change] (@pa_dt_from datetime)
as
begin 

select top 1 @pa_dt_from =  eff_from_dt from schemechanged

insert into client_dp_brkg_bak_dnd
select *, 'back before scheme change in bulk' ,GETDATE ()  from client_dp_brkg 
where CLIDB_DPAM_ID in(select DPAM_ID from dp_acct_mstr where DPAM_SBA_NO in(select boid from schemechanged))


		if exists (select 1 from brokerage_mstr where brom_desc  in (select top 1 new_scheme from schemechanged))
		and 1 = (select count(distinct new_scheme ) from schemechanged)

		begin 



		declare @new_scheme varchar(100)
		select top 1 @new_scheme = BROM_ID  from schemechanged, BROKERAGE_MSTR
		where new_scheme = BROM_DESC 


		select CLIDB_DPAM_ID into #temp1 from  client_dp_brkg 
		where CLIDB_DPAM_ID in (select  DPAM_ID from schemechanged, DP_ACCT_MSTR where boid = DPAM_SBA_NO )
		and CLIDB_DELETED_IND = '1'
		and GETDATE () between clidb_eff_from_dt and clidb_eff_to_dt 
		and clidb_eff_from_dt < @pa_dt_from

		--BEGIN TRAN
		UPDATE  client_dp_brkg 
		SET clidb_eff_to_dt = @pa_dt_from - 1 
		where CLIDB_DPAM_ID in (select  DPAM_ID from schemechanged, DP_ACCT_MSTR where boid = DPAM_SBA_NO )
		and CLIDB_DELETED_IND = '1'
		and GETDATE () between clidb_eff_from_dt and clidb_eff_to_dt 
		and clidb_eff_from_dt < @pa_dt_from
 

		UPDATE    client_dp_brkg 
		set CLIDB_BROM_ID = @new_scheme 
		where CLIDB_DPAM_ID in (select  DPAM_ID from schemechanged, DP_ACCT_MSTR where boid = DPAM_SBA_NO )
		and CLIDB_DELETED_IND = '1'
		and GETDATE () between clidb_eff_from_dt and clidb_eff_to_dt 
		and clidb_eff_from_dt >= @pa_dt_from

		INSERT INTO client_dp_brkg
		select clidb_dpam_id , @new_scheme,'MIG',GETDATE(),'MIG',GETDATE(),'1',@pa_dt_from,'2900-01-01 00:00:00.000'
		FROM #TEMP1

--		COMMIT



		end 




end

GO
