-- Object: PROCEDURE citrus_usr.DPBM_USP_Update_BankDetails
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[DPBM_USP_Update_BankDetails]          
(        
@BKNAME varchar(500),        
@BRNAME varchar(200),        
@Add1 varchar(500),        
@Add2 varchar(500),        
@Add3 varchar(500),        
@PINCODE varchar(12),        
@CITY varchar(100),        
@STATE varchar(100),        
@COUNTRY varchar(100),        
@IFSC varchar(15),        
@MICR varchar(15),        
@bk_condesg varchar(50)        
)         
AS
BEGIN             
DECLARE @intErrorCode INT    
    
BEGIN TRAN    
        
update DPBM_Bank_Master        
set        
bk_name = @BKNAME,        
bk_add1 = @Add1,        
bk_add2 = @Add2,        
bk_add3 = @Add3,        
bk_city = @CITY,        
bk_state = @STATE,        
bk_country = @COUNTRY,        
bk_pin = @PINCODE,        
bk_branch = @IFSC,        
bk_condesg = @bk_condesg,      
bk_email = @BRNAME      
where bk_micr = @MICR and bk_name = @BKNAME --and bk_branch = @IFSC        
    
SELECT @intErrorCode = @@ERROR    
    IF (@intErrorCode <> 0) GOTO PROBLEM    
        
update DPBM_BANK_MASTER_UPLOAD          
set         
BANK_NAME = @BKNAME,        
ADD1 = @Add1,        
ADD2 = @Add2,        
ADD3 = @Add3,        
CITY = @CITY,        
STATE = @STATE,        
COUNTRY = @COUNTRY,        
PIN_CODE = @PINCODE,        
IFSC_CODE = @IFSC,        
BRANCH_MNGR = @bk_condesg,    
BRANCH_NAME = @BRNAME,        
STATUS = 'U',        
MODIFIED_DATE = getdate()       
where MICR_CODE = @MICR --and BANK_NAME = @BKNAME --and IFSC_CODE = @IFSC 
    
SELECT @intErrorCode = @@ERROR    
    IF (@intErrorCode <> 0) GOTO PROBLEM    
COMMIT TRAN    
    
PROBLEM:    
IF (@intErrorCode <> 0) BEGIN    
PRINT 'Unexpected error occurred!'    
    ROLLBACK TRAN    
END    
    
    
end

GO
