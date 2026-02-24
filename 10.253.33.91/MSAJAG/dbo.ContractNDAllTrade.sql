-- Object: PROCEDURE dbo.ContractNDAllTrade
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ContractNDAllTrade    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.ContractNDAllTrade    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.ContractNDAllTrade    Script Date: 20-Mar-01 11:38:48 PM ******/

Create Procedure ContractNDAllTrade as 
Begin
if ( Select Count(*) From Owner Where Mainbroker > 0 ) > 0
 Exec GenSubContract
Exec GenNDContract
End

GO
