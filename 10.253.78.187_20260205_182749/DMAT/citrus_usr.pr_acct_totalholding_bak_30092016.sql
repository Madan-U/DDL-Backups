-- Object: PROCEDURE citrus_usr.pr_acct_totalholding_bak_30092016
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


--pr_acct_totalholding '10054016',''  
CREATE procedure [citrus_usr].[pr_acct_totalholding]( @pa_sba_no  varchar(20)  
                                 , @pa_output  varchar(8000) output  
                                   )  
as  
--  
--  
begin  
--  
if len(@pa_sba_no) = 8
select distinct dpam.dpam_sba_no            CLIENT_ID  
     , dpdhm.dpdhm_isin                   ISIN  
     , convert(varchar,dpdhm.dpdhm_qty)    QTY  , ISIN_NAME
from   dp_hldg_mstr_nsdl            dpdhm  
     , dp_acct_mstr                  dpam  , isin_mstr
where  dpdhm.dpdhm_dpam_id       = dpam.dpam_id  
and    dpam.dpam_sba_no            = @pa_sba_no     
and    isnull(dpdhm.dpdhm_qty,0) <> 0
and    not exists(select dptd_dpam_id from dp_trx_dtls dptd where dpdhm.dpdhm_dpam_id = dptd.dptd_dpam_id and dptd.dptd_isin = dpdhm.dpdhm_isin and isnull(dptd.dptd_batch_no,'') <> '' and left(dptd_rmks,4) = 'AUTO' and dptd_deleted_ind = 1 )    
and    dpam.dpam_deleted_ind       = 1  
and    dpdhm.dpdhm_deleted_ind   = 1  and ISIN_CD=DPDHM_ISIN and isin_deleted_ind=1

if len(@pa_sba_no) = 16
select distinct dpam.dpam_sba_no            CLIENT_ID  
     , dphmc.dphmc_isin                   ISIN  
     , replace(convert(varchar,dphmc.DPHMC_CURR_QTY),'.000','')    QTY  ,ISIN_NAME, '' dptdc_trans_no, '' status , ISIN_NAME as [ISIN NAME],'' qtydesc
     , '0' dptdc_id,replace(convert(varchar,dphmc.DPHMC_CURR_QTY),'.000','')    dptdc_qty,dphmc.dphmc_isin                   dptdc_isin
     , valuation = replace(isnull((Select top 1 isnull((dphmc.DPHMC_CURR_QTY*CLOPM_CDSL_RT),0) from CLOSING_LAST_CDSL where CLOPM_ISIN_CD=DPHMC_ISIN and CLOPM_DELETED_IND=1),'0'),'.0000000','')
from   dp_hldg_mstr_cdsl            dphmc  
     , dp_acct_mstr                  dpam  ,isin_mstr
where  dphmc.dphmc_dpam_id       = dpam.dpam_id  
and    dpam.dpam_sba_no            = @pa_sba_no     
and    isnull(dphmc.DPHMC_CURR_QTY,0) <> 0
and    not exists(select dptdc_dpam_id from dp_trx_dtls_cdsl dptdc where dphmc.dphmc_dpam_id = dptdc.dptdc_dpam_id and dptdc.dptdc_isin = dphmc.dphmc_isin and isnull(dptdc.dptdc_batch_no,'') <> '' and left(dptdc_rmks,4) = 'AUTO' and dptdc_deleted_ind = 1 )  
and    dpam.dpam_deleted_ind       = 1  
and    dphmc.dphmc_deleted_ind   = 1   and ISIN_CD=dphmc_ISIN and isin_deleted_ind=1

--  
--   
end  
--  
--

GO
