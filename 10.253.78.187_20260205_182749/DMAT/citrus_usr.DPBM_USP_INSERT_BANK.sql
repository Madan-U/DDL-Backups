-- Object: PROCEDURE citrus_usr.DPBM_USP_INSERT_BANK
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[DPBM_USP_INSERT_BANK]      
(    
@BANKNAME varchar(100)    
)    
AS
BEGIN    
IF NOT EXISTS(SELECT BANK_NAME FROM DPBM_BANK_NAME_MASTER WHERE STATUS=1  and Bank_name = @BANKNAME)  
BEGIN      
INSERT INTO DPBM_BANK_NAME_MASTER(BANK_NAME,CREATED_DATE) VALUES (@BANKNAME,GETDATE())    
END  
else
begin
update DPBM_BANK_NAME_MASTER set Status =1,MODIFIED_DATE = GETDATE() where BANK_NAME = @BANKNAME and Status = 0
end
END

GO
