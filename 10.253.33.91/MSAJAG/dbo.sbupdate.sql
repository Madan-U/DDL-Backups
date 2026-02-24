-- Object: PROCEDURE dbo.sbupdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbupdate    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbupdate    Script Date: 3/21/01 12:50:29 PM ******/

/****** Object:  Stored Procedure dbo.sbupdate    Script Date: 20-Mar-01 11:39:08 PM ******/

/****** Object:  Stored Procedure dbo.sbupdate    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.sbupdate    Script Date: 12/27/00 8:59:16 PM ******/

CREATE PROCEDURE sbupdate
@subbroker varchar(15),
@newpsw varchar(15)
AS
update subbrokadmin 
set password = @newpsw
where subbrokname = @subbroker

GO
