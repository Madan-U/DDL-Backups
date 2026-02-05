-- Object: PROCEDURE citrus_usr.PR_select_login_TP
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create  Procedure [citrus_usr].[PR_select_login_TP](@tab varchar(10),@logn_name  varchar(800))
as
if PATINDEX('%[^a-zA-Z0-9]%' , @logn_name) = 0
begin
begin
if @tab ='CHNGP'
  Select logn_name , logn_pswd from login_names where logn_name = @logn_name
else if @tab ='forget'
select logn_name,Logn_PSWD,logn_usr_email from login_names where logn_name = @logn_name and logn_deleted_ind =1 

end
end

GO
