-- Object: PROCEDURE dbo.settlementtypespp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.settlementtypespp    Script Date: 3/17/01 9:56:10 PM ******/

/****** Object:  Stored Procedure dbo.settlementtypespp    Script Date: 3/21/01 12:50:30 PM ******/

/****** Object:  Stored Procedure dbo.settlementtypespp    Script Date: 20-Mar-01 11:39:09 PM ******/

/****** Object:  Stored Procedure dbo.settlementtypespp    Script Date: 2/5/01 12:06:28 PM ******/

/****** Object:  Stored Procedure dbo.settlementtypespp    Script Date: 12/27/00 8:59:03 PM ******/

CREATE PROCEDURE settlementtypespp 
@settno varchar(3)
 AS
select distinct sett_type from settlement  
union 
 select distinct sett_type from history  
where sett_no like @settno
 order by sett_type

GO
