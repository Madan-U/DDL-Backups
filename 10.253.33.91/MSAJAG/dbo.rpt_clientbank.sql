-- Object: PROCEDURE dbo.rpt_clientbank
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_clientbank    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clientbank    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clientbank    Script Date: 20-Mar-01 11:38:54 PM ******/





/****** Object:  Stored Procedure dbo.rpt_clientbank    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clientbank    Script Date: 12/27/00 8:58:54 PM ******/

/* report : client details
file :clientdetail.asp
*/
CREATE PROCEDURE rpt_clientbank
@bankid varchar(12)
AS
select bankname from bank where bankid = @bankid

GO
