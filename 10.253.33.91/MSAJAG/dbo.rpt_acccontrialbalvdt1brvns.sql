-- Object: PROCEDURE dbo.rpt_acccontrialbalvdt1brvns
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/* report : consolidate trial balance  
   file : trialbal.asp
 displays consolidated trial balance */

/*This procedure is executed when user selects sort by date = vdt 
and opening entry date exists for selected year  for a branch
*/
 
CREATE PROCEDURE rpt_acccontrialbalvdt1brvns

@vdt datetime,
@openentrydate datetime,
@flag varchar(15),
@viewoption varchar(10),
@balance varchar(10),
@statusname varchar(25)

AS

if @flag='codewise' 
begin
/*--------------------------------------------------------------------------------if user wants to see trial balance without opening balance -------------------------------------------------------------------*/
if @balance='normal'
begin
/*--------------------------------------------------------------------------------if user wants to see trial balance for all accounts-------------------------------------------------------------------*/
	if @viewoption='All'	
	begin
 			 select l.cltcode , acname=isnull(l.acname,''),branchcode, 
	  		Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalallbr l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			and costname=@statusname
  			group by l.Cltcode , l.acname, branchcode 
			order by  l.Cltcode , l.acname , branchcode 
	end 
/*--------------------------------------------------------------------------------if user wants to see trial balance for parties only  -------------------------------------------------------------------*/
	else if @viewoption='partywise'
	begin 
 			 select l.cltcode , acname=isnull(l.acname,''),branchcode, 
	  		Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalbr l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			and costname=@statusname
  			group by l.Cltcode , l.acname, branchcode 
			order by  l.Cltcode , l.acname, branchcode  
 	end 
 

/*--------------------------------------------------------------------------------if user wants to see report for general ledger---------------------------------------------------------------------------------------*/
	else if @viewoption='gl'
	begin 
 			 select l.cltcode ,acname=isnull(l.acname,''),branchcode, 
	  		Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalglbr  l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			and costname=@statusname
  			group by l.Cltcode , l.acname, branchcode 
			order by  l.Cltcode , l.acname , branchcode 

	end /* this end for query order by  codewise*/
end /*of balance = 'normal'  */
else if @balance='withopbal' 
begin
		if @viewoption='All'	
		begin
 			 select l.cltcode , acname=isnull(l.acname,''),branchcode, 
	  		/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBalallbr l2 where
			 vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18' and costname=@statusname
			group by l2.Cltcode ),0) , 						
			Crtot = isnull((select Sum(crAmt) from Rpt_AccTrialBalallbr l2 where
			 vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18' and costname=@statusname
			group by l2.Cltcode ),0) , 
/*			opbal= isnull((select ( case when drcr = 'd' then vamt else -vamt end ) from account.dbo.ledger l2 where vdt = @openentrydate  and l2.cltcode=l.cltcode and  l2.vtyp='18'),0)	*/
			opbal=isnull((select sum(case when l2.drcr = 'd' then camt else -camt end) from account.dbo.ledger2 l2, account.dbo.ledger l1
                              where l1.vtyp = 18 and l1.vdt = @openentrydate and l2.vtype = l1.vtyp and l2.booktype = l1.booktype and l2.vno = l1.vno and l2.lno = l1.lno and l1.cltcode = l.cltcode and costname = @statusname),0)
	  		From Rpt_AccTrialBalallbr l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			and costname=@statusname
  			group by l.Cltcode , l.acname, branchcode, costname 
			order by  l.Cltcode , l.acname , branchcode,costname
		end 
/*--------------------------------------------------------------------------------if user wants to see trial balance for parties only  -------------------------------------------------------------------*/
	else if @viewoption='partywise'
		begin 
 			 select l.cltcode , acname=isnull(l.acname,''),branchcode, 
	  		/*amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBalbr l2 where
			 vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'	and costname=@statusname
			group by l2.Cltcode ),0) , 						
			Crtot = isnull((select Sum(crAmt) from Rpt_AccTrialBalbr l2 where
		                  vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18' and costname=@statusname
		 	group by l2.Cltcode ),0) , 
			opbal= isnull((select ( case when drcr = 'd' then vamt else -vamt end ) from account.dbo.ledger l2 where vdt = @openentrydate   and l2.cltcode=l.cltcode and  l2.vtyp='18'),0)	
	  		From Rpt_AccTrialBalbr l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			and costname=@statusname
  			group by l.Cltcode , l.acname, branchcode 
			order by  l.Cltcode , l.acname , branchcode 
	 	end 
 

/*--------------------------------------------------------------------------------if user wants to see report for general ledger---------------------------------------------------------------------------------------*/
	else if @viewoption='gl'
		begin 
 			 select l.cltcode , acname=isnull(l.acname,''),branchcode, 
	  		/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBalglbr l2 where
	             	                  vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			and costname=@statusname
			group by l2.Cltcode ),0) , 						
			Crtot = isnull((select Sum(crAmt) from Rpt_AccTrialBalglbr l2 where
			vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			and costname=@statusname
			group by l2.Cltcode ),0),
			opbal= isnull((select ( case when drcr = 'd' then vamt else -vamt end ) from account.dbo.ledger l2 where vdt = @openentrydate  and l2.cltcode=l.cltcode and  l2.vtyp='18'),0)	
	  		From Rpt_AccTrialBalglbr  l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			and costname=@statusname
  			group by l.Cltcode , l.acname, branchcode 
			order by  l.Cltcode , l.acname , branchcode 

		end /* this end for query order by  codewise*/

