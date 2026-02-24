-- Object: PROCEDURE dbo.albrates
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.albrates    Script Date: 3/17/01 9:55:43 PM ******/

/****** Object:  Stored Procedure dbo.albrates    Script Date: 3/21/01 12:49:59 PM ******/

/****** Object:  Stored Procedure dbo.albrates    Script Date: 20-Mar-01 11:38:42 PM ******/

/****** Object:  Stored Procedure dbo.albrates    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.albrates    Script Date: 12/27/00 8:58:42 PM ******/

CREATE PROCEDURE albrates
@settno varchar(7),
@settype varchar(3),
@scripcd varchar(15)
AS
select rate from albmrate 
where sett_no=@settno
and sett_type=@settype
and scrip_Cd=@scripcd

GO
