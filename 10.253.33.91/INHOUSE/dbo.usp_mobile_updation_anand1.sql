-- Object: PROCEDURE dbo.usp_mobile_updation_anand1
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------



CREATE proc [dbo].[usp_mobile_updation_anand1]
as       
--select party_code  into #Anand1client_details from msajag.dbo.client_details with (nolock)      

select * 
into #temp_mobile_updation 
from [MIDDLEWARE].inhouse.dbo.temp_mobile_updation  
  
begin tran                                                                
	update y
	set mobile_pager=x.modifiedno, status = 'I',imp_status =0,ModifidedOn=GETDATE() 
	from #temp_mobile_updation x, msajag.dbo.client_details y with (nolock)
	where ltrim(rtrim(x.party_code))=ltrim(rtrim(y.party_code))
commit tran

GO
