-- Object: PROCEDURE dbo.rpt_acccontrialbalvdt
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE  rpt_acccontrialbalvdt

/* report : consolidated trial balance        
file : trialbal.asp
displays consolidated trial balance */

/*
This procedure is executed when user selects sort by date = vdt and openig entry date does not exist
for the selected year
*/

  


@vdt datetime,
@flag varchar(15),
@viewoption varchar(10),
@balance varchar(10),
@stdate datetime	

AS

/*-----------------------------------------------------------------------------If user wants to see trial balance codewise  ------------------------------------------------------------------------------------*/
if @flag='codewise' 
begin
/*-----------------------------------------------------------------------------If user wants to see trial balance with opening balance  ------------------------------------------------------------------------------------*/
	if @balance='withopbal'
	begin
/*-----------------------------------------------------------------------------If user wants to see trial balance for all accounts ------------------------------------------------------------------------------------*/
		if @viewoption = 'All' 
		begin
 			select l.cltcode , acname=isnull(l.acname,''), branchcode,
  			/*Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0),*/
	  		drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBalall l2 where
			       vdt <= @vdt + ' 23:59:59' and vdt >= @stdate  and l2.cltcode=l.cltcode group by l2.Cltcode ),0) , 			
			Crtot = isnull((select isnull(Sum(crAmt),0) from Rpt_AccTrialBalall l2 where
			       vdt <= @vdt +' 23:59:59' and vdt >= @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0),		
			opbal= isnull((select Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0) from Rpt_AccTrialBalall l2 where
			       vdt < @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0)  	
	  		From Rpt_AccTrialBalall l
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode where  
			vdt <= @vdt + ' 23:59:59'  
	  		group by l.Cltcode , l.acname, branchcode
			order by l.Cltcode , l.acname, branchcode
		end 

/*-----------------------------------------------------------------------------If user wants to see trial balance for only party accounts ------------------------------------------------------------------------------------*/		
		else if @viewoption='Partywise' 
                                      begin		 

 			select l.cltcode , acname=isnull(l.acname,''), branchcode,
  			/*Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0),*/
	  		drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBal l2 where
			       vdt <= @vdt + ' 23:59:59' and vdt >= @stdate  and l2.cltcode=l.cltcode group by l2.Cltcode ),0) , 			
			Crtot = isnull((select isnull(Sum(crAmt),0) from Rpt_AccTrialBal l2 where
			       vdt <= @vdt +' 23:59:59' and vdt >= @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0),		
			opbal= isnull((select Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0) from Rpt_AccTrialBal l2 where
			       vdt < @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0)  	
	  		From Rpt_AccTrialBal l 
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode where  
			vdt <= @vdt + ' 23:59:59'  
	  		group by l.Cltcode , l.acname, branchcode
			order by l.Cltcode , l.acname, branchcode
		end

/*-----------------------------------------------------------------------------If user wants to see trial balance for only general ledger  accounts ------------------------------------------------------------------------------------*/		
	           else if @viewoption = 'gl'
                              begin
 			select l.cltcode , acname=isnull(l.acname,''), branchcode,
  			/*Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0),*/
	  		drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBalgl l2 where
			       vdt <= @vdt + ' 23:59:59' and vdt >= @stdate  and l2.cltcode=l.cltcode group by l2.Cltcode ),0) , 			
			Crtot = isnull((select isnull(Sum(crAmt),0) from Rpt_AccTrialBalgl l2 where
			       vdt <= @vdt +' 23:59:59' and vdt >= @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0),		
			opbal= isnull((select Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0) from Rpt_AccTrialBalgl l2 where
			       vdt < @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0)  	
	  		From Rpt_AccTrialBalgl l 
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode where  
			vdt <= @vdt + ' 23:59:59'  
	  		group by l.Cltcode , l.acname, branchcode
			order by l.Cltcode , l.acname, branchcode
			

	          end 		
/*-----------------------------------------------------------------------------If user wants to see trial balance without opening balance ------------------------------------------------------------------------------------*/		
	end /* balance=withopbal*/
else if @balance='normal'
begin
			if @viewoption = 'All' 
			begin
 				 select l.cltcode , acname=isnull(l.acname,''), branchcode,
  				Amount = Sum(DrAmt)-Sum(CrAmt)
	  			From Rpt_AccTrialBalall l 
				left outer join account.dbo.acmast a on l.cltcode=  a.cltcode where  
				vdt <= @vdt + ' 23:59:59'  
		  		group by l.Cltcode , l.acname, branchcode
				order by  l.Cltcode , l.acname, branchcode
			end 

/*-----------------------------------------------------------------------------If user wants to see trial balance for only party accounts ------------------------------------------------------------------------------------*/		
		else if @viewoption='Partywise' 
                                      begin		 

				select l.cltcode , acname=isnull(l.acname,''), branchcode,
  				Amount = Sum(DrAmt)-Sum(CrAmt)
		  		From Rpt_AccTrialBal l 
				left outer join account.dbo.acmast a on l.cltcode=  a.cltcode where  
				vdt <= @vdt + ' 23:59:59'  
	  			group by l.Cltcode , l.acname, branchcode
				order by  l.Cltcode , l.acname, branchcode
 	                  end

/*-----------------------------------------------------------------------------If user wants to see trial balance for only general ledger  accounts ------------------------------------------------------------------------------------*/		
	           else if @viewoption = 'gl'
                              begin
 			 select l.cltcode ,acname=isnull(l.acname,''), branchcode,
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalgl l 
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode where  
			vdt <= @vdt + ' 23:59:59'  
	  		group by l.Cltcode , l.acname, branchcode
			order by  l.Cltcode , l.acname, branchcode
 
	          end 		


end /*of normal = balance */
end /*of flag = codewise */

/*-----------------------------------------------------------------------------If user wants to see trial balance namewise ------------------------------------------------------------------------------------*/		

if @flag='namewise' 
begin
/*-----------------------------------------------------------------------------If user wants to see trial balance with opening balance  ------------------------------------------------------------------------------------*/

	if @balance='withopbal'
	begin
/*-----------------------------------------------------------------------------If user wants to see trial balance for all accounts ------------------------------------------------------------------------------------*/

		if @viewoption = 'all'
		begin 
 			select l.cltcode , acname=isnull(l.acname,''), branchcode,
  			/*Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0),*/
	  		drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBalall l2 where
			       vdt <= @vdt + ' 23:59:59' and vdt >= @stdate  and l2.cltcode=l.cltcode group by l2.Cltcode ),0) , 			
			Crtot = isnull((select isnull(Sum(crAmt),0) from Rpt_AccTrialBalall l2 where
			       vdt <= @vdt +' 23:59:59' and vdt >= @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0),		
			opbal= isnull((select Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0) from Rpt_AccTrialBalall l2 where
			       vdt < @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0)  	
	  		From Rpt_AccTrialBalall l 
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode where  			vdt <= @vdt + ' 23:59:59'  
	  		group by l.Cltcode , l.acname, branchcode
			order by  l.acname,l.cltcode, branchcode

		end
/*-----------------------------------------------------------------------------If user wants to see trial balance for only party accounts ------------------------------------------------------------------------------------*/

		else if @viewoption = 'partywise'
		begin
			select l.cltcode , acname=isnull(l.acname,''), branchcode,
  			/*Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0),*/
	  		drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBal l2 where
			       vdt <= @vdt + ' 23:59:59' and vdt >= @stdate  and l2.cltcode=l.cltcode group by l2.Cltcode ),0) , 			
			Crtot = isnull((select isnull(Sum(crAmt),0) from Rpt_AccTrialBal l2 where
			       vdt <= @vdt +' 23:59:59' and vdt >= @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0),		
			opbal= isnull((select Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0) from Rpt_AccTrialBal l2 where
			       vdt < @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0)  	
	  		From Rpt_AccTrialBal l 
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode where  
			vdt <= @vdt + ' 23:59:59'  
	  		group by l.Cltcode , l.acname, branchcode
 			order by  l.acname , l.Cltcode, branchcode
	 	end 

/*-----------------------------------------------------------------------------If user wants to see trial balance for general ledger ------------------------------------------------------------------------------------*/

		else if  @viewoption='gl'
		begin
			select l.cltcode , acname=isnull(l.acname,''), branchcode,
  			/*Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0),*/
	  		drtot = isnull((select Sum(drAmt) from Rpt_AccTrialBalgl l2 where
			       vdt <= @vdt + ' 23:59:59' and vdt >= @stdate  and l2.cltcode=l.cltcode group by l2.Cltcode ),0) , 			
			Crtot = isnull((select isnull(Sum(crAmt),0) from Rpt_AccTrialBalgl l2 where
			       vdt <= @vdt +' 23:59:59' and vdt >= @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0),		
			opbal= isnull((select Amount = isnull(Sum(DrAmt)-Sum(CrAmt),0) from Rpt_AccTrialBalgl l2 where
			       vdt < @stdate and l2.cltcode=l.cltcode group by l2.Cltcode ),0)  	
	  		From Rpt_AccTrialBalgl l 
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode where  
			vdt <= @vdt + ' 23:59:59'  
	  		group by l.Cltcode , l.acname , branchcode
			order by  l.acname , l.Cltcode, branchcode
		end
	end /*withopbal*/
	else if  @balance='normal'
	begin
		if @viewoption = 'all'
		begin 
	 		 select l.cltcode , acname=isnull(l.acname,''), branchcode,
	  		Amount = Sum(DrAmt)-Sum(CrAmt)
		  	From Rpt_AccTrialBalall  l 
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode where  
			vdt <= @vdt + ' 23:59:59'  
			group by l.Cltcode , l.acname , branchcode
			order by  l.acname , l.Cltcode, branchcode
		end
/*-----------------------------------------------------------------------------If user wants to see trial balance for only party accounts ------------------------------------------------------------------------------------*/

		else if @viewoption = 'partywise'
		begin
 			 select l.cltcode , acname=isnull(l.acname,''), branchcode,
	  		Amount = Sum(DrAmt)-Sum(CrAmt)
		  	From Rpt_AccTrialBal  l 
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode where  
			vdt <= @vdt + ' 23:59:59'  
			group by l.Cltcode , l.acname , branchcode
			order by  l.acname , l.Cltcode, branchcode
	 	end 

/*-----------------------------------------------------------------------------If user wants to see trial balance for general ledger ------------------------------------------------------------------------------------*/

		else if  @viewoption='gl'
		begin
 			 select l.cltcode , acname=isnull(l.acname,''), branchcode,
	  		Amount = Sum(DrAmt)-Sum(CrAmt)
			From Rpt_AccTrialBalgl  l 
			left outer join account.dbo.acmast a on l.cltcode=  a.cltcode where  
			vdt <= @vdt + ' 23:59:59'  
			group by l.Cltcode , l.acname , branchcode
			order by  l.acname , l.Cltcode, branchcode

		end
	end  /* of normal balance */  		
end

GO
