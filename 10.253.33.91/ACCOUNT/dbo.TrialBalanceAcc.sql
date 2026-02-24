-- Object: PROCEDURE dbo.TrialBalanceAcc
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.TrialBalanceAcc    Script Date: 01/04/1980 1:40:44 AM ******/


CREATE proc TrialBalanceAcc
@startdt varchar(11),
@enddt varchar(11),
@grpcode varchar(11)
As

select a.grpcode,a.cltcode,a.acname,
openamt=isnull(( select sum(case when drcr ='c' then vamt*-1 else vamt end )from ledger l 
     	 Where l.cltcode = a.cltcode and l.vdt >= @startdt and l.vtyp = 18
      	and l.vdt <= @enddt + ' 23:59:59' ),0) ,
amt=isnull(( select sum(case when drcr ='c' then vamt*-1 else vamt end )from ledger l 
     	 Where l.cltcode = a.cltcode and l.vdt >= @startdt and l.vtyp <> 18
      	and l.vdt <= @enddt + ' 23:59:59' ),0) 
from acmast a
where a.grpcode like @grpcode
group by a.grpcode,a.cltcode,a.acname
order by a.grpcode,a.cltcode,a.acname

GO
