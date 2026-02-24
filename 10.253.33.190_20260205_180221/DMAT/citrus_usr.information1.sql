-- Object: PROCEDURE citrus_usr.information1
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[information1]          
  @Flag char(1),      
  @username varchar(100),      
  @passward varchar(100),      
  @name varchar(100),      
  @CorresAdd varchar(100),      
  @PermanentAdd varchar(100),      
  @email varchar(100),      
  @mobileNo varchar(15),      
  @degree varchar(5)  
  --@empimg varchar(1000)     
as    
IF NOT EXISTS(SELECT * FROM information WHERE username = @username)    
  begin    
INSERT INTO information       
 (      
   username,      
   passward,      
   name,      
   CorresAdd,      
   PermanentAdd,      
   email,      
   mobileNo,      
   degree  
   --empimg      
  )      
VALUES       
 (      
   @username,      
   @passward,      
   @name,      
   @CorresAdd,      
   @PermanentAdd,      
   @email,      
   @mobileNo,      
   @degree  
   --@empimg   
 )      
end    
else     
begin    
raiserror('user Already Exists',16,1)    
end

GO
