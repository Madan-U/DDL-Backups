-- Object: PROCEDURE citrus_usr.pr_get_gst_mismatch
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create proc pr_get_gst_mismatch (@pa_from_dt datetime,@pa_to_date datetime)
as
begin 

select clic_dpam_id main_dpam_id , sum(clic_charge_amt) chargeamt into #maindata from client_charges_cdsl where clic_charge_name not like '%GST%'
and clic_charge_name not in ('SERVICE TAX','SWACHH BHARAT CESS','1_POAFIXED','ANGEL CLASSIC_POAFIXED','ANGEL ELITE_POAFIXED'
,'ANGEL PREFERRED_POA_','ANGEL PREMIER_POA','B2B INV_POAFIXED','BSDA_POAFIXED','INV CORP_POAFIXED','JK INV_POAFIXED'
,'LIF1250_POAFIXED','LIF1250C_POAFIXED','LIF1250J_POAFIXED','LIF1250Q_POAFIXED','LIFE-INV_POAFIXED','TRADERS_POAFIXED','ZEROWAIVE_POAFIXED'
,'ZEROWAIVE1_POAFIXED','VERSON 2.5 NORMAL_POA','VERSON 2.5 LIFETIME_POA','VERSION 2.5 LIFETIMEPOA','NBFC INVW_POA')
and clic_trans_dt between @pa_from_dt and @pa_to_date
group by clic_dpam_id

select clic_dpam_id gst_dpam_id , sum(clic_charge_amt) gst into #gst from client_charges_cdsl where clic_charge_name like '%GST%'
and clic_charge_name not in ('SERVICE TAX','SWACHH BHARAT CESS','1_POAFIXED','ANGEL CLASSIC_POAFIXED','ANGEL ELITE_POAFIXED'
,'ANGEL PREFERRED_POA_','ANGEL PREMIER_POA','B2B INV_POAFIXED','BSDA_POAFIXED','INV CORP_POAFIXED','JK INV_POAFIXED'
,'LIF1250_POAFIXED','LIF1250C_POAFIXED','LIF1250J_POAFIXED','LIF1250Q_POAFIXED','LIFE-INV_POAFIXED','TRADERS_POAFIXED','ZEROWAIVE_POAFIXED'
,'ZEROWAIVE1_POAFIXED','VERSON 2.5 NORMAL_POA','VERSON 2.5 LIFETIME_POA','VERSION 2.5 LIFETIMEPOA','NBFC INVW_POA')
and clic_trans_dt between @pa_from_dt and @pa_to_date
group by clic_dpam_id

select *,chargeamt * 0.18 manualgst into #final from #maindata left outer join #gst on main_dpam_id = gst_dpam_id 

select * from #final where gst is null


end

GO
