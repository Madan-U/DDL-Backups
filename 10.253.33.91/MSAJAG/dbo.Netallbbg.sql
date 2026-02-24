-- Object: PROCEDURE dbo.Netallbbg
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.Netallbbg    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.Netallbbg    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.Netallbbg    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.Netallbbg    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.Netallbbg    Script Date: 12/27/00 8:59:08 PM ******/

/****** Object:  Stored Procedure dbo.Netallbbg    Script Date: 12/18/99 8:24:13 AM ******/
CREATE PROCEDURE Netallbbg (@sett_no varchar(10), @sett_type varchar(3)) As
exec nettradeasp @sett_no,@sett_type
exec netsettasp @sett_no,@sett_type
exec nethistoryasp @sett_no,@sett_type

GO
