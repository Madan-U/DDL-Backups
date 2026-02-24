-- Object: PROCEDURE citrus_usr.pr_billing_nsdl
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_billing_nsdl](@pa_billing_from_dt datetime,@pa_billing_to_dt datetime,@pa_dpm_id numeric,@pa_billing_status char(1))  
as  
begin  
--  

  SET DATEFORMAT dmy

  declare @l_post_toacct numeric(10,0)  
         ,@pa_excmid int  
           
           
  select top 1 @pa_excmid  = excm_id from dp_mstr,exch_seg_mstr,exchange_mstr   
  where dpm_id = @pa_dpm_id   
  and   dpm_excsm_id = excsm_id   
  and   excsm_exch_cd=  excm_cd  
  and dpm_deleted_ind = 1            
  and excm_deleted_ind = 1            
  and excsm_deleted_ind = 1            
    
    
  create table #temp_bill  
  (trans_dt datetime  
  ,dpam_id  numeric  
  ,charge_name varchar(50)  
  ,charge_val  numeric(18,5)  
  ,post_toacct numeric(10,0))  
    
  
   select convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd into #account_properties from account_properties where accp_accpm_prop_cd = 'BILL_START_DT' 


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
		where 	SLIIM_DPAM_ACCT_NO = dpam_sba_no 
        and   dpam_id     = clidb_dpam_id  
        and   clidb_brom_id = proc_profile_id
		and   proc_slab_no  = cham_slab_no
		and sliim_created_dt between @pa_billing_from_dt and @pa_billing_to_dt
	    and  dpam_dpm_id = @pa_dpm_id 
		and   sliim_created_dt >= clidb_eff_from_dt and  sliim_created_dt <= clidb_eff_to_dt
		and   cham_charge_type = 'SLIP_ISS_NSDL'
		and   cham_deleted_ind = 1
		and   clidb_deleted_ind = 1
		and   dpam_deleted_ind = 1
		and   proc_deleted_ind = 1
		and   sliim_deleted_ind = 1 
        and   CHAM_CHARGE_BASE = 'NORMAL'
		group by dpam_id , cham_slab_name , cham_post_toacct,cham_from_factor,cham_to_factor,cham_charge_value, sliim_created_dt
		having sum(((convert(bigint,SLIIM_SLIP_NO_TO) - convert(bigint,SLIIM_SLIP_NO_FR) + 1))) between  cham_from_factor and cham_to_factor 
  --logic for charging slip issued charges


  --logic for charging for one time charges  
    
--  insert into #temp_bill  
--  (trans_dt   
--  ,dpam_id    
--  ,charge_name   
--  ,charge_val  
--  ,post_toacct)  
--  select convert(datetime,accp_value,103)  
--  ,dpam_id  
--  ,cham_slab_name  
--  ,sum(cham_charge_value ) * -1  
--  ,cham_post_toacct  
--  from dp_acct_mstr  
--      ,client_dp_brkg  
--      ,profile_charges  
--      ,charge_mstr  
--      ,charge_ctgry_mapping,account_properties
--  where accp_clisba_id = dpam_id
--  AND   dpam_id     = clidb_dpam_id  
--  and   CHAM_SLAB_NO = chacm_cham_id
--  AND   clidb_brom_id = proc_profile_id  
--  AND   proc_slab_no  = cham_slab_no  
--  and   case when chacm_subcm_cd = '0' then '0' else dpam_subcm_cd end = chacm_subcm_cd
--  and   dpam_dpm_id = @pa_dpm_id  
--  and   accp_accpm_prop_cd = 'BILL_START_DT' 
--  and   DPAM_STAM_CD not in('05','04','08','02_BILLSTOP')
--  and   isdate(accp_value) = 1
--  AND   convert(datetime,accp_value,103) >= clidb_eff_from_dt and  convert(datetime,accp_value,103) <= clidb_eff_to_dt  
--  AND   cham_charge_type = 'O'  
--  AND   convert(datetime,citrus_usr.fn_acct_entp(dpam_id,'BILL_START_DT'),103) between @pa_billing_from_dt and @pa_billing_to_dt  
--  and   cham_deleted_ind = 1  
--  and   clidb_deleted_ind = 1  
--  and   dpam_deleted_ind = 1  
--  and   proc_deleted_ind = 1  
--  and   CHAM_CHARGE_BASE = 'NORMAL'
--  group by dpam_id , cham_slab_name , cham_post_toacct ,accp_value 



