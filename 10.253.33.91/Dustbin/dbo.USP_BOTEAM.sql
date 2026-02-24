-- Object: PROCEDURE dbo.USP_BOTEAM
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

  
CREATE PROC USP_BOTEAM (@NAME VARCHAR (20))    
AS    
BEGIN    
    
SELECT * FROM BOTEAM WHERE NAME LIKE '%'+@NAME+'%'
    
END

GO
