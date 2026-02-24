-- Object: PROCEDURE dbo.allocdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.allocdate    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.allocdate    Script Date: 3/21/01 12:49:59 PM ******/

/****** Object:  Stored Procedure dbo.allocdate    Script Date: 20-Mar-01 11:38:42 PM ******/

/****** Object:  Stored Procedure dbo.allocdate    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.allocdate    Script Date: 12/27/00 8:58:42 PM ******/

CREATE PROCEDURE  allocdate
@settno varchar(7),
@settype varchar(3)
as
select allocdate=convert(varchar,max(date),103) from certinfo where sett_no=@settno  and sett_type=@settype
and targetparty <> '1'

GO
