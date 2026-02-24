-- Object: PROCEDURE dbo.TrialBalTotalSp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.TrialBalTotalSp    Script Date: 01/04/1980 1:40:44 AM ******/



/****** Object:  Stored Procedure dbo.TrialBalTotalSp    Script Date: 11/28/2001 12:23:53 PM ******/

/****** Object:  Stored Procedure dbo.TrialBalTotalSp    Script Date: 29-Sep-01 8:12:08 PM ******/

/****** Object:  Stored Procedure dbo.TrialBalTotalSp    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.TrialBalTotalSp    Script Date: 8/7/01 6:03:54 PM ******/

/****** Object:  Stored Procedure dbo.TrialBalTotalSp    Script Date: 07/24/2001 11:35:22 AM ******/
Create Proc TrialBalTotalSp
@startdate as datetime,
@enddate as datetime  

AS

select g1.grpname,g1.grpcode, 
vamt=isnull(( select sum(case when drcr ='c' then vamt*-1 else vamt end )
from ledger l ,acmast a ,grpmast g 
 Where l.cltcode = a.cltcode and g.grpcode =g1.grpcode and l.vdt >= @startdate  and l.vdt <= @enddate
and substring(a.grpcode,1,1) = substring(g.grpcode,1,1)),0) ,
totaldebit=isnull(( select sum(case when drcr ='d' then vamt else 0 end )
from ledger l ,acmast a ,grpmast g 
 Where l.cltcode = a.cltcode and g.grpcode =g1.grpcode and l.vdt >= @startdate and l.vdt <= @enddate
and substring(a.grpcode,1,1) = substring(g.grpcode,1,1)),0) ,
totalcredit=isnull(( select sum(case when drcr ='c' then vamt else 0 end )
from ledger l ,acmast a ,grpmast g 
 Where l.cltcode = a.cltcode and g.grpcode =g1.grpcode and l.vdt >= @startdate and l.vdt <= @enddate
and substring(a.grpcode,1,1) = substring(g.grpcode,1,1)),0) 
from grpmast g1 where g1.grpcode='N0000000000' or  g1.grpcode='X0000000000' or g1.grpcode='A0000000000' 
or g1.grpcode='L0000000000'  
order by grpname

GO
