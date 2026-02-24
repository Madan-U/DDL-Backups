-- Object: PROCEDURE dbo.CLS_LogException
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROCEDURE [dbo].[CLS_LogException]  
(  
    @ExceptionMessage nvarchar(max),  
    @Source Varchar(50)  ,
	@RefNo nvarchar(100)
)  
  
AS  
BEGIN  
        SET NOCOUNT ON;  
    INSERT INTO [CLS_tblExceptionLog]  
    ([ExceptionMesage]  
    ,[LogDate]  
    ,[Source]  
    ,[Trace]
	,[RefNo]
	)  
    VALUES  
    (@ExceptionMessage,GETDATE(),@Source,'',@RefNo)  
END

GO
