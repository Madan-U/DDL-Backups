-- Object: PROCEDURE citrus_usr.pr_billing_cdsl_BAK01032013
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

/*
INSERT INTO BITMAP_REF_MSTR
SELECT max(bitrm_id)+ 1 ,'BILL_CLI_ADD_DP_CHRG_CDSL' ,'BILL_CLI_ADD_DP_CHRG_CDSL',3,'0','','HO',getdate(),'HO',getdate(),1 FROM BITMAP_REF_MSTR
*/
--select * from dp_mstr where default_dp = dpm_excsm_id 
--begin tran
--[pr_billing_cdsl] 'oct 01 2012','oct 31 2012',485029,'y'
CREATE procedure [citrus_usr].[pr_billing_cdsl_BAK01032013](@pa_billing_from_dt datetime,@pa_billing_to_dt datetime,@pa_dpm_id numeric,@pa_billing_status   char(1))
as
begin
--
  declare @l_post_toacct numeric(10,0)
         ,@pa_excmid int
         
  SET DATEFORMAT dmy



       
	select top 1 @pa_excmid  = excm_id from dp_mstr,exch_seg_mstr,exchange_mstr 
	where dpm_id = @pa_dpm_id 
	and   dpm_excsm_id = excsm_id 
	and   excsm_exch_cd=  excm_cd
	and dpm_deleted_ind = 1          
	and excm_deleted_ind = 1          
	and excsm_deleted_ind = 1   

	select top 1 @l_post_toacct = cham_post_toacct 
	from  charge_mstr,profile_charges,client_dp_brkg 
	where 	clidb_brom_id = proc_profile_id
	AND   proc_slab_no  = cham_slab_no
	and cham_charge_type = 'OF-DR' and cham_deleted_ind  = 1 
	and @pa_billing_to_dt between clidb_eff_from_dt and clidb_eff_to_dt	
	and clidb_deleted_ind = 1  
    and   CHAM_CHARGE_BASE = 'NORMAL'    
  
  
  create table #temp_bill
  (trans_dt datetime
  ,dpam_id  numeric
  ,charge_name varchar(50)
  ,charge_val  numeric(18,5)
  ,post_toacct numeric(10,0), FLG CHAR(1) NULL)

/*
	--LOGIC FOR CHARGING POA CHARGES for Pune e brok only
	insert into #temp_bill(trans_dt,dpam_id,charge_name,charge_val,post_toacct)
	select dppd_setup,dppd_dpam_id,'POA Setup Charges',-125,5 
	from dp_poa_dtls ,dp_acct_mstr,client_dp_brkg 
	where dppd_setup between @pa_billing_from_dt and @pa_billing_to_dt
	and  dppd_dpam_id = dpam_id
    and  DPAM_STAM_CD not in('05','04','08','02_BILLSTOP')
	and  dpam_dpm_id = @pa_dpm_id 
	and  dpam_id     = clidb_dpam_id
	and  dppd_setup >= clidb_eff_from_dt and  dppd_setup <= clidb_eff_to_dt
	and  dppd_deleted_ind = 1
	and  dpam_deleted_ind = 1
	and  clidb_deleted_ind = 1






	--LOGIC FOR CHARGING POA CHARGES for Pune e brok only
*/

select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
into #account_properties from account_properties 
where accp_accpm_prop_cd = 'BILL_START_DT' 
and accp_value not in ('')

select distinct convert(datetime,accp_value,103) accp_value_cl
, accp_clisba_id accp_clisba_id_cl , accp_accpm_prop_cd accp_accpm_prop_cd_cl 
into #account_properties_close from account_properties 
where accp_accpm_prop_cd = 'ACC_CLOSE_DT' 
and accp_value not in ('','//') 

