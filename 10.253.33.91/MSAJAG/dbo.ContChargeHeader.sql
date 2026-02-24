-- Object: PROCEDURE dbo.ContChargeHeader
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ContChargeHeader    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.ContChargeHeader    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.ContChargeHeader    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.ContChargeHeader    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.ContChargeHeader    Script Date: 12/27/00 8:58:48 PM ******/

CREATE proc ContChargeHeader (@Party varchar(10)) as
select distinct Party_Code = @party, client1.short_name,
l_address1 = isnull(client1.l_address1,""),
l_address2 = isnull(client1.l_address2,""),
l_address3 =  isnull(client1.l_address3,""),
l_City = isnull(client1.l_city,""),
l_Zip = isnull(client1.l_zip,"")
from client1,client2
where client1.cl_code = client2.cl_code 
and client2.party_code = @Party
 union
select distinct @party,client1.short_name,
l_address1 = isnull(client1.l_address1,""),
l_address2 = isnull(client1.l_address2,""),
l_address3 =  isnull(client1.l_address3,""),
l_City = isnull(client1.l_city,""),
l_Zip = isnull(client1.l_zip,"")
from client1,client2
where client1.cl_code = client2.cl_code 
and client2.party_code =  @Party

GO
