-- Object: PROCEDURE citrus_usr.holding_valuation
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create proc holding_valuation 
as
begin 
select max(clopm_dt) dt ,clopm_isin_cd isin_cd into #tempdata from closing_price_mstr_nsdl where clopm_dt <=  getdate() group by clopm_isin_cd 
create index ix_1 on  #tempdata(isin_Cd,dt)

select dpam_id , dpam_sba_no,dpdhm_isin,dpdhm_qty,dpdhm_holding_dt,CLOPM_NSDL_RT,CLOPM_DT 
from dp_hldg_mstr_nsdl left outer join #tempdata
on isin_cd = dpdhm_isin 
left outer join closing_price_mstr_nsdl on clopm_isin_Cd = isin_Cd and clopm_dt = dt 
,dp_acct_mstr 
where dpam_id = dpdhm_dpam_id --and dpam_sba_no ='10772223'
and dpdhm_qty > 0 



select dpam_sba_no,sum(dpdhm_qty*CLOPM_NSDL_RT)
from dp_hldg_mstr_nsdl left outer join #tempdata
on isin_cd = dpdhm_isin 
left outer join closing_price_mstr_nsdl on clopm_isin_Cd = isin_Cd and clopm_dt = dt 
,dp_acct_mstr 
where dpam_id = dpdhm_dpam_id
and dpdhm_qty > 0 
group by dpam_sba_no
order by sum(dpdhm_qty*CLOPM_NSDL_RT)

end

GO
