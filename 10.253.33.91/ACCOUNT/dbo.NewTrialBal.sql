-- Object: PROCEDURE dbo.NewTrialBal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.NewTrialBal    Script Date: 01/04/1980 1:40:38 AM ******/


CREATE Proc NewTrialBal 
@startdt varchar(11),
@enddt varchar(11)
As

select grpname,a.grpcode,l.acname,l.cltcode ,
openentry=isnull(( select sum(case when drcr ='c' then vamt*-1 else vamt end )from ledger 
		   where cltcode = l.cltcode and vtyp = 18 
		   and vdt >= @startdt and vdt < = @enddt),0),
dramt = isnull((select sum(vamt) from ledger  where drcr = 'd' and cltcode = l.cltcode and vtyp <> 18
	 and vdt >= @startdt and vdt < = @enddt ),0),
cramt = isnull((select sum(vamt) from ledger  where drcr = 'c' and cltcode = l.cltcode and vtyp <> 18
	and vdt >= @startdt and vdt < = @enddt),0)
from acmast a,ledger l,grpmast g
where l.cltcode = a.cltcode and  a.grpcode = g.grpcode
group by  g.grpname,a.grpcode,l.acname,l.cltcode
order by a.grpcode,l.cltcode


/*
select grpname,a.grpcode,l.acname,l.cltcode ,
openentry=round(isnull(( select sum(case when drcr ='c' then vamt*-1 else vamt end )from ledger 
		   where cltcode = l.cltcode and vtyp = 18 
		   and vdt >= @startdt and vdt < = @enddt),0),2),
dramt = round(isnull((select sum(vamt) from ledger  where drcr = 'd' and cltcode = l.cltcode and vtyp <> 18
	 and vdt >= @startdt and vdt < = @enddt ),0),2),
cramt = round(isnull((select sum(vamt) from ledger  where drcr = 'c' and cltcode = l.cltcode and vtyp <> 18
	and vdt >= @startdt and vdt < = @enddt),0),2)
from acmast a,ledger l,grpmast g
where l.cltcode = a.cltcode and  a.grpcode = g.grpcode
group by  g.grpname,a.grpcode,l.acname,l.cltcode
order by a.grpcode,l.cltcode
*/

GO
