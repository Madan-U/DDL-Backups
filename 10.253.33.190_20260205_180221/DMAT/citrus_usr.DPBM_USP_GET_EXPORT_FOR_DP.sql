-- Object: PROCEDURE citrus_usr.DPBM_USP_GET_EXPORT_FOR_DP
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[DPBM_USP_GET_EXPORT_FOR_DP]          
(            
@UploadedDate DATETIME            
)            
AS
BEGIN                
SELECT             
          
BANK_NAME as[BANKNAME],          
case when IFSC_CODE='1' then ''           
when IFSC_CODE = 'D' then '' else IFSC_CODE end as [IFSCCODE],          
MICR_CODE as [MICRCODE],          
BRANCH_NAME as [BRANCHNAME],      
ADD1 + ',' + ADD2 + ',' + ADD3 + ',' + CITY AS [ADDRESS],      
'' AS [CONTACT],      
BRANCH_NAME AS [CENTRE],      
CITY AS [DISTRICT],      
STATE AS [STATE]      
FROM DPBM_BANK_MASTER_UPLOAD WHERE STATUS='I'             
AND                         
--(CONVERT(DATETIME,CONVERT(VARCHAR,UPLOADED_DATE,106)) = @UploadedDate)            
(CONVERT(DATETIME,CONVERT(VARCHAR,MODIFIED_DATE,106)) = @UploadedDate)            
            
         
--AND U.BRANCH_NAME = R.BRANCH_NAME            
END

GO
