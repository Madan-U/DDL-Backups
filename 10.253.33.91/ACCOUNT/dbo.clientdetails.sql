-- Object: PROCEDURE dbo.clientdetails
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.clientdetails    Script Date: 01/04/1980 1:40:36 AM ******/



/****** Object:  Stored Procedure dbo.clientdetails    Script Date: 11/28/2001 12:23:42 PM ******/

/****** Object:  Stored Procedure dbo.clientdetails    Script Date: 29-Sep-01 8:12:03 PM ******/

/****** Object:  Stored Procedure dbo.clientdetails    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.clientdetails    Script Date: 8/7/01 6:03:48 PM ******/

/****** Object:  Stored Procedure dbo.clientdetails    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.clientdetails    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.clientdetails    Script Date: 20-Mar-01 11:43:32 PM ******/

CREATE PROCEDURE clientdetails
@clcode varchar(6)
AS
select c1.Res_Phone1,Off_Phone1, c1.short_name,c2.tran_cat from MSAJAG.DBO.client1
c1,MSAJAG.DBO.client2 c2 
where c1.cl_code=@clcode and c2.cl_code=@clcode

GO
