-- Object: PROCEDURE dbo.CHECK_USER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC [dbo].[CHECK_USER]      
(      
 @UID VARCHAR(50),      
 @STNAME VARCHAR(50),      
 @RESULT INT OUTPUT      
)       
/*      
CHECK_USER 'DFS','',''
      
SELECT * FROM MSAJAG..CLIENT_DETAILS WHERE CL_CODE = '00000031'       
SELECT * FROM TBLPRADNYAUSERS WHERE FLDUSERNAME ='TEST'
*/       
     
AS      
 DECLARE @COUNT SMALLINT      
       
SET @COUNT = 0       
      
IF UPPER(@STNAME) = 'CLIENT'      
 BEGIN      
 SELECT @COUNT = COUNT(*) FROM MSAJAG.DBO.CLIENT_DETAILS WHERE CL_CODE = @UID      
       
 IF @COUNT = 0       
  BEGIN      
  SET @RESULT = 2 --'NOTEXISTS'      
  SELECT @RESULT      
  RETURN      
  END      
 END       

SELECT @COUNT = COUNT(FLDNAME) FROM TBLUSERBLOCK WHERE FLDNAME LIKE '%'+@UID OR FLDNAME LIKE @UID+'%'
IF @COUNT <> 0       
 BEGIN      
 SET @RESULT = 4 --'INVALID'      
 SELECT @RESULT      
 RETURN      
 END      

      
SELECT       
 @COUNT = COUNT(FLDUSERNAME) FROM TBLPRADNYAUSERS (NOLOCK) WHERE FLDUSERNAME LIKE @UID      
      
IF @COUNT <> 0       
 BEGIN      
 SET @RESULT = 1 --'EXSITSINMASTER'      
 SELECT @RESULT      
 RETURN      
 END      
ELSE      
 BEGIN      
 SET @RESULT = 0 --'OK'      
 SELECT @RESULT      
 RETURN      
 END

GO
