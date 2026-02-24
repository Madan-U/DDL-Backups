-- Object: PROCEDURE citrus_usr.pr_get_holding_fix_latest_BBOCODE_arch
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


--DECLARE @p19 VARCHAR(1)      
--SET @p19=NULL      
--exec Pr_Rpt_Statement @pa_dptype='CDSL',@pa_excsmid=3,@pa_fromdate='AUG  2 2011',@pa_todate='AUG  2 2011'      
--,@pa_fromaccid='1201090000000101'      
--,@pa_toaccid='1201090000000101'      
--,@pa_bulk_printflag='N'      
--,@pa_stopbillclients_flag='N'      
--,@pa_isincd='INF732E01037'      
--,@pa_group_cd='|*~|N',@pa_transclientsonly='N      
--',@pa_Hldg_Yn='N',@pa_login_pr_entm_id='1'      
--,@pa_login_entm_cd_chain='HO|*~|',@pa_settm_type=''      
--,@pa_settm_no_fr='',@pa_settm_no_to=''      
--,@PA_WITHVALUE='N'      
--,@pa_output=@p19 output      
--SELECT @p19      
      
--exec [pr_get_holding_fix_latest] 3,'MAR 31 2012','MAR 31 2012','0','9999999999999999',''    
--exec [pr_get_holding_fix_latest] 3,'jun 01 2012','jun 01 2012','1201090000000101','1201090000000101',''    
--1201090000025122~INE083C01022    

CREATE PROCEDURE [citrus_usr].[pr_get_holding_fix_latest_BBOCODE_arch]
(
	@pa_dpm_id  NUMERIC,
	@pa_from_dt DATETIME, 
	@pa_to_dt   DATETIME  ,
	@pa_ben_acct_no_fr VARCHAR(16),
	@pa_ben_acct_no_to VARCHAR(16),
	@PA_BBO VARCHAR(100),
	@pa_out  VARCHAR(8000) out
)      
AS      

BEGIN       

	--DECLARE
	--	@pa_dpm_id NUMERIC,
	--	@pa_from_dt DATETIME, 
	--	@pa_to_dt DATETIME ,
	--	@pa_ben_acct_no_fr VARCHAR(16),
	--	@pa_ben_acct_no_to VARCHAR(16),
	--	@PA_BBO VARCHAR(100),
	--	@pa_out  VARCHAR(8000) 
	
	--SELECT 
	--@pa_dpm_id =3,
	--@pa_from_dt ='2019-11-23',
	--@pa_to_dt ='2019-11-23',
	--@pa_ben_acct_no_fr='',
	--@pa_ben_acct_no_to ='',
	--@PA_BBO ='RP61'
  
DECLARE @l_min_trx_dt   DATETIME
DECLARE @l_base_hldg_dt DATETIME

SET @l_min_trx_dt   = ''
SET @l_base_hldg_dt = ''
--#vw_holding_base_all_tmp
IF EXISTS(SELECT * FROM  bitmap_ref_mstr  where bitrm_parent_cd='arch' and bitrm_values ='1')
BEGIN 
	SELECT @l_min_trx_dt = min(hst_fr_dt) from archival_details 
	SELECT @l_base_hldg_dt = min(dphmcd_holding_dt) from #vw_holding_base_all_tmp
END 
ELSE 
BEGIN 


SET @l_min_trx_dt = 'aug 01 2011'
SET @l_base_hldg_dt = 'jul 31 2011'


END 
 
 
IF OBJECT_ID('tempdb..#CLIENTLIST') IS NOT NULL
    DROP TABLE #CLIENTLIST
 
 SELECT A.DPAM_ID ID , A.DPAM_SBA_NO SBANO 
	   	   INTO #CLIENTLIST  
	FROM DP_ACCT_MSTR  A WITH(NOLOCK)
	INNER JOIN ACCOUNT_PROPERTiES  B WITH(NOLOCK)
	ON  B.ACCP_CLISBA_ID     = A.DPAM_ID AND 
		B.ACCP_ACCPM_PROP_CD ='BBO_CODE' AND
		B.ACCP_VALUE         = @PA_BBO 
	GROUP BY A.DPAM_ID , A.DPAM_SBA_NO


	/** NEW ADDITION START FOR OPTIMIZATION**/
SELECT DP_ACCT_MSTR.* INTO #DP_ACCT_MSTR  FROM DP_ACCT_MSTR WITH(NOLOCK) , ACCOUNT_PROPERTIES WITH(NOLOCK) WHERE ACCP_CLISBA_ID = DPAM_ID AND 
ACCP_ACCPM_PROP_CD ='BBO_CODE'
AND ACCP_VALUE = @PA_BBO 



	
IF OBJECT_ID('tempdb..#cdsl_holding_dtls_tmp') IS NOT NULL
    DROP TABLE #cdsl_holding_dtls_tmp
SELECT A.* INTO #cdsl_holding_dtls_tmp 
         FROM dmat_archival.citrus_usr.cdsl_holding_dtls A WITH (NOLOCK)    
		    ,#DP_ACCT_MSTR D  WITH(NOLOCK) WHERE DPAM_SBA_NO=CDSHM_BEN_ACCT_NO
		
CREATE NONCLUSTERED INDEX IX_#cdsl_holding_dtls_tmp_CDSHM_BEN_ACCT_NO ON 
                    #cdsl_holding_dtls_tmp(CDSHM_BEN_ACCT_NO , CDSHM_TRAS_DT ,cdshm_dpm_id) INCLUDE (cdshm_tratm_cd)


IF OBJECT_ID('tempdb..#vw_holding_base_all_tmp') IS NOT NULL
    DROP TABLE #vw_holding_base_all_tmp
	SELECT A.* INTO #vw_holding_base_all_tmp 
			FROM vw_holding_base_all A WITH (NOLOCK)
			 INNER JOIN #CLIENTLIST B On   A.dphmcd_dpam_id =B.ID 
			 WHERE A.dphmcd_dpm_id = @pa_dpm_id 
  
CREATE NONCLUSTERED INDEX IX_#vw_holding_base_all_tmp ON  
                          #vw_holding_base_all_tmp(dphmcd_dpam_id , DPHMCD_HOLDING_DT ,DPHMCD_DPM_ID)

 

 
  IF OBJECT_ID('tempdb..#dp_acct_mstr_tmp') IS NOT NULL
    DROP TABLE #dp_acct_mstr_tmp
 
