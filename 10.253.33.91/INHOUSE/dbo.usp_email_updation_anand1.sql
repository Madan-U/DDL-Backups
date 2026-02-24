-- Object: PROCEDURE dbo.usp_email_updation_anand1
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------



CREATE proc [dbo].[usp_email_updation_anand1]
as

--select party_code  into #Anand1client_details from msajag.dbo.client_details with (nolock)  
select * 
into #temp_email_updation 
from [MIDDLEWARE].inhouse.dbo.temp_email_updation  

begin tran 
	update y
	set email=x.modifiedemail, status = 'I',imp_status =0,ModifidedOn=GETDATE() 
	from #temp_email_updation x,msajag.dbo.client_details y with (nolock)
	where ltrim(rtrim(x.party_code))=ltrim(rtrim(y.party_code))
commit tran

GO
