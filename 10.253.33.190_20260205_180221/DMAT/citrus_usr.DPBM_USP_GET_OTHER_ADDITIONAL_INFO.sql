-- Object: PROCEDURE citrus_usr.DPBM_USP_GET_OTHER_ADDITIONAL_INFO
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[DPBM_USP_GET_OTHER_ADDITIONAL_INFO]        
(        
@ROWID numeric(18,0)               
)         
as
begin            
SELECT MICR_CODE,IFSC_CODE,BANK_NAME,BRANCH_NAME,ADD1,ADD2,ADD3,CITY,STATE,COUNTRY,PIN_CODE,BRANCH_MNGR
FROM DPBM_BANK_MASTER_UPLOAD      
WHERE ROW_ID = @ROWID
end

GO
