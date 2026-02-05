-- Object: PROCEDURE citrus_usr.pr_recon_holding_MODIFIED
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------












--select * from #holdingall

--exec [pr_recon_holding_feb262016] 41,'FEB 25 2016','MISMATCH',''
--exec pr_recon_holding 22,'jun 03 2014','MISMATCH',''
--exec pr_recon_holding_new 3,'jun 28 2012','MISMATCH',''
--select * from dp_mstr where default_dp = dpm_excsm_id
CREATE proc [citrus_usr].[pr_recon_holding_MODIFIED](@pa_excsm_id numeric
, @pa_date datetime
, @pa_flag char(15)
,@pa_acct_no varchar(16)
,@pa_ref_cur varchar(8000) output
)
as
begin 
declare @pa_dpm_id numeric
select @pa_dpm_id = dpm_id from dp_mstr with(nolock) where default_dp = dpm_excsm_id and dpm_excsm_id = @pa_excsm_id

/*charged by tushar 28062012*/
--select client,isin,sum(qty) qty  into #asontran from (
--select dpam_sba_no client , dptdc_isin isin , abs(dptdc_qty) qty
--from dp_trx_dtls_cdsl, dp_acct_mstr 
--where convert(varchar(11),dptdc_request_dt,109) = convert(varchar(11),@pa_date,109)
--and DPTDC_DPAM_ID = dpam_id
--and dpam_dpm_id = @pa_dpm_id
--and dpam_deleted_ind = 1
--and dptdc_deleted_ind = 1
--union all 
--select dpam_sba_no client, DEMRM_ISIN isin, abs(DEMRM_QTY) qty
--from demat_request_mstr, dp_acct_mstr 
--where convert(varchar(11),DEMRM_REQUEST_DT,109) = convert(varchar(11),@pa_date,109)
--and DEMRM_DPAM_ID = dpam_id
--and dpam_dpm_id = @pa_dpm_id
--and dpam_deleted_ind = 1
--and demrm_deleted_ind = 1
--union all 
--select dpam_sba_no client, rEMRM_ISIN isin, abs(rEMRM_QTY) qty
--from remat_request_mstr, dp_acct_mstr 
--where convert(varchar(11),rEMRM_REQUEST_DT,109) = convert(varchar(11),@pa_date,109)
--and rEMRM_DPAM_ID = dpam_id
--and dpam_dpm_id = @pa_dpm_id
--and dpam_deleted_ind = 1
--and remrm_deleted_ind = 1
--union all 
--select dpam_sba_no client, PLDTC_ISIN isin, abs(PLDTC_QTY) qty
--from cdsl_pledge_dtls, dp_acct_mstr 
--where convert(varchar(11),PLDTC_REQUEST_DT,109) = convert(varchar(11),@pa_date,109)
--and PLDTC_DPAM_ID = dpam_id
--and dpam_dpm_id = @pa_dpm_id
--and dpam_deleted_ind = 1
--and PLDTC_DELETED_IND = 1 
--) a 
--group by client,isin
/*charged by tushar 28062012*/

select top 0 * into #holdingall from holdingall_structure
declare @l_dt datetime 
set @l_dt  = dateadd(d,-1,@pa_date)
if @pa_acct_no =''
insert into #holdingall
exec pr_get_holding_fix_latest_mODIFIED @pa_dpm_id,@l_dt,@l_dt,'0','9999999999999999',''    
--exec [pr_get_holding_fix_latest] @pa_dpm_id,@l_dt,@l_dt,'0','9999999999999999',''    

if @pa_acct_no <>''
insert into #holdingall
exec pr_get_holding_fix_latest_mODIFIED @pa_dpm_id,@l_dt,@l_dt,@pa_acct_no,@pa_acct_no,''    


--
--
--if @pa_dpm_id <> 3 
--begin 
--insert into #holdingall
--exec [pr_get_holding_fix_latest] @pa_dpm_id,@l_dt,@l_dt,'0','9999999999999999',''    
--end 
--else 
--begin
--insert into #holdingall
--select * from holdingall_bak291212 
--end 
--

 

select dpam_sba_no client_hldg,DPHMCD_ISIN isin_hldg,DPHMCD_CURR_QTY qty_hldg 
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
into #priviousholding_1 from #holdingall with(nolock),dp_acct_mstr  with(nolock)
where dpam_id = DPHMCD_DPAM_ID 
and dpam_dpm_id = @pa_dpm_id 
and case when @pa_acct_no ='' then '1' else dpam_sba_no end = case when @pa_acct_no ='' then '1' else @pa_acct_no  end 
--and DPHMC_HOLDING_DT = 
--(select top 1 DPHMC_HOLDING_DT from DP_HLDG_MSTR_CDSL
--where DPHMC_HOLDING_DT <  @pa_date order by 1 desc)

