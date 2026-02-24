-- Object: PROCEDURE dbo.settlementtypespp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.settlementtypespp    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.settlementtypespp    Script Date: 11/28/2001 12:23:52 PM ******/

/****** Object:  Stored Procedure dbo.settlementtypespp    Script Date: 29-Sep-01 8:12:07 PM ******/

/****** Object:  Stored Procedure dbo.settlementtypespp    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.settlementtypespp    Script Date: 8/7/01 6:03:53 PM ******/

/****** Object:  Stored Procedure dbo.settlementtypespp    Script Date: 7/8/01 3:22:51 PM ******/

/****** Object:  Stored Procedure dbo.settlementtypespp    Script Date: 2/17/01 3:34:19 PM ******/


/****** Object:  Stored Procedure dbo.settlementtypespp    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE settlementtypespp 
@settno varchar(3)
 AS
select distinct sett_type from MSAJAG.DBO.settlement  
union 
 select distinct sett_type from MSAJAG.DBO.history  
where sett_no like @settno
 order by sett_type

GO
