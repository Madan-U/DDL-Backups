-- Object: PROCEDURE dbo.ContractAllTrade
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Procedure [dbo].[ContractAllTrade] as 
Begin
/* Removed By BBG 22 Aug */
/* Delete From TradeCon */
/* Insert into TradeCon Select * from Confirmview */
Exec BBGDirectGenContract
End

GO
