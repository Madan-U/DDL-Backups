-- Object: PROCEDURE dbo.selbroktable
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.selbroktable    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.selbroktable    Script Date: 3/21/01 12:50:29 PM ******/

/****** Object:  Stored Procedure dbo.selbroktable    Script Date: 20-Mar-01 11:39:08 PM ******/

/****** Object:  Stored Procedure dbo.selbroktable    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.selbroktable    Script Date: 12/27/00 8:59:02 PM ******/

/****** Object:  Stored Procedure dbo.selbroktable    Script Date: 12/18/99 8:24:10 AM ******/
create procedure selbroktable
@tablename varchar(30)
as
select * from broktable 
where Table_name like @tablename order by table_name

GO
