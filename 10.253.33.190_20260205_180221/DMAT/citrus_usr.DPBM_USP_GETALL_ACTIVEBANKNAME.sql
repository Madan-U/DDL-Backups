-- Object: PROCEDURE citrus_usr.DPBM_USP_GETALL_ACTIVEBANKNAME
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[DPBM_USP_GETALL_ACTIVEBANKNAME]      
as
begin              
select distinct ID,BANK_NAME AS [BANK NAME] FROM DPBM_BANK_NAME_MASTER WHERE STATUS =1    
ORDER BY BANK_NAME  
end

GO
