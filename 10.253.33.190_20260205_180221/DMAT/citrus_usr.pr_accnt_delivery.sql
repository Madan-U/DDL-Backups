-- Object: PROCEDURE citrus_usr.pr_accnt_delivery
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--pr_accnt_delivery '10054016',''
CREATE procedure [citrus_usr].[pr_accnt_delivery]( @pa_sba_no  varchar(20)
                                 , @pa_output  varchar(8000) output
                                   )
as
--
--
begin
--
select distinct dpam.dpam_sba_no            CLIENT_ID
     , dpdhmd.dpdhmd_isin                   ISIN
     , convert(varchar,dpdhmd.dpdhmd_qty)    QTY
from   dp_daily_hldg_nsdl            dpdhmd
     , dp_acct_mstr                  dpam
where  dpdhmd.dpdhmd_dpam_id       = dpam.dpam_id
and    dpam.dpam_sba_no            = @pa_sba_no   
and    isnull(dpdhmd.dpdhmd_qty,0) <> 0
and    dpam.dpam_deleted_ind       = 1
and    dpdhmd.dpdhmd_deleted_ind   = 1
--
-- 
end
--
--

GO