SELECT 
XY.DPAM_ID	
,XY.DPAM_CRN_NO	
,XY.DPAM_ACCT_NO	
,XY.DPAM_SBA_NAME	
,XY.DPAM_SBA_NO	
,XY.DPAM_EXCSM_ID	
,XY.DPAM_DPM_ID	
,XY.DPAM_ENTTM_CD	
,XY.DPAM_CLICM_CD	
,XY.DPAM_STAM_CD	
,XY.DPAM_CREATED_BY	
,XY.DPAM_CREATED_DT	
,XY.DPAM_LST_UPD_BY	
,XY.DPAM_LST_UPD_DT	
,XY.DPAM_DELETED_IND	
,XY.dpam_subcm_cd	
,XY.dpam_batch_no	
,XY.DPAM_BBO_CODE INTO #dp_acct_mstr_tmp 
             FROM #vw_holding_base_all_tmp A 
INNER JOIN #DP_ACCT_MSTR  XY with (nolock)  ON XY.dpam_id = A.dphmcd_dpam_id
GROUP BY 
XY.DPAM_ID	
,XY.DPAM_CRN_NO	
,XY.DPAM_ACCT_NO	
,XY.DPAM_SBA_NAME	
,XY.DPAM_SBA_NO	
,XY.DPAM_EXCSM_ID	
,XY.DPAM_DPM_ID	
,XY.DPAM_ENTTM_CD	
,XY.DPAM_CLICM_CD	
,XY.DPAM_STAM_CD	
,XY.DPAM_CREATED_BY	
,XY.DPAM_CREATED_DT	
,XY.DPAM_LST_UPD_BY	
,XY.DPAM_LST_UPD_DT	
,XY.DPAM_DELETED_IND	
,XY.dpam_subcm_cd	
,XY.dpam_batch_no	
,XY.DPAM_BBO_CODE
  


IF EXISTS(SELECT NAME FROM sysobjects WHERE name ='holdingall')  
DROP TABLE holdingall  
      
SELECT 
 DISTINCT cdshm_dpm_id DPHMCD_DPM_ID      
,cdshm_dpam_id  DPHMCD_DPAM_ID        
,cdshm_isin  DPHMCD_ISIN    
,CONVERT(NUMERIC(18,5),0) DPHMCD_CURR_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_FREE_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_FREEZE_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_PLEDGE_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_DEMAT_PND_VER_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_REMAT_PND_CONF_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_DEMAT_PND_CONF_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_SAFE_KEEPING_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_LOCKIN_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_ELIMINATION_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_EARMARK_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_AVAIL_LEND_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_LEND_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_BORROW_QTY    
INTO #tmp_dp_daily_hldg_cdsl 
FROM 
#cdsl_holding_dtls_tmp  A with (nolock) 
INNER JOIN #CLIENTLIST B ON CDSHM_BEN_ACCT_NO = SBANO 
where  CDSHM_TRAS_DT >= @l_min_trx_dt      
and CDSHM_TRAS_DT <= @pa_to_dt     
and cdshm_dpm_id = @pa_dpm_id      
and cdshm_tratm_cd in ('2246','2277','2201','3102','2270','2220','2205')    
--and cdshm_isin =@pa_isin 
   --and cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to 
     
INSERT INTO  #tmp_dp_daily_hldg_cdsl     
SELECT DISTINCT dphmcd_dpm_id , dphmcd_dpam_id , dphmcd_isin     
,CONVERT(NUMERIC(18,5),0) DPHMCD_CURR_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_FREE_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_FREEZE_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_PLEDGE_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_DEMAT_PND_VER_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_REMAT_PND_CONF_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_DEMAT_PND_CONF_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_SAFE_KEEPING_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_LOCKIN_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_ELIMINATION_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_EARMARK_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_AVAIL_LEND_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_LEND_QTY    
,CONVERT(NUMERIC(18,5),0) DPHMCD_BORROW_QTY    
from #vw_holding_base_all_tmp a WITH (NOLOCK) 
     INNER JOIN  #dp_acct_mstr_tmp   D WITH (NOLOCK) ON  D.dpam_id = A.DPHMCD_DPAM_ID  
	 INNER JOIN #CLIENTLIST  XY  ON A.dphmcd_dpam_id=XY.ID
where dphmcd_holding_dt =@l_base_hldg_dt    
AND  dphmcd_dpm_id = @pa_dpm_id       
--and dpam_sba_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to         
--and dphmcd_isin =@pa_isin 
AND sbano = dpam_sba_no     
AND NOT EXISTS(SELECT b.dphmcd_dpam_id,b.dphmcd_isin,b.dphmcd_dpm_id from #tmp_dp_daily_hldg_cdsl b with (nolock) where a.dphmcd_dpm_id = b.dphmcd_dpm_id    
AND a.dphmcd_dpam_id = b.dphmcd_dpam_id and a.dphmcd_isin = b.dphmcd_isin)    
                      
     
    
    
--create index ix_1 on #tmp_dp_daily_hldg_cdsl(DPHMCD_DPM_ID,DPHMCD_DPAM_ID,dphmcd_isin)                    
--SELECT * into #dematpendin from dmat_archival.citrus_usr.cdsl_holding_dtls     with(nolock)     
--WHERE CDSHM_TRAS_DT  >=@l_min_trx_dt and CDSHM_TRAS_DT   <= @pa_to_dt    
--and (cdshm_tratm_cd in ('2246','2277','3102')       or (cdshm_tratm_cd in ('2251') and cdshm_trans_cdas_code like '%~607~%'))
--and   cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to 
--and cdshm_dpm_id = @pa_dpm_id    
--


    
SELECT dphmcd_dpm_id ,dphmcd_dpam_id , dphmcd_isin                      
,sum(DPHMCD_CURR_QTY) DPHMCD_CURR_QTY           
 ,sum(DPHMCD_FREE_QTY) DPHMCD_FREE_QTY                          
 ,sum(DPHMCD_FREEZE_QTY)   DPHMCD_FREEZE_QTY                        
 ,sum(DPHMCD_PLEDGE_QTY )   DPHMCD_PLEDGE_QTY                        
 ,sum(DPHMCD_DEMAT_PND_VER_QTY)    DPHMCD_DEMAT_PND_VER_QTY                        
 ,sum(DPHMCD_REMAT_PND_CONF_QTY)    DPHMCD_REMAT_PND_CONF_QTY                        
 ,sum(DPHMCD_DEMAT_PND_CONF_QTY)    DPHMCD_DEMAT_PND_CONF_QTY                        
 ,sum(DPHMCD_SAFE_KEEPING_QTY )   DPHMCD_SAFE_KEEPING_QTY                        
 ,sum(DPHMCD_LOCKIN_QTY )   DPHMCD_LOCKIN_QTY                        
 ,sum(DPHMCD_ELIMINATION_QTY)  DPHMCD_ELIMINATION_QTY                        
 ,sum(DPHMCD_EARMARK_QTY)    DPHMCD_EARMARK_QTY                        
 ,sum(DPHMCD_AVAIL_LEND_QTY)    DPHMCD_AVAIL_LEND_QTY                        
 ,sum(DPHMCD_LEND_QTY)   DPHMCD_LEND_QTY                        
 ,sum(DPHMCD_BORROW_QTY)   DPHMCD_BORROW_QTY                        
 ,dphmcd_holding_dt                      
 ,dphmcd_cntr_settm_id  into #finalholding   from (                      
