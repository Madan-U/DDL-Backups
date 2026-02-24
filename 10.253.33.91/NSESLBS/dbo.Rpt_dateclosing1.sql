-- Object: PROCEDURE dbo.Rpt_dateclosing1
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


/*  
This Procedure Is Written By Neelambari On 10 May 2001  
This Procedure Gives All Distinct Dates From Closing Table  
*/  

CREATE  Proc [dbo].[Rpt_dateclosing1] As  
Select Distinct Left(convert(varchar,sysdate,109),11) ,convert(varchar,sysdate,101)  
From Closing  
Order By Convert(varchar,sysdate,101)

GO
