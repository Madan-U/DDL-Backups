-- Object: PROCEDURE citrus_usr.DPBM_USP_Insert_Update_BankDetails
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[DPBM_USP_Insert_Update_BankDetails]
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

Insert into DPBM_Bank_Master (bk_id,bk_micr,bk_branch,bk_name,bk_add1,bk_add2,bk_add3,bk_city,bk_state,bk_country,bk_pin,bk_email,bk_condesg)
values
(
'1',@MICR,@IFSC,@BKNAME,@Add1,@Add2,@Add3,@CITY,@STATE,@COUNTRY,@PINCODE,@BRNAME,@bk_condesg
)

SELECT @intErrorCode = @@ERROR
    IF (@intErrorCode <> 0) GOTO PROBLEM

update DPBM_BANK_MASTER_UPLOAD  
set 
BANK_NAME = @BKNAME,
BRANCH_NAME = @BRNAME,
ADD1 = @Add1,
ADD2 = @Add2,
ADD3 = @Add3,
CITY = @CITY,
STATE = @STATE,
COUNTRY = @COUNTRY,
PIN_CODE = @PINCODE,
IFSC_CODE = @IFSC,
BRANCH_MNGR = @bk_condesg,
STATUS = 'I',
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