create index ix_1 on #account_properties(accp_clisba_id , accp_value )
create index ix_2 on #account_properties_close(accp_clisba_id_cl , accp_value_cl )

	insert into #temp_bill(trans_dt,dpam_id,charge_name,charge_val,post_toacct)
	select dppd_setup,dppd_dpam_id,CHAM_SLAB_NAME,cham_charge_value,CHAM_POST_TOACCT 
	from dp_poa_dtls ,dp_acct_mstr,client_dp_brkg,profile_charges,charge_mstr  
	where dppd_setup between @pa_billing_from_dt and @pa_billing_to_dt
	and  dppd_dpam_id = dpam_id
	and  DPAM_STAM_CD not in('05','04','08','02_BILLSTOP')
	and  dpam_dpm_id = @pa_dpm_id 
	and  dpam_id     = clidb_dpam_id
	AND  clidb_brom_id = proc_profile_id
	AND  proc_slab_no  = cham_slab_no
	AND   isnull(cham_charge_graded,0) <> 1
	AND   cham_charge_baseon           = 'TV' 
	AND   cham_charge_type = 'POA'
	and   CHAM_CHARGE_BASE = 'NORMAL'
	and  dppd_setup >= clidb_eff_from_dt and  dppd_setup <= clidb_eff_to_dt
	and  dppd_deleted_ind = 1
	and  dpam_deleted_ind = 1
	and  clidb_deleted_ind = 1
	and   proc_deleted_ind = 1
	and   cham_deleted_ind = 1

 

  --logic for charging slip issued charges
		insert into #temp_bill
		(trans_dt 
		,dpam_id  
		,charge_name 
		,charge_val
		,post_toacct)
		select sliim_created_dt,dpam_id,
		cham_slab_name,
		isnull((sum(((convert(bigint,SLIIM_SLIP_NO_TO) - convert(bigint,SLIIM_SLIP_NO_FR) + 1))) * cham_charge_value),0) * -1 ,
		cham_post_toacct
		from slip_issue_mstr,
		dp_acct_mstr
		,client_dp_brkg
		,profile_charges
		,charge_mstr
		where sliim_created_dt between @pa_billing_from_dt and @pa_billing_to_dt
		and SLIIM_DPAM_ACCT_NO = dpam_sba_no 
		and  dpam_dpm_id = @pa_dpm_id 
		and   dpam_id     = clidb_dpam_id
		and   sliim_created_dt >= clidb_eff_from_dt and  sliim_created_dt <= clidb_eff_to_dt
		and   clidb_brom_id = proc_profile_id
		and   proc_slab_no  = cham_slab_no
		and   cham_charge_type = 'SLIP_ISS_CDSL'
		and   cham_deleted_ind = 1
		and   clidb_deleted_ind = 1
		and   dpam_deleted_ind = 1
		and   proc_deleted_ind = 1
		and   sliim_deleted_ind = 1 
        and   CHAM_CHARGE_BASE = 'NORMAL'
		group by dpam_id , cham_slab_name , cham_post_toacct,cham_from_factor,cham_to_factor,cham_charge_value,sliim_created_dt
		having sum(((convert(bigint,SLIIM_SLIP_NO_TO) - convert(bigint,SLIIM_SLIP_NO_FR) + 1))) between  0 and cham_to_factor 
  --logic for charging slip issued charges



  
  --logic for charging for one time charges
  
  insert into #temp_bill
  (trans_dt 
	,dpam_id  
	,charge_name 
  ,charge_val
  ,post_toacct)
  select accp_value
  ,dpam_id
  ,cham_slab_name
  ,sum(cham_charge_value )* -1
  ,cham_post_toacct
  from dp_acct_mstr
      ,client_dp_brkg
      ,profile_charges
      ,charge_mstr
      ,charge_ctgry_mapping, #account_properties left outer join #account_properties_close on accp_clisba_id = accp_clisba_id_cl
  where dpam_dpm_id = @pa_dpm_id 
  and  accp_clisba_id = dpam_id  
  and   ( DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI') or @pa_billing_to_dt between  accp_value and isnull(accp_value_cl,'jan 31 2100'))
	and dpam_stam_cd not in ('CI','04','CLOS','05')
  --and    DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI') 
  AND   dpam_id     = clidb_dpam_id
  and   CHAM_SLAB_NO = chacm_cham_id
  and   case when chacm_subcm_cd = '0' then '0' else dpam_subcm_cd end = chacm_subcm_cd
  AND   accp_value >= clidb_eff_from_dt and  accp_value <= clidb_eff_to_dt
  AND   clidb_brom_id = proc_profile_id
  AND   proc_slab_no  = cham_slab_no
  AND   cham_charge_type = 'O'
  AND   accp_value between @pa_billing_from_dt and @pa_billing_to_dt
  and   cham_deleted_ind = 1
  and   clidb_deleted_ind = 1
  and   dpam_deleted_ind = 1
  and   proc_deleted_ind = 1
  and   CHAM_CHARGE_BASE = 'NORMAL'
  group by dpam_id , cham_slab_name , cham_post_toacct,accp_value



 
insert into #temp_bill
  (trans_dt 
	,dpam_id  
	,charge_name 
  ,charge_val
  ,post_toacct)
  select accp_value
  ,dpam_id
  ,cham_slab_name
  ,sum(cham_charge_value )* -1
  ,cham_post_toacct
  from dp_acct_mstr
      ,client_dp_brkg
      ,profile_charges
      ,charge_mstr
      --,charge_ctgry_mapping
,#account_properties left outer join #account_properties_close on accp_clisba_id = accp_clisba_id_cl
  where dpam_dpm_id = @pa_dpm_id 
  and  accp_clisba_id = dpam_id  
  --and  DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI')
  and   ( DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI') or @pa_billing_to_dt between  accp_value and isnull(accp_value_cl,'jan 31 2100'))
  AND   dpam_id     = clidb_dpam_id
--  and   CHAM_SLAB_NO = chacm_cham_id
--  and   case when chacm_subcm_cd = '0' then '0' else dpam_subcm_cd end = chacm_subcm_cd
  AND   accp_value >= clidb_eff_from_dt and  accp_value <= clidb_eff_to_dt
  AND   clidb_brom_id = proc_profile_id
  AND   proc_slab_no  = cham_slab_no
  AND   cham_charge_type = 'AMCPROONE'
  AND   accp_value between @pa_billing_from_dt and @pa_billing_to_dt
  and   cham_deleted_ind = 1
  and   clidb_deleted_ind = 1
  and   dpam_deleted_ind = 1
  and   proc_deleted_ind = 1
  and   CHAM_CHARGE_BASE = 'NORMAL'
  group by dpam_id , cham_slab_name , cham_post_toacct,accp_value


  

CREATE TABLE #VOUCHERNO(VCHNO BIGINT)
declare @@vch_no bigint,
@@FINID INT,
@@pa_values VARCHAR(8000),
@@FORMNO VARCHAR(16),
@@voucher_dt varchar(11),
@@SSQL VARCHAR(8000)

SELECT @@FINID = FIN_ID FROM FINANCIAL_YR_MSTR WHERE @pa_billing_to_dt BETWEEN FIN_START_DT AND FIN_END_DT  AND FIN_DELETED_IND = 1

DECLARE CUR CURSOR FOR  
SELECT  INWCR_FRMNO, 'B|*~|' +  convert(varchar,ISNULL(INWCR_BANK_ID,0)) + '|*~|' + CONVERT(VARCHAR,INWCR_CHARGE_COLLECTED) + '|*~|*|~*P|*~|' + convert(varchar,dpam_id) + '|*~|0|*~||*~|' + CONVERT(VARCHAR,INWCR_CHARGE_COLLECTED) + '|*~|' + ISNULL(INWCR_CHEQUE_NO,'') + '|*~|' + LEFT(ISNULL(INWCR_RMKS,''),250) + '|*~|' + isnull(inwcr_clibank_accno,'') + '|*~|*|~*',
CONVERT(varchar(10),inwcr_recvd_dt,103) VCH_DT
FROM inw_client_reg,dp_acct_mstr 
where inwcr_frmno = dpam_acct_no 
and convert(bigint,inwcr_dmpdpid) = dpam_dpm_id 
and convert(bigint,inwcr_dmpdpid) = @pa_dpm_id
and inwcr_deleted_ind = 1
and dpam_deleted_ind = 1
and isdate(CONVERT(datetime,citrus_usr.fn_acct_entp(dpam_id,'BILL_START_DT'),103)) = 1
and convert(datetime,citrus_usr.fn_acct_entp(dpam_id,'BILL_START_DT'),103) between @pa_billing_from_dt and @pa_billing_to_dt

OPEN CUR  
FETCH NEXT FROM CUR INTO @@FORMNO,@@pa_values,@@voucher_dt  
WHILE @@FETCH_STATUS = 0  
BEGIN  

		set @@vch_no = 0
		SET @@SSQL = 'TRUNCATE TABLE #VOUCHERNO'
		SET @@SSQL = @@SSQL + ' INSERT INTO #VOUCHERNO SELECT TOP 1 LDG_VOUCHER_NO from ledger' + convert(varchar,@@FINID) + ' where LDG_VOUCHER_TYPE = 2 AND LDG_REF_NO = ''' + @@FORMNO + ''' AND LDG_CREATED_BY = ''BILLPROCESS'' AND LDG_DELETED_IND = 1 and LDG_DPM_ID = ' + CONVERT(VARCHAR,@pa_dpm_id)
		EXEC(@@SSQL)

		SELECT TOP 1 @@vch_no = ISNULL(VCHNO,0) FROM #VOUCHERNO

		IF (ISNULL(@@vch_no,0) = 0)
		BEGIN
			Exec pr_ins_upd_ledgerR '0','INS','BILLPROCESS',@pa_dpm_id,2,'01','',@@FORMNO,@@voucher_dt,@@pa_values,0,'*|~*','|*~|',''      
		END
		ELSE
		BEGIN
			Exec pr_ins_upd_ledgerR '0','EDT','BILLPROCESS',@pa_dpm_id,2,'01',@@vch_no,@@FORMNO,@@voucher_dt,@@pa_values,0,'*|~*','|*~|',''      
		END
FETCH NEXT FROM CUR INTO @@FORMNO,@@pa_values,@@voucher_dt
END
CLOSE CUR
DEALLOCATE CUR
DROP TABLE #VOUCHERNO
  
  --logic for charging for one time charges
  
  

  --logic for charging for fix charges
  
   insert into #temp_bill
	(trans_dt 
	,dpam_id  
	,charge_name 
   ,charge_val
   ,post_toacct)
   select citrus_usr.getfixedchargedate(accp_value,@pa_billing_from_dt,@pa_billing_to_dt,cham_bill_period,cham_bill_interval,@pa_excmid)
			,dpam_id
			,cham_slab_name
			,sum(cham_charge_value )*-1 
			,cham_post_toacct
			from dp_acct_mstr
				,client_dp_brkg
				,profile_charges
				,charge_mstr
                ,charge_ctgry_mapping,#account_properties left outer join #account_properties_close on accp_clisba_id = accp_clisba_id_cl
			where dpam_dpm_id = @pa_dpm_id and accp_clisba_id = dpam_id  
			--and   DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI')
			and   ( DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI') or @pa_billing_to_dt between  accp_value and isnull(accp_value_cl,'jan 31 2100'))
			and dpam_stam_cd not in ('CI','04','CLOS','05')
			AND   dpam_id     = clidb_dpam_id
            and   CHAM_SLAB_NO = chacm_cham_id
            and   case when chacm_subcm_cd = '0' then '0' else dpam_subcm_cd end = chacm_subcm_cd
			
			AND   citrus_usr.getfixedchargedate(accp_value,@pa_billing_from_dt,@pa_billing_to_dt,cham_bill_period,cham_bill_interval,@pa_excmid)  between clidb_eff_from_dt and clidb_eff_to_dt
			AND   clidb_brom_id = proc_profile_id
			AND   proc_slab_no  = cham_slab_no
			AND   cham_charge_type = 'F'
			AND   citrus_usr.getfixedchargedate(accp_value,@pa_billing_from_dt,@pa_billing_to_dt,cham_bill_period,cham_bill_interval,@pa_excmid) is not null
			and   cham_deleted_ind = 1
			and   clidb_deleted_ind = 1
			and   dpam_deleted_ind = 1
			and   proc_deleted_ind = 1
            and   CHAM_CHARGE_BASE = 'NORMAL'
			group by dpam_id , cham_slab_name , cham_post_toacct,CHAM_BILL_PERIOD,CHAM_BILL_INTERVAL,accp_value
  --logic for charging for fix charges
 
 if (select month(fin_start_dt) from financial_yr_mstr where @pa_billing_from_dt between FIN_START_DT and FIN_END_DT ) = month(@pa_billing_from_dt)
begin 

declare @l_dt datetime 
select @l_dt = fin_start_dt from financial_yr_mstr where @pa_billing_from_dt between FIN_START_DT and FIN_END_DT 
  insert into #temp_bill
	(trans_dt 
	,dpam_id  
	,charge_name 
   ,charge_val
   ,post_toacct)
   select @l_dt--citrus_usr.getfixedchargedate(accp_value,@pa_billing_from_dt,@pa_billing_to_dt,cham_bill_period,cham_bill_interval,@pa_excmid)
			,dpam_id
			,cham_slab_name
			,sum(cham_charge_value )*-1 
			,cham_post_toacct
			from dp_acct_mstr
				,client_dp_brkg
				,profile_charges
				,charge_mstr
                --,charge_ctgry_mapping
,#account_properties left outer join #account_properties_close on accp_clisba_id = accp_clisba_id_cl
			where dpam_dpm_id = @pa_dpm_id and accp_clisba_id = dpam_id  
			--and   DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI')
			and   ( DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI') or @pa_billing_to_dt between  accp_value and isnull(accp_value_cl,'jan 31 2100'))
			AND   dpam_id     = clidb_dpam_id
--            and   CHAM_SLAB_NO = chacm_cham_id
--            and   case when chacm_subcm_cd = '0' then '0' else dpam_subcm_cd end = chacm_subcm_cd
			and   @pa_billing_from_dt between clidb_eff_from_dt and clidb_eff_to_dt
            and   accp_value not between @pa_billing_from_dt and @pa_billing_to_dt
			--AND   citrus_usr.getfixedchargedate(accp_value,@pa_billing_from_dt,@pa_billing_to_dt,cham_bill_period,cham_bill_interval,@pa_excmid)  between clidb_eff_from_dt and clidb_eff_to_dt
			AND   clidb_brom_id = proc_profile_id
			AND   proc_slab_no  = cham_slab_no
			AND   cham_charge_type = 'AMCPROFIX'
			--AND   citrus_usr.getfixedchargedate(accp_value,@pa_billing_from_dt,@pa_billing_to_dt,cham_bill_period,cham_bill_interval,@pa_excmid) is not null
			and   cham_deleted_ind = 1
			and   clidb_deleted_ind = 1
			and   dpam_deleted_ind = 1
			and   proc_deleted_ind = 1
            and   CHAM_CHARGE_BASE = 'NORMAL'
			group by dpam_id , cham_slab_name , cham_post_toacct,CHAM_BILL_PERIOD,CHAM_BILL_INTERVAL,accp_value

end 



  --logic for charging for prorata AMC charges
declare @@months_to_charge bigint,
@@AMCPRORATA_INTERVAL char(1)
if exists(select fin_id from financial_yr_mstr where  FIN_START_DT between @pa_billing_from_dt and @pa_billing_to_dt and fin_deleted_ind = 1)
begin
		   insert into #temp_bill
			(trans_dt 
			,dpam_id  
			,charge_name 
		   ,charge_val
		   ,post_toacct)
			select @pa_billing_to_dt,dpam_id,cham_slab_name,cham_charge_value*-1,cham_post_toacct
			from dp_acct_mstr
			,client_dp_brkg
			,profile_charges
			,charge_mstr
			--,charge_ctgry_mapping
			,#account_properties left outer join #account_properties_close on accp_clisba_id = accp_clisba_id_cl
			where dpam_dpm_id = @pa_dpm_id and accp_clisba_id = dpam_id 
			--and   DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI')
			and   ( DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI') or @pa_billing_to_dt between  accp_value and isnull(accp_value_cl,'jan 31 2100'))
			--and isnull(accp_value_cl,'jan 31 2100') not between @pa_billing_from_dt and @pa_billing_to_dt
            and DPAM_STAM_CD  = 'active'
			AND   dpam_id     = clidb_dpam_id
--            and   CHAM_SLAB_NO = chacm_cham_id
--            and   case when chacm_subcm_cd = '0' then '0' else dpam_subcm_cd end = chacm_subcm_cd
			AND   @pa_billing_to_dt  between clidb_eff_from_dt and clidb_eff_to_dt
			AND   clidb_brom_id = proc_profile_id
			AND   proc_slab_no  = cham_slab_no

			AND   cham_charge_type = 'AMCPRO'
			and   accp_value <= @pa_billing_to_dt 
			and   cham_deleted_ind = 1
			and   clidb_deleted_ind = 1
			and   dpam_deleted_ind = 1
			and   proc_deleted_ind = 1
            and   CHAM_CHARGE_BASE = 'NORMAL'
			union all 
			select @pa_billing_to_dt,dpam_id,'CORPORATE AMC',500.00*-1,36
						from dp_acct_mstr
						,#account_properties left outer join #account_properties_close on accp_clisba_id = accp_clisba_id_cl
						where dpam_dpm_id = @pa_dpm_id and accp_clisba_id = dpam_id 
						--and   DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI')
						and   ( DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI') or @pa_billing_to_dt between  accp_value and isnull(accp_value_cl,'jan 31 2100'))
						--and isnull(accp_value_cl,'jan 31 2100') not between @pa_billing_from_dt and @pa_billing_to_dt
						and DPAM_STAM_CD  = 'active'
						and   accp_value <= @pa_billing_to_dt 
						and   cham_deleted_ind = 1
						and   clidb_deleted_ind = 1
						and   dpam_deleted_ind = 1
						and   proc_deleted_ind = 1
						and   CHAM_CHARGE_BASE = 'NORMAL'
				and   dpam_subcm_Cd in ('022552','022551','022543','022541'
				,'022538','022536','022523','022522','022521','022520'
				,'022519','022518','022517','022516','022515','022514'
				,'022513','022512','022567','022576','042207','042206'
				,'042205','052309','052308','052334','062826','242977','242927')
end
else
begin

			/*
			INSERT INTO BITMAP_REF_MSTR
			SELECT MAX(BITRM_ID) + 1,BITRM_PARENT_CD='AMCPRORATA',BITRM_CHILD_CD='',BITRM_BIT_LOCATION=NULL,BITRM_VALUES='M',BITRM_TAB_TYPE='',BITRM_CREATED_BY='MIG',BITRM_CREATED_DT=GETDATE(),BITRM_LST_UPD_BY='MIG',BITRM_LST_UPD_DT=GETDATE(),BITRM_DELETED_IND=1  FROM BITMAP_REF_MSTR
			*/
		   SELECT @@AMCPRORATA_INTERVAL = ISNULL(BITRM_VALUES,'') FROM BITMAP_REF_MSTR WHERE BITRM_PARENT_CD='AMCPRORATA' AND BITRM_DELETED_IND = 1
		   IF @@AMCPRORATA_INTERVAL = 'M' -- M for monthly
		   BEGIN
				select @@months_to_charge = datediff(m,@pa_billing_to_dt,fin_end_dt) + 1 from financial_yr_mstr where  @pa_billing_to_dt between fin_start_dt and fin_end_dt and fin_deleted_ind = 1
		   END 
		   ELSE -- D for daily
		   BEGIN
				select @@months_to_charge = datediff(d,@pa_billing_to_dt,fin_end_dt) + 1 from financial_yr_mstr where @pa_billing_to_dt between fin_start_dt and fin_end_dt and fin_deleted_ind = 1
		   END

			   insert into #temp_bill
				(trans_dt 
				,dpam_id  
				,charge_name 
			   ,charge_val
			   ,post_toacct)
				select @pa_billing_to_dt,dpam_id,cham_slab_name,(cham_charge_value/(case when @@AMCPRORATA_INTERVAL = 'M' then 12 else 365 end))*isnull(@@months_to_charge,0)*-1,cham_post_toacct
				from dp_acct_mstr
				,client_dp_brkg
				,profile_charges
				,charge_mstr
				,#account_properties  left outer join #account_properties_close on accp_clisba_id = accp_clisba_id_cl   
				where dpam_dpm_id = @pa_dpm_id and dpam_id = accp_clisba_id 
				--and   DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI')
				and   ( DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI') or @pa_billing_to_dt between  accp_value and isnull(accp_value_cl,'jan 31 2100'))
				and dpam_stam_cd not in ('CI','04','CLOS','05')
				AND   dpam_id     = clidb_dpam_id
				AND   @pa_billing_to_dt  between clidb_eff_from_dt and clidb_eff_to_dt
				AND   clidb_brom_id = proc_profile_id
				AND   proc_slab_no  = cham_slab_no
				AND   cham_charge_type = 'AMCPRO'
				and   CHAM_CHARGE_BASE = 'NORMAL'
				and   accp_value between @pa_billing_from_dt and @pa_billing_to_dt 
				and   cham_deleted_ind = 1
				and   clidb_deleted_ind = 1
				and   dpam_deleted_ind = 1
				and   proc_deleted_ind = 1
				union all
				select @pa_billing_to_dt,dpam_id,'CORPORATE AMC',(500.00/(case when @@AMCPRORATA_INTERVAL = 'M' then 12 else 365 end))*isnull(@@months_to_charge,0)*-1,36
				from dp_acct_mstr
				,#account_properties  left outer join #account_properties_close on accp_clisba_id = accp_clisba_id_cl   
				where dpam_dpm_id = @pa_dpm_id and dpam_id = accp_clisba_id 
				--and   DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI')
				and   ( DPAM_STAM_CD not in('05','04','08','02_BILLSTOP','CI') or @pa_billing_to_dt between  accp_value and isnull(accp_value_cl,'jan 31 2100'))
				and		dpam_stam_cd not in ('CI','04','CLOS','05')
				and   accp_value between @pa_billing_from_dt and @pa_billing_to_dt
				and   dpam_deleted_ind = 1
				and   dpam_subcm_Cd in ('022552','022551','022543','022541'
				,'022538','022536','022523','022522','022521','022520'
				,'022519','022518','022517','022516','022515','022514'
				,'022513','022512','022567','022576','042207','042206'
				,'042205','052309','052308','052334','062826','242977','242927')

			

end
  --logic for charging for prorata AMC charges

   
  
  --logic for account closure charge
  
  insert into #temp_bill  
		  (trans_dt   
		  ,dpam_id    
		  ,charge_name   
		  ,charge_val
		  ,post_toacct)  
		  select clsr_date  
		  ,clsr_dpam_id  
		  ,cham_slab_name  
		  ,sum(cham_charge_value )  * -1 
		  ,cham_post_toacct
		  from closure_acct_mstr
		      ,client_dp_brkg  
		      ,profile_charges  
		      ,charge_mstr 
              ,dp_acct_mstr 
              ,charge_ctgry_mapping 
		  where clsr_dpm_id   = @pa_dpm_id   
          and   clsr_dpam_id  = dpam_id
		  AND   clsr_dpam_id  = clidb_dpam_id 
          and   CHAM_SLAB_NO = chacm_cham_id
          and   case when chacm_subcm_cd = '0' then '0' else dpam_subcm_cd end = chacm_subcm_cd
		  and 	 clsr_date between @pa_billing_from_dt and @pa_billing_to_dt 
		  and   clsr_status = '3' 
		  AND   clsr_date >= clidb_eff_from_dt and  clsr_date <= clidb_eff_to_dt  
		  AND   clidb_brom_id = proc_profile_id  
		  AND   proc_slab_no  = cham_slab_no  
		  AND   cham_charge_type = 'A'  
		  and   cham_deleted_ind = 1  
		  and   clidb_deleted_ind = 1  
		  and   clsr_deleted_ind = 1 
		  and   proc_deleted_ind = 1  
		and   CHAM_CHARGE_BASE = 'NORMAL'
    group by clsr_dpam_id , clsr_date, cham_slab_name  , cham_post_toacct

  --logic for account closure charge
  
  --logic for holding charge
  
    insert into #temp_bill  
				(trans_dt   
				,dpam_id    
				,charge_name   
				,charge_val
				,post_toacct) 
				select @pa_billing_to_dt
				,dphmc_dpam_id
				,cham_slab_name
				,Charge_amt=COUNT(dphmc_isin) * cham_charge_value   * -1 
				,cham_post_toacct
				 from dp_hldg_mstr_cdsl
				 ,dp_acct_mstr
			     ,client_dp_brkg  
				,profile_charges  
				,charge_mstr 
				where DPHMC_dpm_id= @pa_dpm_id
				and   dphmc_dpam_id = dpam_id
				and   DPAM_STAM_CD not in('05','04','08','02_BILLSTOP')
				AND   DPHMC_HOLDING_DT = @pa_billing_to_dt
				AND   DPHMC_HOLDING_DT >= clidb_eff_from_dt and  DPHMC_HOLDING_DT <= clidb_eff_to_dt  
				AND   DPHMC_dpam_id = clidb_dpam_id
               	AND   clidb_brom_id = proc_profile_id  
				AND   proc_slab_no  = cham_slab_no  
				AND   isnull(cham_charge_graded,0) <> 1  
				AND   cham_charge_type           = 'H'   
				and   cham_deleted_ind = 1  
				and   clidb_deleted_ind = 1  
				and   proc_deleted_ind = 1
				AND    DPHMC_DELETED_IND =1  
                and   CHAM_CHARGE_BASE = 'NORMAL'
				 group by dphmc_dpam_id,cham_slab_name,CHAM_POST_TOACCT,DPHMC_ISIN,cham_charge_value,cham_from_factor,cham_to_factor
				 having COUNT(dphmc_isin) >= 0  and COUNT(dphmc_isin) <= cham_to_factor   
     
  --logic for holding charge
  

  
  --logic for transaction type wise charge
  /*MIN MAX CHARGES LOGIC*/
insert into #temp_bill
(trans_dt 
,dpam_id  
,charge_name 
,charge_val
,post_toacct)
SELECT dt  
,CDSHM_DPAM_ID  
,B.cham_slab_name  
,CASE WHEN SUM(CHARGE) >= CHAM_PER_MAX THEN CHAM_PER_MAX* -1  
      WHEN SUM(CHARGE) <= CHAM_PER_min THEN CHAM_PER_min*-1
      ELSE SUM(CHARGE)*-1 END 
,B.cham_post_toacct 
FROM (
select citrus_usr.getfixedchargedate(CONVERT(DATETIME,citrus_usr.fn_acct_entp(CLIDB_dpam_id,'BILL_START_DT'),103),@pa_billing_from_dt  ,@pa_billing_to_dt  ,cham_bill_period,cham_bill_interval,@pa_excmid)   dt
,CDSHM_DPAM_ID  
,ABS(isnull(cham_charge_value ,0)) CHARGE
,CHAM_SLAB_NO SLAB
from cdsl_holding_dtls      
,client_dp_brkg
,profile_charges
,charge_mstr 
where cdshm_dpm_id = @pa_dpm_id
AND   citrus_usr.getfixedchargedate(CONVERT(DATETIME,citrus_usr.fn_acct_entp(CLIDB_dpam_id,'BILL_START_DT'),103),@pa_billing_from_dt  ,@pa_billing_to_dt  ,cham_bill_period,cham_bill_interval,@pa_excmid)  between  DATEADD(month, cham_bill_interval*-1, @pa_billing_from_dt)  and @pa_billing_to_dt 
AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
AND   cdshm_dpam_id = clidb_dpam_id 
AND   clidb_brom_id = proc_profile_id
AND   proc_slab_no  = cham_slab_no
AND   isnull(cham_charge_graded,0) <> 1
AND   cham_charge_baseon           = 'TQ' 
AND   cham_charge_type = cdshm_tratm_type_desc
AND   (abs(cdshm_qty) >= cham_from_factor)  and (abs(cdshm_qty) <= cham_to_factor)  
AND   cdshm_tratm_cd in ('2277')
and   cham_deleted_ind = 1
and   clidb_deleted_ind = 1
and   cdshm_deleted_ind = 1
and   proc_deleted_ind = 1
and   isnull(CHAM_PER_MAX,'0') <> '0'
and   isnull(CHAM_PER_min,'0') <> '0'
AND   citrus_usr.getfixedchargedate(CONVERT(DATETIME,citrus_usr.fn_acct_entp(CLIDB_dpam_id,'BILL_START_DT'),103),@pa_billing_from_dt  ,@pa_billing_to_dt  ,cham_bill_period,cham_bill_interval,@pa_excmid)  between clidb_eff_from_dt and clidb_eff_to_dt   
	and   CHAM_CHARGE_BASE = 'PERIODIC' ) A , CHARGE_MSTR B WHERE CHAM_SLAB_NO = SLAB
GROUP BY CDSHM_DPAM_ID,dt
,B.cham_slab_name, B.cham_from_factor
,B.cham_to_factor,cham_charge_value 
,B.cham_post_toacct ,B.CHAM_PER_MIN, B.CHAM_PER_MAX,CDSHM_DPAM_ID
,B.cham_bill_period,B.cham_bill_interval 
/*MIN MAX CHARGES LOGIC*/
  ----transaction value wise charge
  ------
 

        update cdsl_holding_dtls
        set    cdshm_charge   =  
                 isnull(case when cham_val_pers  = 'V' then cham_charge_value * -1 
			          else case when (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt) + isnull(CHAM_PER_MIN,0) <= cham_charge_minval then cham_charge_minval* -1
			               else (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt)* -1  + isnull(CHAM_PER_MIN,0)* -1 end
			          end  ,0)  
			    ,cdshm_post_toacct = CHAM_POST_TOACCT
			      from cdsl_holding_dtls      
			          ,client_dp_brkg
					  ,profile_charges
					  ,charge_mstr 
			          ,closing_price_mstr_cdsl
                   
			      where cdshm_dpm_id = @pa_dpm_id
				  AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
                  and   clopm_dt      = cdshm_tras_dt 
                  AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
			      AND   cdshm_dpam_id = clidb_dpam_id 
			      AND   clidb_brom_id = proc_profile_id
			      AND   proc_slab_no  = cham_slab_no
			      AND   isnull(cham_charge_graded,0) <> 1
			      AND   cham_charge_baseon           = 'TV' 
			      --AND   cham_charge_type = cdshm_tratm_type_desc
				AND   cham_charge_type = case when cdshm_tratm_type_desc   = 'OF-DR' and CDSHM_COUNTER_BOID in (select account from SPECIFIED_ACCOUNT_LIST where cm_ben='B')  then  'OF-DR(SAC)'
												when cdshm_tratm_type_desc = 'OF-DR' and (CDSHM_COUNTER_DPID in (select account from SPECIFIED_ACCOUNT_LIST where cm_ben='C')
																							or  CDSHM_COUNTER_CMBPID in (select account from SPECIFIED_ACCOUNT_LIST where cm_ben='C') 
																							or CDSHM_COUNTER_DPID in (select account from SPECIFIED_ACCOUNT_LIST where cm_ben='cmbp')
																							or  CDSHM_COUNTER_CMBPID in (select account from SPECIFIED_ACCOUNT_LIST where cm_ben='cmbp') ) 	  then  'OF-DR(SCM)'
												when cdshm_tratm_type_desc = 'OF-DR' and CDSHM_COUNTER_CMBPID in (select dpam_sba_no from dp_acct_mstr where dpam_clicm_cd = '26' and dpam_stam_cd='ACTIVE')  then  'OF-DR(TOCM)'
												when cdshm_tratm_type_desc = 'OF-DR' and CDSHM_COUNTER_BOID <> '' and  not exists(select dpm_id from dp_mstr where dpm_dpid = left(CDSHM_COUNTER_BOID,8) and default_dp = dpm_excsm_id )  then  'OF-DR(INTER)'

												when cdshm_tratm_type_desc = 'INTDEP-DR' and CDSHM_COUNTER_BOID in (select account from SPECIFIED_ACCOUNT_LIST where cm_ben='B')  then  'INTDEP-DR(SAC)'
												when cdshm_tratm_type_desc = 'INTDEP-DR' and (CDSHM_COUNTER_DPID in (select account from SPECIFIED_ACCOUNT_LIST where cm_ben='C')
																							or  CDSHM_COUNTER_CMBPID in (select account from SPECIFIED_ACCOUNT_LIST where cm_ben='C') 
																							or CDSHM_COUNTER_DPID in (select account from SPECIFIED_ACCOUNT_LIST where cm_ben='cmbp')
																							or  CDSHM_COUNTER_CMBPID in (select account from SPECIFIED_ACCOUNT_LIST where cm_ben='cmbp') ) 	  then  'INTDEP-DR(SCM)'
												when cdshm_tratm_type_desc = 'INTDEP-DR' and CDSHM_COUNTER_CMBPID in (select dpam_sba_no from dp_acct_mstr where dpam_clicm_cd = '26' and dpam_stam_cd='ACTIVE') then  'INTDEP-DR(TOCM)'

												else  cdshm_tratm_type_desc end 


			      AND   cdshm_isin       = clopm_isin_cd  
				 and cdshm_tratm_type_desc <> 'PLEDGE'
			     --AND   (abs(cdshm_qty)*clopm_cdsl_rt >= 0)  and (abs(cdshm_qty)*clopm_cdsl_rt <= cham_to_factor)  
			      AND   cdshm_tratm_cd in ('2277')
			      and   cham_deleted_ind = 1
				  and   clidb_deleted_ind = 1
				  and   cdshm_deleted_ind = 1
                  and   CHAM_CHARGE_BASE = 'NORMAL' 
			      and   proc_deleted_ind = 1
			      and   clopm_deleted_ind = 1
				--  AND   CDSHM_COUNTER_BOID NOT IN ('1206210000002228','1206210000002209')
--citrus_usr.fn_get_charge_list(cdshm_dpam_id ,'apr 01 2012','apr 30 2012','OF-DR(SAC)')='Y'
  


update cdsl_holding_dtls
        set    cdshm_charge   =  
                 isnull(case when cham_val_pers  = 'V' then cham_charge_value * -1 
			          else case when (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt) <= cham_charge_minval then cham_charge_minval* -1
			               else (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt)* -1 end
			          end  ,0)
			    ,cdshm_post_toacct = CHAM_POST_TOACCT
			      from cdsl_holding_dtls      
			          ,client_dp_brkg
					  ,profile_charges
					  ,charge_mstr 
			          ,closing_price_mstr_cdsl
                   
			      where cdshm_dpm_id = @pa_dpm_id
				  AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
                  and   clopm_dt      = cdshm_tras_dt 
                  AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
			      AND   cdshm_dpam_id = clidb_dpam_id 
			      AND   clidb_brom_id = proc_profile_id
			      AND   proc_slab_no  = cham_slab_no
			      AND   isnull(cham_charge_graded,0) <> 1
			      AND   cham_charge_baseon           = 'INST' 
			      AND   cham_charge_type = CASE WHEN cdshm_tratm_type_desc in ('AUTO PLEDGE','UNPLEDGE') THEN 'PLEDGE_CLOSURE' ELSE cdshm_tratm_type_desc END 
				  and cdshm_tratm_type_desc IN ('PLEDGE','AUTO PLEDGE','UNPLEDGE')
				  AND   cdshm_isin       = clopm_isin_cd  
			      AND   (abs(cdshm_qty)*clopm_cdsl_rt >= 0)  and (abs(cdshm_qty)*clopm_cdsl_rt <= cham_to_factor)  
			      AND   cdshm_tratm_cd in ('2270','2280')
			      and   cham_deleted_ind = 1
				  --and   CDSHM_CDAS_TRAS_TYPE <> '8'
				  and   CDSHM_TRATM_DESC not like '%Pledge Rejection%'
				  and   clidb_deleted_ind = 1
				  and   cdshm_deleted_ind = 1
                  and   CHAM_CHARGE_BASE = 'NORMAL' 
			      and   proc_deleted_ind = 1
			      and   clopm_deleted_ind = 1
				--  AND   CDSHM_COUNTER_BOID NOT IN ('1206210000002228','1206210000002209')

			      

 update cdsl_holding_dtls
        set    cdshm_charge   =  
                 isnull(case when cham_val_pers  = 'V' then cham_charge_value * -1 
			          else case when (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt) <= cham_charge_minval then cham_charge_minval* -1
			               else (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt)* -1 end
			          end  ,0)
			    ,cdshm_post_toacct = CHAM_POST_TOACCT
			      from cdsl_holding_dtls      
			          ,client_dp_brkg
					  ,profile_charges
					  ,charge_mstr 
			          ,closing_price_mstr_cdsl
                   
			      where cdshm_dpm_id = @pa_dpm_id
				  AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
                  and   clopm_dt      = cdshm_tras_dt 
                  AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
			      AND   cdshm_dpam_id = clidb_dpam_id 
			      AND   clidb_brom_id = proc_profile_id
			      AND   proc_slab_no  = cham_slab_no
			      AND   isnull(cham_charge_graded,0) <> 1
			      AND   cham_charge_baseon           = 'TV' 
			      AND   cham_charge_type = 'OF-DR-POOL'
			      AND   cdshm_isin       = clopm_isin_cd  
			      AND   (abs(cdshm_qty)*clopm_cdsl_rt >= 0)  and (abs(cdshm_qty)*clopm_cdsl_rt <= cham_to_factor)  
			      AND   cdshm_tratm_cd in ('2277')
			      and   cham_deleted_ind = 1
				  and   clidb_deleted_ind = 1
				  and   cdshm_deleted_ind = 1
                  and   CHAM_CHARGE_BASE = 'NORMAL' 
			      and   proc_deleted_ind = 1
			      and   clopm_deleted_ind = 1
				  AND   CDSHM_COUNTER_BOID IN ('1206210000002228','1206210000002209')
 
  ------
					update cdsl_holding_dtls
					set    cdshm_charge   =  isnull(cdshm_charge,0) +
				     isnull(case when cham_val_pers  = 'V' then cham_charge_value * -1
		          else case when (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt)  + isnull(CHAM_PER_MIN,0) <= cham_charge_minval then cham_charge_minval *-1 
		               else (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt)* -1 + isnull(CHAM_PER_MIN,0)*-1 end
		          end  ,0)
		      ,cdshm_post_toacct = CHAM_POST_TOACCT
				      from cdsl_holding_dtls      
				          ,client_dp_brkg
						,profile_charges
						,charge_mstr 
				          ,closing_price_mstr_cdsl
                      where cdshm_dpm_id = @pa_dpm_id
						   	AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
										and   clopm_dt      = cdshm_tras_dt 
										AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
				      AND   cdshm_dpam_id = clidb_dpam_id 
                      AND   clidb_brom_id = proc_profile_id
				      AND   proc_slab_no  = cham_slab_no
				      AND   isnull(cham_charge_graded,0) <> 1
				      AND   cham_charge_baseon           = 'TV' 
				      AND   cham_charge_type = 'EXCHPAYIN'
				      AND   cdshm_tratm_type_desc in ('NSCCL-DR','CSECH-DR','BSECH-DR','ASECH-DR','OTCEI-DR','DSECH-DR','BSEBOPAYIN-DR','BO')
				      AND   cdshm_isin       = clopm_isin_cd
				      AND   (abs(cdshm_qty)*clopm_cdsl_rt >= 0)  and (abs(cdshm_qty)*clopm_cdsl_rt <= cham_to_factor)  
				      AND   cdshm_tratm_cd = '2277'
				      and   cham_deleted_ind = 1
                      and   CHAM_CHARGE_BASE = 'NORMAL'
										and   clidb_deleted_ind = 1
										and   cdshm_deleted_ind = 1
				      and   proc_deleted_ind = 1
				      and   clopm_deleted_ind = 1
		      
			

  
		------
			      update cdsl_holding_dtls
			        set    cdshm_charge   =  isnull(cdshm_charge,0) +
				 isnull(case when cham_val_pers  = 'V' then cham_charge_value* -1  
		          else case when (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt) <= cham_charge_minval then cham_charge_minval* -1 
			               else (cham_charge_value/100)*(abs(cdshm_qty)*clopm_cdsl_rt)* -1 end
			          end    ,0)
			     ,cdshm_post_toacct = CHAM_POST_TOACCT
									from cdsl_holding_dtls      
													,client_dp_brkg
													,profile_charges
													,charge_mstr 
													,closing_price_mstr_cdsl
                                where cdshm_dpm_id = @pa_dpm_id
								AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
								and   clopm_dt      = cdshm_tras_dt 
								AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
								AND   cdshm_dpam_id = clidb_dpam_id 
								AND   clidb_brom_id = proc_profile_id
								AND   proc_slab_no  = cham_slab_no
								AND   isnull(cham_charge_graded,0) <> 1
								AND   cham_charge_baseon           = 'TV' 
								AND   cham_charge_type = 'EXCHPAYOUT'
								AND   cdshm_tratm_type_desc in ('NSCCL-CR','CSECH-CR','BSECH-CR','ASECH-CR','OTCEI-CR','DSECH-CR')
								AND   cdshm_isin       = clopm_isin_cd 
								AND   (abs(cdshm_qty)*clopm_cdsl_rt >= 0)  and (abs(cdshm_qty)*clopm_cdsl_rt <= cham_to_factor)  
								AND   cdshm_tratm_cd ='2246'
								and   cham_deleted_ind = 1
								and   clidb_deleted_ind = 1
                                and   CHAM_CHARGE_BASE = 'NORMAL'
								and   cdshm_deleted_ind = 1
								and   proc_deleted_ind = 1
								and   clopm_deleted_ind = 1
			      
		------
  ----transaction value wise charge\
  
  ----transaction qty wise charge
  
			if exists(select bitrm_id from bitmap_ref_mstr where bitrm_parent_cd = 'OFF_DR_INTERNAL_CHARGE')
			begin

			   update cdsl_holding_dtls
							 set    cdshm_charge   =  isnull(cdshm_charge,0) +
							 (isnull(cham_charge_value,0) * -1 )
,cdshm_post_toacct = CHAM_POST_TOACCT
							from cdsl_holding_dtls      
							,client_dp_brkg
							,profile_charges
							,charge_mstr 
							where cdshm_dpm_id = @pa_dpm_id
							AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
							AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
							AND   cdshm_dpam_id = clidb_dpam_id 
							AND   clidb_brom_id = proc_profile_id
							AND   proc_slab_no  = cham_slab_no
               				AND   isnull(cham_charge_graded,0) <> 1
							AND   cham_charge_baseon           = 'TQ' 
							AND   cham_charge_type = cdshm_tratm_type_desc
							AND   (abs(cdshm_qty) >= 0)  and (abs(cdshm_qty) <= cham_to_factor)  
							AND   cham_charge_type <> 'DEMAT'
							AND   cdshm_tratm_cd = '2277'
							and   cham_deleted_ind = 1
							and   clidb_deleted_ind = 1
							and   cdshm_deleted_ind = 1
							and   proc_deleted_ind = 1
							and   CHAM_CHARGE_BASE = 'NORMAL'
							and   (CDSHM_COUNTER_BOID not in (select trg_boid from Client_Cm_details where trg_boid <>'') and 
              (CDSHM_COUNTER_CMBPID not in (select trg_cmbpid from Client_Cm_details where trg_cmbpid <>'') and 
              CDSHM_COUNTER_DPID not in (select trg_cmbpid from Client_Cm_details where trg_cmbpid <>'' )))
			 
			end 
			else
			begin

							update cdsl_holding_dtls
							 set    cdshm_charge   =  isnull(cdshm_charge,0) +
							 (isnull(cham_charge_value,0) * -1 )
,cdshm_post_toacct = CHAM_POST_TOACCT
							from cdsl_holding_dtls      
							,client_dp_brkg
							,profile_charges
							,charge_mstr 
							where cdshm_dpm_id = @pa_dpm_id
							AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
							AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
							AND   cdshm_dpam_id = clidb_dpam_id 
							AND   clidb_brom_id = proc_profile_id
							AND   proc_slab_no  = cham_slab_no
               				AND   isnull(cham_charge_graded,0) <> 1
							AND   cham_charge_baseon           = 'TQ' 
							AND   cham_charge_type = cdshm_tratm_type_desc
							AND   (abs(cdshm_qty) >= 0)  and (abs(cdshm_qty) <= cham_to_factor)  
							AND   cham_charge_type <> 'DEMAT'
							AND   cdshm_tratm_cd = '2277'
							and   cham_deleted_ind = 1
							and   clidb_deleted_ind = 1
							and   cdshm_deleted_ind = 1
							and   proc_deleted_ind = 1
							and   CHAM_CHARGE_BASE = 'NORMAL'

			end 

/*

				 update cdsl_holding_dtls
			     set    cdshm_charge   =  isnull(cdshm_charge,0) +
				 (isnull(cham_charge_value,0) * -1 )
				from cdsl_holding_dtls      
				,client_dp_brkg
				,profile_charges
				,charge_mstr 
				where cdshm_dpm_id = @pa_dpm_id
				AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
			    AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
				AND   cdshm_dpam_id = clidb_dpam_id 
				AND   clidb_brom_id = proc_profile_id
				AND   proc_slab_no  = cham_slab_no
               	AND   isnull(cham_charge_graded,0) <> 1
				AND   cham_charge_baseon           = 'TQ' 
				AND   cham_charge_type = cdshm_tratm_type_desc
				AND   (abs(cdshm_qty) >= cham_from_factor)  and (abs(cdshm_qty) <= cham_to_factor)  
				AND   cham_charge_type = 'DEMAT'
				AND   cdshm_tratm_cd = '2246'
				and   cham_deleted_ind = 1
				and   clidb_deleted_ind = 1
				and   cdshm_deleted_ind = 1
				and   proc_deleted_ind = 1
                and   CHAM_CHARGE_BASE = 'NORMAL'

*/
insert into #temp_bill
(trans_dt 
,dpam_id  
,charge_name 
,charge_val
,post_toacct)
 select CDSHM_TRAS_DT,
clidb_dpam_id,'DEMAT COURIER CHARGE',
(isnull(cham_charge_value,0) * -1 ), CHAM_POST_TOACCT
from cdsl_holding_dtls      
,client_dp_brkg
,profile_charges
,charge_mstr 
where cdshm_dpm_id = @pa_dpm_id
AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
AND   cdshm_dpam_id = clidb_dpam_id 
AND   clidb_brom_id = proc_profile_id
AND   proc_slab_no  = cham_slab_no
AND   isnull(cham_charge_graded,0) <> 1
AND   cham_charge_baseon           = 'TQ' 
AND   cham_charge_type = cdshm_tratm_type_desc
AND   (abs(cdshm_qty) >= cham_from_factor)  and (abs(cdshm_qty) <= cham_to_factor)  
AND   cham_charge_type = 'DEMAT'
AND   cdshm_tratm_cd = '2201'
and   cham_deleted_ind = 1
and   clidb_deleted_ind = 1
and   cdshm_deleted_ind = 1
and   proc_deleted_ind = 1
and   CHAM_CHARGE_BASE = 'NORMAL'

insert into #temp_bill
(trans_dt 
,dpam_id  
,charge_name 
,charge_val
,post_toacct)
 select CDSHM_TRAS_DT,
clidb_dpam_id,'DEMAT REJECTION CHARGE',
(isnull(cham_charge_value,0) * -1 ), CHAM_POST_TOACCT
from cdsl_holding_dtls      
,client_dp_brkg
,profile_charges
,charge_mstr 
where cdshm_dpm_id = @pa_dpm_id
AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
AND   cdshm_dpam_id = clidb_dpam_id 
AND   clidb_brom_id = proc_profile_id
AND   proc_slab_no  = cham_slab_no
AND   isnull(cham_charge_graded,0) <> 1
AND   cham_charge_baseon           = 'CQ' 
AND   case when cham_charge_type = 'DMAT_REJ' then 'DEMAT' else cham_charge_type end = cdshm_tratm_type_desc
AND   (abs(cdshm_qty) >= cham_from_factor)  and (abs(cdshm_qty) <= cham_to_factor)  
AND   cham_charge_type = 'DMAT_REJ'
--AND   cdshm_tratm_cd = '3102'
AND   (cdshm_tratm_cd = '3102' or (cdshm_tratm_cd = '2251' and  cdshm_cdas_sub_tras_type = '607'))
and   cham_deleted_ind = 1
and   clidb_deleted_ind = 1
and   cdshm_deleted_ind = 1
and   proc_deleted_ind = 1
and   CHAM_CHARGE_BASE = 'NORMAL'





				update cdsl_holding_dtls
					set    cdshm_charge   =  isnull(cdshm_charge,0) +
					(isnull(cham_charge_value,0)* -1)
,cdshm_post_toacct = CHAM_POST_TOACCT
					from cdsl_holding_dtls      
					,client_dp_brkg
					,profile_charges
					,charge_mstr 
					where cdshm_dpm_id = @pa_dpm_id
					AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
					AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
					AND   cdshm_dpam_id = clidb_dpam_id 
					AND   clidb_brom_id = proc_profile_id
					AND   proc_slab_no  = cham_slab_no
					AND   isnull(cham_charge_graded,0) <> 1
					AND   cham_charge_baseon           = 'CQ' 
					AND   cham_charge_type = 'REMAT'
					AND   cdshm_tratm_type_desc = cham_charge_type 
					AND   (abs(cdshm_qty) >= 0)  and (abs(cdshm_qty) <= cham_to_factor)  
					AND   cdshm_tratm_cd = '2205'
					and   cham_deleted_ind = 1
					and   clidb_deleted_ind = 1
					and   cdshm_deleted_ind = 1
					and   proc_deleted_ind = 1
                    and   CHAM_CHARGE_BASE = 'NORMAL'
 
 
					update cdsl_holding_dtls
					set    cdshm_charge   =  isnull(cdshm_charge,0) +
					(isnull(cham_charge_value,0)* -1)
,cdshm_post_toacct = CHAM_POST_TOACCT
					from cdsl_holding_dtls      
					,client_dp_brkg
					,profile_charges
					,charge_mstr 
					where cdshm_dpm_id = @pa_dpm_id
					AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
					AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
					AND   cdshm_dpam_id = clidb_dpam_id 
					AND   clidb_brom_id = proc_profile_id
					AND   proc_slab_no  = cham_slab_no
					AND   isnull(cham_charge_graded,0) <> 1
					AND   cham_charge_baseon           = 'TQ' 
					AND   cham_charge_type = 'EXCHPAYIN'
					AND   cdshm_tratm_type_desc in ('NSCCL-DR','CSECH-DR','BSECH-DR','ASECH-DR','OTCEI-DR','DSECH-DR')
					AND   (abs(cdshm_qty) >= 0)  and (abs(cdshm_qty) <= cham_to_factor)  
					AND   cdshm_tratm_cd = '2277'
					and   cham_deleted_ind = 1
					and   clidb_deleted_ind = 1
					and   cdshm_deleted_ind = 1
					and   proc_deleted_ind = 1
                    and   CHAM_CHARGE_BASE = 'NORMAL'
 


					--slab added for same day payin & execution for slip
					update cdsl_holding_dtls
					set    cdshm_charge   =  isnull(cdshm_charge,0) +
					(isnull(cham_charge_value,0)* -1)
,cdshm_post_toacct = CHAM_POST_TOACCT
					from cdsl_holding_dtls      
					,dp_trx_dtls_cdsl
					,settlement_mstr 
					,client_dp_brkg
					,profile_charges
					,charge_mstr
					where cdshm_dpm_id = @pa_dpm_id
					AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
					and   cdshm_trans_no = dptdc_trans_no
					and   convert(varchar,cdshm_dpam_id ) = convert(varchar,dptdc_dpam_id)
					and   cdshm_tras_dt = dptdc_execution_dt
					and   cdshm_isin   = dptdc_isin
					and   dptdc_request_dt = dptdc_execution_dt
					and   dptdc_other_settlement_type = convert(varchar,setm_settm_id )
					and	  dptdc_other_settlement_no = setm_no   
					and	  convert(varchar(11),dptdc_request_dt,109) = convert(varchar(11),SETM_PAYIN_DT,109)  
					AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
					AND   cdshm_dpam_id = clidb_dpam_id 
					AND   clidb_brom_id = proc_profile_id
					AND   proc_slab_no  = cham_slab_no
					AND   isnull(cham_charge_graded,0) <> 1
					AND   cham_charge_baseon           = 'TQ' 
					AND   cham_charge_type = 'EXCHPAYIN_SAMEDAY_PAYIN'
					AND   cdshm_tratm_type_desc in ('NSCCL-DR','CSECH-DR','BSECH-DR','ASECH-DR','OTCEI-DR','DSECH-DR')
					AND   (abs(cdshm_qty) >= 0)  and (abs(cdshm_qty) <= cham_to_factor)  
					AND   cdshm_tratm_cd = '2277'
					and   cham_deleted_ind = 1
					and   clidb_deleted_ind = 1
					and   cdshm_deleted_ind = 1
					and   proc_deleted_ind =  1
					and   dptdc_deleted_ind = 1
                    and   CHAM_CHARGE_BASE = 'NORMAL'
					--slab added for same day payin & execution for slip

---- SLAB NSE POOL A/C & BSE PRINCIPLE A/C to fix the POA charges 10 Rs -- FEB 26 2010
--
--                            update cdsl_holding_dtls
--							set    cdshm_charge   =  10 * -1 
--							from cdsl_holding_dtls      
--							
--							where cdshm_dpm_id = @pa_dpm_id
--							AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
--							--AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
--							and   cdshm_deleted_ind = 1							
--							and   cdshm_tratm_cd='2277'
--							AND   CDSHM_COUNTER_BOID IN ('1206210000002228','1206210000002209')
--
---- SLAB NSE POOL A/C & BSE PRINCIPLE A/C to fix the POA charges 10 Rs  FEB 26 2010


					--slab added for same day execution after notified timings for slip -- not complete
print '2'
					declare @notified_time varchar(8)
				
					select @notified_time=ISNULL(bitrm_values,'') from bitmap_ref_mstr where BITRM_PARENT_CD = 'CDSL_NOTIFIED_TM'
					if ltrim(rtrim(isnull(@notified_time,''))) <> ''
					begin
								update cdsl_holding_dtls
								set    cdshm_charge   =  isnull(cdshm_charge,0) +
								(isnull(cham_charge_value,0)* -1)
,cdshm_post_toacct = CHAM_POST_TOACCT
								from cdsl_holding_dtls      
								,dp_trx_dtls_cdsl
								,client_dp_brkg
								,profile_charges
								,charge_mstr
								where cdshm_dpm_id = @pa_dpm_id
								AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
								and   cdshm_trans_no = dptdc_trans_no
								and   cdshm_dpam_id  = dptdc_dpam_id
								and   cdshm_tras_dt = dptdc_execution_dt
								and   cdshm_isin   = dptdc_isin
								and   dptdc_request_dt = dptdc_execution_dt
								and   CONVERT(DATETIME,CONVERT(VARCHAR,dptdc_created_dt,108)) >= CONVERT(DATETIME,@notified_time)
								AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
								AND   cdshm_dpam_id = clidb_dpam_id 
								AND   clidb_brom_id = proc_profile_id
								AND   proc_slab_no  = cham_slab_no
								AND   isnull(cham_charge_graded,0) <> 1
								AND   cham_charge_baseon           = 'TQ' 
								AND   cham_charge_type = 'LATE_EXEC'
								AND   cdshm_tratm_type_desc in ('INTDEP-DR','OF-DR')
								AND   (abs(cdshm_qty) >= 0)  and (abs(cdshm_qty) <= cham_to_factor)  
								AND   cdshm_tratm_cd = '2277'
								and   cham_deleted_ind = 1
								and   clidb_deleted_ind = 1
								and   cdshm_deleted_ind = 1
								and   proc_deleted_ind = 1
								and   dptdc_deleted_ind = 1
                                and   CHAM_CHARGE_BASE = 'NORMAL'
					end
					--slab added for same day execution after notified timings for slip




		print '4'						

					 
					update cdsl_holding_dtls
					set    cdshm_charge   =  ISNULL(cdshm_charge,0) +
					(isnull(cham_charge_value,0)* -1 )
,cdshm_post_toacct = CHAM_POST_TOACCT
					from cdsl_holding_dtls      
					,client_dp_brkg
					,profile_charges
					,charge_mstr 
					where cdshm_dpm_id = @pa_dpm_id
					AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
					AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
					AND   cdshm_dpam_id = clidb_dpam_id 
					AND   clidb_brom_id = proc_profile_id
					AND   proc_slab_no  = cham_slab_no
					AND   isnull(cham_charge_graded,0) <> 1
					AND   cham_charge_baseon           = 'TQ' 
					AND   cham_charge_type = 'EXCHPAYOUT'
					AND   cdshm_tratm_type_desc in ('NSCCL-CR','CSECH-CR','BSECH-CR','ASECH-CR','OTCEI-CR','DSECH-CR')
					AND   (abs(cdshm_qty) >= 0)  and (abs(cdshm_qty) <= cham_to_factor)  
					AND   cdshm_tratm_cd = '2246'
					and   cham_deleted_ind = 1
					and   clidb_deleted_ind = 1
					and   cdshm_deleted_ind = 1
					and   proc_deleted_ind = 1
                    and   CHAM_CHARGE_BASE = 'NORMAL'
								

  
  ----transaction qtywise charge
  ----transaction instruction wise charge
  print '5'
     
					insert into #temp_bill
					(trans_dt 
					,dpam_id  
					,charge_name 
					,charge_val
					,post_toacct)
					select cdshm_tras_dt
					,cdshm_dpam_id
					,cham_slab_name
					,isnull(count(cdshm_slip_no)*cham_charge_value ,0)* -1 
					,cham_post_toacct
					from cdsl_holding_dtls      
					,client_dp_brkg
					,profile_charges
					,charge_mstr 
					where cdshm_dpm_id = @pa_dpm_id
					AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
					AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
					AND   cdshm_dpam_id = clidb_dpam_id 
					AND   clidb_brom_id = proc_profile_id
					AND   proc_slab_no  = cham_slab_no
					AND   isnull(cham_charge_graded,0) <> 1
					AND   cham_charge_baseon           = 'INST' 
					AND   cham_charge_type = cdshm_tratm_type_desc
					AND   cdshm_tratm_cd in ('2277')
					and   cham_deleted_ind = 1
					and   clidb_deleted_ind = 1
					and   cdshm_deleted_ind = 1
					and   proc_deleted_ind = 1
                    and   CHAM_CHARGE_BASE = 'NORMAL'
					group by cdshm_dpam_id,cdshm_tras_dt,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value,CHAM_BILL_INTERVAL,CHAM_POST_TOACCT
					having (count(cdshm_slip_no) >= cham_from_factor) and (count(cdshm_slip_no) <= cham_to_factor) 

  
					Insert into #temp_bill
					(trans_dt 
					,dpam_id  
					,charge_name 
					,charge_val
					,post_toacct)
					select cdshm_tras_dt
					,cdshm_dpam_id
					,cham_slab_name
					,isnull(count(cdshm_slip_no)*cham_charge_value ,0)* -1 
					,cham_post_toacct
					from cdsl_holding_dtls      
					,client_dp_brkg
					,profile_charges
					,charge_mstr 
					where cdshm_dpm_id = @pa_dpm_id
					AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
					AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
					AND   cdshm_dpam_id = clidb_dpam_id 
					AND   clidb_brom_id = proc_profile_id
					AND   proc_slab_no  = cham_slab_no
					AND   isnull(cham_charge_graded,0) <> 1
					AND   cham_charge_baseon           = 'INST' 
					AND   cham_charge_type = 'EXCHPAYIN'
					AND   cdshm_tratm_type_desc in ('NSCCL-DR','CSECH-DR','BSECH-DR','ASECH-DR','OTCEI-DR','DSECH-DR')
					AND   cdshm_tratm_cd = '2277'
					and   cham_deleted_ind = 1
					and   clidb_deleted_ind = 1
					and   cdshm_deleted_ind = 1
					and   proc_deleted_ind = 1
                    and   CHAM_CHARGE_BASE = 'NORMAL'
					group by cdshm_dpam_id,cdshm_tras_dt,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value,CHAM_POST_TOACCT
					having (count(cdshm_slip_no) >= 0) and (count(cdshm_slip_no) <= cham_to_factor) 
					 
					 
						insert into #temp_bill
						(trans_dt 
						,dpam_id  
						,charge_name 
						,charge_val
						,post_toacct)
						select cdshm_tras_dt
						,cdshm_dpam_id
						,cham_slab_name
						,	isnull(count(cdshm_slip_no)*cham_charge_value ,0)* -1 
						,cham_post_toacct
						from cdsl_holding_dtls      
						,client_dp_brkg
						,profile_charges
						,charge_mstr 
						where cdshm_dpm_id = @pa_dpm_id
						AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
						AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
						AND   cdshm_dpam_id = clidb_dpam_id 
						AND   clidb_brom_id = proc_profile_id
						AND   proc_slab_no  = cham_slab_no
						AND   isnull(cham_charge_graded,0) <> 1
						AND   cham_charge_baseon           = 'INST' 
						AND   cham_charge_type = 'EXCHPAYOUT'
						AND   cdshm_tratm_type_desc in ('NSCCL-CR','CSECH-CR','BSECH-CR','ASECH-CR','OTCEI-CR','DSECH-CR')
						AND   cdshm_tratm_cd = '2246'
						and   cham_deleted_ind = 1
						and   clidb_deleted_ind = 1
						and   cdshm_deleted_ind = 1
						and   proc_deleted_ind = 1
                        and   CHAM_CHARGE_BASE = 'NORMAL'
						group by cdshm_dpam_id,cdshm_tras_dt,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value,CHAM_POST_TOACCT
						having (count(cdshm_slip_no) >= 0) and (count(cdshm_slip_no) <= cham_to_factor) 
  
  
  
						insert into #temp_bill
						(trans_dt 
						,dpam_id  
						,charge_name 
						,charge_val
						,post_toacct)
						select cdshm_tras_dt
						,cdshm_dpam_id
						,cham_slab_name
						,isnull(case when count(cdshm_trans_no)*cham_charge_value <= cham_charge_minval then cham_charge_minval* -1 
						else (count(cdshm_trans_no)*cham_charge_value)* -1 end    ,0)
						,cham_post_toacct
						from cdsl_holding_dtls      
						,client_dp_brkg
						,profile_charges
						,charge_mstr 
						where cdshm_dpm_id = @pa_dpm_id
						AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
						AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
						AND   cdshm_dpam_id = clidb_dpam_id 
						AND   clidb_brom_id = proc_profile_id
						AND   proc_slab_no  = cham_slab_no
						AND   isnull(cham_charge_graded,0) <> 1
						AND   cham_charge_baseon    = 'TRANSPERSLIP' 
						AND   cdshm_tratm_type_desc not in ('DEMAT','REMAT')
						AND   cham_charge_type = cdshm_tratm_type_desc
						AND   cdshm_tratm_cd in ('2246','2277')
						and   cham_deleted_ind = 1
						and   clidb_deleted_ind = 1
						and   cdshm_deleted_ind = 1
						and   proc_deleted_ind = 1
                        and   CHAM_CHARGE_BASE = 'NORMAL'
						group by cdshm_dpam_id,cdshm_tras_dt,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value, cham_charge_minval,CHAM_POST_TOACCT
						having (count(cdshm_trans_no) >= 0) and (count(cdshm_trans_no) <= cham_to_factor) 
		      

		      
						update cdsl_holding_dtls
						set cdshm_charge= ISNULL(cdshm_charge,0) + isnull(case when demrm_total_certificates*cham_charge_value <= cham_charge_minval then cham_charge_minval* -1
						else demrm_total_certificates*cham_charge_value*-1 end    ,0)
,cdshm_post_toacct = CHAM_POST_TOACCT
						from cdsl_holding_dtls      
						,client_dp_brkg
						,profile_charges
						,charge_mstr 
						,demat_request_mstr
						where cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
						AND   cdshm_dpm_id = @pa_dpm_id
						AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
						AND   cdshm_dpam_id = clidb_dpam_id 
						AND   clidb_brom_id = proc_profile_id
						AND   proc_slab_no  = cham_slab_no
						AND   cdshm_dpam_id = demrm_dpam_id
						AND   abs(cdshm_trans_no) = abs(DEMRM_TRANSACTION_NO)
						AND   isnull(cham_charge_graded,0) <> 1
						AND   cham_charge_baseon           = 'TRANSPERSLIP' 
						AND   cdshm_tratm_type_desc        = 'DEMAT'
						--AND   demrm_status                 = 'E'
						AND   cham_charge_type = cdshm_tratm_type_desc
						AND   cdshm_tratm_cd = '2201'
						AND   (demrm_total_certificates >= 0) and (demrm_total_certificates<= cham_to_factor) 
						and   cham_deleted_ind  = 1
						and   clidb_deleted_ind = 1
						and   cdshm_deleted_ind = 1
						and   proc_deleted_ind  = 1
						and	  demrm_deleted_ind = 1
                       and   CHAM_CHARGE_BASE = 'NORMAL'

/*NEW CHARGES*/
                        update cdsl_holding_dtls
						set cdshm_charge= ISNULL(cdshm_charge,0) + 
                        isnull(case when DEMRM_QTY *(CONVERT(NUMERIC(10,2),cham_charge_value)/CONVERT(NUMERIC(10,2),CHAM_CHARGE_MINVAL)) < DEMRM_TOTAL_CERTIFICATES*CHAM_PER_MIN then  DEMRM_TOTAL_CERTIFICATES*CHAM_PER_MIN * -1 
		                else DEMRM_QTY *(CONVERT(NUMERIC(10,2),cham_charge_value)/CONVERT(NUMERIC(10,2),CHAM_CHARGE_MINVAL)) end    ,0)  
,cdshm_post_toacct = CHAM_POST_TOACCT
						from cdsl_holding_dtls      
						,client_dp_brkg
						,profile_charges
						,charge_mstr 
						,demat_request_mstr
						where cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
						AND   cdshm_dpm_id = @pa_dpm_id
						AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
						AND   cdshm_dpam_id = clidb_dpam_id 
						AND   clidb_brom_id = proc_profile_id
						AND   proc_slab_no  = cham_slab_no
						AND   cdshm_dpam_id = demrm_dpam_id
						AND   abs(cdshm_trans_no) = abs(DEMRM_TRANSACTION_NO)
						AND   isnull(cham_charge_graded,0) <> 1
						AND   cham_charge_baseon           = 'CQ' 
						AND   cdshm_tratm_type_desc        = 'DEMAT'
						AND   demrm_status                 = 'E'
						AND   cham_charge_type = cdshm_tratm_type_desc
						AND   cdshm_tratm_cd = '2201'
						and   cham_deleted_ind  = 1
						and   clidb_deleted_ind = 1
						and   cdshm_deleted_ind = 1
						and   proc_deleted_ind  = 1
						and	  demrm_deleted_ind = 1
                        and   CHAM_CHARGE_BASE = 'NORMAL'
/*NEW CHARGES*/



						update cdsl_holding_dtls
						set cdshm_charge= ISNULL(cdshm_charge,0) + isnull(case when REMRM_CERTIFICATE_NO*cham_charge_value <= cham_charge_minval then cham_charge_minval* -1
						else REMRM_CERTIFICATE_NO*cham_charge_value*-1 end    ,0)
,cdshm_post_toacct = CHAM_POST_TOACCT
						from cdsl_holding_dtls      
						,client_dp_brkg
						,profile_charges
						,charge_mstr 
						,remat_request_mstr
						where cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
						AND   cdshm_dpm_id = @pa_dpm_id
						AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
						AND   cdshm_dpam_id = clidb_dpam_id 
						AND   clidb_brom_id = proc_profile_id
						AND   proc_slab_no  = cham_slab_no
						AND   cdshm_dpam_id = remrm_dpam_id
						AND   cdshm_trans_no = remrm_rrf_no
						AND   isnull(cham_charge_graded,0) <> 1
						AND   cham_charge_baseon           = 'TRANSPERSLIP' 
						AND   cdshm_tratm_type_desc        = 'REMAT'
						--AND   remrm_status                 = 'E'
						AND   cham_charge_type = cdshm_tratm_type_desc
						AND   cdshm_tratm_cd = '2277'
						AND   (REMRM_CERTIFICATE_NO >= 0) and (REMRM_CERTIFICATE_NO <= cham_to_factor) 
						and   cham_deleted_ind  = 1
						and   clidb_deleted_ind = 1
						and   cdshm_deleted_ind = 1
						and   proc_deleted_ind  = 1
						and	  remrm_deleted_ind = 1
                        and   CHAM_CHARGE_BASE = 'NORMAL'


		
						insert into #temp_bill
						(trans_dt 
						,dpam_id  
						,charge_name 
						,charge_val
						,post_toacct)
						select cdshm_tras_dt
						,cdshm_dpam_id
						,cham_slab_name
						,isnull(case when count(cdshm_trans_no)*cham_charge_value <= cham_charge_minval then cham_charge_minval* -1 
						else count(cdshm_trans_no)*cham_charge_value* -1  end    ,0)
						,cham_post_toacct
						from cdsl_holding_dtls      
						,client_dp_brkg
						,profile_charges
						,charge_mstr 
						where cdshm_dpm_id = @pa_dpm_id
						AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
						AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
						AND   cdshm_dpam_id = clidb_dpam_id 
						AND   clidb_brom_id = proc_profile_id
						AND   proc_slab_no  = cham_slab_no
						AND   isnull(cham_charge_graded,0) <> 1
						AND   cham_charge_baseon = 'TRANSPERSLIP' 
						AND   cham_charge_type = 'EXCHPAYIN'
						AND   cdshm_tratm_type_desc in ('NSCCL-DR','CSECH-DR','BSECH-DR','ASECH-DR','OTCEI-DR','DSECH-DR')
						AND   cdshm_tratm_cd = '2277'
						and   cham_deleted_ind = 1
						and   clidb_deleted_ind = 1
						and   cdshm_deleted_ind = 1
						and   proc_deleted_ind = 1
                        and   CHAM_CHARGE_BASE = 'NORMAL'
						group by cdshm_dpam_id,cdshm_tras_dt,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value, cham_charge_minval,CHAM_POST_TOACCT
						having (count(cdshm_trans_no) >= cham_from_factor) and (count(cdshm_trans_no) <= cham_to_factor) 
		
		
						insert into #temp_bill
						(trans_dt 
						,dpam_id  
						,charge_name 
						,charge_val
						,post_toacct)
						select cdshm_tras_dt
						,cdshm_dpam_id
						,cham_slab_name
						,isnull(case when count(cdshm_trans_no)*cham_charge_value <= cham_charge_minval then cham_charge_minval* - 1 
						else count(cdshm_trans_no)*cham_charge_value* -1  end    ,0)
						,cham_post_toacct
						from cdsl_holding_dtls      
						,client_dp_brkg
						,profile_charges
						,charge_mstr 
						where cdshm_dpm_id = @pa_dpm_id
						AND   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
						AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
						AND   cdshm_dpam_id = clidb_dpam_id 
						AND   clidb_brom_id = proc_profile_id
						AND   proc_slab_no  = cham_slab_no
						AND   isnull(cham_charge_graded,0) <> 1
						AND   cham_charge_baseon = 'TRANSPERSLIP' 
						AND   cham_charge_type = 'EXCHPAYOUT'
						AND   cdshm_tratm_type_desc in ('NSCCL-CR','CSECH-CR','BSECH-CR','ASECH-CR','OTCEI-CR','DSECH-CR')
						AND   cdshm_tratm_cd = '2246'
						and   cham_deleted_ind = 1
						and   clidb_deleted_ind = 1
						and   cdshm_deleted_ind = 1
						and   proc_deleted_ind = 1
                       and   CHAM_CHARGE_BASE = 'NORMAL'
						group by cdshm_dpam_id,cdshm_tras_dt,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value, cham_charge_minval,CHAM_POST_TOACCT
						having (count(cdshm_trans_no) >= 0) and (count(cdshm_trans_no) <= cham_to_factor)

					 ----transaction per transaction no per slip no wise charge		


					update cdsl_holding_dtls 
					set  cdshm_charge = round(cdshm_charge,2) 
					where cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
					and isnull(cdshm_charge,0) <> 0

			 

					

				
					IF EXISTS(SELECT bitrm_id FROM bitmap_ref_mstr WHERE bitrm_parent_cd = 'BILL_CLI_ADD_DP_CHRG_CDSL' 
								AND BITRM_BIT_LOCATION = @pa_dpm_id AND BITRM_VALUES = 1 and 1 = 2)
					BEGIN
						UPDATE cdsl_holding_dtls 
						SET cdshm_charge = isnull(cdshm_charge,0) + isnull(CDSHM_DP_CHARGE,0)
						where cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
						and CDSHM_DPM_ID = @pa_dpm_id 
						and not exists(select clidb_dpam_id from client_dp_brkg,brokerage_mstr 
										where clidb_dpam_id = cdshm_dpam_id 
										AND   clidb_brom_id = brom_id
										and   brom_desc = 'DUMMY'
										AND   cdshm_tras_dt >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
										and   clidb_deleted_ind = 1 
										and   brom_deleted_ind =1)
						and isnull(cdshm_charge,0) <> 0 
										
										



						insert into #temp_bill
						(trans_dt 
						,dpam_id  
						,charge_name 
						,charge_val
						,post_toacct)
						SELECT DPCH_TRANC_DT
						, DPCH_dpam_id 
						, DPCH_CHARGE_NAME 
						, sum(DPCH_CHARGE_AMT) 
						, @l_post_toacct
						FROM DP_CHARGES_cdsl dcc	
						WHERE DPCH_DPM_ID = @pa_dpm_id  
						AND   DPCH_TRANC_DT between  @pa_billing_from_dt and @pa_billing_to_dt
						AND   DPCH_CHARGE_NAME <> 'TRANSACTION CHARGES'
						AND   DPCH_CHARGE_NAME NOT like  '%SER%TAX%' AND DPCH_CHARGE_NAME NOT LIKE '%CESS%'
						and not exists(select clidb_dpam_id from client_dp_brkg,brokerage_mstr 
										where clidb_dpam_id = DPCH_dpam_id 
										AND   clidb_brom_id = brom_id
										and   brom_desc = 'DUMMY'
										AND   @pa_billing_to_dt >= clidb_eff_from_dt and  @pa_billing_to_dt <= clidb_eff_to_dt
										and   clidb_deleted_ind = 1 
										and   brom_deleted_ind =1)
						GROUP BY DPCH_dpam_id,	DPCH_CHARGE_NAME,DPCH_TRANC_DT
					END

/*logic for calculating transaction rejection charges

				--demat rejection
				 update DMT_STATUS_MSTR
			     set    DMTS_CHARGE   =   (isnull(cham_charge_value,0) * -1 )
				from DMT_STATUS_MSTR      
				,client_dp_brkg
				,profile_charges
				,charge_mstr 
				where DMTS_DPM_ID = @pa_dpm_id
				AND   DMTS_DMT_REQ_RECDT between  @pa_billing_from_dt and @pa_billing_to_dt
			    AND   DMTS_DMT_REQ_RECDT >= clidb_eff_from_dt and  cdshm_tras_dt <= clidb_eff_to_dt
				AND   DMTS_DPAM_ID = clidb_dpam_id 
				AND   clidb_brom_id = proc_profile_id
				AND   proc_slab_no  = cham_slab_no
               	AND   isnull(cham_charge_graded,0) <> 1
				AND   cham_charge_baseon           = 'TQ' 
				AND   cham_charge_type = 'DMAT_REJ'
				AND   (abs(DMTS_DMT_REJ_QTY) >= cham_from_factor)  and (abs(DMTS_DMT_REJ_QTY) <= cham_to_factor)  
				AND   DMTS_DMT_REJ_QTY <> 0
				AND   DMTS_DRN_STATUS ='C'
				and   cham_deleted_ind = 1
				and   clidb_deleted_ind = 1
				and   proc_deleted_ind = 1
				--demat rejection
				--remat rejection
				 update RMT_STATUS_MSTR
			     set    RMTS_CHARGE =   (isnull(cham_charge_value,0) * -1 )
				from RMT_STATUS_MSTR  
				,client_dp_brkg
				,profile_charges
				,charge_mstr 
				where RMTS_DPM_ID = @pa_dpm_id
				AND   RMTS_REC_DT between  @pa_billing_from_dt and @pa_billing_to_dt
			    AND   RMTS_REC_DT >= clidb_eff_from_dt and  rmat_summary_dt <= clidb_eff_to_dt
				AND   RMTS_DPAM_ID = clidb_dpam_id 
				AND   clidb_brom_id = proc_profile_id
				AND   proc_slab_no  = cham_slab_no
               	AND   isnull(cham_charge_graded,0) <> 1
				AND   cham_charge_baseon           = 'TQ' 
				AND   cham_charge_type = 'RMAT_REJ'
				AND   (abs(RMTS_QTY_REQ_FOR_RMT_NOS) >= cham_from_factor)  and (abs(rmaRMTS_QTY_REQ_FOR_RMT_NOSt_qty) <= cham_to_factor)  
				AND   RMTS_RRN_STAT_DESC ='REJECTED'
				and   cham_deleted_ind = 1
				and   clidb_deleted_ind = 1
				and   proc_deleted_ind = 1
				--remat rejection

				--offmkt rejection


				 update OFFMKT_STATUS_MSTR
			     set    OFFSM_CHARGE   =   (isnull(cham_charge_value,0) * -1 )
				from OFFMKT_STATUS_MSTR
				,client_dp_brkg
				,profile_charges
				,charge_mstr 
				where OFFSM_DPID = @pa_dpm_id
				AND   OFFSM_SETTL_DT between  @pa_billing_from_dt and @pa_billing_to_dt
			    AND   OFFSM_SETTL_DT >= clidb_eff_from_dt and  OFFSM_SETTL_DT <= clidb_eff_to_dt
				AND   OFFSM_DPAM_ID = clidb_dpam_id 
				AND   clidb_brom_id = proc_profile_id
				AND   proc_slab_no  = cham_slab_no
               	AND   isnull(cham_charge_graded,0) <> 1
				AND   cham_charge_baseon           = 'TQ' 
				AND   cham_charge_type = 'TRANS_REJ'
				AND   (abs(OFFSM_QTY) >= cham_from_factor)  and (abs(OFFSM_QTY) <= cham_to_factor)  
				AND   OFFSM_STAT = 2
				and   cham_deleted_ind = 1
				and   clidb_deleted_ind = 1
				and   proc_deleted_ind = 1
				--offmkt rejection

				--interdep rejection
				 update INTERDP_STATUS_MSTR
			     set    IDS_CHARGE   =   (isnull(cham_charge_value,0) * -1 )
				from INTERDP_STATUS_MSTR
				,client_dp_brkg
				,profile_charges
				,charge_mstr 
				where IDS_DPM_ID = @pa_dpm_id
				AND   IDS_TRX_DT between  @pa_billing_from_dt and @pa_billing_to_dt
			    AND   IDS_TRX_DT >= clidb_eff_from_dt and  IDS_TRX_DT <= clidb_eff_to_dt
				AND   IDS_DPAM_ID = clidb_dpam_id 
				AND   clidb_brom_id = proc_profile_id
				AND   proc_slab_no  = cham_slab_no
               	AND   isnull(cham_charge_graded,0) <> 1
				AND   cham_charge_baseon           = 'TQ' 
				AND   cham_charge_type = 'TRANS_REJ'
				AND   (abs(IDS_QTY) >= cham_from_factor)  and (abs(IDS_QTY) <= cham_to_factor)  
				AND   IDS_TRX_STAT_CD ='23'
				and   cham_deleted_ind = 1
				and   clidb_deleted_ind = 1
				and   proc_deleted_ind = 1
				--interdep rejection



				insert into #temp_bill(trans_dt,dpam_id,charge_name,charge_val,post_to_acct)
				select @pa_billing_to_dt,dpam_id,'Demat Rejection Charges', sum(isnull(DMTS_CHARGE,0)),@l_post_toacct 
				from DMT_STATUS_MSTR 
				where DMTS_DMT_REQ_RECDT between @pa_billing_from_dt and @pa_billing_to_dt
				and DMTS_DPM_ID = @pa_dpm_id
				group by dpam_id
				having sum(isnull(abs(DMTS_CHARGE),0)) > 0

				insert into #temp_bill(trans_dt,dpam_id,charge_name,charge_val,post_to_acct)
				select @pa_billing_to_dt,dpam_id,'Remat Rejection Charges', sum(isnull(RMTS_CHARGE,0)),@l_post_toacct 
				from RMT_STATUS_MSTR 
				where RMTS_REC_DT between @pa_billing_from_dt and @pa_billing_to_dt
				and RMTS_DPM_ID = @pa_dpm_id
				group by dpam_id
				having sum(isnull(abs(RMTS_CHARGE),0)) > 0

				insert into #temp_bill(trans_dt,dpam_id,charge_name,charge_val,post_to_acct)
				select @pa_billing_to_dt,dpam_id,'Offmarket Rejection Charges', sum(isnull(OFFSM_CHARGE,0)),@l_post_toacct 
				from OFFMKT_STATUS_MSTR 
				where OFFSM_SETTL_DT between @pa_billing_from_dt and @pa_billing_to_dt
				and OFFSM_DPID = @pa_dpm_id
				group by dpam_id
				having sum(isnull(abs(OFFSM_CHARGE),0)) > 0

				insert into #temp_bill(trans_dt,dpam_id,charge_name,charge_val,post_to_acct)
				select @pa_billing_to_dt,dpam_id,'InterDepository Rejection Charges', sum(isnull(IDS_CHARGE,0)),@l_post_toacct 
				from INTERDP_STATUS_MSTR 
				where IDS_TRX_DT between @pa_billing_from_dt and @pa_billing_to_dt
				and IDS_DPM_ID = @pa_dpm_id
				group by dpam_id
				having sum(isnull(abs(IDS_CHARGE),0)) > 0







logic for calculating transaction rejection charges
*/

				insert into #temp_bill(trans_dt,dpam_id,charge_name,charge_val,post_toacct) 
				Exec Pr_CalculateInterest 'CDSL',@pa_dpm_id,@@FINID, @pa_billing_to_dt, @l_post_toacct



					
					insert into #temp_bill
					(trans_dt   
					,dpam_id    
					,charge_name   
					,charge_val
					,post_toacct) 
					select cdshm_tras_dt 
					, cdshm_dpam_id
					, 'TRANSACTION CHARGES'
					, sum(cdshm_charge)
					, cdshm_post_toacct 
					from cdsl_holding_dtls     
					WHERE cdshm_dpm_id = @pa_dpm_id  
					and   cdshm_tras_dt between  @pa_billing_from_dt and @pa_billing_to_dt
					and   cdshm_deleted_ind =1 
					group by  CDSHM_DPAM_ID,cdshm_tras_dt,cdshm_post_toacct
					having isnull(sum(cdshm_charge),0) <> 0
						
						
insert into #temp_bill
(trans_dt   
,dpam_id    
,charge_name   
,charge_val
,post_toacct, FLG) 
select CLIC_TRANS_DT , CLIC_DPAM_ID , CLIC_CHARGE_NAME , sum(CLIC_CHARGE_AMT), CLIC_POST_TOACCT, 'M'
from client_charges_cdsl
where CLIC_FLG = 'M'
and CLIC_TRANS_DT between @pa_billing_from_dt and @pa_billing_to_dt
group by  CLIC_TRANS_DT , CLIC_DPAM_ID, CLIC_CHARGE_NAME  , CLIC_POST_TOACCT

					   --logic for charge on amount like service tax
declare @l_sert_posttoacct numeric

select @l_sert_posttoacct  = fina_acc_id from fin_account_mstr where fina_acc_code ='SERVICETAX'

					insert into #temp_bill  
					(trans_dt   
					,dpam_id    
					,charge_name   
					,charge_val
					,post_toacct) 
					select trans_dt, dpam_id , clic_charge_name 
					,Charge_amt*amount
					,posttoacct 
					from ( select trans_dt,dpam_id
					,'SERVICE TAX' clic_charge_name 
					,Charge_amt=sum(charge_val)
					,@l_sert_posttoacct posttoacct   
					from #temp_bill a 
				    where citrus_usr.fn_splitval([citrus_usr].[fn_addr_value_bydpam_id](dpam_id,'COR_ADR1'),5) not in   (select statename from statelisttowaive)
					and charge_name not like '%ACOP%'
					group by dpam_id ,trans_dt ) a 
					,servicetax_mstr 
					where @pa_billing_from_dt >= from_dt and  @pa_billing_from_dt <= to_dt
					
					
--					select trans_dt
--					,dpam_id
--					,cham_slab_name
--					,Charge_amt=sum(case when cham_val_pers  = 'V' then cham_charge_value* -1   
--					else case when ABS((cham_charge_value/100)*charge_val) <= cham_charge_minval then cham_charge_minval* -1   
--					else (cham_charge_value/100)*charge_val  end  
--					end)    
--					,cham_post_toacct
--					from #temp_bill a
--					,client_dp_brkg  
--					,profile_charges  
--					,charge_mstr 
--					where trans_dt >= clidb_eff_from_dt and  trans_dt <= clidb_eff_to_dt  
--					AND   a.dpam_id = clidb_dpam_id 
--					AND   clidb_brom_id = proc_profile_id  
--					AND   proc_slab_no  = cham_slab_no  
--					AND   isnull(cham_charge_graded,0) <> 1  
--					AND   cham_charge_type           = 'AMT'   
--					and   cham_deleted_ind = 1  
--					and   clidb_deleted_ind = 1  
--					and   proc_deleted_ind = 1  
--                    and   CHAM_CHARGE_BASE = 'NORMAL'
--					and not exists(select src_chargename,on_chargename from ExcludeTransCharges
--					where src_chargename = charge_name and on_chargename = cham_slab_name and for_type = 'C' and  dpm_id = @pa_dpm_id)
--					group by dpam_id,cham_slab_name,cham_post_toacct ,trans_dt
--						  logic for charge on amount like service tax
  
					 

					 --delete from client_charges_cdsl where clic_trans_dt between @pa_billing_from_dt and @pa_billing_to_dt and clic_flg = 'S' and clic_dpm_id = @pa_dpm_id
                    delete from client_charges_cdsl 
					where clic_trans_dt between @pa_billing_from_dt and @pa_billing_to_dt  
					and clic_dpm_id = @pa_dpm_id and CLIC_FLG in ('S','M')
					 
					 insert into client_charges_cdsl(clic_trans_dt
					,clic_dpm_id
					,clic_dpam_id
					,clic_charge_name
					,clic_charge_amt
					,clic_flg
					,clic_created_by
					,clic_created_dt
					,clic_lst_upd_by
					,clic_lst_upd_dt
					,clic_deleted_ind
					,clic_post_toacct
					)
					select trans_dt
					,@pa_dpm_id 
					,dpam_id
					,charge_name
					,round(charge_val,2)
					, case when isnull(flg,'')= '' then 'S' else flg end --
					,'HO'
					,getdate()
					,'HO'
					,getdate()
					,1
					,post_toacct
					from  #temp_bill 
					where charge_val <> 0

  
  --logic for transaction type wise charge
  
  
  
  
  
--
end

GO