update a set qty_hldg  = qty_hldg - cdshm_qty, DPHMCD_FREE_QTY = DPHMCD_FREE_QTY - CASE WHEN DPHMCD_AVAIL_LEND_QTY > = cdshm_qty THEN 0 ELSE cdshm_qty END 
,DPHMCD_AVAIL_LEND_QTY= DPHMCD_AVAIL_LEND_QTY - cdshm_qty
from #priviousholding_1 a ,(select cdshm_ben_acct_no , cdshm_isin , sum(cdshm_qty ) cdshm_qty 
from cdsl_holding_dtls a with(nolock)
where convert(varchar(11),CDSHM_TRAS_DT,109) = convert(varchar(11),@pa_date,109)
and cdshm_dpm_id = @pa_dpm_id
and CDSHM_TRATM_CD in ('2230','2280') group by cdshm_ben_acct_no , cdshm_isin) b
where b.cdshm_ben_acct_no = a.client_hldg
and a.isin_hldg = b.cdshm_isin
and case when @pa_acct_no ='' then '1' else cdshm_ben_Acct_no end = case when @pa_acct_no ='' then '1' else @pa_acct_no  end 


update a set DPHMCD_LOCKIN_QTY = DPHMCD_LOCKIN_QTY + cdshm_qty
,DPHMCD_FREE_QTY = DPHMCD_FREE_QTY - cdshm_qty
from #priviousholding_1 a ,(select cdshm_ben_acct_no , cdshm_isin , sum(cdshm_qty ) cdshm_qty 
from cdsl_holding_dtls a with(nolock)
where convert(varchar(11),CDSHM_TRAS_DT,109) = convert(varchar(11),@pa_date,109)
and cdshm_dpm_id = @pa_dpm_id and CDSHM_CDAS_TRAS_TYPE = '23'
and case when @pa_acct_no ='' then '1' else cdshm_ben_Acct_no end = case when @pa_acct_no ='' then '1' else @pa_acct_no  end 
and CDSHM_TRATM_CD in ('2262') group by cdshm_ben_acct_no , cdshm_isin) b
where b.cdshm_ben_acct_no = a.client_hldg
and a.isin_hldg = b.cdshm_isin

