-- Object: PROCEDURE dbo.bankdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.bankdate    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.bankdate    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.bankdate    Script Date: 20-Mar-01 11:38:43 PM ******/

/****** Object:  Stored Procedure dbo.bankdate    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.bankdate    Script Date: 12/27/00 8:59:05 PM ******/

CREATE PROCEDURE bankdate
@settno varchar(7),
@settype varchar(3)
as
select bankdate=convert(varchar,max(date),103) from dematdelivery where sett_no=@settno  and sett_type=@settype

GO
