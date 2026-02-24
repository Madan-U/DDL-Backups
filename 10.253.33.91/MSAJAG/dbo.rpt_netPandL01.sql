-- Object: PROCEDURE dbo.rpt_netPandL01
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/****** Object:  Stored Procedure dbo.rpt_netPandL01    Script Date: 06/26/2002 6:15:44 PM ******/
/* Query to Get Net Income and Expenses for the given period */
/* Written on 13-06-2002 by VNS */
/* Flag can have values 'N' - for Income */
/*                      'X' - for Expenses */

CREATE proc rpt_netPandL01
@fromdt varchar(11),
@todt varchar(11),
@statusid varchar(15),
@statusname varchar(25)

as

select type='G', Grp=substring(a.grpcode,1,3), Grpname=grpname, Bal=isnull(sum(case when drcr = 'd' then vamt else -vamt end),0), left(a.grpcode,1)
from account.dbo.ledger l, account.dbo.acmast a, account.dbo.grpmast g
where l.cltcode = a.cltcode and substring(a.grpcode,1,1) in ('N','X')
and vdt >= @fromdt + ' 00:00:00' and vdt <= @todt + ' 23:59:59'
and g.grpcode = substring(a.grpcode,1,3)+ '00000000'
group by substring(a.grpcode,1,3), grpname, left(a.grpcode,1)
having abs(isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)) > 0

union all

select type = 'D', Grp=l.cltcode, Grpname=l.acname, Bal=isnull(sum(case when drcr = 'd' then vamt else -vamt end),0), left(a.grpcode,1)
from account.dbo.ledger l, account.dbo.acmast a
where vdt >= @fromdt + ' 00:00:00' and vdt <= @todt + ' 23:59:59'
and l.cltcode = a.cltcode and a.grpcode in ('N0000000000', 'X0000000000')
group by l.cltcode, l.acname, left(a.grpcode,1)
having abs(isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)) > 0
order by grp, grpname

GO
