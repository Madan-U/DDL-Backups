-- Object: PROCEDURE dbo.rpath
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

create procedure rpath
@fldpath nvarchar (200)
as
select * from tblreports where fldpath like '%'+@fldpath+'%'

GO
