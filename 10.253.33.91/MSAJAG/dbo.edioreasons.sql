-- Object: PROCEDURE dbo.edioreasons
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.edioreasons    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.edioreasons    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.edioreasons    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.edioreasons    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.edioreasons    Script Date: 12/27/00 8:59:07 PM ******/

/****** Object:  Stored Procedure dbo.edioreasons    Script Date: 12/18/99 8:24:09 AM ******/
create procedure edioreasons
@res_code varchar(3),
@reason varchar(25),
@code varchar(3) OUTPUT AS
update ioreasons
Set 
res_code = @res_code,
reason = @reason
where 
  res_code = @res_code
Select res_code from ioreasons where res_code like @res_code

GO
