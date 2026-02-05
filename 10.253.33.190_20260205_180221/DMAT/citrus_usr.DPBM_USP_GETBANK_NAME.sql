-- Object: PROCEDURE citrus_usr.DPBM_USP_GETBANK_NAME
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[DPBM_USP_GETBANK_NAME]  
(  
@SEARCH VARCHAR(50)              
)   
as
begin          
select distinct BANK_NAME FROM DPBM_BANK_NAME_MASTER WHERE BANK_NAME LIKE @SEARCH + '%'  and status=1
end

GO