SELECT dphmcd_dpm_id ,dphmcd_dpam_id , dphmcd_isin                      
,DPHMCD_CURR_QTY    
 ,DPHMCD_FREE_QTY    
 ,DPHMCD_FREEZE_QTY    
 ,DPHMCD_PLEDGE_QTY     
 ,0 DPHMCD_DEMAT_PND_VER_QTY    
 ,DPHMCD_REMAT_PND_CONF_QTY    
 ,DPHMCD_DEMAT_PND_CONF_QTY    
 ,DPHMCD_SAFE_KEEPING_QTY     
 ,DPHMCD_LOCKIN_QTY     
 ,DPHMCD_ELIMINATION_QTY    
 ,DPHMCD_EARMARK_QTY    
 ,DPHMCD_AVAIL_LEND_QTY    
 ,DPHMCD_LEND_QTY    
 ,DPHMCD_BORROW_QTY    
 ,@pa_to_dt dphmcd_holding_dt                      
 ,'' dphmcd_cntr_settm_id                      
from (SELECT cdshm_dpam_id  dphmcd_dpam_id,cdshm_isin dphmcd_isin 
,sum(case when cdshm_tratm_cd in ('2246','2277') then cdshm_qty else 0 END)  DPHMCD_CURR_QTY    
,sum(case when cdshm_tratm_cd in ('2246','2277') then cdshm_qty else 0 END)  DPHMCD_FREE_QTY                        
,0 DPHMCD_FREEZE_QTY                        
,0 DPHMCD_PLEDGE_QTY                        
,sum(case when cdshm_tratm_cd in ('2201') then cdshm_qty else 0 END)  DPHMCD_DEMAT_PND_VER_QTY                        
,0 DPHMCD_REMAT_PND_CONF_QTY                        
,0 DPHMCD_DEMAT_PND_CONF_QTY                        
,0 DPHMCD_SAFE_KEEPING_QTY                        
,0 DPHMCD_LOCKIN_QTY                        
,0 DPHMCD_ELIMINATION_QTY                        
,0 DPHMCD_EARMARK_QTY                        
,0 DPHMCD_AVAIL_LEND_QTY                        
,0 DPHMCD_LEND_QTY                        
,0 DPHMCD_BORROW_QTY                        
--,CDSHM_TRG_SETTM_NO  dphmcd_cntr_settm_id                  
,'' dphmcd_cntr_settm_id                  
,cdshm_dpm_id dphmcd_dpm_id , cdshm_trans_no dphmcd_trans_no                     
from   #cdsl_holding_dtls_tmp        with(nolock)   , #CLIENTLIST                   
where cdshm_tratm_cd in ('2246','2277','2201')   
--and (CITRUS_USR.FN_SPLITVAL_BY(SUBSTRING(cdshm_trans_cdas_code,CHARINDEX('D~',cdshm_trans_cdas_code),LEN(cdshm_trans_cdas_code)),2,'~') NOT IN ('33','7')) 
--and   cdshm_ben_acct_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
--and   cdshm_isin = @pa_isin              
and   CDSHM_TRAS_DT  >=@l_min_trx_dt      
and   CDSHM_TRAS_DT   <= @pa_to_dt 
and cdshm_dpm_id = @pa_dpm_id 
and sbano =cdshm_ben_acct_no
group by         cdshm_dpam_id  ,cdshm_isin  ,cdshm_dpm_id  , cdshm_trans_no     
union  all                     
SELECT dphmcd_dpam_id ,dphmcd_isin
,sum(dphmcd_curr_qty   )             
,sum(DPHMCD_FREE_QTY   )                     
,sum(DPHMCD_FREEZE_QTY       )                 
,sum(DPHMCD_PLEDGE_QTY     )                   
,sum(DPHMCD_DEMAT_PND_VER_QTY  )                      
,sum(DPHMCD_REMAT_PND_CONF_QTY  )                      
,sum(DPHMCD_DEMAT_PND_CONF_QTY  )                      
,sum(DPHMCD_SAFE_KEEPING_QTY  )                      
,sum(DPHMCD_LOCKIN_QTY  )                      
,sum(DPHMCD_ELIMINATION_QTY  )                      
,sum(DPHMCD_EARMARK_QTY )                       
,sum(DPHMCD_AVAIL_LEND_QTY)                        
,sum(DPHMCD_LEND_QTY   )                     
,sum(DPHMCD_BORROW_QTY )                     
,'' dphmcd_cntr_settm_id  ,dphmcd_dpm_id , '' dphmcd_trans_no                     
from 
#vw_holding_base_all_tmp,
#dp_acct_mstr_tmp, 
#CLIENTLIST with(nolock)                      
where DPHMCd_HOLDING_DT =@l_base_hldg_dt    
and dphmcd_dpam_id = dpam_id   
and dphmcd_dpm_id = @pa_dpm_id
and dpam_sba_no = sbano   
--and dpam_sba_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
--and dphmcd_isin = @pa_isin    
group by         dphmcd_dpam_id,dphmcd_isin ,dphmcd_dpm_id 
    
) a      
) b      
                     
