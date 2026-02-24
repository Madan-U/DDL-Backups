-- Object: PROCEDURE citrus_usr.PR_BSDA_STATUS_bAK_30112015
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------




CREATE   procedure [citrus_usr].[PR_BSDA_STATUS_bAK_30112015]
(
@PA_DPM_ID INT
,@PA_FROM_ACC VARCHAR(16)
,@PA_TO_ACC VARCHAR(16)
,@PA_EFF_DATE DATETIME
,@pa_profile_type varchar(20)
)
AS
BEGIN

   

select BOID 
,dpam_sba_name [Client_name] 
,convert(numeric(18,2),sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0)))) [Holding_Valuation]
,dpam_bbo_code [BBOcode]
,a.brom_desc [Current_tariff] 
--,a.brom_desc [Tariff_to_be_changed]
,case when  a.brom_desc LIKE '%LIF%' then a.brom_desc 
when  a.brom_desc LIKE '%ZERO%' then a.brom_desc 
when sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0))) <'50000' then 'BSDA' 
when sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0))) BETWEEN '50001' AND '200000' then 'BSDA1' 
when sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0))) > '200001' then '1'
END [Tariff_to_be_changed]
,case when  a.brom_desc LIKE '%LIF%' then 'LIFE' 
when  a.brom_desc LIKE '%ZERO%' then 'LIFE'
when sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0))) <'50000' then 'NEED TO CHANGE BSDA' 
when sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0))) BETWEEN '50001' AND '200000' then 'NEED TO CHANGE BSDA1' 
when sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0))) > '200001' then 'NEED TO DEACTIVE BSDA'
END [REMARKS],a.BROM_ID
from dps8_pc1
,DP_ACCT_MSTR 
left outer join client_dp_brkg on CLIDB_DPAM_ID = DPAM_ID and GETDATE() between clidb_eff_from_dt and isnull(clidb_eff_to_dt ,'dec 31 2100')
left outer join brokerage_mstr a on a.brom_id = CLIDB_BROM_ID 
left outer join holdingallforview on DPHMCD_DPAM_ID = DPAM_ID 
where Filler9 ='Y'
and BOId = DPAM_SBA_NO AND DPAM_STAM_CD = 'ACTIVE' 
group by BOID,dpam_sba_name,dpam_bbo_code,brom_desc,BROM_ID
HAVING a.brom_desc <> case when  a.brom_desc LIKE '%LIF%' then a.brom_desc 
when  a.brom_desc LIKE '%ZERO%' then a.brom_desc 
when sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0))) <'50000' then 'BSDA' 
when sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0))) BETWEEN '50001' AND '200000' then 'BSDA1' 
when sum((isnull(RATE,0)*isnull(DPHMCD_FREE_QTY,0))) > '200001' then '1' 
END 
order by 1 

END

GO
