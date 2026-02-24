-- Object: PROCEDURE citrus_usr.pr_get_txt_filegen_NewOneJul142017
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--pr_get_txt_filegen_NewOneJul142017 'client','12033200','','','jun 01 2017','jun 30 2017'
CREATE proc [citrus_usr].[pr_get_txt_filegen_NewOneJul142017](@pa_action varchar(100),@pa_dpid varchar(100)    
,@pa_boid varchar(100)    
,@pa_isin varchar(100)    
,@pa_from_date datetime    
,@pa_to_date datetime    
)    
as    
begin    
  
-- FOR ECNFLAG


SELECT DISTINCT ACCP_VALUE, ACCP_CLISBA_ID , ACCP_ACCPM_PROP_CD 
INTO #ACCOUNT_PROPERTIES_ECN FROM ACCOUNT_PROPERTIES 
WHERE ACCP_ACCPM_PROP_CD = 'ECN_FLAG' 
AND ACCP_VALUE NOT IN ('','//') AND ACCP_VALUE='NO'

insert into #ACCOUNT_PROPERTIES_ECN 
select '',dpam_id , '' from dp_acct_mstr where
 not exists (select 1 from ACCOUNT_PROPERTIES where accp_clisba_id = dpam_id 
and ACCP_ACCPM_PROP_CD ='ECN_FLAG')


SELECT * INTO #TMP_CLIENT_CHARGES_CDSL FROM (
select CLIC_DPAM_ID ,CLIC_TRANS_DT  from cLIENT_CHARGES_CDSL  WITH(NOLOCK)  ,dp_acct_mstr   WITH(NOLOCK)  where 
CLIC_TRANS_DT between citrus_usr.ufn_GetFirstDayOfMonth(@pa_from_date) and @pa_to_date
AND CLIC_DPAM_ID = DPAM_ID AND CASE WHEN @pa_boid ='' THEN '1' ELSE DPAM_SBA_NO END = CASE WHEN @pa_boid ='' THEN '1' ELSE @pa_boid END 
UNION 
select CDSHM_DPAM_ID CLIC_DPAM_ID , CDSHM_TRAS_DT  CLIC_TRANS_DT from CDSL_HOLDING_DTLS WITH(NOLOCK) where 
CDSHM_TRAS_DT  between citrus_usr.ufn_GetFirstDayOfMonth(@pa_from_date) and @pa_to_date
 AND CASE WHEN @pa_boid ='' THEN '1' ELSE CDSHM_BEN_ACCT_NO   END = CASE WHEN @pa_boid ='' THEN '1' ELSE @pa_boid END 
 and cdshm_tratm_cd in('2246','2277','2201','3102','2270','2220','2262','2251','2202','2205','2280') 
)  A 
     


-- FOR ECNFLAG

--SELECT DISTINCT '' ACCP_VALUE, dpam_id ACCP_CLISBA_ID , '' ACCP_ACCPM_PROP_CD 
--INTO #ACCOUNT_PROPERTIES_ECN FROM dp_acct_mstr,TMP_BOUNCEBACK_MSTR
--where DPAM_SBA_NO=[Client  id]

