-- Object: PROCEDURE citrus_usr.DPBM_USP_GETBANK_NAME_DP
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[DPBM_USP_GETBANK_NAME_DP]        
(        
@MICR VARCHAR(50)                    
)         
as
begin                
select distinct bk_name       
--FROM [192.168.3.25].acercross.dbo.DPBM_Bank_Master with (nolock)       
FROM DPBM_Bank_Master with (nolock)       
WHERE bk_micr = @MICR
end

GO
