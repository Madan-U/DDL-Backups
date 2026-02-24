-- Object: PROCEDURE citrus_usr.DPBM_USP_Update_BankDetails_NoChange
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[DPBM_USP_Update_BankDetails_NoChange]
(
@IFSC varchar(15),
@MICR varchar(15)
) 
AS
BEGIN     
update DPBM_BANK_MASTER_UPLOAD  
set 
STATUS = 'N',
MODIFIED_DATE = getdate()
where MICR_CODE = @MICR and IFSC_CODE = @IFSC
end

GO
