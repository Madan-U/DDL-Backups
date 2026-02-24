-- Object: PROCEDURE citrus_usr.useravialablity
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROC [citrus_usr].[useravialablity]
@username varchar(100)
AS
IF  EXISTS(SELECT * FROM information WHERE username = @username)
raiserror('user Already Exists',16,1)
else 
raiserror('user Name is Available ',16,1)

GO
