-- Object: PROCEDURE dbo.trademtom10
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.trademtom10    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.trademtom10    Script Date: 3/21/01 12:50:33 PM ******/

/****** Object:  Stored Procedure dbo.trademtom10    Script Date: 20-Mar-01 11:39:11 PM ******/

/****** Object:  Stored Procedure dbo.trademtom10    Script Date: 2/5/01 12:06:30 PM ******/

/****** Object:  Stored Procedure dbo.trademtom10    Script Date: 12/27/00 8:59:05 PM ******/

/****** Object:  Stored Procedure dbo.trademtom10    Script Date: 12/18/99 8:24:14 AM ******/
create Procedure trademtom10 as
 set rowcount 10
     select * from trademtom 
     union 
     select * from settmtom

GO
