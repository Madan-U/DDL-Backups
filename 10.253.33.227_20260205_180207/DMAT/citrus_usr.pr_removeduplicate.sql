-- Object: PROCEDURE citrus_usr.pr_removeduplicate
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


create proc pr_removeduplicate 
as
begin 
with cte as
(select *,row_number() over(partition by DPHMCD_DPM_ID
,DPHMCD_DPAM_ID
,DPHMCD_ISIN order by DPHMCD_DPM_ID
,DPHMCD_DPAM_ID
,DPHMCD_ISIN) row_no from tmp_dp_daily_hldg_cdsl1) 
delete  from cte where row_no>1
end

GO
