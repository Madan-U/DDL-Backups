-- Object: PROCEDURE dbo.proc_acc_GetCompanyName
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


/****** Object:  Stored Procedure dbo.proc_acc_GetCompanyName    Script Date: 5/18/04 1:04:54 PM ******/  
  
CREATE  PROCEDURE proc_acc_GetCompanyName  
 @AccoundDBName VarChar (50)  
AS  
  
SELECT * FROM  
 pradnya.dbo.multicompany  
  
WHERE  
 accountdb = @AccoundDBName AND  
 primaryserver = 1  
  
ORDER BY  
 companyname

GO
