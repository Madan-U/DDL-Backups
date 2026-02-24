-- Object: PROCEDURE dbo.CLASS_VALIDATE_ADMIN
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE [dbo].[CLASS_VALIDATE_ADMIN]    
(    
    @ADMINID     VARCHAR(50),    
    @IPADDRESS  VARCHAR(20),    
    @RETCODE    INT  OUTPUT,    
    @RETMSG     VARCHAR(200)  OUTPUT,    
    @UM_SESSION UNIQUEIDENTIFIER  OUTPUT,    
    @LASTLOGIN VARCHAR(40) OUTPUT    
)    
AS    

  DECLARE  @@USER_COUNT TINYINT    
  DECLARE  @@LASTLOGIN VARCHAR(40)      
  DECLARE  @@USER_SESSION VARCHAR(200)    
    
                              
  SELECT @@USER_COUNT = COUNT(1)    
  FROM   TBLCLASSADMINLOGINS (NOLOCK)    
  WHERE  FLDADMINNAME = @ADMINID    
                        
  IF ISNULL(@@USER_COUNT,0) = 0    
    BEGIN    
      INSERT INTO TBLCLASSADMINLOGINS    
	  (    
	   FLDAUTO,    
	   FLDADMINNAME,    
	   FLDSTATUS,    
	   FLDSTNAME,    
	   FLDSESSION,    
	   FLDIPADDRESS,    
	   FLDLASTVISIT,    
	   FLDTIMEOUTPRD    
	  )  
	  SELECT A.FLDAUTO_ADMIN,    
		A.FLDNAME,    
		A.FLDSTATUS,    
		A.FLDSTNAME,    
		'',    
		'',    
		GETDATE(),    
		''   
	  FROM   TBLADMIN A (NOLOCK)    
	  WHERE  A.FLDNAME = @ADMINID   
                                 
	  IF @@ERROR <> 0    
		BEGIN    
		 SET @RETCODE = 0    
		 SET @RETMSG = 'UNABLE TO FETCH USER INFORMATION'    
		 RETURN    
		END    
	END    
        
    
 SELECT @@LASTLOGIN = CONVERT(VARCHAR,ISNULL(FLDLASTLOGIN,''),113)    
 FROM TBLCLASSADMINLOGINS    
 WHERE FLDADMINNAME = @ADMINID    
    
    
 SET @@USER_SESSION = NEWID()    
                           
 UPDATE TBLCLASSADMINLOGINS    
 SET    FLDIPADDRESS = @IPADDRESS,    
   FLDSESSION = @@USER_SESSION,    
   FLDLASTVISIT = GETDATE(),    
   FLDLASTLOGIN = GETDATE()    
 WHERE  FLDADMINNAME = @ADMINID    
                            
  IF @@ERROR <> 0    
    BEGIN    
  SET @RETCODE = 0    
  SET @RETMSG = 'UNABLE TO UPDATE LOGIN INFORMATION'    
  RETURN    
    END    
        
  SET @RETCODE = 1    
  SET @RETMSG = 'USER LOGGED IN SUCCESSFULLY'    
  SET @UM_SESSION = @@USER_SESSION    
  SET @LASTLOGIN = @@LASTLOGIN                    
  RETURN

GO
