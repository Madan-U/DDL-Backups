-- Object: PROCEDURE citrus_usr.procchecklogin
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


CREATE proc procchecklogin (@action varchar(10),@u varchar(100),@p varchar(100),@e varchar (50))  
  
  
  
as  
begin   
if @action = 'get'   
begin  
SELECT [Username] FROM [dbo].[System_Users] WHERE [Username] = @u AND [Password] = @p  
end   
else  
insert into [dbo].[System_Users](Username,password,Email)values(@u,@p,@e)  
  
  
  
end

GO
