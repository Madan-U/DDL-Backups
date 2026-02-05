-- Object: PROCEDURE citrus_usr.pr_update_scheme_yogesh
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--begin tran
--  exec pr_update_scheme_yogesh '1201910300662968'
--rollback

CREATE    proc [citrus_usr].[pr_update_scheme_yogesh]
 @boid varchar (16)
 as 
 begin  
 
 declare @count numeric ,
 @errmsg varchar (500)

 select @count = count (1) from client_dp_brkg where CLIDB_DELETED_IND =1 and CLIDB_DPAM_ID in 
	(select DPAM_ID  from dp_acct_mstr where DPAM_SBA_NO = @boid)
 
 if @count   = 2 
	begin
	 declare @mindate  datetime
	 declare @maxdate  datetime
	 declare @to_date datetime 
	-- declare @boid  varchar (16) --= '1201910300643953'
 
	-- select @mindate = min (clidb_eff_from_dt ) , @maxdate = max (clidb_eff_from_dt ) 
	-- from client_dp_brkg  where CLIDB_DPAM_ID in 
	--(select DPAM_ID  from dp_acct_mstr where DPAM_SBA_NO = @boid)

	----select  @mindate,@maxdate


	--update client_dp_brkg set clidb_eff_to_dt = @maxdate - 1 
	--where CLIDB_DPAM_ID in 
	--(select DPAM_ID  from dp_acct_mstr where DPAM_SBA_NO = @boid)
	--and clidb_eff_from_dt = @mindate


			 

		if exists (
		select * from client_dp_brkg where CLIDB_DPAM_ID 
		in (select dpam_id from DP_ACCT_MSTR where dpam_sba_no = @boid)
		and clidb_eff_from_dt = 'Oct 29 2025')
		begin 

		select @to_date = clidb_eff_to_dt  from client_dp_brkg where CLIDB_DPAM_ID 
		in (select dpam_id from DP_ACCT_MSTR where dpam_sba_no = @boid)
		and clidb_eff_from_dt <> 'Oct 29 2025'

		update client_dp_brkg
		set clidb_eff_from_dt =  DATEADD(DAY, 1, CAST(@to_date AS DATE)) 
		  from client_dp_brkg where CLIDB_DPAM_ID 
		in (select dpam_id from DP_ACCT_MSTR where dpam_sba_no = @boid)
		and clidb_eff_from_dt = 'Oct 29 2025'

		end 


	 end 
	 else 
	 begin 
		set @errmsg = 'Records are more than 2 for client, please do it manally'
		select @errmsg  
	 return
	 end 
 end

GO
