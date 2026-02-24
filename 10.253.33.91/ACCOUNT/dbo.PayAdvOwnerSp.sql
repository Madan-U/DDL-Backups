-- Object: PROCEDURE dbo.PayAdvOwnerSp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.PayAdvOwnerSp    Script Date: 20-Mar-01 11:43:34 PM ******/


/*
Created by vaishali on 26/12/2000
Used inthe PaymentAdvice control
*/
CREATE PROCEDURE PayAdvOwnerSp

 AS

Select preprintchq from msajag.dbo.owner

GO