insert into #temp_bill  
  (trans_dt   
  ,dpam_id    
  ,charge_name   
  ,charge_val  
  ,post_toacct)  
  select accp_value
  ,dpam_id  
  ,cham_slab_name  
  ,sum(cham_charge_value ) * -1  
  ,cham_post_toacct  
  from dp_acct_mstr  
      ,client_dp_brkg  
      ,profile_charges  
      ,charge_mstr  
      ,charge_ctgry_mapping
      ,#account_properties
  where accp_clisba_id = dpam_id
  AND   dpam_id     = clidb_dpam_id  
  and   CHAM_SLAB_NO = chacm_cham_id
  AND   clidb_brom_id = proc_profile_id  
  AND   proc_slab_no  = cham_slab_no  
  and   case when chacm_subcm_cd = '0' then '0' else dpam_subcm_cd end = chacm_subcm_cd
  and   dpam_dpm_id = @pa_dpm_id  
  and   DPAM_STAM_CD not in('05','04','08','02_BILLSTOP')
  and   isdate(accp_value) = 1
  AND   accp_value >= clidb_eff_from_dt and  convert(datetime,accp_value,103) <= clidb_eff_to_dt  
  AND   cham_charge_type = 'O'  
  AND   accp_value between @pa_billing_from_dt and @pa_billing_to_dt  
  and   cham_deleted_ind = 1  
  and   clidb_deleted_ind = 1  
  and   dpam_deleted_ind = 1  
  and   proc_deleted_ind = 1  
  and   CHAM_CHARGE_BASE = 'NORMAL'
  group by dpam_id , cham_slab_name , cham_post_toacct ,accp_value 

    
 CREATE TABLE #VOUCHERNO(VCHNO BIGINT)
declare @@vch_no bigint,
@@FINID INT,
@@pa_values VARCHAR(8000),
@@FORMNO VARCHAR(16),
@@voucher_dt varchar(11),
@@SSQL VARCHAR(8000)

SELECT @@FINID = FIN_ID FROM FINANCIAL_YR_MSTR WHERE @pa_billing_to_dt BETWEEN FIN_START_DT AND FIN_END_DT AND FIN_DPM_ID = @pa_dpm_id AND FIN_DELETED_IND = 1

DECLARE CUR CURSOR FOR  
SELECT  INWCR_FRMNO, 'B|*~|' +  convert(varchar,ISNULL(INWCR_BANK_ID,0)) + '|*~|' + CONVERT(VARCHAR,INWCR_CHARGE_COLLECTED) + '|*~|*|~*P|*~|' + convert(varchar,dpam_id) + '|*~|0|*~||*~|' + CONVERT(VARCHAR,INWCR_CHARGE_COLLECTED) + '|*~|' + ISNULL(INWCR_CHEQUE_NO,'') + '|*~|' + LEFT(ISNULL(INWCR_RMKS,''),250) + '|*~|' + isnull(inwcr_clibank_accno,'') + '|*~|*|~*',
CONVERT(varchar(10),inwcr_recvd_dt,103) VCH_DT
FROM inw_client_reg,dp_acct_mstr,account_properties 
where inwcr_frmno = dpam_acct_no 
and   accp_clisba_id = dpam_id 
and   accp_accpm_prop_cd = 'BILL_START_DT'
and convert(bigint,inwcr_dmpdpid) = dpam_dpm_id 
and convert(bigint,inwcr_dmpdpid) = @pa_dpm_id
and inwcr_deleted_ind = 1
and dpam_deleted_ind = 1
and isdate(accp_value) = 1
and convert(datetime,accp_value) between @pa_billing_from_dt and @pa_billing_to_dt

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
   select citrus_usr.getfixedchargedate(convert(varchar(11),accp_value,103),@pa_billing_from_dt,@pa_billing_to_dt,cham_bill_period,cham_bill_interval,@pa_excmid)  
   ,dpam_id  
   ,cham_slab_name  
   ,sum(cham_charge_value )  * -1
   ,cham_post_toacct  
   from dp_acct_mstr  
       ,client_dp_brkg  
       ,profile_charges  
       ,charge_mstr  
       ,charge_ctgry_mapping,#account_properties
   where dpam_id     = clidb_dpam_id  
   and   accp_clisba_id = dpam_id  
   and dpam_dpm_id = @pa_dpm_id   
   and   CHAM_SLAB_NO = chacm_cham_id
   AND   clidb_brom_id = proc_profile_id  
   AND   proc_slab_no  = cham_slab_no  
   and   case when chacm_subcm_cd = '0' then '0' else dpam_subcm_cd end = chacm_subcm_cd
   and   DPAM_STAM_CD not in('05','04','08','02_BILLSTOP')
   and   accp_accpm_prop_cd = 'BILL_START_DT'
   and   isdate(accp_value) = 1
   AND   citrus_usr.getfixedchargedate(convert(varchar(11),accp_value,103),@pa_billing_from_dt,@pa_billing_to_dt,cham_bill_period,cham_bill_interval,@pa_excmid)  between clidb_eff_from_dt and clidb_eff_to_dt   
   AND   cham_charge_type = 'F'  
   AND   citrus_usr.getfixedchargedate(convert(varchar(11),accp_value,103),@pa_billing_from_dt,@pa_billing_to_dt,cham_bill_period,cham_bill_interval,@pa_excmid) is not null  
   and   cham_deleted_ind = 1  
   and   clidb_deleted_ind = 1  
   and   dpam_deleted_ind = 1  
   and   proc_deleted_ind = 1  
   and   CHAM_CHARGE_BASE = 'NORMAL'
   group by dpam_id , cham_slab_name , cham_post_toacct ,cham_bill_period,CHAM_BILL_INTERVAL ,accp_value
  
  --logic for charging for fix charges  
    
    
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
    ,sum(cham_charge_value ) * -1   
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
    AND   clidb_brom_id = proc_profile_id    
    AND   proc_slab_no  = cham_slab_no  
    and   case when chacm_subcm_cd = '0' then '0' else dpam_subcm_cd end = chacm_subcm_cd
    and   clsr_date between @pa_billing_from_dt and @pa_billing_to_dt   
    and   clsr_status = '3'   
    AND   clsr_date >= clidb_eff_from_dt and  clsr_date <= clidb_eff_to_dt    
     
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
     ,dpdhm_dpam_id  
     ,cham_slab_name  
     ,Charge_amt=COUNT(DPDHM_isin) * cham_charge_value * -1    
     ,cham_post_toacct  
     from dp_hldg_mstr_nsdl  
		 ,dp_acct_mstr
         ,client_dp_brkg    
         ,profile_charges    
         ,charge_mstr 
     where DPDHM_dpm_id= @pa_dpm_id  
     AND   DPDHM_dpam_id = clidb_dpam_id 
     AND   clidb_brom_id = proc_profile_id    
     AND   proc_slab_no  = cham_slab_no    
	 and   DPDHM_dpam_id = dpam_id
	 and   DPAM_STAM_CD not in('05','04','08','02_BILLSTOP')
     AND   DPDHM_HOLDING_DT = @pa_billing_to_dt  
     AND   DPDHM_HOLDING_DT >= clidb_eff_from_dt and  DPDHM_HOLDING_DT <= clidb_eff_to_dt    
     AND   isnull(cham_charge_graded,0) <> 1    
     AND   cham_charge_type           = 'H'     
     and   cham_deleted_ind = 1    
     and   clidb_deleted_ind = 1    
     and   proc_deleted_ind = 1  
     AND    DPDHM_DELETED_IND =1    
     and   DPDHM_BENF_ACCT_TYP in ('10','11','30')
     and   CHAM_CHARGE_BASE = 'NORMAL'
     group by DPDHM_dpam_id,cham_slab_name,CHAM_POST_TOACCT,DPDHM_ISIN,cham_charge_value,cham_from_factor,cham_to_factor  
     having COUNT(DPDHM_isin) >= cham_from_factor  and COUNT(DPDHM_isin) <= cham_to_factor     
       
  --logic for holding charge  
    
  
    
  --logic for transaction type wise charge  
