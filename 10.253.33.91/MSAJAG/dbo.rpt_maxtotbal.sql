-- Object: PROCEDURE dbo.rpt_maxtotbal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_maxtotbal    Script Date: 01/19/2002 12:15:15 ******/

/****** Object:  Stored Procedure dbo.rpt_maxtotbal    Script Date: 01/04/1980 5:06:27 AM ******/


CREATE proc rpt_maxtotbal

@openingentry datetime,
@inputdt  datetime,
@cltcode  varchar(12) 

as
if @openingentry <> ' ' 
	begin
	        select finalamt =sum(balamt*actNoDays) from  rpt_ageingview  where cltcode=@cltcode
	         and  vdt >= @openingentry and vdt <= @inputdt + ' 23:59:59'  
	end
else
	begin
	       select  finalamt=sum(balamt*actNoDays)  from rpt_ageingview  where cltcode=@cltcode
	 and   vdt <= @inputdt + ' 23:59:59'
end

GO
