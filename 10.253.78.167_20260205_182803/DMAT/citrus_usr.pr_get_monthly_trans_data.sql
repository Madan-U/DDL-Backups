-- Object: PROCEDURE citrus_usr.pr_get_monthly_trans_data
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--exec pr_get_monthly_trans_data 'MAY 01 2013','MAY 31 2013'
CREATE proc [citrus_usr].[pr_get_monthly_trans_data](@pa_from_dt datetime,@pa_to_dt datetime)
as
begin 

SET @pa_from_dt = CONVERT(VARCHAR(11),DATEADD(dd,-(DAY(getdate()-10)-1),getdate()-10),109)
SET @pa_to_dt   = CONVERT(VARCHAR(11),DATEADD(dd,-(DAY(DATEADD(mm,1,getdate()-10))),DATEADD(mm,1,getdate()-10)),109) 




truncate table monthlytransdetails
select * INTO #transdata
from cdsl_holding_dtls WITH (NOLOCK)
where CDSHM_TRAS_DT BETWEEN @pa_from_dt AND @pa_to_dt
--and cdshm_ben_acct_no = '1201090000000019'



declare @openbal_dt datetime
,@bal_dt datetime

select @openbal_dt  = dateadd(dd,-1,@pa_from_dt)
select @bal_dt  = dateadd(dd,1,@pa_to_dt)

  
create table #openbal( DPHMCD_DPM_ID      numeric
,DPHMCD_DPAM_ID        numeric
,DPHMCD_ISIN    varchar(50)
,DPHMCD_CURR_QTY     numeric(18,5)
, DPHMCD_FREE_QTY    numeric(18,5)
, DPHMCD_FREEZE_QTY    numeric(18,5)
,DPHMCD_PLEDGE_QTY    numeric(18,5)
, DPHMCD_DEMAT_PND_VER_QTY    numeric(18,5)
,DPHMCD_REMAT_PND_CONF_QTY    numeric(18,5)
,DPHMCD_DEMAT_PND_CONF_QTY    numeric(18,5)
,DPHMCD_SAFE_KEEPING_QTY    numeric(18,5)
,DPHMCD_LOCKIN_QTY    numeric(18,5)
,DPHMCD_ELIMINATION_QTY    numeric(18,5)
,DPHMCD_EARMARK_QTY    numeric(18,5)
,DPHMCD_AVAIL_LEND_QTY    numeric(18,5)
,DPHMCD_LEND_QTY    numeric(18,5)
,DPHMCD_BORROW_QTY    numeric(18,5)
,holdingdt datetime)


if not exists (select dphmcd_holding_dt from Holdingdataforaging WITH (NOLOCK) where dphmcd_holding_dt = @openbal_dt)
begin 

insert into #openbal
exec [pr_get_holding_fix_latest_ForStatView] '0',@openbal_dt,@openbal_dt,'0','9999999999999999',''

end 
else 
begin
print @openbal_dt
insert into #openbal
select DPHMCD_DPM_ID,DPHMCD_DPAM_ID,DPHMCD_ISIN,DPHMCD_CURR_QTY,DPHMCD_FREE_QTY,DPHMCD_FREEZE_QTY
,DPHMCD_PLEDGE_QTY,DPHMCD_DEMAT_PND_VER_QTY,DPHMCD_REMAT_PND_CONF_QTY,DPHMCD_DEMAT_PND_CONF_QTY,DPHMCD_SAFE_KEEPING_QTY
,DPHMCD_LOCKIN_QTY,DPHMCD_ELIMINATION_QTY,DPHMCD_EARMARK_QTY,DPHMCD_AVAIL_LEND_QTY,DPHMCD_LEND_QTY,DPHMCD_BORROW_QTY
,dphmcd_holding_dt from Holdingdataforaging WITH (NOLOCK)
where dphmcd_holding_dt = @openbal_dt


