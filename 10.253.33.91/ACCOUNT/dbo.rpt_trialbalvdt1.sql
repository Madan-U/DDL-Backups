-- Object: PROCEDURE dbo.rpt_trialbalvdt1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_trialbalvdt1    Script Date: 01/04/1980 1:40:42 AM ******/



/****** Object:  Stored Procedure dbo.rpt_trialbalvdt1    Script Date: 11/28/2001 12:23:51 PM ******/



/* report : trial balance        file : trialbal.asp
 displays trial balance */

/* changed by mousami on 29 sept 2001 removed rounding */
/*
This procedure is executed when user selects sort by date = vdt 
and opening entry date exists for selected year
*/
  
CREATE PROCEDURE rpt_trialbalvdt1

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
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
	  		Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalall l
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
	end 
/*--------------------------------------------------------------------------------if user wants to see trial balance for parties only  -------------------------------------------------------------------*/
	else if @viewoption='partywise'
	begin 
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
	  		Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBal l
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
 	end 
 

/*--------------------------------------------------------------------------------if user wants to see report for general ledger---------------------------------------------------------------------------------------*/
	else if @viewoption='gl'
	begin 
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
	  		Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalgl  l
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 

	end /* this end for query order by  codewise*/
end /*of balance = 'normal'  */
else if @balance='withopbal' 
begin
		if @viewoption='All'	
		begin
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
	  		Amount = Sum(DrAmt)-Sum(CrAmt),
			drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt) 
	  		From Rpt_AccTrialBalall l
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 
/*--------------------------------------------------------------------------------if user wants to see trial balance for parties only  -------------------------------------------------------------------*/
	else if @viewoption='partywise'
		begin 
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
	  		amount = Sum(DrAmt)-Sum(CrAmt),
			drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt) 
	  		From Rpt_AccTrialBal l
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
	 	end 
 

/*--------------------------------------------------------------------------------if user wants to see report for general ledger---------------------------------------------------------------------------------------*/
	else if @viewoption='gl'
		begin 
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
	  		Amount = Sum(DrAmt)-Sum(CrAmt),
			drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt) 
	  		From Rpt_AccTrialBalgl  l
			where  vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 

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
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalall l  where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
	  		group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
 
	end	
/*--------------------------------------------------------------------------------if user wants to see report for all accounts---------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------if user wants to see report for all party accounts---------------------------------------------------------------------------------------*/
	if @viewoption='partywise'
	begin
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBal l
			where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
 	end 

/*--------------------------------------------------------------------------------if user wants to see report for all party accounts---------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------if user wants to see report for all general ledger accounts---------------------------------------------------------------------------------------*/
	if @viewoption='gl'
		begin
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalgl l
			where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
	 	end 
end
else if @balance='withopbal'
begin
/*--------------------------------------------------------------------------------if user wants to see report for all accounts---------------------------------------------------------------------------------------*/
	if @viewoption='all'
	begin
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt),
			drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt)
			From Rpt_AccTrialBalall l  where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
	  		group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
 
	end	
/*--------------------------------------------------------------------------------if user wants to see report for all accounts---------------------------------------------------------------------------------------*/

/*--------------------------------------------------------------------------------if user wants to see report for all party accounts---------------------------------------------------------------------------------------*/
	if @viewoption='partywise'
	begin
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt),
			drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt)
	  		From Rpt_AccTrialBal l
			where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
 	end 

/*--------------------------------------------------------------------------------if user wants to see report for all party accounts---------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------if user wants to see report for all general ledger accounts---------------------------------------------------------------------------------------*/
	if @viewoption='gl'
		begin
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt),
			drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt)
	  		From Rpt_AccTrialBalgl l
			where vdt <= @vdt + ' 23:59:59'  and vdt >= @openentrydate 
			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
	 	end 

end	
/*--------------------------------------------------------------------------------if user wants to see report for all general ledger accounts---------------------------------------------------------------------------------------*/
end /* this end for query order by namewise */

GO
