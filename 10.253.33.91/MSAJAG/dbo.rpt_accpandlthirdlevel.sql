-- Object: PROCEDURE dbo.rpt_accpandlthirdlevel
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accpandlthirdlevel    Script Date: 01/19/2002 12:15:12 ******/

/****** Object:  Stored Procedure dbo.rpt_accpandlthirdlevel    Script Date: 01/04/1980 5:06:25 AM ******/

/* report : pandl
*/


CREATE proc rpt_accpandlthirdlevel



@nextgrpcode varchar(13),
@samelevel varchar(13),
@grpcode varchar(13),
@fromdt datetime,
@todt datetime,
@otherlevel varchar(1),
@abovelevel varchar(13),
@zeros int,
@toplevelcode varchar(13),
@firstlevelcode varchar(13),
@secondlevelcode varchar(13),
@thirdlevelcode varchar(13)


as

if @zeros=8
begin


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
group by gr.grpcode, gr.grpname,gr.dispdetail

union all

select gr.grpcode, gr.grpname,flag='samelevel', dispflag=gr.dispdetail,
amount=isnull((select isnull(sum(vamt),0) from account.dbo.ledger l , account.dbo.acmast a , account.dbo.grpmast g  
				 where l.cltcode=a.cltcode 
				and vdt>=@fromdt  and vdt <= @todt +' 23:59:59' and drcr='d' 
				and  g.grpcode=gr.grpcode and g.grpcode=a.grpcode
				and g.grpcode like @samelevel 
				and g.grpcode not like @grpcode
				group by g.grpcode),0) -  
				isnull((select isnull(sum(vamt),0) from account.dbo.ledger l , account.dbo.acmast a , account.dbo.grpmast g  
				 where l.cltcode=a.cltcode 
				and vdt>=@fromdt and vdt<= @todt + ' 23:59:59'  and drcr='c' 
				and  g.grpcode=gr.grpcode and g.grpcode=a.grpcode
				and  g.grpcode like @samelevel
				and g.grpcode not like @grpcode
				group by g.grpcode),0)
from account.dbo.ledger l1,  account.dbo.acmast ac , account.dbo.grpmast gr 
where vdt>=@fromdt and vdt<= @todt + ' 23:59:59' 
and ac.grpcode=gr.grpcode
and ac.cltcode=l1.cltcode
and (gr.grpcode like @samelevel) 
and gr.grpcode not like @grpcode
group by gr.grpcode, gr.grpname,gr.dispdetail
union all

select gr.grpcode,cltcode,flag='sameaccounts',dispflag=gr.dispdetail,
amt = isnull((select sum(case when drcr ='c' then vamt*-1 else vamt end ) from account.dbo.ledger l,account.dbo.acmast a1 
		where l.cltcode = a1.cltcode and a1.cltcode = a.cltcode and a1.grpcode = a.grpcode 
		and l.vdt >=@fromdt and l.vdt <= @todt+ ' 23:59:59'),0) 
from account.dbo.acmast a, account.dbo.grpmast gr
where  a.grpcode=@grpcode
and gr.grpcode=a.grpcode

union all 
select gr.grpcode,gr.grpname, flag='closedlevel', dispflag=gr.dispdetail,
vamt=isnull(( select sum(case when drcr ='c' then vamt*-1 else vamt end )from account.dbo.ledger l , account.dbo.acmast a , account.dbo.grpmast g 
	      Where l.cltcode = a.cltcode and g.grpcode =gr.grpcode and l.vdt >= @fromdt
	      and l.vdt <= @todt + ' 23:59:59' and substring(a.grpcode,1,1) = substring(g.grpcode,1,1)),0) 
from  account.dbo.grpmast gr 
where gr.grpcode= @otherlevel+'0000000000' 

union all 

select gr.grpcode, gr.grpname,flag='abovelevel', dispflag=gr.dispdetail,
amount=isnull((select isnull(sum(vamt),0) from account.dbo.ledger l , account.dbo.acmast a , account.dbo.grpmast g  
				 where l.cltcode=a.cltcode 
				and vdt>=@fromdt  and vdt <= @todt +' 23:59:59' and drcr='d' 
				and  g.grpcode=gr.grpcode and g.grpcode=a.grpcode
				and g.grpcode like @abovelevel and g.grpcode not like @grpcode
				group by g.grpcode),0) -  
				isnull((select isnull(sum(vamt),0) from account.dbo.ledger l , account.dbo.acmast a , account.dbo.grpmast g  
				 where l.cltcode=a.cltcode 
				and vdt>=@fromdt and vdt<= @todt + ' 23:59:59'  and drcr='c' 
				and  g.grpcode=gr.grpcode and g.grpcode=a.grpcode
				and  g.grpcode like @abovelevel  and g.grpcode not like @grpcode
				group by g.grpcode),0)
