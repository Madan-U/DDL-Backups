-- Object: PROCEDURE dbo.rpt_acccontrialbalvdt1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/* report : consolidate trial balance  
   file : trialbal.asp
 displays consolidated trial balance */

/*This procedure is executed when user selects sort by date = vdt 
and opening entry date exists for selected year
*/
  
CREATE PROCEDURE rpt_acccontrialbalvdt1

@vdt datetime,
@openentrydate datetime,
@flag varchar(15),
@viewoption varchar(10),
@balance varchar(10)
AS

if @flag='codewise' 
begin
/*--------------------------------------------------------------------------------if user wants to see trial balance without opening balance -------------------------------------------------------------------*/
if @balance='normal'
begin
/*--------------------------------------------------------------------------------if user wants to see trial balance for all accounts-------------------------------------------------------------------*/
	if @viewoption='All'	
	begin
 			 select l.cltcode , acname=isnull(l.acname,''), branchcode,
	  		Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalall l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
  			group by l.Cltcode , l.acname, branchcode 
			order by  l.Cltcode , l.acname, branchcode 
	end 
/*--------------------------------------------------------------------------------if user wants to see trial balance for parties only  -------------------------------------------------------------------*/
	else if @viewoption='partywise'
	begin 
 			 select l.cltcode , acname=isnull(l.acname,''), branchcode,
	  		Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBal l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
  			group by l.Cltcode , l.acname, branchcode 
			order by  l.Cltcode , l.acname, branchcode 
 	end 
 

/*--------------------------------------------------------------------------------if user wants to see report for general ledger---------------------------------------------------------------------------------------*/
	else if @viewoption='gl'
	begin 
 			 select l.cltcode ,acname=isnull(l.acname,''), branchcode,
	  		Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalgl  l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
  			group by l.Cltcode , l.acname, branchcode 
			order by  l.Cltcode , l.acname, branchcode 

	end /* this end for query order by  codewise*/
