-- Object: PROCEDURE dbo.V2_CHECKBLOCKEDREPORTS
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE V2_CHECKBLOCKEDREPORTS
                @RPTPATH VARCHAR(100)
                
AS

  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED
  
  SET NOCOUNT ON
        
  IF (SELECT COUNT(1)
      FROM   TBLREPORTS_BLOCKED WITH (NOLOCK)
      WHERE  BLOCK_FLAG = 1
             AND LTRIM(RTRIM(FLDPATH)) = left(LTRIM(RTRIM(@RPTPATH)),len(FLDPATH))) > 0 
  BEGIN 
    SELECT '<font color = red><b>This Option has been disabled temporarily!! Please contact System Administrator!!</b></font>'
  END 
  ELSE 
  BEGIN 
    SELECT '' 
  END

GO
