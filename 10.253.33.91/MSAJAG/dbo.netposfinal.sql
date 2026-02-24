-- Object: PROCEDURE dbo.netposfinal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.netposfinal    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.netposfinal    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.netposfinal    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.netposfinal    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.netposfinal    Script Date: 12/27/00 8:58:51 PM ******/

/****** Object:  Stored Procedure dbo.netposfinal    Script Date: 12/18/99 8:24:13 AM ******/
CREATE PROCEDURE netposfinal
(@date varchar(10),@party_code varchar(15) )
 AS
select * from NETTRADEview where party_code like @party_code and convert(varchar,sdate,103) like @DATE
union
select * from NETSETTview where party_code like @party_code and convert(varchar,sdate,103) like @DATE
union
select * from NEThisTview where party_code like @party_code and convert(varchar,sdate,103) like @DATE

GO
