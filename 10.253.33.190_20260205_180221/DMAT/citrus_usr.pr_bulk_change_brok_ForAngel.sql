-- Object: PROCEDURE citrus_usr.pr_bulk_change_brok_ForAngel
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_bulk_change_brok_ForAngel](@pa_action varchar(100))
as
begin

declare @@dpmid int,  
@@l_child_entm_id numeric
,@l_error bigint
,@l_errorstr varchar(8000)
declare @l_sql varchar(8000)
declare @l_rnd varchar(20)
declare @l_cltlist varchar(8000)
set @l_rnd = convert(varchar(20),getdate(),109)

 
begin transaction

IF EXISTS (SELECT 1 FROM ins_tariff WHERE profile_type='INVTOZERO')
BEGIN 


				declare @l_id numeric
				select @l_id = MAX(fre_id) from freeze_Unfreeze_dtls
				select IDENTITY(numeric,1,1) id,dpam_id into #tempdatafinal_forfreeze  from ins_tariff ,dp_acct_mstr 
				where BOID = DPAM_SBA_NO  AND  profile_type='INVTOZERO'
				
				
				insert into freeze_Unfreeze_dtls 
				select id +@l_id   fre_id,'F','A',CONVERT(VARCHAR(11),GETDATE(),109), '3',dPAM_ID , '',0.00000,'A','A'
				,'HO',GETDATE(),'HO',GETDATE(),'1',NULL,'A',NULL, 'FREEZE DUE TO DEBIT BALANCE IN DP LEDGER','02'
				FROM   #tempdatafinal_forfreeze 


END 

IF EXISTS (SELECT 1 FROM ins_tariff WHERE profile_type='ZEROTOINV')
BEGIN 

UPDATE FRE 
SET FRE_ACTION = 'U'
,fre_rmks = ''
FROM freeze_Unfreeze_dtls FRE , ins_tariff ,dp_acct_mstr
WHERE BOID = DPAM_SBA_NO AND DPAM_ID = fre_Dpam_id 
--AND fre_rmks = 'FREEZE DUE TO DEBIT BALANCE IN DP LEDGER'
AND profile_type='ZEROTOINV' AND FRE_ACTION = 'f'



END 


 update clidb set clidb_eff_to_dt = dateadd(dd,-1,PA_EFF_DATE)
	  , clidb_lst_upd_by = 'MIG'
	  , clidb_lst_upd_dt = getdate()
	  from client_dp_brkg clidb , ins_tariff,dp_acct_mstr,BROKERAGE_MSTR   where dpam_id = clidb_dpam_id and DPAM_SBA_NO = BOID
	  and CLIDB_BROM_ID = BROM_ID 
	  and isnull(clidb_eff_to_dt ,'2099-12-31 00:00:00.000') >=  '2099-12-31 00:00:00.000' 
	  and pa_old_brok = BROM_desc --@pa_old_brok  
	  and clidb_deleted_ind = 1 

	  insert into client_dp_brkg
	  select dpam_id , new.BROM_ID  , 'MIG',getdate(),'MIG',getdate(),1, PA_EFF_DATE ,dateadd(yy,1,'2099-12-31 00:00:00.000') 
	  from client_dp_brkg clidb , ins_tariff,dp_acct_mstr,BROKERAGE_MSTR old,BROKERAGE_MSTR new  where dpam_id = clidb_dpam_id  and DPAM_SBA_NO = BOID
	  and CLIDB_BROM_ID = old.BROM_ID 
	  and pa_old_brok = old.BROM_desc -- @pa_old_brok  
	  and pa_new_brok = new.BROM_desc
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
	  Set @l_cltlist =''
	  select @l_cltlist = @l_cltlist + ',' + grp_client_code from group_mstr where grp_client_code not in(select dpam_sba_no from dp_acct_mstr)
	  print @l_cltlist
	  SET @l_errorstr = 'Tarrif Mapping successfuly Updated'+ '*|~*' + ' @ ' + 'Clients not in our backoffice are:: ' + @l_cltlist
	  --
	  COMMIT TRANSACTION
	--  
	END  


select * from ins_tariff

end

GO