end 


 
create table #bal( DPHMCD_DPM_ID      numeric
,DPHMCD_DPAM_ID        numeric
,DPHMCD_ISIN    varchar(50)
,DPHMCD_CURR_QTY     numeric(18,5)
, DPHMCD_FREE_QTY    numeric(18,5)
, DPHMCD_FREEZE_QTY    numeric(18,5)
,DPHMCD_PLEDGE_QTY    numeric(18,5)
, DPHMCD_DEMAT_PND_VER_QTY    numeric(18,5)
,DPHMCD_REMAT_PND_CONF_QTY    numeric(18,5)
,DPHMCD_DEMAT_PND_CONF_QTY    numeric(18,5)
,DPHMCD_SAFE_KEEPING_QTY    numeric(18,5)
,DPHMCD_LOCKIN_QTY    numeric(18,5)
,DPHMCD_ELIMINATION_QTY    numeric(18,5)
,DPHMCD_EARMARK_QTY    numeric(18,5)
,DPHMCD_AVAIL_LEND_QTY    numeric(18,5)
,DPHMCD_LEND_QTY    numeric(18,5)
,DPHMCD_BORROW_QTY    numeric(18,5)
,holdingdt datetime)


if not exists (select dphmcd_holding_dt from Holdingdataforaging WITH (NOLOCK) where dphmcd_holding_dt = @pa_to_dt)
begin 
insert into #bal
exec [pr_get_holding_fix_latest_ForStatView] '0',@pa_to_dt,@pa_to_dt,'0','9999999999999999',''
end 
else 
begin
print @pa_to_dt
insert into #bal
select DPHMCD_DPM_ID,DPHMCD_DPAM_ID,DPHMCD_ISIN,DPHMCD_CURR_QTY,DPHMCD_FREE_QTY,DPHMCD_FREEZE_QTY
,DPHMCD_PLEDGE_QTY,DPHMCD_DEMAT_PND_VER_QTY,DPHMCD_REMAT_PND_CONF_QTY,DPHMCD_DEMAT_PND_CONF_QTY,DPHMCD_SAFE_KEEPING_QTY
,DPHMCD_LOCKIN_QTY,DPHMCD_ELIMINATION_QTY,DPHMCD_EARMARK_QTY,DPHMCD_AVAIL_LEND_QTY,DPHMCD_LEND_QTY,DPHMCD_BORROW_QTY
,dphmcd_holding_dt from Holdingdataforaging WITH (NOLOCK)
where dphmcd_holding_dt = @pa_to_dt

end 

insert into monthlytransdetails
select cdshm_ben_acct_no DPCode
, cdshm_isin   ISIN
, ISIN_COMP_NAME Security
,convert(varchar(11),cdshm_tras_dt ,103) Date

, cdshm_traNS_NO Reference
, CDSHM_TRATM_DESC Particulars
, case when cdshm_qty < 0 then ABS(CDSHM_QTY) ELSE 0 END DEBIT
, case when cdshm_qty > 0 then ABS(CDSHM_QTY) ELSE 0 END Credit

,isnull(opnbal.dphmcd_curr_qty,0)  Opening

,isnull(bal.dphmcd_curr_qty,0)  Balance
 
, CONVERT(VARCHAR(8), CONVERT(DATETIME,@pa_to_dt,109), 112)  HoldingDate
--into monthlytransdetails
FROM isin_mstr WITH (NOLOCK), #transdata with(nolock) 
	  --left outer join  #vw_fethob   on v_cdshm_dpam_id = cdshm_dpam_id 
      --and v_cdshm_isin = cdshm_isin          
	  --and v_cdshm_dpm_id = cdshm_dpm_id 
left outer join #openbal opnbal on opnbal.dphmcd_dpam_id = cdshm_dpam_id and cdshm_isin = opnbal.dphmcd_isin
left outer join #bal bal on bal.dphmcd_dpam_id = cdshm_dpam_id and cdshm_isin = bal.dphmcd_isin
	 ,dp_acct_mstr  account   WITH (NOLOCK)                            
      where   cdshm_isin = isin_cd and  CDSHM_TRAS_DT BETWEEN  @pa_from_dt AND @pa_to_dt
      and cdshm_tratm_cd in('2246','2277','2201','3102','2270','2220','2262','2251','2202','2205')       --,'2252','4456' '2280', -- 2205 added                            
      --and cdshm_tratm_cd in('2246','2277','2201','2205','2220','3102','2252','2270','2280','2262','2251','3202','2202','2212')     
      AND CDSHM_DPAM_ID = account.dpam_id                            
       ORDER BY 3,4

--DROP TABLE #tmp_cdsl_holding_dtls

DROP TABLE #transdata
drop table #openbal
drop table #bal

end

GO
