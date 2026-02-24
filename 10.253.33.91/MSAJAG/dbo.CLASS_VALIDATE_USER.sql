-- Object: PROCEDURE dbo.CLASS_VALIDATE_USER
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
    
    
      
CREATE PROCEDURE [dbo].[CLASS_VALIDATE_USER]      
(      
                @USERID     VARCHAR(50),      
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
  FROM   TBLCLASSUSERLOGINS (NOLOCK)      
  WHERE  FLDUSERNAME = @USERID      
                             
  IF ISNULL(@@USER_COUNT,0) = 0      
    BEGIN      
          
  INSERT INTO TBLCLASSUSERLOGINS      
  (      
   FLDAUTO,      
   FLDUSERNAME,      
   FLDSTATUS,      
   FLDSTNAME,      
   FLDSESSION,      
   FLDIPADDRESS,      
   FLDLASTVISIT,      
   FLDTIMEOUTPRD      
  )      
  SELECT P.FLDAUTO,      
     P.FLDUSERNAME,      
     A.FLDSTATUS,      
     P.FLDSTNAME,      
     '',      
     '',      
     GETDATE(),      
     ISNULL(M.FLDTIMEOUT,1)      
  FROM   TBLPRADNYAUSERS P (NOLOCK)      
     LEFT OUTER JOIN TBLUSERCONTROLMASTER M (NOLOCK)      
    ON (M.FLDUSERID = P.FLDAUTO)      
     INNER JOIN TBLADMIN A (NOLOCK)      
    ON (P.FLDADMINAUTO = A.FLDAUTO_ADMIN)      
  WHERE  P.FLDUSERNAME = @USERID      
                                   
  IF @@ERROR <> 0      
    BEGIN      
   SET @RETCODE = 0      
                 
   SET @RETMSG = 'UNABLE TO FETCH USER INFORMATION'      
                 
   RETURN      
    END      
              
    END      
          
      
     SELECT @@LASTLOGIN = CONVERT(VARCHAR,ISNULL(FLDLASTLOGIN,''),113)      
 FROM TBLCLASSUSERLOGINS      
 WHERE FLDUSERNAME = @USERID      
      
      
 SET @@USER_SESSION = NEWID()      
                             
 UPDATE TBLCLASSUSERLOGINS      
 SET    FLDIPADDRESS = @IPADDRESS,      
   FLDSESSION = @@USER_SESSION,      
   FLDLASTVISIT = GETDATE(),      
   FLDLASTLOGIN = GETDATE()      
 WHERE  FLDUSERNAME = @USERID      
                              
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
