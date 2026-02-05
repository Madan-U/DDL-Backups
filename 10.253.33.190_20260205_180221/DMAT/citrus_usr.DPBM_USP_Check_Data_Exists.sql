-- Object: PROCEDURE citrus_usr.DPBM_USP_Check_Data_Exists
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[DPBM_USP_Check_Data_Exists]        
(        
@MICR VARCHAR(50),        
@BANKNAME VARCHAR(500),
@BRNAME varchar(200)                
)         
as
begin       
IF EXISTS(SELECT BK_NAME,bk_email 
--FROM [192.168.3.25].acercross.dbo.DPBM_Bank_Master with (nolock)       
FROM DPBM_Bank_Master with (nolock)
WHERE bk_name = @BANKNAME and bk_email = @BRNAME)
BEGIN     
select bk_add1 as [Add1],bk_add2 as [Add2],bk_add3 as [Add3],bk_City as [City],bk_State as [State],      
bk_branch as [IFSC Code],bk_pin as [Pin Code],bk_Country as [Country],bk_condesg as [Br Desg]    
--FROM [192.168.3.25].acercross.dbo.DPBM_Bank_Master with (nolock)       
FROM DPBM_Bank_Master with (nolock)       
WHERE bk_name = @BANKNAME and bk_email = @BRNAME
END
--ELSE IF EXISTS (SELECT BANK_NAME FROM DPBM_DPBM_BANK_MASTER_UPLOAD where MICR_CODE = @MICR AND BANK_NAME  = @BANKNAME )
--BEGIN
--Select add1,add2,add3,city,state,IFSC_CODE,PIN_CODE,COUNTRY,BRANCH_MNGR
--FROM DPBM_DPBM_BANK_MASTER_UPLOAD
--where MICR_CODE = @MICR AND BANK_NAME  = @BANKNAME 
--END
end

GO
