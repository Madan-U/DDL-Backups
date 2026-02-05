-- Object: PROCEDURE citrus_usr.Pr_CdslReconcile
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--Pr_CdslReconcile 3,'aug 28 2008','N',''    
CREATE proc [citrus_usr].[Pr_CdslReconcile]    
@pa_excsmid int,                          
@pa_reconcile_dt datetime,  
@pa_mismatchonly char(1),    
@pa_account varchar(8)   
as    
begin    
  set nocount on             
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  declare @@dpmid int,
  @@dpmdpid char(8),
  @pa_prevfromdate datetime    
      
  select @@dpmid = dpm_id,@@dpmdpid=dpm_dpid from dp_mstr with(nolock) where default_dp = @pa_excsmid and dpm_deleted_ind =1                          
      
  create table #cdslreco                  
  (                  
  dpam_id bigint,                  
  isin_cd varchar(12),                  
  Qty numeric(19,3),       
  trans_type int               
  )                  
      
  if @pa_account <> ''  
  begin    
   set @pa_account =  @@dpmdpid + ltrim(rtrim(@pa_account))

   insert into #cdslreco(dpam_id,isin_cd,Qty,trans_type)       
   select cdshm_dpam_id,cdshm_isin,cdshm_qty,1    
   from CDSL_HOLDING_DTLS with(nolock)     
   where               
   cdshm_dpm_id = @@dpmid                          
   and cdshm_tras_dt = @pa_reconcile_dt and cdshm_ben_acct_no = @pa_account    
   and cdshm_tratm_cd in('2246','2277')                          
  end  
  else  
  begin  
   insert into #cdslreco(dpam_id,isin_cd,Qty,trans_type)       
   select cdshm_dpam_id,cdshm_isin,cdshm_qty,1    
   from CDSL_HOLDING_DTLS with(nolock)     
   where               
   cdshm_dpm_id = @@dpmid                          
   and cdshm_tras_dt = @pa_reconcile_dt     
   and cdshm_tratm_cd in('2246','2277')   
  end      
      
  select @pa_prevfromdate=isnull(max(dphmcd_holding_dt),'jan  1 1900') from DP_DAILY_HLDG_CDSL with(nolock) where dphmcd_dpm_id = @@dpmid and dphmcd_holding_dt < @pa_reconcile_dt    
      
  if @pa_account <> ''  
  begin      
   insert into #cdslreco(dpam_id,isin_cd,Qty,trans_type)                 
   select dphmcd_dpam_id,dphmcd_ISIN,dphmcd_curr_qty,1    
   from DP_DAILY_HLDG_CDSL with(nolock),dp_acct_mstr with(nolock)       
   where               
   dphmcd_dpm_id = @@dpmid   
    and dphmcd_dpam_id = dpam_id    
   and dpam_sba_no = @pa_account                              
   and DPHMCD_HOLDING_DT like convert(varchar(11),@pa_prevfromdate,109) + '%'    
       
   insert into #cdslreco(dpam_id,isin_cd,Qty,trans_type)                 
   select dphmcd_dpam_id,dphmcd_ISIN,dphmcd_curr_qty,2    
   from DP_DAILY_HLDG_CDSL with(nolock),dp_acct_mstr with(nolock)     
   where               
   dphmcd_dpm_id = @@dpmid    
    and dphmcd_dpam_id = dpam_id    
   and dpam_sba_no = @pa_account     
   and DPHMCD_HOLDING_DT = @pa_reconcile_dt    
  end  
  else  
  begin  
   insert into #cdslreco(dpam_id,isin_cd,Qty,trans_type)                 
   select dphmcd_dpam_id,dphmcd_ISIN,dphmcd_curr_qty,1    
   from DP_DAILY_HLDG_CDSL with(nolock)     
   where               
   dphmcd_dpm_id = @@dpmid                          
   and DPHMCD_HOLDING_DT like convert(varchar(11),@pa_prevfromdate,109) + '%' 
       
   insert into #cdslreco(dpam_id,isin_cd,Qty,trans_type)                 
   select dphmcd_dpam_id,dphmcd_ISIN,dphmcd_curr_qty,2    
   from DP_DAILY_HLDG_CDSL with(nolock)     
   where               
   dphmcd_dpm_id = @@dpmid    
   and DPHMCD_HOLDING_DT = @pa_reconcile_dt    
  end  
     
  if @pa_mismatchonly = 'Y'  
  begin   
   select DPAM_SBA_NAME,DPAM_SBA_NO,isin_cd,    
   Trans_Holding =sum(case when trans_type = 1 then Qty else 0 end),    
   SOH_Holding=sum(case when trans_type = 2 then Qty else 0 end)    
   from #cdslreco r with(nolock), dp_acct_mstr d with(nolock)   
   where r.dpam_id = d.dpam_id    
   group by DPAM_SBA_NAME,DPAM_SBA_NO,isin_cd    
   having sum(case when trans_type = 1 then Qty else 0 end) <> sum(case when trans_type = 2 then Qty else 0 end)
   UNION
   SELECT DPAM_SBA_NAME,DPAM_SBA_NO,isin_cd=DPHMCD_ISIN,Trans_Holding =DPHMCD_CURR_QTY,SOH_Holding=DPHMC_CURR_QTY 
   FROM DP_DAILY_HLDG_CDSL with(nolock) 
   LEFT OUTER JOIN CDSl_FREE_BALANCE  with(nolock) ON DPHMCD_HOLDING_DT = DPHMC_HOLDING_DT AND DPHMCD_DPAM_ID = DPHMC_DPAM_ID AND DPHMCD_ISIN = DPHMC_ISIN
   , dp_acct_mstr with(nolock)   
   WHERE DPHMCD_HOLDING_DT = @pa_reconcile_dt 
   AND DPHMCD_DPAM_ID = dpam_id    
   AND (DPHMCD_CURR_QTY <> isnull(DPHMC_CURR_QTY,0) or DPHMCD_FREE_QTY <> isnull(DPHMC_FREE_QTY,0) or DPHMCD_FREEZE_QTY <> isnull(DPHMC_FREEZE_QTY,0)
   or DPHMCD_PLEDGE_QTY <> isnull(DPHMC_PLEDGE_QTY,0) or DPHMCD_DEMAT_PND_VER_QTY <> isnull(DPHMC_DEMAT_PND_VER_QTY,0) or DPHMCD_REMAT_PND_CONF_QTY <> isnull(DPHMC_REMAT_PND_CONF_QTY,0)
   or DPHMCD_DEMAT_PND_CONF_QTY <> isnull(DPHMC_DEMAT_PND_CONF_QTY,0) or DPHMCD_LOCKIN_QTY <> isnull(DPHMC_LOCKIN_QTY,0) or DPHMCD_ELIMINATION_QTY <> isnull(DPHMC_ELIMINATION_QTY,0)
   or DPHMCD_EARMARK_QTY <> isnull(DPHMC_EARMARK_QTY,0))

  end  
  else  
  begin  
   select DPAM_SBA_NAME,DPAM_SBA_NO,isin_cd,    
   Trans_Holding =sum(case when trans_type = 1 then Qty else 0 end),    
   SOH_Holding=sum(case when trans_type = 2 then Qty else 0 end)    
   from #cdslreco r with(nolock), dp_acct_mstr d    
   where r.dpam_id = d.dpam_id    
   group by DPAM_SBA_NAME,DPAM_SBA_NO,isin_cd    
   having sum(case when trans_type = 1 then Qty else 0 end) <> 0 AND sum(case when trans_type = 2 then Qty else 0 end) <> 0
  end  
      
  truncate table #cdslreco
  drop table #cdslreco    
      
      
end

GO
