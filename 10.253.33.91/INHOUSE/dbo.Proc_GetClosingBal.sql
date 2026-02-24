-- Object: PROCEDURE dbo.Proc_GetClosingBal
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE Procedure Proc_GetClosingBal(@FromDate as varchar(23),@ToDate as varchar(23))
as
Set NoCount On
Begin

truncate table Tbl_NRMS_ClosingBal

insert into Tbl_NRMS_ClosingBal(CltCode,ClsBal)
select cltcode,ClsBal=sum(Case when drcr='D' then vamt else -vamt end)
--from account.dbo.LEDGER a with(nolock)
from LEDGER a with(nolock)
--where vdt >= '2011-02-01 00:00:00.000' and vdt <= 'Mar  2 2011 11:59PM'
where vdt >= @FromDate and vdt <= @ToDate
group by cltcode
having sum(Case when drcr='D' then vamt else -vamt end) <> 0

End
Set NoCount Off

GO
