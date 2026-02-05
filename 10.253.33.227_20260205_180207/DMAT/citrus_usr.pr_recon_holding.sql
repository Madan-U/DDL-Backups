-- Object: PROCEDURE citrus_usr.pr_recon_holding
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--select * from #holdingall
--exec pr_recon_holding 3,'sep 30 2010','ALL',''
--exec pr_recon_holding 485031,'may 24 2012','MATCH',''
--exec pr_recon_holding 3,'feb 28 2015','MISMATCH',''
CREATE proc [citrus_usr].[pr_recon_holding](@pa_excsm_id numeric
, @pa_date datetime
, @pa_flag char(15)
,@pa_ref_cur varchar(8000) output
)
as
   
begin 
if @pa_date='jul 03 2015'
begin

exec pr_recon_holding_audit 3,'jul 03 2015',@pa_flag,''
return
end 

declare @pa_dpm_id numeric
select @pa_dpm_id = dpm_id from dp_mstr where default_dp = dpm_excsm_id and dpm_excsm_id = @pa_excsm_id

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

insert into #holdingall
--exec [pr_get_holding_fix_latest] @pa_dpm_id,@l_dt,@l_dt,'0','9999999999999999',''    
exec [pr_get_holding_fix_latest_reco] @pa_dpm_id,@l_dt,@l_dt,'0','9999999999999999',''    
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
into #priviousholding_1 from #holdingall,dp_acct_mstr 
where dpam_id = DPHMCD_DPAM_ID 
and dpam_dpm_id = @pa_dpm_id
and dpam_sba_no not in (select dpam_sba_no  from dp_Acct_mstr where dpam_subcm_cd in (select subcm_cd from SUB_CTGRY_MSTR where subcm_desc like '%cuspa%'))
--and DPHMC_HOLDING_DT = 
--(select top 1 DPHMC_HOLDING_DT from DP_HLDG_MSTR_CDSL
--where DPHMC_HOLDING_DT <  @pa_date order by 1 desc)




select * into #tmp_cdsl_holding_dlts from cdsl_holding_dtls with(nolock)
where CDSHM_TRAS_DT = @pa_date