/*MIN MAX CHARGES LOGIC*/
if exists(select top 1 NSDHM_TRANSACTION_DT from nsdl_holding_dtls)
insert into #temp_bill
(trans_dt 
,dpam_id  
,charge_name 
,charge_val
,post_toacct)
SELECT dt  
,nsdhm_dpam_id  
,B.cham_slab_name  
,CASE WHEN SUM(CHARGE) >= CHAM_PER_MAX THEN CHAM_PER_MAX* -1  
       WHEN SUM(CHARGE) <= CHAM_PER_min THEN CHAM_PER_min*-1
      ELSE SUM(CHARGE)*-1 END 
,B.cham_post_toacct 
FROM (
select citrus_usr.getfixedchargedate(CONVERT(DATETIME,accp_value,103),@pa_billing_from_dt  ,@pa_billing_to_dt  ,cham_bill_period,cham_bill_interval,@pa_excmid)   dt
,nsdhm_dpam_id  
,ABS(isnull(cham_charge_value ,0)) CHARGE
,CHAM_SLAB_NO SLAB
from nsdl_holding_dtls        
,client_dp_brkg  
,profile_charges  
,charge_mstr   , #account_properties 
where nsdhm_dpm_id = @pa_dpm_id  
and   accp_clisba_id =  CLIDB_dpam_id
AND   nsdhm_dpam_id = clidb_dpam_id
AND   clidb_brom_id = proc_profile_id  
AND   proc_slab_no  = cham_slab_no  
and   accp_accpm_prop_cd = 'BILL_START_DT'
and   isnull(WAIVE_FLAG,'') <> 'Y'
AND   citrus_usr.getfixedchargedate(CONVERT(DATETIME,accp_value,103),@pa_billing_from_dt  ,@pa_billing_to_dt ,cham_bill_period,cham_bill_interval,@pa_excmid)  between  DATEADD(month, cham_bill_interval*-1, @pa_billing_from_dt)  and @pa_billing_to_dt
AND   nsdhm_transaction_dt >= clidb_eff_from_dt and  nsdhm_transaction_dt <= clidb_eff_to_dt  
AND   isnull(cham_charge_graded,0) <> 1  
AND   cham_charge_baseon           = 'TQ'   
AND   cham_charge_type = nsdhm_book_naar_cd  
and   cham_deleted_ind = 1  
and   clidb_deleted_ind = 1  
and   nsdhm_deleted_ind = 1  
and   proc_deleted_ind = 1  
and   NSDHM_BEN_ACCT_TYPE in ('10','11','30','40','20')
and   NSDHM_QTY < 0  
and   isnull(CHAM_PER_MAX,'0') <> '0'
and   isnull(CHAM_PER_min,'0') <> '0'
and   CHAM_CHARGE_BASE = 'PERIODIC'
--AND  'sep 302008'  between clidb_eff_from_dt and clidb_eff_to_dt   
 ) A , CHARGE_MSTR B WHERE CHAM_SLAB_NO = SLAB
