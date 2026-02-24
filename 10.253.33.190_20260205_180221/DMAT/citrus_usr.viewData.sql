-- Object: PROCEDURE citrus_usr.viewData
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[viewData]  
   
 @userName varchar(100)   
as   
  select username,name,CorresAdd,PermanentAdd,email,mobileNo,degree  from information where   username = @username

GO
