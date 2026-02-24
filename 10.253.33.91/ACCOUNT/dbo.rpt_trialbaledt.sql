-- Object: PROCEDURE dbo.rpt_trialbaledt
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_trialbaledt    Script Date: 01/04/1980 1:40:42 AM ******/



/****** Object:  Stored Procedure dbo.rpt_trialbaledt    Script Date: 11/28/2001 12:23:51 PM ******/



/* report : trial balance        file : trialbal.asp
 displays trial balance according to effective date */
/*removed rounding 
    changed by mousami on 26 sept 2001 
*/
/*
this query is executed only if opening entry date is not found
and sort by = effective date
*/
 

     
CREATE PROCEDURE rpt_trialbaledt 

@date datetime,
@flag varchar(15),
@viewoption varchar(10),
@balance varchar(10)


AS

if @flag='codewise' 
begin
	if @balance='normal'
	begin
		if @viewoption='all'
		begin
			select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalalledt l
			 where edt <= @date + ' 23:59:59'  
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 

		if @viewoption='partywise'
		begin
			select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBaledt l
			 where edt <= @date + ' 23:59:59'  
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 

		if @viewoption='gl'
		begin
			select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalgledt l
			 where edt <= @date + ' 23:59:59'  
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
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
				 where edt <= @date + ' 23:59:59'  
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
			 where edt <= @date + ' 23:59:59'  
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
			 where edt <= @date + ' 23:59:59'  
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 
	end
end
end


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
			 where   edt <= @date + ' 23:59:59'  
  			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
 		end
		if @viewoption='partywise'
		begin

	 		select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBaledt l
			where   edt <= @date + ' 23:59:59'  
  			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
 		end

		if @viewoption='gl'
		begin

	 		select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalgledt l
			  where   edt <= @date + ' 23:59:59'  
			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
 		end

	end /* this end for query order by namewise */

	if @balance='withopbal'
	begin
		if @viewoption='all'
		begin

	 		select l.cltcode , clcode=isnull((select cl_code from client2 c2 
 			where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
			Amount = Sum(DrAmt)-Sum(CrAmt),
			drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt) 
	  		From Rpt_AccTrialBalalledt l
			 where   edt <= @date + ' 23:59:59'  
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
			where   edt <= @date + ' 23:59:59'  
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
			  where   edt <= @date + ' 23:59:59'  
			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
 		end

	end /* this end for query order by namewise */

end

GO
