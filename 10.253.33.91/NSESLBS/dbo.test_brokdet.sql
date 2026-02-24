-- Object: PROCEDURE dbo.test_brokdet
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE proc test_brokdet 

@clcode varchar(20)
as
select top 25  * from client2 where cl_code like @clcode
select * from broktable where table_no in (select table_no from client2 where cl_code like @clcode)
select * from broktable where table_no in (select sub_tableno from client2 where cl_code like @clcode)

GO