INSERT INTO #priviousholding_1
select cdshm_ben_acct_no client, cdshm_isin isin, cdshm_qty qty
,case when CDSHM_CDAS_TRAS_TYPE not in ('33') then cdshm_qty else 0 end  DPHMCD_FREE_QTY
,0 DPHMCD_FREEZE_QTY
,0 DPHMCD_PLEDGE_QTY
,0 DPHMCD_DEMAT_PND_VER_QTY
,case when CDSHM_CDAS_TRAS_TYPE in ('33') then cdshm_qty else 0 end   DPHMCD_REMAT_PND_CONF_QTY
,0 DPHMCD_DEMAT_PND_CONF_QTY
,0 DPHMCD_SAFE_KEEPING_QTY
,0 DPHMCD_LOCKIN_QTY
,0 DPHMCD_ELIMINATION_QTY
,0 DPHMCD_EARMARK_QTY
,0 DPHMCD_AVAIL_LEND_QTY
,0 DPHMCD_LEND_QTY
,0 DPHMCD_BORROW_QTY
from cdsl_holding_dtls a with(nolock)
where convert(varchar(11),CDSHM_TRAS_DT,109) = convert(varchar(11),@pa_date,109)
and cdshm_dpm_id = @pa_dpm_id
and CDSHM_TRATM_CD in ('2246','2277')
and not exists (select 1 from cdsl_holding_dtls b with(nolock)
where convert(varchar(11),CDSHM_TRAS_DT,109) = convert(varchar(11),@pa_date,109)
and a.cdshm_ben_acct_no = b.cdshm_ben_acct_no 
and a.cdshm_isin = b.cdshm_isin
and case when CDSHM_TRATM_CD in ('2212','2230','2280') then  a.cdshm_trans_no else 1 end 
	= case when CDSHM_TRATM_CD in ('2212','2230','2280') then   b.cdshm_trans_no else 1 end 
and CDSHM_TRATM_CD in ('2212','2230','2280','2211','2220'))
and case when @pa_acct_no ='' then '1' else cdshm_ben_Acct_no end = case when @pa_acct_no ='' then '1' else @pa_acct_no  end 
union  all
select cdshm_ben_acct_no client, cdshm_isin isin, cdshm_qty qty
,0 DPHMCD_FREE_QTY
,0 DPHMCD_FREEZE_QTY
,0 DPHMCD_PLEDGE_QTY
,0 DPHMCD_DEMAT_PND_VER_QTY
,0 DPHMCD_REMAT_PND_CONF_QTY
,0 DPHMCD_DEMAT_PND_CONF_QTY
,0 DPHMCD_SAFE_KEEPING_QTY
,cdshm_qty DPHMCD_LOCKIN_QTY
,0 DPHMCD_ELIMINATION_QTY
,0 DPHMCD_EARMARK_QTY
,0 DPHMCD_AVAIL_LEND_QTY
,0 DPHMCD_LEND_QTY
,0 DPHMCD_BORROW_QTY
from cdsl_holding_dtls a with(nolock)
where convert(varchar(11),CDSHM_TRAS_DT,109) = convert(varchar(11),@pa_date,109)
and cdshm_dpm_id = @pa_dpm_id
and CDSHM_TRATM_CD in ('2212')
and case when @pa_acct_no ='' then '1' else cdshm_ben_Acct_no end = case when @pa_acct_no ='' then '1' else @pa_acct_no  end 
union  all
select cdshm_ben_acct_no client, cdshm_isin isin, cdshm_qty qty
,0 DPHMCD_FREE_QTY
,0 DPHMCD_FREEZE_QTY
,cdshm_qty DPHMCD_PLEDGE_QTY
,0 DPHMCD_DEMAT_PND_VER_QTY
,0 DPHMCD_REMAT_PND_CONF_QTY
,0 DPHMCD_DEMAT_PND_CONF_QTY
,0 DPHMCD_SAFE_KEEPING_QTY
,0 DPHMCD_LOCKIN_QTY
,0 DPHMCD_ELIMINATION_QTY
,0 DPHMCD_EARMARK_QTY
,0 DPHMCD_AVAIL_LEND_QTY
,0 DPHMCD_LEND_QTY
,0 DPHMCD_BORROW_QTY
from cdsl_holding_dtls a with(nolock)
where convert(varchar(11),CDSHM_TRAS_DT,109) = convert(varchar(11),@pa_date,109)
and cdshm_dpm_id = @pa_dpm_id
and CDSHM_TRATM_CD in ('2230','2280')
and case when @pa_acct_no ='' then '1' else cdshm_ben_Acct_no end = case when @pa_acct_no ='' then '1' else @pa_acct_no  end 
union  all
select cdshm_ben_acct_no client, cdshm_isin isin, cdshm_qty qty
,0 DPHMCD_FREE_QTY
,0 DPHMCD_FREEZE_QTY
,0 DPHMCD_PLEDGE_QTY
,0 DPHMCD_DEMAT_PND_VER_QTY
,0 DPHMCD_REMAT_PND_CONF_QTY
,0 DPHMCD_DEMAT_PND_CONF_QTY
,cdshm_qty DPHMCD_SAFE_KEEPING_QTY
,0 DPHMCD_LOCKIN_QTY
,0 DPHMCD_ELIMINATION_QTY
,0 DPHMCD_EARMARK_QTY
,0 DPHMCD_AVAIL_LEND_QTY
,0 DPHMCD_LEND_QTY
,0 DPHMCD_BORROW_QTY
from cdsl_holding_dtls a with(nolock)
where convert(varchar(11),CDSHM_TRAS_DT,109) = convert(varchar(11),@pa_date,109)
and cdshm_dpm_id = @pa_dpm_id
and CDSHM_TRATM_CD in ('2211')
and case when @pa_acct_no ='' then '1' else cdshm_ben_Acct_no end = case when @pa_acct_no ='' then '1' else @pa_acct_no  end 
union  all
select cdshm_ben_acct_no client, cdshm_isin isin, cdshm_qty qty
,0 DPHMCD_FREE_QTY
,0 DPHMCD_FREEZE_QTY
,0 DPHMCD_PLEDGE_QTY
,0 DPHMCD_DEMAT_PND_VER_QTY
,0 DPHMCD_REMAT_PND_CONF_QTY
,0 DPHMCD_DEMAT_PND_CONF_QTY
,0 DPHMCD_SAFE_KEEPING_QTY
,0 DPHMCD_LOCKIN_QTY
,0 DPHMCD_ELIMINATION_QTY
,0 DPHMCD_EARMARK_QTY
,cdshm_qty*-1 DPHMCD_AVAIL_LEND_QTY
,0 DPHMCD_LEND_QTY
,0 DPHMCD_BORROW_QTY
from cdsl_holding_dtls a with(nolock)
where convert(varchar(11),CDSHM_TRAS_DT,109) = convert(varchar(11),@pa_date,109)
and cdshm_dpm_id = @pa_dpm_id
and CDSHM_TRATM_CD in ('2220')
and case when @pa_acct_no ='' then '1' else cdshm_ben_Acct_no end = case when @pa_acct_no ='' then '1' else @pa_acct_no  end 
and not exists (select 1   FROM CDSL_HOLDING_DTLS b with (nolock)
WHERE CDSHM_TRATM_cD  in ( '2230') --=case when CDSHM_CDAS_TRAS_TYPE IN ('21','22','23') then '2262' else '2277' end --2261 added by tushar on jun 03 2014
and convert(varchar(11),CDSHM_TRAS_DT,109) = convert(varchar(11),@pa_date,109)
and a.cdshm_ben_Acct_no =b.cdshm_ben_Acct_no 
and a.cdshm_isin=b.cdshm_isin
and a.cdshm_trans_no =b.cdshm_trans_no 
)



