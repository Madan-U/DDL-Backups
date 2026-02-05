-- Object: PROCEDURE dbo.SP_try
-- Server: 10.253.78.187 | DB: inhouse
--------------------------------------------------

create proc SP_try

as 
begin

select * into  #temp1
from (
select
isnull(DPAM_bbo_code,'') as party_code,
dpam_sba_no as Cltdpid,
'' as PrevScheme,
BROM_DESC as NewScheme,
clidb_eff_from_dt as UpdDate
FROM DMAT.citrus_usr.CLIENT_DP_BRKG B,
DMAT.citrus_usr.DP_ACCT_MSTR D,
DMAT.citrus_usr.BROKERAGE_MSTR C
WHERE clidb_eff_FROM_dt >='2015-10-01'  
AND CLIDB_BROM_ID =BROM_ID 
AND BROM_DESC LIKE '%LIF%'  
AND CLIDB_DPAM_ID =DPAM_ID
)a


select client_code,max(bill_date) as cm_lastbill into #temp2
from dbo.Vw_Bill_Transaction with (nolock)
where client_code in (select cltdpid from #temp1) group by client_code


select a.*,isnull(cm_lastbill,'1900-01-01 00:00:00.000')cm_lastbill from #temp1 a
left outer join
#temp2 b on a.cltdpid =client_code
and client_code like '1203%'

end

GO