group by dphmcd_dpm_id,dphmcd_holding_dt,dphmcd_dpam_id,dphmcd_isin   ,dphmcd_cntr_settm_id                      
having (sum(dphmcd_curr_qty) <> '0'                        
or sum(DPHMCD_FREE_QTY) <> '0'                        
or sum(DPHMCD_FREEZE_QTY) <> '0'                        
or sum(DPHMCD_PLEDGE_QTY ) <> '0'                        
or sum(DPHMCD_DEMAT_PND_VER_QTY)  <> '0'                        
or sum(DPHMCD_REMAT_PND_CONF_QTY)  <> '0'                        
or sum(DPHMCD_DEMAT_PND_CONF_QTY)  <> '0'                        
or sum(DPHMCD_SAFE_KEEPING_QTY ) <> '0'                        
or sum(DPHMCD_LOCKIN_QTY ) <> '0'                        
or sum(DPHMCD_ELIMINATION_QTY)  <>  '0'                        
or sum(DPHMCD_EARMARK_QTY)  <> '0'                        
or sum(DPHMCD_AVAIL_LEND_QTY)  <> '0'                        
or sum(DPHMCD_LEND_QTY)  <> '0'                        
or sum(DPHMCD_BORROW_QTY)  <> '0')       
      
     
    

    
update a      
SET a.DPHMCD_CURR_QTY = f.DPHMCD_CURR_QTY    
,a.DPHMCD_FREE_QTY= 0--f.DPHMCD_FREE_QTY    
,a.DPHMCD_FREEZE_QTY= f.DPHMCD_FREEZE_QTY    
,a.DPHMCD_PLEDGE_QTY= f.DPHMCD_PLEDGE_QTY    
,a.DPHMCD_DEMAT_PND_VER_QTY  = 0   
,a.DPHMCD_REMAT_PND_CONF_QTY= 0  
,a.DPHMCD_DEMAT_PND_CONF_QTY = 0  
,a.DPHMCD_SAFE_KEEPING_QTY= f.DPHMCD_SAFE_KEEPING_QTY    
,a.DPHMCD_LOCKIN_QTY= f.DPHMCD_LOCKIN_QTY    
,a.DPHMCD_ELIMINATION_QTY= f.DPHMCD_ELIMINATION_QTY    
,a.DPHMCD_EARMARK_QTY= f.DPHMCD_EARMARK_QTY    
,a.DPHMCD_AVAIL_LEND_QTY= f.DPHMCD_AVAIL_LEND_QTY    
,a.DPHMCD_LEND_QTY= f.DPHMCD_LEND_QTY    
,a.DPHMCD_BORROW_QTY= f.DPHMCD_BORROW_QTY    
from #tmp_dp_daily_hldg_cdsl   a with (nolock), #finalholding f    with (nolock)
where a.dphmcd_dpam_id= f.dphmcd_dpam_id     
and a.dphmcd_dpm_id = f.dphmcd_dpm_id     
and a.dphmcd_isin = f.dphmcd_isin  



/**/
--DROP TABLE #holdingdmtpenfing 
--DROP TABLE #trasdmtpenfing
--DROP TABLE #trasdmtcnfrej
--DROP TABLE #trasdmtpenfing
--DROP TABLE #finaldmatpen
--DROP TABLE #finaldmatcnfrej
--DROP TABLE #FINALDEMATHOLDI


create table #FINALREMTHOLDI
(DPHMCD_DPAM_ID NUMERIC,DPHMCD_ISIN VARCHAR(50),trans_no VARCHAR(100),qty NUMERIC(18,5),RMATPENDING NUMERIC(18,5))

/*remat calculation */

 
SELECT dphmcd_dpam_id,dphmcd_isin ,sum(DPHMCD_REMAT_PND_CONF_QTY) qty ,'' trans_no  
into #holdingdmtpenfing from  #vw_holding_base_all_tmp with (nolock), #dp_acct_mstr_tmp  with (nolock), #CLIENTLIST
where DPHMCD_DPAM_ID = DPAM_ID AND dphmcd_holding_dt=@l_base_hldg_dt
--and dpam_sba_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and dphmcd_dpm_id = @PA_DPM_ID
and sbano = dpam_sba_no
group by dphmcd_dpam_id,dphmcd_isin 
having sum(DPHMCD_REMAT_PND_CONF_QTY) <> 0 




SELECT cdshm_dpam_id , cdshm_isin , sum(cdshm_qty) qty ,cdshm_trans_no into #trasdmtpenfing 
 from #cdsl_holding_dtls_tmp with (nolock), #CLIENTLIST
where CDSHM_TRATM_CD='2205'
and sbano = cdshm_ben_acct_no
--and CDSHM_BEN_ACCT_NO between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and CDSHM_DPM_ID = @PA_DPM_ID

And cdshm_tras_dt between @l_min_trx_dt and @PA_TO_DT
group by cdshm_dpam_id,cdshm_isin,cdshm_trans_no



SELECT * 
into #tras 
from #cdsl_holding_dtls_tmp with (nolock), #CLIENTLIST
where cdshm_tratm_cd in ('2255','2277')
--and CDSHM_BEN_ACCT_NO between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and CDSHM_DPM_ID = @PA_DPM_ID
and cdshm_ben_acct_no = sbano

And cdshm_tras_dt between @l_min_trx_dt and @PA_TO_DT
and (CDSHM_CDAS_TRAS_TYPE in ('7','33'))




SELECT CDSHM_TRATM_CD,cdshm_dpam_id , cdshm_isin , cdshm_trans_no,sum(case when  CDSHM_CDAS_SUB_TRAS_TYPE in( '709','703') then cdshm_qty*-1
															else cdshm_qty END ) cdshm_qty
into #trasdmtcnfrej from #tras A with (nolock) 
where cdshm_tratm_cd in ('2255','2277') and CDSHM_CDAS_SUB_TRAS_TYPE IN ('707','709','703','3304','705')
--and CDSHM_BEN_ACCT_NO between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and CDSHM_DPM_ID = @PA_DPM_ID

