-- Object: PROCEDURE dbo.rpt_acccontrialbaledt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/* report : consolidated trial balance        file : trialbal.asp
 displays consolidated trial balance according to effective date */

/*
this query is executed only if opening entry date is not found
and sort by = effective date
*/
 

     
CREATE PROCEDURE rpt_acccontrialbaledt 

@date datetime,
@flag varchar(15),
@viewoption varchar(10),
@balance varchar(10),
@stdate datetime

AS

if @flag='codewise' 
begin
	if @balance='normal'
	begin
		if @viewoption='all'
		begin
			select l.cltcode ,acname=isnull(l.acname,''), 
			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalalledt l
			 where edt <= @date + ' 23:59:59'  
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 

		if @viewoption='partywise'
		begin
			select l.cltcode,acname=isnull(l.acname,''), 
			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBaledt l
			 where edt <= @date + ' 23:59:59'  
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 

		if @viewoption='gl'
		begin
			select l.cltcode , acname=isnull(l.acname,''), 
			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalgledt l
			 where edt <= @date + ' 23:59:59'  
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 
	end
else if @balance='withopbal' 
		begin
			if @viewoption='all'
			begin
				select l.cltcode , acname=isnull(l.acname,''), 
				/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
				drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBalalledt  l2 where
				edt <= @date + ' 23:59:59' and edt >= @stdate  and l2.cltcode=l.cltcode group by l2.Cltcode ),0) , 			
				Crtot = isnull((select isnull(Sum(crAmt),0) from Rpt_AccTrialBalalledt  l2 where
			                  edt <= @date +' 23:59:59' and edt >= @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0),		
			                 opbal= isnull((select Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0) from Rpt_AccTrialBalalledt  l2 where
			                   edt < @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0)  	
	  			From Rpt_AccTrialBalalledt l
				 where edt <= @date + ' 23:59:59'  
	  			group by l.Cltcode , l.acname 
				order by  l.Cltcode , l.acname 
			end 

		if @viewoption='partywise'
		begin
			select l.cltcode ,acname=isnull(l.acname,''), 
			/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBaledt  l2 where
			edt <= @date + ' 23:59:59' and edt >= @stdate  and l2.cltcode=l.cltcode group by l2.Cltcode ),0) , 			
			Crtot = isnull((select isnull(Sum(crAmt),0) from Rpt_AccTrialBaledt  l2 where
			edt <= @date +' 23:59:59' and edt >= @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0),		
			opbal= isnull((select Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0) from Rpt_AccTrialBaledt  l2 where
			edt < @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0)  	
	  		From Rpt_AccTrialBaledt l
			 where edt <= @date + ' 23:59:59'  
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 

		if @viewoption='gl'
		begin
			select l.cltcode , acname=isnull(l.acname,''), 
			/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from  Rpt_AccTrialBalgledt  l2 where
			edt <= @date + ' 23:59:59' and edt >= @stdate  and l2.cltcode=l.cltcode group by l2.Cltcode ),0) , 			
			Crtot = isnull((select isnull(Sum(crAmt),0) from  Rpt_AccTrialBalgledt l2 where
			edt <= @date +' 23:59:59' and edt >= @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0),		
			opbal= isnull((select Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0) from  Rpt_AccTrialBalgledt  l2 where
			edt < @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0)  	
	  		From Rpt_AccTrialBalgledt l
			 where edt <= @date + ' 23:59:59'  
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 
	end
end



if @flag='namewise' 
begin

	if @balance='normal'
	begin
		if @viewoption='all'
		begin

	 		select l.cltcode , acname=isnull(l.acname,''), 
			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalalledt l
			 where   edt <= @date + ' 23:59:59'  
  			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
 		end
		if @viewoption='partywise'
		begin

	 		select l.cltcode , acname=isnull(l.acname,''), 
			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBaledt l
			where   edt <= @date + ' 23:59:59'  
  			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
 		end

		if @viewoption='gl'
		begin

	 		select l.cltcode , acname=isnull(l.acname,''), 
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

	 		select l.cltcode , acname=isnull(l.acname,''), 
			/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from  Rpt_AccTrialBalalledt  l2 where
			edt <= @date + ' 23:59:59' and edt >= @stdate  and l2.cltcode=l.cltcode group by l2.Cltcode ),0) , 			
			Crtot = isnull((select isnull(Sum(crAmt),0) from  Rpt_AccTrialBalalledt l2 where
			edt <= @date +' 23:59:59' and edt >= @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0),		
			opbal= isnull((select Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0) from  Rpt_AccTrialBalalledt  l2 where
			edt < @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0)  	
	  		From Rpt_AccTrialBalalledt l
			 where   edt <= @date + ' 23:59:59'  
  			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
 		end
		if @viewoption='partywise'
		begin

	 		select l.cltcode , acname=isnull(l.acname,''), 
			/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBaledt  l2 where
			edt <= @date + ' 23:59:59' and edt >= @stdate  and l2.cltcode=l.cltcode group by l2.Cltcode ),0) , 			
			Crtot = isnull((select isnull(Sum(crAmt),0) from  Rpt_AccTrialBaledt l2 where
			edt <= @date +' 23:59:59' and edt >= @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0),		
			opbal= isnull((select Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0) from  Rpt_AccTrialBaledt  l2 where
			edt < @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0)  	
	  		From Rpt_AccTrialBaledt l
			where   edt <= @date + ' 23:59:59'  
  			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
 		end

		if @viewoption='gl'
		begin

	 		select l.cltcode , acname=isnull(l.acname,''), 
			/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from  Rpt_AccTrialBalgledt   l2 where
			edt <= @date + ' 23:59:59' and edt >= @stdate  and l2.cltcode=l.cltcode group by l2.Cltcode ),0) , 			
			Crtot = isnull((select isnull(Sum(crAmt),0) from   Rpt_AccTrialBalgledt  l2 where
			edt <= @date +' 23:59:59' and edt >= @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0),		
			opbal= isnull((select Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0) from   Rpt_AccTrialBalgledt   l2 where
			edt < @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0)  	
	  		From Rpt_AccTrialBalgledt l
			  where   edt <= @date + ' 23:59:59'  
			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
 		end

	end /* this end for query order by namewise */

end

GO
