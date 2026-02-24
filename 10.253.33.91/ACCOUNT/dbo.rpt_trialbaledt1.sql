-- Object: PROCEDURE dbo.rpt_trialbaledt1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_trialbaledt1    Script Date: 01/04/1980 1:40:42 AM ******/



/****** Object:  Stored Procedure dbo.rpt_trialbaledt1    Script Date: 11/28/2001 12:23:51 PM ******/



/* report : trial balance        file : trialbal.asp
 displays trial balance according to effective date */
/*
this query is executed only if opening entry date is  found
and sort by = effective date
*/

/* changed by mousami on 29 sept 2001
     removed roudning */
 

     
CREATE PROCEDURE rpt_trialbaledt1 

@date datetime,
@openentrydate datetime,
@flag varchar(15),
@viewoption varchar(10),
@balance varchar(10)

AS

if @flag='codewise' 
begin
	if @balance ='normal'
	begin
		if @viewoption='all'
		begin
	 		select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalalledt l
			 where edt <= @date + ' 23:59:59'  and edt>=@openentrydate
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 

		if @viewoption='partywise'
		begin
	 		select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBaledt l
			where edt <= @date + ' 23:59:59'  and edt>=@openentrydate
			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 

		if @viewoption='gl'
		begin
	 		select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalgledt l
			where edt <= @date + ' 23:59:59'  and edt>=@openentrydate
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 
	end
	else if @balance ='withopbal'
	begin
		if @viewoption='all'
		begin
	 		select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt),
			drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt) 
	  		From Rpt_AccTrialBalalledt l
			 where edt <= @date + ' 23:59:59'  and edt>=@openentrydate
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 

		if @viewoption='partywise'
		begin
	 		select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt),
			drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt) 
	  		From Rpt_AccTrialBaledt l
			where edt <= @date + ' 23:59:59'  and edt>=@openentrydate
			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 

		if @viewoption='gl'
		begin
	 		select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt),
			drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt) 
	  		From Rpt_AccTrialBalgledt l
			where edt <= @date + ' 23:59:59'  and edt>=@openentrydate
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 
	end
end /* this end for query order by  codewise*/


if @flag='namewise' 
begin
	if @balance='normal'
	begin		
		if @viewoption='all'
		begin
			select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalalledt l
			 where   edt <= @date + ' 23:59:59'  and edt>=@openentrydate
  			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
		end
			if @viewoption='partywise'
			begin
			select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBaledt l
			 where   edt <= @date + ' 23:59:59'  and edt>=@openentrydate
  			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
			end
			if @viewoption='gl'
			begin
			select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalgledt l
			 where   edt <= @date + ' 23:59:59'  and edt>=@openentrydate
  			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
			end


 	end 
 	else if @balance='withopbal'
	begin		
		if @viewoption='all'
		begin
			select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt),
			drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt) 
	  		From Rpt_AccTrialBalalledt l
			 where   edt <= @date + ' 23:59:59'  and edt>=@openentrydate
  			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
		end
			if @viewoption='partywise'
			begin
			select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt),
			drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt) 
	  		From Rpt_AccTrialBaledt l
			 where   edt <= @date + ' 23:59:59'  and edt>=@openentrydate
  			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
			end
			if @viewoption='gl'
			begin
			select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt),
			drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt) 
	  		From Rpt_AccTrialBalgledt l
			 where   edt <= @date + ' 23:59:59'  and edt>=@openentrydate
  			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
			end

		end

end /* this end for query order by namewise */

GO
