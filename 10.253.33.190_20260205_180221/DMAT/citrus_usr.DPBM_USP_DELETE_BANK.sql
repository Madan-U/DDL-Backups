-- Object: PROCEDURE citrus_usr.DPBM_USP_DELETE_BANK
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[DPBM_USP_DELETE_BANK]  
(  
@BANKNAME VARCHAR(100)              
)   
AS
BEGIN          
UPDATE DPBM_BANK_NAME_MASTER SET STATUS=0 , MODIFIED_DATE = getdate() WHERE BANK_NAME = @BANKNAME
END

GO
