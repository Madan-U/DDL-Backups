-- Object: PROCEDURE citrus_usr.pr_get_quaterly_bill_data
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--exec pr_get_quaterly_bill_data 'MAY 01 2013','MAY 31 2013'
CREATE proc [citrus_usr].[pr_get_quaterly_bill_data](@pa_from_dt datetime,@pa_to_dt datetime)
as
begin 

SET @pa_from_dt = DATEADD(QQ, DATEDIFF(QQ,0,GETDATE()-10),0) 
SET @pa_to_dt   = DATEADD(s,-1,DATEADD(QQ, DATEDIFF(QQ,0,GETDATE()-10)+1,0)) 

truncate table quaterlybilldata

insert into quaterlybilldata
select dpam_sba_no dpcode, 
CONVERT(VARCHAR(8), dbo.ufn_GetLastDayOfMonth(clic_trans_dt), 112) date,
'' ref,
CONVERT(VARCHAR(8),citrus_usr.ufn_GetFirstDayOfMonth(clic_trans_dt), 112) [from date],
CONVERT(VARCHAR(8),dbo.ufn_GetLastDayOfMonth(clic_trans_dt), 112) [to date],
abs(sum(clic_charge_amt)) amount,
CONVERT(VARCHAR(8),convert(datetime,@pa_to_dt,109), 112) [holdingdate]
--into quaterlybilldata
from client_charges_cdsl with (nolock),dp_acct_mstr with (nolock)
where clic_dpam_id = dpam_id 
and clic_flg <> 'B'
and clic_trans_dt between @pa_from_dt and @pa_to_dt
and clic_deleted_ind = 1 
group by dpam_sba_no ,dbo.ufn_GetLastDayOfMonth(clic_trans_dt),citrus_usr.ufn_GetFirstDayOfMonth(clic_trans_dt)




end

GO