SELECT client_hldg,isin_hldg,SUM(qty_hldg) qty_hldg
,sum(DPHMCD_FREE_QTY) DPHMCD_FREE_QTY
,sum(DPHMCD_FREEZE_QTY) DPHMCD_FREEZE_QTY
,sum(DPHMCD_PLEDGE_QTY) DPHMCD_PLEDGE_QTY
,sum(DPHMCD_DEMAT_PND_VER_QTY) DPHMCD_DEMAT_PND_VER_QTY
,sum(DPHMCD_REMAT_PND_CONF_QTY) DPHMCD_REMAT_PND_CONF_QTY
,sum(DPHMCD_DEMAT_PND_CONF_QTY) DPHMCD_DEMAT_PND_CONF_QTY
,sum(DPHMCD_SAFE_KEEPING_QTY) DPHMCD_SAFE_KEEPING_QTY
,sum(DPHMCD_LOCKIN_QTY) DPHMCD_LOCKIN_QTY
,sum(DPHMCD_ELIMINATION_QTY) DPHMCD_ELIMINATION_QTY
,sum(DPHMCD_EARMARK_QTY) DPHMCD_EARMARK_QTY
,sum(DPHMCD_AVAIL_LEND_QTY) DPHMCD_AVAIL_LEND_QTY
,sum(DPHMCD_LEND_QTY) DPHMCD_LEND_QTY
,sum(DPHMCD_BORROW_QTY) DPHMCD_BORROW_QTY
INTO #priviousholding FROM #priviousholding_1 with(nolock)
GROUP BY client_hldg,isin_hldg
 
--select * from #priviousholding where isin_hldg = 'INE894F01025' and client_hldg ='1206210000002209'

/*charged by tushar 28062012*/
--update #priviousholding  set qty_hldg  = qty_hldg - qty
--from #priviousholding  ,  #asontran
--where client_hldg = client
--and isin_hldg = isin 
/*charged by tushar 28062012*/


--select DISTINCT dpam_sba_no client_hldg_ason,DPHMCd_ISIN isin_hldg_ason,SUM(DPHMCd_CURR_QTY) qty_hldg_ason 
--into #asonholding from holdingallforview,dp_acct_mstr 
--where dpam_id = DPHMCd_DPAM_ID 
--and dpam_dpm_id = @pa_dpm_id
--and DPHMCd_HOLDING_DT = @pa_date
--GROUP BY dpam_sba_no,DPHMCd_ISIN

