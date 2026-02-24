-- Object: PROCEDURE dbo.edtranscat
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.edtranscat    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.edtranscat    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.edtranscat    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.edtranscat    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.edtranscat    Script Date: 12/27/00 8:58:49 PM ******/

/****** Object:  Stored Procedure dbo.edtranscat    Script Date: 12/18/99 8:24:09 AM ******/
create procedure edtranscat
@trans_cat varchar(3),
@category varchar(25),
@code varchar(3) OUTPUT,
@desc varchar(30) OUTPUT  AS
update transcat
Set 
@trans_cat = @trans_cat ,
@category = @category
where 
  trans_cat = @trans_cat
Select * from transcat where trans_cat like @trans_cat

GO
