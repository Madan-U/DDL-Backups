-- Object: PROCEDURE citrus_usr.pr_prebilling_mismatch_clear
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

 CREATE   proc [citrus_usr].[pr_prebilling_mismatch_clear](@pa_tab varchar(100) , @date datetime  )  
as  
begin 

--

--exec [citrus_usr].[pr_prebilling_mismatch_clear] 'brokerage', 'Jun 01 2019'
--exec [citrus_usr].[pr_prebilling_mismatch_clear] 'relationship', 'Jun 01 2019'

if @pa_tab = 'brokerage'
	
	begin 
	exec pr_take_backup_prebill 'client_dp_brkg'
	 
	drop table tmpdata
	 
	select clidb_dpam_id into tmpdata
	from client_dp_brkg, dp_acct_mstr
	where clidb_dpam_id = dpam_id and getdate() between clidb_eff_from_dt and isnull(clidb_eff_to_dt,getdate())
	and clidb_deleted_ind =1 
	and dpam_deleted_ind =1 
	group by clidb_dpam_id , dpam_sba_no
	having count(clidb_brom_id)>1;
 
	
	WITH CTE (CLIDB_BROM_ID,CLIDB_DPAM_ID,clidb_eff_from_dt,clidb_eff_to_dt, DuplicateCount)
	AS
	(
	SELECT CLIDB_BROM_ID,CLIDB_DPAM_ID,clidb_eff_from_dt,clidb_eff_to_dt,
	ROW_NUMBER() OVER(PARTITION BY CLIDB_BROM_ID,CLIDB_DPAM_ID,clidb_eff_from_dt,clidb_eff_to_dt ORDER BY CLIDB_BROM_ID,CLIDB_DPAM_ID,clidb_eff_from_dt,clidb_eff_to_dt ) ASDuplicateCount
	FROM client_dp_brkg
	where clidb_deleted_ind = 1 
	and clidb_dpam_id in (select clidb_dpam_id  from tmpdata)
	)
	delete   
	FROM CTE
	WHERE DuplicateCount >1
 
	delete  from client_dp_brkg where clidb_eff_from_dt > = @date
	and clidb_eff_to_dt =  @date-1

	end 
	
if @pa_tab = 'relationship'
	begin 

		exec pr_take_backup_prebill 'entity_relationship'

		drop table  missingbaselocation

		select dpid  cltdpno, baselocation  base_location into  missingbaselocation 
		from bobackup.[dbo].[temp_baselocation_new] 
		 
		begin tran
		update a  set entr_dummy5 = entm_id
		from  missingbaselocation, entity_mstr, ENTITY_RELATIONSHIP  a
		 where entm_enttm_cd = 'bl' and cltdpno = entr_sba 
		 and base_location = replace(entm_short_name ,'_bl','')
		 --and entr_dummy5 = '0'
		 and getdate() between entr_from_Dt and isnull(entr_to_dt ,'Dec 31 2900')
		 and entr_deleted_ind = '1'
 
 	
	end



end

GO
