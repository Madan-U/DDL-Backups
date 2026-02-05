-- Object: PROCEDURE citrus_usr.HTTP_REQUEST
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

    
    
CREATE PROCEDURE [Citrus_usr].[HTTP_REQUEST]    
(     
@URI varchar(max),     
@response varchar(8000) OUT    
)    
AS    
    
DECLARE    
@xhr INT    
,@result INT    
,@httpStatus INT    
,@msg VARCHAR(255)    
    
    
EXEC @result = sp_OACreate 'MSXML2.XMLHttp.5.0', @xhr OUT    
    
IF @result <> 0 BEGIN RAISERROR('sp_OACreate on MSXML2.XMLHttp.5.0 failed', 16,1) RETURN     
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
IF @result <>0 BEGIN RAISERROR('sp_OAMethod read response failed', 16,1) RETURN     
END    
    
EXEC @result = sp_OADestroy @xhr    
    
RETURN

GO
