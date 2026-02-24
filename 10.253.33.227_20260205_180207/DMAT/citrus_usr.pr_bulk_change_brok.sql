-- Object: PROCEDURE citrus_usr.pr_bulk_change_brok
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


CREATE   procedure [citrus_usr].[pr_bulk_change_brok]
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

if @pa_action ='BULKUPDATE_ANGEL'
begin

exec pr_bulk_change_brok_ForAngel 'BULKUPDATE_ANGEL'
return 
end 


 declare @@dpmid int,  
 @@l_child_entm_id numeric
 ,@l_error bigint
 ,@l_errorstr varchar(8000)
 declare @l_sql varchar(8000)
 declare @l_rnd varchar(20)
 declare @l_cltlist varchar(8000)
 set @l_rnd = convert(varchar(20),getdate(),109)

 select @@dpmid = dpm_id from dp_mstr with(nolock) where default_dp = @pa_excsmid and dpm_deleted_ind =1                      
 select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)
 
print @@dpmid
print @pa_login_pr_entm_id
print @@l_child_entm_id

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

CREATE TABLE #OLDPROFILE (DPAM_ID BIGINT,BROM_ID INT)


if @pa_action = 'BULKUPDATE'
begin 

INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) where dpam_stam_cd <> '02_BILLSTOP'		
AND dpam_sba_no in (select bulk_sba_no from bulkbrok_chng_accno)  
  

INSERT INTO  #OLDPROFILE
select dpam_id,clidb_brom_id from bulkbrok_chng_accno,client_dp_brkg b,dp_acct_mstr where dpam_sba_no=bulk_sba_no
and dpam_id=clidb_dpam_id
and getdate()  between clidb_eff_from_dt and 
clidb_eff_to_dt order by CLIDB_LST_UPD_DT desc
   
end
else
begin
INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO 
FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) where dpam_stam_cd <> '02_BILLSTOP'		

  --AND dpam_sba_no in (select dpam_sba_no from bulkbrok_chng_accno)  
end

if @pa_group_cd='Y'
begin 
delete from #ACLIST where dpam_sba_no not in (select grp_client_code from group_mstr)
end


if @pa_action = 'BULKUPDATE'
begin 


--print @pa_eff_from
	  begin transaction 
--    #OLDPROFILE
--	  update clidb set clidb_eff_to_dt = dateadd(dd,-1,@pa_eff_from)
--	  , clidb_lst_upd_by = 'MIG'
--	  , clidb_lst_upd_dt = getdate()
--	  from client_dp_brkg clidb , #ACLIST where dpam_id = clidb_dpam_id 
--	  and isnull(clidb_eff_to_dt ,'2099-12-31 00:00:00.000') >=  '2099-12-31 00:00:00.000' 
--	  and CLIDB_BROM_ID = @pa_old_brok  
--	  and clidb_deleted_ind = 1 

--	  insert into client_dp_brkg
--	  select dpam_id , @pa_new_brok , 'MIG',getdate(),'MIG',getdate(),1, @pa_eff_from ,dateadd(yy,1,'2099-12-31 00:00:00.000') 
--	  from client_dp_brkg clidb , #ACLIST where dpam_id = clidb_dpam_id 
--	  and CLIDB_BROM_ID = @pa_old_brok  
--	  and clidb_deleted_ind = 1 

	  update clidb set clidb_eff_to_dt = dateadd(dd,-1,@pa_eff_from)
	  , clidb_lst_upd_by = 'MIG'
	  , clidb_lst_upd_dt = getdate()
	  from client_dp_brkg clidb , #OLDPROFILE where dpam_id = clidb_dpam_id 
	  and isnull(clidb_eff_to_dt ,'2099-12-31 00:00:00.000') >=  '2099-12-31 00:00:00.000' 
	  and CLIDB_BROM_ID = BROM_ID --@pa_old_brok  
	  and clidb_deleted_ind = 1 

	  insert into client_dp_brkg
	  select dpam_id , @pa_new_brok , 'MIG',getdate(),'MIG',getdate(),1, @pa_eff_from ,dateadd(yy,1,'2099-12-31 00:00:00.000') 
	  from client_dp_brkg clidb , #OLDPROFILE where dpam_id = clidb_dpam_id 
	  and CLIDB_BROM_ID = BROM_ID -- @pa_old_brok  
	  and clidb_deleted_ind = 1 


	  

--		insert into client_dp_brkg
--		select dpam_id ,@pa_new_brok,'MIG',getdate(),'MIG',getdate(),1, @pa_eff_from 
--		,dateadd(yy,1,'2099-12-31 00:00:00.000') 
--		from #ACLIST,group_mstr where  grp_client_code = dpam_sba_no
--		and grp_deleted_ind = 1
--		and dpam_deleted_ind = 1


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
	  Set @l_cltlist =''
	  select @l_cltlist = @l_cltlist + ',' + grp_client_code from group_mstr where grp_client_code not in(select dpam_sba_no from dp_acct_mstr)
	  print @l_cltlist
	  SET @l_errorstr = 'Tarrif Mapping successfuly Updated'+ '*|~*' + ' @ ' + 'Clients not in our backoffice are:: ' + @l_cltlist
	  --
	  COMMIT TRANSACTION
	--  
	END  

end 
else 
begin 
--  if @pa_from_acct <> ''
--  begin	
--	  select dpam_id , dpam_sba_no,dpam_sba_name, @pa_old_brok , 'MIG',getdate(),'MIG',getdate(),1, clidb_eff_from_dt,clidb_eff_to_dt
--	  from client_dp_brkg clidb , #ACLIST where dpam_id = clidb_dpam_id 
--      and CLIDB_BROM_ID = @pa_old_brok
--      and getdate() between convert(varchar,clidb_eff_from_dt,109) and convert(varchar,clidb_eff_to_dt,109)
--	  and case when RIGHT(@pa_from_acct,8) = '' then '0' else RIGHT(dpam_sba_no,8) end = case when RIGHT(@pa_from_acct,8) = '' then '0' else RIGHT(@pa_from_acct,8) end	  
--	  and clidb_deleted_ind = 1 
	
	select distinct dpam_id,dpam_sba_no,dpam_sba_name from group_mstr, #ACLIST
	where dpam_sba_no = grp_client_code
	and grp_DELETED_IND = 1
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
