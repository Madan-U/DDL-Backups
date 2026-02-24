-- Object: PROCEDURE citrus_usr.DPBM_USP_GET_BANK_DEAILS
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[DPBM_USP_GET_BANK_DEAILS]        
(        
@MICR VARCHAR(50),        
@BANKNAME VARCHAR(500)                   
)         
as
begin                
select bk_add1 as [Add1],bk_add2 as [Add2],bk_add3 as [Add3],bk_City as [City],bk_State as [State],      
bk_branch as [IFSC Code],bk_pin as [Pin Code],bk_Country as [Country],bk_condesg as [Br Desg]    
--FROM [192.168.3.25].acercross.dbo.DPBM_Bank_Master with (nolock)       
FROM DPBM_Bank_Master with (nolock)       
WHERE bk_micr = @MICR AND bk_name like + '%' +@BANKNAME + '%'      
end

GO