end /*of balance = 'normal'  */
else if @balance='withopbal' 
begin
		if @viewoption='All'	
		begin
 			 select l.cltcode , acname=isnull(l.acname,''), branchcode,
	  		/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBalall l2 where
			 vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0) , 						
			Crtot = isnull((select Sum(crAmt) from Rpt_AccTrialBalall l2 where
			 vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0) , 
			opbal= isnull((select balamt from account.dbo.ledger l2 where vdt = @openentrydate  and l2.cltcode=l.cltcode and  l2.vtyp='18'),0)	
	  		From Rpt_AccTrialBalall l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
  			group by l.Cltcode , l.acname, branchcode 
			order by  l.Cltcode , l.acname, branchcode 
		end 
/*--------------------------------------------------------------------------------if user wants to see trial balance for parties only  -------------------------------------------------------------------*/
	else if @viewoption='partywise'
		begin 
 			 select l.cltcode , acname=isnull(l.acname,''), branchcode,
	  		/*amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBal l2 where
			 vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0) , 						
			Crtot = isnull((select Sum(crAmt) from Rpt_AccTrialBal l2 where
		                  vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
		 	group by l2.Cltcode ),0) , 
			opbal= isnull((select balamt from account.dbo.ledger l2 where vdt = @openentrydate   and l2.cltcode=l.cltcode and  l2.vtyp='18'),0)	
	  		From Rpt_AccTrialBal l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
  			group by l.Cltcode , l.acname, branchcode 
			order by  l.Cltcode , l.acname, branchcode 
	 	end 
 

/*--------------------------------------------------------------------------------if user wants to see report for general ledger---------------------------------------------------------------------------------------*/
	else if @viewoption='gl'
		begin 
 			 select l.cltcode , acname=isnull(l.acname,''), branchcode,
	  		/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBalgl l2 where
	             	                  vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0) , 						
			Crtot = isnull((select Sum(crAmt) from Rpt_AccTrialBalgl l2 where
			vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0),
			opbal= isnull((select balamt from account.dbo.ledger l2 where vdt = @openentrydate  and l2.cltcode=l.cltcode and  l2.vtyp='18'),0)	
	  		From Rpt_AccTrialBalgl  l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
  			group by l.Cltcode , l.acname, branchcode 
			order by  l.Cltcode , l.acname, branchcode 

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
 			 select l.cltcode , acname=isnull(l.acname,''), branchcode,
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalall l  
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
	  		group by l.Cltcode , l.acname, branchcode 
			order by  l.acname , l.Cltcode, branchcode
 
	end	
/*--------------------------------------------------------------------------------if user wants to see report for all accounts---------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------if user wants to see report for all party accounts---------------------------------------------------------------------------------------*/
	if @viewoption='partywise'
	begin
 			 select l.cltcode , acname=isnull(l.acname,''), branchcode,
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBal l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			group by l.Cltcode , l.acname, branchcode 
			order by  l.acname , l.Cltcode, branchcode
 	end 

/*--------------------------------------------------------------------------------if user wants to see report for all party accounts---------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------if user wants to see report for all general ledger accounts---------------------------------------------------------------------------------------*/
	if @viewoption='gl'
		begin
 			 select l.cltcode , acname=isnull(l.acname,''), branchcode,
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalgl l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode
			where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			group by l.Cltcode , l.acname, branchcode 
			order by  l.acname , l.Cltcode, branchcode
	 	end 
end
else if @balance='withopbal'
begin
/*--------------------------------------------------------------------------------if user wants to see report for all accounts---------------------------------------------------------------------------------------*/
	if @viewoption='all'
	begin
 			 select l.cltcode , acname=isnull(l.acname,''), branchcode,
  			/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from  Rpt_AccTrialBalall l2 where
			vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0) , 						
			Crtot = isnull((select Sum(crAmt) from Rpt_AccTrialBalall l2 where
			 vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0) , 
			opbal= isnull((select balamt from account.dbo.ledger l2 where vdt = @openentrydate   and l2.cltcode=l.cltcode and  l2.vtyp='18'),0)	
			From Rpt_AccTrialBalall l  
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
	  		group by l.Cltcode , l.acname, branchcode 
			order by  l.acname , l.Cltcode, branchcode
 
	end	
/*--------------------------------------------------------------------------------if user wants to see report for all accounts---------------------------------------------------------------------------------------*/

/*--------------------------------------------------------------------------------if user wants to see report for all party accounts---------------------------------------------------------------------------------------*/
	if @viewoption='partywise'
	begin
 			 select l.cltcode , acname=isnull(l.acname,''), branchcode,
  			/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from   Rpt_AccTrialBal l2 where
			 vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0) , 						
			Crtot = isnull((select Sum(crAmt) from  Rpt_AccTrialBal  l2 where
			 vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0) , 
			opbal= isnull((select balamt from account.dbo.ledger l2 where vdt = @openentrydate   and l2.cltcode=l.cltcode and  l2.vtyp='18'),0)	
	  		From Rpt_AccTrialBal l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			group by l.Cltcode , l.acname, branchcode 
			order by  l.acname , l.Cltcode, branchcode
 	end 

/*--------------------------------------------------------------------------------if user wants to see report for all party accounts---------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------if user wants to see report for all general ledger accounts---------------------------------------------------------------------------------------*/
	if @viewoption='gl'
		begin
 			 select l.cltcode , acname=isnull(l.acname,''), branchcode,
  			/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from  Rpt_AccTrialBalgl l2 where
			 vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0) , 						
			Crtot = isnull((select Sum(crAmt) from Rpt_AccTrialBalgl  l2 where
			vdt <= @vdt + ' 23:59:59' and vdt >= @openentrydate   and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0) , 
			opbal= isnull((select balamt from account.dbo.ledger l2 where vdt = @openentrydate  and l2.cltcode=l.cltcode and  l2.vtyp='18'),0)	
	  		From Rpt_AccTrialBalgl l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode 
			where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			group by l.Cltcode , l.acname, branchcode 
			order by  l.acname , l.Cltcode, branchcode
	 	end 

end	
/*--------------------------------------------------------------------------------if user wants to see report for all general ledger accounts---------------------------------------------------------------------------------------*/
end /* this end for query order by namewise */

GO
