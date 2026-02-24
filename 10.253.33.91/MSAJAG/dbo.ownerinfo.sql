-- Object: PROCEDURE dbo.ownerinfo
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create proc ownerinfo as
select company_name= isnull(Company,0),o_address1=isnull( Addr1 ,0),o_address2=isnull( Addr2,0),
o_city=isnull(city,0) ,o_zip = isnull(zip,0),o_phone = isnull(Phone,0)
from owner

GO
