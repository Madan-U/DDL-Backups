-- Object: PROCEDURE citrus_usr.DPBM_USP_GETCDSL_FILE_DETAILS
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[DPBM_USP_GETCDSL_FILE_DETAILS]      
as
begin              
select ROW_ID,MICR_CODE AS [MICR CODE],IFSC_CODE AS [IFSC CODE],BANK_NAME AS [BANK NAME],BRANCH_NAME AS[BRANCH NAME],ADD1,ADD2,ADD3,CITY,STATE,COUNTRY,PIN_CODE AS [PIN CODE],STATUS,BRANCH_MNGR as [Branch Desg] FROM DPBM_BANK_MASTER_UPLOAD where status is null
end

GO
