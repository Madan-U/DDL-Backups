-- Object: PROCEDURE dbo.sblogin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sblogin    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sblogin    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.sblogin    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sblogin    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sblogin    Script Date: 12/27/00 8:59:15 PM ******/

CREATE PROCEDURE sblogin
@subbroker varchar(15),
@psw varchar(15)
AS
select * 
from subbrokadmin 
where subbrokname = @subbroker 
and password =@psw

GO
