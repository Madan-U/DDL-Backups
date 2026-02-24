-- Object: PROCEDURE dbo.edsett_type
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.edsett_type    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.edsett_type    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.edsett_type    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.edsett_type    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.edsett_type    Script Date: 12/27/00 8:59:07 PM ******/

/****** Object:  Stored Procedure dbo.edsett_type    Script Date: 12/18/99 8:24:09 AM ******/
create procedure edsett_type
@exchange varchar(3),
@Sett_type varchar(5),
@Description varchar(25),
@code varchar(3) OUTPUT ,
@set_in varchar(5) OUTPUT ,
@desc varchar(25) OUTPUT AS
update sett_type
Set 
exchange = @exchange ,
sett_type = @sett_type , 
description = @description
where 
  exchange = @exchange and
  sett_type = @sett_type
  Select * from sett_type where sett_type like @sett_type and exchange like @exchange

GO