INSERT INTO #priviousholding_1
select cdshm_ben_acct_no client, cdshm_isin isin, cdshm_qty qty
from #tmp_cdsl_holding_dlts
where  cdshm_dpm_id = @pa_dpm_id
and CDSHM_TRATM_CD in ('2246','2277')
and CDSHM_CDAS_TRAS_TYPE <> '11'
and CDSHM_BEN_ACCT_NO not in (select dpam_sba_no  from dp_Acct_mstr where dpam_subcm_cd in
(select subcm_cd from SUB_CTGRY_MSTR where subcm_desc like '%cuspa%'))
union all 
select cdshm_ben_acct_no client, cdshm_isin isin, cdshm_qty qty
from #tmp_cdsl_holding_dlts
where  cdshm_dpm_id = @pa_dpm_id
and CDSHM_TRATM_CD in ('4456') and CDSHM_CDAS_SUB_TRAS_TYPE ='417' and CDSHM_TRAS_DT<'may 01 2023' 
and CDSHM_BEN_ACCT_NO not in (select dpam_sba_no  from dp_Acct_mstr where dpam_subcm_cd in (select subcm_cd from SUB_CTGRY_MSTR where subcm_desc like '%cuspa%'))
union all 
select cdshm_ben_acct_no client, cdshm_isin isin, cdshm_qty qty
from #tmp_cdsl_holding_dlts main
where  cdshm_dpm_id = @pa_dpm_id
and CDSHM_TRATM_CD in ('2246','2277')
and CDSHM_CDAS_TRAS_TYPE = '11'
and CDSHM_BEN_ACCT_NO not in (select dpam_sba_no  from dp_Acct_mstr where dpam_subcm_cd in
(select subcm_cd from SUB_CTGRY_MSTR where subcm_desc like '%cuspa%')) 
and citrus_usr.fn_splitval_by(main.cdshm_trans_cdas_code,52,'~')   = '' 
union all 
select cdshm_ben_acct_no client, cdshm_isin isin, cdshm_qty qty
from #tmp_cdsl_holding_dlts main
where  cdshm_dpm_id = @pa_dpm_id
and CDSHM_TRATM_CD in ('2246','2277')
and CDSHM_CDAS_TRAS_TYPE = '11'
and CDSHM_BEN_ACCT_NO not in (select dpam_sba_no  from dp_Acct_mstr where dpam_subcm_cd in
(select subcm_cd from SUB_CTGRY_MSTR where subcm_desc like '%cuspa%')) 
and citrus_usr.fn_splitval_by(main.cdshm_trans_cdas_code,52,'~')   <> '' 
and  not exists (select 1 from  #tmp_cdsl_holding_dlts ep_rej where convert(varchar(11),ep_rej.CDSHM_TRAS_DT,109) = convert(varchar(11),@pa_date,109)
and ep_rej.CDSHM_BEN_ACCT_NO = main.CDSHM_BEN_ACCT_NO 
and ep_rej.cdshm_isin = main.cdshm_isin 
and ep_rej.CDSHM_TRANS_NO = citrus_usr.fn_splitval_by(main.cdshm_trans_cdas_code,52,'~')  
and abs(ep_rej.CDSHM_QTY)=abs(main.CDSHM_QTY) 
--and left(main.CDSHM_COUNTER_BOID ,8) <> '12033200'
and ep_rej.CDSHM_TRATM_CD ='4466')
and  exists (select 1 from  #tmp_cdsl_holding_dlts ep_rej_part where convert(varchar(11),ep_rej_part.CDSHM_TRAS_DT,109) = convert(varchar(11),@pa_date,109)
and ep_rej_part.CDSHM_BEN_ACCT_NO = main.CDSHM_BEN_ACCT_NO 
and ep_rej_part.cdshm_isin = main.cdshm_isin 
and ep_rej_part.CDSHM_TRANS_NO = citrus_usr.fn_splitval_by(main.cdshm_trans_cdas_code,52,'~')  
--and abs(ep_rej.CDSHM_QTY)=abs(main.CDSHM_QTY) 
--and left(main.CDSHM_COUNTER_BOID ,8) <> '12033200'
and ep_rej_part.CDSHM_TRATM_CD ='2277'
and ep_rej_part.CDSHM_CDAS_TRAS_TYPE ='4' )
and CDSHM_BEN_ACCT_NO not in (select dpam_sba_no  from dp_Acct_mstr where dpam_subcm_cd in
(select subcm_cd from SUB_CTGRY_MSTR where subcm_desc like '%cuspa%'))
union all 
select main.cdshm_ben_acct_no client, main.cdshm_isin isin, ep_accpt_part.cdshm_qty*-1 qty
from #tmp_cdsl_holding_dlts main, #tmp_cdsl_holding_dlts ep_accpt_part  
where  main.cdshm_dpm_id = @pa_dpm_id 
and ep_accpt_part.CDSHM_BEN_ACCT_NO = main.CDSHM_BEN_ACCT_NO 
and ep_accpt_part.cdshm_isin = main.cdshm_isin 
and ep_accpt_part.CDSHM_TRANS_NO = citrus_usr.fn_splitval_by(main.cdshm_trans_cdas_code,52,'~')  
--and abs(ep_rej.CDSHM_QTY)=abs(main.CDSHM_QTY) 
--and left(main.CDSHM_COUNTER_BOID ,8) <> '12033200'
and ep_accpt_part.CDSHM_TRATM_CD ='2215'
and ep_accpt_part.CDSHM_CDAS_TRAS_TYPE ='4'

