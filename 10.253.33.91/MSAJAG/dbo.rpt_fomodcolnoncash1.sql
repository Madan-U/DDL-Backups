-- Object: PROCEDURE dbo.rpt_fomodcolnoncash1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomodcolnoncash1    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodcolnoncash1    Script Date: 5/7/2001 9:02:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodcolnoncash1    Script Date: 5/5/2001 2:43:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodcolnoncash1    Script Date: 5/5/2001 1:24:14 PM ******/
CREATE PROCEDURE rpt_fomodcolnoncash1

@code varchar(10),
@sdate varchar(12)

AS

select * from focashcomposition
where party_code = @code
and exchange = 'NSE'
and markeTtype like 'FUT%'
and effdate = (select max(effdate) from focashcomposition
	       where party_code = @code
	       and exchange = 'NSE'
	       and markeTtype like 'FUT%'
	       and effdate <= @sdate)

GO
