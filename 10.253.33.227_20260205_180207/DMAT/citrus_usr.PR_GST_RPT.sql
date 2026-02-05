-- Object: PROCEDURE citrus_usr.PR_GST_RPT
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE  PROC [citrus_usr].[PR_GST_RPT](@pa_from_dt DATETIME, @pa_to_dt DATETIME    
,@pa_login_name varchar(100)    
)          
AS          
BEGIN  

select ''''+maincharge.dpam_sba_no DEMATACCTNO, maincharge.dpam_sba_name NAME,billamt*-1 AMOUNT,isnull(cgst,0)*-1 CGST,isnull(sgst,0 )*-1 SGST,isnull(igst  ,0 )*-1 IGST,''''+inv_no [INVOICE NO],SINGLELOC [BASE LOCATION] from (
select dpam_sba_no, dpam_sba_name ,sum(clic_charge_amt) billamt from client_charges_cdsl , dp_Acct_mstr 
where clic_trans_dt between @pa_from_dt and @pa_to_dt and clic_charge_name not like '%GST%'
and clic_dpam_id = dpam_id 
group by dpam_sba_no,dpam_sba_name
) maincharge left outer join VW_BASELOCATION_MSTR vw on vw.boid = maincharge.dpam_sba_no
left outer join bo_bill_inv_mapping inv on inv.boid = maincharge.dpam_sba_no and billmonth =month(@pa_from_dt)
and billyear = year(@pa_from_dt)
 left outer join 
(select dpam_sba_no,dpam_sba_name,sum(clic_charge_amt) sgst from client_charges_cdsl , dp_Acct_mstr 
where clic_trans_dt between @pa_from_dt and @pa_to_dt and clic_charge_name  like '%sGST%'
and clic_dpam_id = dpam_id 
group by dpam_sba_no,dpam_sba_name
)  sgst on maincharge.dpam_sba_no = sgst.dpam_sba_no 
left outer join 
(select dpam_sba_no,dpam_sba_name,sum(clic_charge_amt) cgst from client_charges_cdsl , dp_Acct_mstr 
where clic_trans_dt between @pa_from_dt and @pa_to_dt and clic_charge_name  like '%CGST%'
and clic_dpam_id = dpam_id 
group by dpam_sba_no,dpam_sba_name
)  Cgst on maincharge.dpam_sba_no = Cgst.dpam_sba_no 
left outer join 
(select dpam_sba_no,dpam_sba_name,sum(clic_charge_amt) igst from client_charges_cdsl , dp_Acct_mstr 
where clic_trans_dt between @pa_from_dt and @pa_to_dt and clic_charge_name  like '%IGST%'
and clic_dpam_id = dpam_id 
group by dpam_sba_no,dpam_sba_name
)  Igst on maincharge.dpam_sba_no = Igst.dpam_sba_no 
order by inv_no

END

GO