GROUP BY nsdhm_dpam_id,dt
,B.cham_slab_name, B.cham_from_factor
,B.cham_to_factor,cham_charge_value 
,B.cham_post_toacct ,B.CHAM_PER_MIN, B.CHAM_PER_MAX,nsdhm_dpam_id
,B.cham_bill_period,B.cham_bill_interval


/*MIN MAX CHARGES LOGIC*/
  ----transaction value wise charge  
  ------  
   
		update nsdl_holding_dtls  
		set    nsdhm_charge   =    
		isnull(case when cham_val_pers  = 'V' then cham_charge_value * -1   
		else case when (cham_charge_value/100)*(abs(nsdhm_qty)*clopm_nsdl_rt) <= cham_charge_minval then cham_charge_minval* -1  
		else (cham_charge_value/100)*(abs(nsdhm_qty)*clopm_nsdl_rt)* -1 end  
		end  ,0)  
		from nsdl_holding_dtls        
		,client_dp_brkg  
		,profile_charges  
		,charge_mstr   
		,closing_price_mstr_nsdl 
		where 
         nsdhm_dpam_id = clidb_dpam_id 
    	AND   clidb_brom_id = proc_profile_id  
		AND   proc_slab_no  = cham_slab_no   
		AND   nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt  
		and nsdhm_dpm_id = @pa_dpm_id 
		and   nsdhm_transaction_dt = clopm_dt    
	    AND   nsdhm_isin       = clopm_isin_cd      
		AND   nsdhm_transaction_dt >= clidb_eff_from_dt and  nsdhm_transaction_dt <= clidb_eff_to_dt  
		AND   isnull(cham_charge_graded,0) <> 1  
		AND   cham_charge_baseon           = 'TV'   
		AND   cham_charge_type = nsdhm_book_naar_cd  
		AND   (abs(nsdhm_qty)*clopm_nsdl_rt >= cham_from_factor)  and (abs(nsdhm_qty)*clopm_nsdl_rt <= cham_to_factor)    
		and   cham_deleted_ind = 1  
		and   clidb_deleted_ind = 1  
		and   nsdhm_deleted_ind = 1  
		and   proc_deleted_ind = 1  
		and   clopm_deleted_ind = 1  
        and   CHAM_CHARGE_BASE = 'NORMAL'
		and   NSDHM_QTY < 0
		and   ((NSDHM_BEN_ACCT_TYPE in ('10','11','30','20')) or (NSDHM_BEN_ACCT_TYPE = '14' and nsdhm_book_naar_cd = '093'))

  ----transaction value wise charge\  
    
    
  ----transaction qty wise charge  

	 update nsdl_holding_dtls  
	 set    nsdhm_charge   =  nsdhm_charge +  
	 isnull(cham_charge_value,0) * -1 
	 from nsdl_holding_dtls        
	 ,client_dp_brkg  
	 ,profile_charges  
	 ,charge_mstr   
	 where nsdhm_dpm_id = @pa_dpm_id
     AND   nsdhm_dpam_id = clidb_dpam_id 
	 AND   clidb_brom_id = proc_profile_id  
	 AND   proc_slab_no  = cham_slab_no    
	 AND   nsdhm_transaction_dt between   @pa_billing_from_dt and @pa_billing_to_dt
	 AND   nsdhm_transaction_dt >= clidb_eff_from_dt and  nsdhm_transaction_dt <= clidb_eff_to_dt  
	 AND   isnull(cham_charge_graded,0) <> 1  
	 AND   cham_charge_baseon           = 'TQ'   
	 AND   cham_charge_type = nsdhm_book_naar_cd  
	 AND   (abs(nsdhm_qty) >= cham_from_factor)  and (abs(nsdhm_qty) <= cham_to_factor)    
	 and   cham_deleted_ind = 1  
	 and   clidb_deleted_ind = 1  
	 and   nsdhm_deleted_ind = 1  
	 and   proc_deleted_ind = 1  
     and   CHAM_CHARGE_BASE = 'NORMAL'
	 and    NSDHM_QTY < case when NSDHM_BEN_ACCT_TYPE ='12' and nsdhm_book_naar_cd = '011' then 999999999999999 else 0 end 
	 and   ((NSDHM_BEN_ACCT_TYPE in ('10','11','30','20','12')) or (NSDHM_BEN_ACCT_TYPE = '14' and nsdhm_book_naar_cd = '093'))	 
     
  ----transaction qtywise charge  
  ----transaction instruction wise charge  
   
   
		insert into #temp_bill  
		(trans_dt   
		,dpam_id    
		,charge_name   
		,charge_val  
		,post_toacct)  
		select nsdhm_transaction_dt  
		,nsdhm_dpam_id  
		,cham_slab_name  
		,isnull(count(nsdhm_slip_no)*cham_charge_value ,0) * -1  
		,cham_post_toacct  
		from nsdl_holding_dtls        
		,client_dp_brkg  
		,profile_charges  
		,charge_mstr   
		where nsdhm_dpm_id = @pa_dpm_id 
        AND   nsdhm_dpam_id = clidb_dpam_id
		AND   clidb_brom_id = proc_profile_id  
		AND   proc_slab_no  = cham_slab_no   
		AND   nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt  
		AND   nsdhm_transaction_dt >= clidb_eff_from_dt and  nsdhm_transaction_dt <= clidb_eff_to_dt  
		AND   isnull(cham_charge_graded,0) <> 1  
			and   isnull(WAIVE_FLAG,'') <> 'Y'
		AND   cham_charge_baseon           = 'INST'   
		AND   cham_charge_type = nsdhm_book_naar_cd  
		and   cham_deleted_ind = 1  
		and   clidb_deleted_ind = 1  
		and   nsdhm_deleted_ind = 1  
        and   CHAM_CHARGE_BASE = 'NORMAL'
		and   proc_deleted_ind = 1  
		and   NSDHM_QTY < 0 
		and   ((NSDHM_BEN_ACCT_TYPE in ('10','11','30','20')) or (NSDHM_BEN_ACCT_TYPE = '14' and nsdhm_book_naar_cd = '093'))
		group by nsdhm_dpam_id,nsdhm_transaction_dt,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value ,cham_post_toacct 
		having (count(nsdhm_slip_no) >= cham_from_factor) and (count(nsdhm_slip_no) <= cham_to_factor)   
  ----transaction instruction wise charge  
    
   
    
   ----transaction per transaction no per slip no wise charge  
		 insert into #temp_bill  
		 (trans_dt   
		 ,dpam_id    
		 ,charge_name   
		 ,charge_val  
		 ,post_toacct)  
		 select nsdhm_transaction_dt  
		 ,nsdhm_dpam_id  
		 ,cham_slab_name  
		 ,isnull(case when count(nsdhm_dm_trans_no)*cham_charge_value <= cham_charge_minval then cham_charge_minval * -1 
		 else (count(nsdhm_dm_trans_no)*cham_charge_value) * -1 end    ,0)  
		 ,cham_post_toacct  
		 from nsdl_holding_dtls        
		 ,client_dp_brkg  
		 ,profile_charges  
		 ,charge_mstr   
		 where nsdhm_dpm_id = @pa_dpm_id 
         AND   nsdhm_dpam_id = clidb_dpam_id 
		 AND   clidb_brom_id = proc_profile_id  
		 AND   proc_slab_no  = cham_slab_no  
		 AND   nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt 
		 AND   nsdhm_transaction_dt >= clidb_eff_from_dt and  nsdhm_transaction_dt <= clidb_eff_to_dt  
		 AND   isnull(cham_charge_graded,0) <> 1  
			and   isnull(WAIVE_FLAG,'') <> 'Y'
		 AND   cham_charge_baseon           = 'TRANSPERSLIP'   
		 AND   nsdhm_book_naar_cd        not in( '011','012','013','021','022','023')  
		 AND   cham_charge_type = nsdhm_book_naar_cd  
		 and   cham_deleted_ind = 1  
		 and   clidb_deleted_ind = 1  
		 and   nsdhm_deleted_ind = 1  
		 and   proc_deleted_ind = 1 
         and   NSDHM_QTY < 0
		 and   NSDHM_BEN_ACCT_TYPE in ('10','11','30','20')   
         and   CHAM_CHARGE_BASE = 'NORMAL'
		 group by nsdhm_dpam_id,nsdhm_transaction_dt,cham_slab_name, cham_from_factor,cham_to_factor,cham_charge_value, cham_charge_minval  ,cham_post_toacct
		 having (count(nsdhm_dm_trans_no) >= cham_from_factor) and (count(nsdhm_dm_trans_no) <= cham_to_factor)   
   
		update nsdl_holding_dtls
		set nsdhm_charge = isnull(nsdhm_charge,0) + 
		isnull(case when demrm_total_certificates*cham_charge_value <= cham_charge_minval then cham_charge_minval * -1 
		else (demrm_total_certificates*cham_charge_value)* -1 end    ,0)  
		from nsdl_holding_dtls        
		,client_dp_brkg  
		,profile_charges  
		,charge_mstr   
		,demat_request_mstr  
		where nsdhm_dpm_id = @pa_dpm_id
        AND   nsdhm_dpam_id = clidb_dpam_id  
		AND   clidb_brom_id = proc_profile_id  
		AND   proc_slab_no  = cham_slab_no    
		AND   nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt  
		AND   nsdhm_transaction_dt >= clidb_eff_from_dt and  nsdhm_transaction_dt <= clidb_eff_to_dt  
		AND   convert(numeric,nsdhm_dpm_trans_no) = convert(numeric,demrm_drf_no)  
		AND   nsdhm_dpam_id = demrm_dpam_id  
		AND   isnull(cham_charge_graded,0) <> 1  
		AND   cham_charge_baseon           = 'TRANSPERSLIP'   
		AND   nsdhm_book_naar_cd           in( '011','012','013')  
		--AND   demrm_status                 = 'E'  
		AND   cham_charge_type      = nsdhm_book_naar_cd  
		AND   (demrm_total_certificates >= cham_from_factor) and (demrm_total_certificates<= cham_to_factor)   
		and   cham_deleted_ind = 1  
		and   clidb_deleted_ind = 1  
		and   nsdhm_deleted_ind = 1  
		and   proc_deleted_ind = 1  
        and   CHAM_CHARGE_BASE = 'NORMAL'
		and   NSDHM_BEN_ACCT_TYPE in ('10','11','12','30')  
		and   demrm_deleted_ind = 1
		
		/*NEW CHARGES*/
		update nsdl_holding_dtls
		set nsdhm_charge = isnull(nsdhm_charge,0) + 
		isnull(case when DEMRM_QTY *(CONVERT(NUMERIC(10,2),cham_charge_value)/CONVERT(NUMERIC(10,2),CHAM_CHARGE_MINVAL)) < DEMRM_TOTAL_CERTIFICATES*CHAM_PER_MIN then  DEMRM_TOTAL_CERTIFICATES*CHAM_PER_MIN * -1 
		else DEMRM_QTY *(CONVERT(NUMERIC(10,2),cham_charge_value)/CONVERT(NUMERIC(10,2),CHAM_CHARGE_MINVAL)) end    ,0)  
		from nsdl_holding_dtls        
		,client_dp_brkg  
		,profile_charges  
		,charge_mstr   
		,demat_request_mstr  
		where nsdhm_dpm_id = @pa_dpm_id
        AND   nsdhm_dpam_id = clidb_dpam_id  
		AND   clidb_brom_id = proc_profile_id  
		AND   proc_slab_no  = cham_slab_no    
		AND   nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt  
		AND   nsdhm_transaction_dt >= clidb_eff_from_dt and  nsdhm_transaction_dt <= clidb_eff_to_dt  
		AND   convert(numeric,nsdhm_dpm_trans_no) =  convert(numeric,demrm_drf_no ) 
		AND   nsdhm_dpam_id = demrm_dpam_id  
		AND   isnull(cham_charge_graded,0) <> 1  
		AND   cham_charge_baseon           = 'CQ'   
		AND   nsdhm_book_naar_cd           in( '011','012','013')  
		--AND   demrm_status                 = 'E'  
		AND   cham_charge_type      = nsdhm_book_naar_cd  
		and   cham_deleted_ind = 1  
		and   clidb_deleted_ind = 1  
		and   nsdhm_deleted_ind = 1  
		and   proc_deleted_ind = 1  
        and   CHAM_CHARGE_BASE = 'NORMAL'
		and   NSDHM_BEN_ACCT_TYPE in ('10','12','11','30')  
		and   demrm_deleted_ind = 1
		/*NEW CHARGES*/

		update nsdl_holding_dtls
		set nsdhm_charge = isnull(nsdhm_charge,0) + 
		isnull(case when REMRM_CERTIFICATE_NO*cham_charge_value <= cham_charge_minval then cham_charge_minval * -1 
		else (REMRM_CERTIFICATE_NO*cham_charge_value)* -1 end    ,0)  
		from nsdl_holding_dtls        
		,client_dp_brkg  
		,profile_charges  
		,charge_mstr   
		,remat_request_mstr  
		where nsdhm_dpm_id = @pa_dpm_id
        AND   nsdhm_dpam_id = clidb_dpam_id  
		AND   clidb_brom_id = proc_profile_id  
		AND   proc_slab_no  = cham_slab_no    
		AND   nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt  
		AND   nsdhm_transaction_dt >= clidb_eff_from_dt and  nsdhm_transaction_dt <= clidb_eff_to_dt  
		AND   nsdhm_dpm_trans_no = remrm_rrf_no  
		AND   nsdhm_dpam_id = remrm_dpam_id  
		AND   isnull(cham_charge_graded,0) <> 1  
		AND   cham_charge_baseon           = 'TRANSPERSLIP'   
		AND   nsdhm_book_naar_cd           in( '021','022','023')  
		--AND   remrm_status                 = 'E'  
		AND   cham_charge_type      = nsdhm_book_naar_cd  
		AND   (REMRM_CERTIFICATE_NO >= cham_from_factor) and (REMRM_CERTIFICATE_NO<= cham_to_factor)   
		and   cham_deleted_ind = 1  
		and   clidb_deleted_ind = 1  
		and   nsdhm_deleted_ind = 1  
        and   CHAM_CHARGE_BASE = 'NORMAL'
		and   proc_deleted_ind = 1  
		and   NSDHM_BEN_ACCT_TYPE in ('10','12','11','30')  
		and   remrm_deleted_ind = 1

