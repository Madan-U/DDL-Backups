-- Object: PROCEDURE dbo.BillHeaderDel
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BillHeaderDel    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.BillHeaderDel    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.BillHeaderDel    Script Date: 20-Mar-01 11:38:43 PM ******/

CREATE proc BillHeaderDel (@Sett_No varchar(10), @Sett_Type varchar(2),@party varchar(10)) as
/*select distinct D.party_code,short_name= isnull(client1.short_name,0),D.sett_no,
D.sett_type,Start_date,End_date,l_address1=isnull(client1.l_address1,0),l_address2=isnull(client1.l_address2,0),
l_address3=isnull(client1.l_address3,0),l_city=isnull(client1.l_city,0) ,l_zip = isnull(client1.l_zip,0)
from DeliveryClt D, client1,client2, sett_mst
where client1.cl_code = client2.cl_code 
and client2.party_code = client2.party_code
and D.party_code = client2.party_code
and D.sett_no = sett_mst.sett_no
and D.sett_type = sett_mst.sett_Type
and D.sett_no = @Sett_No
and D.sett_type = @sett_type
and D.party_code = @party
and client2.printf = 0
*/
select distinct D.party_code,short_name= isnull(client1.short_name,0),D.sett_no,
D.sett_type,Start_date,End_date,l_address1=isnull(client1.l_address1,0),l_address2=isnull(client1.l_address2,0),
l_address3=isnull(client1.l_address3,0),l_city=isnull(client1.l_city,0) ,l_zip = isnull(client1.l_zip,0),Email = isnull(client1.Email,0)
from Settlement D, client1,client2, sett_mst
where client1.cl_code = client2.cl_code 
and client2.party_code = client2.party_code
and D.party_code = client2.party_code
and D.sett_no = sett_mst.sett_no
and D.sett_type = sett_mst.sett_Type
and D.sett_no = @Sett_No
and D.sett_type = @sett_type
and D.party_code = @party
and client2.printf = 0

GO
