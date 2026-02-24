-- Object: PROCEDURE dbo.PR_Client_Status_Flag_DUMP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
  Create Proc PR_Client_Status_Flag_DUMP 
  As
  Select Distinct Cl_code ,Max(isnull(deactive_value,'')) As Status_Flag from CLIENT_BROK_DETAILS  (NOlock)
  where deactive_value='D'
  Group By Cl_code

GO