and main.CDSHM_TRATM_CD in ('2246','2277')
and main.CDSHM_CDAS_TRAS_TYPE = '11'
and citrus_usr.fn_splitval_by(main.cdshm_trans_cdas_code,52,'~')   <> '' 
and  not exists (select 1 from  #tmp_cdsl_holding_dlts ep_rej 
where ep_rej.CDSHM_BEN_ACCT_NO = main.CDSHM_BEN_ACCT_NO 
and ep_rej.cdshm_isin = main.cdshm_isin 
and ep_rej.CDSHM_TRANS_NO = citrus_usr.fn_splitval_by(main.cdshm_trans_cdas_code,52,'~')  
and abs(ep_rej.CDSHM_QTY)=abs(main.CDSHM_QTY) 
--and left(main.CDSHM_COUNTER_BOID ,8) <> '12033200'
and ep_rej.CDSHM_TRATM_CD ='4466')
and not  exists (select 1 from  #tmp_cdsl_holding_dlts ep_rej_part 
where ep_rej_part.CDSHM_BEN_ACCT_NO = main.CDSHM_BEN_ACCT_NO 
and ep_rej_part.cdshm_isin = main.cdshm_isin 
and ep_rej_part.CDSHM_TRANS_NO = citrus_usr.fn_splitval_by(main.cdshm_trans_cdas_code,52,'~')  
--and abs(ep_rej.CDSHM_QTY)=abs(main.CDSHM_QTY) 
--and left(main.CDSHM_COUNTER_BOID ,8) <> '12033200'
and ep_rej_part.CDSHM_TRATM_CD ='2277'
and ep_rej_part.CDSHM_CDAS_TRAS_TYPE ='4' )
and main.CDSHM_BEN_ACCT_NO not in (select dpam_sba_no  from dp_Acct_mstr where dpam_subcm_cd in
(select subcm_cd from SUB_CTGRY_MSTR where subcm_desc like '%cuspa%'))
union all 
select cdshm_ben_acct_no client, cdshm_isin isin, cdshm_qty qty
from #tmp_cdsl_holding_dlts main
where  cdshm_dpm_id = @pa_dpm_id
and CDSHM_TRATM_CD in ('2246','2277')
and CDSHM_CDAS_TRAS_TYPE = '11'
and CDSHM_BEN_ACCT_NO not in (select dpam_sba_no  from dp_Acct_mstr where dpam_subcm_cd in
(select subcm_cd from SUB_CTGRY_MSTR where subcm_desc like '%cuspa%')) 
and citrus_usr.fn_splitval_by(main.cdshm_trans_cdas_code,52,'~')   <> '' 
and  not exists (select 1 from  #tmp_cdsl_holding_dlts mf_redem 
where convert(varchar(11),mf_redem.CDSHM_TRAS_DT,109) = convert(varchar(11),@pa_date,109)
and mf_redem.CDSHM_BEN_ACCT_NO = main.CDSHM_BEN_ACCT_NO 
and mf_redem.cdshm_isin = main.cdshm_isin 
and mf_redem.CDSHM_TRANS_NO = citrus_usr.fn_splitval_by(main.cdshm_trans_cdas_code,52,'~')  
) 
and main.CDSHM_SETT_TYPE =''
and left(main.cdshm_isin,3) = 'INF'




drop table #tmp_cdsl_holding_dlts





SELECT client_hldg,isin_hldg,SUM(qty_hldg) qty_hldg INTO #priviousholding FROM #priviousholding_1
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
into #asonholding from dp_hldg_mstr_cdsl,dp_acct_mstr 
where dpam_id = DPHMC_DPAM_ID 
and dpam_dpm_id = @pa_dpm_id
and DPHMC_HOLDING_DT = @pa_date

GROUP BY dpam_sba_no,DPHMC_ISIN


