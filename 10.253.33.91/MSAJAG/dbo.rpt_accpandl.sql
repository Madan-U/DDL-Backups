-- Object: PROCEDURE dbo.rpt_accpandl
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/****** Object:  Stored Procedure dbo.rpt_accpandl    Script Date: 06/26/2002 6:15:44 PM ******/  
/* ch by mousami on 15 apr 2002   
     added branch login effect */  
  
  
CREATE PROCEDURE  rpt_accpandl  
  
@fromdt varchar(11),  
@todt varchar(11),  
@statusid varchar(15),  
@statusname varchar(25)  
  
  
as  
  
if @statusid=''  
begin  
 select g1.grpname,g1.grpcode,   
 vamt=isnull(( select sum(case when drcr ='c' then vamt*-1 else vamt end )from account.dbo.ledger l ,account.dbo.acmast a ,account.dbo.grpmast g   
       Where l.cltcode = a.cltcode and g.grpcode =g1.grpcode and l.vdt >= @fromdt + ' 00:00:00'  
       and l.vdt <=@todt + ' 23:59:59' and substring(a.grpcode,1,1) = substring(g.grpcode,1,1)),0)   
 from account.dbo.grpmast g1   
 where g1.grpcode='N0000000000' or  g1.grpcode='X0000000000'   
 order by g1.grpcode  
end  
else  
begin  
 select g1.grpname,g1.grpcode,   
 vamt=isnull(( select sum(case when l.drcr ='c' then vamt*-1 else vamt end )from  
  account.dbo.ledger l ,account.dbo.acmast a ,account.dbo.grpmast g ,  account.dbo.ledger2 l2 ,  account.dbo.costmast c , account.dbo.category c1  
   Where l.cltcode = a.cltcode and g.grpcode =g1.grpcode and l.vdt >= @fromdt + ' 00:00:00'  
     and l.vdt <=@todt  + ' 23:59:59'   
     and l.vno=l2.vno and l.vtyp=l2.vtype and l.lno=l2.lno and l.drcr=l2.drcr  
 and c.costcode=l2.costcode  
 and c.catcode=c1.catcode  
 and l.booktype=l2.booktype  
 and c1.category='branch'  
    and c.costname=@statusname  
  and substring(a.grpcode,1,1) = substring(g.grpcode,1,1)),0)   
  from account.dbo.grpmast g1   
  where g1.grpcode='N0000000000' or  g1.grpcode='X0000000000'   
  order by g1.grpcode  
end

GO