--  update nsdl_holding_dtls
--		set nsdhm_charge = isnull(nsdhm_charge,0) + 
--		isnull(case when rEMRM_QTY *(CONVERT(NUMERIC(10,2),cham_charge_value)/CONVERT(NUMERIC(10,2),CHAM_CHARGE_MINVAL)) < REMRM_CERTIFICATE_NO*CHAM_PER_MIN then  REMRM_CERTIFICATE_NO*CHAM_PER_MIN * -1 
--		else rEMRM_QTY *(CONVERT(NUMERIC(10,2),cham_charge_value)/CONVERT(NUMERIC(10,2),CHAM_CHARGE_MINVAL)) end    ,0)  
--		from nsdl_holding_dtls        
--		,client_dp_brkg  
--		,profile_charges  
--		,charge_mstr   
--		,remat_request_mstr  
--		where nsdhm_dpm_id = @pa_dpm_id
--        AND   nsdhm_dpam_id = clidb_dpam_id  
--		AND   clidb_brom_id = proc_profile_id  
--		AND   proc_slab_no  = cham_slab_no    
--		AND   nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt  
--		AND   nsdhm_transaction_dt >= clidb_eff_from_dt and  nsdhm_transaction_dt <= clidb_eff_to_dt  
--		AND   convert(numeric,nsdhm_dpm_trans_no) =  convert(numeric,REMRM_RRF_NO ) 
--		AND   nsdhm_dpam_id = remrm_dpam_id  
--		AND   isnull(cham_charge_graded,0) <> 1  
--		AND   cham_charge_baseon           = 'CQ'   
--		AND   nsdhm_book_naar_cd           in( '021','022','023')  
--		--AND   demrm_status                 = 'E'  
--		AND   cham_charge_type      = nsdhm_book_naar_cd  
--		and   cham_deleted_ind = 1  
--		and   clidb_deleted_ind = 1  
--		and   nsdhm_deleted_ind = 1  
--		and   proc_deleted_ind = 1  
--        and   CHAM_CHARGE_BASE = 'NORMAL'
--		and   NSDHM_BEN_ACCT_TYPE in ('10','12','11','30')  
--		and   remrm_deleted_ind = 1
        
		update nsdl_holding_dtls 
		set nsdhm_charge   =  round(nsdhm_charge,2) 
		where nsdhm_transaction_dt between   @pa_billing_from_dt and @pa_billing_to_dt and nsdhm_dpm_id = @pa_dpm_id           
		 

		select top 1 @l_post_toacct = cham_post_toacct 
		from  charge_mstr,profile_charges,client_dp_brkg 
		where 	clidb_brom_id = proc_profile_id
		AND   proc_slab_no  = cham_slab_no
		and cham_charge_type = '042' and cham_deleted_ind  = 1 
		and @pa_billing_to_dt between clidb_eff_from_dt and clidb_eff_to_dt	
		and clidb_deleted_ind = 1
        and   CHAM_CHARGE_BASE = 'NORMAL'


                   IF EXISTS(SELECT bitrm_id FROM bitmap_ref_mstr WHERE bitrm_parent_cd = 'BILL_CLI_ADD_DP_CHRG_NSDL' AND BITRM_BIT_LOCATION = @pa_dpm_id AND BITRM_VALUES = 1 )
					BEGIN

						UPDATE NSDL_holding_dtls 
						SET NSDHM_CHARGE = isnull(NSDHM_CHARGE,0) + isnull(NSDHM_DP_CHARGE,0)
						WHERE nsdhm_dpm_id = @pa_dpm_id and nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt 					

