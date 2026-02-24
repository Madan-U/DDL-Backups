-- Object: PROCEDURE dbo.PR_Client_Status_Flag
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc [dbo].[PR_Client_Status_Flag] (@party_code varchar(10))
AS

If @party_code ='A115390'
	 begin
	  Select cl_code='A115390',Status_Flag='D'
	 End 
Else 
	Begin 
		Select Cl_code ,Max(isnull(deactive_value,'')) As Status_Flag from CLIENT_BROK_DETAILS
		where Cl_Code=@party_code
		Group By Cl_code
   End

GO
