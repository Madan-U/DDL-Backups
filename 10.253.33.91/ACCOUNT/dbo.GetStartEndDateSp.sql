-- Object: PROCEDURE dbo.GetStartEndDateSp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.GetStartEndDateSp    Script Date: 02/22/2002 1:56:05 PM ******/

/****** Object:  Stored Procedure dbo.GetStartEndDateSp    Script Date: 01/24/2002 12:11:43 PM ******/

/****** Object:  Stored Procedure dbo.GetStartEndDateSp    Script Date: 11/28/2001 12:23:44 PM ******/

/****** Object:  Stored Procedure dbo.GetStartEndDateSp    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.GetStartEndDateSp    Script Date: 09/21/2001 2:39:21 AM ******/


/****** Object:  Stored Procedure dbo.GetStartEndDateSp    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.GetStartEndDateSp    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.GetStartEndDateSp    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.GetStartEndDateSp    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.GetStartEndDateSp    Script Date: 20-Mar-01 11:43:33 PM ******/

/*This procedure is used to get the start and end date of the current financial year from parameter table
The record with curyear = 1 is the current year record
The date is retrieved in dd/mm/yyyy format*/
create proc GetStartEndDateSp as
select convert(varchar,sdtcur,103)sdtcur,convert(varchar,ldtcur,103)ldtcur from parameter where curyear = 1

GO
