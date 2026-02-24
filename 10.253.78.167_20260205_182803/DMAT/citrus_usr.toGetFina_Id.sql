-- Object: FUNCTION citrus_usr.toGetFina_Id
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create function [citrus_usr].[toGetFina_Id](@pa_id varchar(100))
returns varchar(100)
as
begin
  DECLARE @l_value  varchar(100)     
select @l_value =  fina_acc_code from fin_account_mstr where fina_acc_id=@pa_id and FINA_DELETED_IND=1 
 return @l_value 
end

GO
