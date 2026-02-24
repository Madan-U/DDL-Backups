-- Object: PROCEDURE citrus_usr.pr_get_monthly_holding
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--exec pr_get_monthly_holding 'apr 01 2013','apr 30 2013'
CREATE proc [citrus_usr].[pr_get_monthly_holding](@pa_from_dt datetime,@pa_to_dt datetime)
as
begin 

SET @pa_from_dt = CONVERT(VARCHAR(11),DATEADD(dd,-(DAY(getdate()-10)-1),getdate()-10),109)
SET @pa_to_dt   = CONVERT(VARCHAR(11),DATEADD(dd,-(DAY(DATEADD(mm,1,getdate()-10))),DATEADD(mm,1,getdate()-10)),109) 


truncate  table monthlyholingval

truncate table bal 


if not exists (select dphmcd_holding_dt from Holdingdataforaging WITH (NOLOCK) where dphmcd_holding_dt = @pa_to_dt)
begin 
insert into bal
exec [pr_get_holding_fix_latest_ForStatView] '0',@pa_to_dt,@pa_to_dt,'0','9999999999999999',''
end 
else 
begin
print @pa_to_dt
insert into bal
select DPHMCD_DPM_ID,DPHMCD_DPAM_ID,DPHMCD_ISIN,DPHMCD_CURR_QTY,DPHMCD_FREE_QTY,DPHMCD_FREEZE_QTY
,DPHMCD_PLEDGE_QTY,DPHMCD_DEMAT_PND_VER_QTY,DPHMCD_REMAT_PND_CONF_QTY,DPHMCD_DEMAT_PND_CONF_QTY,DPHMCD_SAFE_KEEPING_QTY
,DPHMCD_LOCKIN_QTY,DPHMCD_ELIMINATION_QTY,DPHMCD_EARMARK_QTY,DPHMCD_AVAIL_LEND_QTY,DPHMCD_LEND_QTY,DPHMCD_BORROW_QTY
,dphmcd_holding_dt from Holdingdataforaging WITH (NOLOCK)
where dphmcd_holding_dt = @pa_to_dt

end 

select * into #tmp_dp_daily_hldg_cdsl from (
select dpam_sba_no td_ac_code,	isin_cd ISIN	,isin_comp_name Security
,case when DPHMCD_FREE_QTY <> '0' then 'Beneficiary' end type
,DPHMCD_FREE_QTY  qty,holdingdt
 from bal, dp_acct_mstr , isin_mstr
where dphmcd_dpam_id = dpam_id
and dphmcd_isin = isin_cd 
and DPHMCD_FREE_QTY <> '0'
union all 

select dpam_sba_no td_ac_code,	isin_cd ISIN	,isin_comp_name Security
,case when DPHMCD_FREEZE_QTY <> '0' then 'Frozed Balance' end type
,DPHMCD_FREEZE_QTY  qty,holdingdt
 from bal, dp_acct_mstr , isin_mstr
where dphmcd_dpam_id = dpam_id
and dphmcd_isin = isin_cd 
and DPHMCD_FREEZE_QTY <> '0'

union all 

select dpam_sba_no td_ac_code,	isin_cd ISIN	,isin_comp_name Security
,case when DPHMCD_LOCKIN_QTY <> '0' then 'Lock in Balance' end type
,DPHMCD_LOCKIN_QTY  qty,holdingdt
 from bal, dp_acct_mstr , isin_mstr
where dphmcd_dpam_id = dpam_id
and dphmcd_isin = isin_cd 
and DPHMCD_LOCKIN_QTY <> '0'

union all 

select dpam_sba_no td_ac_code,	isin_cd ISIN	,isin_comp_name Security
,case when DPHMCD_DEMAT_PND_VER_QTY <> '0' then 'Pending Demat' end type
,DPHMCD_DEMAT_PND_VER_QTY  qty,holdingdt
 from bal, dp_acct_mstr , isin_mstr
where dphmcd_dpam_id = dpam_id
and dphmcd_isin = isin_cd 
and DPHMCD_DEMAT_PND_VER_QTY <> '0'


union all 

select dpam_sba_no td_ac_code,	isin_cd ISIN	,isin_comp_name Security
,case when DPHMCD_REMAT_PND_CONF_QTY <> '0' then 'Pending Remat' end type
,DPHMCD_REMAT_PND_CONF_QTY  qty,holdingdt
 from bal, dp_acct_mstr , isin_mstr
where dphmcd_dpam_id = dpam_id
and dphmcd_isin = isin_cd 
and DPHMCD_REMAT_PND_CONF_QTY <> '0'


union all 

select dpam_sba_no td_ac_code,	isin_cd ISIN	,isin_comp_name Security
,case when DPHMCD_PLEDGE_QTY <> '0' then 'Pledge' end type
,DPHMCD_PLEDGE_QTY qty,holdingdt
 from bal, dp_acct_mstr , isin_mstr
where dphmcd_dpam_id = dpam_id
and dphmcd_isin = isin_cd 
and DPHMCD_PLEDGE_QTY <> '0' ) a

insert into monthlyholingval
select td_ac_code,isin,security,type,qty quantity  ,isnull(CLOPM_CDSL_RT,0) rate     , qty * isnull(CLOPM_CDSL_RT,0) value
, convert(varchar(8),holdingdt ,112) holdingdt
--into monthlyholingval
from #tmp_dp_daily_hldg_cdsl   a    
left outer join (select max(CLOPM_DT) lastdt , clopm_isin_cd isincd from closing_price_mstr_cdsl     
     where CLOPM_DT <= @pa_to_dt 
    and CLOPM_CDSL_RT <> 0  group by CLOPM_ISIN_CD ) lastdt     
----left outer join closing_price_mstr_cdsl     
on ISIN  = isincd    
left outer join closing_price_mstr_cdsl on lastdt = CLOPM_DT and isincd =  clopm_isin_cd       
       
where         
(qty <>'0') 


end

GO
