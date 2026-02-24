-- Object: PROCEDURE dbo.HTTP_REQUEST
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE [dbo].[HTTP_REQUEST]        
(         
@URI varchar(max),         
@response varchar(max) OUT        
)        
AS        
        
DECLARE        
@xhr INT        
,@result INT        
,@httpStatus INT        
,@msg VARCHAR(255),        
@RES_TEXT varchar(max)        
        
EXEC @result = sp_OACreate 'MSXML2.XMLHttp.6.0', @xhr OUT        
        
IF @result <> 0 BEGIN RAISERROR('sp_OACreate on MSXML2.XMLHttp.6.0 failed', 16,1) RETURN         
END        
        
EXEC @result = sp_OAMethod @xhr, 'open', NULL, 'GET', @URI, false        
IF @result <>0 BEGIN RAISERROR('sp_OAMethod Open failed', 16,1) RETURN         
END        
  
EXEC @result = sp_OAMethod @xhr, SEND, NULL, ''        
IF @result <>0 BEGIN RAISERROR('sp_OAMethod SEND failed', 16,1) RETURN         
END        
        
EXEC @result = sp_OAGetProperty @xhr, 'status', @httpStatus OUT        
        
IF @result <>0         
    BEGIN RAISERROR('sp_OAMethod read status failed', 16,1) RETURN         
    END        
        
IF @httpStatus <> 200 BEGIN RAISERROR('sp_OAMethod http status bad', 16,1) RETURN         
END        
        
EXEC @result = sp_OAGetProperty @xhr, 'responseText', @response OUT    
  
--IF @result <>0 BEGIN RAISERROR('sp_OAMethod read response failed', 16,1)   
-- RETURN         
--END        
        
EXEC @result = sp_OADestroy @xhr        
        
  
RETURN

GO