--insert into #ACCOUNT_PROPERTIES_ECN 
--select '',dpam_id , '' from dp_acct_mstr where
--  exists (select 1 from ACCOUNT_PROPERTIES where accp_clisba_id = dpam_id 
--and ACCP_ACCPM_PROP_CD ='ECN_FLAG')


    
  if @pa_action = 'HOLDING'    
  begin     
  create table #holdingallforview  
  (DPHMCD_DPM_ID numeric  
  ,DPHMCD_DPAM_ID numeric  
  ,DPHMCD_ISIN varchar(100)  
  ,DPHMCD_CURR_QTY numeric(18,3)  
  ,DPHMCD_FREE_QTY numeric(18,3)  
  ,DPHMCD_FREEZE_QTY numeric(18,3)  
  ,DPHMCD_PLEDGE_QTY numeric(18,3)  
  ,DPHMCD_DEMAT_PND_VER_QTY numeric(18,3)  
  ,DPHMCD_REMAT_PND_CONF_QTY numeric(18,3)  
  ,DPHMCD_DEMAT_PND_CONF_QTY numeric(18,3)  
  ,DPHMCD_SAFE_KEEPING_QTY numeric(18,3)  
  ,DPHMCD_LOCKIN_QTY numeric(18,3)  
  ,DPHMCD_ELIMINATION_QTY numeric(18,3)  
  ,DPHMCD_EARMARK_QTY numeric(18,3)  
  ,DPHMCD_AVAIL_LEND_QTY numeric(18,3)  
  ,DPHMCD_LEND_QTY numeric(18,3)  
  ,DPHMCD_BORROW_QTY numeric(18,3)  
  ,dphmcd_holding_dt datetime)   
    
  if @pa_boid <> '' and not exists (select 1 from DP_HLDG_MSTR_CDSL_MONTHEND_HOLDING where dphmc_holding_dt=@pa_to_date)  
  insert into #holdingallforview(DPHMCD_DPM_ID   
  ,DPHMCD_DPAM_ID   
  ,DPHMCD_ISIN   
  ,DPHMCD_CURR_QTY   
  ,DPHMCD_FREE_QTY   
  ,DPHMCD_FREEZE_QTY   
  ,DPHMCD_PLEDGE_QTY   
  ,DPHMCD_DEMAT_PND_VER_QTY   
  ,DPHMCD_REMAT_PND_CONF_QTY   
  ,DPHMCD_DEMAT_PND_CONF_QTY   
  ,DPHMCD_SAFE_KEEPING_QTY   
  ,DPHMCD_LOCKIN_QTY   
  ,DPHMCD_ELIMINATION_QTY   
  ,DPHMCD_EARMARK_QTY   
  ,DPHMCD_AVAIL_LEND_QTY   
  ,DPHMCD_LEND_QTY   
  ,DPHMCD_BORROW_QTY   
  ,dphmcd_holding_dt)  
  exec [pr_get_holding_fix_latest] 3,@pa_to_date,@pa_to_date,@pa_boid,@pa_boid,''    
  
  if @pa_boid <> '' and  exists (select 1 from DP_HLDG_MSTR_CDSL_MONTHEND_HOLDING where dphmc_holding_dt=@pa_to_date)  
  insert into #holdingallforview(DPHMCD_DPM_ID   
  ,DPHMCD_DPAM_ID   
  ,DPHMCD_ISIN   
  ,DPHMCD_CURR_QTY   
  ,DPHMCD_FREE_QTY   
  ,DPHMCD_FREEZE_QTY   
  ,DPHMCD_PLEDGE_QTY   
  ,DPHMCD_DEMAT_PND_VER_QTY   
  ,DPHMCD_REMAT_PND_CONF_QTY   
  ,DPHMCD_DEMAT_PND_CONF_QTY   
  ,DPHMCD_SAFE_KEEPING_QTY   
  ,DPHMCD_LOCKIN_QTY   
  ,DPHMCD_ELIMINATION_QTY   
  ,DPHMCD_EARMARK_QTY   
  ,DPHMCD_AVAIL_LEND_QTY   
  ,DPHMCD_LEND_QTY   
  ,DPHMCD_BORROW_QTY   
  ,dphmcd_holding_dt)  
  select  DPHMC_DPM_ID   
  ,DPHMC_DPAM_ID   
  ,DPHMC_ISIN   
  ,DPHMC_CURR_QTY   
  ,DPHMC_FREE_QTY   
  ,DPHMC_FREEZE_QTY   
  ,DPHMC_PLEDGE_QTY   
  ,DPHMC_DEMAT_PND_VER_QTY   
  ,DPHMC_REMAT_PND_CONF_QTY   
  ,DPHMC_DEMAT_PND_CONF_QTY   
  ,DPHMC_SAFE_KEEPING_QTY   
  ,DPHMC_LOCKIN_QTY   
  ,DPHMC_ELIMINATION_QTY   
  ,DPHMC_EARMARK_QTY   
  ,DPHMC_AVAIL_LEND_QTY   
  ,DPHMC_LEND_QTY   
  ,DPHMC_BORROW_QTY   
  ,dphmc_holding_dt from DP_HLDG_MSTR_CDSL_MONTHEND_HOLDING , dp_acct_mstr 
  where dphmc_dpam_id = DPAM_ID and DPAM_SBA_NO = @pa_boid and  dphmc_holding_dt = @pa_to_date
  
  
  if @pa_boid = ''  and not exists (select 1 from DP_HLDG_MSTR_CDSL_MONTHEND_HOLDING where dphmc_holding_dt=@pa_to_date)    
  insert into #holdingallforview(DPHMCD_DPM_ID   
  ,DPHMCD_DPAM_ID   
  ,DPHMCD_ISIN   
  ,DPHMCD_CURR_QTY   
  ,DPHMCD_FREE_QTY   
  ,DPHMCD_FREEZE_QTY   
  ,DPHMCD_PLEDGE_QTY   
  ,DPHMCD_DEMAT_PND_VER_QTY   
  ,DPHMCD_REMAT_PND_CONF_QTY   
  ,DPHMCD_DEMAT_PND_CONF_QTY   
  ,DPHMCD_SAFE_KEEPING_QTY   
  ,DPHMCD_LOCKIN_QTY   
  ,DPHMCD_ELIMINATION_QTY   
  ,DPHMCD_EARMARK_QTY   
  ,DPHMCD_AVAIL_LEND_QTY   
  ,DPHMCD_LEND_QTY   
  ,DPHMCD_BORROW_QTY   
  ,dphmcd_holding_dt)  
  exec [pr_get_holding_fix_latest] 3,@pa_to_date,@pa_to_date,'0','9999999999999999','' 
  
  
  if @pa_boid = ''  and  exists (select 1 from DP_HLDG_MSTR_CDSL_MONTHEND_HOLDING where dphmc_holding_dt=@pa_to_date)    
  insert into #holdingallforview(DPHMCD_DPM_ID   
  ,DPHMCD_DPAM_ID   
  ,DPHMCD_ISIN   
  ,DPHMCD_CURR_QTY   
  ,DPHMCD_FREE_QTY   
  ,DPHMCD_FREEZE_QTY   
  ,DPHMCD_PLEDGE_QTY   
  ,DPHMCD_DEMAT_PND_VER_QTY   
  ,DPHMCD_REMAT_PND_CONF_QTY   
  ,DPHMCD_DEMAT_PND_CONF_QTY   
  ,DPHMCD_SAFE_KEEPING_QTY   
  ,DPHMCD_LOCKIN_QTY   
  ,DPHMCD_ELIMINATION_QTY   
  ,DPHMCD_EARMARK_QTY   
  ,DPHMCD_AVAIL_LEND_QTY   
  ,DPHMCD_LEND_QTY   
  ,DPHMCD_BORROW_QTY   
  ,dphmcd_holding_dt)  
  select  DPHMC_DPM_ID   
  ,DPHMC_DPAM_ID   
  ,DPHMC_ISIN   
  ,DPHMC_CURR_QTY   
  ,DPHMC_FREE_QTY   
  ,DPHMC_FREEZE_QTY   
  ,DPHMC_PLEDGE_QTY   
  ,DPHMC_DEMAT_PND_VER_QTY   
  ,DPHMC_REMAT_PND_CONF_QTY   
  ,DPHMC_DEMAT_PND_CONF_QTY   
  ,DPHMC_SAFE_KEEPING_QTY   
  ,DPHMC_LOCKIN_QTY   
  ,DPHMC_ELIMINATION_QTY   
  ,DPHMC_EARMARK_QTY   
  ,DPHMC_AVAIL_LEND_QTY   
  ,DPHMC_LEND_QTY   
  ,DPHMC_BORROW_QTY   
  ,dphmc_holding_dt from DP_HLDG_MSTR_CDSL_MONTHEND_HOLDING 
  where dphmc_holding_dt = @pa_to_date
  
      
     select dpam_sba_no +'|'+dphmcd_isin+'|'+isin_name 
     +'|'+convert(varchar,case when left(dphmcd_isin ,3) = 'INF' then convert(numeric(18,3),DPHMCd_FREEZE_QTY) else convert(numeric(18,2),DPHMCd_FREEZE_QTY) end )   
     +'|'+convert(varchar,case when left(dphmcd_isin ,3) = 'INF' then convert(numeric(18,3),DPHMCd_PLEDGE_QTY) else  convert(numeric(18,2),DPHMCd_PLEDGE_QTY) end ) 
     +'|'+convert(varchar,case when left(dphmcd_isin ,3) = 'INF' then convert(numeric(18,3),DPHMCD_free_QTY) else convert(numeric(18,2),DPHMCD_free_QTY) end )           
     +'|'+convert(varchar,case when left(dphmcd_isin ,3) = 'INF' then convert(numeric(18,3),DPHMCd_LOCKIN_QTY) else convert(numeric(18,2),DPHMCd_LOCKIN_QTY) end )     
     +'|'+CONVERT(varchar,0)    
     +'|'+convert(varchar,case when left(dphmcd_isin ,3) = 'INF' then convert(numeric(18,3),DPHMCd_DEMAT_PND_VER_QTY) else convert(numeric(18,2),DPHMCd_DEMAT_PND_VER_QTY) end )       
     +'|'+CONVERT(varchar,0)    
     +'|'+CONVERT(varchar,0)    
     +'|'+CONVERT(varchar,0)    
     +'|'+CONVERT(varchar,0)    
     +'|'+CONVERT(varchar,isnull(convert(numeric(18,2),CLOPM_CDSL_RT),'0')) as value from #holdingallforview with (nolock)
     LEFT OUTER JOIN  CLOSING_PRICE_MSTR_cdsl ON DPHMCD_ISIN = CLOPM_ISIN_CD AND ISNULL(CLOPM_DT,'01/01/1900') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_cdsl WHERE CLOPM_ISIN_CD = DPHMCD_ISIN and CLOPM_DT <= @pa_to_date and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc)                                                             
     , dp_acct_mstr with (nolock), ISIN_MSTR with (nolock)    ,
     #ACCOUNT_PROPERTIES_ECN
     where DPHMCD_DPAM_ID = DPAM_ID   and ACCP_CLISBA_ID=dpam_id  
     and  ISIN_CD = DPHMCD_ISIN     
     and DPAM_DELETED_IND = 1     
     and DPAM_SBA_NO like  @pa_boid + '%' and DPHMCD_ISIN like @pa_isin + '%'    
     and exists(select 1 from #TMP_CLIENT_CHARGES_CDSL where CLIC_DPAM_ID = DPHMCD_DPAM_ID 
     and CLIC_TRANS_DT between citrus_usr.ufn_GetFirstDayOfMonth(@pa_from_date) and @pa_to_date ) 
     and not exists (select client_code from angelownaccount where client_code=dpam_sba_no) 
       
       
       
  end     
  if @pa_action = 'TRX'    
  begin     
  
  create table #ob(ob_cdshm_dpm_id numeric,ob_cdshm_dpam_id numeric,ob_cdshm_isin varchar(100),ob numeric(18,3))
  if @pa_boid <>'' 
  insert into #ob
  exec [pr_get_ob_fix] 3,@pa_from_date,@pa_to_date,@pa_boid,@pa_boid,''
  if @pa_boid ='' 
  insert into #ob
  exec [pr_get_ob_fix] 3,@pa_from_date,@pa_to_date,'0','9999999999999999',''
  
   
     
      
   select identity(numeric,1,1) id,cdshm_dpam_id ,cdshm_isin , convert(numeric(18,3),cdshm_qty) cdshm_qty, ISNULL(convert(numeric(18,3),ob),0) ob ,cdshm_tras_dt,  cdshm_ben_acct_no +'|'    
   +CONVERT(varchar(11),cdshm_tras_dt,112) +'|'    
   +cdshm_trans_no +'|'    
   +cdshm_isin +'|'+isin_name +'|'+CDSHM_TRATM_DESC +'|'++'|'+convert(varchar,'####')+'|'+case when CDSHM_QTY > 0 then 'C' else 'D' end     
   +'|'+isnull(cdshm_internal_trastm,'')--MKTRXD    
   +'|'+convert(varchar,abs(convert(numeric(18,3),cdshm_qty)))--1000    
   +'|'+convert(varchar,'$$$$')  
   +'|'++'|'+ convert(varchar,abs(convert(numeric(18,2),cdshm_charge)))as value--11   
   , CDSHM_TRATM_CD
   into #tempdata from cdsl_holding_dtls with(nolock) left outer join #ob 
   on CDSHM_DPAM_ID = ob_cdshm_dpam_id and CDSHM_ISIN = ob_cdshm_isin ,ISIN_MSTR with(nolock)
   ,#ACCOUNT_PROPERTIES_ECN where cdshm_ben_acct_no like  @pa_boid + '%' and cdshm_isin like @pa_isin + '%'    
   and ISIN_CD = cdshm_isin    
   and ACCP_CLISBA_ID=CDSHM_DPAM_ID
   and CDSHM_TRATM_DESC is not null    
   and CDSHM_TRAS_DT between @pa_from_date and @pa_to_date   
    and exists(select 1 from #TMP_CLIENT_CHARGES_CDSL where CLIC_DPAM_ID = CDSHM_DPAM_ID  and CLIC_TRANS_DT between @pa_from_date and @pa_to_date )  
    and CDSHM_TRATM_CD in  ('2246','2277','2201','3102','2270','2220','2205')    
    and not exists (select client_code from angelownaccount where client_code=CDSHM_BEN_ACCT_NO)
    order by CDSHM_DPAM_ID ,CDSHM_TRAS_DT, CDSHM_ISIN,case when CDSHM_QTY > 0 then 'C' else 'D' end
    
    
    
    
    select *,ob+ isnull((select SUM( cdshm_qty )  
    from #tempdata t2 where t1.CDSHM_ISIN= t2.CDSHM_ISIN and t1.CDSHM_DPAM_ID = t2.CDSHM_DPAM_ID 
    and t2.id<=t1.id  and t2.CDSHM_TRATM_CD <>'2201'
    ),0) closingbalance   into #tempfinal from #tempdata t1 
    
    select --*,closingbalance-cdshm_qty openingbalance , 
    replace(replace(value,'$$$$',closingbalance),'####',closingbalance-case when CDSHM_TRATM_CD ='2201' then 0 else cdshm_qty end) as value
    from #tempfinal  order by id 
    
    --select *,ob+(select SUM(cdshm_qty) from #tempdata t2 where t1.CDSHM_ISIN= t2.CDSHM_ISIN and t1.CDSHM_DPAM_ID = t2.CDSHM_DPAM_ID 
    --and t2.id<=t1.id
    --)  runningbalance , replace(REPLACE(value,'$$$$',convert(varchar,ob+(select SUM(cdshm_qty) from #tempdata t2 where t1.CDSHM_ISIN= t2.CDSHM_ISIN and t1.CDSHM_DPAM_ID = t2.CDSHM_DPAM_ID 
    --and t2.id<=t1.id
    --))),'####',convert(varchar,ob+(select SUM(cdshm_qty) from #tempdata t2 where t1.CDSHM_ISIN= t2.CDSHM_ISIN and t1.CDSHM_DPAM_ID = t2.CDSHM_DPAM_ID 
    --and t2.id<=t1.id
    --)-cdshm_qty)) value from #tempdata t1     
       
       
      
  end     
  if @pa_action = 'CLIENT'    
  begin
  
  
  declare @l_fin_id numeric 
  select   @l_fin_id = fin_id from Financial_Yr_Mstr where @pa_from_date between FIN_START_DT and FIN_END_DT and FIN_DELETED_IND =1 
  declare @sql varchar(8000)
  set @sql = ''
  select @sql  = 'select dpam_sba_no OS_boid,ldg_ref_no, sum(ldg_amount) OS into ##billed_os from ledger'+convert(varchar,@l_fin_id)
  select @sql  = @sql + ' , dp_Acct_mstr where dpam_id = ldg_account_id and ldg_account_type =''p'' and ldg_deleted_ind = 1'
  select @sql  = @sql + ' and exists (select 1 from #TMP_CLIENT_CHARGES_CDSL where clic_dpam_id = dpam_id and CLIC_TRANS_DT between '''+ CONVERT(varchar(11),@pa_from_date,109) + ''' and  ''' +  CONVERT(varchar(11),@pa_to_date,109)
  select @sql  = @sql + ''') and ldg_voucher_dt < ''' + CONVERT(varchar(11),@pa_from_date,109)
  select @sql  = @sql + ''' group by dpam_sba_no ,ldg_ref_no'
  print @sql
  exec(@sql) 
  
  select * into #billed_os from ##billed_os
  drop table ##billed_os
  
  
  declare @sql22 varchar(8000)
  set @sql22 = ''
  select @sql22  = 'select dpam_sba_no OS_boid22,ldg_ref_no ldg_ref_no22, sum(ldg_amount) OS22 into ##billed_os22 from ledger'+convert(varchar,@l_fin_id)
  select @sql22  = @sql22 + ' , dp_Acct_mstr where dpam_id = ldg_account_id and ldg_account_type =''p'' and ldg_deleted_ind = 1'
  select @sql22  = @sql22 + ' and exists (select 1 from #TMP_CLIENT_CHARGES_CDSL where clic_dpam_id = dpam_id and CLIC_TRANS_DT between '''+ CONVERT(varchar(11),@pa_from_date,109) + ''' and  ''' +  CONVERT(varchar(11),@pa_to_date,109)
  select @sql22  = @sql22 + ''') and ldg_voucher_dt < ''' + CONVERT(varchar(11),@pa_to_date,109)
  select @sql22  = @sql22 + ''' group by dpam_sba_no ,ldg_ref_no '
  print @sql22
  exec(@sql22) 
  
  select * into #billed_os22 from ##billed_os22
  drop table ##billed_os22
  
  SELECT DPAM_SBA_NO CLIC_BO_ID ,   SUM(CLIC_CHARGE_AMT) AMT INTO #BILLAMT FROM CLIENT_CHARGES_CDSL , DP_ACCT_MSTR 
  WHERE CLIC_TRANS_DT BETWEEN @pa_from_date and @pa_to_date 
  AND CLIC_DPAM_ID= DPAM_ID AND DPAM_DELETED_IND = 1
  AND CLIC_DELETED_IND = 1 
  AND CLIC_CHARGE_NAME <>'SERVICE TAX' GROUP BY DPAM_SBA_NO
  
  --SELECT DPAM_SBA_NO CLIC_BO_ID_ST ,   SUM(CLIC_CHARGE_AMT) STAMT INTO #STAMT FROM CLIENT_CHARGES_CDSL , DP_ACCT_MSTR 
  --WHERE CLIC_TRANS_DT BETWEEN @pa_from_date and @pa_to_date 
  --AND CLIC_DPAM_ID= DPAM_ID AND DPAM_DELETED_IND = 1
  --AND CLIC_DELETED_IND = 1 
  --AND CLIC_CHARGE_NAME ='SERVICE TAX' 
  --GROUP BY DPAM_SBA_NO
  
    SELECT DPAM_SBA_NO CLIC_BO_ID_CGST ,   SUM(CLIC_CHARGE_AMT) CGSTAMT INTO #CGSTAMT FROM CLIENT_CHARGES_CDSL , DP_ACCT_MSTR 
  WHERE CLIC_TRANS_DT BETWEEN @pa_from_date and @pa_to_date 
  AND CLIC_DPAM_ID= DPAM_ID AND DPAM_DELETED_IND = 1
  AND CLIC_DELETED_IND = 1 
  --AND CLIC_CHARGE_NAME ='SERVICE TAX' 
  AND CLIC_CHARGE_NAME in ('CGST')
  GROUP BY DPAM_SBA_NO
  
    SELECT DPAM_SBA_NO CLIC_BO_ID_SGST ,   SUM(CLIC_CHARGE_AMT) SGSTAMT INTO #SGSTAMT FROM CLIENT_CHARGES_CDSL , DP_ACCT_MSTR 
  WHERE CLIC_TRANS_DT BETWEEN @pa_from_date and @pa_to_date 
  AND CLIC_DPAM_ID= DPAM_ID AND DPAM_DELETED_IND = 1
  AND CLIC_DELETED_IND = 1 
  --AND CLIC_CHARGE_NAME ='SERVICE TAX' 
  AND CLIC_CHARGE_NAME in ('SGST')
  GROUP BY DPAM_SBA_NO
  
    SELECT DPAM_SBA_NO CLIC_BO_ID_UGST ,   SUM(CLIC_CHARGE_AMT) UGSTAMT INTO #UGSTAMT FROM CLIENT_CHARGES_CDSL , DP_ACCT_MSTR 
  WHERE CLIC_TRANS_DT BETWEEN @pa_from_date and @pa_to_date 
  AND CLIC_DPAM_ID= DPAM_ID AND DPAM_DELETED_IND = 1
  AND CLIC_DELETED_IND = 1 
  --AND CLIC_CHARGE_NAME ='SERVICE TAX' 
  AND CLIC_CHARGE_NAME in ('UGST')
  GROUP BY DPAM_SBA_NO
  
    SELECT DPAM_SBA_NO CLIC_BO_ID_IGST ,   SUM(CLIC_CHARGE_AMT) IGSTAMT INTO #IGSTAMT FROM CLIENT_CHARGES_CDSL , DP_ACCT_MSTR 
  WHERE CLIC_TRANS_DT BETWEEN @pa_from_date and @pa_to_date 
  AND CLIC_DPAM_ID= DPAM_ID AND DPAM_DELETED_IND = 1
  AND CLIC_DELETED_IND = 1 
  --AND CLIC_CHARGE_NAME ='SERVICE TAX' 
  AND CLIC_CHARGE_NAME in ('IGST')
  GROUP BY DPAM_SBA_NO
   
        
    select isnull(dpam_bbo_code  ,'')  
    +'|'+dpam_sba_no    
    +'|'+enttm_desc    
    +'|'+stam_Cd    
    +'|'+clicm_desc    
    +'|'+subcm_desc    
    +'|'+''-- 2015021457401    
    +'|'+convert(varchar(8),convert(datetime,@pa_from_date,103),112) + '-' + convert(varchar(8),convert(datetime,@pa_to_date,103),112)--20150201-20150228    
    +'|'+convert(varchar(8),convert(datetime,@pa_to_date,103),112)--20150228    
    +'|'+convert(varchar(8),convert(datetime,@pa_to_date+30,103),112) -- ''--20150330    
    +'|'+isnull(ldg_ref_no22,'') -- invoiceno
    +'|'+isnull(citrus_usr.fn_find_relations_Acctlvl(dpam_id,'BL'),'') -- baseloc
    +'|'+dpam_sba_name    
    +'|'+addr1     
    +'|'+addr2    
    +'|'+ISNULL(Addr3,'')    
    +'|'+city    
    +'|'+state    
    +'|'+pincode    
    +'|'+PriPhNum  --9431009950    
    +'|'+ ltrim(rtrim(isnull(replace(citrus_usr.fn_find_relations_ACCT_nm(DPAM_SBA_NO,'BR'),'_BR',''),''))) + '~' + isnull(replace(citrus_usr.fn_find_relations_Acctlvl(dpam_id,'BR'),'_BR',''),'')--PATNA BR-RIP LTD~PTN    
    +'|'+EMailId      
    +'|'+case when isnull(citrus_usr.Fn_Ucc_Brom(dpam_id,@pa_to_date),'')='1' then 'INVESTOR' else isnull(citrus_usr.Fn_Ucc_Brom(dpam_id,@pa_to_date),'') end --LIFE INVESTOR    
    +'|'+ CONVERT(VARCHAR,ISNULL(ABS(convert(numeric(18,2),AMT)),0))--curr bill amt (select top 1 convert(varchar,convert(numeric(18,2),SUM(clic_charge_amt)*-1)) from #TMP_CLIENT_CHARGES_CDSL where CLIC_DPAM_ID=dpam_id and CLIC_TRANS_DT between @pa_from_date and @pa_to_date and CLIC_CHARGE_NAME<>'SERVICE TAX')--11    
   -- +'|'+ CONVERT(VARCHAR,ISNULL(ABS(convert(numeric(18,2),STAMT)),0))--curr bill st (select top 1 convert(varchar,convert(numeric(18,2),SUM(clic_charge_amt)*-1)) from #TMP_CLIENT_CHARGES_CDSL where CLIC_DPAM_ID=dpam_id and CLIC_TRANS_DT between @pa_from_date and @pa_to_date and CLIC_CHARGE_NAME='SERVICE TAX')--11    --1.3596    
    +'|'+CONVERT(VARCHAR,ISNULL(ABS(convert(numeric(18,2),CGSTAMT )),0))
    +'|'+CONVERT(VARCHAR,ISNULL(ABS(convert(numeric(18,2),SGSTAMT)),0))
    +'|'+CONVERT(VARCHAR,ISNULL(ABS(convert(numeric(18,2),IGSTAMT)),0))
    +'|'+CONVERT(VARCHAR,ISNULL(ABS(convert(numeric(18,2),UGSTAMT)),0))
    +'|'+ CONVERT(VARCHAR,ISNULL(ABS(convert(numeric(18,2),OS)),0)) --prev bal as on jun 30 2015(select top  1 convert(varchar,SUM(ldg_amount)) from ledger2 where LDG_ACCOUNT_ID=dpam_id and LDG_DELETED_IND=1 and LDG_VOUCHER_DT<=@pa_to_date)--0    
    --+'|'+ CONVERT(VARCHAR,ISNULL(ABS(convert(numeric(18,2),OS22)),0)+ISNULL(ABS(convert(numeric(18,2),STAMT)),0)+ISNULL(ABS(convert(numeric(18,2),AMT)),0))  -- net amount convert(varchar,((select top 1 convert(numeric(18,2),SUM(clic_charge_amt)*-1) from #TMP_CLIENT_CHARGES_CDSL where CLIC_DPAM_ID=dpam_id and CLIC_TRANS_DT between @pa_from_date and @pa_to_date ) -     (select top  1 SUM(ldg_amount) from ledger2 where LDG_ACCOUNT_ID=dpam_id and LDG_DELETED_IND=1 and LDG_VOUCHER_DT<=@pa_to_date) ))--(select top 1 convert(numeric(18,2),SUM(clic_charge_amt))-convert(numeric(18,2),SUM(ldg_amount)) from #TMP_CLIENT_CHARGES_CDSL,ledger2 where CLIC_DPAM_ID=dpam_id and clic_dpam_id=ldg_account_id and ldg_deleted_ind=1 and ldg_voucher_dt<=@pa_to_date and CLIC_TRANS_DT between 'JUL  1 2015' and 'JUL 31 2015')--12.3596    
    +'|'+ CONVERT(VARCHAR,ISNULL(ABS(convert(numeric(18,2),OS22)),0)+ISNULL(ABS(convert(numeric(18,2),CGSTAMT)),0)+ISNULL(ABS(convert(numeric(18,2),SGSTAMT)),0)+ISNULL(ABS(convert(numeric(18,2),UGSTAMT)),0)+ISNULL(ABS(convert(numeric(18,2),IGSTAMT)),0)+ISNULL(ABS(convert(numeric(18,2),AMT)),0))  -- net amount convert(varchar,((select top 1 convert(numeric(18,2),SUM(clic_charge_amt)*-1) from #TMP_CLIENT_CHARGES_CDSL where CLIC_DPAM_ID=dpam_id and CLIC_TRANS_DT between @pa_from_date and @pa_to_date ) -     (select top  1 SUM(ldg_amount) from ledger2 where LDG_ACCOUNT_ID=dpam_id and LDG_DELETED_IND=1 and LDG_VOUCHER_DT<=@pa_to_date) ))--(select top 1 convert(numeric(18,2),SUM(clic_charge_amt))-convert(numeric(18,2),SUM(ldg_amount)) from #TMP_CLIENT_CHARGES_CDSL,ledger2 where CLIC_DPAM_ID=dpam_id and clic_dpam_id=ldg_account_id and ldg_deleted_ind=1 and ldg_voucher_dt<=@pa_to_date and CLIC_TRANS_DT between 'JUL  1 2015' and 'JUL 31 2015')--12.3596    
    +'|'+convert(varchar(8),convert(datetime,@pa_to_date,103),112)--20150228    
    +'|'+convert(varchar(8),convert(datetime,@pa_to_date,103),112)--20150228    
    +'|'+convert(varchar(8),convert(datetime,@pa_from_date,103),112) + '-' + convert(varchar(8),convert(datetime,@pa_to_date,103),112)--20150201-20150228    
    +'|'+convert(varchar(8),convert(datetime,@pa_from_date,103),112) + '-' + convert(varchar(8),convert(datetime,@pa_to_date,103),112) as value --20150201-20150228    
    
    
    from dp_acct_mstr with(nolock) LEFT OUTER JOIN  #billed_os ON OS_boid = DPAM_SBA_NO 
    left outer join  #billed_os22 ON OS_boid22 = DPAM_SBA_NO 
    LEFT OUTER JOIN  #BILLAMT ON CLIC_BO_ID = DPAM_SBA_NO 
    --LEFT OUTER JOIN  #STAMT ON CLIC_BO_ID_ST = DPAM_SBA_NO 
    LEFT OUTER JOIN  #CGSTAMT ON CLIC_BO_ID_CGST = DPAM_SBA_NO 
    LEFT OUTER JOIN  #SGSTAMT ON CLIC_BO_ID_SGST = DPAM_SBA_NO 
    LEFT OUTER JOIN  #UGSTAMT ON CLIC_BO_ID_UGST = DPAM_SBA_NO 
    LEFT OUTER JOIN  #IGSTAMT ON CLIC_BO_ID_IGST = DPAM_SBA_NO 
    , client_ctgry_mstr with(nolock), ENTITY_TYPE_MSTR with(nolock)
    , SUB_CTGRY_MSTR with(nolock), dps8_pc1 with(nolock), STATUS_MSTR with(nolock)    
    ,#ACCOUNT_PROPERTIES_ECN
    
    where BOId = DPAM_SBA_NO and stam_cd = DPAM_STAM_CD    and ACCP_CLISBA_ID=dpam_id 
    and CLICM_CD  = DPAM_CLICM_CD     
    and ENTTM_CD = DPAM_ENTTM_CD     
    and dpam_subcm_cd = SUBCM_CD     
    and DPAM_DELETED_IND = 1     
    and DPAM_SBA_NO like @pa_boid + '%'   
    and exists(select 1 from #TMP_CLIENT_CHARGES_CDSL where CLIC_DPAM_ID = DPAM_ID  and CLIC_TRANS_DT between @pa_from_date and @pa_to_date )   
    and not exists (select client_code from angelownaccount where client_code=dpam_sba_no)

      DROP TABLE #billed_os
  end      
  if @pa_action = 'LEDGER'    
  begin     
  --print 3     
      
  declare @l_fin_id1 numeric 
  select   @l_fin_id1 = fin_id from Financial_Yr_Mstr where @pa_from_date between FIN_START_DT and FIN_END_DT and FIN_DELETED_IND =1 
  declare @sql1 varchar(8000)
  set @sql1 = ''
  select @sql1  = 'select dpam_sba_no OS_boid, sum(ldg_amount) OS into ##billed_os_ledger from ledger'+convert(varchar,@l_fin_id1)
  select @sql1  = @sql1 + ' , dp_Acct_mstr where dpam_id = ldg_account_id and ldg_account_type =''p'' and ldg_deleted_ind = 1'
  select @sql1  = @sql1 + ' and exists (select 1 from #TMP_CLIENT_CHARGES_CDSL where clic_dpam_id = dpam_id and CLIC_TRANS_DT between '''+ CONVERT(varchar(11),@pa_from_date,109) + ''' and  ''' +  CONVERT(varchar(11),@pa_to_date,109)
  select @sql1  = @sql1 + ''') and ldg_voucher_dt < ''' + CONVERT(varchar(11),@pa_from_date,109)
  select @sql1  = @sql1 + ''' group by dpam_sba_no '
  print @sql1
  exec(@sql1) 
  
  select * into #billed_os_ledger  from ##billed_os_ledger  
  drop table ##billed_os_ledger  
  
  
  
   declare @sql11 varchar(8000)
  set @sql11 = ''
  select @sql11  = 'select identity(numeric,1,1) id , dpam_sba_no r_boid,isnull(OS,''0'') os , sum(ldg_amount) r_amount,ldg_voucher_dt r_vo_dt,ldg_narration re_narration into ##billed_re from ledger'+convert(varchar,@l_fin_id1)
  select @sql11  = @sql11 + ' , dp_Acct_mstr left outer join #billed_os_ledger on os_boid = dpam_sba_no  where dpam_id = ldg_account_id and ldg_account_type =''p'' and ldg_deleted_ind = 1'
  select @sql11  = @sql11 + ' and exists (select 1 from #TMP_CLIENT_CHARGES_CDSL where clic_dpam_id = dpam_id and CLIC_TRANS_DT between '''+ CONVERT(varchar(11),@pa_from_date,109) + ''' and  ''' +  CONVERT(varchar(11),@pa_to_date,109)
  select @sql11  = @sql11 + ''')  and ldg_voucher_dt between ''' + CONVERT(varchar(11),@pa_from_date,109)
  select @sql11  = @sql11 + ''' and  ''' + CONVERT(varchar(11),@pa_to_date,109) + ''' group by dpam_sba_no ,isnull(OS,''0''),ldg_voucher_dt,ldg_narration order by dpam_sba_no ,ldg_voucher_dt,ldg_narration'
  print @sql11
  exec(@sql11) 
  
   
  select * into #billed_re from ##billed_re
  drop table  ##billed_re
  
  
    
    
    select *,isnull(OS,'0')+(select SUM(r_amount) from #billed_re t2 where t1.r_boid= t2.r_boid --and t1.r_vo_dt = t2.r_vo_dt 
    and t2.id<=t1.id
    )  closingbalance  
     into #billed_final 
    from #billed_re t1 
  
  
   select dpam_sba_no+'|'    
   --+CONVERT(varchar(11),isnull(r_vo_dt,''),112)
   +case when CONVERT(varchar(11),isnull(r_vo_dt,''),112)='19000101' then '' else CONVERT(varchar(11),isnull(r_vo_dt,''),112) end  +'|'    
   +isnull(re_narration,'')+'|'    
   +CONVERT(varchar,isnull(case when (isnull(closingbalance,0)-isnull((r_amount),0))<0 then (isnull(closingbalance,0)-isnull((r_amount),0))*-1 when (isnull(closingbalance,0)-isnull((r_amount),0))>0 then (isnull(closingbalance,0)-isnull((r_amount),0))*-1 else (isnull(closingbalance,0)-isnull((r_amount),0))  end,0)) +'|'    
   +case when r_amount < 0 then 'D' else 'C' end +'|'    
   +CONVERT(varchar,isnull((abs(r_amount)),0))+'|'   --12.36    
   +CONVERT(varchar,case when ISNULL(closingbalance,0)<0 then ISNULL(closingbalance,0)*-1 when ISNULL(closingbalance,0)>0 then ISNULL(closingbalance,0)*-1 else ISNULL(closingbalance,0) end) as value--+61.8    
   from dp_acct_mstr with(nolock)  
   --left outer join #billed_os_ledger  on os_boid = DPAM_SBA_NO 
   left outer join #billed_final on r_boid= DPAM_SBA_NO 
     ,#ACCOUNT_PROPERTIES_ECN
    where  ACCP_CLISBA_ID=DPAM_ID  
   and DPAM_DELETED_IND = 1 and DPAM_SBA_NO like  @pa_boid + '%'  
   and exists(select 1 from #TMP_CLIENT_CHARGES_CDSL where CLIC_DPAM_ID = dpam_id   and CLIC_TRANS_DT between @pa_from_date and @pa_to_date )    
   and not exists (select client_code from angelownaccount where client_code=dpam_sba_no)  
   and r_amount <>0     
      
      
      
  end    
  if @pa_action = 'SUMMARY'    
  begin     
  --print @pa_action     
      
   select isnull(dpam_sba_no,'')+'|'    
   +case when  isnull(CLIC_CHARGE_NAME,'')='1_DIBOOK' then 'DIS BOOK CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='1_POAFIXED' then 'POA CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='INV CORP_ACMAIN' then 'ANNUAL MAINTAINENCE CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='JK INV_ACMAIN' then 'ANNUAL MAINTAINENCE CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='LIF1250_DIBOOK' then 'DIS BOOK CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='LIF1250_ONETIME' then 'LIF1250 AMC CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='LIF1250_POAFIXED' then 'POA CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='LIF1250C_POAFIXED' then 'POA CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='LIF1250Q_DIBOOK' then 'DIS BOOK CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='NBC_ACMAIN' then 'ANNUAL MAINTAINENCE CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='NBFC INVW_DIBOOK' then 'DIS BOOK CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='TRADERS_ACMAIN' then 'ANNUAL MAINTAINENCE CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='TRADERS_POAFIXED' then 'POA CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='ZEROWAIVE_DIBOOK' then 'DIS BOOK CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='ZEROWAIVE_POAFIXED' then 'POA CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='ZEROWAIVE1_POAFIXED' then 'POA CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='DEMAT COURIER CHARGE' then 'DEMAT CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='DEMAT REJECTION CHARGE' then 'DEMAT REJECTION CHARGES'
when  isnull(CLIC_CHARGE_NAME,'')='1_ACMAIN' then 'ANNUAL MAINTAINENCE CHARGES'
 else isnull(CLIC_CHARGE_NAME,'') end +'|'    
   +convert(varchar,isnull(convert(numeric(18,2),sum(clic_charge_amt)),'0')*-1)+'|'   as value  
   from CLIENT_CHARGES_CDSL  with(nolock)    
   ,dp_acct_mstr with(nolock)  ,#ACCOUNT_PROPERTIES_ECN  
   where CLIC_DPAM_ID = DPAM_ID and CLIC_DELETED_IND = 1     and ACCP_CLISBA_ID=dpam_id
   and DPAM_DELETED_IND = 1 and DPAM_SBA_NO like @pa_boid + '%'  
   and CLIC_TRANS_DT between @pa_from_date and @pa_to_date     
   and not exists (select client_code from angelownaccount where client_code=dpam_sba_no)
   Group by     dpam_sba_no ,  CLIC_CHARGE_NAME
  end      
  
  
  if @pa_action = 'SEBI1'     -- No transaction and no holding during the year
  begin 

--DROP TABLE TMPHLDG
--CREATE TABLE #TMPHLDG     
--(    
--[DPHMCD_DPM_ID] [NUMERIC](18, 0) NOT NULL,    
--[DPHMCD_DPAM_ID] [NUMERIC](10, 0) NOT NULL,    
--[DPHMCD_ISIN] [VARCHAR](20) NOT NULL,    
--[DPHMCD_CURR_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_FREE_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_FREEZE_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_PLEDGE_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_DEMAT_PND_VER_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_REMAT_PND_CONF_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_DEMAT_PND_CONF_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_SAFE_KEEPING_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_LOCKIN_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_ELIMINATION_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_EARMARK_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_AVAIL_LEND_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_LEND_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_BORROW_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_HOLDING_DT] DATETIME    
--)      

--INSERT INTO #TMPHLDG
--EXEC  [PR_GET_HOLDING_FIX_LATEST]   3,'MAR 31 2015','MAR 31 2015','0','9999999999999999',''    
--SELECT * INTO  TMPHLDG FROM  #TMPHLDG  
  
SELECT 
DPAM_SBA_NO +'|'    
+CONVERT(VARCHAR(11),'MAR 31 2016',112) +'|'    
+'0' +'|'    
+'' +'|'+'' +'|'+'' +'|'++'|'+CONVERT(VARCHAR,'')+'|'
+''    
+'|'+ISNULL('','')--MKTRXD    
+'|'+CONVERT(VARCHAR,ABS(CONVERT(NUMERIC(18,3),0)))--1000    
+'|'+CONVERT(VARCHAR,'')  
+'|'++'|'+ CONVERT(VARCHAR,ABS(CONVERT(NUMERIC(18,2),0)))AS VALUE
FROM DP_ACCT_MSTR 
WHERE  DPAM_STAM_CD ='ACTIVE' AND NOT EXISTS (SELECT 1 
				  FROM CDSL_HOLDING_DTLS 
				WHERE CDSHM_BEN_ACCT_NO = DPAM_SBA_NO
				AND CDSHM_TRAS_DT BETWEEN 'APR 01 2015' AND 'MAR 31 2016'
)
AND  NOT EXISTS (SELECT 1 
				  FROM TMPHLDG 
				WHERE DPHMCD_DPAM_ID  = DPAM_ID 
				)   
  end  
  
if @pa_action = 'SEBI2'     -- Account which become zero balance during the year
  begin 
--drop table TMPHLDG_EOY
--CREATE TABLE #TMPHLDG_EOY     
--(    
-- [DPHMCD_DPM_ID] [NUMERIC](18, 0) NOT NULL,    
-- [DPHMCD_DPAM_ID] [NUMERIC](10, 0) NOT NULL,    
-- [DPHMCD_ISIN] [VARCHAR](20) NOT NULL,    
-- [DPHMCD_CURR_QTY] [NUMERIC](18, 3) NULL,    
-- [DPHMCD_FREE_QTY] [NUMERIC](18, 3) NULL,    
-- [DPHMCD_FREEZE_QTY] [NUMERIC](18, 3) NULL,    
-- [DPHMCD_PLEDGE_QTY] [NUMERIC](18, 3) NULL,    
-- [DPHMCD_DEMAT_PND_VER_QTY] [NUMERIC](18, 3) NULL,    
-- [DPHMCD_REMAT_PND_CONF_QTY] [NUMERIC](18, 3) NULL,    
-- [DPHMCD_DEMAT_PND_CONF_QTY] [NUMERIC](18, 3) NULL,    
-- [DPHMCD_SAFE_KEEPING_QTY] [NUMERIC](18, 3) NULL,    
-- [DPHMCD_LOCKIN_QTY] [NUMERIC](18, 3) NULL,    
-- [DPHMCD_ELIMINATION_QTY] [NUMERIC](18, 3) NULL,    
-- [DPHMCD_EARMARK_QTY] [NUMERIC](18, 3) NULL,    
-- [DPHMCD_AVAIL_LEND_QTY] [NUMERIC](18, 3) NULL,    
-- [DPHMCD_LEND_QTY] [NUMERIC](18, 3) NULL,    
-- [DPHMCD_BORROW_QTY] [NUMERIC](18, 3) NULL,    
-- [DPHMCD_HOLDING_DT] DATETIME    
-- )      
    
--    INSERT INTO #TMPHLDG_EOY     
--    EXEC  [PR_GET_HOLDING_FIX_LATEST]   3,'MAR 31 2016','MAR 31 2016','0','9999999999999999','' 
--  SELECT * INTO  TMPHLDG_EOY FROM  #TMPHLDG_EOY

SELECT DPAM_SBA_NO ,
DPAM_SBA_NO +'|'    
+CONVERT(VARCHAR(11),'MAR 31 2016',112) +'|'    
+'0' +'|'    
+'' +'|'+'' +'|'+'' +'|'++'|'+CONVERT(VARCHAR,'')+'|'
+''    
+'|'+ISNULL('','')--MKTRXD    
+'|'+CONVERT(VARCHAR,ABS(CONVERT(NUMERIC(18,3),0)))--1000    
+'|'+CONVERT(VARCHAR,'')  
+'|'++'|'+ CONVERT(VARCHAR,ABS(CONVERT(NUMERIC(18,2),0)))AS VALUE
FROM DP_ACCT_MSTR 
WHERE  DPAM_STAM_CD ='ACTIVE' 
AND   EXISTS (SELECT 1 
				  FROM TMPHLDG 
				WHERE DPHMCD_DPAM_ID  = DPAM_ID 
				) 

AND   NOT EXISTS (SELECT 1 
				  FROM TMPHLDG_EOY  
				WHERE DPHMCD_DPAM_ID  = DPAM_ID 
				) 
 
  end  
  
if @pa_action = 'SEBI3'     -- accounts with credit balance but no transactions during the year
  begin 


--DROP TABLE TMPHLDG3
--CREATE TABLE #TMPHLDG3     
--(    
--[DPHMCD_DPM_ID] [NUMERIC](18, 0) NOT NULL,    
--[DPHMCD_DPAM_ID] [NUMERIC](10, 0) NOT NULL,    
--[DPHMCD_ISIN] [VARCHAR](20) NOT NULL,    
--[DPHMCD_CURR_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_FREE_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_FREEZE_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_PLEDGE_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_DEMAT_PND_VER_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_REMAT_PND_CONF_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_DEMAT_PND_CONF_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_SAFE_KEEPING_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_LOCKIN_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_ELIMINATION_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_EARMARK_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_AVAIL_LEND_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_LEND_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_BORROW_QTY] [NUMERIC](18, 3) NULL,    
--[DPHMCD_HOLDING_DT] DATETIME    
--)      

--INSERT INTO #TMPHLDG3
--EXEC  [PR_GET_HOLDING_FIX_LATEST]   3,'MAR 31 2015','MAR 31 2015','0','9999999999999999',''    
--SELECT * INTO  TMPHLDG3 FROM  #TMPHLDG3  



SELECT  
DPAM_SBA_NO +'|'    
+CONVERT(VARCHAR(11),'MAR 31 2016',112) +'|'    
+'0' +'|'    
+'' +'|'+'' +'|'+'' +'|'++'|'+CONVERT(VARCHAR,'')+'|'
+''    
+'|'+ISNULL('','')--MKTRXD    
+'|'+CONVERT(VARCHAR,ABS(CONVERT(NUMERIC(18,3),0)))--1000    
+'|'+CONVERT(VARCHAR,'')  
+'|'++'|'+ CONVERT(VARCHAR,ABS(CONVERT(NUMERIC(18,2),0)))AS VALUE
FROM DP_ACCT_MSTR 
WHERE  DPAM_STAM_CD ='ACTIVE' AND NOT EXISTS (SELECT 1 
				  FROM CDSL_HOLDING_DTLS 
				WHERE CDSHM_BEN_ACCT_NO = DPAM_SBA_NO
				AND CDSHM_TRAS_DT BETWEEN 'APR 01 2015' AND 'MAR 31 2016'
)
AND   EXISTS (SELECT 1 
				  FROM TMPHLDG
				WHERE DPHMCD_DPAM_ID  = DPAM_ID 
				) 




  end      
    
end

GO