select DISTINCT dpam_sba_no client_hldg_ason,DPHMC_ISIN isin_hldg_ason,SUM(DPHMC_CURR_QTY) qty_hldg_ason 
,sum(DPHMC_FREE_QTY) DPHMC_FREE_QTY
,sum(DPHMC_FREEZE_QTY) DPHMC_FREEZE_QTY
,sum(DPHMC_PLEDGE_QTY)  DPHMC_PLEDGE_QTY
,sum(DPHMC_DEMAT_PND_VER_QTY) DPHMC_DEMAT_PND_VER_QTY
,sum(DPHMC_REMAT_PND_CONF_QTY) DPHMC_REMAT_PND_CONF_QTY
,sum(DPHMC_DEMAT_PND_CONF_QTY) DPHMC_DEMAT_PND_CONF_QTY
,sum(DPHMC_SAFE_KEEPING_QTY) DPHMC_SAFE_KEEPING_QTY
,sum(DPHMC_LOCKIN_QTY) DPHMC_LOCKIN_QTY
,sum(DPHMC_ELIMINATION_QTY) DPHMC_ELIMINATION_QTY
,sum(DPHMC_EARMARK_QTY)DPHMC_EARMARK_QTY 
,sum(DPHMC_AVAIL_LEND_QTY) DPHMC_AVAIL_LEND_QTY
,sum(DPHMC_LEND_QTY) DPHMC_LEND_QTY
,sum(DPHMC_BORROW_QTY) DPHMC_BORROW_QTY
into #asonholding from dp_hldg_mstr_cdsl with(nolock),dp_acct_mstr  with(nolock)
where dpam_id = DPHMC_DPAM_ID 
and dpam_dpm_id = @pa_dpm_id
and DPHMC_HOLDING_DT = @pa_date
and case when @pa_acct_no ='' then '1' else dpam_sba_no end = case when @pa_acct_no ='' then '1' else @pa_acct_no  end 
GROUP BY dpam_sba_no,DPHMC_ISIN
 
--select a.client_hldg,a.isin_hldg , isnull(qty_hldg,0) edmat_hldg 
--,isnull((select isnull(qty_hldg_ason,0) from #asonholding b 
--where client_hldg_ason = a.client_hldg and isin_hldg_ason = a.isin_hldg),0) cdas_hldg


--from #priviousholding a 


select client_hldg=convert(varchar(1000),isnull(a.client_hldg,client_hldg_ason)),
isin_hldg=isnull(a.isin_hldg,isin_hldg_ason), 
isnull(qty_hldg,0) edmat_hldg, cdas_hldg=isnull(qty_hldg_ason,0)
, DPHMCD_FREE_QTY
, dphmc_FREE_QTY
, DPHMCD_FREEZE_QTY
, dphmc_FREEZE_QTY
, DPHMCD_PLEDGE_QTY
, dphmc_PLEDGE_QTY
, DPHMCD_DEMAT_PND_VER_QTY
, dphmc_DEMAT_PND_VER_QTY
, DPHMCD_REMAT_PND_CONF_QTY
, dphmc_REMAT_PND_CONF_QTY
, DPHMCD_DEMAT_PND_CONF_QTY
, dphmc_DEMAT_PND_CONF_QTY
, DPHMCD_SAFE_KEEPING_QTY
, dphmc_SAFE_KEEPING_QTY
, DPHMCD_LOCKIN_QTY
, dphmc_LOCKIN_QTY
, DPHMCD_ELIMINATION_QTY
, dphmc_ELIMINATION_QTY
, DPHMCD_EARMARK_QTY
, dphmc_EARMARK_QTY
, DPHMCD_AVAIL_LEND_QTY
, dphmc_AVAIL_LEND_QTY
, DPHMCD_LEND_QTY
, dphmc_LEND_QTY
, DPHMCD_BORROW_QTY
, dphmc_BORROW_QTY
into #finalholding  
from #priviousholding a with(nolock) full outer join #asonholding b  with(nolock)
on (client_hldg_ason = a.client_hldg and isin_hldg_ason = a.isin_hldg)

-- 
--
--insert into #finalholding
--exec [pr_recon_holding_From_holdingallforview] @pa_excsm_id,@pa_date,@pa_flag,''    
--


if @pa_flag ='ALL'
select * from #finalholding   with(nolock)

if @pa_flag ='MATCH'
select * from #finalholding with(nolock) where edmat_hldg = cdas_hldg

if @pa_flag ='MISMATCH'
begin 
--if exists (select * from #finalholding with(nolock) where edmat_hldg <> cdas_hldg)
--begin 
--insert into dp_hldg_mstr_cdsl_mismatch
--select * from dp_hldg_mstr_cdsl where dphmc_holding_dt = @pa_date and dphmc_dpm_id = @pa_dpm_id
--end 
select * into tempdatafeb262016 from #finalholding with(nolock) --where edmat_hldg <> cdas_hldg
end 
--
--drop table tempdatafeb262016
--select * from #asontran where isin = 'INE894F01025' and client ='1206210000002209'
--select * from #priviousholding where isin_hldg = 'INE894F01025' and client_hldg ='1206210000002209'
--select * from #asonholding where isin_hldg_ason = 'INE894F01025' and client_hldg_ason ='1206210000002209'






end

GO
