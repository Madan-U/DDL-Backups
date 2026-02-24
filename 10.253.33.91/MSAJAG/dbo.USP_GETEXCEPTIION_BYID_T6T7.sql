-- Object: PROCEDURE dbo.USP_GETEXCEPTIION_BYID_T6T7
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE USP_GETEXCEPTIION_BYID_T6T7  
@ExceptionID INT      
AS      
BEGIN      
 SELECT ExceptionID, AccessLevel,AccessCode,ValidFrom,ValidTo,Status,CreateDt,CreateBy,ModifyDt,ModifyBy,SQ_OFF_TYPE    
 FROM SQuareUp_Exception_T6T7  
 WHERE ExceptionID = @ExceptionID      
END

GO
