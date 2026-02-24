-- Object: PROCEDURE dbo.partymtom
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.partymtom    Script Date: 3/17/01 9:55:54 PM ******/

/****** Object:  Stored Procedure dbo.partymtom    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.partymtom    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.partymtom    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.partymtom    Script Date: 12/27/00 8:58:52 PM ******/

/****** Object:  Stored Procedure dbo.partymtom    Script Date: 12/18/99 8:24:05 AM ******/
CREATE Procedure partymtom as
     select distinct short_name from trademtom 
     union 
     select distinct short_name from settmtom
 order by short_name

GO
