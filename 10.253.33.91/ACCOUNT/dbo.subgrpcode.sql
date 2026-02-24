-- Object: PROCEDURE dbo.subgrpcode
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.subgrpcode    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.subgrpcode    Script Date: 11/28/2001 12:23:53 PM ******/

/****** Object:  Stored Procedure dbo.subgrpcode    Script Date: 29-Sep-01 8:12:08 PM ******/

/****** Object:  Stored Procedure dbo.subgrpcode    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.subgrpcode    Script Date: 8/7/01 6:03:53 PM ******/

/****** Object:  Stored Procedure dbo.subgrpcode    Script Date: 7/8/01 3:22:51 PM ******/

/****** Object:  Stored Procedure dbo.subgrpcode    Script Date: 2/17/01 3:34:19 PM ******/


/****** Object:  Stored Procedure dbo.subgrpcode    Script Date: 20-Mar-01 11:43:36 PM ******/

/****** Object:  Stored Procedure dbo.subgrpcode    Script Date: 12/18/99 8:23:21 AM ******/
CREATE PROCEDURE subgrpcode 
@tempgrpcode  varchar(13)
AS
select grpname , grpcode from grpmast where grpcode like @tempgrpcode
order by grpcode

GO
