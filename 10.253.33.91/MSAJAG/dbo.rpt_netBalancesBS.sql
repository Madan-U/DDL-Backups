-- Object: PROCEDURE dbo.rpt_netBalancesBS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/****** Object:  Stored Procedure dbo.rpt_netBalancesBS    Script Date: 06/26/2002 6:15:44 PM ******/
/* Query to Get Net Income and Expenses for the given period */
/* Written on 13-06-2002 by VNS */
/* Flag can have values 'A' - for Income */
/*                      'L' - for Expenses */

CREATE proc rpt_netBalancesBS
@fromdt varchar(11),
@todt varchar(11),
@Grpcode varchar(11),
@statusid varchar(15),
@statusname varchar(25)

as

select type='G', Grp=substring(a.grpcode,1,len(rtrim(@grpcode))+2), Grpname=grpname, Bal= isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)
from account.dbo.ledger l, account.dbo.acmast a, account.dbo.grpmast g
where l.cltcode = a.cltcode and substring(a.grpcode,1,len(rtrim(@grpcode))) = rtrim(@grpcode) 
and vdt >= @fromdt + ' 00:00:00' and vdt <= @todt + ' 23:59:59'
and g.grpcode = substring(a.grpcode,1,len(rtrim(@grpcode))+2)+ right('0000000000',11-(len(rtrim(@grpcode))+2))
group by substring(a.grpcode,1,len(rtrim(@grpcode))+2), grpname
having abs(isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)) > 0

union all

select type = 'D', Grp=l.cltcode, Grpname=l.acname, Bal= isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)
from account.dbo.ledger l, account.dbo.acmast a
where vdt >= @fromdt + ' 00:00:00' and vdt <= @todt + ' 23:59:59'
and l.cltcode = a.cltcode and a.grpcode = @grpcode  +rtrim(right('0000000000',11-len(rtrim(@grpcode)))) 
group by l.cltcode, l.acname
having abs(isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)) > 0
order by grp, grpname

GO
