-- Object: PROCEDURE dbo.rpt_maxcrbal1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_maxcrbal1    Script Date: 01/19/2002 12:15:15 ******/

/****** Object:  Stored Procedure dbo.rpt_maxcrbal1    Script Date: 01/04/1980 5:06:27 AM ******/


/*  store procedure written on 27 th sept 2001 
    to calculate  maximum credit balance 
    written by shilpa */
CREATE proc rpt_maxcrbal1

@openingentry datetime,
@inputdt datetime,
@cltcode  varchar(12) 

as
if @openingentry <> ' ' 
	begin
		 select min(balamt) from account.dbo.ledger where cltcode=@cltcode  
	        	and  balamt < 0  and  vdt >= @openingentry and vdt <= @inputdt + ' 23:59:59'  
	end
else
	begin
	            select min(balamt) from account.dbo.ledger 
		where cltcode=@cltcode	 and  balamt < 0  and   vdt <= @inputdt + ' 23:59:59'
end

GO
