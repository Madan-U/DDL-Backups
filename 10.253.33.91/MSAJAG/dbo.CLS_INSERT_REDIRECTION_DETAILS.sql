-- Object: PROCEDURE dbo.CLS_INSERT_REDIRECTION_DETAILS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc [dbo].[CLS_INSERT_REDIRECTION_DETAILS]  
(
  @Token Varchar(50),  
  @LoginID Varchar(50),  
  @ReturnPath Varchar(500),
  @Return_Time int
 )

As  
  BEGIN
		Insert into CLS_LOGIN_REDIRECT  (Token,LoginID,ReturnPath,Return_Time) Values
		(@Token,@LoginID,@ReturnPath,@Return_Time)  

  END

GO
