-- Object: PROCEDURE citrus_usr.CLASS_AUTO_GET_PROCESS_FOR
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create procedure [citrus_usr].[CLASS_AUTO_GET_PROCESS_FOR]     
(    
 @PROCESS_TYPE VARCHAR(max)    
)    
AS    
BEGIN    
 SELECT PROCESS_FOR FROM TBL_AUTO_PROCESS_MASTER WHERE PROCESS_TYPE= @PROCESS_TYPE    
END

GO
