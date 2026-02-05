-- Object: PROCEDURE citrus_usr.DPBM_USP_GET_EXPORT_FOR_CDSL_INSERT
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[DPBM_USP_GET_EXPORT_FOR_CDSL_INSERT]        
(          
@UploadedDate DATETIME,      
@TYPE varchar(50)        
)          
AS
BEGIN              
if @TYPE = 'INSERT'      
begin      
SELECT           
 '1' as bk_id,MICR_CODE as bk_micr,IFSC_CODE as bk_branch,        
 BANK_NAME as bk_name,        
 ADD1 as bk_add1,ADD2 as bk_add2,ADD3 as bk_add3,city as bk_city,STATE as bk_state,COUNTRY as bk_country,      
 PIN_CODE as bk_pin,'' as bk_tele1,'' as bk_tele2,'' as bk_fax,BRANCH_NAME as bk_email,'' as bk_conname,      
 BRANCH_MNGR as bk_condesg      
FROM DPBM_BANK_MASTER_UPLOAD WHERE STATUS='I'           
AND                       
(CONVERT(DATETIME,CONVERT(VARCHAR,MODIFIED_DATE,106)) = @UploadedDate)            
end      
if @TYPE = 'UPDATE'      
begin      
  SELECT           
  '1' as bk_id,MICR_CODE as bk_micr,IFSC_CODE as bk_branch,BANK_NAME as bk_name,        
  ADD1 as bk_add1,ADD2 as bk_add2,ADD3 as bk_add3,city as bk_city,STATE as bk_state,      
  COUNTRY as bk_country,PIN_CODE as bk_pin,'' as bk_tele1,'' as bk_tele2,'' as bk_fax,      
  BRANCH_NAME as bk_email,'' as bk_conname,BRANCH_MNGR as bk_condesg      
  FROM DPBM_BANK_MASTER_UPLOAD       
  WHERE STATUS='U'           
  AND                       
  (CONVERT(DATETIME,CONVERT(VARCHAR,MODIFIED_DATE,106)) = @UploadedDate)            
end      
END

GO