and (CDSHM_CDAS_TRAS_TYPE IN ('33','7'))
and cdshm_tras_dt between @l_min_trx_dt and @PA_TO_DT
and (cdshm_trans_no in (SELECT DISTINCT cdshm_trans_no from #trasdmtpenfing B )
OR EXISTS(SELECT DPHMCD_DPAM_ID,DPHMCD_ISIN FROM #holdingdmtpenfing WHERE DPHMCD_DPAM_ID = CDSHM_DPAM_ID 
AND DPHMCD_ISIN = CDSHM_ISIN ))
group by cdshm_dpam_id,cdshm_isin,cdshm_trans_no, cdshm_tratm_cd





update tras SET cdshm_trans_no =''
from #trasdmtpenfing tras
where exists(SELECT dphmcd_dpam_id , dphmcd_isin from #holdingdmtpenfing where dphmcd_dpam_id = cdshm_dpam_id and dphmcd_isin = cdshm_isin )


update trascnfrej SET cdshm_trans_no =''
from #trasdmtcnfrej trascnfrej
where exists(SELECT dphmcd_dpam_id , dphmcd_isin from #holdingdmtpenfing where dphmcd_dpam_id = cdshm_dpam_id and dphmcd_isin = cdshm_isin )


delete a from #trasdmtcnfrej a
where CDSHM_TRATM_CD ='2255'
and exists(SELECT * from #trasdmtcnfrej b where a.cdshm_dpam_id = b.cdshm_dpam_id 
and a.cdshm_isin = b.cdshm_isin
and a.cdshm_trans_no = b.cdshm_trans_no
and b.CDSHM_TRATM_CD = '2277')

 

SELECT dphmcd_dpam_id,dphmcd_isin,trans_no,sum(qty) qty into #finaldmatpen from (
SELECT dphmcd_dpam_id,dphmcd_isin,qty,trans_no from #holdingdmtpenfing
union ALL
SELECT cdshm_dpam_id , cdshm_isin,qty,cdshm_trans_no from #trasdmtpenfing) a 
group by dphmcd_dpam_id,dphmcd_isin,trans_no

SELECT cdshm_dpam_id , cdshm_isin , cdshm_trans_no ,sum(cdshm_qty) qty 
into #finaldmatcnfrej from #trasdmtcnfrej 
group by cdshm_dpam_id , cdshm_isin , cdshm_trans_no

--SELECT * FROM #finaldmatpen WHERE DPHMCD_ISIN  = 'INE680B01019' AND DPHMCD_DPAM_ID=549859
--SELECT * FROM #finaldmatcnfrej WHERE CDSHM_DPAM_ID = 549859 AND CDSHM_ISIN ='INE680B01019'

--516841	INE115A01026

--DROP TABLE #FINALDEMATHOLDI

INSERT INTO  #FINALREMTHOLDI
SELECT a.*,A.QTY-abs(isnull(b.qty,0)) RMATPENDING 
 from #finaldmatpen a left outer join #finaldmatcnfrej b
on cdshm_dpam_id = dphmcd_dpam_id 
and cdshm_isin = dphmcd_isin 
and cdshm_trans_no = trans_no

--INSERT INTO  #FINALREMTHOLDI
--exec citrus_usr.pr_getrmtcnfpnd @pa_dpm_id ,@pa_from_dt , @pa_to_dt,@pa_ben_acct_no_fr ,@pa_ben_acct_no_to ,'' ,''



DROP TABLE #holdingdmtpenfing 
DROP TABLE #trasdmtpenfing  
DROP TABLE #tras 
DROP TABLE #trasdmtcnfrej 
DROP TABLE #finaldmatcnfrej 






update a      
SET a.DPHMCD_REMAT_PND_CONF_QTY  = case when A.DPHMCD_CURR_QTY <> 0  then RMATPENDING else 0 END   
--, a.DPHMCD_FREE_QTY  = a.DPHMCD_FREE_QTY - case when A.DPHMCD_CURR_QTY = a.DPHMCD_FREE_QTY and a.DPHMCD_FREE_QTY >= RMATPENDING  then RMATPENDING else 0 END   
from #tmp_dp_daily_hldg_cdsl   a , #FINALREMTHOLDI f    
where a.dphmcd_dpam_id= f.dphmcd_dpam_id     
and a.dphmcd_isin = f.dphmcd_isin 
and RMATPENDING <> 0 

/*remat calculation */

 /*demat calculation */

create table #FINALDEMATHOLDI
(DPHMCD_DPAM_ID NUMERIC,DPHMCD_ISIN VARCHAR(50),trans_no VARCHAR(100),qty NUMERIC(18,5),DMATPENDING NUMERIC(18,5))


SELECT dphmcd_dpam_id,dphmcd_isin ,sum(DPHMCD_DEMAT_PND_VER_QTY) qty ,'' trans_no  
into #holdingdmtpenfing1 from  #vw_holding_base_all_tmp with (nolock) , #dp_acct_mstr_tmp with (nolock), #CLIENTLIST
where DPHMCD_DPAM_ID = DPAM_ID AND dphmcd_holding_dt=@l_base_hldg_dt
--and dpam_sba_no between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and dpam_sba_no = sbano
and dphmcd_dpm_id = @PA_DPM_ID

group by dphmcd_dpam_id,dphmcd_isin 
having sum(DPHMCD_DEMAT_PND_VER_QTY) <> 0 
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)

SELECT cdshm_dpam_id , cdshm_isin , sum(cdshm_qty  ) qty ,cdshm_trans_no into #trasdmtpenfing1  from #cdsl_holding_dtls_tmp with (nolock), #CLIENTLIST
where CDSHM_TRATM_CD in ('2201')
and cdshm_ben_acct_no = sbano
--and CDSHM_BEN_ACCT_NO between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and CDSHM_DPM_ID = @PA_DPM_ID

And cdshm_tras_dt between @l_min_trx_dt and @PA_TO_DT
group by cdshm_dpam_id,cdshm_isin,cdshm_trans_no
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)


SELECT * 
into #tras1 
from #cdsl_holding_dtls_tmp with (nolock), #CLIENTLIST
WHERE (CDSHM_TRATM_CD in ('2246','3102')
or cdshm_tratm_cd ='2251' and  CDSHM_CDAS_SUB_TRAS_TYPE IN ('607','609'))
--and CDSHM_BEN_ACCT_NO between @pa_ben_acct_no_fr and @pa_ben_acct_no_to    
and CDSHM_DPM_ID = @PA_DPM_ID
and cdshm_ben_acct_no = sbano

and (CDSHM_CDAS_TRAS_TYPE IN ('32','6'))
and cdshm_tras_dt between @l_min_trx_dt and @PA_TO_DT
and (cdshm_trans_no in (SELECT DISTINCT cdshm_trans_no from #trasdmtpenfing1 B )
	OR EXISTS(SELECT DPHMCD_DPAM_ID,DPHMCD_ISIN FROM #holdingdmtpenfing1 WHERE DPHMCD_DPAM_ID = CDSHM_DPAM_ID 
AND DPHMCD_ISIN = CDSHM_ISIN ))

PRINT CONVERT(VARCHAR(26), GETDATE(), 109)




SELECT CDSHM_TRATM_CD,cdshm_dpam_id , cdshm_isin , cdshm_trans_no,sum(case when  CDSHM_TRATM_CD = '3102' then cdshm_qty*-1
															when  CDSHM_TRATM_CD = '2251' then cdshm_qty*-1 else cdshm_qty END ) cdshm_qty
into #trasdmtcnfrej1 from #tras1 A 
group by cdshm_dpam_id,cdshm_isin,cdshm_trans_no, cdshm_tratm_cd
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)

update tras1 SET cdshm_trans_no =''
from #trasdmtpenfing1 tras1
where exists(SELECT dphmcd_dpam_id , dphmcd_isin from #holdingdmtpenfing1 where dphmcd_dpam_id = cdshm_dpam_id and dphmcd_isin = cdshm_isin )
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)

update trascnfrej1 SET cdshm_trans_no =''
from #trasdmtcnfrej1 trascnfrej1
where exists(SELECT dphmcd_dpam_id , dphmcd_isin from #holdingdmtpenfing1 where dphmcd_dpam_id = cdshm_dpam_id and dphmcd_isin = cdshm_isin )
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)

SELECT dphmcd_dpam_id,dphmcd_isin,trans_no,sum(qty) qty into #finaldmatpen1 from (
SELECT dphmcd_dpam_id,dphmcd_isin,qty,trans_no from #holdingdmtpenfing1
union ALL
SELECT cdshm_dpam_id , cdshm_isin,qty,cdshm_trans_no from #trasdmtpenfing1) a 
group by dphmcd_dpam_id,dphmcd_isin,trans_no
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)

