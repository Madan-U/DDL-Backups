-- Object: FUNCTION citrus_usr.fn_toget_logintype
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create function fn_toget_logintype  
(@pa_login_name varchar(50))  
returns varchar(800)  
  
as  
begin   
declare @l_chr varchar(800)  
select top 1 @l_chr =  logn_ent_id from login_names where logn_name = @pa_login_name and logn_deleted_ind=1  
return @l_chr  
end

GO
