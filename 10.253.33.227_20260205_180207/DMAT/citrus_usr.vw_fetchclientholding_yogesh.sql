-- Object: VIEW citrus_usr.vw_fetchclientholding_yogesh
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create view [citrus_usr].[vw_fetchclientholding_yogesh]                     
as  

select dphmcd_dpm_id ,dphmcd_dpam_id , dphmcd_isin                  
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
 ,dphmcd_cntr_settm_id     from (                  
select dphmcd_dpm_id ,dphmcd_dpam_id , dphmcd_isin                  
,DPHMCD_CURR_QTY
 ,DPHMCD_FREE_QTY
 ,DPHMCD_FREEZE_QTY
 ,DPHMCD_PLEDGE_QTY 
 ,case when not exists(select cdshm_dpam_id , cdshm_isin,CDSHM_TRAS_DT  from cdsl_holding_dtls 
    			   WHERE CDSHM_TRAS_DT   <= datevalu and cdshm_tratm_cd in ('2246','2277')  
	    		   AND ABS(CDSHM_QTY) = ABS(DPHMCD_DEMAT_PND_VER_QTY)  
		    	   and cdshm_dpam_id = dphmcd_dpam_id 
				   and  cdshm_isin  = dphmcd_isin 
				   and isnull(DPHMCD_DEMAT_PND_VER_QTY ,0)<>0 
				   and isnull(DPHMCD_FREE_QTY ,0)=0 
				   and isnull(dphmcd_curr_qty,0) = 0 )    then DPHMCD_DEMAT_PND_VER_QTY else 0 end  DPHMCD_DEMAT_PND_VER_QTY
 ,DPHMCD_REMAT_PND_CONF_QTY
 ,DPHMCD_DEMAT_PND_CONF_QTY
 ,DPHMCD_SAFE_KEEPING_QTY 
 ,DPHMCD_LOCKIN_QTY 
 ,DPHMCD_ELIMINATION_QTY
 ,DPHMCD_EARMARK_QTY
 ,DPHMCD_AVAIL_LEND_QTY
 ,DPHMCD_LEND_QTY
 ,DPHMCD_BORROW_QTY
 ,datevalu dphmcd_holding_dt                  
 ,'' dphmcd_cntr_settm_id                  
from (select cdshm_tras_dt,cdshm_dpam_id  dphmcd_dpam_id,cdshm_isin dphmcd_isin ,case when cdshm_tratm_cd in ('2246','2277') then cdshm_qty else 0 end  DPHMCD_CURR_QTY
,case when cdshm_tratm_cd in ('2246','2277') then cdshm_qty else 0 end  DPHMCD_FREE_QTY                    
,0 DPHMCD_FREEZE_QTY                    
,0 DPHMCD_PLEDGE_QTY                    
,case when cdshm_tratm_cd in ('2201') then cdshm_qty else 0 end  DPHMCD_DEMAT_PND_VER_QTY                    
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
,cdshm_dpm_id dphmcd_dpm_id                  
from   citrus_usr.cdsl_holding_dtls                     
where cdshm_tratm_cd in ('2246','2277','2201')          
and   CDSHM_TRAS_DT  >='aug 01 2011'          
union  all                 
select DPHMCd_HOLDING_DT, dphmcd_dpam_id ,dphmcd_isin,dphmcd_curr_qty                     
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
,'' dphmcd_cntr_settm_id  ,dphmcd_dpm_id                  
from citrus_usr.dp_daily_hldg_cdsl                  
where DPHMCd_HOLDING_DT ='jul 31 2011'
) a  , citrus_usr.l_datalist                    
where  cdshm_tras_dt <= datevalu   

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

GO
