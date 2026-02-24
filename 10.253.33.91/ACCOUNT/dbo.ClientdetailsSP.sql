-- Object: PROCEDURE dbo.ClientdetailsSP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ClientdetailsSP    Script Date: 01/04/1980 1:40:36 AM ******/



/****** Object:  Stored Procedure dbo.ClientdetailsSP    Script Date: 11/28/2001 12:23:42 PM ******/

/****** Object:  Stored Procedure dbo.ClientdetailsSP    Script Date: 29-Sep-01 8:12:03 PM ******/

/****** Object:  Stored Procedure dbo.ClientdetailsSP    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.ClientdetailsSP    Script Date: 8/7/01 6:03:48 PM ******/

/****** Object:  Stored Procedure dbo.ClientdetailsSP    Script Date: 07/24/2001 11:35:22 AM ******/
Create Proc ClientdetailsSP 
@cltcode varchar(10)

AS

select taddr1= isnull(l_address1,'') , taddr2= isnull(l_address2 ,''), tcity =isnull(l_city ,''),tzip= isnull(l_zip ,'') 
from MSAJAG.DBO.client1 c1, MSAJAG.DBO.client2 c2 
where  c1.cl_code=c2.cl_code and c2.party_code= @cltcode

GO
