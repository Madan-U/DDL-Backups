-- Object: PROCEDURE dbo.rpt_accbalsheetchecknextlvl
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accbalsheetchecknextlvl    Script Date: 01/19/2002 12:15:11 ******/

/****** Object:  Stored Procedure dbo.rpt_accbalsheetchecknextlvl    Script Date: 01/04/1980 5:06:24 AM ******/

CREATE PROCEDURE rpt_accbalsheetchecknextlvl

@fromdt datetime,
@todt datetime,
@nextgrpcode varchar(13),
@grpcode varchar(13)

as

select gr.grpcode, gr.grpname  ,  flag='nextlevel',dispflag=gr.dispdetail,
	amount=isnull((select isnull(sum(vamt),0) from account.dbo.ledger l , account.dbo.acmast a , account.dbo.grpmast g  
				 where l.cltcode=a.cltcode 
				and vdt>=@fromdt  and vdt <= @todt +' 23:59:59' and drcr='d' 
				and  g.grpcode=gr.grpcode and g.grpcode=a.grpcode
				and ( g.grpcode like  @nextgrpcode) 
				and g.grpcode not like @grpcode 
				group by g.grpcode),0) -  
				isnull((select isnull(sum(vamt),0) from account.dbo.ledger l , account.dbo.acmast a , account.dbo.grpmast g  
				 where l.cltcode=a.cltcode 
				and vdt>=@fromdt and vdt<=  @todt + ' 23:59:59'  and drcr='c' 
				and  g.grpcode=gr.grpcode and g.grpcode=a.grpcode
				and ( g.grpcode like  @nextgrpcode) 
				and g.grpcode not like @grpcode 
				group by g.grpcode),0)
	from account.dbo.ledger l1,  account.dbo.acmast ac , account.dbo.grpmast gr 
	where vdt>=@fromdt and vdt<=  @todt + ' 23:59:59' 
	and ac.grpcode=gr.grpcode
	and ac.cltcode=l1.cltcode
	and gr.grpcode like  @nextgrpcode
	and gr.grpcode not like @grpcode 

/*
select gr.grpcode, gr.grpname 
	from rpt_accbalsheetgrpvdtdrcr gr
	where vdt>=@fromdt and vdt<=  @todt + ' 23:59:59' 
	and gr.grpcode like  @nextgrpcode
	and gr.grpcode not like @grpcode 
*/

GO