SELECT cdshm_dpam_id , cdshm_isin , cdshm_trans_no ,sum(cdshm_qty) qty 
into #finaldmatcnfrej1 from #trasdmtcnfrej1 
group by cdshm_dpam_id , cdshm_isin , cdshm_trans_no
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)
--SELECT * FROM #finaldmatpen WHERE DPHMCD_ISIN  = 'INE680B01019' AND DPHMCD_DPAM_ID=549859
--SELECT * FROM #finaldmatcnfrej WHERE CDSHM_DPAM_ID = 549859 AND CDSHM_ISIN ='INE680B01019'

--516841	INE115A01026

--DROP TABLE #FINALDEMATHOLDI
INSERT INTO  #FINALDEMATHOLDI
SELECT a.*,CASE WHEN CDSHM_ISIN LIKE 'INF%' THEN '0' ELSE A.QTY-isnull(b.qty,0) END DMATPENDING 
from #finaldmatpen1 a left outer join #finaldmatcnfrej1 b
on cdshm_dpam_id = dphmcd_dpam_id 
and cdshm_isin = dphmcd_isin 
and cdshm_trans_no = trans_no
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)


DROP TABLE #holdingdmtpenfing1 
DROP TABLE #trasdmtpenfing1 
DROP TABLE #tras1 
DROP TABLE #trasdmtcnfrej1 
DROP TABLE #finaldmatcnfrej1 
--INSERT INTO  #FINALDEMATHOLDI
--exec citrus_usr.pr_getdmacnfpnd @pa_dpm_id ,@pa_from_dt , @pa_to_dt,@pa_ben_acct_no_fr ,@pa_ben_acct_no_to ,'' ,''


SELECT DPHMCD_DPAM_ID , DPHMCD_ISIN , SUM(DMATPENDING) pVERQTY INTO  #pVERQTY
FROM #FINALDEMATHOLDI 
WHERE NOT EXISTS(SELECT 1 FROM #cdsl_holding_dtls_tmp with (nolock) , #CLIENTLIST WHERE cdshm_ben_acct_no = sbano and CDSHM_DPAM_ID = DPHMCD_DPAM_ID AND DPHMCD_ISIN = CDSHM_ISIN 
AND CDSHM_TRAS_DT < =@PA_TO_DT AND CDSHM_TRATM_cD = '2202' AND CDSHM_TRANS_NO = TRANS_NO)
AND DMATPENDING <> 0
GROUP BY  DPHMCD_DPAM_ID , DPHMCD_ISIN
HAVING SUM(DMATPENDING) <> 0

update a      
SET a.DPHMCD_DEMAT_PND_VER_QTY  = pVERQTY   
from #tmp_dp_daily_hldg_cdsl   a , #pVERQTY f    
where a.dphmcd_dpam_id= f.dphmcd_dpam_id     
and a.dphmcd_isin = f.dphmcd_isin 



SELECT DPHMCD_DPAM_ID , DPHMCD_ISIN , SUM(DMATPENDING) pCONVERQTY INTO  #pCONVERQTY
FROM #FINALDEMATHOLDI 
WHERE EXISTS(SELECT 1 FROM #cdsl_holding_dtls_tmp with (nolock) , #CLIENTLIST WHERE cdshm_ben_acct_no = sbano and  CDSHM_DPAM_ID = DPHMCD_DPAM_ID AND DPHMCD_ISIN = CDSHM_ISIN 
AND CDSHM_TRAS_DT < =@PA_TO_DT AND CDSHM_TRATM_cD = '2202' AND CDSHM_TRANS_NO = TRANS_NO)
AND DMATPENDING <> 0
GROUP BY  DPHMCD_DPAM_ID , DPHMCD_ISIN
HAVING SUM(DMATPENDING) <> 0

update a      
SET a.DPHMCD_DEMAT_PND_CONF_QTY  = pCONVERQTY   
from #tmp_dp_daily_hldg_cdsl   a , #pCONVERQTY f    
where a.dphmcd_dpam_id= f.dphmcd_dpam_id     
and a.dphmcd_isin = f.dphmcd_isin 



 /*demat calculation */


/*PLEDGE QTY*/


 --593918	INE749A01030
