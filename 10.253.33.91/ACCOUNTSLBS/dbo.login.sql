-- Object: PROCEDURE dbo.login
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

create Procedure login
@fldusername varchar (25)
as
select Fldusername ,fldpassword from tblpradnyausers 
where Fldusername like '%'+@fldusername+'%'

GO