end 
end
/*--------------------------------------------------------------------------------if user wants to see report namewise---------------------------------------------------------------------------------------*/


if @flag='namewise' 
begin
/*--------------------------------------------------------------------------------if user wants to see report without opening balance --------------------------------------------------------------------------------------*/

if @balance='normal'
begin

/*--------------------------------------------------------------------------------if user wants to see report for all accounts---------------------------------------------------------------------------------------*/
	if @viewoption='all'
	begin
 			 select l.cltcode , acname=isnull(l.acname,''),branchcode, 
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalallbr l  
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			and costname=@statusname
	  		group by l.Cltcode , l.acname, branchcode 
			order by  l.acname , l.Cltcode, branchcode 
 
	end	
/*--------------------------------------------------------------------------------if user wants to see report for all accounts---------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------if user wants to see report for all party accounts---------------------------------------------------------------------------------------*/
	if @viewoption='partywise'
	begin
 			 select l.cltcode , acname=isnull(l.acname,''),branchcode, 
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalbr l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			and costname=@statusname
			group by l.Cltcode , l.acname, branchcode 
			order by  l.acname , l.Cltcode, branchcode 
 	end 

/*--------------------------------------------------------------------------------if user wants to see report for all party accounts---------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------if user wants to see report for all general ledger accounts---------------------------------------------------------------------------------------*/
	if @viewoption='gl'
		begin
 			 select l.cltcode , acname=isnull(l.acname,''),branchcode, 
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalglbr l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			and costname=@statusname
			group by l.Cltcode , l.acname, branchcode 
			order by  l.acname , l.Cltcode, branchcode 
	 	end 
end
else if @balance='withopbal'
begin
/*--------------------------------------------------------------------------------if user wants to see report for all accounts---------------------------------------------------------------------------------------*/
	if @viewoption='all'
	begin
 			 select l.cltcode , acname=isnull(l.acname,''),branchcode, 
  			/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from  Rpt_AccTrialBalallbr l2 where
			vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18' and costname=@statusname
			group by l2.Cltcode ),0) , 						
			Crtot = isnull((select Sum(crAmt) from Rpt_AccTrialBalallbr l2 where
			 vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18' and costname=@statusname
			group by l2.Cltcode ),0) , 
			opbal= isnull((select ( case when drcr = 'd' then vamt else -vamt end ) from account.dbo.ledger l2 where vdt = @openentrydate   and l2.cltcode=l.cltcode and  l2.vtyp='18'),0)	
			From Rpt_AccTrialBalallbr l  
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			and costname=@statusname
	  		group by l.Cltcode , l.acname, branchcode 
			order by  l.acname , l.Cltcode, branchcode 
 
	end	
/*--------------------------------------------------------------------------------if user wants to see report for all accounts---------------------------------------------------------------------------------------*/

/*--------------------------------------------------------------------------------if user wants to see report for all party accounts---------------------------------------------------------------------------------------*/
	if @viewoption='partywise'
	begin
 			 select l.cltcode , acname=isnull(l.acname,''),branchcode, 
  			/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from   Rpt_AccTrialBalbr l2 where
			 vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'	and costname=@statusname
			group by l2.Cltcode ),0) , 						
			Crtot = isnull((select Sum(crAmt) from  Rpt_AccTrialBalbr  l2 where
			 vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18' and costname=@statusname 
			group by l2.Cltcode ),0) , 
			opbal= isnull((select ( case when drcr = 'd' then vamt else -vamt end ) from account.dbo.ledger l2 where vdt = @openentrydate   and l2.cltcode=l.cltcode and  l2.vtyp='18'),0)	
	  		From Rpt_AccTrialBalbr l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			and costname=@statusname
			group by l.Cltcode , l.acname, branchcode 
			order by  l.acname , l.Cltcode, branchcode 
 	end 

/*--------------------------------------------------------------------------------if user wants to see report for all party accounts---------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------if user wants to see report for all general ledger accounts---------------------------------------------------------------------------------------*/
	if @viewoption='gl'
		begin
 			 select l.cltcode , acname=isnull(l.acname,''),branchcode, 
  			/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from  Rpt_AccTrialBalglbr l2 where
			 vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'	and costname=@statusname
			group by l2.Cltcode ),0) , 						
			Crtot = isnull((select Sum(crAmt) from Rpt_AccTrialBalglbr  l2 where
			vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'	and costname=@statusname
			group by l2.Cltcode ),0) , 
			opbal= isnull((select ( case when drcr = 'd' then vamt else -vamt end ) from account.dbo.ledger l2 where vdt = @openentrydate  and l2.cltcode=l.cltcode and  l2.vtyp='18'),0)	
	  		From Rpt_AccTrialBalglbr l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			and costname=@statusname
			group by l.Cltcode , l.acname, branchcode 
			order by  l.acname , l.Cltcode, branchcode 
	 	end 

end	
/*--------------------------------------------------------------------------------if user wants to see report for all general ledger accounts---------------------------------------------------------------------------------------*/
end /* this end for query order by namewise */

GO
