-- Object: PROCEDURE dbo.rname
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

create procedure rname
@fldreportname nvarchar (100)
as
select * from tblreports where fldreportname like '%'+@fldreportname+'%'

GO
