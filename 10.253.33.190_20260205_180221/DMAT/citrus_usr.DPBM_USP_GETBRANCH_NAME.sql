-- Object: PROCEDURE citrus_usr.DPBM_USP_GETBRANCH_NAME
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[DPBM_USP_GETBRANCH_NAME]      
(      
@MICR VARCHAR(50)                  
)       
as
begin              
select bk_email as [Branch Name],bk_branch as [IFSC Code],bk_name     
--FROM [192.168.3.25].acercross.dbo.DPBM_Bank_Master with (nolock)     
FROM DPBM_Bank_Master with (nolock)     
WHERE bk_micr = @MICR      
end

GO