from account.dbo.ledger l1,  account.dbo.acmast ac , account.dbo.grpmast gr 
where vdt>=@fromdt and vdt<= @todt + ' 23:59:59' 
and ac.grpcode=gr.grpcode
and ac.cltcode=l1.cltcode
and gr.grpcode like  @abovelevel  
  and gr.grpcode not like @grpcode
group by gr.grpcode, gr.grpname,gr.dispdetail
order by gr.grpcode

end


else  
begin

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
	group by gr.grpcode, gr.grpname,gr.dispdetail

	union all
	
	select gr.grpcode, gr.grpname,flag='samelevel', dispflag=gr.dispdetail,
	amount=isnull((select isnull(sum(vamt),0) from account.dbo.ledger l , account.dbo.acmast a , account.dbo.grpmast g  
					 where l.cltcode=a.cltcode 
				and vdt>=@fromdt  and vdt <= @todt +' 23:59:59' and drcr='d' 
				and  g.grpcode=gr.grpcode and g.grpcode=a.grpcode
				and g.grpcode like @samelevel 
				and g.grpcode not like @grpcode
				group by g.grpcode),0) -  
				isnull((select isnull(sum(vamt),0) from account.dbo.ledger l , account.dbo.acmast a , account.dbo.grpmast g  
				 where l.cltcode=a.cltcode 
				and vdt>=@fromdt and vdt<= @todt + ' 23:59:59'  and drcr='c' 
				and  g.grpcode=gr.grpcode and g.grpcode=a.grpcode
				and  g.grpcode like @samelevel
				and g.grpcode not like @grpcode
				group by g.grpcode),0)
	from account.dbo.ledger l1,  account.dbo.acmast ac , account.dbo.grpmast gr 
	where vdt>=@fromdt and vdt<= @todt + ' 23:59:59' 
	and ac.grpcode=gr.grpcode
	and ac.cltcode=l1.cltcode
	and (gr.grpcode like @samelevel) 
	and gr.grpcode not like @grpcode
	group by gr.grpcode, gr.grpname,gr.dispdetail
	union all

	select gr.grpcode,cltcode,flag='sameaccounts',dispflag=gr.dispdetail,
	amt = isnull((select sum(case when drcr ='c' then vamt*-1 else vamt end ) from account.dbo.ledger l,account.dbo.acmast a1 
		where l.cltcode = a1.cltcode and a1.cltcode = a.cltcode and a1.grpcode = a.grpcode 
		and l.vdt >=@fromdt and l.vdt <= @todt+ ' 23:59:59'),0) 
	from account.dbo.acmast a, account.dbo.grpmast gr
	where  a.grpcode=@grpcode
	and gr.grpcode=a.grpcode

	union all 
	select gr.grpcode,gr.grpname, flag='closedlevel', dispflag=gr.dispdetail,
	vamt=isnull(( select sum(case when drcr ='c' then vamt*-1 else vamt end )from account.dbo.ledger l , account.dbo.acmast a , account.dbo.grpmast g 
	      Where l.cltcode = a.cltcode and g.grpcode =gr.grpcode and l.vdt >= @fromdt
	      and l.vdt <= @todt + ' 23:59:59' and substring(a.grpcode,1,1) = substring(g.grpcode,1,1)),0) 
	from  account.dbo.grpmast gr 
	where gr.grpcode= @otherlevel+'0000000000' 

	union all 

	select gr.grpcode, gr.grpname,flag='abovelevel', dispflag=gr.dispdetail,
	amount=isnull((select isnull(sum(vamt),0) from account.dbo.ledger l , account.dbo.acmast a , account.dbo.grpmast g  
				 where l.cltcode=a.cltcode 
				and vdt>=@fromdt  and vdt <= @todt +' 23:59:59' and drcr='d' 
				and  g.grpcode=gr.grpcode and g.grpcode=a.grpcode
				and g.grpcode not like @grpcode and  g.grpcode in (@firstlevelcode,@secondlevelcode,@toplevelcode,@abovelevel)
				group by g.grpcode) ,0) -  
				isnull((select isnull(sum(vamt),0) from account.dbo.ledger l , account.dbo.acmast a , account.dbo.grpmast g  
				 where l.cltcode=a.cltcode 
				and vdt>=@fromdt and vdt<= @todt + ' 23:59:59'  and drcr='c' 
				and  g.grpcode=gr.grpcode and g.grpcode=a.grpcode
				and   g.grpcode not like @grpcode and g.grpcode in (@firstlevelcode,@secondlevelcode,@toplevelcode,@abovelevel)
				group by g.grpcode),0)
	from account.dbo.ledger l1,  account.dbo.acmast ac , account.dbo.grpmast gr 
	where vdt>=@fromdt and vdt<= @todt + ' 23:59:59' 
	and ac.grpcode=gr.grpcode
	and ac.cltcode=l1.cltcode
	  and gr.grpcode not like @grpcode
	and gr.grpcode in (@firstlevelcode,@secondlevelcode,@toplevelcode,@abovelevel)
	group by gr.grpcode, gr.grpname,gr.dispdetail
	order by gr.grpcode

end

GO
