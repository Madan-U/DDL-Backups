-- Object: PROCEDURE dbo.rpt_trialbalvdt
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_trialbalvdt    Script Date: 01/04/1980 1:40:42 AM ******/



/****** Object:  Stored Procedure dbo.rpt_trialbalvdt    Script Date: 11/28/2001 12:23:51 PM ******/

/* report : trial balance        file : trialbal.asp
 displays trial balance */

/* changed by mousami on 18 oct 2001
     added option for user to see report either for party accounts or for general ledger or all accounts 
 */
/* changed by mousami on 29 sept 2001
     removed rounding
*/
/*
This procedure is executed when user selects sort by date = vdt and openig entry date does not exist
for the selected year
*/

  
CREATE PROCEDURE rpt_trialbalvdt

@vdt datetime,
@flag varchar(15),
@viewoption varchar(10),
@balance varchar(10)	

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
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
  	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt),
	  		drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt) 
	  		From Rpt_AccTrialBalall l where  
			vdt <= @vdt + ' 23:59:59'  
	  		group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
		end 

/*-----------------------------------------------------------------------------If user wants to see trial balance for only party accounts ------------------------------------------------------------------------------------*/		
		else if @viewoption='Partywise' 
                                      begin		 

			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
  	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt),
	  		drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt) 
	  		From Rpt_AccTrialBal l where  
			vdt <= @vdt + ' 23:59:59'  
	  		group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 	                  end

/*-----------------------------------------------------------------------------If user wants to see trial balance for only general ledger  accounts ------------------------------------------------------------------------------------*/		
	           else if @viewoption = 'gl'
                              begin
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
  	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt),
	  		drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt) 
	  		From Rpt_AccTrialBalgl l where  
			vdt <= @vdt + ' 23:59:59'  
	  		group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
 
	          end 		
/*-----------------------------------------------------------------------------If user wants to see trial balance without opening balance ------------------------------------------------------------------------------------*/		
	else if @balance='normal'
	begin
			if @viewoption = 'All' 
			begin
 				 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
  	 			 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  				Amount = Sum(DrAmt)-Sum(CrAmt)
	  			From Rpt_AccTrialBalall l where  
				vdt <= @vdt + ' 23:59:59'  
		  		group by l.Cltcode , l.acname 
				order by  l.Cltcode , l.acname 
			end 

/*-----------------------------------------------------------------------------If user wants to see trial balance for only party accounts ------------------------------------------------------------------------------------*/		
		else if @viewoption='Partywise' 
                                      begin		 

				 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
  		 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  				Amount = Sum(DrAmt)-Sum(CrAmt)
		  		From Rpt_AccTrialBal l where  
				vdt <= @vdt + ' 23:59:59'  
	  			group by l.Cltcode , l.acname 
				order by  l.Cltcode , l.acname 	                  end

/*-----------------------------------------------------------------------------If user wants to see trial balance for only general ledger  accounts ------------------------------------------------------------------------------------*/		
	           else if @viewoption = 'gl'
                              begin
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
  	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
  			Amount = Sum(DrAmt)-Sum(CrAmt)
	  		From Rpt_AccTrialBalgl l where  
			vdt <= @vdt + ' 23:59:59'  
	  		group by l.Cltcode , l.acname 
			order by  l.Cltcode , l.acname 
 
	          end 		
	end

	end /*of normal = balance */
end 

/*-----------------------------------------------------------------------------If user wants to see trial balance namewise ------------------------------------------------------------------------------------*/		

if @flag='namewise' 
begin
/*-----------------------------------------------------------------------------If user wants to see trial balance with opening balance  ------------------------------------------------------------------------------------*/

if @balance='withopbal'
begin
/*-----------------------------------------------------------------------------If user wants to see trial balance for all accounts ------------------------------------------------------------------------------------*/

	if @viewoption = 'all'
	begin 
	 		 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
	  		Amount = Sum(DrAmt)-Sum(CrAmt),
			drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt) 
		  	From Rpt_AccTrialBalall  l where vdt <= @vdt + ' 23:59:59'  
			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
	end
/*-----------------------------------------------------------------------------If user wants to see trial balance for only party accounts ------------------------------------------------------------------------------------*/

	else if @viewoption = 'partywise'
	begin
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
	  		Amount = Sum(DrAmt)-Sum(CrAmt),
			drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt) 
		  	From Rpt_AccTrialBal  l where vdt <= @vdt + ' 23:59:59'  
			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
 	end 

/*-----------------------------------------------------------------------------If user wants to see trial balance for general ledger ------------------------------------------------------------------------------------*/

	else if  @viewoption='gl'
	begin
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
	  		Amount = Sum(DrAmt)-Sum(CrAmt),
			drtot = Sum(DrAmt),  			
			Crtot = Sum(CrAmt) 
		  	From Rpt_AccTrialBalgl  l where vdt <= @vdt + ' 23:59:59'  
			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode

	end
	else if  @balance='normal'
	begin
		if @viewoption = 'all'
		begin 
	 		 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
	  		Amount = Sum(DrAmt)-Sum(CrAmt)
		  	From Rpt_AccTrialBalall  l where vdt <= @vdt + ' 23:59:59'  
			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
		end
/*-----------------------------------------------------------------------------If user wants to see trial balance for only party accounts ------------------------------------------------------------------------------------*/

	else if @viewoption = 'partywise'
	begin
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
	  		Amount = Sum(DrAmt)-Sum(CrAmt)
		  	From Rpt_AccTrialBal  l where vdt <= @vdt + ' 23:59:59'  
			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode
 	end 

/*-----------------------------------------------------------------------------If user wants to see trial balance for general ledger ------------------------------------------------------------------------------------*/

	else if  @viewoption='gl'
	begin
 			 select l.cltcode , clcode=isnull((select cl_code from client2 c2 
	 		 where c2.party_code=l.cltcode),''),acname=isnull(l.acname,''), 
	  		Amount = Sum(DrAmt)-Sum(CrAmt)
			From Rpt_AccTrialBalgl  l where vdt <= @vdt + ' 23:59:59'  
			group by l.Cltcode , l.acname 
			order by  l.acname , l.Cltcode

	end
	end
              end  /* of normal balance */  		
	

end

GO
