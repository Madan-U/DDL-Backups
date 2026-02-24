-- Object: PROCEDURE dbo.AniBillHeader
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.AniBillHeader    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.AniBillHeader    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.AniBillHeader    Script Date: 20-Mar-01 11:38:42 PM ******/

/****** Object:  Stored Procedure dbo.AniBillHeader    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.AniBillHeader    Script Date: 12/27/00 8:58:43 PM ******/

CREATE proc AniBillHeader (@Sett_No varchar(7), @Sett_Type varchar(2),@party varchar(10)) as
select distinct client2.party_code,short_name= isnull(client1.short_name,0),s.sett_no,
s.sett_type, start_date,end_date,l_address1=isnull(client1.l_address1,0),l_address2=isnull(client1.l_address2,0),l_address3=isnull(client1.l_address3,0),l_city=isnull(client1.l_city,0) ,l_zip = isnull(client1.l_zip,0)
from client1,client2, sett_mst s
where client1.cl_code = client2.cl_code 
and s.sett_no = @Sett_No
and s.sett_type = @sett_type
and client2.party_code = @party
and client2.printf = 0

GO