SELECT dphmcd_dpam_id,dphmcd_isin ,sum(DPHMCD_PLEDGE_QTY) QTY 
into #holdingdmtpenfing2 from  #vw_holding_base_all_tmp with (nolock), #dp_acct_mstr_tmp with (nolock), #CLIENTLIST
where DPHMCD_DPAM_ID = DPAM_ID AND dphmcd_holding_dt=@l_base_hldg_dt
and dpam_sba_no = sbano
group by dphmcd_dpam_id,dphmcd_isin 
having sum(DPHMCD_PLEDGE_QTY) <> 0 
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)



SELECT cdshm_dpam_id  ,cdshm_isin 
,case when cdshm_tratm_cd in ('2230','2246') and cdshm_tratm_type_desc = 'PLEDGE' then cdshm_qty 
when cdshm_tratm_cd in ('2280') and cdshm_tratm_type_desc in ('UNPLEDGE','CONFISCATE','AUTO PLEDGE','PLEDGE') then cdshm_qty else 0 END QTY                    
                  
INTO #TEMPDATA2 from   #cdsl_holding_dtls_tmp                     with (nolock), #CLIENTLIST
where cdshm_tratm_cd in ('2246','2277','2201','2230','5101','2280')   
and cdshm_tras_dt between @l_min_trx_dt and @PA_TO_DT
and cdshm_ben_acct_no = sbano
and cdshm_tratm_type_desc in ('UNPLEDGE','CONFISCATE','AUTO PLEDGE','PLEDGE')

SELECT cdshm_dpam_id , cdshm_isin , sum(QTY) qty into #trasdmtpenfing2  from #TEMPDATA2
group by cdshm_dpam_id,cdshm_isin

PRINT CONVERT(VARCHAR(26), GETDATE(), 109)


SELECT dphmcd_dpam_id,dphmcd_isin,sum(qty) qty into #finaldmatpen2 from (
SELECT dphmcd_dpam_id,dphmcd_isin,qty from #holdingdmtpenfing2
union ALL
SELECT cdshm_dpam_id , cdshm_isin,qty from #trasdmtpenfing2) a 
group by dphmcd_dpam_id,dphmcd_isin
PRINT CONVERT(VARCHAR(26), GETDATE(), 109)





update a      
SET a.DPHMCD_PLEDGE_QTY  = case when QTY >= 0 then QTY       else 0 END   
from #tmp_dp_daily_hldg_cdsl   a , #finaldmatpen2 f    
where a.dphmcd_dpam_id= f.dphmcd_dpam_id     
and a.dphmcd_isin = f.dphmcd_isin 


DROP TABLE #holdingdmtpenfing2 
DROP TABLE #trasdmtpenfing2 
DROP TABLE #finaldmatpen2 
DROP TABLE #TEMPDATA2




/*PLEDGE QTY*/

--update a SET DPHMCD_LOCKIN_QTY  = DPHMCD_LOCKIN_QTY - isnull(DPHMCD_REMAT_PND_CONF_QTY ,0)
--from   #tmp_dp_daily_hldg_cdsl   a
--where DPHMCD_LOCKIN_QTY <> 0 
--and   DPHMCD_REMAT_PND_CONF_QTY <> 0 
--


SELECT CDSHM_DPAM_ID , CDSHM_ISIN , SUM(CDSHM_QTY) QTY into #locindata_cr FROM #cdsl_holding_dtls_tmp with (nolock), #CLIENTLIST WHERE 
CDSHM_TRATM_cD IN ('2212','2211')
and CDSHM_TRAS_DT between  @l_min_trx_dt and @pa_to_dt
AND CDSHM_CDAS_TRAS_TYPE IN ('12','20','21','22','23')  -- 20 added by tushar on jul 16 2012
and cdshm_ben_acct_no = sbano
GROUP BY CDSHM_DPAM_ID ,  CDSHM_ISIN 

update a SET DPHMCD_LOCKIN_QTY = qty from #locindata_cr , #tmp_dp_daily_hldg_cdsl  a
where dphmcd_dpam_id = cdshm_dpam_id 
and dphmcd_isin = cdshm_isin 

--SELECT CDSHM_DPAM_ID , CDSHM_ISIN , SUM(CDSHM_QTY) QTY into #locindata_dr FROM dmat_archival.citrus_usr.cdsl_holding_dtls 
--WHERE CDSHM_TRATM_cD =case when CDSHM_CDAS_TRAS_TYPE IN ('21','22','23') then '2262' else '2277' END 
--and CDSHM_TRAS_DT between  @l_min_trx_dt and @pa_to_dt
--AND CDSHM_CDAS_TRAS_TYPE IN ('21','22','23','7')
--GROUP BY CDSHM_DPAM_ID ,  CDSHM_ISIN 


SELECT CDSHM_DPAM_ID , CDSHM_ISIN , SUM(CDSHM_QTY) QTY into #locindata_dr FROM #cdsl_holding_dtls_tmp with (nolock), #CLIENTLIST
WHERE CDSHM_TRATM_cD  in( '2262','2261') --=case when CDSHM_CDAS_TRAS_TYPE IN ('21','22','23') then '2262' else '2277' END 
and CDSHM_TRAS_DT between  @l_min_trx_dt and @pa_to_dt
and cdshm_ben_acct_no = sbano
AND CDSHM_CDAS_TRAS_TYPE IN ('21','22','23','12')
GROUP BY CDSHM_DPAM_ID ,  CDSHM_ISIN 

update a SET DPHMCD_LOCKIN_QTY = DPHMCD_LOCKIN_QTY + qty from #locindata_dr , #tmp_dp_daily_hldg_cdsl  a
where dphmcd_dpam_id = cdshm_dpam_id 
and dphmcd_isin = cdshm_isin 
and  DPHMCD_LOCKIN_QTY <> 0 

--lockin remat

SELECT CDSHM_DPAM_ID , CDSHM_ISIN , SUM(CDSHM_QTY) QTY into #locindata_dr_remat FROM #cdsl_holding_dtls_tmp with (nolock), #CLIENTLIST 
WHERE CDSHM_TRATM_cD  = '2262' --=case when CDSHM_CDAS_TRAS_TYPE IN ('21','22','23') then '2262' else '2277' END 
and CDSHM_TRAS_DT between  @l_min_trx_dt and @pa_to_dt
AND CDSHM_CDAS_TRAS_TYPE = '7'
and CDSHM_CDAS_SUB_TRAS_TYPE = '707'
and sbano = cdshm_ben_acct_no
GROUP BY CDSHM_DPAM_ID ,  CDSHM_ISIN 

