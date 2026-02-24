-- Object: PROCEDURE dbo.CLS_ADMINLIST
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create PROC [dbo].[CLS_ADMINLIST]      
(      
 @ADMIN_USER VARCHAR(30)       
)      
/*      
 EXEC CLS_ADMINLIST 'ADMINISTRATOR'      
 EXEC CLS_ADMINLIST 'BRANCH'      
 SELECT * FROM TBLADMIN  
 select * from tblAdminConfig  
*/      
AS      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED       
IF RTRIM(LTRIM(UPPER(@ADMIN_USER))) <> 'ADMINISTRATOR'      
 BEGIN      
  SELECT    
   SRNO = FLDAUTO_ADMIN,        
   FLDNAME,       
   FLDSTATUS,       
   FLDAUTO_ADMIN,       
   FLDCOMPANY,       
   FLDDESC       
  FROM       
   TBLADMIN A(NOLOCK), tblAdminConfig E        
  WHERE     
  A.FLDSTATUS = E.Fldadmin        
  AND UPPER(FLDSTATUS) = RTRIM(LTRIM(UPPER(@ADMIN_USER)))      
  ORDER BY       
   FLDAUTO_ADMIN       
  END      
ELSE      
 BEGIN   
 print 'asd'  
 SELECT    
    SRNO = FLDAUTO_ADMIN,        
    FLDNAME,       
    FLDSTATUS,       
    FLDAUTO_ADMIN,       
    FLDCOMPANY,       
    FLDDESC       
   FROM       
   TBLADMIN A (NOLOCK), tblAdminConfig E        
   WHERE     
   A.FLDSTATUS = E.Fldadmin        
END

GO
