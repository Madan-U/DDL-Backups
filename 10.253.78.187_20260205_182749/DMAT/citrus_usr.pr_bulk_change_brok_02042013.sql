-- Object: PROCEDURE citrus_usr.pr_bulk_change_brok_02042013
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--[pr_bulk_change_brok]  	'0','',3,	'', '', '1','','apr 13 2010',1,'HO|*~|', ''	
CREATE procedure [citrus_usr].[pr_bulk_change_brok_02042013]
(@pa_id varchar(8000)
,@pa_action varchar(100)
,@pa_excsmid numeric
,@pa_from_acct varchar(20)
,@pa_to_acct varchar(20)
,@pa_old_brok varchar(50)
,@pa_new_brok varchar(50)
,@pa_group_cd varchar(10)
,@pa_eff_from datetime
,@pa_login_pr_entm_id numeric                       
,@pa_login_entm_cd_chain  varchar(8000)
,@pa_output varchar(8000) output
)
as
begin


 declare @@dpmid int,  
 @@l_child_entm_id numeric
  ,@l_error              bigint
,@l_errorstr           varchar(8000)
   declare @l_sql varchar(8000)
 declare @l_rnd varchar(20)
 set @l_rnd = convert(varchar(20),getdate(),109)

 select @@dpmid = dpm_id from dp_mstr with(nolock) where default_dp = @pa_excsmid and dpm_deleted_ind =1                      
 select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)
 


  /*if @pa_from_acct = '' and @pa_to_acct = '' 
  begin 
    set @pa_from_acct ='0' 
    set  @pa_to_acct ='999999999999999999999' 
  end 
  if @pa_from_acct <> '' 
  begin 
    set  @pa_to_acct =@pa_from_acct
  end */

  CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)

if @pa_action = 'BULKUPDATE'
begin 
  INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) where dpam_stam_cd <> '02_BILLSTOP'		
  AND dpam_sba_no in (select bulk_sba_no from bulkbrok_chng_accno)  
end
else
begin
INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) where dpam_stam_cd <> '02_BILLSTOP'		

  --AND dpam_sba_no in (select dpam_sba_no from bulkbrok_chng_accno)  
end

if @pa_group_cd='Y'
begin 
delete from #ACLIST where dpam_sba_no not in (select grp_client_code from group_mstr)
end


if @pa_action = 'BULKUPDATE'
begin 

	  begin transaction 

	  update clidb set clidb_eff_to_dt = dateadd(dd,-1,@pa_eff_from)
	  , clidb_lst_upd_by = 'MIG'
	  , clidb_lst_upd_dt = getdate()
	  from client_dp_brkg clidb , #ACLIST where dpam_id = clidb_dpam_id 
	  and isnull(clidb_eff_to_dt ,'2099-12-31 00:00:00.000') >=  '2099-12-31 00:00:00.000' and CLIDB_BROM_ID = @pa_old_brok  
	  and clidb_deleted_ind = 1 

	  insert into client_dp_brkg
	  select dpam_id , @pa_new_brok , 'MIG',getdate(),'MIG',getdate(),1, @pa_eff_from ,dateadd(yy,1,'2099-12-31 00:00:00.000') 
	  from client_dp_brkg clidb , #ACLIST where dpam_id = clidb_dpam_id 
	  and CLIDB_BROM_ID = @pa_old_brok  
	  and clidb_deleted_ind = 1 

	SET @l_error = @@error
	--
	IF @l_error > 0
	BEGIN
	--
	  SET @l_errorstr = 'Error Tarrif Mapping could not be Updated'+'*|~*'
	  --
	  ROLLBACK TRANSACTION
	--
	END
	ELSE
	BEGIN
	--
	  SET @l_errorstr = 'Tarrif Mapping successfuly Updated'+'*|~*'
	  --
	  COMMIT TRANSACTION
	--  
	END  

end 
else 
begin 
--  if @pa_from_acct <> ''
--  begin	
	  select dpam_id , dpam_sba_no,dpam_sba_name, @pa_old_brok , 'MIG',getdate(),'MIG',getdate(),1, clidb_eff_from_dt,clidb_eff_to_dt
	  from client_dp_brkg clidb , #ACLIST where dpam_id = clidb_dpam_id 
      and CLIDB_BROM_ID = @pa_old_brok
      and getdate() between convert(varchar,clidb_eff_from_dt,109) and convert(varchar,clidb_eff_to_dt,109)
	  and case when RIGHT(@pa_from_acct,8) = '' then '0' else RIGHT(dpam_sba_no,8) end = case when RIGHT(@pa_from_acct,8) = '' then '0' else RIGHT(@pa_from_acct,8) end	  
	  and clidb_deleted_ind = 1 
--  end
	
--  else
--  begin 
--	  select dpam_id , dpam_sba_no,dpam_sba_name, @pa_old_brok , 'MIG',getdate(),'MIG',getdate(),1, clidb_eff_from_dt,clidb_eff_to_dt
--	  from client_dp_brkg clidb , #ACLIST where dpam_id = clidb_dpam_id 
--	  and CLIDB_BROM_ID = @pa_old_brok	  
--	  and clidb_deleted_ind = 1 
--  end
end 

  
 
 SET @pa_output = ISNULL(@l_errorstr, '')

end

GO