update a SET DPHMCD_LOCKIN_QTY = DPHMCD_LOCKIN_QTY + qty from #locindata_dr_remat , #tmp_dp_daily_hldg_cdsl  a
where dphmcd_dpam_id = cdshm_dpam_id 
and dphmcd_isin = cdshm_isin 
and  DPHMCD_LOCKIN_QTY <> 0 


--lockin remat

--lockin remat cr

SELECT CDSHM_DPAM_ID , CDSHM_ISIN , SUM(CDSHM_QTY) QTY into #locindata_dr_remat_cr FROM #cdsl_holding_dtls_tmp with (nolock), #CLIENTLIST
WHERE CDSHM_TRATM_cD  = '2262' --=case when CDSHM_CDAS_TRAS_TYPE IN ('21','22','23') then '2262' else '2277' END 
and CDSHM_TRAS_DT between  @l_min_trx_dt and @pa_to_dt
AND CDSHM_CDAS_TRAS_TYPE = '33'
and cdshm_ben_acct_no = sbano
and CDSHM_CDAS_SUB_TRAS_TYPE = '3304'
GROUP BY CDSHM_DPAM_ID ,  CDSHM_ISIN 

update a SET DPHMCD_LOCKIN_QTY = DPHMCD_LOCKIN_QTY + qty from #locindata_dr_remat_cr , #tmp_dp_daily_hldg_cdsl  a
where dphmcd_dpam_id = cdshm_dpam_id 
and dphmcd_isin = cdshm_isin 
and  DPHMCD_LOCKIN_QTY <> 0  and DPHMCD_CURR_QTY=0
and DPHMCD_FREE_QTY=0


--lockin remat cr

--avail lending

SELECT CDSHM_DPAM_ID , CDSHM_ISIN , SUM(CDSHM_QTY) QTY into #availlenddata FROM #cdsl_holding_dtls_tmp with (nolock), #CLIENTLIST
WHERE CDSHM_TRATM_cD  = '2270' 
and CDSHM_TRAS_DT between  @l_min_trx_dt and @pa_to_dt
and cdshm_ben_acct_no = sbano
AND CDSHM_CDAS_TRAS_TYPE = '8'
and CDSHM_CDAS_SUB_TRAS_TYPE = '816' 
GROUP BY CDSHM_DPAM_ID ,  CDSHM_ISIN

update a SET DPHMCD_AVAIL_LEND_QTY = DPHMCD_AVAIL_LEND_QTY - qty from #availlenddata , #tmp_dp_daily_hldg_cdsl  a
where dphmcd_dpam_id = cdshm_dpam_id 
and dphmcd_isin = cdshm_isin 
and  DPHMCD_AVAIL_LEND_QTY <> 0 and DPHMCD_CURR_QTY=0
and DPHMCD_FREE_QTY=0

--avail lending
    
--update a SET DPHMCD_FREE_QTY  = dphmcd_curr_qty - isnull(DPHMCD_REMAT_PND_CONF_QTY ,0) - isnull(DPHMCD_LOCKIN_QTY ,0)
--from   #tmp_dp_daily_hldg_cdsl   a
--where dphmcd_curr_qty <>0 

update a SET DPHMCD_FREE_QTY  = dphmcd_curr_qty - isnull(DPHMCD_REMAT_PND_CONF_QTY ,0) - isnull(DPHMCD_LOCKIN_QTY ,0) - ISNULL(DPHMCD_PLEDGE_QTY,'0') - ISNULL(DPHMCD_avail_lend_qty,'0') -ISNULL(DPHMCD_SAFE_KEEPING_QTY,'0') -ISNULL(DPHMCD_LEND_QTY,'0') - 
  
ISNULL(DPHMCD_BORROW_QTY,'0') - ISNULL(DPHMCD_EARMARK_QTY,'0')    
from   #tmp_dp_daily_hldg_cdsl   a    
where dphmcd_curr_qty <>0     



update a SET DPHMCD_FREE_QTY  = dphmcd_curr_qty 
from   #tmp_dp_daily_hldg_cdsl   a    
where dphmcd_curr_qty <>0     
and DPHMCD_FREEZE_QTY=0
and DPHMCD_PLEDGE_QTY=0
and DPHMCD_DEMAT_PND_VER_QTY=0
and DPHMCD_REMAT_PND_CONF_QTY=0
and DPHMCD_DEMAT_PND_CONF_QTY=0
and DPHMCD_SAFE_KEEPING_QTY=0
and DPHMCD_LOCKIN_QTY=0
and DPHMCD_ELIMINATION_QTY=0
and DPHMCD_EARMARK_QTY=0
and DPHMCD_AVAIL_LEND_QTY=0
and DPHMCD_LEND_QTY=0
and DPHMCD_BORROW_QTY=0

/**/   
    
    
update A 
SET DPHMCD_REMAT_PND_CONF_QTY  = 0   
from   #tmp_dp_daily_hldg_cdsl   a  

SELECT *,
@pa_to_dt dphmcd_holding_dt 
into #holdingall 
from #tmp_dp_daily_hldg_cdsl     
where     
(dphmcd_curr_qty <> '0'                        
or DPHMCD_FREE_QTY <> '0'                        
or DPHMCD_FREEZE_QTY <> '0'                        
or DPHMCD_PLEDGE_QTY  <> '0'                        
or DPHMCD_DEMAT_PND_VER_QTY  <> '0'                        
or DPHMCD_REMAT_PND_CONF_QTY  <> '0'                        
or DPHMCD_DEMAT_PND_CONF_QTY  <> '0'                        
or DPHMCD_SAFE_KEEPING_QTY  <> '0'                        
or DPHMCD_LOCKIN_QTY <> '0'                        
or DPHMCD_ELIMINATION_QTY  <>  '0'                        
or DPHMCD_EARMARK_QTY  <> '0'                        
or DPHMCD_AVAIL_LEND_QTY  <> '0'                        
or DPHMCD_LEND_QTY  <> '0'                        
or DPHMCD_BORROW_QTY  <> '0') 

SELECT * from #holdingall

drop table #holdingall 


      
END

GO
