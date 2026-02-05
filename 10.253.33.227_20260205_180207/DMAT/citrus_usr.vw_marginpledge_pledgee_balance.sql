-- Object: VIEW citrus_usr.vw_marginpledge_pledgee_balance
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create view citrus_usr.vw_marginpledge_pledgee_balance
as
SELECT ''''+DPAM_SBA_NO BOID
,DPAM_SBA_NAME [CLIENT NAME]
,DPAM_BBO_CODE [BBO CODE]
,dphmcd_isin ISIN
,ISIN_NAME [ISIN NAME]
,sum(qty) MARGIN_PLEDGE
,sum(0) PLEDGEE_BAL FROM (
select dphmcd_dpam_id,dphmcd_isin,sum(qty) qty ,PLEDGETYPE, PLEDGEE   from (
select dphmcd_dpam_id,dphmcd_isin ,sum(DPHMCD_PLEDGE_QTY) QTY  ,'NORMAL' PLEDGETYPE,'' PLEDGEE from  vw_holding_base_all with (nolock), DP_aCCT_MSTR with (nolock)where DPHMCD_DPAM_ID = DPAM_ID AND dphmcd_holding_dt=( SELECT max(dphmcd_holding_dt) from vw_holding_base_all)
group by dphmcd_dpam_id,dphmcd_isin having sum(DPHMCD_PLEDGE_QTY) <> 0
union all

select cdshm_dpam_id , cdshm_isin , sum(QTY) qty ,PLEDGETYPE , PLEDGEE
from (select cdshm_dpam_id  ,cdshm_isin
,case when cdshm_tratm_cd in ('2230','2246') and cdshm_tratm_type_desc = 'PLEDGE' then cdshm_qty
when cdshm_tratm_cd in ('2280') and cdshm_tratm_type_desc in ('UNPLEDGE','CONFISCATE','AUTO PLEDGE','PLEDGE') then cdshm_qty else 0 end QTY                    
     ,  CASE WHEN  CDSHM_CDAS_SUB_TRAS_TYPE BETWEEN 828 AND 838 THEN 'MARGIN' ELSE  'NORMAL'  END PLEDGETYPE  
     ,           CASE WHEN  CDSHM_CDAS_SUB_TRAS_TYPE BETWEEN 828 AND 838 THEN CDSHM_COUNTER_BOID ELSE  ''  END PLEDGEE
from   cdsl_holding_dtls                     with (nolock)
where -- CDSHM_BEN_ACCT_NO  BETWEEN @pa_ben_acct_no_fr AND @pa_ben_acct_no_to  AND
cdshm_tratm_cd in ('2246','2277','2201','2230','5101','2280')  
and cdshm_tras_dt between (SELECT  min(curr_fr_dt) from archival_details ) and GETDATE()
and cdshm_tratm_type_desc in ('UNPLEDGE','CONFISCATE','AUTO PLEDGE','PLEDGE')
) a
group by  cdshm_dpam_id,cdshm_isin,PLEDGETYPE, PLEDGEE
) aa
where PLEDGETYPE  ='margin'
group by dphmcd_dpam_id,dphmcd_isin,PLEDGETYPE, PLEDGEE
) aaa
LEFT OUTER JOIN ISIN_MSTR ON dphmcd_isin = ISIN_CD , DP_ACCT_MSTR WHERE DPAM_ID = DPHMCD_DPAM_ID AND QTY > 0  and PLEDGETYPE ='margin'
GROUP BY DPAM_SBA_NO
,DPAM_SBA_NAME
,DPAM_BBO_CODE
,dphmcd_isin
,ISIN_NAME
UNION ALL
SELECT ''''+DPAM_SBA_NO BOID
,DPAM_SBA_NAME   [CLIENT NAME]
,DPAM_BBO_CODE [BBO CODE]
,dphmcd_isin  ISIN
,ISIN_NAME [ISIN NAME]
,sum(0) MARGIN_PLEDGE
,sum(qty) PLEDGEE_BAL  from (




select dphmcd_dpam_id,dphmcd_isin,sum(qty) qty ,PLEDGETYPE, PLEDGEE   from (
select dphmcd_dpam_id,dphmcd_isin ,sum(DPHMCD_PLEDGE_QTY) QTY  ,'NORMAL' PLEDGETYPE,'' PLEDGEE from  vw_holding_base_all with (nolock), DP_aCCT_MSTR with (nolock)where DPHMCD_DPAM_ID = DPAM_ID AND dphmcd_holding_dt=( SELECT max(dphmcd_holding_dt) from vw_holding_base_all)
group by dphmcd_dpam_id,dphmcd_isin having sum(DPHMCD_PLEDGE_QTY) <> 0
union all

select cdshm_dpam_id , cdshm_isin , sum(QTY) qty ,PLEDGETYPE , PLEDGEE
from (select cdshm_dpam_id  ,cdshm_isin
,case when cdshm_tratm_cd in ('2230','2246') and cdshm_tratm_type_desc = 'PLEDGE' then cdshm_qty
when cdshm_tratm_cd in ('2280') and cdshm_tratm_type_desc in ('UNPLEDGE','CONFISCATE','AUTO PLEDGE','PLEDGE') then cdshm_qty else 0 end QTY                    
     ,  CASE WHEN  CDSHM_CDAS_SUB_TRAS_TYPE BETWEEN 828 AND 838 THEN 'MARGIN' ELSE  'NORMAL'  END PLEDGETYPE  
     ,           CASE WHEN  CDSHM_CDAS_SUB_TRAS_TYPE BETWEEN 828 AND 838 THEN CDSHM_COUNTER_BOID ELSE  ''  END PLEDGEE
from   cdsl_holding_dtls                     with (nolock)
where -- CDSHM_BEN_ACCT_NO  BETWEEN @pa_ben_acct_no_fr AND @pa_ben_acct_no_to  AND
cdshm_tratm_cd in ('2246','2277','2201','2230','5101','2280')  
and cdshm_tras_dt between (SELECT  min(curr_fr_dt) from archival_details ) and GETDATE()
and cdshm_tratm_type_desc in ('UNPLEDGE','CONFISCATE','AUTO PLEDGE','PLEDGE')
) a
group by  cdshm_dpam_id,cdshm_isin,PLEDGETYPE, PLEDGEE
) aa
where PLEDGETYPE  ='margin'
group by dphmcd_dpam_id,dphmcd_isin,PLEDGETYPE, PLEDGEE
)bbb LEFT OUTER JOIN ISIN_MSTR ON dphmcd_isin = ISIN_CD , DP_ACCT_MSTR WHERE DPAM_SBA_NO = PLEDGEE AND QTY > 0  and PLEDGETYPE ='margin'
GROUP BY DPAM_SBA_NO
,DPAM_SBA_NAME
,DPAM_BBO_CODE
,dphmcd_isin
,ISIN_NAME

GO