/*
						--033 condition hard coded for NSDL banglore for not applying intra charges to brokers pool account						
						UPDATE  H
						SET NSDHM_CHARGE = isnull(NSDHM_CHARGE,0) + isnull(NSDHM_DP_CHARGE,0)
						FROM NSDL_holding_dtls H,DP_ACCT_MSTR
						WHERE nsdhm_dpam_id = dpam_id and nsdhm_dpm_id = dpam_dpm_id 
						and nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt
						and (NSDHM_BOOK_NAAR_CD <> '033' or dpam_enttm_cd <> '03') and nsdhm_dpm_id = @pa_dpm_id 
						and dpam_deleted_ind = 1					
						--033 condition hard coded for NSDL banglore for not applying intra charges to brokers pool account
*/
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
						FROM DP_CHARGES_NSDL dcc	
						WHERE DPCH_DPM_ID = @pa_dpm_id  
						AND   DPCH_TRANC_DT between  @pa_billing_from_dt and @pa_billing_to_dt
						AND   DPCH_CHARGE_NAME <> 'TRANSACTION CHARGES'
                        AND   DPCH_CHARGE_NAME NOT like  '%SER%TAX%' AND DPCH_CHARGE_NAME NOT LIKE '% CESS %'
						GROUP BY DPCH_dpam_id,	DPCH_CHARGE_NAME,DPCH_TRANC_DT
					END
					
					

				insert into #temp_bill(trans_dt,dpam_id,charge_name,charge_val,post_toacct) 
				Exec Pr_CalculateInterest 'NSDL',@pa_dpm_id,@@FINID, @pa_billing_to_dt, @l_post_toacct


