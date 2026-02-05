-- Object: PROCEDURE citrus_usr.login1
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[login1]    
@userName varchar(100)    
as    
if exists(select * from information where username=@username)    
raiserror('User Exists',16,1)    
else    
raiserror('User Not Exists',16,1)

GO
