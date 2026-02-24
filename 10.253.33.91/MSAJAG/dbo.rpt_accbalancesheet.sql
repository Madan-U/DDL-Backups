-- Object: PROCEDURE dbo.rpt_accbalancesheet
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accbalancesheet    Script Date: 01/19/2002 12:15:11 ******/

/****** Object:  Stored Procedure dbo.rpt_accbalancesheet    Script Date: 01/04/1980 5:06:24 AM ******/

cREATE PROCEDURE  rpt_accbalancesheet

@fromdt datetime,
@todt datetime


as

select g1.grpname,g1.grpcode, 
vamt=isnull(( select sum(case when drcr ='c' then vamt*-1 else vamt end )from account.dbo.ledger l ,account.dbo.acmast a ,account.dbo.grpmast g 
	      Where l.cltcode = a.cltcode and g.grpcode =g1.grpcode and l.vdt >= @fromdt
	      and l.vdt <=@todt + ' 23:59:59' and substring(a.grpcode,1,1) = substring(g.grpcode,1,1)),0) 
from account.dbo.grpmast g1 
where g1.grpcode='A0000000000' or  g1.grpcode='L0000000000' 
order by g1.grpcode

GO
