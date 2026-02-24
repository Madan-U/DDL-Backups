-- Object: PROCEDURE dbo.SpSettBillHeader
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpSettBillHeader    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.SpSettBillHeader    Script Date: 3/21/01 12:50:31 PM ******/

/****** Object:  Stored Procedure dbo.SpSettBillHeader    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.SpSettBillHeader    Script Date: 2/5/01 12:06:29 PM ******/

/****** Object:  Stored Procedure dbo.SpSettBillHeader    Script Date: 12/27/00 8:59:04 PM ******/

CREATE proc SpSettBillHeader (@Sett_No varchar(10), @Sett_Type varchar(2),@party varchar(10)) as
select distinct settlement.party_code,short_name= isnull(client1.short_name,0),settlement.contractno,sett_no = @sett_no,
settlement.sett_type, 
start_date = ( case when @sett_type = 'L' then ( select Max(Start_Date) from  sett_mst where  sett_no < @sett_no and sett_type = 'N') else Start_date end ),
end_date = ( case when @sett_type = 'L' then ( select Max(end_Date) from  sett_mst where  sett_no < @sett_no and sett_type = 'N') else end_date end ),
l_address1=isnull(client1.l_address1,0),l_address2=isnull(client1.l_address2,0),l_address3=isnull(client1.l_address3,0),l_city=isnull(client1.l_city,0) ,l_zip = isnull(client1.l_zip,0)/*l_zip = added by bhagyashree*/
from settlement, client1,client2, sett_mst
where client1.cl_code = client2.cl_code 
and client2.party_code = client2.party_code
and settlement.party_code = client2.party_code
and settlement.sett_no = sett_mst.sett_no
and settlement.sett_type = sett_mst.sett_Type
and settlement.sett_no = @Sett_No
and settlement.sett_type = @sett_type
and settlement.party_code = @party
and client2.printf = 0

GO