exec pr_charge_waive_nsdl @pa_dpm_id,'WaiveFlagupdate','','0','0',@pa_billing_from_dt,@pa_billing_to_dt,'','',''


				 insert into #temp_bill  
				 (trans_dt     
				 ,dpam_id      
				 ,charge_name     
				 ,charge_val  
				 ,post_toacct)   
				 select nsdhm_transaction_dt   
				 , nsdhm_dpam_id  
				 , 'TRANSACTION CHARGES'  
				 , sum(nsdhm_charge) 
				 , @l_post_toacct   
				 from nsdl_holding_dtls       
				 WHERE nsdhm_dpm_id = @pa_dpm_id    
				 and   nsdhm_transaction_dt between  @pa_billing_from_dt and @pa_billing_to_dt  
				 and   nsdhm_deleted_ind =1 
				 --and   NSDHM_BEN_ACCT_TYPE in ('10','11','30','14','12')  
				 group by  nsdhm_dpam_id,nsdhm_transaction_dt
				 having isnull(sum(nsdhm_charge),0) <> 0 
    
  
       
        
 --logic for charge on amount like service tax  
		 insert into #temp_bill    
		 (trans_dt     
		 ,dpam_id      
		 ,charge_name     
		 ,charge_val  
		 ,post_toacct)   
		 select trans_dt
		 ,dpam_id  
		 ,cham_slab_name  
		 ,Charge_amt=sum(case when cham_val_pers  = 'V' then cham_charge_value * -1     
		 else case when  ABS((cham_charge_value/100)*charge_val) <= cham_charge_minval then cham_charge_minval    * -1
		 else ((cham_charge_value/100)*charge_val) end    
		 end)      
		 ,cham_post_toacct  
		 from #temp_bill  a
		 ,client_dp_brkg    
		 ,profile_charges    
		 ,charge_mstr
 
		 where trans_dt >= clidb_eff_from_dt and  trans_dt <= clidb_eff_to_dt  
		 AND   a.dpam_id     = clidb_dpam_id   
		 AND   clidb_brom_id = proc_profile_id    
		 AND   proc_slab_no  = cham_slab_no    
		 AND   isnull(cham_charge_graded,0) <> 1    
		 AND   cham_charge_type       = 'AMT'     
		 and   cham_deleted_ind = 1    
		 and   clidb_deleted_ind = 1    
		 and   proc_deleted_ind = 1 
        and   CHAM_CHARGE_BASE = 'NORMAL'
		and not exists(select src_chargename,on_chargename from ExcludeTransCharges
		where src_chargename = charge_name and on_chargename = cham_slab_name and for_type = 'C' and  dpm_id = @pa_dpm_id)

		 group by dpam_id,cham_slab_name,cham_post_toacct   ,trans_dt


 


 --logic for charge on amount like service tax  
   
       
		delete from client_charges_nsdl 
        where clic_trans_dt between @pa_billing_from_dt and @pa_billing_to_dt 
        and clic_flg = 'S' 
        and clic_dpm_id = @pa_dpm_id
        and clic_deleted_ind = 1 
		    
		insert into client_charges_nsdl(clic_trans_dt  
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
		,'S'  
		,'HO'  
		,getdate()  
		,'HO'  
		,getdate()  
		,1  
		,post_toacct  
		from  #temp_bill   
   
   
   
 ----transaction per transaction no per slip no wise charge  
   
  --logic for transaction type wise charge  
    
    
    
    
    
--  
end

GO
