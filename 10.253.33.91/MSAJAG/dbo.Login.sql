-- Object: PROCEDURE dbo.Login
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc Login    
(@name Varchar(20))  
as    
Select * from Tblpradnyausers with (nolock) Where fldusername like '%' + @name + '%'  and
fldusername <> fldstname
union   
Select * from Tblpradnyausers with (nolock) Where fldfirstname like '%' + @name + '%' and
fldusername <> fldstname

GO
