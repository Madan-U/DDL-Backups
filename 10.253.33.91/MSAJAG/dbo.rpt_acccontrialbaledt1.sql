-- Object: PROCEDURE dbo.rpt_acccontrialbaledt1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/* report : trial balance/        file : trialbal.asp
 displays trial balance according to effective date */
/*
this query is executed only if opening entry date is  found
and sort by = effective date
*/

/* changed by mousami on 29 sept 2001
     removed roudning */
 

     
CREATE PROCEDURE rpt_acccontrialbaledt1 

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
	 		select l.cltcode , acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalalledt l
			 where edt <= @date + ' 23:59:59'  and edt>=@openentrydate
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 

		if @viewoption='partywise'
		begin
	 		select l.cltcode , acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBaledt l
			where edt <= @date + ' 23:59:59'  and edt>=@openentrydate
			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 

		if @viewoption='gl'
		begin
	 		select l.cltcode , acname=isnull(l.acname,''), 
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
	 		select l.cltcode , acname=isnull(l.acname,''), 
  			/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBalalledt   l2 where
				edt <= @date + ' 23:59:59' and edt >= @openentrydate  and l2.cltcode=l.cltcode 
				and vtyp <>  '18'
				group by l2.Cltcode ),0) , 			
			Crtot = isnull((select isnull(Sum(crAmt),0) from Rpt_AccTrialBalalledt  l2 where
				edt <= @date +' 23:59:59' and edt >= @openentrydate and l2.cltcode=l.cltcode 
				and vtyp <>  '18'
				group by l2.Cltcode ),0),		
			opbal= isnull((select balamt from account.dbo.ledger   l2 where vdt  = @openentrydate  and l2.cltcode=l.cltcode and vtyp='18'  ),0)  	
	  		From Rpt_AccTrialBalalledt l
			 where edt <= @date + ' 23:59:59'  and edt>=@openentrydate
  			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 

		if @viewoption='partywise'
		begin
	 		select l.cltcode , acname=isnull(l.acname,''), 
  			/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBaledt   l2 where
			edt <= @date + ' 23:59:59' and edt >= @openentrydate  and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0) , 			
			Crtot = isnull((select isnull(Sum(crAmt),0) from Rpt_AccTrialBaledt l2 where
			edt <= @date +' 23:59:59' and edt >=@openentrydate and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0),		
			opbal= isnull((select balamt from account.dbo.ledger   l2 where vdt  = @openentrydate  and l2.cltcode=l.cltcode and vtyp='18' ),0)  	
	  		From Rpt_AccTrialBaledt l
			where edt <= @date + ' 23:59:59'  and edt>=@openentrydate
			group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 

		if @viewoption='gl'
		begin
	 		select l.cltcode , acname=isnull(l.acname,''), 
  			/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from  Rpt_AccTrialBalgledt   l2 where
			edt <= @date + ' 23:59:59' and edt >= @openentrydate  and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0) , 			
			Crtot = isnull((select isnull(Sum(crAmt),0) from  Rpt_AccTrialBalgledt l2 where
			edt <= @date +' 23:59:59' and edt >= @openentrydate and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0),		
			opbal= isnull((select balamt from account.dbo.ledger   l2 where vdt  = @openentrydate  and l2.cltcode=l.cltcode and vtyp='18'  ),0)  	
	  		From  Rpt_AccTrialBalgledt l
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
			select l.cltcode , acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalalledt l
			 where   edt <= @date + ' 23:59:59'  and edt>=@openentrydate
  			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
		end
			if @viewoption='partywise'
			begin
			select l.cltcode , acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBaledt l
			 where   edt <= @date + ' 23:59:59'  and edt>=@openentrydate
  			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
			end
			if @viewoption='gl'
			begin
			select l.cltcode ,acname=isnull(l.acname,''), 
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
			select l.cltcode , acname=isnull(l.acname,''), 
  			/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBalalledt   l2 where
			edt <= @date + ' 23:59:59' and edt >= @openentrydate  and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0) , 			
			Crtot = isnull((select isnull(Sum(crAmt),0) from Rpt_AccTrialBalalledt  l2 where
			edt <= @date +' 23:59:59' and edt >=@openentrydate and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0),		
			opbal= isnull((select balamt from account.dbo.ledger   l2 where vdt  = @openentrydate  and l2.cltcode=l.cltcode and vtyp='18'  ),0)  	
	  		From Rpt_AccTrialBalalledt l
			 where   edt <= @date + ' 23:59:59'  and edt>=@openentrydate
  			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
		end
			if @viewoption='partywise'
			begin
			select l.cltcode , acname=isnull(l.acname,''), 
  			/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBaledt   l2 where
			edt <= @date + ' 23:59:59' and edt >= @openentrydate  and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0) , 			
			Crtot = isnull((select isnull(Sum(crAmt),0) from Rpt_AccTrialBaledt l2 where
			edt <= @date +' 23:59:59' and edt >= @openentrydate and l2.cltcode=l.cltcode 
			and vtyp <>  '18'			
			group by l2.Cltcode ),0),		
			opbal= isnull((select balamt from account.dbo.ledger   l2 where vdt  = @openentrydate  and l2.cltcode=l.cltcode and vtyp='18' ),0)
	  		From Rpt_AccTrialBaledt l
			 where  edt <= @date + ' 23:59:59'  and edt>=@openentrydate
  			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
			end
			if @viewoption='gl'
			begin
			select l.cltcode , acname=isnull(l.acname,''), 
  			/*Amount = Sum(DrAmt)-Sum(CrAmt),*/
			drtot = isnull((select Sum(drAmt) from  Rpt_AccTrialBalgledt   l2 where
			edt <= @date + ' 23:59:59' and edt >= @openentrydate  and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0) , 			
			Crtot = isnull((select isnull(Sum(crAmt),0) from  Rpt_AccTrialBalgledt l2 where
			edt <= @date +' 23:59:59' and edt >= @openentrydate and l2.cltcode=l.cltcode 
			and vtyp <>  '18'
			group by l2.Cltcode ),0),		
			opbal= isnull((select balamt from account.dbo.ledger   l2 where vdt  = @openentrydate  and l2.cltcode=l.cltcode and vtyp='18' ),0)  	
	  		From Rpt_AccTrialBalgledt l
			 where   edt <= @date + ' 23:59:59'  and edt>=@openentrydate
  			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
			end

		end

end /* this end for query order by namewise */

GO
