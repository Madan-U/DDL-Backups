-- Object: PROCEDURE dbo.rpt_maxdrbal1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_maxdrbal1    Script Date: 01/19/2002 12:15:15 ******/

/****** Object:  Stored Procedure dbo.rpt_maxdrbal1    Script Date: 01/04/1980 5:06:27 AM ******/


/*   written by shilpa  
      this store procedure is used in  "Ageing Report"
*/
CREATE proc rpt_maxdrbal1

@openingentry datetime,
@inputdt datetime,
@cltcode  varchar(12) 

as
if @openingentry <> ' ' 
	begin
	       select max(balamt) from rpt_ageingview  where cltcode=@cltcode  
	       and balamt >0 and  vdt >= @openingentry and vdt <= @inputdt + ' 23:59:59'  
	end
else
	begin
	       select max(balamt) from rpt_ageingview  where cltcode=@cltcode
	       and balamt >0  and   vdt <= @inputdt + ' 23:59:59'
end

GO