--select a.client_hldg,a.isin_hldg , isnull(qty_hldg,0) edmat_hldg 
--,isnull((select isnull(qty_hldg_ason,0) from #asonholding b 
--where client_hldg_ason = a.client_hldg and isin_hldg_ason = a.isin_hldg),0) cdas_hldg


--from #priviousholding a 


select client_hldg=isnull(a.client_hldg,client_hldg_ason),
isin_hldg=isnull(a.isin_hldg,isin_hldg_ason), 
isnull(qty_hldg,0) edmat_hldg, cdas_hldg=isnull(qty_hldg_ason,0) 
into #finalholding  
from #priviousholding a full outer join #asonholding b 
on (client_hldg_ason = a.client_hldg and isin_hldg_ason = a.isin_hldg)



delete from #finalholding where  client_hldg ='1203320009858060' and isin_hldg in ('INF732E01011','INE669C01036')
delete from #finalholding where  client_hldg ='1203320049270305' and isin_hldg in ('INE669E01016') -- ADDED BY YOGESH DATED 19072021 AS PER MAIL FROM JAGANNATH KADAM DATED 19072021
delete from #finalholding where  client_hldg ='1203320034017031' and isin_hldg in ('INE935N01020')-- ADDED BY YOGESH DATED 19072021 AS PER MAIL FROM JAGANNATH KADAM DATED 19072021


if @pa_flag ='ALL'
select * from #finalholding  

if @pa_flag ='MATCH'
select * from #finalholding where edmat_hldg = cdas_hldg

if @pa_flag ='MISMATCH'
begin
	


		
		--select * from #finalholding where edmat_hldg <> cdas_hldg
		
		
select cdshm_ben_acct_no ac, cdshm_isin isin , sum(cdshm_qty  * -1 ) fill_qty  into #tempdata_forreco from cdsl_holding_dtls a where CDSHM_CDAS_SUB_TRAS_TYPE ='1103'  and cdshm_tras_dt between getdate()-6 and getdate()
and exists (select 1 from cdsl_holding_dtls b where a.CDSHM_BEN_ACCT_NO = b.CDSHM_BEN_ACCT_NO and a.cdshm_isin = b.cdshm_isin and a.CDSHM_TRANS_NO =b.CDSHM_TRANS_NO 
and b.CDSHM_CDAS_SUB_TRAS_TYPE ='802')
group by cdshm_ben_acct_no , cdshm_isin 




--select * from #finalholding where edmat_hldg <> cdas_hldg

select a.* from #finalholding a left outer join #tempdata_forreco on ac = client_hldg  and isin = isin_hldg where edmat_hldg+case when edmat_hldg <> cdas_hldg then isnull(fill_qty,0)  else 0 end  <> cdas_hldg 



	IF NOT EXISTS (select top 1  * from #finalholding a left outer join #tempdata_forreco on ac = client_hldg  and isin = isin_hldg where edmat_hldg+case when edmat_hldg <> cdas_hldg then isnull(fill_qty,0)  else 0 end  <> cdas_hldg )
		BEGIN
		insert into cdsl_recon_log
		select 'START' ,@pa_date,getdate(),'NO MISMATCH'
		END 
		ELSE
		BEGIN
		insert into cdsl_recon_log
		select 'START' ,@pa_date,getdate(),'MISMATCH'
		END


insert into CDSL_recon_mismatch_data
		select a.*, @pa_date, GETDATE ()  from #finalholding a left outer join #tempdata_forreco on ac = client_hldg  and isin = isin_hldg where edmat_hldg+case when edmat_hldg <> cdas_hldg then isnull(fill_qty,0)  else 0 end  <> cdas_hldg 



--
--
--select * from #asontran where isin = 'INE894F01025' and client ='1206210000002209'
--select * from #priviousholding where isin_hldg = 'INE894F01025' and client_hldg ='1206210000002209'
--select * from #asonholding where isin_hldg_ason = 'INE894F01025' and client_hldg_ason ='1206210000002209'

end




end

GO
