-- Object: FUNCTION citrus_usr.fn_get_last_Clo_dt
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_get_last_Clo_dt](@@isin varchar(20),@holding_dt datetime)  returns datetime    
as    
begin    
declare @@retdate datetime    
     
    select top 1 @holding_dt  = CLOPM_DT 
    from   CLOSING_PRICE_MSTR_NSDL 
    WHERE CLOPM_ISIN_CD = @@isin 
    and CLOPM_DT <= @holding_dt 
    and CLOPM_DELETED_IND = 1
    order by CLOPM_DT desc
    
         
    set @@retdate = @holding_dt      
 return @@retdate    
    
end

GO
