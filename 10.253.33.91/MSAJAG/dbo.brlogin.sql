-- Object: PROCEDURE dbo.brlogin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brlogin    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brlogin    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brlogin    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brlogin    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brlogin    Script Date: 12/27/00 8:59:06 PM ******/

CREATE PROCEDURE brlogin
@br varchar(3),
@psw varchar(15)
AS
select * 
from bradmin 
where branch_cd = @br 
and password =@psw

GO
