-- Object: PROCEDURE dbo.rpt_acccostsumcostdetails
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acccostsumcostdetails    Script Date: 01/04/1980 1:40:39 AM ******/



/* report : cost summary
    gives details of a cost center  and levels under it
 */

CREATE PROCEDURE  rpt_acccostsumcostdetails

@nextgrpcode varchar(20),
@costdate datetime


AS

select c.costname,c.grpcode, vtype,l.vno, camt, vdt=convert(varchar,vdt,103), acname
from account.dbo.ledger2 l2, account.dbo.ledger l , account.dbo.costmast c
where grpcode like @nextgrpcode
and l.vtyp=l2.vtype and l.vno=l2.vno and l.lno=l2.lno
and l.drcr=l2.drcr
and l.booktype=l2.booktype
and c.costcode=l2.costcode
and l.vdt <= @costdate + ' 23:59:59'
order by vdt,vtype,acname

GO
