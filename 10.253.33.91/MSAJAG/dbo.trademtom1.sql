-- Object: PROCEDURE dbo.trademtom1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.trademtom1    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.trademtom1    Script Date: 3/21/01 12:50:33 PM ******/

/****** Object:  Stored Procedure dbo.trademtom1    Script Date: 20-Mar-01 11:39:11 PM ******/

/****** Object:  Stored Procedure dbo.trademtom1    Script Date: 2/5/01 12:06:30 PM ******/

/****** Object:  Stored Procedure dbo.trademtom1    Script Date: 12/27/00 8:59:05 PM ******/

/****** Object:  Stored Procedure dbo.trademtom1    Script Date: 12/18/99 8:24:06 AM ******/
CREATE Procedure trademtom1 (@short_name varchar(20),@partycode varchar(10)) as
     select * from trademtom WHERE short_name like @short_name  and party_code like @partycode 
     union 
     select * from settmtom WHERE short_name like @short_name and party_code like @partycode

GO
