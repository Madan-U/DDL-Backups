-- Object: PROCEDURE dbo.rpt_nsebankid1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_nsebankid1    Script Date: 04/27/2001 4:32:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nsebankid1    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nsebankid1    Script Date: 20-Mar-01 11:39:01 PM ******/





/****** Object:  Stored Procedure dbo.rpt_nsebankid1    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_nsebankid1    Script Date: 12/27/00 8:58:56 PM ******/

/* report : client details
 file : dpreport.asp **/
CREATE PROCEDURE
 rpt_nsebankid1
@bankid varchar(12)
AS
select bankname from bank where bankid = @bankid

GO
