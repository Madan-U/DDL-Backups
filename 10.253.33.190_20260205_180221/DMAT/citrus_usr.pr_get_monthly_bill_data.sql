-- Object: PROCEDURE citrus_usr.pr_get_monthly_bill_data
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--exec pr_get_monthly_bill_data '',''
CREATE proc [citrus_usr].[pr_get_monthly_bill_data](@pa_from_dt datetime,@pa_to_dt datetime)
as
begin 

SET @pa_from_dt = CONVERT(VARCHAR(11),DATEADD(dd,-(DAY(getdate()-10)-1),getdate()-10),109)
SET @pa_to_dt   = CONVERT(VARCHAR(11),DATEADD(dd,-(DAY(DATEADD(mm,1,getdate()-10))),DATEADD(mm,1,getdate()-10)),109) 

truncate table monthlybilldata

insert into monthlybilldata
select dpam_sba_no dpcode, 
CONVERT(VARCHAR(8),convert(datetime,@pa_to_dt,109), 112) date,
'' ref,
CONVERT(VARCHAR(8),convert(datetime,@pa_from_dt,109), 112) [from date],
CONVERT(VARCHAR(8),convert(datetime,@pa_to_dt,109), 112) [to date],
abs(sum(clic_charge_amt)) amount,
CONVERT(VARCHAR(8),convert(datetime,@pa_to_dt,109), 112) [holdingdate]
--into monthlybilldata
from client_charges_cdsl,dp_acct_mstr
where clic_dpam_id = dpam_id 
and clic_flg <> 'B'
and clic_trans_dt between @pa_from_dt and @pa_to_dt
and clic_deleted_ind = 1 
group by dpam_sba_no 




end

GO
