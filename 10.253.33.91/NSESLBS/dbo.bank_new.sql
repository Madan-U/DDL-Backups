-- Object: PROCEDURE dbo.bank_new
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

create proc bank_new 
as 
begin insert into dbo.emp(username,password) values('pratik1','456789')
end

GO
