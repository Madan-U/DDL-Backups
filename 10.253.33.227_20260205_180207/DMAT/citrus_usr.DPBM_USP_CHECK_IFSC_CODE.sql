-- Object: PROCEDURE citrus_usr.DPBM_USP_CHECK_IFSC_CODE
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[DPBM_USP_CHECK_IFSC_CODE]          
(          
@MICR VARCHAR(50),          
@BRANCHNAME VARCHAR(500)                     
)           
as
begin                  
select      
bk_branch as [IFSC Code]    
--FROM [192.168.3.25].acercross.dbo.DPBM_Bank_Master with (nolock)         
FROM DPBM_Bank_Master with (nolock)         
WHERE bk_micr = @MICR AND bk_email = @BRANCHNAME
end

GO
