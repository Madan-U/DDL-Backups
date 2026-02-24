-- Object: PROCEDURE dbo.abhitest
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

create procedure abhitest
(
@pass varchar(20) 
)
as

declare @temp varchar(2000)
 
select @temp= PRADNYA.dbo.CLASS_PWDENCRY(@pass)

print @temp

GO
