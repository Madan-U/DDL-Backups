-- Object: PROCEDURE dbo.rpt_accpandlleveldrcr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accpandlleveldrcr    Script Date: 01/19/2002 12:15:12 ******/

/****** Object:  Stored Procedure dbo.rpt_accpandlleveldrcr    Script Date: 01/04/1980 5:06:25 AM ******/

/* calculates  debit and credit  for all levels below a particular level excluding selected level*/

CREATE PROCEDURE rpt_accpandlleveldrcr

@levelgrpcode varchar(13),
@grpcode varchar(13),
@fromdt datetime,
@todt datetime


AS

select amount=isnull((select isnull(sum(vamt),0) from account.dbo.ledger l , account.dbo.acmast a , account.dbo.grpmast g  
				 where l.cltcode=a.cltcode 
				and vdt>=@fromdt  and vdt <= @todt +' 23:59:59' and drcr='d' 
				and  g.grpcode=gr.grpcode and g.grpcode=a.grpcode
				and ( g.grpcode like  @levelgrpcode) 
				and g.grpcode not like @grpcode 
				group by g.grpcode) -  
				(select isnull(sum(vamt),0) from account.dbo.ledger l , account.dbo.acmast a , account.dbo.grpmast g  
				 where l.cltcode=a.cltcode 
				and vdt>=@fromdt and vdt<=  @todt + ' 23:59:59'  and drcr='c' 
				and  g.grpcode=gr.grpcode and g.grpcode=a.grpcode
				and ( g.grpcode like  @levelgrpcode) 
				and g.grpcode not like @grpcode 
				group by g.grpcode),0)
from account.dbo.ledger l1,  account.dbo.acmast ac , account.dbo.grpmast gr
where vdt>=@fromdt and vdt<=  @todt + ' 23:59:59' 
and ac.grpcode=gr.grpcode
and ac.cltcode=l1.cltcode
and gr.grpcode not like @grpcode 
and ( gr.grpcode like  @levelgrpcode) 
group by gr.grpcode, gr.grpname,gr.dispdetail

GO
